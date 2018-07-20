<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%
//response.setDateHeader("Expires",-1);
//response.setHeader("Cache-Control","no-store");
//response.setHeader("Pragrma","no-cache");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>账号绑定</title>
<%@include file="header_userMapper.jsp"%>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
	</head>
	<script type="text/javascript">
	//导航菜单
	//根据html加载
	
	//根据资源文件夹在showCtpLocation("F21_topersonmapper");
	
	function init(){
		//隐藏框架上的确定和取消按钮
		var personalSet = window.parent.document.getElementById("personalSet");
		if(personalSet != null){
			var personalSetChildNodes = personalSet.childNodes;
			for(var i=0;i<personalSetChildNodes.length;i++){
				if(personalSetChildNodes[i].className=='stadic_layout_footer stadic_footer_height align_center'){
					personalSet.removeChild(personalSetChildNodes[i]);
				}
			}
		}
		getA8Top().initSpaceNavigationNoDisplay();
	}
	
	
	function enabledClick()
	{
	  var ids=document.getElementsByName("exLoginName");
	  var y=0;
	    for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
			  document.getElementById("submit1").disabled = false;
			  y++;
			  break;
			}
		}
	if(y==0)
	{
	 document.getElementById("submit1").disabled = true;
	}
	}
	function reload(){
		//getA8Top().refreshNavigation("");
		getA8Top().refreshHomePageForNC();
	}
	function submitForm()
	{
		var form1=document.getElementById("postForm1");
		
		if(checkForm(form1))
		{
		   if(form1.ncUserLoginName.value=="")
	           {
	           return;
	           }
		   document.getElementById("buttonSub").disabled=true;
		   var userLoginN=document.getElementById("ncUserLoginName").value.trim();
		   document.getElementById("ncUserLoginName").value=userLoginN;
		   form1.action = "${ncUserMapper}?method=userBindingMapper";
		   form1.submit();
		}
	}
	function doEnter(){
	    if(event.keyCode == 13){
	    	submitForm();
	    }
	}
	</script>
	<body onload="init()" scroll="no" style="overflow: auto">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			    <tr class="page2-header-line">
					<td width="100%" height="41" valign="top" class="page-list-border-LRD">
						 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
					     	<tr class="page2-header-line">
									<td id="notepagerTitle1" class="page2-header-bg">&nbsp;<fmt:message key='nc.user.mapper' /></td>
									<td class="page2-header-line padding-right" align="right" id="back">
									<!-- 
									<a class="link-blue" onclick="getA8Top().refreshNavigation();"> <fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}"/> </a> 
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
									-->
									</td>
						        </tr>
						 </table>
					</td>
				</tr>
				<tr>
					<td  class="padding5" width="100%" align="center" valign="top">
						<br>
						<div style="width: 40%;">
							<br />
							<table width="40%" border="0" cellspacing="0" cellpadding="0"
								align="center">
								<c:if test="${userMapperList!=null}">
									<tr>
										<td class="bg-gray" width="20%" nowrap="nowrap">
											<fieldset>
												<legend>
													<fmt:message key='nc.current.mapper' /><fmt:message key='nc.user.account' />
												</legend>
												<table width="70%" border="0" cellspacing="0"
													cellpadding="0" align="center">
													<form id="postForm" method="post" action="${ncUserMapper}?method=deleteBindingMapper" onsubmit="return confirm('<fmt:message key='nc.user.confirm.delete'/>')" target="addConfigFrame">
													<tr>
														<td width="20%" nowrap="nowrap" align="center">
															<c:forEach var="mapper" items="${userMapperList}"
																varStatus="status">
																<input type="checkbox" name="exLoginName"
																	value="<c:out value='${mapper.exLoginName}'/>" onclick="enabledClick()" />${mapper.exLoginName}
																   <c:if test="${status.count%4==0&&status.count!=0}">
																	<br>
																</c:if>
															</c:forEach>

														</td>
														</tr>
													<tr>
														<td width="20%" nowrap="nowrap" align="center">
															<input disabled type="submit"
																value="<fmt:message key='addressbook.toolbar.remove.select.label' bundle="${v3xCommonI18N}" />"
																class="button-default-2 button-left-margin-10"  id="submit1">
														</td>
													</tr>
													</form>
												</table>
										</td>
									</tr>
								</c:if>
								<tr>
									<td>
										<br>
										<br>
										<br>
									</td>
								</tr>
								<tr>
									<td class="new-column" width="80%">
										<fieldset>
											<legend>
												<fmt:message key='addressbook.toolbar.new.select.label'
													bundle="${v3xCommonI18N}" /><fmt:message key='nc.currentuser.mapper' />
											</legend>
											<table width="70%" border="0" cellspacing="0" cellpadding="0"
												align="center">
												<form id="postForm1" method="post" action="" onkeypress="doEnter()" target="addConfigFrame">
												<tr>
													<td class="bg-gray" width="20%" nowrap="nowrap">
														<fmt:message key='nc.user.account' />
														:
														<input style="height:20px;border:1px solid #8f9385"  onclick="this.value=''"  value=" " type="text" name="ncUserLoginName" id="ncUserLoginName" validate="notNull" inputName="<fmt:message key='nc.user.account' />"/>
														<fmt:message key='nc.org.user.password'/>:
														<input  value="" type="password" name="userPassword" validate="notNull" inputName="<fmt:message key='nc.org.user.password'/>"/>
													</td>
													<td class="bg-gray" width="20%" nowrap="nowrap">
														<input type="button"
															value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"
															class="button-default-2 button-left-margin-10" onclick="submitForm()" id="buttonSub"/>
													</td>
												</tr>
												</form>
											</table>
										</fieldset>
									</td>
								</tr>
								<tr>
									<td>
										<br>
										<br>
										<br>
									</td>
								</tr>
							</table>
							<br />
						</div>

					</td>
				</tr>
			</table>
			<iframe id="addConfigFrame" name="addConfigFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	</body>
</html>