<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<%@include file="logHeader.jsp"%>
<%@include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />" />
<script type="text/javascript">
	function doIt() {
		var startDay = document.getElementById("startDay").value;
		var endDay = document.getElementById("endDay").value;
		form1.isExprotExcel.value = "false";
		if (startDay != "" && endDay != "") {
			if (compareDate(startDay, endDay) > 0) {
				alert(v3x.getMessage("LogLang.log_search_overtime"))
				return false;
			}
		}
		form1.submit();
	}
	
	function delIt(){
		var startDay = document.getElementById("startDay").value;
		var endDay = document.getElementById("endDay").value;
		form1.isExprotExcel.value = "false";
		if (startDay != "" && endDay != "") {
			if (compareDate(startDay, endDay) > 0) {
				alert(v3x.getMessage("LogLang.log_search_overtime"))
				return false;
			}
		}

		location.href="<html:link renderURL='/restlog.do?method=deleteRestLogs&startDay="+startDay+"&endDay="+endDay+"' />";
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
</head>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
	<tr>
		<td height="20" style="border-right: solid 1px #A4A4A4;"></td>
	</tr>

	<tr>
		<td class="page-list-border-LRD" valign="top">
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
				<tr>
					<td width="100%" height="40" align="center" class="lest-shadow">
						<form method="post" id="form1"
							action="${restlog}?method=restLogList">
							<input type="hidden" name="isExprotExcel" id="isExprotExcel"
								value="">  <fmt:message
									key="logon.search.selectTime" />: <input type="text"
								name="startDay" id="startDay" class="cursor-hand"
								value="${startDay }"
								onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);"
								readonly="true"> <fmt:message key="logon.search.to" />
									<input type="text" class="cursor-hand" name="endDay"
									id="endDay" value="${endDay }"
									onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);"
									readonly="true"> <input type="button"
										value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>"
										class="button-default-2" onclick="doIt()"> <input
											type="button"
											value="<fmt:message key="common.button.delete.label" bundle="${v3xCommonI18N}"/>"
											class="button-default-2" onclick="delIt()">
						</form>
					</td>
				</tr>
				<tr height="24">
					<td class="webfx-menu-bar-gray border-top">&nbsp;&nbsp;&nbsp;<fmt:message
							key="label.mail.search" bundle="${v3xMailI18N}" /></td>
				</tr>
				<tr>
					<td height="100%" valign="top">
						<div class="scrollList" id="dataList">
							<form>
								<v3x:table data="${results}" var="result" htmlId="aaa"
									isChangeTRColor="true" showHeader="true" showPager="true"
									pageSize="20" subHeight="130">

											<v3x:column width="15%" type="String"
												label="${ctp:i18n('restlog.restname.info')}" maxLength="40"
												value="${result[0]}">
											</v3x:column>


									<v3x:column width="25%"
										label="${ctp:i18n('restlog.resttoken.info')}" maxLength="40"
										type="String" value="${result[1]}" />

									<v3x:column width="10%"
										label="${ctp:i18n('restlog.reststate.info')}" type="String"
										maxLength="40" value="${result[3]}" />

									<v3x:column width="20%" type="String"
										label="${ctp:i18n('restlog.restlogintime.info')}"
										maxLength="40" value="${result[2]}" />
									<v3x:column width="15%"
										label="${ctp:i18n('restlog.restip.info')}" maxLength="40"
										type="String" value="${result[4]}" />

									<v3x:column width="10%"
										label="${ctp:i18n('restlog.restlogintype.info')}"
										maxLength="40" type="String" value="${result[5]}" />
									<v3x:column width="35%"
										label="${ctp:i18n('restlog.resturl.info')}" maxLength="80"
										type="String" value="${result[6]}" />
								</v3x:table>
							</form>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
	<iframe id="targetFrame" name="targetFrame" width="0" height="0"></iframe>
</body>
</html>