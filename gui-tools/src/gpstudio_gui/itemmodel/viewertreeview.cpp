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

#include "viewertreeview.h"

#include <QDebug>
#include <QMimeData>

#include "camera/camera.h"
#include "model/model_viewerflow.h"

ViewerTreeView::ViewerTreeView()
{
    _model = new CameraItemModel(this);
    _modelSorted = new QSortFilterProxyModel(this);
    _modelSorted->setSourceModel(_model);
    setModel(_modelSorted);
}

void ViewerTreeView::attachProject(GPNodeProject *project)
{
    _project = project;
    _model->setViewer(_project->node()->gpViewer());

    connect(_project, SIGNAL(viewerAdded(ModelViewer*)), _model, SLOT(addViewer(ModelViewer*)));
    connect(_project, SIGNAL(viewerRemoved(QString)), _model, SLOT(removeViewer(QString)));
}

GPNodeProject *ViewerTreeView::project() const
{
    return _project;
}

void ViewerTreeView::setCamera(Camera *camera)
{
    _camera = camera;
    _model->setViewer(_camera->node()->gpViewer());
}

Camera *ViewerTreeView::camera() const
{
    return _camera;
}

void ViewerTreeView::dragEnterEvent(QDragEnterEvent *event)
{
    QTreeView::dragEnterEvent(event);

    if(event->mimeData()->hasFormat("flow/flowid"))
        event->accept();
}

void ViewerTreeView::dragMoveEvent(QDragMoveEvent *event)
{
    QTreeView::dragMoveEvent(event);

    if(event->mimeData()->hasFormat("flow/flowid"))
        event->accept();
}

void ViewerTreeView::dropEvent(QDropEvent *event)
{
    QTreeView::dropEvent(event);

    QString flow = event->mimeData()->data("flow/flowid");
    qDebug()<<Q_FUNC_INFO<<flow<<selectedIndexes();

    // viewerAdded
    // viewerFlowAdded
}

void ViewerTreeView::keyPressEvent(QKeyEvent *event)
{
    if(event->key()==Qt::Key_Delete || event->key()==Qt::Key_Backspace)
    {
        if(!currentIndex().isValid())
            return;
        const ModelViewer *viewer = _model->viewer(_modelSorted->mapToSource(currentIndex()));
        if(viewer)
        {
            emit viewerDeleted(viewer->name());
            return;
        }
        const ModelViewerFlow *viewerFlow = _model->viewerFlow(_modelSorted->mapToSource(currentIndex()));
        if(viewerFlow)
        {
            emit viewerDeleted(viewerFlow->flowName());
            return;
        }
    }
    QTreeView::keyPressEvent(event);
}

#ifndef QT_NO_CONTEXTMENU
void ViewerTreeView::contextMenuEvent(QContextMenuEvent *event)
{
    /*QModelIndex index = indexAt(event->pos());
    if(!index.isValid())
        return;
    const BlockLib *proc = _model->blockLib(index);
    if(!proc)
        return;*/

    /*QMenu menu;
    QAction *infosIPAction = menu.addAction("View implementation files");
    QAction *docIPAction = menu.addAction("View pdf documentation");
    if(docFile.isEmpty())
        docIPAction->setEnabled(false);
    QAction *trigered = menu.exec(event->globalPos());
    if(trigered == docIPAction)
        PdfViewer::showDocument(docFile.first());*/
}
#endif // QT_NO_CONTEXTMENU
