<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /></c:if><fmt:message key="mt.mtMeeting" />
	</title>
	<%@ include file="../include/header.jsp" %>
</head>
<body scroll='no'>
<script type="text/javascript">
	
	//模板名称map判断重名用
	var tempNameMap = new Properties();

	function loadContentTemplate(){
		if($F('templateId')==''){
			alert(v3x.getMessage("meetingLang.choose_text_format"));
			return;
		}
		if(confirm(v3x.getMessage("meetingLang.load_text_sure"))){
			//$('templateIframe').src='<c:url value="/bulTemplate.do?method=detail" />&preview=true&load=true&id='+$F('templateId');;
			$('formOper').value="loadTemplate";
			$('method').value="${param.method}";
			saveAttachment();
			saveOffice();
			validata();
			isFormSumit = true;
			$('dataForm').submit();
		}
	}
	
	function saveAsTemplate(){
		validata();
		$('method').value="saveAsTemplate";
		saveAttachment();
		cloneAllAttachments();
		saveOffice();
		isFormSumit = true;
		disableButtons();
		$('dataForm').submit();
	}
	
		function selectResources(){
			var dlgArgs=new Array();		
			dlgArgs['width']=300;
			dlgArgs['height']=400;
			dlgArgs['url']='${mtTemplateURL}?method=selectResources';
			var elements=v3x.openWindow(dlgArgs);
			if(elements!=null){
				$('resourcesId').value=getIdsString(elements,false);
				$('resourcesName').value=getNamesString(elements,true);
			}
		}

		function chanageBodyTypeExt(type){
			if(chanageBodyType(type))
			  $('dataFormat').value=type;
		}
		
		//保存按钮事件
		function save(){
		
			if(checkForm($('dataForm'))){
			
				saveAttachment();
				saveOffice();
				validata();
				isFormSumit = true;
				trimTitle();
				
				var tempName = $('title').value;
				//判断模板名称是否重复
				if(tempNameMap.get(tempName)!='${bean.id}'){  //修改时不做判断
					if(tempNameMap.get(tempName)){
						alert(v3x.getMessage("meetingLang.template_already_exist"));
						return;
					}
				}
				
				disableButtons();
				
				$('dataForm').submit();
			}
			
		}
		
		function validata(){
		
			if($('beginDate').value==document.getElementById("valiName").value){
    			$('beginDate').value = "";
    		}
			if($('endDate').value==document.getElementById("valiName").value){
    			$('endDate').value = "";
    		}
		}
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}", "gray");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	    	
    	var bodyTypeSelector = new WebFXMenu;
    	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_HTML", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeWord", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeExcel", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsWord", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
		bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsExcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
		    	
		//myBar.add(new WebFXMenuButton("draft", "<fmt:message key='oper.draft' />", "send()", "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("submit", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}'/>", "save()", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
    	<c:if test="${bean.id!=null}">
    	myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='oper.saveAs.meeting' />", "saveAsTemplate();", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));    	
    	</c:if>
    	    	
 		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));
    	//myBar.add(${v3x:bodyTypeSelector("v3x")});
    	//myBar.add(new WebFXMenuButton("return", "<fmt:message key='oper.return' />", "window.location.href='${mtTemplateURL}?method=listMain&templateType=0';", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));
    	//document.write(myBar);
    	//document.close();
    	
    	function chooseEndDate(obj){
    		if($('endDate').value==document.getElementById("valiName").value){
    			$('endDate').value = "";
    		}
    		whenstart('${pageContext.request.contextPath}', obj, event.clientX, event.clientY+100,'datetime');
    	}
    	
    	function chooseBeginDate(obj){
    		if($('beginDate').value==document.getElementById("valiName").value){
    			$('beginDate').value = "";
    		}
    		whenstart('${pageContext.request.contextPath}', obj, event.clientX, event.clientY+100,'datetime');
    	}
    	
    	function disableButtons() {
		    disableButton("insert");
		    disableButton("bodyTypeSelector");
		    disableButton("submit");
		    if(${bean.id!=null}){
		       disableButton("saveAs");
		    }
		}
		
		function trimTitle(){
			var title = $('title').value;
			$('title').value = title.trim();
		}
		
		//不进行职务级别的筛选
		isNeedCheckLevelScope_emcee = false;
		isNeedCheckLevelScope_conferees = false;
		isNeedCheckLevelScope_recorder = false;
</script>

    	
<div class="newDiv">
<form id="dataForm" name="dataForm" action="${mtTemplateURL}" method="post" onsubmit="return checkForm(this)">
<input type="hidden" name="method" value="save" />
<input type="hidden" name="formOper" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="templateType" value="0" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<c:forEach items="${personTemplateList}" var="temp">
	<script>
		tempNameMap.put('${temp.title}','${temp.id}');
	</script>
</c:forEach>
<c:set value="${v3x:parseElements(emceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(recorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(confereeList, 'id', 'entityType')}" var="confereesList"/>
<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="conferees" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Outworker" maxSize="0" selectType="Member,Department,Team" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<fmt:message key="click.choice" var="valiName"/>
<input type="hidden" id="valiName" value="${valiName}" >

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="22">
				<script type="text/javascript">
					document.write(myBar);
					var elements_emceeArr = elements_emcee;
					var elements_confereesArr = elements_conferees;
					var elements_recorderArr = elements_recorder;
				</script>
			</td>
		</tr>
		<tr><td height="10" class="detail-summary"><table border="0" height="10" cellpadding="0" cellspacing="0" width="100%" align="center">
		<tr class="bg-summary lest-shadow">
			<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></td>
			<td width="42%">
				<jsp:include page="../include/inputDefine.jsp">
					<jsp:param name="_property" value="title" />
					<jsp:param name="_key" value="mt.mtMeeting.title" />
					<jsp:param name="_validate" value="notNull,isDeaultValue" />
				</jsp:include>
			</td>
			<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" /></td>
			<td width="42%">
				<fmt:message key='click.choice' var="def"/>
				<fmt:formatDate pattern='${datetimePattern}' value='${bean.beginDate}' var="beginD" />
				<input type="text" readonly="readonly" class="input-100per" name="beginDate" onclick="chooseBeginDate(this)" inputName="<fmt:message key="mt.mtMeeting.beginDate" />"  value="${beginD == null ? def : beginD }" />
			</td>
		</tr>
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<fmt:message key="mt.mtMeeting.emceeId" var="_myLabel"/>
				<fmt:message key="label.please.select" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message>

				<input type="hidden" name="emceeId" value="${bean.emceeId}"/>
				<input type="text" class="input-100per cursor-hand" name="emceeName" readonly="true" 
					value="<c:out value="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
					title="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}"
					deaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${_myLabel}" 
					validate="notNull,isDeaultValue"
					onclick="selectMtPeople('emcee','emceeId');"
					/>
			</td>
			<td class="bg-gray"><fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<fmt:formatDate pattern='${datetimePattern}' value='${bean.endDate}' var="endD" />
				<input readonly="true" escapeXml="true" type="text" class="input-100per" name="endDate" onclick="chooseEndDate(this)" inputName="<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />"  value="${endD == null ? def : endD }" />
			</td>
		</tr>
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.conferees" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
				<fmt:message key="label.please.select" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message>
				
				<input type="hidden" name="conferees" value="${bean.conferees}"/>
				<input type="text" class="input-100per cursor-hand" name="confereesNames" readonly="true" 
					value="<c:out value="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
					title="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}"
					deaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${_myLabel}" 
					validate="notNull,isDeaultValue"
					onclick="selectMtPeople('conferees','conferees');"
					/>
			</td>
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.remindFlag" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<input type="checkbox" name="remindFlag" inputName="<fmt:message key="mt.mtMeeting.remindFlag" />" validate="notNull" value="${bean.remindFlag}" 
					onclick="this.checked?$('beforeTime').disabled=false:$('beforeTime').disabled=true;"
					/>
				<select name="beforeTime" value="${bean.beforeTime}" disabled>
					<v3x:metadataItem metadata="${remindTimeMetaData}"
						showType="option" name="beforeTime" selected="${bean.beforeTime}" />
				</select>
				<script type="text/javascript">
					$('remindFlag').checked=<c:if test="${bean.remindFlag}">true</c:if><c:if test="${!bean.remindFlag}">false</c:if>;
					$('remindFlag').checked?$('beforeTime').disabled=false:$('beforeTime').disabled=true;
					//setSelectValue("beforeTime","${bean.beforeTime}");
				</script>
			</td>
		</tr>
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<fmt:message key="mt.mtMeeting.recorderId" var="_myLabel"/>
				<fmt:message key="label.please.select" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message>
				
				<input type="hidden" name="recorderId" value="${bean.recorderId}"/>
				<input type="text" class="input-100per cursor-hand" name="recorderName" readonly="true" 
					value="<c:out value="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
					title="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}"
					deaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${_myLabel}" 
					validate="notNull,isDeaultValue"
					onclick="selectMtPeople('recorder','recorderId');"
					/>
			</td>
			<td class="bg-gray"><fmt:message key="mt.resource"/><fmt:message key="label.colon" /></td>
			<td class="value">
				<input type="hidden" name="resourcesId" value="${bean.resourcesId}" />
				<input type="text" style="width:80%" readonly="readonly" name="resourcesName" value="${bean.resourcesName}" onclick="selectResources();"/>
			</td>
		</tr>
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.projectId" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<select name="projectId" class="input-100per" value="${bean.projectId}">
					<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.projectId" />&gt;</option>
					<c:forEach items="${projectMap}" var="project">
						<option value='${project.id}'>${project.projectName}</option>
					</c:forEach>
				</select>
				<script type="text/javascript">
					setSelectValue("projectId","${bean.projectId}");
				</script>
			</td>
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.templateId" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<select name="templateId" style="width:80%" value="${bean.templateId}">
					<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.templateId" />&gt;</option>
					<c:forEach items="${contentTemplateList}" var="contentTemplate">
						<option value='${contentTemplate.id}'>${contentTemplate.templateName}</option>
					</c:forEach>
				</select>
				<script type="text/javascript">
					setSelectValue("templateId","${bean.templateId}");
				</script>
				<input type="button" id="loadTemplate" value="<fmt:message key="oper.load" />" onclick="loadContentTemplate();" />
			</td>
		</tr>
		<!--  
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.address" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<jsp:include page="../include/inputDefine.jsp">
					<jsp:param name="_property" value="address" />
					<jsp:param name="_key" value="mt.mtMeeting.address" />
					<jsp:param name="_validate" value="" />
				</jsp:include>
			</td>
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.room" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<select name="room" class="input-100per" value="${bean.room}" >
					<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.room" />&gt;</option>
					<c:forEach items="${meetingRomeList}" var="mtRome">
						<option value='${mtRome.id}'>${mtRome.name}</option>
					</c:forEach>
				</select>
				<script type="text/javascript">
					setSelectValue("room","${bean.room}");
				</script>
			</td>
		</tr>
		-->
		<tr id="attachmentTR" style="display:none;" class="bg-summary">

			<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="3">
				<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
				<v3x:fileUpload originalAttsNeedClone="true" attachments="${attachments}" canDeleteOriginalAtts="true" />
			</td>
		</tr>
		</table></td></tr>
		<tr>
  			<td colspan="9" height="6" class="bg-b"></td>
 		</tr>
		<tr>
			<td>
				<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" 
					createDate="${bean.createDate}" category="<%=ApplicationCategoryEnum.meeting.getKey()%>" originalNeedClone="${originalNeedClone}"/>
			</td>
		</tr>
	</table>

</form>
</div>

<c:if test="${null!=exception}">
<script type="text/javascript">
<!--
	alert("${exception.message}");
//-->
</script>
</c:if>
<jsp:include page="../include/deal_exception.jsp" />
</body>
</html> 