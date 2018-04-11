<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<html class="h100b over_hidden">
<title>${ctp:i18n('calendar.event.calendar.view.title')}</title>
<head>
<style>
.common_tabs li {
	padding-left: 0px;
	padding-right: 0px;
	align: center
}
.common_tabs li a {
	padding-left: 0px;
	padding-right: 0px;
	text-align: center
}
</style>
<c:set value="${v3x:parseElements(personList, 'id', 'entityType')}" var="othersList"/>

<v3x:selectPeople id="others" departmentId="${CurrentUser.departmentId}" panels="Department,Team,Outworker" originalElements="${othersList}" maxSize="20" selectType="Member" jsFunction="showOtherPeopleMeetings(elements, 'othersId', 'othersName')" showMe="false"/>

<script type="text/javascript">

var excludeElements_others;
var elements_othersArr = elements_others;

var maxLen = 10;
var width = 600;

function selectOtherPeople(selectPeopleId, idElem) {
	eval('selectPeopleFun_'+selectPeopleId+'()');
}

function showOtherPeopleMeetings(elements,idElem,nameElem){
	elementsIds = getIdsString(elements, false);
	if(elementsIds.trim() != '') {
		initParameters(elementsIds, elements);
		changePersonTab(elementsIds.split(",")[0]);//取选人界面中第一个人员ID来显示OA-44871
		elements_othersArr = elements;
	}
}

function initParameters(elementsIds, elements) {
	var perId = '${CurrentUser.id}';
	var persons = elements;
	
	document.getElementById("firstIndex").value = '0';
	document.getElementById("lastIndex").value = maxLen;
	
	document.getElementById("personCount").value = 1 + persons.length;
	document.getElementById("perId").value = perId;
	
	document.getElementById("perIds").value = elementsIds;
	document.getElementById("perNames").value = getNamesString(elements, ",");
}

function loadUE() {
	var navlineTop = 0;
	var navlineHeight = 30;
	$("div.dhx_cal_navline").css({height:navlineHeight+"px"});
	$("div.dhx_cal_navline").css({top:navlineTop+"px"});
	
	var headerTop = navlineTop + navlineHeight;
	var headerHeight = $("div.dhx_cal_header").height();
	$("div.dhx_cal_header").css({top : headerTop + "px"});
	
	var dayTop = headerTop + headerHeight;
	var dayHeight = $("div.dhx_multi_day").height();
	$("div.dhx_multi_day").css({top: dayTop + "px"});
	
	var dataTop = dayTop + dayHeight;
	$("div.dhx_cal_data").css({top : dataTop + "px"});
	
	$("#personTab").css({"padding-top" : "0px"});
}

function initPersonTab() {
	
	loadUE();
	
	$("#personTab").html("");
	
	var left = parseInt(document.getElementById("left").value);
	var tabWidth = parseInt(document.getElementById("tabWidth").value);

	var leftTab = "";
	var rightTab = "";
	var middleTab = "";
	var divTab = "";
	
	var tabLeft = 0;
	var firstIndex = 0;
	var lastIndex = maxLen;
	if(document.getElementById("firstIndex").value != '') {
		firstIndex = parseInt(document.getElementById("firstIndex").value);
	}
	if(document.getElementById("lastIndex").value != '') {
		lastIndex = parseInt(document.getElementById("lastIndex").value);
	}
	
	var perId = '${CurrentUser.id}';

	var persons = [];
	<c:if test="${persons != null}">
		persons = eval(${persons});
		perId = '${param.perId}';
		document.getElementById("perId").value = '${param.perId}';
		document.getElementById("perIds").value = '${param.perIds}';
	</c:if>
	
	width = $("div.dhx_cal_navline").width();
	var perWidth = width - 260;
	if(perWidth/tabWidth < 3) {
		maxLen = 2;
	} else if(perWidth/tabWidth < 8) {
		maxLen = 4;
	}

	if(persons==null || persons.length==0) {
		return;
	}

	if(persons.length+1 > maxLen) {
		left = 15;
	}
	var name = "${v3x:toHTML(CurrentUser.name)}";
	if (name.length > 3) {
		name = name.substring(0,2) +"..";
	}
	divTab = '<li class="current"><a index="0" id="${CurrentUser.id}" hideFocus="true" style="border-left: 1px solid #B6B6B6; border-right: 1px solid #B6B6B6;border-top: 1px solid #B6B6B6;" href="javascript:void(0)" onClick="changePersonTab(this.id)" title="${v3x:toHTML(CurrentUser.name)}">'+name+'</a></li>';
	middleTab += divTab;

	for(var i=0; i<persons.length; i++) {
		var name = persons[i].name;
		if (name.length > 3) {
			name = name.substring(0,2) +"..";
		}
		//divTab = "<div class='dhx_cal_tab_person' index='"+(i+1)+"' id='"+persons[i].id+"' onClick='changePersonTab(this.id)'>"+persons[i].name+"</div>";
		divTab = '<li><a index="'+(i+1)+'" id="'+persons[i].id+'" hideFocus="true" style="border-left: 0px; border-right: 1px solid #B6B6B6;border-top: 1px solid #B6B6B6;" href="javascript:void(0)" onClick="changePersonTab(this.id)" title="'+persons[i].name+'">'+name+'</a></li>';
		middleTab += divTab;
	}
	
	if(persons.length+1 > maxLen) {
		tabLeft = left + tabWidth*maxLen;
		leftTab = "<div class='dhx_cal_prev_button' style='left:0px' onClick='personTabToLast(this)'></div>";
		rightTab = "<div class='dhx_cal_next_button' style='left:" + tabLeft + "px' onClick='personTabToNext(this)'></div>";
	}
	
	$("#personTab").html(leftTab+middleTab+rightTab);
	
	document.getElementById("left").value = left;
	document.getElementById("firstIndex").value = firstIndex;
	document.getElementById("lastIndex").value = lastIndex;
	document.getElementById("personCount").value = 1 + persons.length;
	document.getElementById("perId").value = perId;

	showPersonDiv();
}

function showPersonDiv() {
	var left = parseInt(document.getElementById("left").value);
	var tabWidth = parseInt(document.getElementById("tabWidth").value);
	var firstIndex = document.getElementById("firstIndex").value;
	var lastIndex = document.getElementById("lastIndex").value;
	var perId = document.getElementById("perId").value;
	var tab_persons = $("#personTab");	
	
	var tabLeft = 0;
	var visibleIndex = 0;
	tab_persons.find("li").each(function(i) {
		$(this).removeClass("current");
		if(i<firstIndex || i>=lastIndex) {
			$(this).hide();
		} else {
			$(this).show();
			tabLeft = left + tabWidth * visibleIndex;
			$(this).css("left", tabLeft+"px");
			var liA = $(this).find("a");
			if(liA.attr("id") == perId) {
				$(this).addClass("current");
			}
			visibleIndex++;
		}
	});
	
}

//人员切换
function changePersonTab(perId) {
	var meetingForm = document.getElementById("meetingForm");
	document.getElementById("perId").value = perId;
	meetingForm.action = _ctxPath + "/meetingView.do?method=arrangeTime&type=week";
	meetingForm.submit();
}

//人员切换-上一个
function personTabToLast(arrowObj) {
	var firstIndex = parseInt(document.getElementById("firstIndex").value);
	var lastIndex = parseInt(document.getElementById("lastIndex").value);
	var personCount = parseInt(document.getElementById("personCount").value);
	
	if(firstIndex == 0) {
		return;
	}

	firstIndex = firstIndex - 1;
	lastIndex = lastIndex - 1;
	
	document.getElementById("firstIndex").value = firstIndex;
	document.getElementById("lastIndex").value = lastIndex;
	
	showPersonDiv();
}

//人员切换-下一个
function personTabToNext(arrowObj) {
	var firstIndex = parseInt(document.getElementById("firstIndex").value);
	var lastIndex = parseInt(document.getElementById("lastIndex").value);
	var personCount = parseInt(document.getElementById("personCount").value);
	
	if(lastIndex >= personCount) {
		return;
	}

	firstIndex = firstIndex + 1;
	lastIndex = lastIndex + 1;

	document.getElementById("firstIndex").value = firstIndex;
	document.getElementById("lastIndex").value = lastIndex;
	
	showPersonDiv();
	
}

//上一周/下一周切换
function dateChangeOfMeeting(type, nextDate) {
	var url = _ctxPath + "/meetingView.do?method=arrangeTime&type=week&app=${param.app}";
	try {
		var temp=nextDate.split('-');
		nextDate = new Date(temp[0], (temp[1]-1), temp[2]);
	} catch(e) {}
	var selectedDate = nextDate.format("yyyy-MM-dd");
	var meetingForm = document.getElementById("meetingForm");
	document.getElementById("selectedDate").value = selectedDate;
	meetingForm.action = url;
	meetingForm.submit();
}

</script>
</head>
<body>

<form id="meetingForm" method="post">
	<input type="hidden" id="tabWidth" name="tabWidth" value="44"/><!-- 人员页签宽度 -->
	<input type="hidden" id="left" name="left" value="15" /><!-- 每一个人员页签左坐标 -->
	<input type="hidden" id="firstIndex" name="firstIndex" value="${param.firstIndex }" /><!-- 当页第一个页签下标 -->
	<input type="hidden" id="lastIndex" name="lastIndex" value="${param.lastIndex }" /><!-- 当页最后一个页签下标 -->
	<input type="hidden" id="personCount" name="personCount" value="${param.personCount}" /><!-- 人员共个数 -->
	<input type="hidden" id="app" name="app" value="${param.app }"/><!-- 我的会议日程视图标识 -->
	<input type="hidden" id="perId" name="perId" value="${param.perId }" /><!-- 当前选中页签人员id -->
	<input type="hidden" id="perIds" name="perIds" value="${param.perIds }" /><!-- 所有页签人员id -->
	<input type="hidden" id="perNames" name="perNames" value="${param.perNames}" /><!-- 所有页签人员name -->
	<input type="hidden" id="replyState" name="replyState" value="${param.replyState }"/><!-- 回执状态 -->
	<input type="hidden" id="selectedDate" name="selectedDate" value="${param.selectedDate }" /><!-- 上一周/下一周查询时间 -->
</form>
<!-- 
<iframe name="meetingFormTarget" style="height:0%;width:0%;display:none" />
 -->
</body>
</html>