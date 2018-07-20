<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<style>
<!--
.appendInfo{
	border-bottom-width: 1px;
	border-bottom-color: #c5cad2;
}
-->
</style>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
    <tr height="100%">
        <td class="body-bgcolor" width="100%" height="100%">
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${bean.dataFormat=='HTML'?'body-detail':'body-detail-office'} margin-auto" align="center">    
                <tr height="100%">
                    <td colspan="6" valign="top">
                        <div id="printThis" style="height: 100%;">
                            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
                                <tr height="100%">
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
                                            <tr style="padding-bottom: 20px;">
                                                <td nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
                                                <td width="100%" class="font-12px">
                                                  <v3x:attachmentDefine attachments="${attachments}" /> 
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
                                        <tr style="padding-bottom: 20px;">
                                            <td nowrap="nowrap" width="70" class="font-12px"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
                                            <td width="100%" class="font-12px">
                                              <v3x:attachmentDefine attachments="${attachments}" /> 
                                                <script type="text/javascript">     
                                                    showAttachment('${bean.id}', 2, 'attachment2Tr', '');       
                                                </script>
                                            </td>
                                         </tr>
                                    </table>
                                  </td>
                                </tr>
                                
                                <tr>
                                    <td colspan="6" class="paddingLR" height="30" id="paddId" >  
                                    <c:choose>
	                                    <c:when test="${bean.showPublishUserFlag }">
	                                         <table class="appendInfo" cellspacing="0" cellpadding="0" width="100%" height="100%" >
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" title="${v3x:toHTML(bean.title)}" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${v3x:toHTML(v3x:getLimitLengthString(bean.title, 30, "..."))}
	                                                </td>
	                                                <c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
	                                                <td class="font-12px sort" title="${v3x:toHTML(publishScopeStr)}" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 30, "..."))}
	                                                </td>
	                                            </tr>
	                
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
															${bean.publishMemberName}
	                                                </td>
	                                                <td class="font-12px sort" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    <fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" />
	                                                </td>
	                                            </tr>
	                                            
	                                        <c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${v3x:showMemberName(bean.auditUserId)}
	                                                </td>
	                                                <td class="font-12px sort" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    <fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
	                                                </td>
	                                            </tr>
	                                        </c:if>
	                
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                        ${v3x:toHTML(bean.publishDeptName)}
	                                                </td>
	                                                <td class="font-12px sort" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${bean.readCount}
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </c:when>
	                                    <c:otherwise>
	                                       <table class="appendInfo" cellspacing="0" cellpadding="0" width="100%" height="100%" >
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" title="${v3x:toHTML(bean.title)}" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${v3x:toHTML(v3x:getLimitLengthString(bean.title, 30, "..."))}
	                                                </td>
	                                                <c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
	                                                <td class="font-12px sort" title="${v3x:toHTML(publishScopeStr)}" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${v3x:toHTML(v3x:getLimitLengthString(publishScopeStr, 30, "..."))}
	                                                </td>
	                                            </tr>
		                                        <c:if test="${bean.auditUserId !=null && bean.auditUserId != 0 && bean.auditUserId != -1}">
		                                            <tr class="sort">
		                                                <td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
		                                                    <fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
		                                                    ${v3x:showMemberName(bean.auditUserId)}
		                                                </td>
		                                                <td class="font-12px sort" width="50%">&nbsp;&nbsp;
		                                                    <fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
		                                                    <fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
		                                                </td>
		                                            </tr>
		                                        </c:if>
	                                            <tr class="sort">
	                                                <td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                        ${v3x:toHTML(bean.publishDeptName)}
	                                                </td>
	                                                <td class="font-12px sort" width="50%">&nbsp;&nbsp;
	                                                    <fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    <fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" />
	                                                </td>
	                                            </tr>
	                                            <tr class="sort">
	                                            	<td class="font-12px sort" width="100%" colspan="2">&nbsp;&nbsp;
	                                                    <fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	                                                    ${bean.readCount}
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </c:otherwise>
                                    </c:choose>                       
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="center">
                                        &nbsp;
                                    </td>
                                </tr>   
                                            
                                <tr>
                                    <td align="center">
                                    <div id="noprint" style="visibility:visible">
                                        <c:if test="${param.fromPigeonhole!=true && docCollectFlag eq 'true'}">
                                            <span id="cancelFavorite${bean.id}" class="font-size-12 cursor-hand ${!isCollect?'hidden':''}" onclick="javaScript:cancelFavorite_old('7','${bean.id}','${bean.attachmentsFlag }','3')">
                                                <img class="cursor-hand" style="vertical-align: middle;;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/uncollect.gif" />">
                                                <fmt:message key='bulletin.cancel.favorite' />
                                            </span>
                                            <span id="favoriteSpan${bean.id}" class="font-size-12 cursor-hand ${isCollect?'hidden':''}" onclick="javaScript:favorite_old('7','${bean.id}','${bean.attachmentsFlag }','3')">
                                                <img class="cursor-hand" style="vertical-align: middle;;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/collect.gif"/>">
                                                <fmt:message key='bulletin.favorite' />
                                            </span>
                                            <span class="margin_r_5">&nbsp;</span>
                                        </c:if>
                                        <c:choose>
                                         <c:when test="${bean.ext2=='1' && param.openFrom ne 'glwd'}">
                                                <span name="mergeButton" class="font-size-12 margin_r_10 cursor-hand" href="javascript:void(0);" name="mergeButton" onclick="printResult('${bean.dataFormat}', '${empty bean.ext5}')" >
                                                    <img class="cursor-hand" style="vertical-align: middle;;margin-top: -1px;" src="<c:url value="/common/images/toolbar/print.gif"/>">
                                                    <fmt:message key="oper.print" />
                                                </span>
                                                <script>officecanPrint = "true"; officecanSaveLocal = "true";</script>
                                        </c:when>
                                        <c:otherwise>
                                        <script>officecanPrint = "false"; officecanSaveLocal = "false";</script>  
                                        </c:otherwise>
                                        </c:choose>                                    
                                    <c:if test="${isManager}">
                                        <input type="button" name="mergeButton" class="button-default-2 button-default-2-long" onclick="showReadList1('${param.id}','<fmt:message key="bul.userView.CallInfo" />','${param.fromPigeonhole}')" value="<fmt:message key="bul.userView.CallInfo" />" />
                                    </c:if>
                                     
                                    </div>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="center">&nbsp;</td>
                                </tr>               
                            </table>
                        </div>
                    </td>
                </tr>
            </table> 
        </td>
    </tr>

    <tr><td height="10"></td></tr>
</table>
