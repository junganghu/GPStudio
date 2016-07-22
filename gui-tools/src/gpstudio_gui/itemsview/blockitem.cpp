/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "blockconnectoritem.h"
#include "blockitem.h"
#include "blockportitem.h"

#include <QPainter>
#include <QDebug>

#include "blockconnectoritem.h"

#include "lib_parser/lib.h"

#include <QGraphicsScene>
#include <QGraphicsProxyWidget>
#include <QCheckBox>
#include <QSlider>

#include <model/model_block.h>
#include <camera/block.h>

#include "propertywidgets/propertywidgets.h"

BlockItem::BlockItem()
{
    _block = NULL;

    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);
    setFlag(ItemSendsScenePositionChanges, true);

    update();
}

BlockItem::~BlockItem()
{
}

int BlockItem::type() const
{
    return Type;
}

QRectF BlockItem::boundingRect() const
{
    return _boundingRect.adjusted(-2,-2,2,15);
}

void BlockItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option); Q_UNUSED(widget);

    if(isSelected())
        painter->setPen(QPen(QColor("orange"), 3));
    else
        painter->setPen(QPen(Qt::black, 1));

    if(_svgRenderer.isValid())
    {
        _svgRenderer.render(painter, _svgRenderer.viewBox());
        painter->drawRect(_svgRenderer.viewBox());
    }
    else
    {
        painter->drawRect(QRect(0,0,125,50));
    }

    // block name
    painter->setPen(QPen(Qt::black, 1));
    QRectF textRect = QRectF(_boundingRect.x(), _boundingRect.height(), _boundingRect.width(), 15);
    painter->drawText(textRect, Qt::AlignRight | Qt::AlignBottom, _name);
}

QString BlockItem::processName() const
{
    return _processName;
}

void BlockItem::setProcessName(const QString &processName)
{
    _processName = processName;
}

QString BlockItem::name() const
{
    return _name;
}

void BlockItem::setName(const QString &name)
{
    _name = name;
}

Block *BlockItem::block() const
{
    return _block;
}

void BlockItem::updateBlock()
{
    if(_svgRenderer.isValid())
    {
        _boundingRect = _svgRenderer.viewBoxF();
    }
    else
    {
        _boundingRect = QRectF(0,0,125,50);
    }

    // port placement
    int inCount=0, outCount=0;
    foreach (BlockPortItem *portItem, _ports)
    {
        if(portItem->direction()==BlockPortItem::Output)
            outCount++;
        else
            inCount++;
    }
    int inId=0, outId=0;
    foreach (BlockPortItem *portItem, _ports)
    {
        if(portItem->direction()==BlockPortItem::Output)
            portItem->setPos(_boundingRect.width(), (_boundingRect.height()/(outCount+1))*(++outId));
        else
            portItem->setPos(0, (_boundingRect.height()/(inCount+1))*(++inId));
    }
}

void BlockItem::updatePos()
{
    setPos(_modelBlock->pos());
    foreach (BlockPortItem *portItem, _ports)
    {
        foreach (BlockConnectorItem *connectItem, portItem->connects())
        {
            connectItem->updateShape();
        }
    }
}

void BlockItem::addPort(BlockPortItem *portItem)
{
    portItem->setParentItem(this);
    _ports.insert(portItem->name(), portItem);
}

BlockPortItem *BlockItem::port(const QString &name) const
{
    QMap<QString, BlockPortItem* >::const_iterator it = _ports.find(name);
    if(it != _ports.end())
        return it.value();
    return NULL;
}

const QMap<QString, BlockPortItem *> &BlockItem::ports() const
{
    return _ports;
}

QVariant BlockItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemPositionChange && scene())
    {
        foreach (BlockPortItem *portItem, _ports)
        {
            foreach (BlockConnectorItem *connectItem, portItem->connects())
            {
                connectItem->updateShape();
            }
        }
    }
    return QGraphicsItem::itemChange(change, value);
}

ModelBlock *BlockItem::modelBlock() const
{
    return _modelBlock;
}

BlockItem *BlockItem::fromBlockLib(const BlockLib *processLib, BlockItem *item)
{
    if(!processLib)
        return NULL;

    if(!item)
        item = new BlockItem();

    item->_svgRenderer.load(processLib->draw().toUtf8());
    item->setName(processLib->name());
    item->updateBlock();

    return item;
}

BlockItem *BlockItem::fromModelBlock(ModelBlock *modelBlock, BlockItem *item)
{
    if(!modelBlock)
        return NULL;

    BlockLib *blockLib;
    if(modelBlock->type()=="process")
        blockLib = Lib::getLib().process(modelBlock->driver());
    else
        blockLib = Lib::getLib().io(modelBlock->driver());
    item = fromBlockLib(blockLib);

    if(!item)
        item = new BlockItem();

    if(blockLib)
    foreach (ModelFlow *flow, blockLib->modelProcess()->flows())
    {
        item->addPort(BlockPortItem::fromModelFlow(flow));
    }

    item->setPos(modelBlock->pos());
    item->setName(modelBlock->name());

    item->_modelBlock = modelBlock;

    item->updateBlock();

    return item;
}

BlockItem *BlockItem::fromBlock(Block *block, BlockItem *item)
{
    if(!item)
        item = BlockItem::fromModelBlock(block->modelBlock());

    Property *propertyEnable = NULL;
    propertyEnable = block->assocProperty()->path("enable");
    if(propertyEnable)
    {
        QWidget *propertyEnableWidget = PropertyWidget::getWidgetFromProperty(propertyEnable);
        QGraphicsProxyWidget *proxy = new QGraphicsProxyWidget(item);
        propertyEnableWidget->setGeometry(5,5,50,20);
        propertyEnableWidget->setAttribute(Qt::WA_NoSystemBackground);
        proxy->setWidget(propertyEnableWidget);
    }

    item->_block = block;

    return item;
}
