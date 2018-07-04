<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
</head>
<body>
<form action="" name="mainForm" id="mainForm" method="post">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="96%" align="center" class="">	
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
					<c:if test="${param.flag == 'edit'}">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='doc.property.editproperty.label'/></td>
					</c:if>
					<c:if test="${param.flag != 'edit'}">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='doc.property.viewproperty.label'/></td>
					</c:if>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<div id="docLibBody">
				<table width="70%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr align="center">
						<td valign="middle">
<!-- Del By Lif Start -->		

<!-- Del End -->	
							<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">			
								<tr>
									<td class="bg-gray" width="25%" nowrap>
										<font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:</td>
									<td class="new-column" width="75%" >
										<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
										<input type="text" name="theName" id="theName" class="input-100per"  deaultValue="${defName}" 
										inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" maxSize="20"  
										validate="isDeaultValue,notNull" value="<c:out value="${name}" escapeXml="true" default='${defName}' />" onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"  />
									</td>
								</tr>								
								
								<tr>
									<td class="bg-gray" width="25%" nowrap>
										<font color="red">*</font><fmt:message key='common.type.label' bundle="${v3xCommonI18N}"/>:
									</td>
									<td class="new-column" width="75%">
										${v3x:_(pageContext, metadataType)}
									</td>
								</tr>
			
								
								<tr>
									<td class="bg-gray" width="25%" nowrap valign="top">
									</td>
									<td class="new-column" width="75%">
									<!-- 
									<font color="red">(
										<fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
											<fmt:param value="120" />
										</fmt:message>)</font>
										 -->
									</td>
								</tr>

								<!-- category start -->
								<tr>
									<td class="bg-gray" width="25%" nowrap ><font color="red">*</font><fmt:message key='common.category.label' bundle="${v3xCommonI18N}" />:</td>
									<td class="new-column" width="75%"><label for="1"><input type="radio" name="newCategory" value="0" onclick="changeCategory();" checked id="1">&nbsp;<fmt:message key='metadataDef.selectCategory.label'/></label>:&nbsp;&nbsp;&nbsp;<select id="meta_category" name="meta_category" class="input-50per"  >
													<c:forEach items="${category}" var="category">
														<option value="${category}" ${category eq metadata.category ? 'selected' : ''}>${v3x:_(pageContext, category)}</option>
													</c:forEach>
													</select>
									</td>
								</tr>								
			
								<tr>
									<td class="bg-gray" width="25%" nowrap>&nbsp;</td>
									<td class="new-column" width="75%">
									<label for="newCategory2">
									<input type="radio" name="newCategory" value="1" onclick="changeCategory();" id="newCategory2">
									<fmt:message key='metadataDef.newCategory.label'/></label>:&nbsp;&nbsp;
									<input type="text" name="category_name" id="category_name" class="input-50per" disabled
									validate="maxLength,isWord" maxSize="10" inputName="<fmt:message key='metadataDef.newCategory.label'/>"
									>
									</td>
								</tr>
								<!-- category end -->
							</table>
<!-- Del By Lif Start -->		

<!-- Del End -->	

							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr><td>&nbsp;</td></tr>
							</table>
							
<!-- Del By Lif Start -->		

<!-- Del End -->	
							<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">								
								
								<!-- nullable start 
								<tr id="nullable">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.nullable.label'/>:</td>
									<td class="new-column" width="75%">
										<input type="radio" id="isNull" name="isNull" value="1" checked><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/>
										<input type="radio" id="isNull" name="isNull" value="0"><fmt:message key='common.no' bundle="${v3xCommonI18N}"/>
									</td>
								</tr>-->
								<!-- nullable end -->
								
								<!-- can be used as search condition start -->
								<tr id="searchable">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.searchable.label'/>:</td>
									<td class="new-column" width="75%">
										<label for="searchable1">	
											<input type="radio" id="searchable1" name="searchable" value="1" ${metadata.searchable ? "checked" : ""} ${metadata.isSystem || param.flag == 'view' ? "disabled" : ""} /><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/>
										</label>
										<label for="searchable0">	
											<input type="radio" id="searchable0" name="searchable" value="0" ${metadata.searchable == false ? "checked" : ""} ${metadata.isSystem || param.flag == 'view' ? "disabled" : ""} /><fmt:message key='common.no' bundle="${v3xCommonI18N}"/>
										</label>
									</td>
								</tr>
								<!-- can be used as search condition start -->

								<!-- default value start -->
								<tr id="defaultValue">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.defaultvalue.label'/>:</td>
									<td class="new-column" width="75%">
										<input type="text" maxlength="6" maxSize="6"  id="defaultValue" validate="maxLength" name="defaultValue" class="input-30per">
									</td>
								</tr>
								

								
								
																<tr id="defaultValue_int" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.defaultvalue.label'/>:</td>
									<td class="new-column" width="75%">
										<input type="text" id="defaultValue_int" name="defaultValue_int" class="input-30per"
										validate="isNumber,maxLength" maxSize="6" maxlength="6" inputName="<fmt:message key='doc.property.defaultvalue.label'/>"
										>
									</td>
								</tr>
																<tr id="defaultValue_decimal" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.defaultvalue.label'/>:</td>
									<td class="new-column" width="75%">
										<input type="text" id="defaultValue_decimal" name="defaultValue_decimal" class="input-30per"
										validate="isNumber" maxlength="9" decimalDigits="2" integerMax="999999.99" inputName="<fmt:message key='doc.property.defaultvalue.label'/>"
										>
									</td>
								</tr>
								

								<!-- default value end -->
								
								<!-- number start -->								
								<tr id="number" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.ispercent.label'/>:</td>
									<td class="new-column" width="75%">
									<label for="isPercent1">
										<input type="radio" id="isPercent1" name="isPercent" value="1"
										${v3x:outConditionExpression(metadata.isPercent=='true', 'checked', '')}
										><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/>
									</label>
									<label for="isPercent2">
										<input type="radio" id="isPercent2" name="isPercent" value="0" 
										${v3x:outConditionExpression(metadata.isPercent=='false', 'checked', '')}
										><fmt:message key='common.no' bundle="${v3xCommonI18N}"/>
									</label>
									</td>
								</tr>
								<!-- number end -->		
								
								<!-- yesOrNo start -->
								<tr id="yesOrNo" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.defaultvalue.label'/>:</td>
									<td class="new-column" width="75%">
									<label for="yesOrNo_default1">
										<input type="radio" id="yesOrNo_default1" name="yesOrNo_default" value="1" /><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/>
									</label>
									<label for="yesOrNo_default2">
										<input type="radio" id="yesOrNo_default2" name="yesOrNo_default" value="0" checked><fmt:message key='common.no' bundle="${v3xCommonI18N}"/>
									</label>
									</td>
								</tr>
								<!-- yesOrNo end -->
								
								
								

								<!-- date and time: start -->								
								<tr id="datetime" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='doc.property.defaultvalue.label'/>:</td>
									<td class="new-column" width="75%">
									<label for="nowTime1">
										<input type="radio" id="nowTime1" name="nowTime" value="1"><fmt:message key="doc.property.currenttime.label"/>
									</label>
									<label for="nowTime0">
										<input type="radio" id="nowTime0" name="nowTime" value="0" checked><fmt:message key="doc.property.none.label"/>
									</label>
									</td>
								</tr>
								
								<!-- date and time: end -->
								
								<!-- enumeration: start -->
								<tr id="list" style="display:none;">
									<td colspan="2">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="bg-gray" width="25%" valign="top" nowrap><font color="red">*</font><fmt:message key="doc.property.addoption.label"/>:</td>
												<td class="new-column" width="75%">
													<select multiple="multiple" size="3" id="addContent" name="addContent" class="input-50per">
													<c:forEach var="the_item" items="${listEnum}">
													<!-- 增加title属性 -->
														<option value="${the_item}" title="${the_item}">${the_item}</option>
													</c:forEach>
													</select>
												</td>
											</tr>
											<tr id="addOption" style="display:none">
												<td class="bg-gray" width="25%" nowrap></td>
												<td class="new-column" width="75%">
													<input type="text"  id="enmuName" name="enmuName" style="width: 50%;"  validate="isWord"
													 maxSize="80" inputName="<fmt:message key="doc.property.addoption.label"/>"
													>
													<input type="button" value="<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}'/>" onclick="addOption();" >&nbsp;&nbsp;<input type="button" value="<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}'/>" onclick="removeOption();" >
												</td>
											</tr>
										</table>
									</td>
								</tr>

								<tr>
									<td class="bg-gray" width="25%" nowrap valign="top">
										<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:
									</td>
									<td class="new-column" width="75%">
										<textarea rows="5" cols="38" id="description" name="description" class="input-100per"
										 inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="80">${metadata.description}</textarea>
									</td>
								</tr>
								<!-- enumeration: end -->

								<!-- userOrDept start -->
								<tr id="userOrDept" style="display:none;">
									<td class="bg-gray" width="25%" nowrap><fmt:message key='metadataDef.allselect.label'/>:</td>
									<td class="new-column" width="75%">
									<label for="isUser1">
										<input type="radio" id="isUser1" name="isUser" value="1" checked><fmt:message key='metadataDef.user.label'/>
									</label>
									<label for="isUser2">
										<input type="radio" id="isUser2" name="isUser" value="0"><fmt:message key='metadataDef.department.label'/>
									</label>
									</td>
								</tr>
								<!-- userOrDept end -->	
							</table>
<!-- Del By Lif Start -->		

<!-- Del End -->	
						</td>
					</tr>
				</table>		
			</div>
		</td>
	</tr>

	<tr id="editButton" style="display:none">
		<td height="42" align="center" class="bg-advance-bottom" colspan="2">
			<input type="button" id="b1" name="b1" onclick="updateDocProperty();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" id="b2" name="b2" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>

</table>
<input type="hidden" id="metadataId" name="metadataId" value="${metadata.id}">
<input type="hidden" id="type" name="type" value="${metadata.type}">
<input type="hidden" id="theContent" name="theContent">
</form>
<script type="text/javascript">
<!--
	var flag = "${param.flag}";

	//var nullable = "${metadata.nullable}";
	var defaultValue = "${metadata.defaultValue}";
	var isPercent = "${metadata.isPercent}";
	var isSystem = "${metadata.isSystem}";
	var isDefault = "${metadata.isDefault}";
	var type = '${metadata.type}';

	//if (nullable == "true") {
	//	mainForm.isNull[0].checked = true;
	//}
	//else {
	//	mainForm.isNull[1].checked = true;
	//}


	var _defaultValue = document.getElementById("defaultValue"); // Ĭ��
	var _defaultValue_int = document.getElementById("defaultValue_int");
	var _defaultValue_decimal = document.getElementById("defaultValue_decimal");
		//var _nullable = document.getElementById("nullable"); // �Ƿ�����Ϊ��
	var _number = document.getElementById("number"); // ����
	var _datetime = document.getElementById("datetime"); // ����ʱ��	
	var _yesOrNo = document.getElementById("yesOrNo"); // ��|��
	var _list = document.getElementById("list"); //ö��

	//��������
	if (type == '1') { // single line of text 
		mainForm.defaultValue.value = defaultValue;
	}
	else if (type == '2') { // number int
		_number.style.display = "";
		_defaultValue.style.display = "none";
		_defaultValue_int.style.display = "";
		mainForm.defaultValue_int.value = defaultValue;
	}
	else if (type == '3') { // number decimal
		_number.style.display = "";
				_defaultValue.style.display = "none";
		_defaultValue_decimal.style.display = "";
		mainForm.defaultValue_decimal.value = defaultValue;
	}
	else if (type == '4' || type == '5') { // date and time
		_datetime.style.display = "";
		_defaultValue.style.display = "none";
		//_nullable.style.display = "none";
		if(defaultValue == '1'){
			mainForm.nowTime1.checked = true;
		}
	}
	else if (type == '7') { // yes or no
		_yesOrNo.style.display = "";
		_defaultValue.style.display = "none";
		
		if(defaultValue == "true"){
			document.getElementById("yesOrNo_default1").checked = true;
		}else{
			document.getElementById("yesOrNo_default2").checked = true;
		}
	}
	else if (type == '13') { // enumeration
		_list.style.display = "";
		_defaultValue.style.display = "none";
	}
	else if (type == '6') { // multiple lines of text
		_defaultValue.style.display = "none";
	}
	else if (type == '8' || type == '9') {
		_defaultValue.style.display = "none";
	}
	

	
	if (flag != "edit" || isSystem == "true") {
		mainForm.theName.disabled = true;
		mainForm.description.disabled = true;
		mainForm.newCategory[0].disabled = true;
		mainForm.newCategory[1].disabled = true;
		mainForm.meta_category.disabled = true;
		//mainForm.isNull[0].disabled = true;
		//mainForm.isNull[1].disabled = true;
		mainForm.defaultValue.disabled = true;
		mainForm.defaultValue_int.disabled = true;
		mainForm.defaultValue_decimal.disabled = true;
		//mainForm.addContent.disabled = true;
		mainForm.nowTime[0].disabled = true;
		mainForm.nowTime[1].disabled = true;
		mainForm.yesOrNo_default[0].disabled = true;
		mainForm.yesOrNo_default[1].disabled = true;
		mainForm.isPercent[0].disabled = true;
		mainForm.isPercent[1].disabled = true;
	}
	else {
		editButton.style.display = "";
		var obj = document.getElementById("addOption");
		obj.style.display = "";	
	}

//-->
</script>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
</body>
</html>
<script>
  bindOnresize('docLibBody',20,80);
</script>