$(function() {
	$(".nbtn").parent("div").attr("title", "");
	$(".nbtn").attr("title", "");
	$(".nbtn").parent("div").css("padding","1");
	$(".nbtn").parent("div").css("height","65%");
	$(".nbtn").click(function(e){
		var nul=$(".nUL"); //菜单div
		var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
		nul.toggleClass("hidden");
		nul.css({"left":left+"px","top":"25px"});
		addEvent(document.body,"mousedown",clickOther);
	});
	if(hasSubjectWrap == "true") {
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}
});
function init() {}