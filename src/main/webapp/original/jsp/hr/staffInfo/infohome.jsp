<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="hr.Laws.staff.files"
	bundle="${v3xHRI18N}" /></title>
<script language="JavaScript">
var dept_flag = false;
var level_flag = false;
var post_flag = false;
var secondPost_flag = false;
var reporter_flag = false;
var selectType = "";
var Full_valueId = "";
var Full_valueName = "";

var onlyLoginAccount_dept=true;
var onlyLoginAccount_post=true;
var onlyLoginAccount_dept4Out=true;
var onlyLoginAccount_level=true;
var onlyLoginAccount_assistantPosts=true;
var onlyLoginAccount_reporter=true;
var isNeedCheckLevelScope_dept= false;
var isNeedCheckLevelScope_post= false;
var isNeedCheckLevelScope_dept4Out= false;
var isNeedCheckLevelScope_level= false;
var isNeedCheckLevelScope_assistantPosts= false;
var isNeedCheckLevelScope_reporter= false;
var hiddenSaveAsTeam_dept = true;
var hiddenSaveAsTeam_post = true;
var hiddenSaveAsTeam_level = true;
var hiddenSaveAsTeam_dept4Out = true;
var hiddenSaveAsTeam_assistantPosts = true;
var hiddenSaveAsTeam_reporter = true;

var showAllOuterDepartment_dept4Out = true;

var labelnum=0;

function showPage(id,page,index){
	var isNew = "${isNew}";
    if(${infoType}==1 && isNew=="New"){
      alert(v3x.getMessage("HRLang.hr_staffInfo_info_first_label"));
      return;
    }
    try{
    for(var i=1;i<9;i++){
    //document.getElementById('l-'+i).className='tab-tag-left';
    document.getElementById('m-'+i).className='tab-tag-middel';
    //document.getElementById('r-'+i).className='tab-tag-right';
    }
    for(var j = 0;j<labelnum;j++){
    //document.getElementById('l-f-'+j).className='tab-tag-left';
    document.getElementById('m-f-'+j).className='tab-tag-middel';
    //document.getElementById('r-f-'+j).className='tab-tag-right';
    }
    //document.getElementById('l-f-'+index).className='tab-tag-left-sel';
    document.getElementById('m-f-'+index).className='tab-tag-middel-sel';
    //document.getElementById('r-f-'+index).className='tab-tag-right-sel';
    }catch(e){}
    detailIframe.location.href = "${hrStaffURL}?method=userDefinedHome&page_id="+id+'&isReadOnly=ReadOnly&staffId=${staffId}&isManager=${isManager}';
}

function setDept(elements){	
    if (!elements) {
        return;
    }   
    Full_valueName = getNamesString(elements);
    Full_valueId = getIdsString(elements,false);
    dept_flag = true;
    if (parent.selectType != "") {
    	var frameWinow = document.getElementById('detailIframe').contentWindow;
    	if (typeof(frameWinow.setSelectPeopleNameFun) == 'function') {
    		frameWinow.setSelectPeopleNameFun(selectType);
    	}
    } 
}

function setLevel(elements){	
    if (!elements) {
        return;
    }   
    Full_valueName = getNamesString(elements);
    Full_valueId = getIdsString(elements,false);
    level_flag = true;
    if (parent.selectType != "") {
    	var frameWinow = document.getElementById('detailIframe').contentWindow;
    	if (typeof(frameWinow.setSelectPeopleNameFun) == 'function') {
    		frameWinow.setSelectPeopleNameFun(selectType);
    	}
    }
}

function setPost(elements){	
    if (!elements) {
        return;
    }   
	Full_valueName = getNamesString(elements);
    Full_valueId = getIdsString(elements,false);
    post_flag = true;
    if (parent.selectType != "") {
    	var frameWinow = document.getElementById('detailIframe').contentWindow;
    	if (typeof(frameWinow.setSelectPeopleNameFun) == 'function') {
    		frameWinow.setSelectPeopleNameFun(selectType);
    	}
    }
}

function setReporter(elements){	
    if (!elements) {
        return;
    }   
	Full_valueName = getNamesString(elements);
    Full_valueId = getIdsString(elements,false);
    reporter_flag = true;
    if (parent.selectType != "") {
    	var frameWinow = document.getElementById('detailIframe').contentWindow;
    	if (typeof(frameWinow.setSelectPeopleNameFun) == 'function') {
    		frameWinow.setSelectPeopleNameFun("Reporter");
    	}
    }
}

function setSecondPosts(elements){	
    if (!elements) {
        return;
    }    
   	Full_valueName = getNamesString(elements);
    Full_valueId = getIdsString(elements,false);
    secondPost_flag = true;
    if (parent.selectType != "") {
    	var frameWinow = document.getElementById('detailIframe').contentWindow;
    	if (typeof(frameWinow.setSelectPeopleNameFun) == 'function') {
    		frameWinow.setSelectPeopleNameFun(selectType);
    	}
    }
}

// interval obj
var oMarqueen;
// 移动间隔时间
var iInterval = 10;
// 点击一次移动距离
var iSubLength = 72;
// 移动步长
var iStep = 9;
// 初始化
function left(){
	clearInterval(oMarqueen);
	iSubLength = 100;
	oMarqueen = setInterval(MarqueeRight, iInterval);
}

function right(){
	clearInterval(oMarqueen);
	iSubLength = 100;
	oMarqueen = setInterval(MarqueeLeft, iInterval);
}

// 左移函数
function MarqueeLeft() {
	if (document.getElementById('menuTabDiv').offsetWidth
			- document.getElementById('scrollborder').scrollLeft >= 0) {
		iSubLength -= iStep;
		if (iSubLength >= 0) {
			document.getElementById('scrollborder').scrollLeft += iStep
		}
	}
}
// 右移函数
function MarqueeRight() {
	if (document.getElementById('scrollborder').scrollLeft >= 0) {
		iSubLength -= iStep;
		if (iSubLength >= 0) {
			document.getElementById('scrollborder').scrollLeft -= iStep
		}
	}
}
function initTabs(){
    var ccc = parseInt(document.body.clientWidth);
    document.getElementById('scrollborder').style.width = (ccc-70)+"px"
    
    var _flagInput = document.getElementsByName('flagInput');
    if(_flagInput.length>0){
      document.getElementById('menuTabDiv').style.width = (_flagInput.length*92)+"px";
    }
    var main_tableWidth = parseInt(document.getElementById('main-table').clientWidth);
    if  (main_tableWidth <= 0){
    	main_tableWidth = document.getElementById('main-table').parentElement.clientWidth;
    } 
	if(parseInt(document.getElementById('menuTabDiv').clientWidth)>main_tableWidth){
    	document.getElementById('left-td').className='cursor-hand show';
    	document.getElementById('right-td').className='cursor-hand show';
	}
}
function changedType(type,clickDiv){ 
    var isNew = "${isNew}";
  
    if(${infoType}==1 && isNew=="New"){
        alert(v3x.getMessage("HRLang.hr_staffInfo_info_first_label"));
        return;
    }
    //改变页签背景，先把所有设为不选中，再把选中那个背景改变
    try{
	  var menuDiv=document.getElementById("menuTabDiv");
	  var clickDivStyle=clickDiv.className;
	  if(clickDivStyle=="tab-tag-middel-sel"){return;}
	  var divs=menuDiv.getElementsByTagName("div");
	  var i;
	  for(i=0;i<divs.length;i++)
	  {    
	  	clickDivStyle=divs[i].className;  	
	  	if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
	  	{  		
	  		divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
	  	}  	    
	  }
	  for(i=0;i<divs.length;i++)
	  {
	        if(clickDiv==divs[i])
	  	    {
	  	      divs[i-1].className=divs[i-1].className+"-sel";
	  	      divs[i].className=divs[i].className+"-sel";
	  	      divs[i+1].className=divs[i+1].className+"-sel";
	  	    }    
	  }
	  var detailIframe = window.frames["detailIframe"];
      detailIframe.location.href = '${hrStaffURL}?method=initInfoHome&infoType='+type+'&isReadOnly=ReadOnly&staffId=${staffId}&isManager=${isManager}&load=1';
    }catch(e){}
}
</script>
<v3x:selectPeople id="dept" maxSize="1" panels="Department"
	selectType="Department" jsFunction="setDept(elements)" />
<v3x:selectPeople id="dept4Out" maxSize="1" panels="Outworker"
	selectType="Department" jsFunction="setDept(elements)" />
<v3x:selectPeople id="level" maxSize="1" panels="Level"
	selectType="Level" jsFunction="setLevel(elements)" />
<v3x:selectPeople id="post" maxSize="1" panels="Post" selectType="Post"
	jsFunction="setPost(elements)" />
<v3x:selectPeople id="reporter" maxSize="1" panels="Department" selectType="Member"
	jsFunction="setReporter(elements)" />
<c:set
	value="${v3x:parseElements(secondPostList,'secondPostId','secondPostType')}"
	var="secondPosts" />
<v3x:selectPeople id="assistantPosts" panels="Department" minSize="0" 
	selectType="Post" jsFunction="setSecondPosts(elements)"
	originalElements="${secondPosts}" />

</head>
<body class="tab-body" scroll="no" onload="initTabs();">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
            <div id="main-table">
                <div id="left-td" class="cursor-hand hidden" style="width: 23px;float: left;">
                    <div class='mxt_to_left' id='oMxtToLeft'  onclick="left()">
                    </div>
                </div>
                
        		<div id='scrollborder' style='overflow:hidden; height: 26px;width:100%;padding: 0; margin: 0;float:left;'>
                    <div id="menuTabDiv" class="div-float" style="word-break:keep-all;white-space:nowrap;width: auto;">
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-1" class="tab-tag-left-sel" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-1" class="tab-tag-middel-sel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(1,this);" title="<fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-1" class="tab-tag-right-sel" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-2" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-2" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(2,this);" title="<fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-2" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-3" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-3" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(3,this);" title="<fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.family.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-3" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;" url="dd"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-4" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-4" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(4,this);" title="<fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.workRecord.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-4" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;" url="dd"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-5" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-5" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(5,this);" title="<fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.eduAndTrain.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-5" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-6" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-6" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(6,this);" title="<fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.postchange.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-6" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-7" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-7" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(7,this);" title="<fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.assess.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-7" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="l-8" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div id="m-8" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="javascript:changedType(8,this);" title="<fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}' />"><fmt:message key='hr.staffInfo.rewardsAndPunishment.label' bundle='${v3xHRI18N}' /><input type="hidden" name="flagInput"/></div>
                        <div id="r-8" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>                  
                        <c:forEach items="${webPages}" var="webPage" varStatus="status">
                        <script>labelnum++;</script>
                        <div id="l-f-${status.index}" class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                            <div id="m-f-${status.index}" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;width:70px;" onclick="showPage('${webPage.page_id}','${status.count}','${status.index}')" >
                                <c:if test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">${webPage.pageName_zh}</c:if>
                                <c:if test="${v3x:getLocale(pageContext.request) == 'zh_TW'}">${webPage.pageName_zh}</c:if>
                                <c:if test="${v3x:getLocale(pageContext.request) == 'en'}">${webPage.pageName_en}</c:if>
                                <input type="hidden" name="flagInput"/>
                            </div>
                        <div id="r-f-${status.index}" class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                        </c:forEach>
                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                    </div>
                </div>
                
                
                <div style="width: 23px;float: left;" align="right" valign="bottom" class="cursor-hand hidden" id="right-td">
                    <div class='mxt_to_right' id='oMxtToRight' onclick="right()"></div>
                </div>
            </div>

		</td>
	</tr>
	<tr>
		<td class="tab-body-bg" style="margin: 0px;padding:0px;">
		<iframe src="${hrStaffURL}?method=initSpace&infoType=${infoType}&isReadOnly=${isReadOnly}&isManager=${isManager}&staffId=${staffId}&isNew=${isNew}"	id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px" frameborder="0" scrolling="yes"></iframe>
		</td>
	</tr>
</table>
</body>
</html>
