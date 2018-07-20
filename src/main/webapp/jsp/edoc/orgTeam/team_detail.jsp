<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head> 
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

	var flagUpd="${flag}";
	function setPeopleFields(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);
		document.getElementById("depart").value = getNamesString(elements);
		document.getElementById("grantedDepartId").value = getIdsString(elements,true);
		}
	}
	
	<%--
	function initiate(obj1,obj2){
		
		var ids = [];
		var temp = null;
		
		obj2 = obj2.split(",");
		for(var i=0;i<obj2.length;i++){
			temp = obj2[i].split("|");
			temp = temp[1];
			ids[i] = temp;
		}

		document.getElementById("grantedDepartId").value = ids;
		document.getElementById("originalDepartId").value = ids;

	}
	--%>
	
function attach(){
        
        var suffix;
        var fix = "";
        var temp = document.getElementById("templateFile");
        
        if(temp.value==""){//如果为空，attachment中没有附件
            insertAttachment(null, null, "attach_AttCallback1", "false");
        }else{//如果不为空，attachment中已经有值
            var att;
            insertAttachment(null, null, "attach_AttCallback2", "false");
        }
    }
    
    function attach_AttCallback1(){
        var suffix;
        var fix = "";
        var temp = document.getElementById("templateFile");
        
        var    at = fileUploadAttachments.values().get(0);//因为之前没有附件,当前附件如果存在只能有1个，也就是第一个
        if(at!=null){
                suffix = at.filename.split(".");
                fix = suffix[suffix.length-1];
                if(fix!="doc" && fix!="DOC" && fix!= "wps" && fix!= "WPS" && fix!= "docx" && fix!="DOCX"){
                    alert(_("edocLang.edocdocformtemplate_suffix"));
                    deleteAttachment(at.fileUrl,false);
                    return false;
                }//判断是否符合格式
                document.getElementById("templateFile").value = at.filename;
                    if(fix == "doc" || fix == "DOC" || fix == "docx" || fix == "DOCX"){document.getElementById("text_type").value = "officeword"}//正文类型是word
                    else if(fix == "wps" || fix == "WPS" ){document.getElementById("text_type").value = "wpsword"}//正文类型是wps
                    else{document.getElementById("text_type").value = "unknown"}//或者是0
        }
    }
    
    
    function attach_AttCallback2(){
        var att;
        if(!fileUploadAttachments.isEmpty()){
            att = fileUploadAttachments.values().get(1); //如果attachment中之前有值,再次上传后的附件应在第2为...get(1);
            if(att!=null){//判断新上传的附件是否为doc或wps格式
                    suffix = att.filename.split(".");
                    fix = suffix[suffix.length-1];
                    if(fix!="doc" && fix!="DOC" && fix!= "wps" && fix!= "WPS" && fix!= "docx" && fix!="DOCX"){
                        alert(_("edocLang.edocdocformtemplate_suffix"));
                        deleteAttachment(att.fileUrl,false);//如果不是，删除该附件
                        return false;
                    }else{//如果为wps或doc格式，删除原有的附件，并把附件名填上
                        var o_at = fileUploadAttachments.values().get(0);
                        deleteAttachment(o_at.fileUrl,false);
                        document.getElementById("templateFile").value = att.filename;
                        if(fix == "doc" || fix=="DOC" || fix == "docx" || fix=="DOCX"){document.getElementById("text_type").value = "officeword"}//正文类型是word
                        else if(fix == "wps"){document.getElementById("text_type").value = "wpsword"}//正文类型是wps
                        else{document.getElementById("text_type").value = "unknown"}//或者是0
                    }
            }       
        }
    }
	
	function submitTeam()
	{
	  var sortValue = $("#sortId").val();
	  var tt=/^\d+$/g;
	  if(!tt.test(sortValue)||sortValue.length>5){
		alert("请输入正确的排序号，且长度不超过5位");
		return; 
	  }
	  if(!checkForm(selectedForm)){return false;}
	  if(checkDoubleName()==false){return false;}
	  if($("#sortId").val()<0){
		  alert("请输入大于或等于0的排序号");
		  return;
	  }
	  selectedForm.submit();
	}
	
	function formSubmit(){
		var name = document.getElementById("name").value;
	    if(name==null || name==""){
	    	alert(_("edocLang.edoc_inputSubject"));
	    	return false;
	    }
	
		if(!checkForm(selectedForm))
			return false;
	  
	  /*
	    var ids = document.getElementById("grantedDepartId").value;
	    var originalIds = document.getElementById("originalDepartId").value;

		var temp;
		var subIds = "";
		
		ids = ids.split(",");
		originalIds = originalIds.split(",");
		for(var i=0;i<ids.length;i++){
			for(var j=0;j<originalIds.length;j++){
				if(ids[i]==originalIds[j]){
					break;
				}
			}if(j==originalIds.length){
				subIds += ids[i];
				subIds +=",";
			}
		}
		
		subIds = subIds.substring(0,subIds.length-1);
		
		document.getElementById("grantedDepartId").value = subIds;
		*/

		saveAttachment();
		
		window.document.selectedForm.submit();
	}
	function cancel(){
		parent.location.reload();
	}
	function initial(fileId,fileName,createDate){
			var str="<A HREF=\"/seeyon/fileUpload.do?method=download&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURI(fileName)+"\" target=\"temp_iframe\" \><fmt:message key="edoc.form.downloadform" /></A>";
			var obj = document.getElementById("download");
			if(obj!=null){
			obj.innerHTML = str; 
    	}
	}
	
	function setEditState()
	{
	  if(flagUpd!="readonly"){return;}
	  selectedForm.name.disabled=true;
	  selectedForm.grantedDepartId.disabled=true;
	}
	
	//alert('flag:${param.flag}')
	
	showAccountShortname_grantedDepartId = "auto";
	
	function checkDoubleName()
	{
	  try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocObjTeamManager", "ajaxGetByName", false);
    	requestCaller.addParameter(1, "String", selectedForm.name.value);
    	requestCaller.addParameter(2, "String", selectedForm.accountId.value);
    	var ds = requestCaller.serviceRequest();
    	if(ds == "-1" || ds==selectedForm.id.value){return true;}
    	else
    	{
    		alert(v3x.getMessage("edocLang.edoc_name_duplicated"));
    		return false;
	    }
    }catch(e){
    }
	  return false;
	}

	$(function(){
		$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		$(window).resize(function() {
			$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		})
	});
isCanSelectGroupAccount_grantedDepartId=true;	
isAllowContainsChildDept_grantedDepartId=true;
</script>
</head>
<body onload="setEditState()" class="over_hidden">

<c:set value="${productEdition eq 'GROUP'?'edoc.objTeam.include.label':'edoc.objTeam.include.dep.label'}" var="includeLabel" />
	
<form action="${edocObjTeamUrl}?method=save" method="post" target="_self" name="selectedForm" id="selectedForm">
<input type="hidden" name="method" id="method" value="change" />
<input type="hidden" name="id" id="id" value="${team.id}" />
<input type="hidden" name="accountId" value="${accountId}" />
<c:set value="${v3x:showOrgEntitiesOfTypeAndId(team.selObjsStr, pageContext)}" var="authStr"/>
<c:set value="${v3x:parseElements(team.edocObjTeamMembers, 'memberId', 'teamType')}" var="authIds"/>
<v3x:selectPeople id="grantedDepartId" panels="Department,Account" selectType="Account,Department" jsFunction="setPeopleFields(elements)" originalElements="${authIds}" />
<script>
hiddenRootAccount_grantedDepartId=true;
isCheckInclusionRelations_grantedDepartId=false;
isNeedCheckLevelScope_grantedDepartId=false;
</script>

<div class="newDiv">

<table width="100%" height="100%" border="0" bordercolor="red" cellspacing="0" cellpadding="0" align="center" class="categorySet-bg">
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
				<td class="categorySet-title" width="120" nowrap="nowrap"><fmt:message key='edoc.addOgrTeam.label'/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>

<tr valign="middle">
	<td width="100%" valign="middle" id="categorySetTd" class="categorySet-head">  
  		<div id="categorySetBody" class="categorySet-body" style="padding:0;border-bottom:1px solid #a0a0a0;">	   
 			<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td width="15%" class="label" align="right"><font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:</td>	
	 				<td class="new-column" nowrap="nowrap">	
						<input name="name" type="text" id="name" style="width:100%;height:22px;margin-top:10px;" deaultValue="${team.name}"
							  value="<c:out value="${team.name}" escapeXml="true" default='${team.name}' />"   maxSize="85" 
						     validate="notNull,maxLength,isWord" character="&quot;\\/|&gt;&lt;:*?'&%$@#^-=+!~" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}"	 />"	     
						     />
					</td>	
				</tr>
		
	 			<tr>
	 				<td class="label" align="right" valign="top"><font color="red">*</font><fmt:message key="${includeLabel}" />:</td>
					<c:set value="" var="classMerc" />
					<c:if test="${flag != 'readonly'}" >
						<c:set value="cursor-hand" var="classMerc" />
					</c:if>			
	 				<td class="new-column" nowrap="nowrap">					
						<textarea id="depart" name="depart" value="" class="${classMerc}"  rows="4"
							validate="notNull"
							readonly = "true" style="width:100%;margin-top:5px;" 
							<c:if test="${flag == 'readonly'}" >${v3x:outConditionExpression(true, 'readOnly', '')}
							</c:if>
							<c:if test="${flag != 'readonly'}" >
								onclick ="selectPeopleFun_grantedDepartId();"
							</c:if>				
	 				 		inputName="<fmt:message key="edoc.objTeam.include.label" />"	 		
						>${authStr}</textarea>		
						<div type="hidden"><input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${authIds}" /></div>	
					</td>
				</tr>
				<tr>
				 <td class="label" align="right"><font color="red">*</font><fmt:message key='common.sort.label' bundle="${v3xCommonI18N}" /></font>:</td>		
				 <td class="new-column" nowrap="nowrap">
					<input name="sortId" type="text" id="sortId" style="width:100%;height:22px;margin-top:10px;" deaultValue="${team.sortId}" value="${team.sortId}"	validate="notNull,isInteger"" inputName="<fmt:message key='common.sort.label' bundle="${v3xCommonI18N}" />" />
				 </td>	
			    </tr>
				
	 			<tr>
	 				<td class="label" align="right"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:</td>		
					<td class="new-column" nowrap="nowrap">
		 				<textarea id="description" name="description" value="" class=""  rows="4"
						     style="width:100%;margin-top:5px;" 
						     <c:if test="${flag == 'readonly'}" >${v3x:outConditionExpression(true, 'readOnly', '')}</c:if>
						 	 validate="maxLength" 	maxSize="256"
						 	 inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />"
						>${team.description}</textarea>
					</td>	
				</tr>
  			</table>	
 		</div>
	</td>
</tr>

<c:if test="${flag!='readonly'}">
<tr>
	<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="submitTeam();">
		&nbsp; 
		<input type="button" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
	</td>
</tr>
</c:if>

</table>

</div>

</form>
</body>
