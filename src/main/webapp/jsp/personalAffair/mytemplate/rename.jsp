<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html style="overflow:hidden">
<head>
<title></title>
<script>
_ = v3x.getMessage;//1111111111111
function submit_name(type,id){
  var isCheck = checkForm(document.forms[0]);
  if(isCheck==true){

      var newName=document.getElementById("newName").value;
	  var xmlManager = ""; 
	  if(type && type == 'meeting'){
		 xmlManager = "ajaxMtTemplateManager";
		 xmlFunction =  "isMeetTempUnique";
	  }else if(type && type == 'inquiry'){
		 xmlManager = "ajaxInquiryManager";
		 xmlFunction =  "isInquiryUnique";
		//branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询start
	  }else if(type && type == 'col' || type=='edoc' || type=='info'){
		//branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询end
		 xmlManager = "ajaxTempleteManager";
		 xmlFunction =  "isTempleteUnique";
	  }
  
			var requestCaller = new XMLHttpRequestCaller(this, xmlManager, xmlFunction, false);
			requestCaller.addParameter(1, "String", newName.trim());
			requestCaller.addParameter(2, "Long", id);
			var ds = requestCaller.serviceRequest();
			if(ds=='false'){
				alert(v3x.getMessage("MainLang.mytemplate_has_exist"));
				return;
				}
		    transParams.parentWin.reNameCollBack(newName.trim());
  }
}
function OK(){
	  var type = '${param.type}';
	  var id = '${param.id}';
	  var isCheck = checkForm(document.forms[0]);
	  if(isCheck==true){

	      var newName=document.getElementById("newName").value;
		  var xmlManager = ""; 
		  if(type && type == 'meeting'){
			 xmlManager = "ajaxMtTemplateManager";
			 xmlFunction =  "isMeetTempUnique";
		  }else if(type && type == 'inquiry'){
			 xmlManager = "ajaxInquiryManager";
			 xmlFunction =  "isInquiryUnique";
			//branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询start
		  }else if(type && type == 'col' || type=='edoc' || type=='info'){
			//branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询end
			 xmlManager = "ajaxTempleteManager";
			 xmlFunction =  "isTempleteUnique";
		  }
	  
				var requestCaller = new XMLHttpRequestCaller(this, xmlManager, xmlFunction, false);
				requestCaller.addParameter(1, "String", newName.trim());
				requestCaller.addParameter(2, "Long", id);
				var ds = requestCaller.serviceRequest();
				if(ds=='false'){
					alert(v3x.getMessage("MainLang.mytemplate_has_exist"));
					return;
					}

			return newName.trim();		
	      //window.returnValue=encodeURI(newName.trim());    
	      // window.close();
	  }
}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" style="overflow:hidden" onkeydown="listenerKeyESC()">
<form name="mainForm" id="mainForm" onsubmit="return false">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key='mytemplate.rename.label'/></td>
		</tr>
		<tr>
			<td class="bg-advance-middel">
				<div>
					<fmt:message key='mytemplate.rename.new'/>:
				</div>
				<input type="text" maxSize="50" id="newName"  name="newName" value = ""
				 inputName="<fmt:message key='mytemplate.rename.new'/>" 
				 validate="notNull,maxLength,notSpecChar" style="width:100%" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input name='b1' type="button" onclick="submit_name('${param.type}','${param.id}')" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default-2">&nbsp;
				<input name='b2' type="button" onclick="getA8Top().myTempReNameWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>	
	</table>
	<TABLE cellSpacing=0 cellPadding=0 align=center>
		<TBODY>
			<tr>
				<td height="100"></td>
			</tr>
		</TBODY>
	</TABLE>
</form>
</body>
</html>