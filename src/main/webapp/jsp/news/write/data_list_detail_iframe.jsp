<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
	<link href="<c:url value="/apps_res/news/css/news.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<script type="text/javascript">
var exist = '${existFlag}';
if(exist == 'false'){	
	alert(v3x.getMessage('bulletin.data_deleted'));
	window.close();
}
function sendCheck(){
	hiddenIframe.location.href = "${newsDataURL}?method=publishOper&id=${bean.id}&form_oper=publish&info=0";
	if(parent.opener){
		window.close();
		//TODO wanguandong 2012-11-21 放开GETA8测试
		parent.opener.getA8Top().reFlesh();
	}
}
</script>
</head>
<body scroll="no" style="overflow: hidden;">
<input type="hidden" id="createDate" name="createDate" value="${bean.createDate}" />
<input type="hidden" id="imageId" name="imageId" value="${bean.imageId}" />
<input type="hidden" id="imageDate" name="imageDate" value="${imageDate}" />
<input type="hidden" id="subject" name="subject" value="${v3x:toHTML(bean.title)}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="">
	<tr height="8" class="${param.from=='list'?'show':'hidden'}">
			<td  width="100%" height="8" >
				<table id="stitle" width="100%" border="0" cellpadding="0" cellspacing="0" >
					<tr >
						<td width="100%" height="8">
							<script type="text/javascript">
								getDetailPageBreak();
							</script>
						</td>
					</tr>
				  </table>  
			</td>
		</tr>
</table>
<div class="body-bgcolor-audit" style="height:100%;">
	<div class="scrollList" style="height:97%">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${bean.dataFormat=='HTML'?'body-detail':'body-detail-office'} margin-auto">
		<tr>
		 <td height="30">
		 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 	<tr class="page2-header-line-old" height="30">
				<td align="right" class="padding5" colspan="3">
					<c:if test="${bean.imageNews}">
						<input type="button" onclick="look()" class="button-default-2"  value="<fmt:message key='new.lookImage' />" />&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
				</td>
			</tr>
			 <tr>
			   <td width="35">&nbsp;</td>
			   <td align="center" width="90%" class="titleCss" style="padding: 20px 0px 10px 0px;">${v3x:toHTML(bean.title)}</td>
			   <td width="35">&nbsp;</td>
			  </tr>
			  
			</table>
		 </td>
		</tr>
		<tr>
			<td align="center" class="paddingLR font-12px" height="30">
				<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" /> 
				&nbsp;&nbsp;&nbsp;&nbsp;
				${bean.publishDepartmentName}
				<c:if test="${bean.showPublishUserFlag }">
				&nbsp;&nbsp;&nbsp;&nbsp;
				${bean.createUserName}
				</c:if>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<fmt:message key="label.readCount" />: ${bean.readCount}
			</td>
		</tr>
		<c:if test="${bean.showKeywordsArea == true || bean.showBriefArea == true}">
		<tr>
			<td height="${bean.showBriefArea == true? '60':'28'}">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="word-break:break-all;word-wrap:break-word">
				<c:if test="${bean.showKeywordsArea == true}"> 
				<tr>
					<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
					<td class="font-12px" style="padding: 0 12px;">
						${v3x:toHTML(bean.keywords)}
					</td>
				</tr>
				</c:if>
				<c:if test="${bean.showBriefArea == true}">
				<tr>
					<td class="font-12px" valign="top" height="40" align="right"><b><fmt:message key="news.data.brief"/>:</b></td>
					<td class="font-12px" valign="top" style="padding: 0 6px;">&nbsp;&nbsp;${v3x:toHTML(bean.brief)}</td>
				</tr>
				</c:if>
				</table>
			</td>	
		</tr>
		</c:if>
		  <tr>
              <td width="100%" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768' : '100%'}" style="padding-bottom: 6px;" valign="top">
                   <div style="height: 100%;">                            
                       <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  viewMode="edit"/>       
                   </div>
                   <style>
                        .contentText p{
                            font-size:14px;
                        }
                   </style>
               </td>
           </tr>
		<!-- 关联文档显示内容-->
		<tr id="attachment2Tr" style="display: none">
		  <td class="paddingLR" height="30" colspan="6">
		   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
				<tr>
					<td height="10" valign="top" colspan="6">
						<hr size="1" class="newsBorder">
					</td>
				</tr>
				
			    <tr style="padding-bottom: 20px;">
					<td nowrap="nowrap" width="70" class="font-12px" valign="top"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
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
		<!-- end -->
		
		<tr id="attachmentTr" style="display: none;">
			<td class="paddingLR" height="50" valign="top">
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="10" valign="top" colspan="2">
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
		</table>
		<c:if test="${bean.state!=0 && bean.state!=10 && bean.auditUserId!=null}">	
		<table width="100%" height="80" border="0" cellpadding="0" cellspacing="0" class="body-detail">
			<tr>
				<td height="20" class="passText" nowrap="nowrap" colspan="4">
					<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}"  /><fmt:message key="label.colon" />
					<c:if test="${bean.state==20}">
					<input type="button" onclick="sendCheck()" class="button-default-2 div-float-right" value="<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/>"/>
					</c:if>
				</td>
			</tr>
			<tr class="passText" style="background-color: rgb(239, 237, 237)">
                <td height="20" width="80" nowrap="nowrap"  align="center">
                  <a style="font-size: 12;font-weight: bold;color:#318ed9;" onclick="showV3XMemberCard('${bean.auditUserId}',getA8Top());">
                  ${v3x:showMemberName(bean.auditUserId)}</a>
                </td>
    			<td width="100" align="left" nowrap="nowrap" style="font-size: 12;font-weight: bold; color:#111;">		
    				<c:if test="${(bean.state==30 && bean.ext3==1) or (bean.state==20)}">
    					<fmt:message key="label.audit" /><fmt:message key="label.accept" />
    				</c:if>
    				<c:if test="${bean.state==30 && bean.ext3!=1}">
    					<fmt:message key="label.accept2" />
    				</c:if>
    				<c:if test="${bean.state==40}">
    					<fmt:message key="label.noaccept" />
    				</c:if>							
    			</td>
                <td nowrap="nowrap" style="color: #a3a3a3;font-size: 12">
                  <fmt:formatDate value="${bean.auditDate}" pattern="yyyy-MM-dd HH:mm" />
                </td>
                <td nowrap="nowrap">
                </td>
			</tr>
			<tr>
                <td colspan="6" style="font-size: 12px;padding-left: 10px;">
                    ${v3x:toHTML(bean.auditAdvice)}&nbsp;
                </td>
			</tr>
		</table>
		</c:if>
		</div>	
</div>
<iframe id="hiddenIframe" name="hiddenIframe"  width="0" height="0" frameborder="0"></iframe>
</body>
<script type="text/javascript">
if(document.body.scrollWidth > 0) {
	document.getElementById('stitle').width = document.body.scrollWidth;
}
</script>
</html>