<?php

header('Content-Type: text/html; charset=utf-8');

if (empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) != 'XMLHttpRequest')
{
	die('Invalid Request');
}

include('class/anitv.php');
require('config.php');

$_POST = array_map('trim', $_POST);
$_POST = array_map('stripslashes', $_POST);


if (!empty($_POST))
{
	$AniTV = new AniTV();
	$AniTV->connect();

	if ($AniTV->modify($_POST['id'], $_POST['field'], $_POST['value']))
		echo $_POST['value'] . '(Updating...)';
	else
		echo '';
}