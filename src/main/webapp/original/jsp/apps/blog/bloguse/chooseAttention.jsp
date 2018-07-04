<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="../header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:set value="${v3x:parseElements(leaderlist, 'attentionId', 'typeProperty')}" var="elementleader"/>
<c:set value="${v3x:parseElements(assistantlist, 'attentionId', 'typeProperty')}" var="elementassistant"/>
<c:set value="${v3x:parseElements(juniorlist, 'attentionId', 'typeProperty')}" var="elementjunior"/>
<c:set value="${v3x:parseElements(confrerelist, 'attentionId', 'typeProperty')}" var="elementconfrere"/>
<script type="text/javascript">
	var excludeElements_leader = parseElements('${elementleader}');
	var excludeElements_assistant = parseElements('${elementassistant}');
	var excludeElements_junior = parseElements('${elementjunior}');
	var excludeElements_confrere = parseElements('${elementconfrere}');
	function selectLeaders(){
		excludeElements_chooseleader = joinArrays('leader',excludeElements_assistant,excludeElements_junior,excludeElements_confrere);
		selectPeopleFun_chooseleader();
	}
	function selectAssistants(){
		excludeElements_chooseassisitant = joinArrays('assistant',excludeElements_leader,excludeElements_junior,excludeElements_confrere);
		selectPeopleFun_chooseassisitant();
	}
	function selectJuniors(){
		excludeElements_choosejunior = joinArrays('junior',excludeElements_leader,excludeElements_assistant,excludeElements_confrere);
		selectPeopleFun_choosejunior();
	}
	function selectConfreres(){
		excludeElements_chooseconfrere = joinArrays('confrere',excludeElements_leader,excludeElements_assistant,excludeElements_junior);
		selectPeopleFun_chooseconfrere();
	}
</script>
<script type="text/javascript">
</script>
</head>
<html:link renderURL='/blog.do?method=createAttention'  var="setURL"/>
<body scroll="no">
<form action="${setURL}" method="post" name="relateform" onsubmit="return setData();">
	<table cellpadding="0" cellspacing="0" align="center" width="100%" height="100%">
		<tr>
			<td valign="top">
				<table width="100%"  cellpadding="0" cellspacing="0" align="center" border="0">
					<tr>
						<td height="60" valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="0" class="page2-header-line border_b">
							      <tr>
							        <td width="80" class="page2-header-img"><img src="<c:url value='/apps_res/peoplerelate/images/pic1.gif' />" width="80" height="60" /></td>
							        		        <td class="page2-header-bg">&nbsp;<fmt:message key="blog.attention"/></td>
							        <td>
										<div class="blog-div-float-right">
										<!-- ���� -->
										<a href="${detailURL}?method=blogHome" class="hyper_link2">
												[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
										</a>&nbsp;&nbsp;
										</div>
									</td>
							      </tr>
						    </table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td height="80%">
				<div class="scrollList">
					<table align="center" cellpadding="0" border="0" cellspacing="0" height="100%" width="100%">
						<input type="hidden" value="${elementleader}" name="noShowLeader">
						<input type="hidden" value="${elementassistant}" name="noShowAssistant">
						<input type="hidden" value="${elementjunior}" name="noShowJunior">
						<input type="hidden" value="${elementconfrere}" name="noShowConfrere">
						<tr>
							<td colspan="4" height="15">
						</tr>
						<tr>
							<td></td>
							<td align="left"><c:set value="${v3x:parseElements(confrerelist, 'attentionId', 'typeProperty')}" var="clist"/>
									<input class="button-default-2" type="button" name="chooseconfrere" value="<fmt:message key='blog.select.label'/>" onclick="selectConfreres();">
									<v3x:selectPeople id="chooseconfrere" showMe="false" memberId="${sessionScope['com.seeyon.current_user'].id}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" panels="Department" selectType="Member" originalElements="${clist}" minSize="0" jsFunction="getMember(elements,typeof(parentWindow)!='undefined'?parentWindow.document.all.confrere:document.all.confrere)"/>
							
							<script type="text/javascript">
							    isNeedCheckLevelScope_chooseconfrere = false;
							     onlyLoginAccount_chooseconfrere = false;
							</script></td>
						</tr>
						<tr>
							<td valign="top" width="30%" align="right">
									&nbsp;&nbsp;
							</td>
							
							<td valign="top" align="left">	
									<select id="confrere" name="confrere" style="WIDTH: 255px" size="15" multiple>
									<c:forEach items="${confrerelist}" var="cl">
									 		<option value="${cl.attentionId}" id="${cl.attentionId}"><c:out value="${cl.userName}"/></option>
									 </c:forEach>
									</select>&nbsp;&nbsp;
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		
		<tr>
			<td align="center" class="bg-advance-bottom" valign="bottom">
				<input type="submit" 
					value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>"
					class="button-default-2"> 
				<input type="button" onclick="reSet()" 
				value="<fmt:message key='common.button.reset.label' bundle='${v3xCommonI18N}' />" 
				class="button-default-2">
			</td>
		</tr>
		<div id="hiddenDataDiv" name="hiddenDataDiv"></div>
</table>
</form>	
</body>
</html>