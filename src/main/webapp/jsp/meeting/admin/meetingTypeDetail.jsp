<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xAdminI18N"/>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>


		<script type="text/javascript">
		function init(){
			var readOnly = "${v3x:escapeJavascript(readOnly)}";
			if(readOnly == "true"){
				setReadOnly();
			}else{
//				xiangfan 注释，可以编辑系统预置类型数据	修复GOV-3074.
//				 var sortId = "${bean.sortId}";
//				 if(sortId=="1" || sortId=="2"){
//					 var nodes = document.getElementsByTagName("input");
//						for(var i = 0; i < nodes.length; i++){
//							try{
//
//								if(nodes[i].type=="hidden"){
//									nodes[i].disabled = false;
//									}
//								else if(nodes[i].id=="name"){
//									nodes[i].disabled = false;
//									}
//								else if(nodes[i].type=="button"){
//									nodes[i].disabled = false;
//									}
//								else{
//									nodes[i].disabled = true;
//									}
//							}catch(E){}
//						}
//						nodes = document.getElementsByTagName("select");
//						for(var i = 0; i < nodes.length; i++){
//							try{
//								nodes[i].disabled = true;
//							}catch(E){}
//						}
//					}
				}
		}

		function setReadOnly(){
			var nodes = document.getElementsByTagName("input");
			for(var i = 0; i < nodes.length; i++){
				try{
					nodes[i].disabled = true;
				}catch(E){}
			}
			nodes = document.getElementsByTagName("select");
			for(var i = 0; i < nodes.length; i++){
				try{
					nodes[i].disabled = true;
				}catch(E){}
			}

			document.getElementById("submitBtn").style.display="none";
			document.getElementById("cancelBtn").style.display="none";
		}

		function doSubmit(){
			var name = document.getElementById("name").value;
			if(!checkForm(document.getElementById('myForm'))){
				return false;
			}
			//特殊字符验证
			if(validateSubject(name)){
				return false;
			}
			if(name.trim()==""){
				alert("分类名称不能为空");
                return false;
			}
		}
		//校验会议名称特殊字符
		function validateSubject(v){
			var patrn = /^[^#￥%&~<>|\"']*$/;
			if(!patrn.test(v)){
				alert("会议分类名称不能包含特殊字符（# ￥ % & ~ < > | \ \" '），请重新录入！");
				return true;
			}
			return false;
		}

		</script>

	</head>
	<body onload="init()">
<script type="text/javascript">
/*
getDetailPageBreak();
*/
</script>
<form name="myForm" id="myForm" action="mtAdminController.do?method=meetingTypeAdd" method="post" target="hiddenIframe" onsubmit="return doSubmit();">
<input type="hidden" name="id" value="${v3x:toHTML(bean.id) }" />
<input type="hidden" name="sortId" value="${bean.sortId}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="97%" align="center" class="categorySet-bg">
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
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='admin.meetingtype.information.label' /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head"><div class="categorySet-body" style="padding:0;border-bottom:1px solid #a0a0a0;">
		<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key='admin.meetingCategory.name.label' />:</td>
			<td width="35%" nowrap="nowrap" class="new-column">
				<input type="text" name="name" id="name" inputName="<fmt:message key='admin.meetingtype.name.label' />" class="input-300px" maxSize="50" maxLength="50" value="${v3x:toHTML(bean.name) }" />
			</td>
		</tr>
		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key='admin.meetingCategory.state.label' />:</td>
			<td width="35%" nowrap="nowrap" class="new-column">
				<select inputName="<fmt:message key='admin.meetingtype.state.label' />" name="state" id="state" class="input-300px">
					<option value="1" <c:if test="${bean.state == 1}">selected</c:if> ><fmt:message key="admin.meetingtype.enabled.label" /> </option>
					<option value="0" <c:if test="${bean.state == 0}">selected</c:if> ><fmt:message key="admin.meetingtype.disable.label" /></option>
				</select>
			</td>

		</tr>
		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"  valign="top"><!--puyc 修改 2012年2月5日 <font color="red">*</font> --><fmt:message key='admin.meetingtype.content.label' />:</td>
			<td width="35%" nowrap="nowrap" class="new-column">
				<input type="checkbox"  id="content_1" name="content" value="1"><fmt:message key="admin.meetingtype.title.label" /><br>
				<input type="checkbox"  id="content_2" name="content" value="2"><fmt:message key="admin.meetingtype.leader.label" /><br>
				<input type="checkbox"  id="content_3" name="content" value="3"><fmt:message key="admin.meetingtype.attender.label" /><br>
				<input type="checkbox"  id="content_4" name="content" value="4"><fmt:message key="admin.meetingtype.tel.label" /><br>
				<input type="checkbox"  id="content_5" name="content" value="5"><fmt:message key="admin.meetingtype.notice.label" /><br>
				<input type="checkbox"  id="content_6" name="content" value="6"><fmt:message key="admin.meetingtype.plan.label" />
				<script type="text/javascript">

				 var content = "${v3x:escapeJavascript(bean.content)}";
				 if(content != null&& content.length > 0){
				 var contents = new Array();
					if(content.length > 1 ){
						if(content.substring(content.length-1,content.length)==",")
							content = content.substring(0,content.length-1);
							contents = content.split(",");
							 for(var i = 0;i<contents.length;i++){
										document.getElementById("content_"+contents[i]).checked=true;
							}
							}
					else{
						document.getElementById("content_"+content).checked=true;
						}
				 }

			</script>
			</td>
		</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
	<!-- -->
		<td height="42" align="center" class="bg-advance-bottom">
			<input id="submitBtn" type="submit" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
			<input id="cancelBtn" type="button" onclick="document.location='<c:url value="/common/detail.jsp" />';" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
		</td>
	</tr>
</table>
</form><iframe name='hiddenIframe' style='display:none'></iframe>
	</body>
</html>
