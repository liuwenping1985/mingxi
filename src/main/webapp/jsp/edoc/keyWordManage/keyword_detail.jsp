<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>editKeyword</title>
		<%@include file="../edocHeader.jsp" %>
		<script type="text/javascript">
			function showDetail(id,readonly){
				parent.detailFrame.window.location='${edocKeyWordUrl}?method=editKeyword&readOnly='+readonly+'&id='+id;
			}

			/**
			 * 提交表单
			 */
			function submitKeywordForm(isVaidata,theForm){
				    if(isVaidata){
				      //getA8Top().startProc(''); 
				      document.getElementById("submintButton").disabled = true;
				      document.getElementById("submintCancel").disabled = true;
				      return true;
				    }else{
				      return false;
				    }
			}
			
			/**
			 * 校验关键字是否重复
			 */
			function checkDoubleName(){
		  		if(keywordForm.name.value == "${v3x:toHTML(keyword.name) }"){
			  		return true;
			  	}
	    		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocKeyWordManager", "ajaxNameIsExist", false);
	    		requestCaller.addParameter(1, "String", keywordForm.name.value);
	    		var ds = requestCaller.serviceRequest();
	    		if (ds == "true") {
	    			alert(v3x.getMessage("edocLang.doc_keyword_two_no_equ"));
	    			return false ;
	    		} else {
	    			return true;
	    		}
			}
		</script>
	</head>
	<body scroll="no" style="overflow: no">
		<form id="keywordForm" name="keywordForm" method="post" target="editKeywordFrame" action="${edocKeyWordUrl}?method=update" onsubmit="return (submitKeywordForm(checkForm(this)&& checkDoubleName(),this))">
			<input type="hidden" value="${keyword.id}" id="id" name="id" />
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
				<tr align="center">
					<td height="8" class="detail-top">
						<script type="text/javascript">
							getDetailPageBreak(); 
						</script>
					</td>
				</tr>	
				<tr>
					<td class="categorySet-4" height="8"></td>
				</tr>
				<tr>
					<td class="categorySet-head" height="23">
						<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="categorySet-1" width="4"></td>
								<c:if test="${preview == 0 }">
								<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key="edoc.keyword.preview" /></td> 
								</c:if>
								<c:if test="${preview == 1 }">
								<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key="edoc.keyword.modify" /></td> 
								</c:if>
								<td class="categorySet-2" width="7"></td>
								<td class="categorySet-head-space">&nbsp;
									<c:if test="${!readOnly}">
									<font color="red">*</font><fmt:message key="edoc.keyword.mustWrite" />
									</c:if>
								 </td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="categorySet-head">
						<div class="categorySet-body" style="padding:0;border-bottom:1px solid #a0a0a0;">
							<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
								<tr>
									<td height="10%">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top">
										<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" valign="center">
											<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}"/>
											<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}"/>
											<tr>
												 <td class="bg-gray" width="30%" nowrap="NOWRAP"><label for="name"><font color="red">*</font><fmt:message key="edoc.keyword.name" />:</label></td>
												 <td class="new-column" width="70%" nowrap="nowrap">
													<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
													<input name="name" type="text" id="name" maxlength="85" maxSize="85" class="input-100per" style="height:22px;margin-top:5px;"
													deaultValue="${defName}"
													inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" validate="isDeaultValue,notNull,maxLength,isWord" character="|,/\"
													value="${v3x:toHTML(keyword.name) }"
													onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"} ${dis}/>
												</td>
											</tr>
											<tr>
												<td class="bg-gray" width="20%" nowrap="nowrap"><font color="red">*</font><label for="keyword.sortNum"><fmt:message key="common.sort.label" bundle="${v3xCommonI18N}" />:</label></td>
												<td class="new-column" width="80%">
													<input class="input-100per" style="height:22px;margin-top:5px;" maxlength="6" type="text" name="sortNum" value="${keyword.sortNum}"  ${dis} 
													id="keyword.sortNum" validate="isInteger,notNull" maxlength="6" min="1" inputName="<fmt:message key='common.sort.label' bundle='${v3xCommonI18N}'/>"/>
												</td>
											</tr>
											<tr>
												<td class="bg-gray" nowrap="nowrap"><label for="level.code"><fmt:message key="edoc.keyword.createUserName" />:</label></td>
												<td class="new-column">
													<input class="input-100per" style="height:22px;margin-top:5px;" maxlength="6" disabled="disabled" type="text" name="createUserName" value="${v3x:showMemberName(keyword.createUserId)}"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>		
					</td>
				</tr>
				<c:if test="${!readOnly}">
				<tr>
					<td height="42" align="center" class="bg-advance-bottom">
						<input id="submintButton" type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
						<!-- -点击取消按钮跳转至详细信息预览页面 -->
						<input id="submintCancel" type="button" onclick="showDetail('${keyword.id}', true)" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
				</c:if>
			</table>
		</form>
		<iframe name="editKeywordFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		<script type="text/javascript">
			if(${!readOnly}){
				document.getElementById("name").focus();
			}
		</script>
	</body>
</html>
