<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<%@ include file="../include/taglib.jsp"%>

<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script type="text/javascript">
<!--
	//TODO zhangxw 2012-10-30 getA8Top().hiddenNavigationFrameset();

	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");	
	}
//-->
</script>
</head>
<body scroll="no" class="with-header page_color">
	<div class="main_div_row2">
 		<div class="right_div_row2">
  			<div class="top_div_row2">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" > 
                    <tr class="page2-header-line">
                        <td width="100%" height="25" valign="top" class="page-list-border-LRD">
                             <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr class="page2-header-line">
                                <td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
                                <td class="page2-header-bg" width="500">
                                    <c:choose>
                                        <c:when test="${param.spaceType eq '1'}">
                                            <c:set value="${v3x:showOrgEntitiesOfIds(typeId, 'Department', pageContext)}" var="headerName" />
                                            <span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;" title="${v3x:toHTML(headerName)}<fmt:message key='bul.more'/>">${v3x:toHTML(v3x:getLimitLengthString(headerName, 30,'...'))}<fmt:message key="bul.more"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:message key="bul.more"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="page2-header-line padding-right" align="right">
                                    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right"></td>
                                        </tr>
                                        <tr>
                                            <td align="right"></td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="bottom">
                                                <c:if test="${fn:length(deptSpaceModels) > 1 && param.spaceType eq '1'}">
                                                    <fmt:message key='department.switch.label' bundle="${v3xMainI18N}"/><fmt:message key="application.7.label" bundle="${v3xCommonI18N}"/>: 
                                                    <select name="departmentIdSelect" onchange="changeDeptBulletin()">
                                                        <c:forEach items="${deptSpaceModels}" var="dept">
                                                            <option value="${dept.entityId}" ${dept.entityId == typeId ? 'selected' : ''}>
                                                               <c:if test="${dept.type == 1}">
                                                                <c:out value="${v3x:getLimitLengthString(v3x:toHTML(v3x:showOrgEntitiesOfIds(dept.entityId,'Department',pageContext)),30, '...')}" escapeXml='true' />
                                                            </c:if>
                                                            <c:if test="${dept.type != 1}">
                                                                <c:out value="${v3x:getLimitLengthString(v3x:toHTML(dept.spacename),30, '...')}" escapeXml='true' />
                                                            </c:if>   
                                                             
                                                            </option>
                                                        </c:forEach>
                                                    </select>&nbsp;&nbsp;
                                                </c:if>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                            <td colspan="2">
                            <div class="hr_heng"></div>
                            </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                <tr>
                <td valign="top">
                <table id="bulMoreTable" align="center" width="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
                    <tr>
                        <td  width="30%" height="22" class="webfx-menu-bar page2-list-header ${(param.spaceType eq '1' || param.spaceType eq '4') ? 'padding5' : ''}">
                        <c:if test="${spaceManagerFlag}">
                            <script type="text/javascript">
                                var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
                                if(v3x.getBrowserFlag("hideMenu") == true){
                                    myBar.add(new WebFXMenuButton("delete", "<fmt:message key="oper.publish" /><fmt:message key="bul.data_shortname" />", "javascript:bullSpacePublish('${param.spaceType}', '${typeId}')", [5,7], "", null));
                                }    	
                                myBar.add(new WebFXMenuButton("refresh", "<fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" />", "javascript:bullSpaceManage('${typeId}')", [12,9], "", null));
                                document.write(myBar);
                                document.close();
                            </script>
                        </c:if>
                            <c:choose>
                                <c:when test="${param.spaceType ne '1'}">
                                    <c:choose>
                                        <c:when test="${isTop == 'true' && param.spaceType == 2}">
                                            <b><fmt:message key="label.new.bulletin.8"/></b>
                                        </c:when>
                                        <c:when test="${isTop == 'true' && (param.spaceType == 17 || param.spaceType == 18)}">
                                            <b><fmt:message key="label.new.bulletin.custom"/></b>
                                        </c:when>
                                        <c:when test="${isTop == 'true' && param.spaceType == 3}">
                                            <b><fmt:message key="label.new.bulletin.7"/></b>
                                        </c:when>
                                        <c:when test="${empty param.typeId}">
                                            <c:if test="${publicCustom}">
                                                <b>${v3x:toHTML(headerName)}</b>
                                            </c:if>
                                            <c:if test="${!publicCustom}">
                                                <c:set value="${param.spaceType == 3 && v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
                                                <b><fmt:message key="label.new.bulletin.${param.spaceType}${govLabel}"/></b>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                        <c:if test="${!custom}"> <b>${v3x:toHTML(headerName)}</b></c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${managerFlag}">
                                            <script type="text/javascript">
                                                var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
                                                if(v3x.getBrowserFlag("hideMenu") == true){
                                                    myBar.add(new WebFXMenuButton("delete", "<fmt:message key="bul.data_shortname" /><fmt:message key="oper.publish" />", "javascript:bullPublish('${param.spaceType}', '${typeId}')", [5,7], "", null));
                                                }    	
                                                myBar.add(new WebFXMenuButton("refresh", "<fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" />", "javascript:bullManage('${typeId}')", [12,9], "", null));
                                                document.write(myBar);
                                                document.close();
                                            </script>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                       </td>
                    
                       <td class="webfx-menu-bar">
                            <form action="${bulDataURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
                                <input type="hidden" value="bulMore" name="method">
                                <input type="hidden" value="${param.spaceType}" name="spaceType">
                                <input type="hidden" value="${param.homeFlag}" name="homeFlag">
                                <input type="hidden" value="${typeId}" name="typeId">
                                <input type="hidden" value="${custom}" name="custom">
                                <input type="hidden" value="${param.spaceId}" id="spaceId" name="spaceId">
                                <input type="hidden" value="${param.fragmentId}" name="fragmentId">
								<input type="hidden" value="${param.ordinal}" name="ordinal">
								<input type="hidden" value="${param.panelValue}" name="panelValue">
                                <input type="hidden" value="${isTop}" name="isTop">
                                <div class="div-float-right condition-search-div">
                                    <div class="div-float">
                                        <select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
                                            <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                                            <option value="title"><fmt:message key="bul.biaoti.label" /></option>
                                            <option value="publishUserId"><fmt:message key="bul.data.createUser" /></option>
                                            <option value="publishDepartmentName"><fmt:message key="bul.data.publishDepartmentId" /></option>
                                            <option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>
                                            <option value="updateDate"><fmt:message key="bul.data.updateDate" /></option>
                                        </select>
                                    </div>
                                    <div id="titleDiv" class="div-float hidden">
                                        <input type="text" name="textfield" id="titleInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
                                    </div>
                                    <div id="publishUserIdDiv" class="div-float hidden">
                                        <input type="text" name="textfield" id="publishUserIdInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
                                    </div>
                                    <div id="publishDepartmentNameDiv" class="div-float hidden">
                                        <input type="text" name="textfield" id="publishDepartmentNameInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
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
                    </table></td></tr></table>
                  </div>
              <div class="center_div_row2" id="scrollListDiv" style="top:66px">
              <form name="listForm" action="" id="listForm" method="post" style="margin: 0px">
                    <v3x:table htmlId="listTable" data="${list }" var="bean" className="ellipsis">
                        <c:choose>
                            <c:when test="${bean.readFlag}">
                                <c:set value="title-already-visited" var="readStyle" />
                            </c:when>
                            <c:otherwise>
                                <c:set value="title-more-visited" var="readStyle" />
                            </c:otherwise>
                        </c:choose>
                        <v3x:column width="15%" type="String" label="bul.biaoti.label" className="sort" hasAttachments="${bean.attachmentsFlag}"
                            bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" read="true" maxLength="23" symbol="...">
                            <c:if test="${typeId != null || param.spaceType eq '1'}">
                                <c:if test="${bean.topOrder>0}">
                                    <font color="red">[<fmt:message key="label.top" />]</font>
                                </c:if>
                            </c:if>					
                            <a href="javascript:openWin('${bulDataURL}?method=userView&spaceId=${param.spaceId}&id=${bean.id}')" class="${readStyle}" title="${v3x:toHTML(bean.title)}" >
                                ${v3x:toHTML(bean.title)}
                            </a>
                        </v3x:column>
                        <c:if test="${empty param.typeId && param.spaceType ne '1'}">
                            <c:set value="${bulDataURL}?method=bulMore&typeId=${bean.type.id}&spaceType=${bean.type.spaceType}&spaceId=${param.spaceId}" var="linkColumn"></c:set>
                        <v3x:column width="15%" type="String" 
                            label="bul.data.type" className="${readStyle}-span sort" value="${bean.type.typeName}"
                            alt="${bean.type.typeName}" href="${linkColumn}"
                            />
                        </c:if>
                        <c:set value="${(empty param.typeId && param.spaceType ne '1')?'10%':'15%'}" var="width"/>
                        <v3x:column width="${width}" type="String" 
                            label="common.issueScope.label" className="${readStyle}-span sort" 
                            value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" 
                            alt="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" />
                        <v3x:column width="20%" type="String"
                            label="bul.data.publishDepartmentId" className="${readStyle}-span sort" value="${bean.publishDeptName}"
                            alt="${bean.publishDeptName}" />
                        <v3x:column width="${width}" type="String"
                            label="bul.data.createUser" className="${readStyle}-span sort" value="${bean.publishMemberName}"
                            alt="${bean.publishMemberName}" />
                        <v3x:column width="${width}" type="Date"
                            label="bul.data.publishDate" className="${readStyle}-span sort">
                            <fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
                        </v3x:column>
                        <v3x:column width="${width}" type="Date"
                            label="bul.data.updateDate" className="${readStyle}-span sort">
                            <fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
                        </v3x:column>
                        <v3x:column width="5%" type="Number" label="bul.data.readCount" className="${readStyle}-span sort" value="${bean.readCount}"/>
                    </v3x:table>
                </form>
                </div>
                </div></div>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
<script type="text/javascript">
initIpadScroll("scrollListDiv",500,870);
var _spaceType = '${param.spaceType}';
if (_spaceType == '1') {
    showCtpLocation('F5_bulIndexDept');
}
if (_spaceType == '4') {
  var theHtml=toHtml("${v3x:toHTML(headerName)}",'<fmt:message key="bul.title"/>');
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
</body>
</html>