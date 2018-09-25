var projectBodyEnum = new Array();

projectBodyEnum[0] = {
	srcFlag : ".psml?showState=show",
	phaseFlag : "sprint"
};

projectBodyEnum[1] = {
	srcFlag : "&phaseId=",
	phaseFlag : "phaseId"
};

projectBodyEnum[2] = {
	srcFlag : "&projectPhaseId=",
	phaseFlag : "projectPhaseId"
};


function getProjectBodyByUrl(bodyUrl){
	for(var i=0;i<projectBodyEnum.length;i++){
		var projectBody = projectBodyEnum[i];
		if(bodyUrl.indexOf(projectBody.srcFlag) > -1){//找到匹配的URL则直接返回
			return projectBody;
		}
	}
	return null;
}

var projectSpaceObj = new Object();
/**监听空间头的onload事件*/
function projectHeadListener(){
	$("#head")[0].contentWindow.changePhaseCallBack = function(value){
		var bodyUrl = $("#body").attr("src");
		/**以下操作就是找到阶段参数，然后将其remove掉*/
		var arrayUrl = bodyUrl.split(projectSpaceObj.projectBody.phaseFlag + "=");
		var urlPre = arrayUrl[0] + projectSpaceObj.projectBody.phaseFlag + "=" + value;
		var urlAfter = "";
		if(arrayUrl[1].indexOf("&") > -1){
			urlAfter = arrayUrl[1].substring(arrayUrl[1].indexOf("&"));
		}
		var url = urlPre + urlAfter;
		//OA-75992 任务状态统计栏目进入穿透页面后，只要切换阶段就会弹出人员穿透查看数据不一致的提示
		url = url.replace("isTaskStatistic=true","");
		$("#body").attr("src",url);
	}
}
/**添加面包屑*/
function init_location4roject(){
	var projectId = $("#projectId").val();
	var projectName = escapeStringToHTML($("#projectName").val(),false);
	var from = $("#from").val();
	
	var skinPathKey = getCtpTop().skinPathKey == null ? "harmony" : getCtpTop().skinPathKey;
	var html = "";
	if(from == "fromSpace"){
		html = '<span class="nowLocation_ico"><img src="'+_ctxPath+'/main/skin/frame56/'+skinPathKey+'/menuIcon/relateproject.png"></span>'
	}else{
		html = '<span class="nowLocation_ico">'+getCtpTop().$("#nowLocation").find(".nowLocation_ico").html()+'</span>';
	}
	html += '<span class="nowLocation_content">';
	html += '<a>' + escapeStringToHTML($.i18n('system.menuname.ManagementbyObjectives'),false) + '</a>';
	//项目/任务
	html += ' &gt; ';
	html += '<a class="hand" href="#" onclick="showMenu(\'/seeyon/project/project.do?method=projectAndTaskIndex&pageType=project\')">' + escapeStringToHTML($.i18n('project.task.menu.name'),false) + '</a>';
	//项目名称
	html += ' &gt; ';
	html += '<a class="hand" href="#" onclick="showMenu(\'/seeyon/project/project.do?method=projectSpace&projectId=' + projectId + '\')">' + getNewStr(projectName,80) + '</a>';
	html += '</span>';
	
	getCtpTop().showLocation(html);
}
/**监听空间体的onload事件*/
function projectBodyListener(){
	var bodyUrl = $("#body").attr("src");
	projectSpaceObj.projectBody = getProjectBodyByUrl(bodyUrl);
}
/**
   *手动编写截取标题长度js
   */
function getNewStr(pStr,afterLen){
 	var _RelLenth;
 	var _newStr;
 	for(var i=0;i<pStr.length&&afterLen>0;i++){
 		if(pStr.charCodeAt(i)>127 || pStr.charCodeAt(i)==94){
 			if(afterLen>1){
 				afterLen-=2;
 			}else{
 				break;
 			}
 		}else{
 			afterLen--;
 		}
 	}
 	_newStr=pStr.substring(0,i);
 	if(i<pStr.length){
 		_newStr=_newStr+"...";
 	}
 	return _newStr;
 }