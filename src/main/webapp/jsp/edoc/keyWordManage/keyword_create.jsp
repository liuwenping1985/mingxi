<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<title>addGroupLevel</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="../edocHeader.jsp"%>
		<script type="text/javascript">

		/*
		 * 连续添加方法
		 */
		function doEndKeyword(){	
			var _cont = document.getElementById("cont");

			//连续添加
		 	if(_cont && _cont.checked){ 
				document.getElementById("name").value = "";
				document.getElementById("sortNum").deaultValue = "";
				document.getElementById("name").focus();
				desabledButton(false);
				parent.detailFrame.showDetail = false;
		 	}else{
				document.getElementById("name").disabled = true;
				document.getElementById("sortNum").disabled = true;
				parent.detailFrame.showDetail = true;
			}
			parent.listFrame.location.reload(true);
			parent.treeFrame.location.reload(true);
		}


		function desabledButton(flag){
			document.getElementById("submintButton").disabled = flag;
			document.getElementById("submintCancel").disabled = flag;
		}
		
		/**
		 * 提交表单
		 */
		function submitKeywordForm(isVaidata,theForm){
			    if(isVaidata){
			      getA8Top().startProc(''); 
			      desabledButton(true);
			      return true;
			    }else{
			      return false;
			    }
		}
		
		/**
		 * 校验关键字是否重复
		 */
		function checkDoubleName(){
	  		if(keywordForm.name.value == "${keyword.name}"){
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
		<form id="keywordForm" method="post" target="addKeywordFrame" action="${edocKeyWordUrl}?method=create" onsubmit="return (submitKeywordForm(checkForm(this)&& checkDoubleName(),this))">
			<input type="hidden" value="${parentId}" id="parentId" name="parentId" />
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
							<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key='edoc.add.keywords'/></td>
							<td class="categorySet-2" width="7"></td>
							<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="edoc.keyword.mustWrite" /></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="categorySet-head">
						<div class="categorySet-body" style="padding:0;border-bottom:1px solid #a0a0a0;">
							<table width="100%" height="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td height="10%">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top">
										<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" valign="center">
											<tr>
												 <td class="bg-gray" width="30%" nowrap="NOWRAP"><label for="name"><font color="red">*</font><fmt:message key="edoc.keyword.name" />:</label></td>
												 <td class="new-column" width="70%" nowrap="nowrap">
													<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
													<input name="name" type="text" id="name" maxlength="85" maxSize="85" class="input-100per" style="height:22px;margin-top:5px;"
													deaultValue="${defName}"
													value="${defName}"
													inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" validate="isDeaultValue,notNull,maxLength,isWord" character="|,/\"
													onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/>
												</td>
											</tr>
											<tr>
												<td class="bg-gray" width="20%" nowrap="nowrap">
													<font color="red">*</font><label for="keyword.sortNum"><fmt:message key="common.sort.label" bundle="${v3xCommonI18N}" />:</label>
												</td>
												<td class="new-column" width="80%">
													<input class="input-100per" style="height:22px;margin-top:5px;" maxlength="6" type="text" name="sortNum" id="sortNum" validate="isInteger,notNull" maxlength="6" min="1" inputName="<fmt:message key='common.sort.label' bundle='${v3xCommonI18N}'/>"/>
												</td>
											</tr>
											<tr>
												<td class="bg-gray" nowrap="nowrap">
													<label for="level.code"><fmt:message key="edoc.keyword.createUserName" />:</label>
												</td>
												<td class="new-column">
													<input class="input-100per" style="height:22px;margin-top:5px;" maxlength="6" disabled="disabled" type="text" name="createUserName" value="${v3x:currentUser().name}"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td height="42" align="center" class="bg-advance-bottom">
					<table width="100%" height="100%" border="0" style="padding-top:5px;">
						<tr>
							<td width="20%" align="center">
								<label for="cont"> 
									<input id="cont" type="checkbox" name="cont" checked=${param.cont== "true" ? "checked" : "" }> <fmt:message key="edoc.keyword.continue" /> 
								</label>
							</td>
							<td width="60%" align="center" valign="middle" height="100%" style="padding-top:5px;">
								<input id="submintButton" type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp; 
								<input id="submintCancel" type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
							</td>
							<td width="20%"></td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</form>
		<iframe name="addKeywordFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	</body>
</html>