<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<!-- 审核前的JSP -->
<head>
<title>
<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /></c:if><fmt:message key="news.title" />
</title>
<%@ include file="../include/header.jsp" %>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<style>.contentText{padding-top:0;}</style>
<script type="text/javascript">
<!--
	function getOperType(){
		var eles = document.getElementsByName("auditOption");
		for(var i = 0 ; i < eles.length; i++){
			if(eles[i].checked)
				return eles[i].value;
		}
		return  'publish';
	}

		function saveForm(){
			if(!checkForm($('dataForm'))){
				return false;
			}
			// 數據有效性检查
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager",
				 "dataExist", false);
			requestCaller.addParameter(1, "Long", '${bean.id}');
				
			var existflag = requestCaller.serviceRequest();
			if(existflag == 'false'){
				alert(v3x.getMessage("bulletin.data_deleted"));
				
				if(window.dialogArguments)
					window.close();
				else{
					parent.location.href = '${bulDataURL}?method=auditListMain&from=${param.from}&spaceId=${param.spaceId}';
				}
					
				return;
			}
			
			var operType = getOperType();
		
		    var parentObj = top.window.dialogArguments;	
		  	if(parentObj){
				$('form_oper').value=operType;
				document.getElementById("hiddenId").value= "hiddenId";
				document.dataForm.target = "hiddenIframe";
				$('dataForm').submit();	
		  	}else{
		    	$('form_oper').value=operType;
				$('dataForm').submit();	
		  	}
		}
		function goHead(){
			var parentObj = top.window.dialogArguments;
			if (parentObj){
				document.getElementById("method").value= "auditListMain";
				document.dataForm.target = "hiddenIframe";
				document.getElementById("hiddenId").value= "hiddenId";
				$('dataForm').submit();	
			}else{
				history.go(-2);
			}

		}
			function myOnload(){
				document.getElementById("scrollList").style.height=window.document.body.clientHeight+"px";
			var parentObj = top.window.dialogArguments;
			if (parentObj){
				location.href='#aaa';
			}else{
				
			}
	}

	function unlock(id)
	{
		//进行解锁
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
//-->
</script>
</head>
<input type="hidden" id="createDate" name="createDate" value="${bean.createDate}" />
<input type="hidden" id="imageId" name="imageId" value="${bean.imageId}" />
<body onload="myOnload();" style="overflow: auto;" onkeydown="listenerKeyESC()" onunload="unlock('${bean.id}')">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="table-layout: fixed;">		
	<tr>
		<td class="body-bgcolor" width="100%" height="100%" style="padding: 0px;">
		<div id="scrollList" class="scrollList" style="text-align: center;"><a name="aaa"></a>
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail" style="margin: auto;">
			<tr class="page2-header-line-old">
				<td width="100%" height="60">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="CollTable">
						<tr class="page2-header-line-old" height="60">
							 <td width="80" height="60"><span class="new_img"></span></td>
		        			 <td class="page2-header-bg-old"><fmt:message key="news.title" /></td>
		       				 <td class="page2-header-line-old page2-header-link" align="right">&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
				<td align="right"class="padding5">
					<c:if test="${bean.imageNews==true}">
					 <input type="button" class="button-default-2"  onclick="look()" value="<fmt:message key='new.lookImage' />" />&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
				</td>
			</tr>
			<tr>
			 <td height="30">
			 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				 <tr>
				   <td align="center" width="100%" class="titleCss" style="padding: 10px 6px;">${v3x:toHTML(bean.title)}</td>
				  </tr>
				</table>
			 </td>
			</tr>
			<tr>
				<td class="padding35">
					<table width="100%" height="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td class="font-12px" align="center" height="28" style="padding: 0 0 10px 0;">
								<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<c:choose>
									<c:when test="${publicCustom}">
										${spaceName}
									</c:when>
									<c:otherwise>
										${bean.publishDepartmentName}
									</c:otherwise>
								</c:choose>
								&nbsp;&nbsp;&nbsp;&nbsp;
								${v3x:showOrgEntitiesOfIds(bean.publishUserId, 'Member', pageContext)}
								&nbsp;&nbsp;&nbsp;&nbsp;
								<fmt:message key="label.readCount" />: ${bean.readCount}
							</td>
						</tr>
						<c:if test="${bean.showKeywordsArea == true || bean.showBriefArea == true}">
						<tr>
							<td height="${bean.showBriefArea == true? '60':'28'}">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<c:if test="${bean.showKeywordsArea == true}"> 
								<tr>
									<td class="font-12px" nowrap="nowrap" width="50" height="24" align="right"><b><fmt:message key="news.data.keywords" />:</b></td>
									<td style="padding: 0 6px;" class="font-12px">
										&nbsp;&nbsp;${v3x:toHTML(bean.keywords)}
									</td>
								</tr>
								</c:if>
								<c:if test="${bean.showBriefArea == true}">
								<tr>
									<td valign="top" class="font-12px" width="50" height="40" nowrap="nowrap" align="right"><b><fmt:message key="news.data.brief"/>:</b></td>
									<td valign="top" class="font-12px" style="padding: 0 6px;">&nbsp;&nbsp;${v3x:toHTML(bean.brief)}</td>
								</tr>
								</c:if>
								</table>
							</td>	
						</tr>
						</c:if>
					</table>
				</td>
			</tr>
			<tr>
				<td width="100%" id="contentTD" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : '100%'}" colspan="2" style="padding-bottom: 6px;" valign="top">
					<div style="height:100%">	
		            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" viewMode="edit"/>	
					</div>
                    <style>
                        .contentText p{
                            font-size:14px;
                        }
                   </style>
				</td>
			</tr>
		</table>
		</div>	
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
/*try{//修改：OA-78130
	if (document.getElementById('contentTD').height > 0 && document.getElementById('officeFrameDiv')) {
		document.getElementById('officeFrameDiv').style.height = document.getElementById('contentTD').height + "px";
	}
}catch(e){}*/
</script>
</body>
</html> 

