<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<script type="text/javascript">
	//TODO yangwulin 2012-10-29 getA8Top().hiddenNavigationFrameset();
</script>
</head>
<body scroll="no" class="with-header page_color">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2" style="height:55px;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" style='background:#eee;'>
		 <!-- <tr class="page2-header-line">
			<td width="100%" height="25" valign="top" class="page-list-border-LRD">
				 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			     	<tr class="page2-header-line">
			        <td width="45" class="page2-header-img"><div class="newsIndex"></div></td>
			       <td class="page2-header-bg"><fmt:message key="news.title"/></td> 
			       <td class="page2-header-line page2-header-link" align="right"> 
			        </td>
				</tr>
				</table>
			</td>
		</tr>
		-->
		 <!--
		<tr>
        <td colSpan="2">
            <div class="hr_heng" ></div>
        </td>
    </tr>
	-->
	<tr>
	<td valign="top">
	<table id="newsMoreTable" align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
	    <tr>
	    	  <c:choose>
	    	  	<c:when test="${custom}">
					<c:if test="${spaceManagerFlag}">
						<td height="22" class="webfx-menu-bar page2-list-header padding5">
						<script type="text/javascript">
							var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
							if(v3x.getBrowserFlag("hideMenu") == true){
								myBar.add(new WebFXMenuButton("create", "<fmt:message key="oper.publish" /><fmt:message key="news.data_shortname" />", "javascript:newsPublish('${typeId}')", [5,7], "", null));
							}    	
							myBar.add(new WebFXMenuButton("manage", "<fmt:message key="news.data_shortname" /><fmt:message key="oper.manage" />", "javascript:newsManage('${typeId}', '${spaceType}')", [12,9], "", null));
							document.write(myBar);
							document.close();
						</script>
						</td>
					</c:if>
				</c:when>
		    	<c:when test="${moreList}">
		    		 <td height="22" class="webfx-menu-bar page2-list-header"><h3>${v3x:toHTML(typeName)}</h3></td>
		    	</c:when>
		    	<c:when test="${imageOrFocus == 0}">
		    		<td height="22" class="webfx-menu-bar page2-list-header"><b><fmt:message key="news.image_news"/></b></td>
		    	</c:when>
		    	<c:when test="${imageOrFocus == 1}">
		    		<td height="22" class="webfx-menu-bar page2-list-header"><b><fmt:message key="news.focus_news"/></b></td>
		    	</c:when>
		    	<c:otherwise>
		    		<c:if test="${publicCustom}">
		    			<td height="22" class="webfx-menu-bar page2-list-header"><b>${v3x:toHTML(spaceName)}</b></td>
		    		</c:if>
		    		<c:if test="${!publicCustom}">
			    		<c:set value="${spaceType == 3 && v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
			    		<td height="22" class="webfx-menu-bar page2-list-header"><b><fmt:message key="news.more.${spaceType}${govLabel}"/></b></td>
		    		</c:if>
		    	</c:otherwise>
	  		  </c:choose>
		  <td class="webfx-menu-bar">
						<form action="${newsDataURL}" name="searchForm" id="searchForm" method="get"
							onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="oneNewsSearch" name="method">
							<input type="hidden" value="${group}" name="group">
							<input type="hidden" value="${param.homeFlag}" name="homeFlag">
							<input type="hidden" value="${spaceType}" name="spaceType">
							<input type="hidden" value="${newsTypeId }" name="newsTypeId">
							<input type="hidden" value="${newsTypeId }" name="typeId">
							<input type="hidden" value="${custom}" name="custom">
							<input type="hidden" value="${param.spaceId}" name="spaceId">
							<input type="hidden" value="${param.fragmentId}" name="fragmentId">
							<input type="hidden" value="${param.ordinal}" name="ordinal">
							<input type="hidden" value="${param.panelValue}" name="panelValue">
							<div class="div-float-right">
								<div class="div-float" style="margin-bottom: 5px;">
									<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
										<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
										<option value="title"><fmt:message key="news.biaoti.label" /></option>
										<option value="keywords"><fmt:message key="news.data.keywords" /></option>
										<option value="brief"><fmt:message key="news.data.brief" /></option>
                                        <option value="departMent"><fmt:message key="news.data.publishDepartmentId" /></option>
                                        <option value="publishDate"><fmt:message key="news.data.publishDate" /></option>
                                        <option value="updateDate"><fmt:message key="news.data.updateDate" /></option>
									</select>
								</div>
                                <div id="departMentDiv" class="div-float hidden">
                                    <input type="text" name="textfield" class="textfield"  maxlength="50"  onkeydown="javascript:searchWithKey()">
                                </div>                    
								<div id="titleDiv" class="div-float hidden">
									<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
								</div>
								<div id="keywordsDiv" class="div-float hidden">
									<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
								</div>
								<div id="briefDiv" class="div-float hidden">
									<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
								</div>
								<div id="publishDateDiv" class="div-float hidden">		
									<input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
									<input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
								</div>
								<div id="updateDateDiv" class="div-float hidden">		
			                        <input type="text" name="textfield" id="startdate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
			                        <input type="text" name="textfield1" id="enddate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
			                    </div>
								<div onclick="javascript:doSearchInq()" class="condition-search-button div-float" style="color:black"></div>
							</div>
						</form>
		  </td>
		</tr>
	</table>	
	</td>
	</tr>
	</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv" style="top:60px">
	  <form name="newsMoreForm">
			<v3x:table htmlId="listTable" data="list" var="bean">
				<c:choose>
					<c:when test="${bean.readFlag}">
						<c:set value="title-already-visited" var="readStyle" />
					</c:when>
					<c:otherwise>
						<c:set value="title-more-visited" var="readStyle" />
					</c:otherwise>
				</c:choose>
				<v3x:column width="40%" type="String" label="news.biaoti.label" className="sort" 
				hasAttachments="${bean.attachmentsFlag}" bodyType="${bean.dataFormat}" read="true" maxLength="50" alt="${bean.title}" symbol="...">
					<c:if test="${bean.topOrder>0}">
						<span class="icon_com news_com inline-block"></span>
					</c:if>
					<c:if test="${bean.focusNews}">
		            	<font color='red'>[<fmt:message key="news.focus" />]</font>
		            </c:if>
					<a href="javascript:openWin('${newsDataURL}?method=userView&spaceId=${param.spaceId}&id=${bean.id}')" class="${readStyle}">${v3x:toHTML(bean.title)}</a>
				</v3x:column>
				
					<c:if test="${empty param.typeId}">
						<c:set value="${newsDataURL}?method=newsMore&typeId=${bean.typeId}&orgType=${orgType}" var="linkColumn"></c:set>
						<v3x:column width="15%" type="String" label="news.data.type" className="sort" >
							<a href="${linkColumn}" class="">${v3x:getLimitLengthString(bean.type.typeName, 22, '...')}</a>
						</v3x:column>
					</c:if>
				<c:set value="${(empty param.typeId)?'10%':'15%'}" var="width"/>
				<v3x:column width="${width}" type="String" label="news.data.publishDepartmentId" className="sort"
					 maxLength="50" alt="${bean.publishDepartmentName}">
					${v3x:toHTML(bean.publishDepartmentName)}
				</v3x:column>
				<v3x:column width="${width}" type="String" label="news.data.createUser" className="sort"
					 maxLength="50" alt="${bean.createUserName}">
					${bean.createUserName}
				</v3x:column>
				<v3x:column width="${width}" type="Date"
					label="news.data.publishDate" className="sort">
					<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="10%" type="Date" label="news.data.updateDate" className="sort">
					<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="5%" type="Number" label="news.data.readCount" value="${bean.readCount}"/>
			</v3x:table>
			</form>
			<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
    </div>
  </div>
</div>
</body>
</html>
<script type="text/javascript">
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
  if('${param.spaceType}'=='4'){
	    var theHtml=toHtml("${v3x:toHTML(typeName)}",'<fmt:message key="news.title"/>');
	    showCtpLocation("",{html:theHtml});
	} 
  if('${param.openFrom}'=='index'){
		resetCtpLocation();
	}
  var firstName = "${firstName}";
  var secondName = "${secondName}";
  if (firstName != '' && secondName != ''){
     var theHtml=toHtml("${v3x:toHTML(firstName)}",'${v3x:toHTML(secondName)}');
     showCtpLocation("",{html:theHtml}); 
  }
</script>