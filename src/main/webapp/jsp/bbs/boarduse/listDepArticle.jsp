<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title></title>
<script>
	//getA8Top().hiddenNavigationFrameset();
	
	function articleDetail(articleId){
		var acturl = "${detailURL}?method=showPost&articleId="+articleId+"&group=${group}&dept=moreDeptActicle&custom=${custom}";
		openWin(acturl);
	}

	function doDeptSearch() {
		var theForm = document.getElementsByName("searchForm")[0];
		var condition = theForm.condition;
		if ("${custom}" != "true" && ${fn:length(deptSpaceModels) > 1}) {
			document.getElementById('departmentId').value = document.getElementById('departmentIdSelect').value;
		}
		if(condition.value == 'issueTime') {			
			var startDate = document.getElementById("startdate").value;
			var endDate = document.getElementById("enddate").value;
			if(startDate!=""&&endDate!=""){
				if(compareDate(startDate,endDate)>0){
					alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
					return false;
				}
			}
		}
		doSearch();
	}
</script>
</head>
<body scroll="no" class="with-header page_color">
	<div class="main_div_row2">
 		<div class="right_div_row2">
  			<div class="top_div_row2">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style='background:#eee;'>
                    <tr class="page2-header-line">
                        <td width="100%" height="25" valign="top">
                             <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr class="page2-header-line">
                                <c:set value="${v3x:showOrgEntitiesOfIds(boardId, 'Department', pageContext)}" var="currentDeptName" />
                                <td class="page2-header-bg"><span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;" title="${v3x:toHTML(currentDeptName)}<fmt:message key='bbs.latest.post.label'/>">${v3x:toHTML(v3x:getLimitLengthString(currentDeptName, 30,'...'))}<fmt:message key="bbs.latest.post.label" /></span></td>
                                <td class="page2-header-line" align="right">
                                    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right"></td>
                                        </tr>
                                        <tr>
                                            <td align="right"></td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                            <c:if test="${!custom}">
                                                <c:if test="${fn:length(deptSpaceModels) > 1}">
                                                    <fmt:message key='department.switch.label' bundle="${v3xMainI18N}"/><fmt:message key="bbs.latest.post.label" />: 
                                                    <select name="departmentIdSelect" id="departmentIdSelect" onchange="changeDeptBBS()">
                                                        <c:forEach items="${deptSpaceModels}" var="dept">
                                                            <option title="${v3x:toHTML(dept.spacename)}" value="${dept.entityId}" ${dept.entityId == boardId ? 'selected' : ''}>
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
                                             </c:if>
                                            </td>
                                        </tr>
                                    </table>		        
                                </td>        	
                            </tr>
                            <tr>
                                <td colSpan="2">
                                    <div class="hr_heng" ></div>
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" >
                            <table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0"  class="page2-list-border">
                                <tr>						
                                    <td height="22" class="webfx-menu-bar page2-list-header">
                                        <script type="text/javascript">
                                            var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
                                            if(v3x.getBrowserFlag('hideMenu')){
                                                myBar.add(new WebFXMenuButton("create", "<fmt:message key='new.bbs.button' />", "javascript:bbsPublish('${boardId}','${spaceType}')", [5,7], "", null));    	
                                            }
                                            <c:if test="${bbsManagerFlag || isSpaceBbsManager}">
                                                myBar.add(new WebFXMenuButton("manage", "<fmt:message key="bbs.organization.label" />", "javascript:bbsManage('${boardId}')", [12,9], "", null));
                                            </c:if>
                                            document.write(myBar);
                                            document.close();
                                        </script>
                                    </td>			       		
                                    <td class="webfx-menu-bar">				   
                                        <form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
                                            <input type="hidden" name="method" value="${param.method}">
                                            <input type="hidden" name="custom" id="custom" value="${custom}">
                                            <input type="hidden" name="departmentId" id="departmentId" value="${param.departmentId}">
                                            <div class="div-float-right">
                                                <div class="div-float">
                                                    <select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
                                                        <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
                                                        <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
                                                        <option value="author"><fmt:message key="bbs.issue.poster.label"/></option>
                                                        <option value="issueTime"><fmt:message key="bbs.date.create"/></option>
                                                    </select>
                                                </div>
                                                <div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
                                                <div id="authorDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
                                                <div id="issueTimeDiv" class="div-float hidden">
                                                    <input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly> - 
                                                    <input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly>
                                                </div>
                                                <div onclick="doDeptSearch()" class="div-float condition-search-button  button-font-color"></div>
                                            </div>
                                        </form>
                                    </td>
                                </tr>
                              </table>
                            </td>
                           </tr>
                          </table>
                         </div>
						<div class="center_div_row2" id="scrollListDiv" style="top:66px" >
							<form name="fm" method="post" action="" onsubmit="">
								<v3x:table htmlId="pending" data="${articleModellist}" var="col" isChangeTRColor="false" className="sort ellipsis">
									<v3x:column width="50%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
										<a href="javascript:articleDetail('${col.id}');" class="defaulttitlecss" title="${v3x:toHTML(col.articleName)}">
										<c:if test="${col.topSequence==1}">
											<font color="red">[<fmt:message key="bbs.top.label" />]</font>
										</c:if>
										${v3x:toHTML(col.articleName)}
										<c:if test="${col.eliteFlag}">
											<font color="red">[<fmt:message key="bbs.elite.label" />]</font>
										</c:if>
										</a>
									</v3x:column>
									<v3x:column width="12%" type="String" label="bbs.issue.poster.label" value="${bbs:showName(col, pageContext)}" />
									<v3x:column width="10%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
									<v3x:column width="12%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
									<v3x:column type="Date" label="bbs.date.create" width="16%">
										<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
									</v3x:column>
								</v3x:table>
							</form>
						</div>
					</div>
                   </div>
                   
<input type="hidden" id="_custom" name="_custom" value="${custom}">
<input type="hidden" id="_spaceId" name="_spaceId" value="${spaceId}">
<script type="text/javascript">
	initIpadScroll("scrollListDiv2",500,870);
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	showCtpLocation('F5_bbsIndexDept');
	
	if('${param.spaceType}'=='4' || '${spaceType}'=='4'){
	    var theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="bbs.latest.post.label"/>');
	    showCtpLocation("",{html:theHtml});
	}
	
</script>
</body>
</html>
