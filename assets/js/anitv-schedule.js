jQuery(document).ready(function() {
	loadSchedule();
});

// Global Variables
var lastShow;

// Load Schedule
var loadSchedule = function() {
	var table = jQuery("#schedule");
	jQuery.ajax({
		url: 'http://anitv.foolz.us/schedule.php',
		type: 'GET',
		dataType: 'jsonp',
		jsonpCallback: 'schedule',
		async: false,
		success: function(data, textStatus, jqXHR) {
			if (data.schedule != undefined) {
				jQuery.each(data.schedule, function(i, value) {
					table.append(format(value));
				});

				jQuery("time").localize('yyyy-mm-dd HH:MM:ss');

				lastShow = data.schedule[data.schedule.length - 1].id;
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
		},
		complete: function(jqXHR, textStatus) {
			schedule();
		}
	});
	return false;
}

// Stream
var streamSchedule = function(total) {
	var table = jQuery("#schedule");
	jQuery.ajax({
		url: 'http://anitv.foolz.us/schedule.php',
		type: 'GET',
		dataType: 'jsonp',
		jsonpCallback: 'stream',
		async: false,
		data: {
			lastShow: lastShow,
			total: total
		},
		success: function(data, textStatus, jqXHR) {
			if (data.stream != undefined) {
				jQuery.each(data.stream, function(i, value) {
					table.append(format(value));
				});

				jQuery("time").localize('yyyy-mm-dd HH:MM:ss');

				lastShow = data.stream[data.stream.length - 1].id;
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
		},
		complete: function(jqXHR, textStatus) {
		}

	});
	return false;
}

// Update Counter
var schedule = function() {
	var current = Math.round((new Date()).getTime() / 1000);
	var data = jQuery("#schedule td:last-child");
	var kill = 0;
	jQuery.each(data, function(i, value) {
		var that = jQuery(this);
		var countdown = that.data("airtime") - current;

		var key = jQuery("#p" + that.data("id") + " td:first-child");
			key.attr("class", colorize(countdown));

		if (key.hasClass('key-00')) {
			if ((countdown + that.data("duration")) <= 0) {
				jQuery("#p" + that.data("id")).remove();
				kill++;
			}
		}
		jQuery(this).html(getETA(countdown));
	});

	if (kill > 0) {
		streamSchedule(kill);
	}
	setTimeout(schedule, 1000);
}

function colorize(time) {
	if (time <= 0) return 'key-00';
	if (time <= 3600) return 'key-01';
	if (time <= 10800) return 'key-03';
	if (time <= 21600) return 'key-06';
	if (time <= 43200) return 'key-12';
	return 'key-XX';
}

function format(data) {
	var current = Math.round((new Date()).getTime() / 1000);
	return '<tr id="p' + data.id + '" data-anidb="' + data.anidb + '">\n\
			<td class="">&nbsp;</td>\n\
			<td class="' + ((data.anidb) ? 'anidb' : '') + '">' + data.title + '</td>\n\
			<td data-subtitle="' + data.subtitle + '">' + data.episode + '</td>\n\
			<td>' + data.station + '</td>\n\
			<td><time datetime="' + data.gmtime + '">' + data.airtime + '</time></td>\n\
			<td class="eta-countdown" data-id="' + data.id + '" data-airtime="' + data.unixtime + '" data-duration="' + data.duration + '">' + (data.unixtime - current) + '</td>\n\
			</tr>';
}

function getETA(time) {
	var h = Math.floor(time / 3600);
	var m = Math.floor(time / 60) - (h * 60);
	var s = time - (h * 3600) - (m * 60);

	return pad(h, 2) + 'h ' + pad(m, 2) + 'm ' + pad(s, 2) + 's';
}

function pad(num, len) {
	var output = '' + num;
	while (output.length < len) output = "0" + output;
	return output;
}