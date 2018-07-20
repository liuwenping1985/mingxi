<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<div class="scrollList body-bgcolor" id="preView">
	<div id="printThis">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
			<tr>
				<td class="body-bgcolor-audit" style="text-align:left;" width="100%" height="100%">
					<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
						<tr>
							<td width="100%" valign="top" colspan="6" style="padding: 47px 39px 0px 39px;" class="contentText">
								<div style="min-height:500px;">								
									<script type="text/javascript">
								        try{
								          if (typeof(content) != "undefined") {
								               document.write(content);
								          }
								        }catch(e){}
									</script>
								</div>
							</td>
						</tr>
						
						<tr id="attachTr"><td colspan="6" width="100%" valign="bottom">
							<script type="text/javascript">
							if (typeof(att) != "undefined") {
							      document.write(att);
							}
							</script>
						</td></tr> 
						
						<tr id="attachFileTr"><td colspan="6" width="100%" valign="bottom">
							<script type="text/javascript">
							if (typeof(attFile) != "undefined") {
							  	document.write(attFile);
							}
							</script>
						</td></tr>
					</table>
				</td>
			</tr>
		</table>

		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="body-bgcolor" align="center" style="padding: 0px;">
			<tr>
				<td width="100%" class="body-bgcolor-audit" style="text-align:left;" valign="top">
					<table width="100%" height="100" align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail" >	
						<tr><td height="10">&nbsp;</td></tr>
						
						<tr>
							<td colspan="6" class="paddingLR" height="30">
							  	<table class="appendInfo" cellspacing="0" border="0" cellpadding="0" width="100%" height="100%">
									<tr class="sort">
										<td class="font-12px sort rightBorder" width="50%">&nbsp;
											<fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
											<script type="text/javascript">
											 if (typeof(title) != "undefined") {
												document.write(title);
											 }
											</script>
										</td>
										<td class="font-12px sort" width="50%">&nbsp;
											<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
			    							<script type="text/javascript">
					    				      if (typeof(publishScope) != "undefined") {
													document.write(publishScope.getLimitLength(30, '...'));
					    				      }
											</script>
										</td>
									</tr>
									
									 <script type="text/javascript">
                                         var html = "";
                                         if (showPublishUserFlag) {
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;<fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += author;
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '</tr>';
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '</tr>';
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += deptName;
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;0';
                                             html += '</td>';
                                             html += '<tr>';
                                         } else {
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;<fmt:message key="bul.data.createDate"/><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.auditUser" /><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '</tr>';
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.auditDate"/><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;';
                                             html += deptName;
                                             html += '</td>';
                                             html += '</tr>';
                                             html += '<tr class="sort">';
                                             html += '<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;';
                                             html += '<fmt:message key="label.readCount" /><fmt:message key="label.colon" />&nbsp;&nbsp;0';
                                             html += '</td>';
                                             html += '<td class="font-12px sort" width="50%">&nbsp;&nbsp;';
                                             html += '</td>';
                                             html += '<tr>';
                                         }
                                         document.write(html);
                                     </script>
								</table>
							 </td>
						</tr>
						
						<tr>
							<td align="center" height="5">&nbsp;</td>
						</tr>
						
						<tr align="center">
							<td colspan="6"  align="center">
							<div id="noprint" style="visibility:visible">
							<script type="text/javascript">
					   			if(printButtons) {
									document.write('<input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key="oper.print" />" />');
								}
							</script>	
							</div>
							</td>
						</tr>
						
						<tr>
							<td align="center">
								&nbsp;
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>	
</div>