jQuery(document).ready(function() {
	loadHistory();
});

// Load Schedule
var loadHistory = function() {
	var table = jQuery("#history");
	jQuery.ajax({
		url: 'json.php',
		type: 'GET',
		dataType: 'json',
		data: {
			controller: 'history'
		},
		jsonpCallback: 'history',
		success: function(data, textStatus, jqXHR) {
			if (data.records != undefined) {
				jQuery.each(data.records, function(i, value) {
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
}

function format(data) {
	var changelog = "";

	if (data.orig_romaji != data.romaji)
		changelog = "Modified Romaji Title from " + data.orig_romaji + " to " + data.romaji + " by " + data.user + ".";
	if (data.orig_title != data.title)
		changelog = "Modified English Title from " + data.orig_title + " to " + data.title + " by " + data.user + ".";
	if (data.orig_anidb != data.anidb)
		changelog = "Modified AniDB ID from " + data.orig_anidb + " to " + data.anidb + " by " + data.user + ".";

	return '<tr>\n\
			<td><time datetime="' + data.last_updated +'">' + data.last_updated + '</time></td>\n\
			<td>' + data.program + '</td>\n\
			<td>' + changelog + '</td>\n\
		</tr>';
}