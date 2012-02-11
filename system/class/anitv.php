<?php

// Set Appropriate Headers & Environment
header('Content-Type: text/html; charset=utf-8');
date_default_timezone_set("Asia/Tokyo");
setlocale(LC_ALL, 'en_US.UTF8');

class AniTV {
	var $hostname = MYSQL_HOST;
	var $username = MYSQL_USER;
	var $password = MYSQL_PASS;
	var $database = MYSQL_NAME;
	var $link;

	function __construct() {

	}

	function connect() {
		$this->link = new mysqli($this->hostname, $this->username, $this->password, $this->database);
		if ($this->link->connect_error)
		{
			return $this->link->connect_error;
		}
		$this->link->set_charset('UTF8');
		$this->link->query("SET time_zone = '+9:00'");
		return TRUE;
	}


	function download($source) {
		switch ($source) {
			case 'anidb.info':
				$contents = file_get_contents('http://anidb.net/api/animetitles.dat.gz');
				file_put_contents('data/animetitles.dat.gz', $contents);

				$execute = 'gunzip -f ' . dirname(__FILE__) . '/data/animetitles.dat.gz'; `$execute`;

				$contents = file_get_contents('data/animetitles.dat');
				$data = preg_replace('/([0-9]+)\|([0-9])\|(.*?)\|(.*)/', 'INSERT INTO `anidb` (`aid`, `type`, `language`, `title`) VALUES (\'\1\', \'\2\', \'\3\', \'\4\');', $contents);

				if (file_exists('data/animetitles.sql')) unlink('data/animetitles.sql');
				$file = fopen('data/animetitles.sql', 'wb');
				fwrite($file, "\xEF\xBB\xBF");
				fwrite($file, $data);
				fclose($file);
				break;

			case 'cal.syoboi.jp/title':
				// Titles
				$contents = file_get_contents('http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=*');
				file_put_contents('data/titles.xml', $contents);
				break;

			case 'cal.syoboi.jp/program':
				// Programs
				$contents = file_get_contents('http://cal.syoboi.jp/db.php?Command=ProgLookup&Range=' . date('Ymd', mktime(0, 0, 0, date('m'), date('d') - 5, date('Y'))) . '_000000-' . date('Ymd', mktime(0, 0, 0, date('m') + 1, date('d'), date('Y'))) . '_000000&JOIN=SubTitles');
				file_put_contents('data/programs.xml', $contents);
				break;

			default:
				return false;
		}
		return false;
	}


	function get_channel_name($id) {
		$id = $this->link->real_escape_string($id);
		$query = $this->link->query("SELECT `ChName`, `ChNameEN` FROM `channel` WHERE `ChID` = '{$id}'");
		$result = $query->fetch_assoc();
		if ($result["ChNameEN"] != "") return $result["ChNameEN"];
		return $result["ChName"];
	}


	function get_channel_id($name) {
		$name = $this->link->real_escape_string($name);
		$query = $this->link->query("SELECT `ChID` FROM `channel` WHERE `ChName` = '{$name}' LIMIT 1");
		$result = $query->fetch_assoc();
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
					$record[$key] = $this->link->real_escape_string(implode(' ', $value));
				} else {
					$record[$key] = $this->link->real_escape_string($value);
				}
			}

			$result = $this->link->query("SELECT `{$col}` FROM `{$table}` WHERE `{$col}` = '{$record[$col]}' LIMIT 1");
			if ($result->num_rows != 0) {
				$local = $result->fetch_assoc();

				if ($local['LastUpdate'] > $record['LastUpdate']) {
					$update = array();
					foreach ($record as $key => $value) {
						$update[] = "`{$key}` = '{$value}'";
					}

					$this->link->query("UPDATE `{$table}` SET " . implode(", ", $update) . " WHERE `{$col}` = '{$entry[$col]}'");
				}
			} else {
				$this->link->query("INSERT INTO `{$table}` (`" . implode("`, `", $field) . "`) VALUES ('" . implode("', '", $record) . "');");
			}
		}
	}


	function sync($table) {
		switch ($table) {
			case 'anidb':
				$this->download('anidb.info');
				$this->link->query("TRUNCATE TABLE `anidb`");
				$data = file_get_contents('data/animetitles.sql');
				$data = explode("\n", $data);

				foreach ($data as $line) {
					if (($line != NULL) && ($line != "") && !preg_match("/\# (.*?)/", $line)) {
						$this->link->query(str_replace("\xEF\xBB\xBF", '', $line));
					}
				}
				break;

			case 'title':
				$this->download('cal.syoboi.jp/title');
				$this->processXML('title');

				$titles = $this->link->query("
					SELECT *
					FROM `title`
					WHERE `AID` = 0
				");

				if ($titles->num_rows)
				{
					while ($row = $titles->fetch_object())
					{
						$anidb = $this->link->query("
							SELECT `Q`.`aid`, `title`
							FROM
								(
									SELECT `aid`
									FROM `anidb` WHERE `title` = '" . $this->link->real_escape_string($row->Title) . "'
								) AS Q
							JOIN `anidb` AS P
							ON `Q`.`aid` = `P`.`aid`
							ORDER BY `P`.`type` ASC
							LIMIT 1
						");

						if ($anidb->num_rows)
						{
							$data = $anidb->fetch_object();
							$this->link->query("UPDATE `title` SET `AID` = '" . $this->link->real_escape_string($data->aid) . "', `TitleManual` = '" . $this->link->real_escape_string($data->title) . "' WHERE `TID` = '" . $this->link->real_escape_string($row->TID) . "'");
						}
					}
				}

				break;

			case 'program':
				$this->download('cal.syoboi.jp/program');
				$this->processXML('program');
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


	function schedule($limit = 50, $nowplaying = TRUE)
	{
		$limit = (int)$this->link->real_escape_string($limit);

		if ($nowplaying === TRUE)
		{
			$airtime = "`program`.`EdTime`";
		}
		else
		{
			$airtime = "`program`.`StTime`";
		}

		$schedule = $this->link->query("
			SELECT `title`.*, `program`.*, UNIX_TIMESTAMP(`program`.`StTime`) AS `StTimeUnix`, UNIX_TIMESTAMP(`program`.`EdTime`) AS `EdTimeUnix`
			FROM `title`, `program`
			WHERE
				`title`.`TID` = `program`.`TID`
			AND
				LENGTH(`Count`) < 10
			AND
				`Count` != ''
			AND
				UNIX_TIMESTAMP(" . $airtime . ") > " . time() . "
			ORDER BY `program`.`StTime`, `program`.`EdTime` ASC
			LIMIT " . $limit . "
		");

		if ($schedule->num_rows)
		{
			while ($row = $schedule->fetch_object())
			{
				// Set Title
				$program = $row->Title;
				if (!empty($row->ShortTitle))
					$program = $row->ShortTitle;
				if (!empty($row->TitleRomaji))
					$program = $row->TitleRomaji;
				if (!empty($row->TitleEN))
					$program = $row->TitleEN;
				if (!empty($row->TitleManual))
					$program = $row->TitleManual;

				// Set Episode Number
				$episode = $row->Count;
				if ($row->Count == 0)
					$episode = $row->SubTitle;

				$schedule_json['programs'][] = array(
					'id' => (int)$row->PID,
					'title' => $program,
					'episode' => $episode,
					'subtitle' => $row->STSubTitle,
					'station' => $this->get_channel_name($row->ChID),
					'gmtime' => date(DATE_W3C, $row->StTimeUnix),
					'airtime' => $row->StTime,
					'duration' => (int)($row->EdTimeUnix - $row->StTimeUnix),
					'unixtime' => (int)$row->StTimeUnix,
					'anidb' => (int)$row->AID
				);
			}

			return json_encode($schedule_json);
		}

		return FALSE;
	}


	function stream($limit = 5)
	{
		$limit = (int)$this->link->real_escape_string($limit);

		$stream = $this->link->query("
			SELECT `title`.*, `program`.*, UNIX_TIMESTAMP(`program`.`StTime`) AS `StTimeUnix`, UNIX_TIMESTAMP(`program`.`EdTime`) AS `EdTimeUnix`
			FROM `title`, `program`
			WHERE
				`title`.`TID` = `program`.`TID`
			AND
				LENGTH(`Count`) < 10
			AND
				`Count` != ''
			AND
				UNIX_TIMESTAMP(`program`.`EdTime`) > " . time() . "
			ORDER BY `program`.`StTime`, `program`.`EdTime` ASC
			LIMIT 50, " . $limit . "
		");

		if ($stream->num_rows)
		{
			while ($row = $stream->fetch_object())
			{
				// Set Title
				$program = $row->Title;
				if (!empty($row->ShortTitle))
					$program = $row->ShortTitle;
				if (!empty($row->TitleRomaji))
					$program = $row->TitleRomaji;
				if (!empty($row->TitleEN))
					$program = $row->TitleEN;
				if (!empty($row->TitleManual))
					$program = $row->TitleManual;

				// Set Episode Number
				$episode = $row->Count;
				if ($row->Count == 0)
					$episode = $row->SubTitle;

				$stream_json['programs'][] = array(
					'id' => (int)$row->PID,
					'title' => $program,
					'episode' => $episode,
					'subtitle' => $row->STSubTitle,
					'station' => $this->get_channel_name($row->ChID),
					'gmtime' => date(DATE_W3C, $row->StTimeUnix),
					'airtime' => $row->StTime,
					'duration' => (int)($row->EdTimeUnix - $row->StTimeUnix),
					'unixtime' => (int)$row->StTimeUnix,
					'anidb' => (int)$row->AID
				);
			}

			return json_encode($stream_json);
		}

		return FALSE;
	}


	function search($query, $limit = 5)
	{
		$query = $this->link->real_escape_string(str_replace('*', '%', $query));
		$limit = (int)$this->link->real_escape_string($limit);

		$search = $this->link->query("
			SELECT `title`.*, `program`.*, UNIX_TIMESTAMP(`program`.`StTime`) AS `StTimeUnix`, UNIX_TIMESTAMP(`program`.`EdTime`) AS `EdTimeUnix`
			FROM `title`, `program`
			WHERE
				`title`.`TID` = `program`.`TID`
			AND
				UNIX_TIMESTAMP(`program`.`StTime`) > " . time() . "
			AND
				(
					MATCH(`title`.`Title`, `title`.`ShortTitle`, `title`.`TitleYomi`, `title`.`TitleRomaji`, `title`.`TitleEN`, `title`.`TitleManual`) AGAINST ('" . $query . "')
						OR
					`title`.`Title` LIKE '%" . $query . "%'
						OR
					`title`.`ShortTitle` LIKE '%" . $query . "%'
						OR
					`title`.`TitleYomi` LIKE '%" . $query . "%'
						OR
					`title`.`TitleRomaji` LIKE '%" . $query . "%'
						OR
					`title`.`TitleEN` LIKE '%" . $query . "%'
						OR
					`title`.`TitleManual` LIKE '%" . $query . "%'
				)
			ORDER BY `program`.`StTime` ASC
			LIMIT " . $limit . "
		");

		if ($search->num_rows)
		{
			while ($row = $search->fetch_object())
			{
				// Set Title
				$program = $row->Title;
				if (!empty($row->ShortTitle))
					$program = $row->ShortTitle;
				if (!empty($row->TitleRomaji))
					$program = $row->TitleRomaji;
				if (!empty($row->TitleEN))
					$program = $row->TitleEN;
				if (!empty($row->TitleManual))
					$program = $row->TitleManual;

				// Set Episode Number
				$episode = $row->Count;
				if ($row->Count == 0)
					$episode = $row->SubTitle;

				$search_json['results'][] = array(
					'id' => (int)$row->PID,
					'title' => $program,
					'episode' => $episode,
					'subtitle' => $row->STSubTitle,
					'station' => $this->get_channel_name($row->ChID),
					'gmtime' => date(DATE_W3C, $row->StTimeUnix),
					'airtime' => $row->StTime,
					'duration' => (int)($row->EdTimeUnix - $row->StTimeUnix),
					'unixtime' => (int)$row->StTimeUnix,
					'anidb' => (int)$row->AID
				);
			}

			return json_encode($search_json);
		}

		$search_json['results'][] = array('error' => 'No results found.');
		return json_encode($search_json);
	}


	function modify($id, $column, $value)
	{
		$id = $this->link->real_escape_string($id);
		$value = $this->link->real_escape_string($value);

		$entry = $this->link->query("SELECT * FROM `title` WHERE `TID` = '{$id}'");

		if ($entry->num_rows)
		{
			$row = $entry->fetch_object();

			switch ($column)
			{
				case 0:
					return TRUE;
					break;

				case 1:
					$this->link->query("INSERT INTO `history` (`TID`, `IP`, `OriginalRomaji`, `NewRomaji`) VALUES ('{$row->TID}', '{$_SERVER['REMOTE_ADDR']}', '{$row->TitleRomaji}', '{$value}'");
					$this->link->query("UPDATE `title` SET `TitleRomaji` = '{$value}' WHERE `TID` = '{$id}'");
					return TRUE;
					break;

				case 2:
					$this->link->query("INSERT INTO `history` (`TID`, `IP`, `OriginalTitle`, `NewTitle`) VALUES ('{$row->TID}', '{$_SERVER['REMOTE_ADDR']}', '{$row->TitleManual}', '{$value}'");
					$this->link->query("UPDATE `title` SET `TitleManual` = '{$value}' WHERE `TID` = '{$id}'");
					return TRUE;
					break;

				case 3:
					$this->link->query("INSERT INTO `history` (`TID`, `IP`, `OriginalAniDB`, `NewAniDB`) VALUES ('{$row->TID}', '{$_SERVER['REMOTE_ADDR']}', '{$row->AID}', '{$value}'");
					$this->link->query("UPDATE `title` SET `AID` = '{$value}' WHERE `TID` = '{$id}'");
					return TRUE;
					break;

				default:
					return FALSE;
			}
		}

		return FALSE;
	}


	function history()
	{
		$history = $this->link->query("SELECT `title`.`TID`, `title`.`Title`, `history`.* FROM `title`, `history` WHERE `title`.`TID` = `history`.`TID` ORDER BY `Updated` DESC LIMIT 50");

		if ($history->num_rows)
		{
			while ($row = $history->fetch_object())
			{
				$user = explode(".", $row->IP); $user[2] = "xxx"; $user[3] = "xxx";
				$user = implode(".", $user);

				$history_json['records'][] = array(
					'user' => $user,
					'program' => $row->Title,
					'orig_romaji' => $row->OriginalRomaji,
					'romaji' => $row->NewRomaji,
					'orig_title' => $row->OriginalTitle,
					'title' => $row->NewTitle,
					'orig_anidb' => $row->OriginalAniDB,
					'anidb' => $row->NewAniDB,
					'last_updated' => date(DATE_W3C, strtotime($row->Updated))
				);
			}

			return json_encode($history_json);
		}

		return FALSE;
	}
}
