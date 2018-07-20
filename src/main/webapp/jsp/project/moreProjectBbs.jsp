<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>
<title>Insert title here</title>
<script type="text/javascript">
     //getA8Top().hiddenNavigationFrameset(1108);
	
	function deleteProjectBbs()
   {
	
	var i;
	var ids="";
	var objs=document.getElementsByName("id");	
	
	for(i=0;i<objs.length;i++)
	 {
	  if(objs[i].checked==false){continue;}	  
	  ids+=objs[i].value+",";	  
	 }
	if(ids.length>0){ids=ids.substr(0,ids.length-1);}
	if(ids.length<=0)
	   {
		alert(_("ProjectLang.choose_item_from_list"));
		return;
	   }
	if(window.confirm(_("ProjectLang.sure_to_delete_discuss"))==false)
	    {
		return;
	    }

		var listForm = self.document.getElementById("listForm");
		listForm.target = "empty";
		var aurl = "${bbsURL}?method=delArticle&isFromProject=true&ids=";
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		var ids = "";
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				ids += "," + chkid[i].value;}}
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_more_select_alert"))
			return;}
        aurl += ids.substring(1, ids.length);
			listForm.action = aurl;	
	listForm.submit();
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
	
	function queryMoreProjectBbsByCondition() {
		var condition = document.getElementById('condition').value;
        if (condition == 'publishDate') {
            return dateCheck();
        } else {
		searchForm.submit();
        }
	}
	
	function newbbs(){
		openCtpWindow({
			'url':"${bbsURL}?method=issuePost&projectState=${projectState }&from=projectSection&showSpaceLacation=true&boardId=${projectCompose.projectSummary.id}&managerFlag=${param.managerFlag}"
		})	
	}
	function init(){
		<c:if test="${not param.from eq 'projectSection'}">
	    	showCtpLocation("F02_projectPersonPage");
		</c:if>
		var titleDiv = document.getElementById("titleDiv");
		var authorDiv = document.getElementById("authorDiv");
		var publishDateDiv = document.getElementById("publishDateDiv");
		if ("${condition }" == "title") {
			titleDiv.style.display = "block";
			authorDiv.style.display = "none";
			publishDateDiv.style.display = "none";
		} else if ("${condition }" == "author") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "block";
			publishDateDiv.style.display = "none";
		} else if ("${condition}" == "publishDate") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "none";
			publishDateDiv.style.display = "block";
		} else if ("${condtion}" == "choice") {
			titleDiv.style.display = "none";
			authorDiv.style.display = "none";
			publishDateDiv.style.display = "none";
		}
		var top_div_row2 = document.getElementById("top_div_row2");
		var scrollListDiv = document.getElementById("scrollListDiv");
		var scrollbDivbbss = document.getElementById("bDivbbss");
		top_div_row2.style.position="relative";
		top_div_row2.style.height="";
		scrollListDiv.style.position="relative";
		scrollListDiv.style.top="5px";
		scrollListDiv.style.height = document.body.clientHeight - 35 + "px";
		scrollbDivbbss.style.height=document.body.clientHeight - 35-32-30 + "px";
	}
	function doMySearchEnter(){
		var evt = v3x.getEvent();
	    if(evt.keyCode == 13){
	    	queryMoreProjectBbsByCondition();
	    }
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" class="with-header-tab" onload="init()">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div id="top_div_row2">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
  <%@ include file="moreProjectBanner.jsp"%>
  <input type="hidden" id="hiddenProjectId" value="${projectCompose.projectSummary.id}" />
  <tr>
    <td>
     <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border">
        <tr>
            <td>
			   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table" style="border-top:#aeaeae 1px solid">
			   <tr>
			    <td class="webfx-menu-bar" >
				  &nbsp;&nbsp;<fmt:message key="project.info.myProjectBbs" />
				</td>
				<td align="right" class="webfx-menu-bar">
				
					<form action="" id="searchForm" name="searchForm" method="get" onkeydown="doMySearchEnter()">
							<input type="hidden" name="method" value="queryMoreProjectBbsByCondition">
							<input type="hidden" name="projectId" value="${projectId}">
							<input type="hidden" name="phaseId" value="${phaseId}">
							<input type="hidden" name="managerFlag" id="managerFlag" value="${param.managerFlag }" />
							<input type="hidden" name="projectState" id="projectState" value="${param.projectState}" />
							<input type="hidden" name="relat" id="relat" value="${relat}">
					    	<div class="div-float-right" style="vertical-align:middle;">
					    		<div class="div-float" id="ddddddddddddddd">
									<select name="condition" id="condition" style="height:22px;" onChange="showNextSpecialCondition(this)" class="">
								    	<option value="choice" <c:if test="${condition == 'choice'}">selected</c:if>><fmt:message key="project.bbs.select.info"/></option>
									    <option value="title" <c:if test="${condition == 'title'}">selected</c:if>><fmt:message key="project.bbs.select.title"/></option>
									    <option value="author" <c:if test="${condition == 'author'}">selected</c:if>><fmt:message key="collaboration.common.common.supervise.initiator"/></option>
									    <option value="publishDate" <c:if test="${condition == 'publishDate'}">selected</c:if>><fmt:message key="plan.label.reference.sendtime"/></option>
								  	</select>
							  	</div>
							  	<div id="titleDiv" class="div-float hidden">
									<input type="text" name="title" value="${v3x:toHTML(title)}" class="textfield-search" onkeydown="">
							  	</div>
							  	<div id="authorDiv" class="div-float hidden">
									<input type="text" name="author" value="${v3x:toHTML(author)}" class="textfield-search" onkeydown="">
							  	</div>
							  	<div id="publishDateDiv" class="div-float hidden">
									<input
                                        type="text" id="startdate" value="${beginTime}" name="beginTime" value="" class="input-date"
                                        onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
                                        readonly> - <input type="text" value ="${endTime}" id="enddate" name="endTime" class="input-date"
                                        onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly>
								</div>	
							  	<div id="grayButton" onclick="queryMoreProjectBbsByCondition()" class="div-float condition-search-button"></div>
					    	</div>
					    </form>				
					<c:if test="${isProjectManager}">
    					<a href="javascript:deleteProjectBbs()">[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a>&nbsp;
					</c:if>
					<c:if test="${param.relat != true}">
                        <c:if test="${param.projectState != true}">
                            [<font color="gray"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" /></font>]&nbsp;
                        </c:if>
                        <c:if test="${param.projectState == true and isNewBbs}">
                        	<c:if test="${param.canReply ne false}">
    						<a href="javascript:newbbs()">
    							[<fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" />]
    						</a>&nbsp;
    						</c:if>
                        </c:if>
					</c:if>                 
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
			<form name="listForm" action="" id="listForm" method="post" >
				<v3x:table htmlId="bbss" leastSize="0" data="bbsList" var="bbs" pageSize="20" showHeader="true" showPager="true" size="1">
				<c:if test="${isProjectManager}">
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${bbs.id}" />
			  </v3x:column>
			  </c:if>
			  <c:if test="${isProjectManager==false}">
   				<v3x:column width="3%" align="center">
					<img src="<c:url value="/apps_res/peoplerelate/images/icon3.gif" />" width="10" height="10" />
				</v3x:column>
				</c:if>
				<v3x:column align="left" width="49%" label="common.subject.label" alt="${bbs.articleName}" symbol="..." type="String"  hasAttachments="${bbs.attachmentFlag}">
					<a class="title-more" href="javascript:openWin('${bbsURL}?method=showPost&resourceMethod=listLatestFiveArticleAndAllBoard&articleId=${bbs.id}')">${v3x:toHTML(bbs.articleName)}</a>
				</v3x:column>	    									
				<v3x:column width="10%" type="String" label="collaboration.common.common.supervise.initiator" value="${v3x:showMemberName(bbs.issueUser)}"  maxLength="18" symbol="..."/>  
				<v3x:column label="bbs.clicknumber.label" width="10%" type="string" value="${bbs.clickNumber }"></v3x:column>
				<v3x:column label="bbs.replynumber.label" width="10%" type="string" value="${bbs.replyNumber }"></v3x:column> 									
				<v3x:column label="plan.label.reference.sendtime" width="16%" type="Date">
				<fmt:formatDate value="${bbs.issueTime}" pattern='yyyy-MM-dd HH:mm'/>
				</v3x:column>											
			</v3x:table>
		</form>
		<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
    </div>
  </div>
</div>

</body>
</html>
