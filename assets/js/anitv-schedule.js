jQuery(document).ready(function() {
	loadSchedule();
});

// Load Schedule
var loadSchedule = function() {
	var table = jQuery("#schedule");
	jQuery.ajax({
		url: 'json.php',
		type: 'GET',
		dataType: 'json',
		data: {
			controller: 'schedule'
		},
		success: function(data, textStatus, jqXHR) {
			if (data.programs != undefined) {
				jQuery.each(data.programs, function(i, value) {
					table.append(format(value));
				});

				jQuery("time").localize('yyyy-mm-dd HH:MM:ss');
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
		},
		complete: function(jqXHR, textStatus) {
			schedule();
		}
	});
}

// Stream
var streamSchedule = function(total) {
	var table = jQuery("#schedule");
	jQuery.ajax({
		url: 'json.php',
		type: 'GET',
		dataType: 'json',
		data: {
			controller: 'stream',
			total: total
		},
		success: function(data, textStatus, jqXHR) {
			if (data.programs != undefined) {
				jQuery.each(data.programs, function(i, value) {
					table.append(format(value));
				});

				jQuery("time").localize('yyyy-mm-dd HH:MM:ss');
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
		var countdown = that.data("unixtime");

		var key = jQuery("#p" + that.data("id") + " td:first-child");
			key.attr("class", colorize(countdown - current));

		if (key.hasClass('key-00')) {
			if ((countdown - current + that.data("duration")) <= 0) {
				jQuery("#p" + that.data("id")).remove();
				kill++;
			}
		}
		jQuery(this).html(getETA(countdown - current));
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
	return '<tr id="p' + data.id + '">\n\
			<td class="">&nbsp;</td>\n\
			<td class="' + ((data.anidb) ? 'anidb' : '') + '">' + ((data.anidb) ? '<a href="http://anidb.info/a' + data.anidb + '" target="_blank" class="anidb-link">' + data.title + '</a>' : data.title) + '</td>\n\
			<td data-subtitle="' + data.subtitle + '">' + data.episode + '</td>\n\
			<td>' + data.station + '</td>\n\
			<td><time datetime="' + data.gmtime + '">' + data.airtime + '</time></td>\n\
			<td class="eta-countdown" data-id="' + data.id + '" data-airtime="' + data.unixtime + '" data-duration="' + data.duration + '">' + (data.unixtime - current) + '</td>\n\
		</tr>';
}

function getETA(time) {
	if (time < 0)
		return 'Now Playing...';

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
