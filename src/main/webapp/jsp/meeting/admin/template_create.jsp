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
		$('method').value="saveAsTemplate";
		saveAttachment();
		saveOffice();
		isFormSumit = true;
		$('dataForm').submit();
	}
	
		function selectResources(){
			var dlgArgs=new Array();		
			dlgArgs['width']=300;
			dlgArgs['height']=400;
			dlgArgs['url']='${mtTemplateURL}?method=selectResources';
			//mark by xuqiangwei Chrome37修改，这里应该被废弃了
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
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	myBar.add(new WebFXMenuButton("submit", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "if($('dataForm').onsubmit()){saveAttachment();saveOffice();validata(); isFormSumit = true; disableButtons();trimTitle();$('dataForm').submit();}", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));    	
    	    	
 		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	myBar.add(${v3x:bodyTypeSelector("v3x")});

    	myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "window.location.href='${mtTemplateURL}?method=listMain&templateType=1';", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));
		myBar.add(
			new WebFXMenuButton(
				"delBtn", 
				"<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}' />", 
				"selectAuthPeople();", 
				"<c:url value='/common/images/toolbar/auth.gif'/>", 
				"", 
				null
				)
		);

    	//document.write(myBar);
    	//document.close();
    	function myCheckForm(myForm){
    		if(!checkForm(myForm)){
    			return false;
    		}
    		
    		var tempName = $('title').value.trim();
    		
    		//判断模板名称是否重复
    		if(tempNameMap.get(tempName)!='${bean.id}'){  //修改时不做判断
				if(tempNameMap.get(tempName)){
					alert(v3x.getMessage("meetingLang.template_already_exist"));
					return;
				}
			}
    		
    		return true;
    	}
    	
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
    	
    	function validata(){
			if($('beginDate').value==document.getElementById("valiName").value){
    			$('beginDate').value = "";
    		}
			if($('endDate').value==document.getElementById("valiName").value){
    			$('endDate').value = "";
    		}
		}
		function disableButtons() {
		    disableButton("insert");
		    disableButton("bodyTypeSelector");
		    disableButton("submit");
		    disableButton("return");
		}
		
		function trimTitle(){
			var title = $('title').value;
			$('title').value = title.trim();
		}
		
		function selectAuthPeople(){
			selectPeopleFun_selectPeopleByCreatePage();
		}
		
		function setPeopleFields(elements){
			$('authId').value = getIdsString(elements,true);
		}
		//不进行职务级别的筛选
		isNeedCheckLevelScope_emcee = false;
		isNeedCheckLevelScope_conferees = false;
		isNeedCheckLevelScope_recorder = false;
		
</script>

    	
<div class="newDiv">
<form id="dataForm" name="dataForm" action="${mtTemplateURL}" method="post" onsubmit="return myCheckForm(this)">
<c:set value="${v3x:parseElements(authUsers, 'id', 'entityType')}" var="auth"/>
<script>
	// 备忘：只选择本单位用户 kuanghs
	onlyLoginAccount_selectPeopleByCreatePage = true;
</script>
<v3x:selectPeople minSize="0" id="selectPeopleByCreatePage" panels="Department,Team" originalElements="${auth}" selectType="Member,Department" jsFunction="setPeopleFields(elements)" />

<input type="hidden" id="authId" name="authId" value="" />
<input type="hidden" name="method" value="save" />
<input type="hidden" name="formOper" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="templateType" value="1" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<c:set value="${v3x:parseElements(emceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(recorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(confereeList, 'id', 'entityType')}" var="confereesList"/>
<c:forEach items="${systemTemplateList}" var="temp">
	<script>
		tempNameMap.put('${temp.title}','${temp.id}');
	</script>
</c:forEach>
<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="conferees" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Outworker" maxSize="0" selectType="Member,Department,Team" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<fmt:message key="click.choice" var="valiName"/>
<input type="hidden" id="valiName" value="${valiName}" >

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="22" class="div-top-line-mercury">
				<script type="text/javascript">
					document.write(myBar);
					var elements_emceeArr = elements_emcee;
					var elements_confereesArr = elements_conferees;
					var elements_recorderArr = elements_recorder;
				</script>
			</td>
		</tr>
		<tr>
		<td height="10" class="detail-summary">
		<table border="0" height="10" cellpadding="0" cellspacing="0" width="100%" align="center">
		<tr class="bg-summary lest-shadow">
			<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></td>
			<td width="42%" colspan="3">
			<fmt:message key="mt.mtMeeting.title" var="_myLabel"/>
			<fmt:message key="label.please.input" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			<input type="text" class="input-100per" name="title"
				value="<c:out value="${bean.title}" default="${_myLabelDefault}" escapeXml="true" />" 
				title="${bean.title}"
				deaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}"
				maxSize="100"
				validate="notNull,isDeaultValue"
				${clearValue}
				/>
			</td>
			<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" /></td>
			<td width="17%">
				<fmt:message key='click.choice' var="def"/>
				<fmt:formatDate pattern='${datetimePattern}' value='${bean.beginDate}' var="beginD" />
				<input type="text" readonly="readonly" class="input-100per" name="beginDate" onclick="chooseBeginDate(this)" inputName="<fmt:message key="mt.mtMeeting.beginDate" />"  value="${beginD == null ? def : beginD }" />
			</td>
			<td width="8%" class="bg-gray"><fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td width="17%">
				<fmt:formatDate pattern='${datetimePattern}' value='${bean.endDate}' var="endD" />
				<input readonly="true" escapeXml="true" type="text" class="input-100per" name="endDate" onclick="chooseEndDate(this)" inputName="<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />"  value="${endD == null ? def : endD }" />
			</td>
		</tr>
		<tr class="bg-summary">
			<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
			<td class="value" width="18%">
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
			
			<td width="6%" class="bg-gray"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
			<td class="value" width="18%">
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
			
			<td class="bg-gray" width="8%"><fmt:message key="mt.mtMeeting.remindFlag" /><fmt:message key="label.colon" /></td>
			<td class="value" width="42%" colspan="3">
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
			<td class="bg-gray" width="8%"><fmt:message key="mt.mtMeeting.conferees" /><fmt:message key="label.colon" /></td>
			<td class="value" width="42%" colspan="3">
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
			
			<td class="bg-gray" width="8%"><fmt:message key="mt.resource"/><fmt:message key="label.colon" /></td>
			<td class="value" width="42%" colspan="3">
				<input type="hidden" name="resourcesId" value="${bean.resourcesId}" />
				<input type="text" style="width:80%" readonly="readonly" name="resourcesName" value="${bean.resourcesName}" onclick="selectResources();"/>
			</td>
			
		</tr>
		<tr class="bg-summary">
			<td class="bg-gray" width="8%"><fmt:message key="mt.mtMeeting.projectId" /><fmt:message key="label.colon" /></td>
			<td class="value" width="42%" colspan="3">
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
			<td class="bg-gray" width="8%"><fmt:message key="mt.mtMeeting.templateId" /><fmt:message key="label.colon" /></td>
			<td class="value" width="42%" colspan="3">
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
				<select name="room" class="input-100per" value="${bean.room}" inputName="<fmt:message key="mt.mtMeeting.room" />">
					<option value=""><fmt:message key="label.lt" /><fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.room" /><fmt:message key="label.gt" /></option>
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
		<!--  
		<c:if test="${bean.id!=null}">
		<tr class="bg-summary">
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.createUser" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.createUserName}</td>
			<td class="bg-gray"><fmt:message key="mt.mtMeeting.createDate" /><fmt:message key="label.colon" /></td>
			<td class="value"><fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/></td>
		</tr>
		</c:if>
		-->
		<tr id="attachmentTR" style="display:none;" class="bg-summary">

			<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value" colspan="7">
				<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
				<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
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

<jsp:include page="../include/deal_exception.jsp" />
</body>
</html> 