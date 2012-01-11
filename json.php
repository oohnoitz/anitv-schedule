<?php

include('system/class/anitv.php');
require('system/config.php');

$AniTV = new AniTV();
$AniTV->connect();

if (empty($_GET) || (!isset($_GET['controller'])))
	die('error: incorrect calls');

switch ($_GET['controller'])
{
	case 'history':
		echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->history() . ')' : $AniTV->history();
		break;

	case 'search':
		if (isset($_GET['total']))
			echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->search($_GET['query'], $_GET['total']) . ')' : $AniTV->search($_GET['query'], $_GET['total']);
		else
			echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->search($_GET['query']) . ')' : $AniTV->search($_GET['query']);
		break;

	case 'stream':
		echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->stream($_GET['total']) . ')' : $AniTV->stream($_GET['total']);
		break;

	default:
		if (isset($_GET['total']))
			echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->schedule($_GET['total'], ((isset($_GET['nowplaying'])) ? $_GET['nowplaying'] : TRUE)) . ')' : $AniTV->schedule($_GET['total'], ((isset($_GET['nowplaying'])) ? $_GET['nowplaying'] : TRUE));
		else
			echo (isset($_GET['callback'])) ? $_GET['callback'] . '(' . $AniTV->schedule(50, ((isset($_GET['nowplaying'])) ? $_GET['nowplaying'] : TRUE)) . ')' : $AniTV->schedule();
}