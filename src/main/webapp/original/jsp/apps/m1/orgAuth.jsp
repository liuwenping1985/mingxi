<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="./orgAuth_js.jsp"%>
<html>
<head>
<title>orgAuth</title>
<script type="text/javascript">
	var showAccountShortname_pop = "no";
</script>
</head>
<body>
<input type="hidden" id="checkinfo" name="checkinfo" value="<fmt:message key='label.mm.orgauth.authrepeartcheckinfo' bundle='${mobileManageBundle}' />" />
<input type="hidden" id="authrepeat" name="authrepeat" value="<fmt:message key='label.mm.orgauth.authrepeat' bundle='${mobileManageBundle}' />" />
<div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" ></div>
        <div class="layout_north" layout="height:40,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
       	<div class="layout_center over_hidden" layout="border:true" id="center">
			<div class="stadic_layout form_area" id='form_area'>
				<form id="auth_form" method="post" action="<c:url value='/m1/mobileAuthController.do' />?method=orgAuth">
					<input type="hidden" id="m1Version" name="m1Version" value="<c:out value='${m1Version}'/>" />
					<input type="hidden" id="orgCount" name="orgCount" value="<c:out value='${orgCount}'/>" />
					<input type="hidden" id="authedCount" name="authedCount" value="<c:out value='${authedCount}'/>" />
					<input type="hidden" name="authStr" id="authStr" value="<c:out value='${authedStr}'/>" />
					<input type="hidden" name="authedIds" id="authedIds" value="<c:out value='${authedIds}'/>" />
					<input type="hidden" name="authedIdNames" id="authedIdNames" value="<c:out value='${authedIdNames}'/>" />
					<input type="hidden" id="groupCount" name="groupCount" value="<c:out value='${groupCount}'/>" />
					<input type="hidden" id="overdueDate" name="overdueDate" value="<c:out value='${overdueDate}'/>" /> 
					<input type="hidden" id="authedType" name="authedType" value="<c:out value='${authedType}'/>" />
					<input type="hidden" id="allauthed" name="allauthed" value="<c:out value='${allauthed}'/>" />
					<input type="hidden" id="m1PermissionType" name="m1PermissionType" value="<c:out value='${m1PermissionType}'/>" />
					<input type="hidden" id="available" name="available" value="<c:out value='${available}'/>" />
					<input type="hidden" id="serverusable" name="serverusable" value="<c:out value='${serverusable}'/>" />
					
					<table border="0" bordercolor="black" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
					<tr>
						<td>
						<div  id ="message_m1_label" >
						<fieldset ><legend><font><fmt:message key="label.mm.orgauth.legend" bundle="${mobileManageBundle}"/>
						</font></legend>
						 
							<table id="tablestyle" >
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.m1version" bundle="${mobileManageBundle}"/>:</td>
								<td class="new-column"><c:out value="${m1Version}" /></td>
							</tr>
							<tr class="trstyle">
								<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.overdueDate" bundle="${mobileManageBundle}"/>:</td>
								<td id="overdueDate_td" class="new-column" ><c:out value="${overdueDate}" /></td>
							</tr>
							<c:if test = "${ authedType > 1 && available  == true }">
								<tr class="trstyle">
									<!-- 本单位移动注册数 + 全集团移动注册数 -->
									<c:if test="${authedType == 22 }"> 
									   	<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.orgcount" bundle="${mobileManageBundle}"/>:</td>
										<td class="new-column" ><c:out value="${orgCount}" /></td>
									 </c:if>
									 <c:if test="${authedType == 23 }"> 
									 	<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.allgroupcount" bundle="${mobileManageBundle}"/>:</td>
										<td class="new-column" ><c:out value="${groupCount}" /></td>
									 </c:if>
								</tr>
								<tr class="trstyle">
									<!-- 全集团已使用移动注册数 + 本单元已使用移动注册数 -->
								    <c:if test="${authedType == 22 }"> 
								   		<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.groupauth.authedcount" bundle="${mobileManageBundle}"/>:</td>
										<td id="authedCount_td" class="new-column"><c:out value="${authedCount}" /></td>
								    </c:if>
								    <c:if test="${authedType == 23 }"> 
								 	 	<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.allgroupauthedcount" bundle="${mobileManageBundle}"/>:</td>
										<td id="authedCount_td" class="new-column"><c:out value="${allauthed}" /></td>
								    </c:if>
								
							    </tr>
							   <tr class="trstyle">
								   <!-- 本单位可用注册数 + 全集团可用注册数 -->
								   <c:if test="${authedType == 22 }"> 
								   		<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.authablenum" bundle="${mobileManageBundle}"/>:</td>
										<td id="authableNum_td" class="new-column"><c:out value="${orgCount - authedCount}"/></td>
								   </c:if>
								   <c:if test="${authedType == 23 }"> 
								 	 	<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.allgroupeffectivecount" bundle="${mobileManageBundle}"/>:</td>
										<td id="authableNum_td" class="new-column"><c:out value="${groupCount - allauthed}"/></td>
								   </c:if>
								
							  </tr>
							  <c:if test="${authedType == 23 }">
								<tr class="trstyle">
								 	<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.authedcount" bundle="${mobileManageBundle}"/>:</td>
									<td id="authableNum_td_1" class="new-column"><c:out value="${authedCount}"/></td>
								</tr>
							  </c:if>
							  <tr >
									<td class="bg-grayspe"  nowrap="nowrap" ><fmt:message key="label.mm.orgauth.authedusers" bundle="${mobileManageBundle}"/>:</td>
									<td class="new-column" >
										<textarea id="viewStr" rows="5" cols="60" readonly="readonly" style="color:gray;overflow-y:auto" disabled="disabled" ></textarea>
										<v3x:selectPeople id="pop" panels="Department,Post,Level,Outworker" selectType="Member" 
											departmentId="${v3x:currentUser().departmentId}" jsFunction="selected_users(elements)" minSize="0" maxSize = "${orgCount}"
											originalElements="${v3x:parseElementsOfIds(authedIds,'Member')}"/>
										
									</td>
							 </tr>
							 <tr><td></td>
							</tr>
							</c:if>
							<c:if test="${authedType == 1 || available == false }">
								<c:if test="${m1PermissionType == 1  }"> <!--  不分单位 -->
									<tr>
										<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.allgroupConurrentCount" bundle="${mobileManageBundle}"/>:</td>
										<td  class="new-column" ><c:out value="${groupCount}" /></td>
									</tr>
									<tr>
										<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.correntAccountauthedusers" bundle="${mobileManageBundle}"/>:</td>
										<td class="new-column"><fmt:message key ="label.mm.orgauth.scope" bundle="${mobileManageBundle}"/></td>
									</tr>
								 </c:if> 
								 <c:if test ="${m1PermissionType == 2 || available == false }"> <!-- 分单位 --> 
								 	<tr>
										<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.allorgConurrentCount" bundle="${mobileManageBundle}"/>:</td>
										<td class="new-column" ><c:out value="${orgCount}" /></td>
									</tr>
									<tr>
										<td class="bg-gray"  nowrap="nowrap"><fmt:message key="label.mm.orgauth.authedusers" bundle="${mobileManageBundle}"/>:</td>
										<td class="new-column">
											<c:if test = "${available == false && m1PermissionType > 2 }" >
												<fmt:message key = "label.mm.orgauth.noscope" bundle="${mobileManageBundle}"/>
											</c:if>
											<c:if test = "${available == true && m1PermissionType == 2 }" >
												<fmt:message key = "label.mm.orgauth.scope" bundle="${mobileManageBundle}"/>
											</c:if>
										</td>
									</tr>
								</c:if>
						</c:if>
						</table>
						</fieldset>
						</div>
						<div id="authe_div" >
						<c:if test="${success != null}"><font id="success"><fmt:message key="label.mm.orgauth.success" bundle="${mobileManageBundle}"/></font></c:if>
						<c:if test="${errMsg != null}"><font id="failed" >
							<fmt:message key="${errMsg.key}" bundle="${mobileManageBundle}" >
								<c:forEach items="${errMsg.vars}" var="avar"><fmt:param value="${avar}"></fmt:param></c:forEach>
							</fmt:message>
						</font></c:if>
						</div>
						<div class = "countle_div" id = "orgCount_countle_div" >
						<fmt:message key="err.mm.service.authusercountlarge" bundle="${mobileManageBundle}" >
							<fmt:param value="${orgCount}"></fmt:param>
						</fmt:message>
						</div>
						<div class = "countle_div" id = "groupCount_countle_div" >
						<fmt:message key="err.mm.service.authorgcountlarge" bundle="${mobileManageBundle}" >
							<fmt:param value="${groupCount}"></fmt:param>
						</fmt:message>
						</div>
						<c:if test = "${available == false}">
						<div class = "available_div" id = "orgCount_countle_div" >
							<fmt:message key="err.mm.service.notbuy" bundle="${mobileManageBundle}" >
							</fmt:message>
						</div>
						</c:if>
						<c:if test = "${available == true && serverusable == false}">
						<div class = "available_div" id = "orgCount_countle_div" >
							<fmt:message key="err.mm.service.m1serverexception" bundle="${mobileManageBundle}" >
							</fmt:message>
						</div>
						</c:if>
						
						</td>
						
					</tr>
					<tr>
						<td height="100%"></td>
					</tr>
					<tr id="edit_tr" >
					</tr>
					</table>
					</form>
					<c:if test="${ authedType > 1 && available == true  && serverusable == true }">
						 <div class="stadic_layout_footer stadic_footer_height">
		           			 <div id="button_area" align="center" class="page_color button_container">
								<a id="btnsubmit" href="javascript:void(0)"
									class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
									&nbsp; 
								<a id="btncancel" href="javascript:void(0)"
								class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
							</div>
		     		   </div>
					</c:if>
			</div>
		</div>
</div>
</body>
</html>