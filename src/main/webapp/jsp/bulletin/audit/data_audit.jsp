<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<title><c:if test="${bean.id!=null}">
	<fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" />
</c:if><c:if test="${bean.id==null}">
	<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" />
</c:if><fmt:message key="bul.data" /></title>
<link
	href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>"
	rel="stylesheet" type="text/css">
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
<!--
	function myOnload(){
			var parentObj = top.window.dialogArguments;
			if (parentObj){
				location.href='#aaa';
			}else{
				
			}
	}
	function unlock(id){
		//进行解锁
		var depObj = document.getElementById("department");
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
			
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
//-->
</script>
</head>
<body scroll='no' onload="myOnload();" onkeydown="listenerKeyESC()" onunload="unlock('${bean.id }');">
<c:set var="ext" value="${bean.type.ext1}"/>
<div class="scrollList">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center">
	<tr>
		<td class="body-bgcolor" width="100%" height="100%" style="padding: 0px; overflow: auto;">
			<div id="printThis"><!-- 打印开始 -->
		<table width="100%" height="100%" border="0" cellpadding="0"
			cellspacing="0">
			<tr>
				<td width="100%" height="100%" align="center">
				<table width="100%" height="100%" border="0" cellpadding="0"
					cellspacing="0" class="body-detail">
					<c:if test="${ext=='0'}">
					<tr class="page2-header-line-old">
						<td colspan="6" width="100%" height="60">
						<table border="0" cellpadding="0" cellspacing="0" width="100%"
							align="center">
							<tr class="page2-header-line-old" height="60">
								<td width="80" height="60"><img align="absmiddle"
									src="<c:url value="/apps_res/bulletin/images/pic.gif"/>" /></td>
								<td class="page2-header-bg-old" width="380"><fmt:message
									key="bul.title" /></td>
								<td class="page2-header-line-old padding-right" align="right"></td>
								<td>&nbsp;</td>
							</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td colspan="6" height="30">
						<table border="0" cellpadding="0" cellspacing="0" width="100%"
							style="border-bottom: 1px solid #A4A4A4;">
							<tr>
								<td align="center" width="90%" class="titleCss"
									style="padding: 20px 6px;">${v3x:toHTML(bean.title)}</td>
									<div id="noprint" style="visibility:visible">
										<td>
						    			</td>
				    				</div>
							</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="padding35">
							<table cellpadding="0" cellspacing="0" width="100%" height="100%">
								<tr>
									<td class="font-12px" align="" nowrap="nowrap" width="5%" height="28"><fmt:message
										key="bul.data.publishDepartmentId" /><fmt:message
										key="label.colon" />&nbsp;</td>
									<td class="font-12px" width="25%">
											${v3x:toHTML(bean.publishDeptName)}
									</td>
									<td class="font-12px" align="" nowrap="nowrap" width="5%"><fmt:message
										key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;</td>
									<td class="font-12px" width="25%">${bean.type.typeName}</td>
									<td class="font-12px" align="" nowrap="nowrap" width="5%"><fmt:message
										key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;</td>
									<td class="font-12px" width="25%"><fmt:formatDate
										value="${bean.createDate}" pattern="${datePattern}" /></td>
								</tr>
								<tr>
									<td class="font-12px" nowrap="nowrap" align="" height="28"><fmt:message
										key='common.issueScope.label' bundle="${v3xCommonI18N}" /><fmt:message
										key="label.colon" />&nbsp;</td>
									<td><c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}"
										var="publishScopeStr" />
									<div title="${v3x:toHTML(publishScopeStr)}" class="font-12px">${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr,30, "..."))}</div>
									</td>
                                    <c:choose>
                                        <c:when test="${bean.showPublishUserFlag }">
                                                <td class="font-12px" nowrap="nowrap" align=""><fmt:message
                                        key="bul.data.createUser" /><fmt:message key="label.colon" />&nbsp;</td>
                                                <td class="font-12px"></td>
                                                <td class="font-12px" nowrap="nowrap" align=""><fmt:message
                                                    key="label.readCount" /><fmt:message key="label.colon" />&nbsp;</td>
                                                <td class="font-12px">${bean.readCount}</td>
                                        </c:when>
                                        <c:otherwise>
                                                 <td class="font-12px" nowrap="nowrap" align=""><fmt:message
                                                    key="label.readCount" /><fmt:message key="label.colon" />&nbsp;</td>
                                                <td colspan="3" class="font-12px">${bean.readCount}</td>
                                        </c:otherwise>
                                    </c:choose>
								</tr>
							</table>
						</td>
					</tr>

					</c:if>
					<tr>
						<td width="100%" id="contentTD" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : '600px'}" style="padding-bottom: 6px;"
							valign="top" colspan="6">
						<div style="height:100%"><v3x:showContent content="${empty bean.ext5 ? bean.content: bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content" viewMode="edit"/></div>
						<style>
                        .contentText p{
                            font-size:14px;
                        }
                   </style>
                        </td>
					</tr>
					
					<tr>
						<td height="10" valign="top" colspan="6">
							<hr size="1" class="newsBorder">
						</td>
					</tr>
					
					<tr id="attachmentTr" style="display: none">
					  <td class="paddingLR" height="30" colspan="6">
					   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
					    <tr style="padding-bottom: 20px;">
							<td nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
							<td width="100%" class="font-12px">
							  <v3x:attachmentDefine	attachments="${attachments}" />		   
								<script type="text/javascript">					
									showAttachment('${bean.id}', 0, 'attachmentTr', '');					
								</script>
							</td>
						 </tr>
						</table>
					  </td>
					</tr>
					<tr id="attachment2Tr" style="display: none">
					  <td class="paddingLR" height="30" colspan="6">
					   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
					    <tr style="padding-bottom: 20px;">
							<td nowrap="nowrap" width="80" class="font-12px"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
							<td width="100%" class="font-12px">
							  <v3x:attachmentDefine	attachments="${attachments}" />		   
								<script type="text/javascript">					
									showAttachment('${bean.id}',2, 'attachment2Tr', '');					
								</script>
							</td>
						 </tr>
						</table>
					  </td>
					</tr>
					
					<c:if test="${ext=='1'}">
					<tr>
							<td colspan="6" class="paddingLR" height="30">
									  	<table BORDER=1 cellspacing="0" cellpadding="0" width="100%" height="100%">
												<TR>
													<TD class="font-12px" title="${v3x:toHTML(bean.title)}">&nbsp;&nbsp;
														<fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
														${v3x:getLimitLengthString(v3x:toHTML(bean.title), 30, "...")}
													</TD>
													<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
													<TD class="font-12px" title="${v3x:toHTML(publishScopeStr)}">&nbsp;&nbsp;
														<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
						    							${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 30, "..."))}
													</TD>
												</TR>
                        
                                            <c:choose>
                                               <c:when test="${bean.showPublishUserFlag}">
                                                <TR>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                    </TD>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                        <fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
                                                    </TD>
                                                </TR>
                                                <TR>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                                ${v3x:toHTML(bean.publishDeptName)}
                                                    </TD>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                        ${bean.readCount}
                                                    </TD>
                                                </TR>                                                
                                                </c:when>
                                                <c:otherwise>
                                                <TR>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                                ${v3x:toHTML(bean.publishDeptName)}
                                                    </TD>
                                                    <TD class="font-12px">&nbsp;&nbsp;
                                                        <fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                        <fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
                                                    </TD>
                                                </TR>
                                                <TR>
                                                    <TD class="font-12px" colspan="2">&nbsp;&nbsp;
                                                        <fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
                                                        ${bean.readCount}
                                                    </TD>
                                                </TR>                                                
                                                </c:otherwise>
                                            </c:choose>
										</table>
							 </td>
						</tr>
						<tr>
							<td align="center">
						&nbsp;
							</td>
						</tr>				
						<tr>
							<td align="center">
							<div id="noprint" style="visibility:visible">
						 	 <c:if test="${bean.ext1=='1'}"><!-- 发布时选中访问信息记录才显示---选中为“1” -->
							 	<c:if test="${readList!=null}">
									<input type="button" name="mergeButton" onclick="showReadList()" value="<fmt:message key="bul.userView.CallInfo" />" />
								</c:if>
							 </c:if>
							 
							</div>
							</td>
						</tr>
					</c:if>
          
                              <c:if test="${ext=='2'}">
                        <tr>
                            <td class="paddingLR font-12px" height="30"><b><fmt:message
                                key="bul.propertyinfo.label" /><fmt:message key="label.colon" /></b>
                            </td>
                        </tr>

                        <tr>
                            <td class="paddingLR" height="40" id="paddId">
                            <div style="padding-left: 20px;">
                            <table cellspacing="0" cellpadding="0" width="100%" height="100%">
                                <tr style="padding: 4px;">
                                    <td class="font-12px" width="10%"><fmt:message
                                        key="bul.data.title" /><fmt:message key="label.colon" /></td>

                                    <td class="font-12px" title="${v3x:toHTML(bean.title)}"
                                        width="40%">
                                    ${v3x:toHTML(v3x:getLimitLengthString(bean.title, 30, "..."))}
                                    </td>

                                    <c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}"
                                        var="publishScopeStr" />
                                    <td class="font-12px" width="10%"><fmt:message
                                        key='common.issueScope.label' bundle="${v3xCommonI18N}" /><fmt:message
                                        key="label.colon" /></td>
                                    <td class="font-12px" title="${v3x:toHTML(publishScopeStr)}" width="40%">
                                    ${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 30, "..."))}</td>
                                </tr>
                                <c:choose>
                                    <c:when test="${bean.showPublishUserFlag}">
                                         <tr style="padding: 4px;">
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="bul.data.createUser" /><fmt:message key="label.colon" />
                                              </td>
                                              <td class="font-12px" width="40%"></td>
          
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="bul.data.publishDate" /><fmt:message key="label.colon" />
                                              </td>
                                              <td class="font-12px" width="40%"><fmt:formatDate
                                                  value="${bean.createDate}" pattern="${datePattern}" /></td>
                                          </tr>
          
                                          <c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
                                              <tr style="padding: 4px;">
                                                  <td class="font-12px" width="10%"><fmt:message
                                                      key="bul.data.auditUser" /><fmt:message key="label.colon" />
                                                  </td>
                                                  <td class="font-12px" width="40%">
                                                 </td>
          
                                                  <td class="font-12px" width="10%"><fmt:message
                                                      key="bul.data.auditDate" /><fmt:message key="label.colon" />
                                                  </td>
                                                  <td class="font-12px" width="40%"><fmt:formatDate
                                                      value="${bean.auditDate}" pattern="${datePattern}" /></td>
                                              </tr>
                                          </c:if>
          
                                          <tr style="padding: 4px;">
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="bul.data.publishDepartmentId" /><fmt:message
                                                  key="label.colon" /></td>
                                              <td class="font-12px" width="40%">
                                              <c:choose>
                                                  <c:when test="${publicCustom}">
                                                      ${spaceName}
                                                  </c:when>
                                                  <c:otherwise>
                                                      ${v3x:getOrgEntity('Department', bean.publishDepartmentId).name}
                                                  </c:otherwise>
                                              </c:choose>
                                              </td>
          
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="label.readCount" /><fmt:message key="label.colon" /></td>
                                              <td class="font-12px" width="40%">${bean.readCount}</td>
                                          </tr>                                 
                                    </c:when>
                                    <c:otherwise>
                                        <tr style="padding: 4px;">
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="bul.data.publishDepartmentId" /><fmt:message
                                                  key="label.colon" /></td>
                                              <td class="font-12px" width="40%">
                                                      ${v3x:toHTML(bean.publishDeptName)}
                                              </td>
          
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="bul.data.publishDate" /><fmt:message key="label.colon" />
                                              </td>
                                              <td class="font-12px" width="40%"><fmt:formatDate
                                                  value="${bean.createDate}" pattern="${datePattern}" /></td>
                                          </tr>
          
                                          <c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
                                              <tr style="padding: 4px;">
                                                  <td class="font-12px" width="10%"><fmt:message
                                                      key="bul.data.auditUser" /><fmt:message key="label.colon" />
                                                  </td>
                                                  <td class="font-12px" width="40%">
                                                  ${v3x:showMemberName(bean.auditUserId)}</td>
          
                                                  <td class="font-12px" width="10%"><fmt:message
                                                      key="bul.data.auditDate" /><fmt:message key="label.colon" />
                                                  </td>
                                                  <td class="font-12px" width="40%"><fmt:formatDate
                                                      value="${bean.auditDate}" pattern="${datePattern}" /></td>
                                              </tr>
                                          </c:if>
          
                                          <tr style="padding: 4px;">
                                              <td class="font-12px" width="10%"><fmt:message
                                                  key="label.readCount" /><fmt:message key="label.colon" /></td>
                                              <td class="font-12px" width="40%" colspan="3">${bean.readCount}</td>
                                          </tr>                                       
                                    </c:otherwise>
                                </c:choose>
                            </table>
                            </div>
                            </td>
                        </tr>

                        <tr>
                            <td height="5"></td>
                        </tr>

                        <tr>
                            <td align="center" height="15">
                            <div id="noprint" style="visibility: visible"><c:if test="${bean.ext2=='1'}">
                                <input type="button" name="mergeButton"
                                    onclick="printResult('${bean.dataFormat}', '${empty bean.ext5}')"
                                    class="button-default-2"
                                    value="<fmt:message key="oper.print" />" />
                            </c:if> <c:if test="${bean.ext2 != '1'}">
                                <script>officecanPrint = "false"; officecanSaveLocal = "false";</script>
                            </c:if> <c:if test="${isManager}">
                                <input type="button" name="mergeButton"
                                    onclick="showReadList('${param.id}','<fmt:message key="bul.userView.CallInfo" />')"
                                    value="<fmt:message key="bul.userView.CallInfo" />" />
                            </c:if></div>
                            </td>
                        </tr>

                        <tr>
                            <td height="5"></td>
                        </tr>
                    </c:if>
				</table>
				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>

</table>

</div>


</body>
<script type="text/javascript">
try{
    if (document.getElementById('contentTD').height > 0 && document.getElementById('officeFrameDiv')) {
        document.getElementById('officeFrameDiv').style.height = document.getElementById('contentTD').height + "px";
    }
}catch(e){}
</script>
</html>
