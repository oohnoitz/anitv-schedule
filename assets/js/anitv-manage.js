jQuery(document).ready(function() {
	var oManager = jQuery("#manage").dataTable({
		"bProcessing": true,
		"bServerSide": true,
		"sAjaxSource": 'system/manage.php',
		"fnDrawCallback": function() {
			jQuery("#manage tbody td").editable('system/editor.php', {
				"callback": function(sValue, y) {
					oManager.fnDraw();
				},
				"submitdata": function(value, settings) {
					return {
						"id": this.parentNode.getAttribute('id'),
						"field": oManager.fnGetPosition(this)[2]
					}
				},
				"height": '14px'
			});
		}
	});
});