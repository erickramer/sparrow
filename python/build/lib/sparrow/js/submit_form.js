function create_table(data){

	function make_row(x, y){
		return "<tr><td>" + x + "</td><td>" + y + "</td></tr>"
	}

	$('#result_table').empty()
	$('#result_table').append(make_row("prediction", data.prediction))
}

$("input#submitButton").click( function(){
	$.ajax({
	    url: $('#form').attr('url'),
	    type: 'post',
	    dataType: 'json',
	    data: $('#form').serialize(),
	    success: create_table
	})

	event.preventDefault()
})