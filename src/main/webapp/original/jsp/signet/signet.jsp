<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>印章管理</title>
<%@include file="header.jsp"%>
<c:set value="${v3x:currentUser().loginAccount}" var='currentAccountId'/>
<script type="text/javascript" src="/seeyon/common/js/imgcut-debug.js"></script>
<script type="text/javascript">
var signet_operation = "${ctp:i18n('collaboration.common.signet.operation')}";
var signet_description = "${ctp:i18n('collaboration.common.signet.description')}";
var collaboration_picture_format = "${ctp:i18n('collaboration.picture.format')}";
//选择查看人
	var onlyLoginAccount_signetId=true;
	function setRefUserId(elements){
		if(elements){
			document.getElementById("signetauto").value = getIdsString(elements,false);
			document.getElementById("signetName").value = getNamesString(elements);
		}
	}
	function doOnclick(){
		fileUploadAttachments.clear();
		insertAttachment();
		var theList=fileUploadAttachments.keys();	//key
		var attach=fileUploadAttachments.get(theList.get(0),null);	//
		var _fileId=attach.fileUrl;
		var _createDate=attach.createDate;
		var _filename=attach.filename;
		var str="<img src=\"/seeyon/fileUpload.do?method=download&fileId="+_fileId+"&createDate="+_createDate+"&filename="+_filename+"\"><a href=\"#\" onclick=\"doOnclick();\">涓婁紶鍥剧墖</a> ";
		document.getElementById("thePicture").innerHTML=str;
		document.getElementById("theFileId").value=_fileId;
		document.getElementById("theFileURL").value=str;
	}
	function showimg(values){
	<%-- var obj = values;
		alert("values ::: " + values);
		obj = obj.split(".");
		obj = obj[obj.length-1].toLowerCase();
		alert("111111111111");
		alert("obj :: " + obj);
		var endName = document.getElementById("icon").value;
		alert("endName :: " + endName)
		if( obj == 'jpg' ){
		}else{
			alert("不是有效的文件！！");
		}
	--%>
	}
	/*
	 * 取消功能方法/
	 */
	 function cancelForm(form){
	 	document.getElementById(form).action= "<c:url value='/common/detail.jsp' />";
		document.getElementById(form).submit();
	 }
	 
	 function endNamePicture(){
	 	var showImg = ${showImg};
	 	if (showImg==0){
		 	var endName = document.getElementById("icon").value;
		 	if (endName==""){
                alert(_("sysMgrLang.system_no_picture"));
                return false;
            } 
		 	endName = endName.toLowerCase();
		 	var obj = endName.split(".");
			obj = obj[obj.length-1].toLowerCase();
		 	if(obj != "jpg" && obj != "bmp"){
				alert(_("sysMgrLang.system_signet_picture"));
				return false;
			}else{
				return true;
			}
		}else if (showImg==1){
			var endName = document.getElementById("icon").value;
			if(endName==""){return true;}
		 	endName = endName.toLowerCase();
		 	var obj = endName.split(".");
			obj = obj[obj.length-1].toLowerCase();
		 	if(obj != "jpg" && obj != "bmp"){
				alert(_("sysMgrLang.system_signet_picture"));
				return false;
			}else{
				return true;
			}
		}
	 }
	 // 验证重名
	 function validateSignet(){
	 	var markNameHidden = document.getElementById("markNameHidden").value;
		var markName = document.getElementById("markName").value;
		var showImg = ${showImg}
			 
		if (showImg==0){
			var requestCaller = new XMLHttpRequestCaller(this,"ajaxSignetManager","checkMarknameIsDupleInAccountScope",false);
			requestCaller.addParameter(1, "String", markName);
			requestCaller.addParameter(2, "Long", "${currentAccountId}");
			var signet = requestCaller.serviceRequest();
			if(signet == true || signet=="true"){
				alert(_("sysMgrLang.system_signet_double",markName));
				return false;
			}else{
				return true;
			}
		} else if (showImg==1){
			if(markNameHidden!=markName){
				var requestCaller = new XMLHttpRequestCaller(this,"ajaxSignetManager","checkMarknameIsDupleInAccountScope",false);
				requestCaller.addParameter(1, "String", markName);
				requestCaller.addParameter(2, "Long", "${currentAccountId}");
				var signet = requestCaller.serviceRequest();
				if(signet == true || signet=="true"){
					alert(_("sysMgrLang.system_signet_double",markName));
					return false;
				}else{
					return true;
				}
			}else{
				return true;
			}
		}
	 }
	   function submitCheck(){
			 disableButton("disable");
		     var signetForm =  document.getElementById("signetForm");
		     if(checkForm(signetForm) == false){
		    	 disableButton("enable");
		         return false;
		     }
		     if(validatepassword() == false){
		    	 disableButton("enable");
		         return false;
		     }
		      if(endNamePicture() == false){
		    	 disableButton("enable");
		         return false;
		     } 
		     if(validateSignet() == false){
		    	 disableButton("enable");
		         return false;
		     }
		     //wxj签章名称不能包含特殊字符 
		     var markName = document.getElementById("markName").value;
		     if(validateSubject(markName)){
		         disableButton("enable");
		         return false;
		     }
		     disableButton("enable");
		     return true;
		   }
		   //防止重复提交
		   function disableButton(flag){
		     if(flag=="disable"){
			     document.getElementById("submitButton").disabled=true;
		     }else{
		    	 document.getElementById("submitButton").disabled=false;
			  }
		   }
		 //截图
		   $(document).ready(function() { 
		$('#icon').ctpImgcut({
			parentWin: window,
			title: signet_operation,
			previewWidth: 140,
			previewHeight: 80,
			selectWidth:120,//画布默认的宽和高，如果小于80（宽和高）的情况，那么就默认全部选中
			selectHeight:60,
			width: 450,
	        height: 350,
			showInstruction: signet_description,
	        uploadCallback: function(instantces){ 
			
	        	if( instantces[0].extension != "jpg"  && instantces[0].extension != "bmp"){
	        		setTimeout(function(){
	        			alert(collaboration_picture_format);
	        		}, 50);
					return false;
				}
				$("#icon").val( instantces[0].filename);
				$("#imgType").val("."+instantces[0].extension);
				return true;
	        },
			//回调
			callbackFunction: function(retValue){ 
				if(retValue != undefined){
			          $("#iconId").val( retValue);
			          //显示图片
			          var picUrl = "fileUpload.do?method=showRTE&fileId="+retValue+"&type=image";
			          var pic = document.getElementById("Myimg");
			          if(pic !=null){
			        	  pic.src = picUrl;
			        	  $('#MyimgDiv').show();
			          }
			    }
			},
			cancelFunction: function(){
				$("#icon").val( "");
			} 
			
		});
	});
</script>
</head>
<body scroll="no" style="overflow: no" >
<form enctype="multipart/form-data" id="signetForm" name="signetForm" method="post" action="<html:link renderURL='/signet.do' />?method=${signetManagerMethod }" onsubmit="return submitCheck();" target="tempIframe">

 <input type="hidden" id="id" name="id" value="${signet.id}">
 <input type="hidden" id="markNameHidden" name="markNameHidden" value="${fn:escapeXml(signet.markName)}">
 <input type="hidden" id="iconId" name="iconId" value="">
 
 <c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
 <c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readOnly', '')}" />
 
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8">
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
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key="system.signet.title"/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="system.signet.title.must"/></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
		    <div class="categorySet-body" id="scrollListDiv" style="height:200px">
			<table width="45%" border="0" cellspacing="0" cellpadding="0" align="center">
				<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
				<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="name"> <font color="red">*</font><fmt:message key="signet.menu.signetname" />：</label></td>
					<td class="new-column" width="80%">
						<input name="markName" type="text" id="markName" class="input-100per" ${dis} value="${fn:escapeXml(signet.markName)}" inputName="<fmt:message key="signet.menu.signetname" />" maxSize="60" validate="notNull" />
					</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="post.code"> <font color="red">*</font><fmt:message key="signet.edit.userword" />：</label></td>
					<td class="new-column" width="80%">
						<input id="userword" class="input-100per" type="password" maxlength="16" maxSize="16" minLength="6" name="password" ${dis} id="password" value="${password}" ${dis} inputName="<fmt:message key="signet.edit.userword" />" validate="notNull,minLength,maxLength" />
					</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="post.code"> <font color="red">*</font> <fmt:message key="signet.edit.validateword" />：</label></td>
					<td class="new-column" width="80%">
						<input id="validateword" class="input-100per" ${dis} type="password"  maxlength="16" maxSize="16" minLength="6" name="validateword" id="validateword" value="${password}" ${ro} inputName="<fmt:message key="signet.edit.validateword" />" validate="notNull,minLength,maxLength" />
					</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="post.code"> <font color="red"></font> <fmt:message key="signet.menu.leveluser" />：</label></td>
					<td class="new-column" width="80%">
					 <v3x:selectPeople id="signetId" maxSize="1" panels="Department,Outworker" selectType="Member"
									 	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
									 	jsFunction="setRefUserId(elements)" originalElements="${authIds}" />
						<fmt:message key="signet.warrant.user" var="defName" /> 
						<input type="text" name="signetName" id="signetName" value="<c:out value="${v3x:showOrgEntitiesOfIds(signet.userName, 'Member', pageContext)}" escapeXml="true" default='${defName}' />"
							class="input-100per" ${dis} readonly onClick="selectPeopleFun_signetId()" inputName="<fmt:message key="signet.menu.leveluser" />"
							deaultValue="${defName}"> 
						<input id="signetauto" name="signetauto" type="hidden" value="${signetUserId }">
						</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="post.code"> <font color="red">*</font> <fmt:message key="signet.menu.type" />：</label></td>
					<td class="new-column" width="80%">
						<select id="signetSelect" name="signetSelect" class="input-100per" ${dis}>
							<c:choose>
								<c:when test="${signet.markType == 1}">
									<option value="1" selected><fmt:message key="signet.type.sig"/></option>
						    		<option value="0"><fmt:message key="signet.type.underwrite"/></option>	
								</c:when>
								<c:otherwise>
									 <option value="1"><fmt:message key="signet.type.sig"/></option>
							   		 <option value="0" selected><fmt:message key="signet.type.underwrite"/></option>
								</c:otherwise>
							</c:choose>		
					  	</select>
					</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="post.code"> <font color="red">*</font> <fmt:message key="signet.edit.signetfile" />：</label></td>
					<td class="new-column" width="80%" id="thePicture">
						<input contenteditable="false"  type="text"   id="icon" value="${signet.markPath}" name="icon" class="input-100per" ${dis} onChange="showimg(this.value)"> 
						<input type="hidden"   id="imgType" value="${signet.imgType}" name="imgType" >  
					</td>
					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="description-lable"><fmt:message key="signet.edit.limit" /></td>
				</tr>
				<c:if test="${showImg == 1 }">
					<tr>
						<td width="20%">&nbsp;</td>
						<td>
							<IMG id="Myimg" name="Myimg" inputName="<fmt:message key="signet.edit.signetfile" />" validate="notNull" src="<c:url value='/signet.do?method=signetPicture&id=${signet.id}' />" >   
						</td>
					</tr>
				</c:if> 
				<c:if test="${showImg == 0 }">
					<tr>
						<td width="20%">&nbsp;</td>
						<td>
						    <div id="MyimgDiv" style="display:none">
							  <IMG id="Myimg" name="Myimg" inputName="<fmt:message key="signet.edit.signetfile" />" validate="notNull">   
							</div>
						</td>
					</tr>
				</c:if> 
			</table>
			</div>
		</td>
	</tr>
	<c:if test="${!readOnly}">
		<tr>
			<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit"  id="submitButton"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
		    <input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2"></td>
		</tr>
	</c:if>
</table>
</form>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
<script type="text/javascript">
    bindOnresize('scrollListDiv',30,110);
    function IE8(){
    	var boolean = navigator.userAgent.split(";")[1].toLowerCase().indexOf("msie 8.0")=="-1"?false:true;
	    if(boolean){//判断IE8
	    	$("#scrollListDiv").css({"overflow-x":"visible","width":"100%"});
	    }
	}
	IE8();
</script>
</body>
</html>