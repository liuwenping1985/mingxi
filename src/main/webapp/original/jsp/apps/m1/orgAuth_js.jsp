<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.m1.authorization.resouces.i18n.MobileManageResources" var="mobileManageBundle"/>
<link type="text/css" rel="stylesheet"  href="<c:url value='/apps_res/m1/css/orgAuth.css${v3x:resSuffix()}' />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" 
src="<c:url value='/apps_res/m1/js/SimpleMap.js${v3x:resSuffix()}'/>">
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<!DOCTYPE html>
<script type="text/javascript">
$().ready(function() {
	hideButtonArea("<c:out value='${authedType}'/>");
  //页面按钮
	$('#toolbar').toolbar({
	    toolbar: [{
	      id: "editAuthed",
	      name: "${ctp:i18n('common.button.modify.label')}",
	      className: "ico16 editor_16",
	      click: editAuthed
	    }]
	  });
	
	init_page("<c:out value='${authedIdNames}'/>","<c:out value='${orgCount}'/>","<c:out value='${concurrentMembers}'/>",
			"<c:out value='${authedStr}'/>","<c:out value='${authedType}'/>","<c:out value='${allauthed}'/>",
			"<c:out value='${authedCount}'/>","<c:out value='${groupCount}'/>"); 
	showCtpLocation('M01_orgAuth');
	$('#viewStr').click(function(){
		document.getElementById("authe_div").style.display = "none";
		document.getElementById("groupCount_countle_div").style.display = "none";
		document.getElementById("orgCount_countle_div").style.display = "none";
		select_user_pop(<c:out value="${serverusable}"/>);
	});
	$("#button_area").hide();
	$('#btnsubmit').click(function(){
			submit_form();	
	}); 
	$('#btncancel').click(function(){
			hidden_edit();
	});
	});
	
var orgCount = null;
var authedIdNames = null;
var editFlag = false;
var canSubmit = false;
var authedConurrent = new Array();
var map = new SimpleMap(); 
var authedType = 0;
var allauthed = 0;
var authedIdStr = null;
var authedNum = 0;
var groupNum = null;

function editAuthed(){
	$('#viewStr').attr("disabled",false);
	$("#button_area").show();
	$("#authe_div").hide();
	$("#orgCount_countle_div").hide();	
	$("#groupCount_countle_div").hide();
	canSubmit = true;

}
function hideButtonArea(authedType){
	if (authedType == 1){
		$('#toolbar').hide();
	}
	
}

function init_page( names, count,authConurrent, authedStr, type,allauth,authedCount,groupCount) {
		authedIdNames = names;
		orgCount = count ;
		authedType = type;
		authedIdStr = authedStr;
		allauthed = allauth;
		authedNum = authedCount;
		groupNum = groupCount;
		if (authedIdNames.length > 0) {
			var arr = authedIdNames.split(",");
			var viewStr = "";
			for  (var i = 0; i < arr.length; i++) {
				var subArr = arr[i].split("|");
				if (subArr.length == 2) {
					var name = "" + subArr[1];
					if (i > 0)
						viewStr += ",";
					viewStr += name;
				}
			}
			document.getElementById("viewStr").value = viewStr;
		}
		if (authConurrent .length > 0) {
			var arr = authConurrent.split(",");
			for  (var i = 0; i < arr.length; i++) {
				var subArr = arr[i].split("|");
				if (subArr.length ==2) {
					var user_id = subArr[0];
					var name = subArr[1];
					authedConurrent[i] = user_id;
					map.put(user_id,name);
					
				}
			}
		}
}
function show_edit() {
	document.getElementById("edit_tr").style.display = "block";
	document.getElementById("viewStr").style.color = "black";
	editFlag = true;
	canSubmit = true;
}
function hidden_edit() {
	$('#viewStr').attr("disabled",true);
	$("#button_area").hide();
	$("#authe_div").hide();
	$("#orgCount_countle_div").hide();	
	$("#groupCount_countle_div").hide();
	init_page("<c:out value='${authedIdNames}'/>","<c:out value='${orgCount}'/>","<c:out value='${concurrentMembers}'/>",
			"<c:out value='${authedStr}'/>","<c:out value='${authedType}'/>","<c:out value='${allauthed}'/>",
			"<c:out value='${authedCount}'/>","<c:out value='${groupCount}'/>"); 
	
	document.getElementById("edit_tr").style.display= "none";
	document.getElementById("viewStr").style.color = "gray";
	
	editFlag = false;
	canSubmit = false;
}
function select_user_pop(usable) {
	if (editFlag){}
	if (usable == true) {
		selectPeopleFun_pop();
	}
	
}
var onlyLoginAccount_pop = true;
//var showConcurrentMember_pop = false;
var authedMember = new Array();
var authed = 0;
var unauthed = 0;

function selected_users(elements){ 
	if(elements){ 
		var typeIds = getIdsString(elements);
		var elementStrings = getNamesString(elements);
		var nameStringArray =  new Array();
		if  (elementStrings.indexOf("undefined") > 0) {
			nameStringArray = getNamesString(elements).split("undefined") ;
		} else {
			nameStringArray = getNamesString(elements).split(",") ;
		}
		var authedCount = 0;
		var	unAuthedIds = "";
		var nameString = "";
		if (typeIds && typeIds.length > 0) {
			var arr = typeIds.split(",");
			if (arr && arr.length > 0) {
				if (authedConurrent.length == 0 ) {
					authedCount = arr.length;
					nameString = getNamesString(elements);
					} else {
						for (var i = 0 ;i < arr.length ; i ++) {
							for (var n = 0 ; n < authedConurrent.length ; n++) {
								if (arr[i].indexOf(authedConurrent[n]) > 0){
									authedMember[authed++] =arr[i];
									arr[i] = "";
								}
							}
							if (arr[i] != "") {
								 unAuthedIds  += arr[i] + ",";
								 nameString += nameStringArray[i] + ",";
							}
						}
						authedCount = arr.length - authed; // 已经注册数量   
						typeIds = unAuthedIds;
					}
			} 
		}
		document.getElementById("authStr").value = typeIds; 
		if (nameString.indexOf("undefined") != -1) {	
			nameString = nameString.replace(/undefined/g,",");
		}
		document.getElementById("viewStr").value = nameString;
		//集团控制注册数时，已经授权的数量
		var authedC = parseInt(allauthed) + parseInt(authedCount) - parseInt(authedNum);
		if (authedType == 23){
			document.getElementById("authableNum_td_1").innerHTML = authedCount;
			document.getElementById("authableNum_td").innerHTML = groupNum - authedC;
			document.getElementById("authedCount_td").innerHTML = authedC;
		} else {
			document.getElementById("authableNum_td").innerHTML = orgCount - authedCount;
			document.getElementById("authedCount_td").innerHTML = authedCount;
		}
		//提示消息div显示
		if (orgCount - authedCount < 0 && authedType == 22) {
			document.getElementById("authe_div").style.display = "none";
			document.getElementById("orgCount_countle_div").style.display = "block";
			canSubmit = false;
		} else if (authedC - groupNum > 0 && authedType == 23) {
			
			document.getElementById("authe_div").style.display = "none";
			document.getElementById("groupCount_countle_div").style.display = "block";
			canSubmit = false;
		} else {
			document.getElementById("groupCount_countle_div").style.display = "none";
			document.getElementById("orgCount_countle_div").style.display = "none";
			canSubmit = true;
		} 
		var errorString = document.getElementById("checkinfo").value;
		var repeatInfo = document.getElementById("authrepeat").value;
		if (authed > 0) {
			for (var i = 0 ; i < authedMember.length ; i++) {
				var info = map.get(authedMember[i].split("|")[1]);
				var name = info.split("#");
				var temp = repeatInfo.replace("1|",name[0]);
				temp = temp.replace("2|",name[1]) + ";";
				
				errorString += temp ;
				temp = null;
			}
			document.getElementById("authe_div").style.display = "block";
			document.getElementById("authe_div").innerHTML = errorString;
			errorString = "";
			authed = "";
			authedMember = new Array();
		}
		if (authedIdStr == typeIds || typeIds == authedIdStr + ","){
			canSubmit = true;
		}
		
		
	}
}
function submit_form() {
	if (canSubmit)
		document.getElementById("auth_form").submit();
}
</script>