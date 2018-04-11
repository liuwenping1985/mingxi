<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="/WEB-INF/jsp/project/projectHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//方法找不到了报错,感觉没啥用,直接注释掉
	//getA8Top().hiddenNavigationFrameset();//隐藏当前位置
	
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
	
	function queryMoreProjectCol() {	
		var condition = document.getElementById('condition').value;
	    if (condition == 'newDate') {
	    	 var startdate=document.getElementById('startdate').value;
	    		var enddate=document.getElementById('enddate').value;
	    		if(compareDate(startdate,enddate)>0)
	    		{
	    			window.alert("${ctp:i18n('calendar_endTime_startTime')}");
	    			return false;	
	    		}
	    }
		document.getElementById("searchForm").submit();
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
		var scrollbDivcolls = document.getElementById("bDivcolls");
		//var center_div_row2 = document.getElementById("center_div_row2");
		top_div_row2.style.position="relative";
		top_div_row2.style.height="";
		scrollListDiv.style.position="relative";
		scrollListDiv.style.top="5px";
		scrollListDiv.style.height = document.body.clientHeight - 35 + "px";
		//设置列表内容的高度使其可以铺满一页
		scrollbDivcolls.style.height = document.body.clientHeight - 35-32-30 -20 + "px";
		//center_div_row2.style.height = center_div_row2.style.height - 15 + "px";
	}
	function myForwardColV3X(id1,id2){
	    var requestCaller = new XMLHttpRequestCaller(this, "colManager", "checkForwardPermission",false);
	    var dataStr = id1 + "_" + id2;
        requestCaller.addParameter(1, "String", dataStr);
        var canForward = requestCaller.serviceRequest();
        if(canForward && (canForward instanceof Array) && canForward.length > 0){
          alert("${ctp:i18n('collaboration.grid.alert.canNotForward')}");
        } else {
    		forwardColV3X(id1,id2);
    		//window.location.reload();
	    }
	}
	//OA-71478【项目协同】更多页面，【转发】文字链接显示错误，且点击不动---老bug
	function refreshProjectWindow(){
		window.location.reload();
	}
	
	function doMySearchEnter(){
		var evt = v3x.getEvent();
	    if(evt.keyCode == 13){
	    	queryMoreProjectCol();
	    }
	}

	function myOpenDetail(url){
		openDetailURL(url);
		//OA-71476【项目协同】更多页面，点击查看查询后的数据，弹出异常提示。--老bug
		//setTimeout("window.location.reload()",500);
	}
	
	function loadMBX(){
		showCtpLocation("F02_projectPersonPage");
	}
	/**
	*状态点击事件
	*/
	function forwardCol(forwardUrl){
		getA8Top().$("#main").attr("src",forwardUrl);
	}
</script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body scroll="no" onload="loadMBX();init()" class="with-header;">
<c:set var="hasNewColl" value="${v3x:hasNewCollaboration() }"/>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div id="top_div_row2">
		<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="">
		  <tr>
		    <td class="padding5">
		     <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="">
		        <tr>
		            <td>
					   <table width="100%" height="100%"  style="border-top:#aeaeae 1px solid" border="0" cellspacing="0" cellpadding="0" class="bbs-table">
					   <tr>
					   		<td class="webfx-menu-bar padding_l_5"> 
							  	<fmt:message key="project.info.myProjectColl" />
							</td>
							<td class="webfx-menu-bar">
								<form action="/seeyon/collaboration/collProjectController.do" id="searchForm" name="searchForm" method="post" onkeydown="doMySearchEnter()">
									<input type="hidden" name="method" value="moreProjectCol" />
									<input type="hidden" name="phaseId" value="${phaseId}" />
									<input type="hidden" name="projectId" value="${projectId }" />
									<input type="hidden" name="managerFlag" id="managerFlag" value="${param.managerFlag}" />
							    	<div class="div-float-right" style="vertical-align:middle;">
							    		<div class="div-float">
											<select name="condition" id="condition" style="height:22px;" onChange="showNextSpecialCondition(this)" class="">
										    	<option value="choice" <c:if test="${condition == 'choice' }">selected</c:if>><fmt:message key="collaboration.lable.search.conditon" bundle="${collI18N}"/></option>
											    <option value="title" <c:if test="${condition == 'title' }">selected</c:if>><fmt:message key="project.bbs.select.title" bundle="${collI18N}"/></option>
											    <option value="author" <c:if test="${condition == 'author' }">selected</c:if>><fmt:message key="project.info.select.publisher.label" bundle="${collI18N}"/></option>
											    <option value="newDate" <c:if test="${condition == 'newDate' }">selected</c:if>><fmt:message key="project.create.time" bundle="${collI18N}"/></option>
										  	</select>
									  	</div>
									  	<div id="titleDiv" class="div-float hidden">
											<input type="text" name="title" value="${v3x:toHTML(title)}" class="textfield-search" onkeydown="">
									  	</div>
									  	<div id="authorDiv" class="div-float hidden">
											<input type="text" name="author" value="${v3x:toHTML(author)}" class="textfield-search" onkeydown="">
									  	</div>
									  	<div id="newDateDiv" class="div-float hidden">
											<input type="text" id="startdate" name="beginTime" value="${beginTime}" class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
											<input type="text" id="enddate" name="endTime" value="${endTime}" class="textfield-search" onclick="whenstart('${pageContext.request.contextPath}',this,575,240);" readonly>
										</div>	
									  	<div id="grayButton" onclick="queryMoreProjectCol()" class="div-float condition-search-button"></div>
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
		  <v3x:table htmlId="colls" leastSize="0" data="colList" var="col" pageSize="20" showHeader="true" showPager="true" size="1">
			<v3x:column width="50%" type="String" label="common.subject.label" maxLength="20" className="cursor-hand1 sort"
			hasAttachments="${col.attsFlag}"  flowState="${col.colSummaryState}" 
								bodyType="${col.bodyTypeStr}"
								importantLevel="${col.importantLevel}">
				<c:choose>
					<c:when test="${col.state==2}">
						<a class="title-more" title="${v3x:toHTML(col.addition)}" href="javascript:myOpenDetail('${colURL}?method=summary&openFrom=listSent&affairId=${col.id }')">${v3x:toHTML(col.addition)}</a>
					</c:when>
					<c:when test="${col.state==3}">
						<a class="title-more" title="${v3x:toHTML(col.addition)}" href="javascript:myOpenDetail('${colURL}?method=summary&openFrom=listPending&affairId=${col.id }')">${v3x:toHTML(col.addition)}</a>
					</c:when>
					<c:otherwise>
						<a class="title-more" title="${v3x:toHTML(col.addition)}" href="javascript:myOpenDetail('${colURL}?method=detail&openFrom=listDone&affairId=${col.id }')">${v3x:toHTML(col.addition)}</a>
					</c:otherwise>
				</c:choose>
			</v3x:column>
			
				<v3x:column type="String" width="15%" className="cursor-hand1 sort" label="collaboration.process.autoskip.log.sender">
	    					${v3x:showOrgEntitiesOfIds(col.senderId, "Member", pageContext)}
	    		</v3x:column>
			<v3x:column width="15%" type="Date" label="common.date.createtime.label" >
				<fmt:formatDate value="${col.createDate}" pattern="${datetimePattern}"/>
			</v3x:column>
			<c:set value="${hasNewColl ? '10%' : '20%'}" var="width"/>			
			<v3x:column  width="${width}" type="String" label="common.state.label" maxLength="40" className="cursor-hand1 sort">
				<c:choose>
					<c:when test="${col.state==2}">
                        <c:choose>
                            <c:when test="${listSent=='yes' }">
                                <a onclick="forwardCol('${colURL}?method=listSent')"><fmt:message key="project.collaboration.colSend.label" bundle="${collI18N}" /></a>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="project.collaboration.col.label.2" bundle="${collI18N}" />
                            </c:otherwise>
                        </c:choose>
					</c:when>
					<c:when test="${col.state==3}">
                        <c:choose>
                             <c:when test="${listPending=='yes' }">
                                <a onclick="forwardCol('${colURL}?method=listPending&from=listPending')"><fmt:message key="project.collaboration.col.label.3" bundle="${collI18N}" /></a>
                            </c:when>
                            <c:otherwise>
                               <fmt:message key="project.collaboration.col.label.3" bundle="${collI18N}" />
                            </c:otherwise>
                        </c:choose>
					</c:when>
					<c:otherwise>
                        <c:choose>
                            <c:when test="${listDone=='yes' }">
                                  <a onclick="forwardCol('${colURL}?method=listDone')"><fmt:message key="project.collaboration.col.label.4" bundle="${collI18N}" /></a>
                              </c:when>
                              <c:otherwise>
                                 <fmt:message key="project.collaboration.col.label.4" bundle="${collI18N}" />
                              </c:otherwise>
                          </c:choose>
					</c:otherwise>
				</c:choose>
			</v3x:column>
            
			<c:if test="${hasNewColl}">
			<v3x:column  type="String" width="10%" className="cursor-hand1 sort" label="project.collaboration.show.forward">
    			<c:if test="${col.canForward}">
    				<a  href="javascript:myForwardColV3X('${col.objectId}','${col.id}')">[<fmt:message key="project.collaboration.show.forward" bundle="${v3xCommonI18N}"/>]</a>&nbsp;
    			</c:if>
    		</v3x:column>
    		</c:if>
		</v3x:table>
	</form>
</div>
</div></div>
<!-- //col.canForward&&hasNewColl line 138,153-->
</body>
</html>
