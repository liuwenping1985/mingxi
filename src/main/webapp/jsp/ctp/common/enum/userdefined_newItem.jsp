<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
<style>
.input-100{
	width: 100%;
	BORDER-TOP:1 Solid #86AFC7;
   	BORDER-LEFT:1 Solid #86AFC7;
   	BORDER-RIGHT:1 Solid #86AFC7;
   	BORDER-BOTTOM:1 Solid #86AFC7;  
}
.button-style{
	width: 70px;
        border-right:#3A6080 1px solid;padding-right:2px;
        border-top:#3A6080 1px solid;padding-left:2px;
        font-size:12px;
        filter:
        progid:DXImageTransform.Microsoft.Gradient
        (GradientType=0,StartColorStr=#FFFEFC,
         EndColorStr=#E8E4DC);
        border-left:#3A6080 1px solid;
        cursor:hand;color:black;padding-top:2px;
        border-bottom:#3A6080 1px solid;
        height:20px;
}
.button-disabled{
        width: 70px;
        border-right:#cccccc 1px solid;padding-right:2px;
        border-top:#cccccc 1px solid;padding-left:2px;
        font-size:12px;
        filter:
        progid:DXImageTransform.Microsoft.Gradient
        (GradientType=0,StartColorStr=#FFFEFC,
         EndColorStr=#E8E4DC);
        border-left:#cccccc 1px solid;
        color:#cccccc;padding-top:2px;
        border-bottom:#cccccc 1px solid;  
        height:20px;
}
.scroll{
    border-bottom: solid 1px #BDBDBD;
}
</style>
<script type="text/javascript">
	function cancel(){
		parent.listFrame.location.reload();
	}
	
	function checkIsNameDuple(){

	var label = document.getElementById("label");
	var value = document.getElementById("value");
	var id = document.getElementById("id");

	try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkItemIsRef", false);
    	requestCaller.addParameter(1, "String", '${metadata.id}');
		requestCaller.addParameter(2, "String", '${metadataItem.id}');
    	var ds = requestCaller.serviceRequest();
		if(ds=="true" && (document.getElementById("id").value!="" && (document.getElementById("orgItemValue").value!=document.getElementById("value").value || document.getElementById("orgItemLabel").value!=document.getElementById("label").value))){
			alert("该枚举项已被引用,只能对序号和描述进行修改!");
			return false;
		}
    }catch(e){
    }
    
    		//新建时校验重复
			var labelObj = document.all.label;
			var existMetadataNames = parent.listFrame.existMetadataNamesArray;
			if(labelObj && existMetadataNames){
				for(var i = 0; i<existMetadataNames.length; i++){
					if(labelObj.value == existMetadataNames[i]){
						alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
						labelObj.focus();
						return false;
					}
				}
			}

		return true;
	}

//自动切换停用状态
	function changeStatus(){
		var inputSwitch = document.editForm.inputSwitch;
		var outputSwitch = document.editForm.outputSwitch;
		if(inputSwitch.options[inputSwitch.selectedIndex].value == "1"){
			outputSwitch.selectedIndex = "0";
			outputSwitch.disabled = true;
		}else{
			outputSwitch.disabled = false;
		}
	}

	 window.onload = function(){
		
			var m = document.getElementsByName("inputSwitch");
			for(var i=0;i<m.length;i++){
				if(m[i].value == 1 && m[i].checked == true){
					fixStatus();
				}
			}	
		
		/*
		var inputSwitch = document.editForm.inputSwitch;
		var outputSwitch = document.editForm.outputSwitch;
		if(inputSwitch.options[inputSwitch.selectedIndex].value == "1"){
			outputSwitch.selectedIndex = "0";
			outputSwitch.disabled = true;
		}else{
			outputSwitch.disabled = false;
		}
		*/
		/*
		try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkItemIsRef", false);
    	requestCaller.addParameter(1, "String", '${metadata.id}');
		requestCaller.addParameter(2, "String", '${metadataItem.id}');
    	var ds = requestCaller.serviceRequest();
		if(ds=="true"){
			inputSwitch.disabled = true;
			outputSwitch.disabled = true;
		}
		}catch(e){}
		*/
	}
	
		function fixStatus(){
		var o = document.getElementsByName("outputSwitch");
		for(var i=0;i<o.length;i++){
			if(o[i].value == 1){
				o[i].checked = true;
			}
			o[i].disabled = true;
		}
	}

	function unFixStatus(){
		var o = document.getElementsByName("outputSwitch");
		for(var i=0;i<o.length;i++){
			o[i].disabled = false;
		}
	}
	
</script>
</head>
<body style="margin: 0px; padding: 0px;">
<form name="editForm" method="post" action="${metadataMgrURL}" onsubmit="return (checkForm(this) && checkIsNameDuple())">
	<input type="hidden" name="method" value="addUdefinedItem">
	<input type="hidden" name="parentId" value="${parentId}">
	<input type="hidden" name="parentType" value="${parentType}">
	<table width="100%" height="100%" border=0 cellpadding=0  cellspacing=0 align="center">	
	<tr align="center">
		<td height="8" class="detail-top" colspan="2">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr valign="middle" align="center">
	   <td colspan="2">			
			<table  width="80%" height="60%" border="0" cellpadding="0"  cellspacing="0">
				<tr>
				  	<td align="right" width="30%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><label for="leader"><fmt:message key="metadata.manager.displayname"/></label>:</td>
					<td class="new-column" width="50%" nowrap="nowrap">
						<input type="text" name="label" id="lable" class="input-100" maxSize="85" maxlength="85" inputName="<fmt:message key='metadata.manager.displayname'/>" validate="notNull,maxLength,isWord"  character="\\/|><*?'&%$" />
				  	</td>
					<td  width="20%">&nbsp;</td>
				</tr>
				<%--
				<c:if test="${metadataItem.role == '0' || metadataItem.role == '2' }">
				--%>
				<tr>			
					<td class="bg-gray" width="30%" nowrap="nowrap" height="24"><font color="red">*</font><label for="members"><fmt:message key="metadata.manager.value"/></label>:</td>
					<td class="new-column" width="50%" nowrap="nowrap">					
						<input class="input-100" type="text"  name="value" value="${valueNumber}" maxlength="100" maxSize="100" integerDigits="100" inputName="<fmt:message key='metadata.manager.value'/>" validate="notNull,isNumber,maxLength,isInteger" /> 	
					</td>
					<td  width="20%">&nbsp;</td>
				</tr>
				<%--
				</c:if>
				<c:if test="${metadataItem.role == '1'}">
				<tr>
					<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="members"><fmt:message key="metadata.manager.value"/></label>:</td>
					<td class="new-column" width="75%" nowrap="nowrap">					
						<input class="input-100" type="text" name="metavalue" ${setIsEnable} id="metavalue" value="${metadataItem.value}" onkeyup="return keypressFilter()"/> 	
					</td>
				</tr>
				<tr>			
					<td class="bg-gray" width="25%" nowrap="nowrap" height="24"></td>
					<td class="new-column" width="75%" nowrap="nowrap">
					<label for="radio1">
						<input type="radio" id="radio1" name="timetype" value="min" ${timetype=='min'? 'checked':''} ${setIsEnable}><fmt:message key="metadata.manager.min"/>
					</label>
					<label for="radio2">
						<input type="radio" id="radio2" name="timetype" value="hour" ${timetype=='hour'? 'checked':''} ${setIsEnable}><fmt:message key="metadata.manager.hour"/>
					</label>
					<label for="radio3">
						<input type="radio" id="radio3" name="timetype" value="day" ${timetype=='day'? 'checked':''} ${setIsEnable}><fmt:message key="metadata.manager.day"/>
					</label>
					<label for="radio4">
						<input type="radio" id="radio4" name="timetype" value="week" ${timetype=='week'? 'checked':''} ${setIsEnable}><fmt:message key="metadata.manager.week"/>
					</label>
					<label for="radio5">
						<input type="radio" id="radio5" name="timetype" value="month" ${timetype=='month'? 'checked':''} ${setIsEnable}><fmt:message key="metadata.manager.month"/>
					</label>
					</td>
				</tr>
				</c:if>
				--%>
				<tr>
					<td class="bg-gray" width="30%" nowrap="nowrap" height="24"><font color="red">*</font><label for="memo"><fmt:message key="metadata.manager.sort"/></label>:</td>
					<td class="new-column" width="50%">
						<input class="input-100" type="text" value="${sortNumber}" name="sort" inputName="<fmt:message key='metadata.manager.sort'/>" validate="notNull,isNumber,isInteger" MAXLENGTH="8"/> 
					</td>
					<td  width="20%">&nbsp;</td>
				</tr>
				<!--
				<tr>
					<td class="bg-gray" width="30%" nowrap="nowrap" height="24" valign="top" class="lest-shadow"><label for="memo"><fmt:message key="metadata.manager.description"/></label>:</td>
					<td class="new-column" width="50%">
						<textarea class="input-100" name="description" id="description" rows="6" cols="" style="width: 100%"  inputName="<fmt:message key='metadata.manager.description' />" validate="maxLength" maxSize="200" ${setIsEnable}>${metadataItem.description}</textarea>
					</td>
					<td  width="20%">&nbsp;</td>
				</tr>
				-->
				<tr>
					<td class="bg-gray" width="30%" nowrap="nowrap" height="24" valign="middle" class="lest-shadow" align="right"><fmt:message key="metadata.button.inputSwitch" />:</td>
					<td class="new-column" width="50%">
						<table width="100%" height="100%" border="0"><tr>
						<td align="left">
						<label for="inputSwitch1">
						<input type="radio" name="inputSwitch" id="inputSwitch1" value="1" checked="checked" onclick="fixStatus();">
						<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
						</label>
						<label for="inputSwitch2">
						<input type="radio" name="inputSwitch" id="inputSwitch2" value="0" onclick="unFixStatus();">
						<fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/>						
						</label>
						</td>
						</tr>
						</table>
					</td>
					<td  width="20%">&nbsp;</td>
				</tr>
				<tr>
					<td class="bg-gray" width="30%" nowrap="nowrap" height="24" valign="middle" class="lest-shadow" align="right"><fmt:message key="metadata.button.outputSwitch" />:</td>
					<td class="new-column" width="50%">
						<table width="100%" height="100%" border="0"><tr>
						<td align="left">
						<label for="outputSwitch1">
						<input type="radio" name="outputSwitch" id="outputSwitch1" value="1" checked="checked">
						<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
						</label>
						<label for="outputSwitch2">						
						<input type="radio" name="outputSwitch" id="outputSwitch2" value="0">
						<fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/>						
						</label>
						</td>
						</tr>
						</table>
					</td>
					<td  width="20%">&nbsp;</td>
				</tr>				
			</table>
	    </td>
	</tr>
	<tr>
	<td class="bg-advance-bottom" width="20%">
	   <label for="checkbox" >
		<input id = "checkbox" type="checkbox" name="continue" value="true" checked="checked"/> <fmt:message key="continue.org" bundle='${organizations}'/> </label>
	</td>
		<td height="42" align="middle"  class="bg-advance-bottom">
		   
			<input class="button-style" type="submit"  value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">&nbsp;&nbsp;
			<input class="button-style" type="button" onclick="cancel()"  value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
<div class="hidden">
<iframe id="tempFrame" name="tempFrame">&bnsp;</iframe>
</div>
<script type="text/javascript">
 document.getElementById("lable").focus() ;
</script>

</body>