$(function(){
	var curr_date = $("INPUT.datepicker").val();
	$("INPUT.datepicker").datepicker({
		defaultDate: curr_date,
		dateFormat: "yy-mm-dd",

		onSelect: function(dateText, inst) {
			$("INPUT.datepicker").val(dateText);
		}
	})
});
