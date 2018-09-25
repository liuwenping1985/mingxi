$(function(){
	$(".nbtn").parent("div").css("padding","0");
	$(".nbtn").click(function(e){
		var nul=$(".nUL"); //菜单div
		var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
		nul.toggleClass("hidden");
		nul.css({"left":left+"px","top":"25px"});
		addEvent(document.body,"mousedown",clickOther);
	});
	if(hasSubjectWrap) {
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}
});
function init(){}
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	//7:收文-待阅
	var listType = 7;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}