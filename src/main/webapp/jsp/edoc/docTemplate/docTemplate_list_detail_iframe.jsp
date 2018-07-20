<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<html>
<head> 
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
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
			insertAttachment(null, null, "insertAtt_AttCallback_new", "false");
		}else{//如果不为空，attachment中已经有值
		    var att;
		    insertAttachment(null, null, "insertAtt_AttCallback_edit", "false");
		}
	}
	
	/**
	 *上传文档时进行回调
	 */
	function insertAtt_AttCallback_new(){
	    
	    var temp = document.getElementById("templateFile");
	    var suffix;
        var fix = "";
        
	    if(temp.value==""){
	        
	        var    at = fileUploadAttachments.values().get(0);//因为之前没有附件,当前附件如果存在只能有1个，也就是第一个
	        if(at!=null){
                suffix = at.filename.split(".");
                fix = suffix[suffix.length-1];
                if(fix!="doc" && fix!="DOC" && fix!= "wps" && fix!= "WPS" && fix!= "docx" && fix!="DOCX"){
                	setTimeout(dealWrongType,100);
                    function dealWrongType(){
                    	alert(_("edocLang.edocdocformtemplate_suffix"));
                    }
                    deleteAttachment(at.fileUrl,false);
                    return false;
                }//判断是否符合格式
                document.getElementById("templateFile").value = at.filename;
                if(fix == "doc" || fix == "DOC" || fix == "docx" || fix == "DOCX"){//正文类型是word
                    document.getElementById("text_type").value = "officeword"
                } else if(fix == "wps" || fix == "WPS" ){//正文类型是wps
                    document.getElementById("text_type").value = "wpsword"
                } else{//或者是0
                    document.getElementById("text_type").value = "unknown"
                }
	        }
	    }
	}
	
	/**
     *上传文档时进行回调
     */
    function insertAtt_AttCallback_edit(){
        var temp = document.getElementById("templateFile");
        var suffix;
        var fix = "";
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
                        if(fix == "doc" || fix=="DOC" || fix == "docx" || fix=="DOCX"){//正文类型是word
                            document.getElementById("text_type").value = "officeword"
                        } else if(fix == "wps"){//正文类型是wps
                            document.getElementById("text_type").value = "wpsword"
                        } else{//或者是0
                            document.getElementById("text_type").value = "unknown"
                        }
                    }
            }       
        }
    }
	
	function formSubmit(){
		//var name = document.getElementById("name").value;
	    //if(name==null || name==""){
	    //	alert(_("edocLang.edoc_inputSubject"));
	    //	return false;
	    //}
	
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
			//lijl注销,OA-42477.开发---server安全
			var str="<A HREF=\"/seeyon/fileDownload.do?method=download&v=${fileId==null?'':(ctp:digest_1(fileId))}&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURI(fileName)+"\" target=\"temp_iframe\" \><fmt:message key="edoc.form.downloadform" /></A>";
			var obj = document.getElementById("download");
			if(obj!=null){
			obj.innerHTML = str; 
    	}
	}

	showAccountShortname_grantedDepartId = "auto";

	$(function(){
		initial("${fileId}","${v3x:escapeJavascript(fileName)}","${createDate}");
	});
</script>
<style>
	.new-column {
		height: 26px;
		margin-top: 10px;
	}
</style>
</head>

<body>

<c:set value="${v3x:showOrgEntities(elements, 'depId', 'depType', pageContext)}" var="authStr"/>
<c:set value="${v3x:parseElements(elements, 'depId', 'depType')}" var="authIds"/>
<v3x:selectPeople id="grantedDepartId" panels="Department" selectType="Account,Department" jsFunction="setPeopleFields(elements)" originalElements="${authIds}" minSize="0"/>

<form action="${edocTemplate}?method=${operType}" method="post" target="temp_iframe" name="selectedForm" id="selectedForm">
<input type="hidden" name="method" id="method" value="change" />
<input type="hidden" name="id" id="id" value="${bean.id}" />
<input type="hidden" id="appName" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">
<input type="hidden" id="text_type" name="text_type" value="${bean.textType}">

<v3x:attachmentDefine attachments="${attachments}" />

<c:choose>
	<c:when test="${type == 0}">
			<c:set value="edoc.doctemplate.text" var="msgType" />
			<c:set value="fileupload.edoctemplate.text" var="popTitle" />
	</c:when>
	<c:when test="${type == 1}">
			<c:set value="edoc.doctemplate.wendan" var="msgType" />	
			<c:set value="fileupload.edoctemplate.script" var="popTitle" />
	</c:when>
</c:choose>

<table width="95%" height="80%" border="0" bordercolor="red" cellspacing="0" cellpadding="0" align="center">
<tr valign="middle">
	<td width="20%" valign="middle">
		<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr height="25">
 				<td  class="label" align="right"><fmt:message key="edoc.doctemplate.type" />&nbsp;:&nbsp;</td>	
 				<td align="left">	
					<input type="hidden" id="type" name="type" value="${type}">
					<input type="text" style="width:100%;height:22px;" id="sort" name="sort" value="<fmt:message key='${msgType}' />" readonly disabled>
				</td>
				<td width="30">
					<c:if test="${operType!='add'}">
						<div id="download" name="download">
							<A HREF="/seeyon/fileDownload.do?method=download&v=${fileId==null?'':(ctp:digest_1(fileId))}&fileId=${fileId }&createDate=${createDate }&filename=${v3x:escapeJavascript(fileName)} " target="temp_iframe" ><fmt:message key="edoc.form.downloadform" /></A>
						</div>
					</c:if>
				</td>	
			</tr>
			<tr height="25">
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.doctemplate.name" />&nbsp;:&nbsp;</td>	
 				<td>	
 					<input name="name"  type="text" id="name" style="width:100%;height:22px;" deaultValue="${v3x:toHTML(bean.name)}"						
					    value="${v3x:toHTML(bean.name)}"
					    maxSize="25" inputName="<fmt:message key='edoc.doctemplate.name' />"
					    <c:if test="${param.flag == 'readonly'}"> readonly</c:if>
					    validate="notNull,maxLength" />
				</td>	
			</tr>
			<tr height="25">
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.doctemplate.template" />&nbsp;:&nbsp;</td>
				<td id="template">
					<table border="0" width="100%" align="left" height="19">
						<tr height="25">
							<td align="left">					
							<input name="templateFile" type="text" style="width:100%;height:22px;" id="templateFile" 
								inputName="<fmt:message key="edoc.doctemplate.template" />" 
								deaultValue="" validate="isDeaultValue,notNull" readonly = "true" 					
								value="${fileName}" escapeXml="true" 		
								/>
							</td>
							<td class="right" width="70" align="right">
								<input type="button" onclick="attach();" style="width:100%;height:22px;"
								 value="<fmt:message key='edoc.doctemplate.choosefile' />"
									<c:if test="${param.flag == 'readonly'}"> 
						 				disabled
						 			</c:if>
								>
							</td>
						</tr>
					</table>	
					<div class="hidden">
						<v3x:fileUpload attachments="${attachments}"  encrypt="false"  popupTitleKey="${popTitle}" />
					</div>	
					<script>
						var fileUploadQuantity = 1;
					</script>
				</td>	
			</tr>
 			<tr height="25">
 				<td class="label" align="right" valign="top"><font color="red"></font><fmt:message key="edoc.doctemplate.grant" />&nbsp;:&nbsp;</td>
 				<td>
<!-- Edit By Lif Start --> 				
					<textarea id="depart" name="depart" value="" <c:if test="${param.flag != 'readonly'}">class="cursor-hand"</c:if>  rows="4"
					inputName="<fmt:message key="edoc.doctemplate.grant" />" validate=""
					readonly = "true" style="width:100%;height:22px;"
	 				<c:if test="${param.flag != 'readonly'}">
					 onclick ="selectPeopleFun_grantedDepartId();"
					 </c:if>				
					>${authStr}</textarea>
<!-- Edit End -->				
					<div type="hidden">
						<input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${grantedDepartId==null?authIds:grantedDepartId}" />
					</div>	
				</td>
			</tr>
 			<tr>
 				<td class="label" align="right"><fmt:message key="edoc.element.elementStatus" />&nbsp;:&nbsp;</td>		
				<td>
	 				<c:choose>
		 				<c:when test="${bean.status == 1 || operType == 'add'}">
			 				<label for="status1">
			 					<input class="margin_l_5" type="radio" id="status1" name="status" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
			 				</label>
		 					<label for="status2">
			 					<input type="radio" id="status2" name="status" value="0" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>  /> <fmt:message key="edoc.element.disabled" />
			 				</label>
						</c:when>
						<c:otherwise>
							<label for="status1">
								<input type="radio" id="status1" name="status" value="1"  <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
							</label>
							<label for="status2">
			 					<input type="radio" id="status2" name="status" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
			 				</label>
						</c:otherwise>
					</c:choose>
				</td>	
			</tr>
  		</table>
	</td>
 </tr>
</table>
</form>

<iframe class="hidden" id="temp_iframe" name="temp_iframe" height="0" width="0" border="0">
</iframe>

</body>