<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录验证USB-Key制作 - 编辑</title>
<script type="text/javascript">
getDetailPageBreak();
function refreshList(isContinueMakeFlag){
	parent.showDetailInfo = !isContinueMakeFlag;
	if(isContinueMakeFlag == true){
		document.forms["editUSBKeyForm"].reset();
		document.all.USBKeyName.focus();
		document.all.submitBtn.disabled = false;
	}
	else{
		alert(_("sysMgrLang.system_post_ok"));
	}
	parent.listFrame.location.reload(true);
}
showOriginalElement_selMember = false;
</script>
</head>
<body>
<v3x:selectPeople id="selMember" maxSize="1" panels="Department,Outworker,Admin" selectType="Member,Admin" jsFunction="showSelMember(elements)" />
<form name="editUSBKeyForm" action="${identificationURL}" method="post" target="eidtUSBKeyIFrame" onsubmit="return editUSBKeyOK(editUSBKeyForm, ${USBKey == null})">
<input type="hidden" name="method" value="updateUSBKey">
<input type="hidden" name="isNew" value="${USBKey==null}">
<input type="hidden" name="dogId" value="${USBKey.dogId}">
<table border="0" width="100%" height="98%" align="center" cellpadding="0" cellspacing="0" class="categorySet-bg">	
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="menu.USBKey.${USBKey==null? 'make':'edit'}" /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
	    </td>
	</tr>
	<tr>
	   <td class="categorySet-head">
	    <div class="categorySet-body" id="bodyDiv" style="padding-left: 0px;padding-right: 0px;margin-top: -4px;">
			<table align="center" width="60%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="30%" align="right" height="28">
						<font color="red">*</font><fmt:message key="USBKey.attribute.name" />:
					</td>
					<td class="padding-L">
						<input type="text" name="USBKeyName" class="input-300px" value="${v3x:toHTML(USBKey.name)}" inputName="<fmt:message key='USBKey.attribute.name' />" validate="notNull,maxLength" maxSize="30" ${param.disabled=='true'? 'disabled':''} >
					</td>
				</tr>
				<tr>
					<td width="30%" height="28" align="right">
						<font color="red">*</font><fmt:message key='common.state.label' bundle='${v3xCommonI18N}' />:
					</td>
					<td class="padding-L">
						<label for="stateRadio1">
							<input id="stateRadio1" type="radio" name="isEnabled" value="true" ${USBKey==null||USBKey.enabled==true? 'checked':''} ${param.disabled=='true'? 'disabled':''} />
							<fmt:message key='common.state.normal.label' bundle='${v3xCommonI18N}' />
						</label>
						<label for="stateRadio2">
							<input id="stateRadio2" type="radio" name="isEnabled" value="false" ${USBKey.enabled==false? 'checked':''}  ${param.disabled=='true'? 'disabled':''}/>
							<fmt:message key='common.state.invalidation.label' bundle='${v3xCommonI18N}' />
						</label>
					</td>
				</tr>
				<tr>
					<td width="30%" align="right" valign="top" height="28">
						<font color="red">*</font><fmt:message key="USBKey.attribute.type" />:
					</td>
					<td class="padding-L" valign="top">
						<label for="isGenericRadio1">
							<input id="isGenericRadio1" type="radio" name="isGeneric" onclick="displaySetOwnerTR(false)" value="true" ${USBKey.genericDog==true? 'checked':''} ${param.disabled=='true'? 'disabled':''} />
							<fmt:message key='USBKey.attribute.generic' />
						</label>
						<label for="isGenericRadio2">
							<input id="isGenericRadio2" type="radio" name="isGeneric" value="false" onclick="displaySetOwnerTR(true)" ${USBKey==null||USBKey.genericDog==false? 'checked':''}  ${param.disabled=='true'? 'disabled':''}/>
							<fmt:message key='USBKey.attribute.setOwner' />
						</label>
					</td>
				</tr>
				<tr id="setOwnerTR" style="display:${USBKey.genericDog==true? 'none':''};">
					<td colspan="2" width="100%">
					<table border="0" width="100%" height="84">
						<tr>
							<td width="30%" align="right" height="28">
								<font color="red">*</font><fmt:message key="USBKey.attribute.owner" />:
							</td>
							<td class="padding-L">
								<c:choose>
								<c:when test="${USBKey.memberId == 1}">
									<c:set var="memberName"><fmt:message key="org.account_form.systemAdminName.value" bundle="${v3xOrganizationI18N }" /></c:set>
								</c:when>
								<c:when test="${USBKey.memberId == 0}">
									<c:set var="memberName"><fmt:message key="org.auditAdminName.value" bundle="${v3xOrganizationI18N }" /></c:set>
								</c:when>
								<c:otherwise>
									<c:set var="memberName">${v3x:toHTML(v3x:showOrgEntitiesOfIds(USBKey.memberId, 'Member', pageContext))}</c:set>
								</c:otherwise>
								</c:choose>
								<input type="text" name="memberName" class="cursor-hand input-300px" readonly="readonly" onclick="selectPeopleFun_selMember()" value="${memberName}" ${param.disabled=='true'? 'disabled':''} >
								<input type="hidden" name="memberId" value="${USBKey.memberId}">
							</td>
						</tr>
						<tr>
							<td align="right" valign="top" height="28">
								&nbsp;
							</td>
							<td class="padding-L" valign="top">
								<label for="isMustUseDog1"  onclick="checkCanAccessMobile(this)" >
									<input id="isMustUseDog1" type="checkbox"  name="isMustUseDog" ${USBKey==null||USBKey.mustUseDog==true? 'checked':''} ${param.disabled=='true'? 'disabled':''} />
									<fmt:message key="USBKey.attribute.isMustUseDog" />
								</label>
							</td>
						</tr>
						<c:if test="${v3x:hasPlugin('m1') }">
						<tr id="canAccessMobileLabel" style="display:${USBKey==null||USBKey.mustUseDog==true?'':'none' }">
							<td align="right" valign="top" height="28">
								&nbsp;
							</td>
							<td class="padding-L" valign="top">
								<label for="canAccessMobile" id="canAccessMobileLabel">
									<input id="canAccessMobile" type="checkbox" name="canAccessMobile" value="true" ${USBKey==null||USBKey.canAccessMobile==true? 'checked':''} ${param.disabled=='true'? 'disabled':''} />
									<fmt:message key="USBKey.attribute.canAccessMobile" />
								</label>
							</td>
						</tr>
						</c:if>
						<tr>
							<td align="right" valign="top" height="28">
								&nbsp;
							</td>
							<td class="padding-L" valign="top">
								<label for="isNeedCheckUsername1">
									<input id="isNeedCheckUsername1" type="checkbox" name="isNeedCheckUsername" ${USBKey==null||USBKey.needCheckUsername==true? 'checked':''} ${param.disabled=='true'? 'disabled':''} />
									<fmt:message key="USBKey.attribute.isNeedCheckUsername" />
								</label>
							</td>
						</tr>
						<c:if test="${USBKey==null}">
						<tr>
							<td>
								&nbsp;
							</td>
							<td class="description-lable">
									<br>
									<fmt:message key="USBKey.make.description"/>
							</td>
						</tr>
						</c:if>
					</table>
				</tr>
			</table>
	    </div>
	    </td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom" style="padding-right: 160px;">
			<table width="100%" border="0">
			  <tr>
				<td width="20%" align="center">
					<c:if test="${USBKey==null}">
						<label for="isContinueMake">
							<input type="checkbox" id="isContinueMake" name="isContinueMake" checked="checked"><fmt:message key="USBKey.make.isContinueMake" />
						</label>
					</c:if>&nbsp;
				</td>
				<td width="70%" align="center">
					<input type="submit" ${param.disabled=='true'? 'disabled':''} name="submitBtn" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2"/>&nbsp;&nbsp;
      				<input type="button" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="parent.location.reload(true);"/>
				</td>
				<td width="10%">&nbsp;</td>
			  </tr>
			</table>
	   </td>
	</tr>
</table>
</form>
<iframe name="eidtUSBKeyIFrame" width="0" height="0" frameborder="0"></iframe>
<script>
  bindOnresize('bodyDiv',20,100);
</script>
</body>
</html>