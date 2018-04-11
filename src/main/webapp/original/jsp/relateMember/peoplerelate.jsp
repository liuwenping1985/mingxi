<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:set value="${v3x:parseElements(leaderlist, 'relateMemberId', 'typeProperty')}" var="elementleader"/>
<c:set value="${v3x:parseElements(assistantlist, 'relateMemberId', 'typeProperty')}" var="elementassistant"/>
<c:set value="${v3x:parseElements(juniorlist, 'relateMemberId', 'typeProperty')}" var="elementjunior"/>
<c:set value="${v3x:parseElements(confrerelist, 'relateMemberId', 'typeProperty')}" var="elementconfrere"/>
<style type="text/css">
	body{position: relative;height: 100%;overflow: hidden;}
	.topDiv{
		position: absolute;top:0;left:0;right:0;bottom:50px;overflow: auto;border:solid 1px #cdcdcd;
	}
	.bottomDiv{
		position: absolute; bottom: 0; width: 100%; height: 40px; padding-top: 10px; float: left; text-align: center; border:solid 1px #cdcdcd;border-top:none;
	}
</style>
<script type="text/javascript">

	//将我设为关联人员的map集合   key人员id  value关联类型
	var myRelateMap = new Properties();

	//进行职务级别的筛选
	isNeedCheckLevelScope_chooseleader = true;
	isNeedCheckLevelScope_chooseassisitant = true;
	isNeedCheckLevelScope_choosejunior = true;
	isNeedCheckLevelScope_chooseconfrere = true;//进行职务级别的筛选

	var excludeElements_leader = parseElements('${elementleader}');
	var excludeElements_assistant = parseElements('${elementassistant}');
	var excludeElements_junior = parseElements('${elementjunior}');
	var excludeElements_confrere = parseElements('${elementconfrere}');
	function selectLeaders(){
		excludeElements_chooseleader = joinArrays('chooseleader',excludeElements_assistant,excludeElements_junior,excludeElements_confrere);
		selectPeopleFun_chooseleader();
	}
	function selectAssistants(){
		excludeElements_chooseassisitant = joinArrays('chooseassisitant',excludeElements_leader,excludeElements_junior,excludeElements_confrere);
		selectPeopleFun_chooseassisitant();
	}
	function selectJuniors(){
		excludeElements_choosejunior = joinArrays('choosejunior',excludeElements_leader,excludeElements_assistant,excludeElements_confrere);
		selectPeopleFun_choosejunior();
	}
	function selectConfreres(){
		excludeElements_chooseconfrere = joinArrays('chooseconfrere',excludeElements_leader,excludeElements_assistant,excludeElements_junior);
		selectPeopleFun_chooseconfrere();
	}


	//将把我设为关联人员的列表存入map
	<c:forEach items="${myRelateList}" var="relate">
		myRelateMap.put('${relate.relatedMemberId}','${relate.relateType}');
	</c:forEach>

	<%--显示当前位置--%>
	showCtpLocation("F12_relate");

	function fixHeight() {
		var height = "BackCompat" === document.compatMode ?  document.body.clientHeight: document.documentElement.clientHeight;
		var dom = document.getElementById("topDiv");
		if(dom){
		    dom.style.height = (height-45) +"px";
		}
    }
</script>

</head>
<html:link renderURL='/relateMember.do?method=setRelate'  var="setURL"/>
<body class="padding5" scroll="no" onload="fixHeight()">
<form  target="iframeForm" action="${setURL}" method="post" name="relateform" onsubmit="return setData();document.getElementById('submit').disabled=true;">
	<div class="topDiv" id="topDiv">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td valign="top" height="100%" align="center">
					<div class="scrollList">
							<table align="center" cellpadding="0" border="0" cellspacing="0" height="80%" width="70%">
	                          <tr><td height="50" colspan="5">&nbsp;</td></tr>
	                          <tr>
							   <td width="22%" valign="middle"><b><fmt:message key="relate.type.leader"/></b></td>
							   <td align="right" width="22%" valign="middle">
							   <c:set value="${v3x:parseElements(leaderlist, 'relateMemberId', 'typeProperty')}" var="l"/>
										<input class="button-default_emphasize" type="button" name="chooseleader" value="<fmt:message key="relate.choose"/>" onclick="selectLeaders();">
										<v3x:selectPeople id="chooseleader" showMe="false" memberId="${sessionScope['com.seeyon.current_user'].id}"  panels="Department,Team,Outworker" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" selectType="Member" originalElements="${l}" minSize="0" jsFunction="getMember(elements,'leader-div')"/>
							   </td>
							   <td width="12%">&nbsp;</td>
							   <td width="22%" valign="middle"><b><fmt:message key="relate.type.junior"/></b></td>
							   <td align="right" width="22%" valign="middle">
							      <c:set value="${v3x:parseElements(juniorlist, 'relateMemberId', 'typeProperty')}" var="jlist"/>
										<input class="button-default_emphasize" type="button" name="choosejunior" value="<fmt:message key="relate.choose"/>" onclick="selectJuniors();">
										<v3x:selectPeople id="choosejunior" showMe="false" memberId="${sessionScope['com.seeyon.current_user'].id}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" panels="Department,Team,Outworker" selectType="Member" originalElements="${jlist}" minSize="0" jsFunction="getMember(elements,'junior-div')"/>
							   </td>
							   </tr>
							   <tr>
							   <td colspan="2" valign="top">
							   <c:choose>
							   		<c:when test="${v3x:getBrowserFlagByRequest('selectDivType', pageContext.request)}">
								   		 <select id="leader-div" name="leader" class="input-100per margin_t_5 margin_b_10" multiple size="6">
											 	<c:forEach items="${leaderlist}" var="ll">
											 			<option value="${ll.relateMemberId}" id="${ll.relateMemberId}"><c:out value="${ll.relateMemberName}"/><c:if test="${ll.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${ll.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if></option>
											 	</c:forEach>
										 </select>
							   		</c:when>
							   		<c:otherwise>
							   			<div name="leader" class="div-list" id="leader-div">
							   				<c:forEach items="${leaderlist}" var="ll">
							   					<div class="member-div" value="${ll.relateMemberId}" id="${ll.relateMemberId}">
							   						<c:out value="${ll.relateMemberName}"/><c:if test="${ll.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${ll.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if>
							   					</div>
							   				</c:forEach>
							   			</div>
							   		</c:otherwise>
							   </c:choose>
							   </td>
							   <td>&nbsp;</td>
							   <td colspan="2" valign="top">
							   <c:choose>
							   		<c:when test="${v3x:getBrowserFlagByRequest('selectDivType', pageContext.request)}">
								     	<select id="junior-div" name="junior" class="input-100per margin_t_5 margin_b_10" size="6" multiple>
											<c:forEach items="${juniorlist}" var="jl">
											 		<option value="${jl.relateMemberId}" id="${jl.relateMemberId}"><c:out value="${jl.relateMemberName}"/><c:if test="${jl.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${jl.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if></option>
											 </c:forEach>
										</select>
							   		</c:when>
							   		<c:otherwise>
							   			<div name="junior" class="div-list" id="junior-div">
							   				<c:forEach items="${juniorlist}" var="jl">
							   					<div class="member-div" value="${jl.relateMemberId}" id="${jl.relateMemberId}">
							   						<c:out value="${jl.relateMemberName}"/><c:if test="${jl.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${jl.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if>
							   					</div>
							   				</c:forEach>
							   			</div>
							   		</c:otherwise>
							   </c:choose>
							   </td>
							   </tr>
							   <tr>
							   <td valign="middle"><b><fmt:message key="relate.type.assistant"/></b></td>
							   <td align="right" valign="middle">
							     <c:set value="${v3x:parseElements(assistantlist, 'relateMemberId', 'typeProperty')}" var="asl"/>
										<input class="button-default_emphasize" type="button" name="chooseassisitant" value="<fmt:message key="relate.choose"/>" onclick="selectAssistants();">
										<v3x:selectPeople id="chooseassisitant" showMe="false" memberId="${sessionScope['com.seeyon.current_user'].id}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" panels="Department,Team,Outworker" selectType="Member" originalElements="${asl}" minSize="0" jsFunction="getMember(elements,'assistant-div')"/>
							   </td>
							   <td>&nbsp;</td>
							   <td valign="middle"><b><fmt:message key="relate.type.confrere"/></b></td>
							   <td align="right" valign="middle">
							     <c:set value="${v3x:parseElements(confrerelist, 'relateMemberId', 'typeProperty')}" var="clist"/>
										<input class="button-default_emphasize" type="button" name="chooseconfrere" value="<fmt:message key="relate.choose"/>" onclick="selectConfreres();">
										<v3x:selectPeople id="chooseconfrere" showMe="false" memberId="${sessionScope['com.seeyon.current_user'].id}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" panels="Department,Team,Outworker" selectType="Member" originalElements="${clist}" minSize="0" jsFunction="getMember(elements,'confrere-div')"/>
							   </td>
							   </tr>
							   <tr>
							   <td colspan="2" valign="top">

							   <c:choose>
							   		<c:when test="${v3x:getBrowserFlagByRequest('selectDivType', pageContext.request)}">
								     	<select id="assistant-div" name="assistant" class="input-100per margin_t_5 margin_b_10" multiple size="6">
											<c:forEach items="${assistantlist}" var="al">
										 		<option value="${al.relateMemberId}" id="${al.relateMemberId}"><c:out value="${al.relateMemberName}"/><c:if test="${al.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${al.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if></option>
											</c:forEach>
										</select>
							   		</c:when>
							   		<c:otherwise>
							   			<div name="assistant" class="div-list" id="assistant-div">
							   				<c:forEach items="${assistantlist}" var="al">
							   					<div class="member-div" value="${al.relateMemberId}" id="${al.relateMemberId}">
							   						<c:out value="${al.relateMemberName}"/><c:if test="${al.relateWsbs==2}"><fmt:message key="relate.unsure"/></c:if><c:if test="${al.relateWsbs==1}"><fmt:message key="relate.sure"/></c:if>
							   					</div>
							   				</c:forEach>
							   			</div>
							   		</c:otherwise>
							   </c:choose>


							   </td>
							   <td>&nbsp;</td>
							   <td colspan="2" valign="top">


							    <c:choose>
							   		<c:when test="${v3x:getBrowserFlagByRequest('selectDivType', pageContext.request)}">
								     	<select id="confrere-div" name="confrere" class="input-100per margin_t_5 margin_b_10" size="6" multiple>
											<c:forEach items="${confrerelist}" var="cl">
											 		<option value="${cl.relateMemberId}" id="${cl.relateMemberId}"><c:out value="${cl.relateMemberName}"/></option>
											 </c:forEach>
										</select>
							   		</c:when>
							   		<c:otherwise>
							   			<div name="confrere" class="div-list" id="confrere-div">
							   				<c:forEach items="${confrerelist}" var="cl">
							   					<div class="member-div" value="${cl.relateMemberId}" id="${cl.relateMemberId}">
							   						<c:out value="${cl.relateMemberName}"/>
							   					</div>
							   				</c:forEach>
							   			</div>
							   		</c:otherwise>
							   </c:choose>


							   </td>
							   </tr>

						</table>
					</div>
				</td>
			</tr>
			<div id="hiddenDataDiv" name="hiddenDataDiv"></div>
	</table>
	</div>
	<div class="bottomDiv">
		<input type="submit" id="submit" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>"
								class="button-default_emphasize">&nbsp;&nbsp;&nbsp;&nbsp;
					  <input type="button" onclick="getA8Top().back()" value="<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}"/>"
								class="button-default-2">
	</div>
</form>
<iframe name="iframeForm" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
initIpadScroll("leader-div",135,281);
initIpadScroll("junior-div",135,281);
initIpadScroll("assistant-div",135,281);
initIpadScroll("confrere-div",135,281);
</script>
</body>
</html>