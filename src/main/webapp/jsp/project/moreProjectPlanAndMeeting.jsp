<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@include file="projectHeader.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>
<script type="text/javascript">
	//getA8Top().hiddenNavigationFrameset();//隐藏当前位置
	
	function openCal(url){
		var result = getA8Top().v3x.openWindow({
				url:  url,
				width:"580",
			    height:"450",
				scrollbars:"no"
		});
	}
		
	function openDetailURL(title,URL){
		var rv = v3x.openWindow({
	        url: URL,
	        dialogType: 'open'
		});
		/*
		  var calDialogTest = v3x.openDialog({
            id: "calDialog",
            title: title,
            url:URL,
            height:getA8Top().outerHeight - 200,
            width:getA8Top().outerWidth - 100,
            targetWindow : getA8Top() 
        });*/
	}
	
	function showNextSpecialCondition(conditionObject) {
	    var options = conditionObject.options;
	    for (var i = 0; i < options.length; i++) {
	        var d = document.getElementById(options[i].value + "Div");
	        if (d) {
	            d.style.display = "none";
	        }
	    }
		if(document.getElementById(conditionObject.value + "Div") == null) return;
	    document.getElementById(conditionObject.value + "Div").style.display = "block";
	}
	
	function queryMoreProjectPlanAndMeetingByCondition() {
		 var condition = document.getElementById('condition').value;
	        if (condition == 'newDate') {
	            return dateCheck();
	        } else {
	        	searchForm.submit();
	        }
	}
	
	function init(){
		var titleDiv = document.getElementById("titleDiv");
		var authorDiv = document.getElementById("authorDiv");
		var newDateDiv = document.getElementById("newDateDiv");
		if ("${condition }" == "title") {
			titleDiv.style.display = "block";
			authorDiv.style.display = "none";
			newDateDiv.style.display = "none";
		} else if ("${condition }" == "author") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "block";
			newDateDiv.style.display = "none";
		} else if ("${condition}" == "newDate") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "none";
			newDateDiv.style.display = "block";
		} else if ("${condtion}" == "choice") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "none";
			newDateDiv.style.display = "none";
		}
		
		var top_div_row2 = document.getElementById("top_div_row2");
		var scrollListDiv = document.getElementById("scrollListDiv");
		var scrollbDivplans = document.getElementById("bDivplans");
		top_div_row2.style.position="relative";
		top_div_row2.style.height="";
		scrollListDiv.style.position="relative";
		scrollListDiv.style.top="5px";
		scrollListDiv.style.bottom="0px";
		scrollListDiv.style.height = document.body.clientHeight - 35 + "px";
		//设置列表内容的高度使其可以铺满一页
		scrollbDivplans.style.height = document.body.clientHeight - 35-32-30 + "px";
	}

	function doMySearchEnter(){
		var evt = v3x.getEvent();
	    if(evt.keyCode == 13){
	    	queryMoreProjectPlanAndMeetingByCondition();
	    }
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<body scroll="no" onload="init()"  class="with-header-tab">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div id="top_div_row2">
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		 <%@ include file="moreProjectBanner.jsp"%>
		  <tr>
		    <td height="30">
		     <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border gov_noborder">
		        <tr>
		            <td>
					   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table">
					   <tr>
					    <td class="webfx-menu-bar" > 
						  &nbsp;&nbsp;<fmt:message key="project.info.planAndMtAndEvent" />
						</td>
						<td class="webfx-menu-bar" >
							<form action="" id="searchForm" name="searchForm" method="get" onkeydown="doMySearchEnter()">
									<input type="hidden" name="method" value="queryMoreProjectPlanAndMeetingByCondition">
									<input type="hidden" name="projectId" value="${projectId}">
									<input type="hidden" name="phaseId" value="${phaseId}">
									<input type="hidden" name="managerFlag" id="managerFlag" value="${param.managerFlag }" />
							    	<div class="div-float-right" style="vertical-align:middle;">
							    		<div class="div-float">
											<select name="condition" style="height:22px;" id="condition" onChange="showNextSpecialCondition(this)" class="">
										    	<option value="choice" <c:if test="${condition == 'choice' }">selected</c:if>><fmt:message key="project.planandmetting.select.info"/></option>
											    <option value="title" <c:if test="${condition == 'title' }">selected</c:if>><fmt:message key="project.planandmetting.select.title"/></option>
											    <option value="author" <c:if test="${condition == 'author' }">selected</c:if>><fmt:message key="project.planandmetting.select.create.people"/></option>
											    <option value="newDate" <c:if test="${condition == 'newDate' }">selected</c:if>><fmt:message key="project.planandmetting.select.create.time"/></option>
										  	</select>
									  	</div>
									  	<div id="titleDiv" class="div-float hidden">
											<input type="text" name="title" value="${v3x:toHTML(title)}" class="textfield-search" onkeydown="">
									  	</div>
									  	<div id="authorDiv" class="div-float hidden">
											<input type="text" name="author" value="${v3x:toHTML(author)}" class="textfield-search" onkeydown="">
									  	</div>
									  	<div id="newDateDiv" class="div-float hidden">
											<input type="text" id="startdate" name="beginTime" value="${beginTime }" class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
											<input type="text" id="enddate" name="endTime" value="${endTime }" class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
										</div>	
									  	<div id="grayButton" onclick="queryMoreProjectPlanAndMeetingByCondition()" class="div-float condition-search-button"></div>
							    	</div>
							    </form>
								</td>
							   </tr>
							</table>
						</td>
						</tr>
						</table>
					</td>
					</tr>
				</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
	    <form>
		<v3x:table htmlId="plans" leastSize="0" data="mtAndPlanList" var="mtPlan" pageSize="20" showHeader="true" showPager="true" size="1">
		<v3x:column align="left" width="50%" label="common.subject.label" bodyType="${mtPlan.bodyType}" alt="${mtPlan.subject}" hasAttachments="${mtPlan.attsFlag}" type="String">
						<c:choose>
				<c:when test="${mtPlan.app==5 }">
					<a class="title-more" href="javascript:openDetailURL('${v3x:toHTML(mtPlan.subject)}','${planURL}?method=initPlanDetailFrame&dataSource=project&editType=${sessionScope['com.seeyon.current_user'].id==mtPlan.memberId ? 'summary' : 'reply' }&planId=${mtPlan.objectId }')" title="${v3x:toHTML(mtPlan.subject)}">
				</c:when>
				<c:when test="${mtPlan.app==6 }">
					<a class="title-more" href="javascript:openDetailURL('${v3x:toHTML(mtPlan.subject)}','${mtURL}?method=myDetailFrame&id=${mtPlan.objectId }&state=${mtPlan.state}')" title="${v3x:toHTML(mtPlan.subject)}">
					<c:if test="${mtPlan.meetingType eq  '2' }">
						<span class="bodyType_videoConf inline-block"></span>
					</c:if>
				</c:when>
				<c:when test="${mtPlan.app==11}">
<%-- 			<a class="title-more" href="javascript:openCal('${calEventURL}?method=editCalEvent&id=${mtPlan.objectId}')" title="${v3x:toHTML(mtPlan.subject)}"> --%>
                <a class="title-more" href="javascript:addCal('1','${mtPlan.objectId}','${calEventUpdateMap[mtPlan.objectId]||mtPlan.memberId==CurrentUser.id}')" title="${v3x:toHTML(mtPlan.subject)}">
		</c:when>
				<c:otherwise>
					<a href="javascript:void(null)" class="title-more">
				</c:otherwise>
			</c:choose>
			${v3x:toHTML(v3x:getLimitLengthString(mtPlan.subject,50,"..."))}</a>
					</v3x:column>
					
					<v3x:column width="15%" type="String" label="common.creater.label" align="center" maxLength="20" className="cursor-hand1 sort">
			${v3x:showOrgEntitiesOfIds(mtPlan.memberId, "Member", pageContext)}
		</v3x:column>
					
					<v3x:column align="center" type="Date" width="25%" label="common.date.createtime.label">
						<fmt:formatDate value="${mtPlan.createDate}" pattern="${datetimePattern}"/>
					</v3x:column>
					<v3x:column align="center" type="String" width="10%" label="common.type.label">
						<c:choose>
				<c:when test="${mtPlan.app==5 }">
					<fmt:message key="application.${mtPlan.app}.label" bundle="${v3xCommonI18N}"/>

				</c:when>
				<c:when test="${mtPlan.app==6 }">
					<fmt:message key="application.${mtPlan.app}.label" bundle="${v3xCommonI18N}"/>

				</c:when>
				<c:when test="${mtPlan.app==11 }">
				<fmt:message
				key="application.${mtPlan.app}.label"
				bundle="${v3xCommonI18N}" />

		</c:when>
		</c:choose>
		</v3x:column>
		</v3x:table>
	</form>
    </div>
  </div>
</div>
</body>
</html>
