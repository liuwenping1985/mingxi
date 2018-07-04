<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">	
<!--
	function cancelAdd(){
		window.location.href= "<c:url value='/common/detail.jsp'/>";
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocLibManager", "cancelAdd", false);
		requestCaller.serviceRequest();
	}
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<v3x:selectPeople id="per" panels="Department" selectType="Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />
<script type="text/javascript">
	onlyLoginAccount_per = true;
</script>
</head>
<body>
<form id="myform" name="myform" method="post">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr align="center">
		<td height="8" class="detail-top" colspan="1">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr>
	<tr>
		<td height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='doclib.jsp.newlib'/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}" /></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<div id="docLibBody" style="overflow: auto;">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr align="center" valign="top">
						<td align="center" valign="top" width="60%">
                         <fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doclib.jsp.doclibinfo'/></strong></legend>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                <tr><td colspan="2">&nbsp;</td></tr>
								<tr> 
									<td class="bg-gray" width="30%" nowrap>
										<font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:
									</td>
							
									<td class="new-column" width="70%">
										<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
										<input type="text" name="theName" id="theName"   deaultValue="${defName}" 
									inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" 
									validate="isDeaultValue,notNull,notSpecChar" maxSize="80" size="66"
									 value="<c:out value="${docLib.name}" escapeXml="true" default='${defName}' />"
									 ${v3x:outConditionExpression(readOnly, 'readonly', '')}
									onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />
									</td>
							
								</tr>
			
								<tr>
									<td class="bg-gray" width="30%" nowrap><font color="red">*</font><fmt:message key='doclib.jsp.manager'/>:</td>
									<td class="new-column"  width="70%">
										<fmt:message key="doclib.jsp.manager.defaultvalue" var="defManager"/>
										<input type="text" id="docManager" name="docManager"  readonly="readonly" size="66" style="cursor:hand"
										onclick="selectPeopleFun_per()"  deaultValue="${defManager}" 
										inputName="<fmt:message key='doclib.jsp.manager'/>" 
										validate="isDeaultValue,notNull" 
										value="<c:out value="${authStr}" escapeXml="true" default='${defManager}' />" ${v3x:outConditionExpression(readOnly, 'readonly', '')} 
										onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />
									</td>
								</tr>
									
								<tr>
									<td class="bg-gray" width="30%" nowrap valign="top">
										<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:
									</td>
									<td class="new-column" width="70%">
										<textarea rows="5" cols="68" name="description" id="description"
										inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" maxSize="80" validate="maxLength" ></textarea>	
									</td>
								</tr>	
								
								<tr>
									<td class="bg-gray" width="30%" nowrap valign="top">
									</td>
									<td class="new-column description-lable" width="70%">
										(
										<fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
											<fmt:param value="80" />
										</fmt:message>)
									</td>
								</tr>
								<tr>
								<td></td>
								<td>
								<table>
                                </fieldset>
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="columnEditable">
									<input type="checkbox" id="columnEditable" name="columnEditable" value="1" onclick="changeValue(this)" checked><fmt:message key='doclib.jsp.option.editable'/>
									</label>
									</td>
									<td>
									</td>
								</tr>
								
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="searchConditionEditable">
									<input type="checkbox" id="searchConditionEditable" name="searchConditionEditable" checked value="1" onclick="changeValue(this)"><fmt:message key='doclib.jsp.option.searchconditioneditable'/>
									</label>
									</td>
									<td>
									</td>
								</tr>

								<tr>
									<td  width="30%" nowrap align="left">
									<label for="logView">
									<input type="checkbox" id="logView" name="logView" value="0" onclick="changeValue(this)"><fmt:message key='doclib.jsp.option.ditailable'/>
									</label>
									</td>
									<td>
									</td>
								</tr>
								
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="downloadLog">
									<input type="checkbox" id="downloadLog" name="downloadLog"  value="0" onclick="changeValue(this)" ><fmt:message key='doc.menu.download.record.label'/>
									</label>
									</td>
									<td>
									</td>
								</tr>									
								
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="printLog">
									<input type="checkbox" id="printLog" name="printLog"  value="0" onclick="changeValue(this)"><fmt:message key='doc.menu.print.record.label'/>
									</label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="shareEnabled">
									<input type="checkbox" id="shareEnabled" name="shareEnabled" onclick="changeValue(this)"><fmt:message key='doc.menu.share.enabled.label'/>
									</label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>
								</table>								
								</td>
								</tr>
							</table>

							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td class="bg-gray">
										<strong><fmt:message key='doclib.jsp.newoptions'/></strong>
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td width="30%">&nbsp;</td>
									<td width="80%">
										<label for="folderEnabled">
										<input type="checkbox" id="folderEnabled" name="folderEnabled" value="1" checked onclick="changeValue(this)"><fmt:message key='doclib.jsp.newfolder'/>				
										</label>
									</td>
								</tr>	
								<tr>
									<td width="30%">&nbsp;</td>							
									<td>
										<label for="a6Enabled">
										<input type="checkbox" id="a6Enabled" name="a6Enabled" value="1" checked onclick="changeValue(this)"><fmt:message key='doclib.jsp.newdoc'/>
										</label>
									</td>	
								</tr>
								
								<tr>
									<td width="30%">&nbsp;</td>	
									<td>
										<label for="officeEnabled">
										<input type="checkbox" id="officeEnabled" name="officeEnabled" value="1" checked onclick="changeValue(this)"><fmt:message key='doclib.jsp.newofficedoc'/>				
										</label>
										<script type="text/javascript">
											if("${v3x:hasPlugin('officeOcx')}" == "false"){
												document.getElementById("officeEnabled").checked = false;
												document.getElementById("officeEnabled").disabled = true;
											}
										</script>
									</td>
								</tr>
								<tr>	
									<td width="30%">&nbsp;</td>
									<td>
										<label for="uploadEnabled">
										<input type="checkbox" id="uploadEnabled" name="uploadEnabled" value="1" checked onclick="changeValue(this)"><fmt:message key='doclib.jsp.upload'/>
										</label>
									</td>	
								</tr>											
							</table>
						</td>
						
						<td width="5%">&nbsp;</td>
						
						<td align="center" valign="top" width="50%" style="padding-top:5px">
							<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doclib.jsp.contenttype'/></strong></legend>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="30%" nowrap align="left" valign="top">&nbsp;</td>
								</tr>

								<tr>
									<td width="50%">
									<div id="typeTable">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
										<c:forEach items="${contentTypes}" var="contentType">									
										<tr height="18">
											<td width="30%" nowrap align="left" valign="top" title="${v3x:_(pageContext, contentType.name)}">&nbsp;&nbsp;&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, contentType.name), 32,'...')}</td>
										</tr>
										</c:forEach>
										</table>
									</div>
									</td>
									<td width="50%" valign="bottom">
									</td>
								</tr>
																
								<tr>
									<td width="50%" height="3">
									</td>
									<td width="50%" valign="bottom">
									</td>
								</tr>	
																
								<tr>
									<td colspan="2" valign="bottom">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
											<tr>
                                                <c:if test="${v3x:getSystemProperty('system.ProductId') != '7'}">
												    <td align="right"><div id="contentType" style="display:block"><a href="javascript:setContentType('${newLibId}');"><fmt:message key='doclib.jsp.editcontenttype'/></a>&nbsp;&nbsp;</div></td>
											     </c:if>
                                            </tr>
										</table>
									</td>
								</tr>
							</table>
							</fieldset>												

							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr><td>&nbsp;</td></tr>
							</table>

							<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doclib.jsp.column'/></strong></legend>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="30%" nowrap align="left" valign="top">&nbsp;</td>
								</tr>
								<tr>
									<td width="50%">
									<div id="columTable">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
											<c:forEach items="${columns}" var="column">									
											<tr height="18">
												<td width="30%" nowrap align="left" valign="top" title="${v3x:_(pageContext, column.showName)}">&nbsp;&nbsp;&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, column.showName), 32,'...')}</td>
											</tr>
											</c:forEach>
										</table>
									</div>
									</td>
									<td width="50%" valign="bottom">
									</td>
								</tr>
								<tr><td colspan="2" height="3"></td></tr>
								<tr><td colspan="2">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td align="right">
												
												<div id="listColumnDefault" style="display:none"><a href="javascript:setDocListColumnDefault('${newLibId}');"><fmt:message key='doclib.jsp.editcolumns.default'/> </a></div>

												</td><td align="right">
												<div id="listColumn" style="display:block"><a href="javascript:setDocListColumn('${newLibId}');"><fmt:message key='doclib.jsp.editcolumns'/></a>&nbsp;&nbsp;</div>
												</td>
											</tr>
										</table></td></tr>
							</table>
							</fieldset>
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr><td>&nbsp;</td></tr>
							</table>

							<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doclib.jsp.searchconfig'/></strong></legend>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="30%" nowrap align="left" valign="top">&nbsp;</td>
								</tr>
								<tr>
									<td width="50%"><div id="searchConditionTable">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<c:forEach items="${searchConditions}" var="condition">									
								<tr height="18">
									<td width="30%" nowrap align="left" valign="top" title="${v3x:_(pageContext, condition.showName)}">&nbsp;&nbsp;&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, condition.showName), 32,'...')}</td>
								</tr>
								</c:forEach>
										</table></div>
									</td>
									<td width="50%" valign="bottom">
									</td>
								</tr>
								<tr><td colspan="2" height="3"></td></tr>
								<tr><td colspan="2">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="right">
										
										<div id="listSearchConfigDefault" style="display:none"><a href="javascript:setDocSearchConfigDefault('${newLibId}');"><fmt:message key='doclib.jsp.editsearchconfig.default'/> </a></div>

										</td><td align="right">
										<div id="listSearchConfig" style="display:block"><a href="javascript:setDocSearchConfig('${newLibId}');"><fmt:message key='doclib.jsp.editsearchconfigs'/></a>&nbsp;&nbsp;</div>
										</td>
									</tr>
								</table></td></tr>
							</table>
							</fieldset>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                <tr><td>&nbsp;</td></tr>
                            </table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" class="button-default_emphasize"  onclick="addDocLib();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" name="b1" id="b1"/> 
			<input type="button" class="button-default-2" onclick="cancelAdd();" value="<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />" name="b2" id="b2"/> 
		</td>
	</tr>
</table>	
<div id="memberId"></div>	
</form>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
</body>
</html>
<script>
	bindOnresize('docLibBody',20,110); 
</script>