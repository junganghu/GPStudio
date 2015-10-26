<?php

define("LIB_PATH", realpath(dirname(__FILE__)."/..").DIRECTORY_SEPARATOR);
define("SUPPORT_PATH", LIB_PATH . "support" . DIRECTORY_SEPARATOR);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH);
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'model');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'scripts'.DIRECTORY_SEPARATOR.'system_interconnect');
set_include_path(get_include_path().PATH_SEPARATOR.LIB_PATH.DIRECTORY_SEPARATOR.'support');

require_once("node.php");
require_once("gpstudio.php");

$options = getopt("a:");
if(array_key_exists('a',$options)) $action = $options['a']; else error("You should specify an action with -a"."\n",1);

// new project creation
if($action=="newproject")
{
	$options = getopt("a:n:");
	if(array_key_exists('n',$options)) $project=$options['n']; else error("You should specify a project name with -n"."\n",1);
	
	$node = new Node();
	$node->name=$project;
	$project.=".node";
}
else
{
	$project=findproject();
	if(!file_exists($project))
	{
		if(strpos($action, "list")===false) error("Cannot find a valid project in the current directory.",1);
	}
	
	$node = new Node($project);
}

$save = true;

// process action, pre config
switch($action)
{
	// =========================== global commands =========================== 
	case "-h":
	case "--help":
		echo "# gpnode command line tool to manage a gpstudio node (v1.0)"."\n";
		echo ""."\n";
		echo "# project"."\n";
		echo "gpnode newproject -n <project-name>		# create a directory named <project-name> with a project file inside named <project-name>.node"."\n";
		echo "gpnode setboard -n <board-name>		# specify the name of the used board for the node"."\n";
		echo "gpnode generate [-o <dir>]		# generate all files needed for the specified toolchain and Makefile"."\n";
		echo ""."\n";
		echo "# io"."\n";
		echo "gpnode addio -n <io-name>		# add IP support in the project to manage <io-name>. <io-name> must be define in the board file definition"."\n";
		echo "gpnode delio -n <io-name>		# remove io support"."\n";
		echo "gpnode showio		# print the list of io support in the current project"."\n";
		echo ""."\n";
		echo "# process"."\n";
		echo "gpnode addprocess -n <process-name> -d <driver-name>		# add a process named <process-name> as an instance of <driver-name> IP in the library or the project dir."."\n";
		echo "gpnode delprocess -n <process-name>		# remove process <process-name> and all the connections to or from it"."\n";
		echo "gpnode showprocess		# print the list of process in the current project"."\n";
		echo ""."\n";
		echo "# block attributes"."\n";
		echo "gpnode renameblock -n <block-name> -v <new-name>		# rename a process block"."\n";
		echo "gpnode setproperty -n <property-name> -v <default-value>		# define a default value <default-value> to the property <property-name>"."\n";
		echo "gpnode setparam -n <param-name> -v <value>		# set the value <value> to the param <param-name>"."\n";
		echo "gpnode setclock -n <clock-name> -v <frequency>		# define the clock frequency <frequency> to the clock <clock-name>"."\n";
		echo "gpnode setflowsize -n <flow-name> -v <flow-size>		# define the flow size <flow-size> to the flow <flow-name>"."\n";
		echo ""."\n";
		echo "# flow interconnect"."\n";
		echo "gpnode connect -f <flow-out> -t <flow-in> [-s <bit-shift>]		# add a flow connection between a flow out <flow-out> (ex: mt9.out) to a flow in <flow-in> with a bit shift <bit-shift> ('lsb' or 'msb')"."\n";
		echo "gpnode unconnect -f <flow-out> -t <flow-in>		# remove a flow connection between a flow out <flow-out> (ex: mt9.out) to a flow in <flow-in>"."\n";
		echo "gpnode showconnects			# print the list of flow connections in the current project"."\n";
		echo ""."\n";
		echo "# clock interconnect"."\n";
		echo "gpnode setclockdomain -n <domain-name> -v <frequency>		# define a clock frequency <frequency> the the clock domain <domain-name>"."\n";
		echo "gpnode showclockdomain		# print the list of clock domains in the current project"."\n";

		$save = false;
		break;
	case "-v":
	case "--version":
		echo "# gpnode command line tool to manage a gpstudio node (v1.0)"."\n";
		$save = false;
		break;
	
	// =========================== project commands =========================== 
	case "newproject":
		// nothing to do
		break;
	case "setboard":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $boardName = $options['n']; else error("You should specify a board name with -n"."\n",1);
		$node->setBoard($boardName);
		break;
		
	case "generate":
		$options = getopt("a:o::");
		if(array_key_exists('o',$options)) $outDir = $options['o']; else $outDir=getcwd();
		break;
		
	// =========================== io commands =========================== 
	case "addio":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $ioName = $options['n']; else error("You should specify an io name with -n"."\n",1);
		
		if(!isset($node->board)) error("You should specify a board with gpnode setboard before add io."."\n",1);
		if($node->getBlock($ioName)!=NULL) error("This io name is ever added."."\n",1);
		
		$node->addIo($ioName);
		break;
		
	case "delio":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $ioName = $options['n']; else error("You should specify an io name with -n"."\n",1);
		
		if(!isset($node->board)) error("You should specify a board with gpnode setboard before del io."."\n",1);
		if($node->getBlock($ioName)==NULL) error("This io name '$ioName' doesn't exists."."\n",1);
		
		$node->delIo($ioName);
		break;
		
	case "showio":
		$options = getopt("a:f::");
		if(array_key_exists('f',$options)) $format = $options['f']; else $format="";
		
		echo "ios :" . "\n";
		foreach($node->blocks as $block)
		{
			if($block->type()=="io")
			{
				echo "  + ".$block->name . "\n";
			}
		}
		$save = false;
		break;
		
	// =========================== process commands =========================== 
	case "addprocess":
		$options = getopt("a:d:n:");
		if(array_key_exists('d',$options)) $processDriver = $options['d']; else error("You should specify a process driver with -d"."\n",1);
		if(array_key_exists('n',$options)) $processName = $options['n']; else $processName = $processDriver;
		
		if($node->getBlock($processName)!=NULL) error("This process name is ever added."."\n",1);
		
		$node->addProcess($processName, $processDriver);
		break;
		
	case "delprocess":
		$options = getopt("a:n:");
		if(array_key_exists('n',$options)) $processName = $options['n']; else error("You should specify an process name with -n"."\n",1);
		
		if($node->getBlock($processName)==NULL) error("This process name '$processName' doesn't exists."."\n",1);
		
		$node->delProcess($processName);
		break;
		
	case "showprocess":
		$options = getopt("a:f::");
		if(array_key_exists('f',$options)) $format = $options['f']; else $format="";
		
		echo "process :" . "\n";
		foreach($node->blocks as $block)
		{
			if($block->type()=="process")
			{
				echo "  + ".$block->name . "\n";
			}
		}
		$save = false;
		break;
		
	// =========================== flow connections commands =========================== 
	case "connect":
	case "unconnect":
		$options = getopt("a:f:t:");
		if(array_key_exists('f',$options)) $from = $options['f'];	else error("You should specify a source flow with -f"."\n",1);
		if(array_key_exists('t',$options)) $to = $options['t'];		else error("You should specify a sink flow with -t"."\n",1);
		
		$fromRes = explode(".", $from, 2);
		if(count($fromRes)!=2) error("Malformed expression from flow -f."."\n",1);
		$fromBlock = $node->getBlock($fromRes[0]);
		if($fromBlock==NULL) error("Block '".$fromRes[0]."' doesn't exists."."\n",1);
		$fromFlow = $fromBlock->getFlow($fromRes[1]);
		if($fromFlow==NULL) error("Flow '".$fromRes[1]."' in '".$fromRes[0]."' doesn't exists."."\n",1);
		if($fromFlow->type!="out") error("Flow '".$fromRes[1]."' in '".$fromRes[0]."' isn't a flow out."."\n",1);
		
		$toRes = explode(".", $to, 2);
		if(count($toRes)!=2) error("Malformed expression to flow -t."."\n",1);
		$toBlock = $node->getBlock($toRes[0]);
		if($toBlock==NULL) error("Block '".$toRes[0]."' doesn't exists."."\n",1);
		$toFlow = $toBlock->getFlow($toRes[1]);
		if($toFlow==NULL) error("Flow '".$toRes[1]."' in '".$toRes[0]."' doesn't exists."."\n",1);
		if($toFlow->type!="in") error("Flow '".$toRes[1]."' in '".$toRes[0]."' isn't a flow in."."\n",1);
		break;
		
	case "showconnects":
		// nothing to do
		$save = false;
		break;
		
	// =========================== clock domain commands =========================== 
	case "setclockdomain":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $clockName = $options['n'];	else error("You should specify the name of the clock domain with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = Clock::convert($options['v']);	else error("You should specify the frequency of the clock domain with -v"."\n",1);
		break;
		
	case "showclockdomain":
		// nothing to do
		$save = false;
		break;
		
	// =========================== block attributes commands =========================== 
	case "renameblock":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $blockName = $options['n'];	else error("You should specify the name of the block to rename with -n"."\n",1);
		if(array_key_exists('v',$options)) $newName = $options['v'];	else error("You should specify the new name of the block to rename with -v"."\n",1);
		
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process '$blockName' name doesn't exists."."\n",1);
		$block->name = $newName;
		break;
		
	case "setproperty":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $propertyName = $options['n'];	else error("You should specify the name of the property with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = $options['v'];	else error("You should specify the value of the property with -v"."\n",1);
		
		$propertyRes = explode(".", $propertyName);
		if(count($propertyRes)<2) error("Malformed expression property name -n."."\n",1);
		
		$blockName = $propertyRes[0];
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process named '$blockName' doesn't exists."."\n",1);
		
		$propertyName = $propertyRes[1];
		$property = $block->getProperty($propertyName);
		if($property==NULL) error("This property name '$propertyName' doesn't exists in '$blockName'."."\n",1);
		
		unset($propertyRes[0]);
		unset($propertyRes[1]);
		foreach($propertyRes as $propertyName)
		{
			$property = $property->getSubProperty($propertyName);
			if($property==NULL) error("This property name '$propertyName' doesn't exists in '$blockName'."."\n",1);
		}
		
		$property->value = $value;
		break;
		
	case "setparam":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $paramName = $options['n'];	else error("You should specify the name of the param with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = $options['v'];	else error("You should specify the value of the param with -v"."\n",1);
		
		$paramRes = explode(".", $paramName);
		if(count($paramRes)!=2) error("Malformed expression param name -n."."\n",1);
		
		$blockName = $paramRes[0];
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process named '$blockName' doesn't exists."."\n",1);
		$paramName = $paramRes[1];
		$param = $block->getParam($paramName);
		if($param==NULL) error("This param name '$param' doesn't exists in '$blockName'."."\n",1);
		
		$param->value = $value;
		break;
		
	case "setclock":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $clockName = $options['n'];	else error("You should specify the name of the clock with -n"."\n",1);
		if(array_key_exists('v',$options)) $value = Clock::convert($options['v']);	else error("You should specify the frequency of the clock with -v"."\n",1);
		
		$clockRes = explode(".", $clockName);
		if(count($clockRes)!=2) error("Malformed expression clock name -n."."\n",1);
		
		$blockName = $clockRes[0];
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name '$blockName' doesn't exists."."\n",1);
		
		$clockName = $clockRes[1];
		$clock = $block->getClock($clockName);
		if($clock==NULL) error("This clock name '$clockName' doesn't exists in '$blockName'."."\n",1);
		
		$clock->typical = $value;
		break;
		
	case "setflowsize":
		$options = getopt("a:n:v:");
		if(array_key_exists('n',$options)) $flowName = $options['n'];	else error("You should specify the name of the flow with -n"."\n",1);
		if(array_key_exists('v',$options)) $flowsize = $options['v'];	else error("You should specify the size of the flow with -v"."\n",1);
		
		$flowRes = explode(".", $flowName);
		if(count($flowRes)!=2) error("Malformed expression clock name -n."."\n",1);
		
		$blockName = $flowRes[0];
		$block = $node->getBlock($blockName);
		if($block==NULL) error("This process name '$blockName' doesn't exists."."\n",1);
		
		$flowName = $flowRes[1];
		$flow = $block->getFlow($flowName);
		if($flow==NULL) error("This flow name '$flowName' doesn't exists in '$blockName'."."\n",1);
		
		$flow->size = $flowsize;
		break;
		
	case "listavailableprocess":
		listprocess();
		$save = false;
		break;
		
	case "listprocess":
		foreach($node->blocks as $block) echo $block->name.' ';
		$save = false;
		break;
		
	case "listavailableio":
		if(!isset($node->board)) exit(0);
		echo implode(" ",$node->board->availableIos());
		$save = false;
		break;
		
	case "listword":
		$options = getopt("a:w:m:");
		if(array_key_exists('w',$options)) $word = $options['w']; else $word="";
		if(array_key_exists('m',$options)) $mode = $options['m']; else $mode="";
		
		$wordRes = explode(".", $word);
		if(count($wordRes)==1)
		{
			foreach($node->blocks as $block) echo $block->name.'. ';
			exit(0);
		}
		else
		{
			$blockName = $wordRes[0];
			$block = $node->getBlock($blockName);
			if($block==NULL) exit(0);
			switch($mode)
			{
				case "property":
					if(count($wordRes)==2)
					{
						foreach($block->properties as $property)
						{
							if(count($property->properties)==0) echo $blockName.'.'.$property->name.' '; else echo $blockName.'.'.$property->name.'. ';
						}
					}
					else
					{
						$propertyName = $wordRes[1];
						$property = $block->getProperty($propertyName);
						if($property==NULL) exit(0);
						
						$prefix=$blockName.'.'.$propertyName;
						if(count($wordRes)>3)
						{
							unset($wordRes[0]);
							unset($wordRes[1]);
							foreach($wordRes as $propertyName)
							{
								$property = $property->getSubProperty($propertyName);
								if($property==NULL) exit(0);
								$prefix.='.'.$property->name;
							}
						}
						
						foreach($property->properties as $property)
						{
							if(count($property->properties)==0) echo $prefix.'.'.$property->name.' '; else echo $prefix.'.'.$property->name.'. ';
						}
					}
					
					break;
				case "clock":
					foreach($block->clocks as $clock) echo $blockName.'.'.$clock->name.' ';
					break;
				case "param":
					foreach($block->params as $param)
					{
						if($param->hard==1) echo $blockName.'.'.$param->name.' ';
					}
					break;
				case "flow":
					foreach($block->flows as $flow) echo $blockName.'.'.$flow->name.' ';
					break;
				case "flowin":
					foreach($block->flows as $flow) if($flow->type=="in") echo $blockName.'.'.$flow->name.' ';
					break;
				case "flowout":
					foreach($block->flows as $flow) if($flow->type=="out") echo $blockName.'.'.$flow->name.' ';
					break;
			}
		}
		
		$save = false;
		break;
	
	default:
		error("Action $action is unknow.",1);
}

// create toolchain depend of the config node
if(isset($node->board))
{
	$toolchain = $node->board->toolchain;
	$toolchain->configure_project($node);
}

// process action, post config
switch($action)
{
	case "generate":
		if(!isset($toolchain))
		{
			error("You should specify a board with gpnode setboard before generate."."\n",1);
		}
		$toolchain->generate_project($node, $outDir);
		$node->saveXml($outDir.DIRECTORY_SEPARATOR."node_generated.xml");
		message("Project successfully generated ($warningCount warnings).");
		break;
	case "connect":
		$fi = $node->getBlock("fi");
		if($fi->getFlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name)!=NULL) error("This flow name connexion ever exists."."\n",1);
		$fi->addFlowConnect(new FlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name));
		break;
	case "unconnect":
		$fi = $node->getBlock("fi");
		if($fi->getFlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name)==NULL) error("This flow name connexion doesn't exists."."\n",1);
		$fi->delFlowConnect($fromBlock->name, $fromFlow->name, $toBlock->name, $toFlow->name);
		break;
	case "showconnects":
		echo "connects :" . "\n";
		foreach($node->getBlock("fi")->flow_connects as $flow_connect)
		{
			echo "  + ".$flow_connect->fromblock.".".$flow_connect->fromflow." -> ".$flow_connect->toblock.".".$flow_connect->toflow." (".$flow_connect->order.")"."\n";
		}
		break;
	case "setclockdomain":
		$node->getBlock("ci")->addClockDomain(new ClockDomain($clockName, $value));
		break;
	case "showclockdomain":
		echo "domains :" . "\n";
		foreach($node->getBlock("ci")->domains as $domain)
		{
			echo "  + ".$domain->name." = ".Clock::formatFreq($domain->typical)."\n";
		}
		break;
}

if($save) $node->saveProject($project);

?>