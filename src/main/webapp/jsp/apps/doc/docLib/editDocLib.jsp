<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/doc/js/docManager.js${v3x:resSuffix()}' />"></script>
<c:set value="${v3x:parseElementsOfIds(oldIds, 'Member')}" var="newowners"/>
<v3x:selectPeople id="per" panels="Department" selectType="Member"
	originalElements="${newowners}"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />
<script type="text/javascript">
	if('${docLib.type}' != '5')
		onlyLoginAccount_per = true;
</script>
</head>
<body>
<form action="" id="myform" name="myform" method="post">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="96%" align="center">	
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr> 	
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap">
					<c:choose>
						<c:when test="${param.flag == 'edit'}"><fmt:message key='doclib.jsp.editlib'/></c:when>
						<c:otherwise><fmt:message key='doclib.jsp.viewlib'/></c:otherwise>
					</c:choose>
					</td>					
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}" /></td>
				</tr>
			</table>
		</td>
	</tr>
     <tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<div id="docLibBody">
			<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
			<tr><td valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr align="center">
						<td align="center" valign="top" width="50%" nowrap="nowrap">
                        <fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doclib.jsp.doclibinfo'/></strong></legend>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="word-break:break-all;word-wrap:break-word">
                                <tr><td colspan="2">&nbsp;</td></tr>
								<tr> 
									<td class="bg-gray" width="30%" nowrap>
										<font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:
									</td>
						
									<td class="new-column" width="70%">
										<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
										<input type="text" name="theName" id="theName"  deaultValue="${defName}" 
											inputName="<fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />" 
											validate="isDeaultValue,notNull,notSpecChar" value="<c:out value="${v3x:_(pageContext, docLib.name)}" escapeXml="true" default='${defName}' />"
											${v3x:outConditionExpression(readOnly, 'readonly', '')} maxSize="80" size="66"
											onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />
									</td>
								</tr>
			
								<tr id="doc_manager">
									<td class="bg-gray" width="30%" nowrap><fmt:message key='doclib.jsp.manager'/>:</td>
									<td class="new-column"  width="70%">
										<fmt:message key="doclib.jsp.manager.defaultvalue" var="defManager"/>
										<input type="text" id="docManager" name="docManager"  readonly="readonly" style="cursor:hand"
										onclick="selectPeopleFun_per()" deaultValue="${defManager}" 
										inputName="<fmt:message key='doclib.jsp.manager'/>" 
										<c:if test="${docLib.type != 4}">validate="isDeaultValue,notNull"</c:if> size="66"
										title="${v3x:showOrgEntitiesOfIds(oldIds, 'Member', pageContext)}"
										value="${v3x:showOrgEntitiesOfIds(oldIds, 'Member', pageContext)}" ${v3x:outConditionExpression(readOnly, 'readonly', '')} 
										onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />
									</td>
								</tr>
								<tr>
									<td class="bg-gray" width="30%" nowrap valign="top">
										<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:
									</td>
									<td class="new-column" width="70%">
										<textarea rows="5" name="description" id="description" cols="68"
										inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" 
										validate="maxLength" maxSize="80" >${docLib.description}</textarea>	
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
									<input type="checkbox" id="columnEditable" name="columnEditable" onclick="changeValue(this)" ${docLib.columnEditable ? "checked" : ""}><fmt:message key='doclib.jsp.option.editable'/>
									</label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>
								
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="searchConditionEditable">
									<input type="checkbox" id="searchConditionEditable" name="searchConditionEditable" ${docLib.searchConditionEditable ? "checked" : ""} ${param.flag == 'view' ? 'disabled' : ''} onclick="changeValue(this)"><fmt:message key='doclib.jsp.option.searchconditioneditable'/>
									</label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>

								<tr>
									<td  width="30%" nowrap align="left">
									<label for="logView">
									<input type="checkbox" id="logView" name="logView" onclick="changeValue(this)" ><fmt:message key='doclib.jsp.option.ditailable'/>
									</label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>	
								<tr>
									<td  width="30%" nowrap align="left">
									 <label for="downloadLog">
									 <input type="checkbox" id="downloadLog" name="downloadLog"  onclick="changeValue(this)" ><fmt:message key='doc.menu.download.record.label'/>
									 </label>
									</td>
									<td>
										<div style="display: none;">
										</div>
									</td>
								</tr>									
								
								<tr>
									<td  width="30%" nowrap align="left">
									<label for="printLog">
									<input type="checkbox" id="printLog" name="printLog" onclick="changeValue(this)"><fmt:message key='doc.menu.print.record.label'/>
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

							<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								<td  class="bg-gray"><strong><fmt:message key='doclib.jsp.newoptions'/></strong></td>
								<td>&nbsp;</td>
								</tr>
								<tr><td width="30%">&nbsp;</td>
									<td width="80%">
										<label for="folderEnabled">
										<input type="checkbox" id="folderEnabled" name="folderEnabled" onclick="changeValue(this)"><fmt:message key='doclib.jsp.newfolder'/>				
									   </label>
									</td>																	
								</tr>
								<tr><td>&nbsp;</td>
								   <td>
								   	   <label for="a6Enabled">
								       <input type="checkbox" id="a6Enabled" name="a6Enabled" onclick="changeValue(this)"><fmt:message key='doclib.jsp.newdoc'/>
									   </label>
								   </td>
								</tr>	
								<tr><td>&nbsp;</td>
									<td>
									<label for="officeEnabled">
										<input type="checkbox" id="officeEnabled" name="officeEnabled" onclick="changeValue(this)"><fmt:message key='doclib.jsp.newofficedoc'/>	
									</label>
									<script type="text/javascript">
										if(${!v3x:isOfficeOcxEnable()}){
											document.getElementById("officeEnabled").checked = false;
											document.getElementById("officeEnabled").disabled = true;
										}
									</script>
									</td>
								</tr>
															
								<tr><td>&nbsp;</td>																	
									<td>
										<label for="uploadEnabled">
										<input type="checkbox" id="uploadEnabled" name="uploadEnabled" onclick="changeValue(this)"><fmt:message key='doclib.jsp.upload'/>
										</label>
									</td>	
								</tr>										
							</table>

						</td>
						<td width="5%">&nbsp;</td>

						<td align="center" valign="top" width="50%">							
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
												<td align="right"><div id="contentType" style="display:none">
                                                    <c:if test="${v3x:getSystemProperty('system.ProductId') != '7'}">
                                                        <a href="javascript:setContentType('${docLib.id}');"><fmt:message key='doclib.jsp.editcontenttype'/></a>&nbsp;&nbsp;
                                                    </c:if>
                                                </div></td>
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
									<td width="50%"><div id="columTable">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<c:forEach items="${columns}" var="column">									
								<tr height="18">
									<td width="30%" nowrap align="left" valign="top" title="${v3x:_(pageContext, column.showName)}">&nbsp;&nbsp;&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, column.showName), 32,'...')}</td>
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
										
										<div id="listColumnDefault" style="display:none"><a href="javascript:setDocListColumnDefault('${docLib.id}');"><fmt:message key='doclib.jsp.editcolumns.default'/> </a></div>

										</td><td align="right">
										<div id="listColumn" style="display:none"><a href="javascript:setDocListColumn('${docLib.id}');"><fmt:message key='doclib.jsp.editcolumns'/></a>&nbsp;&nbsp;</div>
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
										
										<div id="listSearchConfigDefault" style="${docLib.isSearchConditionDefault == false && param.flag != 'view' ? 'display:block' : 'display:none'}"><a href="javascript:setDocSearchConfigDefault('${param.id}');"><fmt:message key='doclib.jsp.editsearchconfig.default'/> </a></div>

										</td><td align="right">
										<div id="listSearchConfig" style="${docLib.searchConditionEditable==true && param.flag != 'view' ? 'display:block' : 'display:none'}"><a href="javascript:setDocSearchConfig('${param.id}');"><fmt:message key='doclib.jsp.editsearchconfigs'/></a>&nbsp;&nbsp;</div>
										</td>
									</tr>
								</table></td></tr>
							</table>
							</fieldset>
						</td>
					</tr>
				</table>
				</td></tr></table>
			</div>
		</td>
	</tr>
	<tr id="editButton" style="display:none">
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" class="button-default_emphasize"  onclick="modifyDocLib('${docLib.id}');" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" name="b1" id="b1">		
			<input type="button" class="button-default-2" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name="b2" id="b2"> 
		</td>
	</tr>
</table>	
<div id="memberId" style="display:none;"><input type='hidden' id='members' name='members' value='${oldIds}' /></div>	
</form>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
<script>
<!--
	var flag = "${param.flag}";

	var _columnEditable = '${docLib.columnEditable}';
	var _folderEnabled = '${docLib.folderEnabled}';
	var _a6Enabled = '${docLib.a6Enabled}';
	var _officeEnabled = '${docLib.officeEnabled}';	
	var _uploadEnabled = '${docLib.uploadEnabled}';
	var _logView = '${docLib.logView}';
    var _printObj = '${docLib.printLog}' ;
	var _downLoadobj = '${docLib.downloadLog}' ;

	var columnEditable = document.getElementById("columnEditable");
	var folderEnabled = document.getElementById("folderEnabled");
	var a6Enabled = document.getElementById("a6Enabled");
	var officeEnabled = document.getElementById("officeEnabled");
	var uploadEnabled = document.getElementById("uploadEnabled");
	var logView = document.getElementById("logView");
	var printObj = document.getElementById("printLog");
	var downLoadobj = document.getElementById("downloadLog");

	columnEditable.checked = _columnEditable == 'true';
	columnEditable.value = _columnEditable == 'true' ? 1 : 0;

	folderEnabled.checked = _folderEnabled == 'true';
	folderEnabled.value = _folderEnabled == 'true' ? 1 : 0;

	officeEnabled.checked = _officeEnabled == 'true';
	officeEnabled.value = _officeEnabled == 'true' ? 1 : 0;

	a6Enabled.checked = _a6Enabled == 'true';
	a6Enabled.value = _a6Enabled == 'true' ? 1 : 0;

	uploadEnabled.checked = _uploadEnabled == 'true';
	uploadEnabled.value = _uploadEnabled == 'true' ? 1 : 0;

	logView.checked = _logView == 'true';
	logView.value = _logView == 'true' ? 1 : 0;
	
	printObj.checked = _printObj == 'true';
	printObj.value = _printObj == 'true' ? 1 : 0;
	
	downLoadobj.checked = _downLoadobj == 'true';
	downLoadobj.value = _downLoadobj == 'true' ? 1 : 0;
			
	// 公文档案库
	<c:if test = "${docLib.type == 3}">
		folderEnabled.disabled = true;
		a6Enabled.disabled = true;
		officeEnabled.disabled = true;
		uploadEnabled.disabled = true;
		logView.disabled = true;
		logView.checked = true;
		downLoadobj.disabled = true;
		downLoadobj.checked = true;
		printObj.disabled = true;	
		printObj.checked = true;		
	</c:if>

	// 项目文档库
	<c:if test = "${docLib.type == 4}">
		document.getElementById("doc_manager").style.display = "none";
		columnEditable.checked = false;
		columnEditable.disabled = true;
	</c:if>
	
	if (flag == "edit") {
		editButton.style.display = "";
		if(_columnEditable == 'true' && '${docLib.type}' != '4')
			listColumn.style.display = "block";
		contentType.style.display = "block";
		if(_columnEditable == 'true' && '${docLib.isDefault}' == 'false')
			listColumnDefault.style.display = "block";
	}
	else {
		var nameObj = document.getElementById("theName");
		nameObj.disabled = true;
		var ownerObj = document.getElementById("docManager");
		ownerObj.disabled = true;
		var descObj = document.getElementById("description");
		descObj.readOnly = true;
		folderEnabled.disabled = true;
		a6Enabled.disabled = true;
		officeEnabled.disabled = true;
		uploadEnabled.disabled = true;
		columnEditable.disabled = true;
		logView.disabled = true;
		downLoadobj.disabled = true;
		printObj.disabled = true;				
	}
//-->
</script>
</body>
</html>
<script>
  bindOnresize('docLibBody',20,90);
</script>