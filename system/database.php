<?php

if ((empty($_GET)) || (!isset($_GET['action']) && !isset($_GET['data'])))
	die('invalid operation');

include('class/anitv.php');
require('config.php');

$AniTV = new AniTV();
$AniTV->connect();

switch ($_GET['action'])
{
	case 'sync':
		$AniTV->sync($_GET['data']);
		break;

	default:
		die('invalid operation');
}