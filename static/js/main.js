if (typeof(window.console) == "undefined") { console = {}; console.log = console.warn = console.error = function(a) {}; }

var ledOnHtml = '<span class="glyphicon glyphicon-eye-open"></span>';
var ledOffHtml = '<span class="glyphicon glyphicon-eye-close"></span>';

$(function () {
	$("#setStateBlue").html(ledOnHtml);
	$("#setStateRed").html(ledOnHtml);
	var host = location.host;
	var ws = new WebSocket("ws://" + host + "/connect");

	$("#setStateBlue").click(function () {
		var btn = this;
		toggleIcon(btn, "blue");
	});
	$("#setStateRed").click(function () {
		var btn = this;
		toggleIcon(btn, "red");
	});
	function toggleIcon(btn, color) {
		var html = $(btn).html();
		var state = 0;
		if (html === ledOnHtml) {
			$(btn).html(ledOffHtml);
			state = 1;
		}
		else {
			state = 0;
			$(btn).html(ledOnHtml);
		}
		ws.send("set_state_" + color + ":" + state);
	}

	$('form input').keydown(function(event){
		if(event.keyCode == 13) {
	    	event.preventDefault();
	    	setAngle();
	    	return false;
	    }
	});

	$('#servoAngleSlider').slider({
		formater: function(value) {
			return 'Current value: ' + value;
		},
	});
	$("#servoAngleSlider").on("slide", function(slideEvt) {
		var angle = slideEvt.value;
		ws.send("set_angle:"+angle);
	});
});