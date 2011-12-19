<?php

// Set Appropriate Headers & Environment
header('Content-Type: text/html; charset=utf-8');
setlocale(LC_ALL, 'en_US.UTF8');

class AniTV {
	var $hostname = MYSQL_HOST;
	var $username = MYSQL_USER;
	var $password = MYSQL_PASS;
	var $database = MYSQL_NAME;
	var $link;

	function connect() {

	}


	function download($source) {
		switch ($source) {
			case 'anidb.info':
				$contents = file_get_contents('http://anidb.net/api/animetitles.dat.gz');
				file_put_contents('data/animetitles.dat.gz', $contents);

				$execute = 'gunzip -f ' . dirname(__FILE__) . '/data/animetitles.dat.gz';
				`$execute`;

				$contents = file_get_contents('data/animetitles.dat');
				$data = preg_replace('/([0-9]+)\|([0-9])\|(.*?)\|(.*)/', "INSERT INTO `anidb` (`aid`, `type`, `language`, `title`) VALUES ('\1', '\2', '\3', '\4');", $contents);

				if (file_exists('data/animetitles.sql')) unlink('data/animetitles.sql');
				$file = fopen('data/animetitles.sql', 'wb');
				fwrite($file, "\xEF\xBB\xBF");
				fwrite($file, $data);
				fclose($file);
				break;

			case 'cal.syoboi.jp':
				// Titles
				$contents = file_get_contents('http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=*');
				file_put_contents('data/titles.xml', $contents);

				// Programs
				$contents = file_get_contents('http://cal.syoboi.jp/db.php?Command=ProgLookup&JOIN=SubTitltes&Range=' . date('Ymd', mktime(0, 0, 0, date('m'), date('d') - 5, date('Y'))) . '_000000-' . date('Ymd', mktime(0, 0, 0, date('m') + 1, date('d'), date('Y'))) . '_000000');
				file_put_contents('data/programs.xml', $contents);
				break;

			default:
				return false;
		}
		return false;
	}


	function get_channel_name($id) {
		$id = mysql_real_escape_string($id, $this->link);
		$query = mysql_query("SELECT `ChName`, `ChNameEN` FROM `channel` WHERE `ChID` = '{$id}'", $this->link);
		$result = mysql_fetch_assoc($query);
		mysql_free_result($query);

		if ($result["ChNameEN"] != "") return $result["ChNameEN"];
		return $result["ChName"];
	}


	function get_channel_id($name) {
		$name = mysql_real_escape_string($name, $this->link);
		$query = mysql_query("SELECT `ChID` FROM `channel` WHERE `ChName` = '{$name}' LIMIT 1", $this->link);
		$result = mysql_fetch_assoc($query);
		mysql_free_result($query);

		return $result["ChID"];
	}


	function processXML($table) {
		switch ($table) {
			case 'title':
				$xml = 'data/titles.xml';
				$col = 'TID';
				$tbl = 'Title';
				break;

			case 'program':
				$xml = 'data/programs.xml';
				$col = 'PID';
				$tbl = 'Prog';
				break;

			default:
				return false;
		}

		$data = $this->XMLtoArray(simplexml_load_string(file_get_contents($xml)));

		foreach ($data["{$tbl}Items"]["{$tbl}Item"] as $record) {
			unset($record["@attributes"]);

			$field = array();
			foreach ($record as $key => $value) {
				$field[$key] = $key;

				if (is_array($value)) {
					$record[$key] = mysql_real_escape_string(implode(' ', $value), $this->link);
				} else {
					$record[$key] = mysql_real_escape_string($value, $this->link);
				}
			}

			$result = mysql_query("SELECT `{$col}` FROM `{$table}` WHERE `{$col}` = '{$record[$col]}' LIMIT 1", $this->link);
			if (mysql_num_rows($result)) {
				$local = mysql_fetch_assoc($result);

				if ($local['LastUpdate'] > $record['LastUpdate']) {
					$update = array();
					foreach ($record as $key => $value) {
						$update[] = "`{$key}` = '{$value}'";
					}

					mysql_query("UPDATE `{$table}` SET " . implode(", ", $update) . " WHERE `{$col}` = '{$entry[$col]}'", $this->link);
				}
			} else {
				mysql_query("INSERT INTO `{$table}` (" . implode("`, `", $field) . "`) VALUES ('" . implode("', '", $record) . "');", $this->link);
			}
			mysql_free_result($result);
		}
	}


	function sync($table) {
		switch ($table) {
			case 'anidb':
				mysql_query("TRUNCATE TABLE `anidb`");
				$data = file_get_contents('data/animetitles.sql');
				$data = explode("\n", $data);

				foreach ($data as $line) {
					if (($line != NULL) && ($line != "") && !preg_match("/\# (.*?)/", $line)) {
						mysql_query(str_replace("\xEF\xBB\xBF", '', $line), $this->link);
					}
				}
				break;

			case 'title':

				break;

			case 'program':
				break;

			default:
				return false;
		}
		return false;
	}


	function XMLtoArray($data) {
		$array = array();

		if (is_object($data)) {
			$data = get_object_vars($data);
		}

		if (is_array($data)) {
			foreach ($data as $index => $value) {
				if (is_object($value) || is_array($value)) {
					$value = $this->XMLtoArray($value);
				}

				$array[$index] = $value;
			}
		}

		return $array;
	}
}