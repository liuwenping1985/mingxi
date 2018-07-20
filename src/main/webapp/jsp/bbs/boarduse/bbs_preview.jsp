<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%">
			<div class="scrollList">
				<div id="printThis">
					<table width="100%" border="0" cellpadding="0" cellspacing="0"
						class="body-detail">
						<tr>
							<td colspan="6" height="30">
								<table border="0" cellpadding="0" cellspacing="0" width="100%"
									style="border-bottom: 1px solid #A4A4A4;">
									<tr>
										<td align="center" width="90%" class="titleCss"
											style="padding: 20px 6px;"><script
												type="text/javascript">
												document.write(title);
											</script></td>
									</tr>
								</table>
							</td>
						</tr>

						<tr style='background-color: #f6f6f6'>

							<td class="font-12px" align="right" width="12%"><fmt:message
									key="bbs.data.type" /> <fmt:message key="label.colon" />&nbsp;&nbsp;</td>
							<td class="font-12px" width="24%"><script
									type="text/javascript">
								document.write(boardName);
							</script>
							</td>

							<td class="font-12px" align="right" width="12%" height="28"><fmt:message
									key="bbs.data.publishDepartmentId" /> <fmt:message
									key="label.colon" />&nbsp;&nbsp;</td>
							<td class="font-12px" width="24%"><script
									type="text/javascript">
								document.write(deptName);
							</script>
							</td>

							<td class="font-12px" align="right" width="10%"><fmt:message
									key="label.readCount" /> <fmt:message key="label.colon" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td class="font-12px" width="16%"><script
									type="text/javascript">
								document.write('0');
							</script></td>

						</tr>

						<tr style='background-color: #f6f6f6'>
							<td class="font-12px" align="right" width="12%"><fmt:message
									key="bbs.data.createUser" /> <fmt:message key="label.colon" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td class="font-12px" width="24%"><c:set var="curUser" value="${v3x:currentUser()}" /> ${curUser.name}</td>


							<td class="font-12px" align="right" width="12%"><fmt:message
									key="bbs.data.publishDate" /> <fmt:message key="label.colon" />&nbsp;&nbsp;</td>
							<td class="font-12px" width="16%"><script
									type="text/javascript">
								
							</script>
							</td>


							<td class="font-12px" align="right" width="10%"><fmt:message
									key='common.issueScope.label' bundle="${v3xCommonI18N}" /> <fmt:message
									key="label.colon" />&nbsp;&nbsp;</td>
							<td class="font-12px" width="24%"><script
									type="text/javascript">
								document.write(issueAreaName);
							</script></td>
						</tr>


						<tr>
							<td width="100%" height="500" valign="top" colspan="6"
								style="padding: 47px 34px 0px 34px;">
								<div>
									<script type="text/javascript">
										try {
											document.write(content);
										} catch (e) {
										}
									</script>
								</div>
							</td>
						</tr>

						<tr id="attachTr">
							<script type="text/javascript">
								document.write(att);
							</script>
						</tr>


					</table>
				</div>
			</div>
		</td>
	</tr>
</table>