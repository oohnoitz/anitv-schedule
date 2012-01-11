-- phpMyAdmin SQL Dump
-- version 3.4.3.2
-- http://www.phpmyadmin.net

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `anitv`
--

-- --------------------------------------------------------

--
-- Table structure for table `anidb`
--

CREATE TABLE IF NOT EXISTS `anidb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aid` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `language` varchar(32) NOT NULL,
  `title` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `title` (`title`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `channel`
--

CREATE TABLE IF NOT EXISTS `channel` (
  `ChID` int(11) NOT NULL,
  `ChGID` int(11) NOT NULL,
  `ChName` varchar(128) NOT NULL,
  `ChNameEN` varchar(128) NOT NULL,
  PRIMARY KEY (`ChID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `channel`
--

INSERT INTO `channel` (`ChID`, `ChGID`, `ChName`, `ChNameEN`) VALUES
(1, 11, 'NHK総合', 'NHK General'),
(2, 11, 'NHK教育', 'NHK Educational'),
(3, 1, 'フジテレビ', 'Fuji TV'),
(4, 1, '日本テレビ', 'NTV'),
(5, 1, 'TBS', ''),
(6, 1, 'テレビ朝日', 'TV Asahi'),
(7, 1, 'テレビ東京', 'TV Tokyo'),
(8, 1, 'tvk', ''),
(9, 9, 'NHK-BS1', ''),
(10, 9, 'NHK-BS2', ''),
(11, 2, 'NHK-BShi', ''),
(12, 9, 'WOWOW', ''),
(13, 1, 'チバテレビ', 'Chiba TV'),
(14, 1, 'テレ玉', 'Teletama'),
(15, 2, 'BS Japan', ''),
(16, 2, 'BS-TBS', ''),
(17, 2, 'BSフジ', 'BS Fuji'),
(18, 2, 'BS朝日', ''),
(19, 1, 'TOKYO MX', ''),
(20, 6, 'AT-X', ''),
(21, 6, 'アニマックス', 'Animax'),
(22, 6, 'キッズステーション', 'Kid''s Station'),
(23, 6, 'カートゥーンネットワーク', 'Cartoon Network'),
(24, 6, 'CS GyaO', ''),
(25, 6, 'テレ朝チャンネル', 'TV Asahi Channel'),
(26, 6, 'チャンネルNECO', 'Channel NECO'),
(27, 7, 'animate.tv', ''),
(28, 8, 'テレビ大阪', 'TV Osaka'),
(29, 7, 'ラジ＠', 'Raji@'),
(30, 12, 'ニッポン放送(1242)', 'Nippon Broadcasting (1242)'),
(31, 6, 'スカパー181ch', 'SkyPerfect 181'),
(32, 6, 'スカパー180ch', 'SkyPerfect 180'),
(33, 6, 'スカパー160ch', 'SkyPerfect 160'),
(34, 6, 'スカパー242ch', 'SkyPerfect 242'),
(35, 15, 'ラジオ大阪(1314)', 'Radio Osaka (1314)'),
(36, 15, 'KBS京都(1143)', 'KBS Kyoto (1143)'),
(37, 16, 'RCC中国放送(1350)', 'RCC Chuugoku Broadcasting (1350)'),
(38, 15, 'ABCラジオ(1008)', ''),
(39, 6, '東映チャンネル', 'Toei Channel'),
(40, 6, '日本映画専門チャンネル', 'Japan Movie Channel'),
(41, 12, '文化放送(1134)', 'Culture Broadcasting (1134)'),
(42, 6, 'ファミリー劇場', 'Family Theatre'),
(43, 6, 'フジテレビTWO', 'Fuji TV TWO'),
(44, 6, 'スカパー182ch', 'SkyPerfect 182'),
(45, 6, 'スカパー183ch', 'SkyPerfect 183'),
(46, 7, 'mugimugi.com', ''),
(47, 6, 'MONDOTV', ''),
(48, 8, 'MBS毎日放送', 'MBS Mainichi Broadcasting'),
(49, 10, 'NHKラジオ第一', 'NHK #1 Radio'),
(50, 2, 'BSQR 489', ''),
(51, 2, 'LFX488', ''),
(52, 6, 'TBSチャンネル', ''),
(53, 12, 'TBSラジオ(954)', ''),
(54, 8, '読売テレビ', 'Yomiuri TV'),
(55, 6, 'YFTV', ''),
(56, 6, 'アニマルプラネット', 'Animal Planet'),
(57, 7, 'その他のインターネット', 'Other Internet Channels'),
(58, 8, 'サンテレビジョン', 'Sun TV'),
(59, 13, 'テレビ愛知', 'TV Aichi'),
(60, 14, 'テレビ新広島', 'TV Shin-Hiroshima'),
(61, 6, 'ディスカバリーチャンネル', 'Discovery Channel'),
(62, 6, 'スカパー101ch', 'Sky Perfect 101'),
(63, 6, 'スカパー', 'Sky Perfect 101'),
(64, 11, 'NHK教育2', 'NHK Educational 2'),
(65, 11, 'NHK教育3', 'NHK Educational 3'),
(66, 8, 'KBS京都', 'KBS (Kyoto)'),
(67, 8, 'ABCテレビ', 'ABC TV (Asahi Broadcasting)'),
(68, 6, 'ch.280 ActOnTV(by recruit)', ''),
(69, 17, 'なし', ''),
(70, 8, '関西テレビ', 'Kansai TV'),
(71, 2, 'BS日テレ', 'BS-Nippon TV'),
(72, 1, '群馬テレビ', 'Gunma TV'),
(73, 7, 'LFX BB', 'Nippon TV Broadband Version'),
(74, 8, '奈良テレビ', 'Nara TV'),
(75, 7, 'GyaO!', ''),
(76, 2, 'WOWOWシネマ', 'WOWOW Cinema'),
(77, 13, '東海テレビ', 'Tokai TV'),
(78, 7, 'ShowTime', ''),
(79, 13, 'CBCテレビ', 'Chuubu Nippon Broadcasting'),
(80, 13, '中京テレビ', 'Chuu-Kyou TV'),
(81, 13, 'メ～テレ', 'Nagoya Broadcasting Network'),
(82, 13, '三重テレビ', 'Mie TV'),
(83, 13, 'ぎふチャン', 'Gifu Channel'),
(84, 6, 'sky・A', ''),
(85, 7, 'Yahoo!動画', 'Yahoo! Douga'),
(86, 8, 'テレビ和歌山', 'TV Wakayama'),
(87, 8, 'ＢＢＣびわ湖放送', 'BBC Biwako Broadcasting'),
(88, 18, '北海道テレビ放送', 'Hokkaido TV Broadcasting'),
(89, 18, '北海道放送', 'Hokkaido Broadcasting'),
(90, 18, 'テレビ北海道', 'TV Hokkaido'),
(91, 18, '北海道文化放送', 'Hokkaido Culture Broadcasting'),
(92, 18, '札幌テレビ放送', 'Sapporo TV Broadcasting'),
(93, 19, 'TVQ九州放送', 'TVQ Kyushu Broadcasting'),
(94, 19, 'RKB毎日放送', 'RKB Mainichi Broadcasting'),
(95, 14, 'テレビせとうち', 'TV Setouchi'),
(96, 19, '福岡放送', 'Fukuoka Broadcasting'),
(97, 2, 'WOWOWライブ', 'WOWOW Live'),
(98, 20, '東北放送', 'Touhoku Broadcasting'),
(99, 14, '広島ホームテレビ', 'Hiroshima Home TV'),
(100, 1, 'とちぎテレビ', 'Tochigi TV'),
(101, 7, 'BIGLOBEストリーム', 'BIGLOBE Stream'),
(102, 14, '中国放送', 'Chugoku Broadcasting'),
(103, 14, '広島テレビ', 'Hiroshima TV'),
(104, 14, '岡山放送', 'Okayama Broadcasting'),
(105, 14, '山陽放送', 'Sanyou Braodcasting'),
(106, 10, 'NHK-FM', ''),
(107, 7, 'バンダイチャンネル', 'Bandai Channel'),
(108, 7, 'フレッツ・スクウェア（NTT東日本）', 'Flet''s Square (NTT Eastern Japan)'),
(109, 6, 'フジテレビONE', 'Fuji TV ONE'),
(110, 7, 'バンダイチャンネルキッズ', 'Bandai Channel Kids'),
(111, 21, 'テレビ信州', 'TV Shinshu'),
(112, 6, '330ch WOWOW', 'Nagano'),
(113, 13, 'SBSテレビ', 'Shizuoka Broadcasting'),
(114, 22, '南海放送', 'Nankai Broadcasting'),
(115, 22, 'テレビ愛媛', 'TV Ehime'),
(116, 22, 'あいテレビ', 'i-TELEVISION'),
(117, 22, '愛媛朝日テレビ', 'Ehime-Asashi TV'),
(118, 7, 'i-revo', ''),
(119, 6, '日テレプラス', 'Nihon TV Plus'),
(120, 7, '@nifty', ''),
(121, 6, 'ビクトリーチャンネル', 'Victory Channel'),
(122, 7, 'gooアニメ', 'goo Anime'),
(123, 22, '瀬戸内海放送', 'Seto-Naikai Broadcasting'),
(124, 22, '西日本放送', 'Western Japan Broadcasting'),
(125, 14, 'テレビ山口', 'TV Yamaguchi'),
(126, 14, '山口放送', 'Yamaguchi Broadcasting'),
(127, 14, '山口朝日放送', 'Yamaguchi-Asashi Broadcasting'),
(128, 2, 'BS11デジタル', 'BS11 Digital'),
(129, 2, 'TwellV', ''),
(130, 7, '角川アニメチャンネル', 'Kadokawa Anime Channel'),
(131, 6, 'フジテレビNEXT', 'Fuji TV NEXT'),
(132, 7, 'ニコニコアニメチャンネル', 'NicoNico Anime Channel'),
(133, 15, 'ラジオ関西(558)', 'Radio Kansai'),
(134, 15, 'MBSラジオ(1179)', 'MBS Radio'),
(135, 17, 'PLAYSTATION Store', ''),
(136, 7, 'ニコニコ生放送', 'NicoNico Live Broadcasting'),
(137, 6, 'スカパー162ch', 'SkyPerfect 162'),
(138, 19, '九州朝日放送', 'Kyushu-Asashi Broadcasting'),
(139, 24, '東海ラジオ(1332)', 'Tokaido Radio (1332)'),
(140, 16, '南海放送(1116)', 'Nankai Broadcasting (1116)'),
(141, 13, 'テレビ静岡', 'TV Shizuoka'),
(142, 19, '熊本放送', 'Kumamoto Broadcasting'),
(143, 7, 'アニメワン', 'Anime One'),
(144, 19, 'テレビ西日本', 'TV Western Japan'),
(145, 19, 'サガテレビ', 'Saga TV'),
(146, 25, '北陸朝日放送', 'Hokuriku-Asahi Broadcasting'),
(147, 25, '北陸放送', 'Hokuriku Broadcasting'),
(148, 25, '福井放送', 'Fukui Broadcasting'),
(149, 25, '福井テレビ', 'Fukui TV'),
(150, 6, 'スカチャンHD800', 'SkyChan HD800'),
(151, 6, 'MUSIC ON! TV', ''),
(152, 6, 'ムービープラス', 'Movie Plus'),
(153, 6, 'ホームドラマチャンネル', 'Home Drama Channel'),
(154, 13, 'だいいちテレビ', '1st TV'),
(155, 13, '静岡朝日テレビ', 'Shizuoka-Asahi TV'),
(156, 12, '超!A&amp;G+', 'I think something messed up when you tried to copy that'),
(157, 7, 'アニメNewtypeチャンネル', 'Anime Newtype Channel'),
(158, 6, '放送大学CSテレビ', 'University of Broadcasting CS TV'),
(159, 6, '放送大学CSラジオ', 'University of Broadcasting CS Radio'),
(160, 6, 'スカチャン', 'Sky Channel'),
(161, 6, 'ディズニーXD', 'Disney XD'),
(162, 12, 'TOKYO FM(80.0)', ''),
(163, 6, 'ディズニー・チャンネル', 'Disney Channel'),
(164, 6, 'Music Japan TV', ''),
(165, 7, 'ニコニコチャンネル', 'NicoNico Channel'),
(166, 12, 'bayfm(78.0)', ''),
(167, 6, 'TAKARAZUKA SKY STAGE', ''),
(168, 19, '長崎放送', 'Nagasaki Broadcasting'),
(169, 19, '長崎文化放送', 'Nagasaki Culture Broadcasting'),
(170, 19, 'テレビ長崎', 'TV Nagasaki'),
(171, 19, '長崎国際テレビ', 'Nagasaki International TV'),
(172, 25, 'テレビ金沢', 'TV Kanazawa'),
(173, 6, 'スカチャンHD801', 'Sky Channel HD801'),
(174, 6, 'スカチャン802', 'Sky Channel 802'),
(175, 6, 'スカチャンHD192', 'Sky Channel HD192'),
(176, 6, '旅チャンネル', 'Travel Channel'),
(177, 7, 'テレビドガッチ', 'TV Gacchi'),
(178, 7, 'YouTube', ''),
(179, 2, 'NHK BSプレミアム', 'NHK BS Premium'),
(180, 12, 'InterFM(76.1)', ''),
(181, 25, '福井さかいケーブルテレビ', 'Fukui-Sakai Cable TV'),
(182, 7, 'USTREAM', ''),
(183, 24, '中部日本放送(1053)', 'Chuubu-Nihon Broadcasting'),
(184, 24, 'ZIP-FM(77.8)', ''),
(185, 24, 'レディオキューブFM三重(78.9)', 'Radio Cube FM Mie'),
(186, 24, 'FM AICHI(80.7)', ''),
(187, 1, 'TOKYO MX2', ''),
(188, 12, 'NACK5(79.5)', ''),
(189, 12, 'bayfm78(78.0)', ''),
(190, 12, 'FMヨコハマ(84.7)', 'FM Yokohama'),
(191, 12, 'ラジオ日本(1422)', 'Radio Japan'),
(192, 11, 'NHKワンセグ2', 'NHK One-Seg 2'),
(193, 7, 'バンダイチャンネルライブ！', 'Bandai Channel Live'),
(194, 6, 'スペースシャワーTV', 'Space Shower TV'),
(195, 10, 'NHKラジオ第二', 'NHK #2 Radio'),
(196, 2, 'BSスカパー！', 'BS SkyPerfect!'),
(197, 2, 'BSアニマックス', 'BS Animax'),
(198, 20, '青森放送', 'Aomori Broadcasting'),
(199, 20, '青森朝日放送', 'Aomori-Asahi Broadcasting'),
(200, 20, '青森テレビ', 'Aomori TV'),
(201, 26, '琉球放送', 'Ryuukyuu Broadcasting'),
(202, 26, '琉球朝日放送', 'Ryuukyuu-Asahi Broadcasting'),
(203, 26, '沖縄テレビ', 'Okinawa TV'),
(204, 2, 'WOWOWプライム', 'WOWOW Prime'),
(205, 7, '東映特撮 YouTube Official', 'Toei Tokusatsu YouTube Official'),
(206, 21, 'BSNテレビ', 'BSN TV'),
(207, 21, 'TeNY', ''),
(208, 21, '新潟テレビ21', 'Niigata TV 21'),
(209, 21, '新潟総合テレビ', 'Niigata General TV');


-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE IF NOT EXISTS `history` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TID` int(11) NOT NULL,
  `IP` varchar(24) NOT NULL,
  `OriginalRomaji` varchar(128) NOT NULL DEFAULT '',
  `NewRomaji` varchar(128) NOT NULL DEFAULT '',
  `OriginalTitle` varchar(128) NOT NULL DEFAULT '',
  `NewTitle` varchar(128) NOT NULL DEFAULT '',
  `OriginalAniDB` int(11) NOT NULL DEFAULT '0',
  `NewAniDB` int(11) NOT NULL DEFAULT '0',
  `Updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `program`
--

CREATE TABLE IF NOT EXISTS `program` (
  `LastUpdate` datetime NOT NULL,
  `PID` int(11) NOT NULL,
  `TID` int(11) NOT NULL,
  `StTime` datetime NOT NULL,
  `StOffset` int(11) NOT NULL,
  `EdTime` datetime NOT NULL,
  `Count` int(11) NOT NULL,
  `SubTitle` text NOT NULL,
  `ProgComment` text NOT NULL,
  `Flag` int(11) NOT NULL,
  `Deleted` int(11) NOT NULL,
  `Warn` int(11) NOT NULL,
  `ChID` int(11) NOT NULL,
  `Revision` int(11) NOT NULL,
  `STSubTitle` varchar(128) NOT NULL,
  PRIMARY KEY (`PID`),
  KEY `TID` (`TID`),
  KEY `LastUpdate` (`LastUpdate`),
  KEY `StTime` (`StTime`),
  KEY `EdTime` (`EdTime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `title`
--

CREATE TABLE IF NOT EXISTS `title` (
  `TID` int(11) NOT NULL,
  `AID` int(11) NOT NULL DEFAULT '0',
  `LastUpdate` datetime NOT NULL,
  `Title` text NOT NULL,
  `ShortTitle` text NOT NULL,
  `TitleYomi` text NOT NULL,
  `TitleRomaji` text NOT NULL,
  `TitleEN` text NOT NULL,
  `TitleManual` text NOT NULL,
  `Comment` text NOT NULL,
  `Cat` int(11) NOT NULL,
  `TitleFlag` int(11) NOT NULL,
  `FirstYear` int(11) NOT NULL,
  `FirstMonth` int(11) NOT NULL,
  `FirstEndYear` int(11) NOT NULL,
  `FirstEndMonth` int(11) NOT NULL,
  `FirstCh` varchar(128) NOT NULL,
  `DefaultCh` int(11) NOT NULL DEFAULT '0',
  `Keywords` varchar(128) NOT NULL,
  `UserPoint` int(11) NOT NULL,
  `UserPointRank` int(11) NOT NULL,
  `SubTitles` text NOT NULL,
  PRIMARY KEY (`TID`),
  FULLTEXT KEY `Title` (`Title`,`ShortTitle`,`TitleYomi`,`TitleRomaji`,`TitleEN`,`TitleManual`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
