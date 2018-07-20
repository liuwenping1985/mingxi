<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<table width="100%" height="100%" style="background:#fff" border="0" cellspacing="0" cellpadding="0" >		
	<tr height="100%">
		<td width="100%" height="100%" style="background:#fff" class="body-bgcolor" valign="top" align="center">
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
				<tr><td>

						<div class="rkz_top" style="margin-bottom:0px">
								<div class="rkz_header">
										<div class="rkz_banner_left">
											<div class="rkz_logo">
												<img class="rkz_logo" src="/rikaze/page/images/logo4.png">
											</div>
											<div class="rkz_banner">日喀则市纪委监委内部工作网</div>
								
								
										</div>
									</div>
							</div>

				</td></tr>
				<tr height="100%">
					<td height="100%">
							
						<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${bean.dataFormat=='HTML'?'body-detail':'body-detail-office'} margin-auto" align="center">
							<tr>
								<td colspan="6" height="60">
										
									<table width="100%" border="0" cellpadding="0" cellspacing="0" >
										<tr class="page2-header-line-old">
											<td colspan="6" width="100%" height="60">
												<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="CollTable">
													<tr class="page2-header-line-old" height="60">
														<td width="80" height="60"><span class="bul_img"></span></td>
														<td class="page2-header-bg-old align_left" width="380">通知公告</td>
														<td class="page2-header-line-old padding-right" align="right">&nbsp;</td>
														<td align="right" class="padding5">
												
                                       					<c:if test="${param.fromPigeonhole!=true && docCollectFlag eq 'true'}">
                                                             <span id="cancelFavorite${bean.id}" class="font-size-12 cursor-hand ${!isCollect?'hidden':''}" onclick="javaScript:cancelFavorite_old('7','${bean.id}','${bean.attachmentsFlag }','3','',false,20)">
                                                                <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/uncollect.gif" />">
                                                                <fmt:message key='bulletin.cancel.favorite' />
                                                            </span>
                                                            <span id="favoriteSpan${bean.id}" class="font-size-12 cursor-hand ${isCollect?'hidden':''}" onclick="javaScript:favorite_old('7','${bean.id}','${bean.attachmentsFlag }','3')">
                                                                <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/collect.gif"/>">
                                                                <fmt:message key='bulletin.favorite' />
                                                            </span>
                                                            <span class="margin_r_10">&nbsp;</span>
														</c:if>
                                                            <c:choose>
														    <c:when test="${bean.ext2=='1' && param.openFrom ne 'glwd'}">
																<span name="mergeButton" class="font-size-12 margin_r_10 cursor-hand" href="javascript:void(0);" name="mergeButton" onclick="printResult('${bean.dataFormat}', '${empty bean.ext5}')" >
								                                     <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/common/images/toolbar/print.gif"/>">
								                                     <fmt:message key="oper.print" />
								                                 </span>
								                                 <script>officecanPrint = "true"; officecanSaveLocal = "true";</script>							
														    </c:when>
                                                            <c:otherwise>
                                                            <script>officecanPrint = "false"; officecanSaveLocal = "false";</script>  
                                                            </c:otherwise>
                                                            </c:choose> 
                                                            <c:if test="${isManager}">
                                                                <input type="button" name="mergeButton" onclick="showReadList1('${param.id}','<fmt:message key="bul.userView.CallInfo"/>' ,'${param.fromPigeonhole}')" class="button-default-2 button-default-2-long" value="<fmt:message key="bul.userView.CallInfo" />" />
                                                            </c:if>
														</td>
													</tr>	
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td colspan="6" valign="top">
									<div id="printThis">
										<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
										    <tr>
												 <td colspan="6" height="30">
												 <table border="0" cellpadding="0" cellspacing="0" width="100%">
													 <tr>
													 	<td width="35">&nbsp;</td>
														<td align="center" width="90%" class="view-bulletin-title">${v3x:toHTML(bean.title)}</td>
													  	<td width="35">&nbsp;</td>
													  </tr>
												 </table>
												 </td>
											</tr>
							
											<tr>
												<td colspan="6" class="padding35" id="paddId">
													<c:choose>
														<c:when test="${false==true}">
															<center>
																<div style="width:80%;height:100%;margin:0 auto">
																	<div style="width:33%;position:relative;display: inline-block;">
																			<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
																			${v3x:toHTML(bean.publishDeptName)}
																		</div>
																	<div style="width:33%;position:relative;display: inline-block;">
																		
																		</div>
																</div>
															<table cellpadding="0" cellspacing="0" width="100%" height="100%">
																<tr>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px align_left" width="25%">${v3x:toHTML(bean.type.typeName)}</td>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px align_left" width="25%">${v3x:toHTML(bean.publishDeptName)}</td>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
													                <td class="font-12px align_left" width="25%">${bean.readCount}</td>
																</tr>
																
																<tr class="padding_t_5">
																    <td class="font-12px" nowrap="nowrap" align=""><fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																    <td class="font-12px align_left">
																    	${bean.publishMemberName}
																    </td>
																    
																    <td class="font-12px" nowrap="nowrap" align=""><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px align_left"><fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /></td>
																	
																	<td class="font-12px" nowrap="nowrap" align=""><fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																    <td nowrap="nowrap" class="align_left">
																    	<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
																    	<div title="${v3x:toHTML(publishScopeStr)}" class="font-12px">${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 24, "..."))}</div>
																    </td>
																</tr>
																
																<c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
																	<tr>
																		<td class="font-12px" nowrap="nowrap" align="" height="16">
																			<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
																		</td>
																	    <td class="font-12px" nowrap="nowrap">
																	    	${v3x:showMemberName(bean.auditUserId)}
																	    </td>
																	    
																	    <td class="font-12px" nowrap="nowrap" align="">
																	    	<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
																	    </td>
																	    <td class="font-12px" nowrap="nowrap">
																	    	<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
																	    </td>
																	    <td class="font-12px" nowrap="nowrap" align="">&nbsp;</td>
																	    <td class="font-12px" nowrap="nowrap">&nbsp;</td>
																	</tr>
																</c:if>
																
																<tr><td>&nbsp;</td></tr>
															</table>
															</center>
														</c:when>
														<c:otherwise>
															<center>
																<table style="width:100%;height:100%;">
																	<tr>
																		<td algin="center">
																	<div style="padding-left:250px;width:60%;height:100%;margin:0 auto">
																			<div align="left" style="margin:0 auto;width:30%;position:relative;display:inline-block;font-size:12px">
																					<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
																					${v3x:toHTML(bean.publishDeptName)}
																				</div>
																				<div align="left" style="margin:0 auto;width:30%;position:relative;display:inline-block;font-size:12px">
																						发布人<fmt:message key="label.colon" />&nbsp;&nbsp;
																						${v3x:showMemberName(bean.publishUserId)}
																					</div>
																				<div align="left" style="margin:0 auto;width:30%;position:relative;display: inline-block;font-size:12px">
																						<fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;	
																						${bean.readCount}
																					</div>
																					<div align="left" style="margin:0 auto;width:30%;position:relative;display: inline-block;font-size:12px">
																							<fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;	
																							<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" />
																						</div>
																						<div align="left" style="margin:0 auto;width:30%;position:relative;display:inline-block;font-size:12px">
																								<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;	
																								<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
																								<span title="${v3x:toHTML(publishScopeStr)}" class="font-12px">${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 24, "..."))}</span>
																							</div>
																							<c:choose>
																									<c:when test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
							
																										<div align="left" style="margin:0 auto;width:30%;position:relative;display: inline-block;font-size:12px">
																												<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
																												${v3x:showMemberName(bean.auditUserId)}
																											</div>
																									</c:when>
																									<c:otherwise>
																											<c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
																							
																													<div align="left" style="margin:0 auto;width:30%;position:relative;display: inline-block;font-size:12px">
																															<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
																															<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
																														</div>
																											</c:if>
																											
																												
																											
																									</c:otherwise>
																								</c:choose>
																								<div align="left" style="margin:0 auto;width:30%;position:relative;display:inline-block;font-size:12px">
																										&nbsp;&nbsp;	
																									</div>
																		</div>
																		<!--
															<table cellpadding="0" cellspacing="0" width="100%" height="100%">
																<tr>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px" width="25%">${v3x:toHTML(bean.type.typeName)}</td>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px" width="25%">${v3x:toHTML(bean.publishDeptName)}</td>
																	<td class="font-12px" nowrap="nowrap" align="" width="5%"><fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
													                <td class="font-12px" width="25%">${bean.readCount}</td>
																</tr>
																
																<tr class="padding_t_5">
																    <td class="font-12px" nowrap="nowrap" align=""><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																	<td class="font-12px"><fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /></td>
																	
																	<td class="font-12px" nowrap="nowrap" align=""><fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
																    <td nowrap="nowrap">
																    	<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
																    	<div title="${v3x:toHTML(publishScopeStr)}" class="font-12px">${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 24, "..."))}</div>
																    </td>
																    <c:choose>
																    	<c:when test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
																		    <td class="font-12px" nowrap="nowrap" align="" height="16">
																				<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
																			</td>
																			<td class="font-12px" nowrap="nowrap">
																			    	${v3x:showMemberName(bean.auditUserId)}
																			</td>
																    	</c:when>
																    	<c:otherwise>
																    		<td class="font-12px" nowrap="nowrap" align="">&nbsp;</td>
																	    	<td class="font-12px" nowrap="nowrap">&nbsp;</td>
																    	</c:otherwise>
																    </c:choose>
																</tr>
																
																<c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
																	<tr>
																	    <td class="font-12px" nowrap="nowrap" align="">
																	    	<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
																	    </td>
																	    <td class="font-12px" nowrap="nowrap">
																	    	<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
																	    </td>
																	    <td class="font-12px" nowrap="nowrap" align="">&nbsp;</td>
																	    <td class="font-12px" nowrap="nowrap">&nbsp;</td>
																	    <td class="font-12px" nowrap="nowrap" align="">&nbsp;</td>
																	    <td class="font-12px" nowrap="nowrap">&nbsp;</td>
																	</tr>
																</c:if>
																
																<tr><td>&nbsp;</td></tr>
															</table>
															-->
															</td></tr>
														</table>
														</center>
														</c:otherwise>
													</c:choose>												
												</td>
											</tr>
		
											<tr>
												<td width="100%" id="contentTD" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : '100%'}" style="padding-bottom: 6px;" valign="top" colspan="6">
										          	<div style="height:100%">
										            	<v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  contentName="${bean.contentName}" viewMode="edit"/>
										            	<script type="text/javascript">
						                                    if (officecanSave=="true"){
						                                        editType = "4,0";
						                                    }else{
						                                        editType = "0,0";
						                                    }
						                                </script>
										            </div>
										            <style>
                                                    .contentText p{
                                                        font-size:16px;
                                                    }
                                                    </style>
                                                    <!-- 
                                                    
										            <c:if test="${empty bean.ext5 && (bean.dataFormat == 'OfficeWord' || bean.dataFormat == 'OfficeExcel')}">
														<%-- æ­¤å¤divçidåªè½æ¯"edocContentDiv", ç¨æ¥æ§å¶officeæ§ä»¶æå è½½, å¦æä»¥åshowContentç»ä»¶æ¯æè¿ä¸ªå±æ§åå¯ä»¥ä¿®æ¹æ­¤åç§° --%>
														<div id="edocContentDiv" style="display: none; width: 0px; height: 0px;">
															<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" contentName="${bean.contentName}" htmlId="content" viewMode ="edit" />
														</div>
													</c:if>
													 -->
												</td>
											</tr>
							
											<c:if test="${bean.attachmentsFlag}">
												<tr>
													<td align="center">
													</td>
												</tr>
											</c:if>	
						
											<tr id="attachmentTr" style="display: none">
											  <td class="paddingLR" height="30" colspan="6">
											   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
													<tr>
														<td height="10" valign="top" colspan="6">
															<hr size="1" class="newsBorder">
														</td>
													</tr>
													
												    <tr style="padding-bottom: 20px;">
														<td nowrap="nowrap" width="50" class="font-12px" ><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
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
							
											<tr id="attachment2Tr" style="display: none">
											  <td class="paddingLR" height="30" colspan="6">
											   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
													<tr>
														<td height="10" valign="top" colspan="6">
															<hr size="1" class="newsBorder">
														</td>
													</tr>
													
												    <tr style="padding-bottom: 20px;">
														<td nowrap="nowrap" width="70" class="font-12px" style="padding-bottom: 20px;"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
														<td width="100%" class="font-12px" style="padding-bottom: 20px;">
														  <v3x:attachmentDefine	attachments="${attachments}" />	
															<script type="text/javascript">		
																showAttachment('${bean.id}', 2, 'attachment2Tr', '');		
															</script>
														</td>
													 </tr>
												</table>
											  </td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table> 
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr><td class="body-bgcolor" style="background:#fff" height="10"></td></tr>
</table>