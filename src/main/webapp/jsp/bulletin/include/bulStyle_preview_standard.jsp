<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%">
			<div class="scrollList" style="text-align:left;" id="preView">
				<div id="printThis">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
					    <tr>
							 <td colspan="6" height="30">
							 	<table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
									 <tr>
										   <td align="center" width="90%" class="titleCss" style="padding: 20px 6px;">
										   		<script type="text/javascript">
										   	 if (typeof(title) != "undefined") {
													document.write(title);
										   	 }
												</script>
										   </td>

										   <td align="right"  width="10%" style="padding: 20px 20px 0px 0px;">		
										   		<script type="text/javascript">
										   			if(printButtons) {
														document.write('<input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key="oper.print" />" />');
													}
												</script>								
										   </td>
									  </tr>
								</table>
							 </td>
						</tr>
						<tr>
						<td height="40" class="padding35">
						<table width="100%" border="0"  cellspacing="0" cellpadding="0">
						<tr class="padding_t_5" style='background-color:#f6f6f6'>
							<td class="font-12px" align="right" width="12%" ><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
							<td class="font-12px" width="24%">
								<script type="text/javascript">
								 if (typeof(deptName) != "undefined") {
										document.write(deptName);
								 }
								</script>
							</td>
              
                           <td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
                           <td class="font-12px" width="24%">
                            <script type="text/javascript">
                             if (typeof(bullType) != "undefined") {
                                document.write(bullType);
                             }
                            </script>
                           </td>
						   <td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
                           <td class="font-12px" width="24%">
                               <script type="text/javascript">
                                    document.write(_createDate==null?"":_createDate);
                           		</script>
                           </td>
						</tr>
						<tr class="padding_tb_5" style="background-color:#f6f6f6">
                             <td class="font-12px" align="right" width="10%"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
                             <td class="font-12px" width="24%">
                              <script type="text/javascript">
                              	document.write(publishScope.getLimitLength(30, '...'));
                              </script>	
                             </td>
                             <script type="text/javascript">
                                 var html = "";
                                 if (showPublishUserFlag) {
                                     html = '<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>'
                                     html += '<td class="font-12px" width="24%" >';
                                     html += author;
                                     html += '</td>';
                                 } else {
                                     html += '<td class="font-12px" align="right" width="10%"></td>';
                                     html += '<td class="font-12px" width="24%">';
                                     html += '</td>';                            	 
                                 }
                                 document.write(html);
                              </script>
                              
                              <td class="font-12px" align="right" width="10%"><fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
                              <td class="font-12px" width="16%">        
                                <script type="text/javascript">
                                    document.write('0');
                                </script>     
                              </td>
                            </tr>
						</table>
						</td>
						</tr>
						<tr>
							<td width="100%" valign="top" colspan="6" style="padding: 47px 39px 0px 39px;line-height:1.5;" class="contentText">
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
							 if (typeof(content) != "undefined") {
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
				</div>	
			</div>
		</td>
	</tr>
</table>