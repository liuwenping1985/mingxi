<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<title>

</title>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<%@ include file="../include/header.jsp" %>
<script>
<!--
function printResult(){
			if('${bean.dataFormat}' != 'HTML'){
				window.officeEditorFrame.officePrint();
				return;
			}
		   var noPrintDiv;
		   try{
	           noPrintDiv=document.getElementById("noprint");
	           noPrintDiv.style.visibility="hidden";
           }catch(e){}
           var mergeButtons  = document.getElementsByName("mergeButton");
           for(var s= 0;s<mergeButtons.length;s++){
              var mergeButton = mergeButtons[s]; 
              mergeButton.style.display="none";
           }
           var p = document.getElementById("printThis");
           var aa= "";
		   var mm = p.innerHTML;
		   var list1 = new PrintFragment(aa,mm);
           var tlist = new ArrayList();
		   tlist.add(list1);
		   	var cssList=new ArrayList();
		   	 cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea5Show.css")
		     cssList.add(v3x.baseURL + "/apps_res/bulletin/css/default.css")   			   	
           printList(tlist,cssList);
           for(var s= 0;s<mergeButtons.length;s++){
               var mergeButton = mergeButtons[s];
               mergeButton.style.display="";
           }
            try{	        
	           noPrintDiv.style.visibility="visible";	           
           }catch(e){} 
		}
-->
</script>
</head>
<body scroll='no'  onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
		<tr height="8">
			<td  width="100%" height="8" >
				<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					<tr >
						<td colspan="6" width="100%" height="8">
							<script type="text/javascript">
								getDetailPageBreak();
							</script>
						</td>
					</tr>
				  </table>  
			</td>
		</tr>
		
		<tr>
			<td class="body-bgcolor-audit" width="100%" height="100%">
			<div class="scrollList">
			<div id="printThis"><!-- 打印开始 -->
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
				 <%-- 加入标准格式和正式格式的区分，板块管理员在进行操作的时候，两种格式同样应该显示出于用户点击查看时的格式区别 --%>
				 <c:if test="${ext1=='0'}">
				    <tr>
						 <td colspan="6" height="30">
								 <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
									 <tr>
									   <td align="center" width="90%" class="titleCss" style="padding: 20px 6px;">${bean.title}</td>
									  <td align="right"  width="10%" style="padding: 20px 20px 0px 0px;">	
				    <c:if test="${bean.ext2=='1'}"><!-- 发布时选中允许打印才显示---选中为“1” -->				 
						<input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key="oper.print" />" />								
				    </c:if>
				   </td>
									  </tr>
								 </table>
						 </td>
					</tr>
					<tr style='background-color:#f6f6f6'>
						<td class="font-12px" align="right" width="12%" height="28"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="24%">${bean.publishDeptName}</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="24%">${bean.type.typeName}</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="16%"><fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /></td>
					</tr>
		        </c:if>
		     		        
					<tr>
						<td width="100%" height="500" valign="top" colspan="6">
							<div>								
				            	<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" />		
							</div>
                            <style>
                        .contentText p{
                            font-size:14px;
                        }
                    </style>
						</td>
					</tr>
					<tr id="attachmentTr" style="display: none">
					  <td class="paddingLR" height="30" colspan="6">
					   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
						<tr>
							<td height="10" valign="top" colspan="6">
								<hr size="1" class="newsBorder">
							</td>
						</tr>
					    <tr style="padding-bottom: 20px;">
							<td nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
							<td width="100%" class="font-12px">
							  <v3x:attachmentDefine	attachments="${attachments}" />		   
								<script type="text/javascript">					
									showAttachment('${bean.id}', 0, 'attachmentTr', '');					
								</script>
							</td>
						 </tr>
						</table>
					  </td>
					</tr>
					
					
				<c:if test="${ext1=='1'}">
					<tr>
						<td colspan="6" class="paddingLR" height="30">
							  	<table BORDER=1 cellspacing="0" cellpadding="0" width="100%" height="100%">
										<TR>
											<TD class="font-12px" title="${bean.title }">&nbsp;&nbsp;
												<fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
												${v3x:getLimitLengthString(bean.title, 30, "...")}
											</TD>
											<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
											<TD class="font-12px" title="${publishScopeStr }">&nbsp;&nbsp;
												<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
				    							${v3x:getLimitLengthString(publishScopeStr, 30, "...")}
											</TD>
										</TR>
										<TR>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
												${v3x:showMemberName(bean.createUser)}
											</TD>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
												<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
											</TD>
										</TR>
										<TR>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
												${v3x:showMemberName(bean.auditUserId)}
											</TD>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
												<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
											</TD>
										</TR>
										<TR>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
												${bean.publishDeptName}
											</TD>
											<TD class="font-12px">&nbsp;&nbsp;
												<fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
												${bean.readCount}
											</TD>
										</TR>
								</table>
						 </td>
					</tr>
					<tr>
						<td align="center">
					&nbsp;
						</td>
					</tr>
				</c:if>
					
				</table>
			</div>
				<c:if test="${bean.type.auditFlag == true}">
				<c:if test="${bean.state!=0 && bean.state!=10}">					
				<table border="0" height="80" cellpadding="0" cellspacing="0" class="body-detail" align="center" style="padding: 6px;">
					<tr>
						<td height="20" class="passText" nowrap="nowrap">
							<fmt:message key="bul.data.auditAdvice" /><fmt:message key="label.colon" />
							<c:if test="${bean.state==20}">
											<input
								type="button" name="b1" id="b1" onclick="publishIt('${bean.id}')"
								value="<fmt:message key="common.toolbar.oper.publish.label" bundle="${v3xCommonI18N}" />"
								class="button-default-2">
							</c:if>
						</td>
					</tr>
					<tr>
						<td height="20" class="passText passbg" nowrap="nowrap">
							<c:if test="${bean.ext3 == '1'}">
								<fmt:message key="label.audit" /><fmt:message key="label.accept" />
							</c:if>
							<c:if test="${bean.ext3 == '2'}">
								<fmt:message key="label.accept2" />
							</c:if>
							<%-- 旧版本中的内容仍兼容为一律显示"直接发布",否则旧版内容将显示为空 --%>
							<c:if test="${bean.ext3!=1 && bean.ext3!=2}">
								<fmt:message key="label.accept2" />
							</c:if>
						</td>
					</tr>
					<c:if test="${fn:length(bean.auditAdvice)>0}">
						<tr>
							<td>
								${bean.auditAdvice}
							</td>
						</tr>
					</c:if>
				</table>
				</c:if>
				</c:if>	
				
				<c:if test="${bean.state==20}">
				<script>
						function publishIt(id){
							hiddenIframe.document.location.href = '${bulDataURL}?method=publishIt&id='+id;
							window.parent.location.reload();
						}
						/**
						if(!window.dialogArguments){
							document.getElementById("publishBtn").style.display = "none";
						}*/
				</script>	

				</c:if>	
				</div>	
				</td>
			</tr>
	</table>
<iframe name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
</body>
</html> 