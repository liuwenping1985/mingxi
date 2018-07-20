<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<title>
		<fmt:message key="oper.config" /><fmt:message key="label.write" />
	</title>
	<%@ include file="../include/header.jsp" %>
	
<script type="text/javascript">
<!--
if('${spaceType}' != '0')
onlyLoginAccount_bulType = true;
    isNeedCheckLevelScope_bulType = false;

	function setPeopleFields(elements){
		alert(elements);
	}
//-->
</script>

<base target="_self">
</head>
<body scroll="no" onkeydown="listenerKeyESC()">

<form action="${bulDataURL}" method="post" onsubmit="return checkForm(this)">
<input type="hidden" name="method" value="configWrite" />
<input type="hidden" name="act" value="save" />
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='oper.auth'/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<c:set var="row" value="0" />
			<v3x:table htmlId="listTable" data="list" var="item" showPager="false">
				<c:set var="row" value="${row+1}" />
				<v3x:column width="30%" type="String" label="bul.type.typeName">
					${item.typeName}
				</v3x:column>
				<v3x:column width="70%" type="String" label="label.write" className="cursor-hand sort">
					<input type="hidden" name="writeUserIds_${item.id}" value="${item.writeUserIds}"/>
					<c:set value="${managerId}" var="ids" />
					<input type="text" style="width:100%;margin-right:-39px;" name="writeUsersNames_${item.id}" inputName="<fmt:message key='label.write' />" validate="notNull" readonly="true" value="${v3x:showOrgEntitiesOfIds(ids, "Member", pageContext)}"/>
					<input type="button" value="<fmt:message key='oper.select.people' />" onclick="selectPeopleFun_bulType()" />
					<v3x:selectPeople id="bulType" panels="Department" selectType="Member" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setBulPeopleFields(elements,'writeUserIds_${item.id}','writeUsersNames_${item.id}')" originalElements="${v3x:parseElementsOfIds(ids, 'Member')}"/>
				</v3x:column>
			</v3x:table>
			
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html> 