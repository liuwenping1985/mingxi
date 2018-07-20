<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@ include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
<!--

 var oldState = "${blogEmployee.flagStart}";
 var oldSize = "${totalLongByM}";
 //alert(oldState)
// alert(oldSize)

 function listenerKeyPress(){
		if(event.keyCode == 27){
			window.close();			
		}
		if(event.keyCode==13){		
			event.keyCode = 9;
		}
	}

	function submitForm(){
	//alert("---");
		var theForm = document.getElementsByName("fm")[0];

	//	var parent = window.dialogArguments.document;
	
	//	alert(flag);
		if (!theForm) {
        	return;
    	}
    	theForm.target = "_parent";
		theForm.action = "${detailURL}?method=modifyEmployeeAdmin";
	
		 if (checkForm(theForm)) {
			 //var startFlag = document.getElementById("flagStart").value;
			 //var spaceSize = document.getElementById("docSize").value;
			 //if((startFlag == '0')&&(oldState == '0'&&(spaceSize != oldSize))){ 

			   //alert (v3x.getMessage('BlogLang.blog_not_allowed_to_modify'));
			   //return;
			// }
				//var docsize = document.getElementById("docSize").value;
				//if(size < 10){
				//	alert(v3x.getMessage('BlogLang.blog_size_assigned_less_than_min'));
				//	return;
				//}
				
				//if(docsize < 10){
					//alert(v3x.getMessage('DocLang.doc_space_blog_less_than_min'));
					//return;
			//	}else if(docsize > 1 * 1024){
				//	alert(v3x.getMessage('DocLang.doc_space_blog_more_than_max'));
					//return;
				// }
			//}
		
        	theForm.submit();
   	 	}
	}
//-->
</script>
<body onkeydown="listenerKeyPress()">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">
<input name="id" type="hidden" value="${blogEmployee.id}">
<input name="image" type="hidden" value="${blogEmployee.image}">
<input name="deptId" type="hidden" value="${v3x:toHTML(deptId)}">

 <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap">
					    <c:if test="${dbClick == 'true' }">
					       <fmt:message key="common.toolbar.update.label" bundle="${v3xCommonI18N}"/>
					     </c:if>
					     <c:if test="${dbClick == 'false' }">
					       <fmt:message key="common.toolbar.view.label" bundle="${v3xCommonI18N}"/>
					     </c:if>
					</td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div id="categorySet-body">
				<table width="500" border="0" cellspacing="0" cellpadding="0" align="center" style="font-size: 12px">
<!--					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" width="25%" nowrap>
							<fmt:message key="org.member_form.name.label"/>:
						</td>					
						</td>
						<td class="new-column , blog-tb-padding-topAndBottom">
							<c:out value="${userName}" escapeXml="true"/>
						</td>
					</tr>
 					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" width="25%" nowrap>
							<fmt:message key="org.member_form.introduce"/>:
						</td>					
						</td>
						<td class="new-column , blog-tb-padding-topAndBottom">
							<textarea id="introduce" name="introduce" class="input-100per"
							rows="5"><c:out value="${blogEmployee.introduce}" escapeXml="true"/></textarea>
						</td>
					</tr>
					 
 -->		
                     
                      <tr>
						<td class="bg-gray" width="25%" nowrap><fmt:message key='org.member_form.name.label'/>:</td><td class="new-column" width="75%">
							<label style="width:90%;">${userName}</label>
						</td>
					</tr>
 			
					<tr>
						<td class="bg-gray" width="30%" nowrap><fmt:message key='blog.space.totalsize'/>:</td><td class="new-column" width="70%">
							<label style="width:90%;">							<label style="width:90%;">
							<label style="width:90%;">${totalLongByM}&nbsp;MB</label>
							</label>

                      </label>
						</td>
					</tr>
					<tr>
						<td class="bg-gray" width="25%" nowrap><fmt:message key='blog.space.usedsize'/>:</td><td class="new-column" width="75%">
							<label style="width:90%;">							<label style="width:90%;">
							<label style="width:90%;">${blogUsedSpace}</label>
							</label>

                      </label>
						</td>
					</tr>
					
					<tr>
						<td class="bg-gray" width="25%" nowrap><fmt:message key='blog.space.status'/>:</td><td class="new-column" width="75%">
							<label style="width:90%;">
							<fmt:message key="${model.blogStatus}" bundle="${v3xDocI18N}" />
							</label>
						</td>
						
					</tr>

					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" nowrap valign="middle">
							<fmt:message key="org.member_form.flagstart" />:
						</td>
						<td class="new-column blog-tb-padding-topAndBottom" valign="middle">
						<div class="div-float">
							<select name="flagStart" id="flagStart" class="condition">
								<option value="1" <c:if test="${blogEmployee.flagStart == 1}">selected</c:if>>
								<fmt:message key="org.member_form.start.rep" />
								</option>
								<option value="0" <c:if test="${blogEmployee.flagStart == 0}">selected</c:if>>
								<fmt:message key="org.member_form.end.rep" />
								</option>
							</select>
						</div>
						</td>
					</tr>
				</table>
			</div>		
		</td>
	</tr>
	<tr id="enEdiable">
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="history.go(-1)" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
	var _dbClick="${v3x:escapeJavascript(dbClick)}";
	if(_dbClick == 'true'){
		document.getElementById("enEdiable").style.display="";
	}
	else{
		document.getElementById("enEdiable").style.display="none";
		//document.getElementById("docSize").disabled = true;
		document.getElementById("flagStart").disabled = true;
	}
	//调节页面高度
	bindOnresize('categorySetBody',30,100);
</script>
</body>
</html>