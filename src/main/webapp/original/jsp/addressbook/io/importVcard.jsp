
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<title>VCARD导入</title>
<script type="text/javascript">
	var accountflag=0;
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.close();			
		}
		if(event.keyCode==13){

		}
	}
	
	//function isExcel(filePostfix
	function submitform(){

		var form = document.all("uploadFormOrgImp");

			var memberId = '';
			if(${param.memberId} && ${param.memberId} != '' && ${param.memberId}!= null ){
				memberId = '${param.memberId}';
				if(!window.confirm('是否要对选中人员进行VCARD覆盖?')){
					memberId = '';
					return;
				}
			}

    		
			saveAttachment();
		    
			form.target='detailFrame';
			form.action= "${urlAddressBook}?method=doVcardImoprt&memberId="+memberId+"&categoryId=${param.categoryId}";
	        document.getElementById("submintCancel").disabled = true;
			form.submit();
			window.returnValue = 'OK';
            window.close();
	}
	
	function attach(){
		
		var suffix;
		var fix = "";
		var temp = document.getElementById("templateFile");
		
		if(temp.value==""){//如果为空，attachment中没有附件
			insertAttachment();
			var	at = fileUploadAttachments.values().get(0);//因为之前没有附件,当前附件如果存在只能有1个，也就是第一个
			if(at!=null){
					suffix = at.filename.split(".");
					fix = suffix[suffix.length-1];
					if(fix!="vcf" && fix!="VCF"){
						alert("请选择VCARD文件");
						deleteAttachment(at.fileUrl,false);
						return false;
					}//判断是否符合格式
			document.getElementById("templateFile").value = at.filename;		
			}	
		}else{//如果不为空，attachment中已经有值
		var att;
		insertAttachment();
		if(!fileUploadAttachments.isEmpty()){
			att = fileUploadAttachments.values().get(1); //如果attachment中之前有值,再次上传后的附件应在第2为...get(1);
			if(att!=null){//判断新上传的附件是否为doc或wps格式
					suffix = att.filename.split(".");
					fix = suffix[suffix.length-1];
					if(fix!="vcf" && fix!="VCF"){
						alert("请选择VCARD文件");
						deleteAttachment(att.fileUrl,false);//如果不是，删除该附件
						return false;
					}else{//如果为wps或doc格式，删除原有的附件，并把附件名填上
						var o_at = fileUploadAttachments.values().get(0);
						deleteAttachment(o_at.fileUrl,false);
						document.getElementById("templateFile").value = att.filename;
			}		
		}
		}
	}
	}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyPress()">
<form enctype="multipart/form-data" name="uploadFormOrgImp" method="post"	>
<v3x:attachmentDefine attachments="${attachments}" />
<div class="hidden"><v3x:fileUpload    attachments="${attachments}"  encrypt="false" /></div>	
<script>
var fileUploadQuantity = 1;
</script>
  <table width="100%" height="100%" align="center"  border="0"><tr><td>
	
	<table width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" name="impURL">
		<tr>
		<td id="upload1" class="bg-advance-middel"><div style="width:50%">
			<input name="templateFile" type="text" class="cursor-hand" id="templateFile"  
					style="width:100%" deaultValue="" validate="isDeaultValue,notNull" readonly = "true" 					
					value="" escapeXml="true" 
					onclick="attach();";
		/></div><div style="width:50%"><fmt:message key='import.choose.file.vcard'  /></div>
		</td>
			<%-- <INPUT type="file" name="file1" id="file1" style="width: 100%"></td>--%>
		</tr>
		<%-- 
		<tr class="bg-imges2">
			<td  class="bg-imges2" height="30" align="left" style="padding-left: 15px" colspan="3">
				<fmt:message key="import.option" bundle="${orgI18N}" />:&nbsp;
				<label for="overleap">
					<input type="radio" name="repeat" value="1" checked="checked" id="overleap">
					<fmt:message key="import.repeatitem.overleap" bundle="${orgI18N}" />
				</label>
				<label for="overcast">
					<input type="radio" name="repeat" value="0" id="overcast">
					<fmt:message key="import.repeatitem.overcast"  bundle="${orgI18N}"  />&nbsp;&nbsp;
				</label>
			</td>
		</tr>
		--%>								
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" name="b1" onclick="submitform()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input id="submintCancel" type="button" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' 
				                                    bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
			</td>
		</tr>	
	</table></form>
	<!--</iframe>-->
	<iframe id="detailFrame" name="detailFrame">&nbsp;</iframe>
</body>
</html>