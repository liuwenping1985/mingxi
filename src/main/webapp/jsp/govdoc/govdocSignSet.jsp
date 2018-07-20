<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>全文签批单设置</title>
    <%@ include file="/WEB-INF/jsp/edoc/edocHeader.jsp" %>
    <script type="text/javascript">
    	var fileType="${fileType}";
    	function _init(){
    		var doubleForm = "${isDoubleForm}";
    		if(doubleForm=='false'){
				document.getElementById("isDoubleForm2").checked="checked";
    		}
    	}
	    function OK(){
	    	var obj = {};
	    	obj["att_fileUrl"] =$("#att_fileUrl").val();
	    	obj["att_filename"] =$("#att_filename").val();
	    	obj["att_size"] =$("#att_size").val();
	    	var radios = document.getElementsByName("isDoubleForm");
	    	for(var i =0;i<radios.length;i++){
	    		if(radios[i].checked){
	    			obj["isDoubleForm"] =radios[i].value;
	    		}
	    	}
	    	return obj;
	    }
	    function newcategoryFileType(){
	    	if(fileType=='pdf'){
	    		fileType="html";
	    	}
			insertAttachmentByType(null, null, "newcategory_Callback", "false",fileType);
		}
		function insertAttachmentByType(){
			
			var url = downloadURL + "&quantity=" + fileUploadQuantity;
			if(arguments && arguments[0]){
				url += "&selectRepeatSkipOrCover=" + arguments[0];
				if(arguments[1]){
					url += arguments[1];
				}
			}
			if(arguments && arguments[2]){
				url +="&callMethod="+ arguments[2];
			}
			
			if(arguments && arguments[3]){
				url +="&takeOver="+ arguments[3];
			}
			if(arguments && arguments[4]){//如果有数据  赋值到extensions
				var hou = url.substring(url.indexOf("extensions"),url.length);
				var hou1  = hou.substring(hou.indexOf("&"),hou.length);
				var qian = url.substring(0,url.indexOf("extensions"));
				var zhi = "extensions="+arguments[4];
				url = qian + zhi +hou1;
				
			}
			
			getA8Top().addattachDialog =null;
			
			if(getA8Top().isCtpTop || getA8Top()._ctxPath){
				getA8Top().addattachDialog = getA8Top().$.dialog({
				title: v3x.getMessage("V3XLang.attachent_title"),
				transParams:{'parentWin':window},
				url     : url,
				width   : 400,
				height  : 300,
				resizable   : "yes"
				});
				
			}else{
				getA8Top().addattachDialog = getA8Top().v3x.openDialog({
				title: v3x.getMessage("V3XLang.attachent_title"),
				transParams:{'parentWin':window},
							url     : url,
				width   : 400,
				height  : 300,
				resizable   : "yes"
			});
			}
			resizeFckeditor();
		}
		//上传文件回调
		function newcategory_Callback(){
	        var atts = fileUploadAttachments.values();
	        if(atts == "")
	        return false;
	        saveAttachment();
	        var form=document.getElementById("govdocSignSetFrom");
	        for(var i = 0; i< atts.size(); i++){
	            var att = atts.get(i);
	            document.getElementById("att_fileUrl").value = att.fileUrl;
	            document.getElementById("att_createDate").value = att.createDate;
	            document.getElementById("att_mimeType").value = att.mimeType;
	            document.getElementById("att_filename").value = att.filename;
	            document.getElementById("signForm").value = att.filename;
	            document.getElementById("att_needClone").value = att.needClone;
	            document.getElementById("att_description").value = att.description;
	            document.getElementById("att_type").value = att.type;
	            document.getElementById("att_size").value = att.size;
	            
	            var field0 = document.createElement('INPUT');
	            field0.setAttribute('type','hidden');
	            field0.setAttribute('name','fileUrl');
	            field0.setAttribute('value',att.fileUrl);
	            var field1 = document.createElement('INPUT');
	            field1.setAttribute('type','hidden');
	            field1.setAttribute('name','fileCreateDate');
	            field1.setAttribute('value',att.createDate);
	            var field2 = document.createElement('INPUT');
	            field2.setAttribute('type','hidden');
	            field2.setAttribute('name','fileMimeType');
	            field2.setAttribute('value',att.mimeType);
	            var field3 = document.createElement('INPUT');
	            field3.setAttribute('type','hidden');
	            field3.setAttribute('name','filename');
	            field3.setAttribute('value',att.filename);
				
	            form.appendChild(field0);
	            form.appendChild(field1);
	            form.appendChild(field2);
	            form.appendChild(field3);
	        //--
	        //不清楚这个变量做什么用，暂时保留 yuhj 2010.4.29
	        document.getElementById("file_name").value = att.filename;
	        
	        /*var file_n = att.filename;
	        var suffix = file_n.substring(file_n.indexOf(".")+1,file_n.length);*/
	        
	        /*
	        if(suffix!="xsn"){
	            alert(_("edocLang.edoc_alertMustBeXsnFormat"));
	            window.location.reload();
	            return false;
	        }*/
	        
	        
	        //--
	        }
	        form.target="detailFrame";
	        form.action = "${edocForm}?method=uploadForm";
	        //form.submit();
	    }
    </script>
</head>
<body onload="_init()">
	<iframe style="display:none" id="govdocSignSetFrame"></iframe>
	<form id="govdocSignSetFrom" name="govdocSignSetFrom" method="post" target="govdocSignSetFrame">
		<input type="hidden" id="attachmentStr" name="attachmentStr" value="">
		<input type="hidden" name="att_fileUrl" id="att_fileUrl" value="${att_fileUrl}">
		<input type="hidden" name="att_createDate" id="att_createDate" value="${att_createDate}">
		<input type="hidden" name="att_mimeType" id="att_mimeType" value="${att_mimeType}">
		<input type="hidden" name="att_filename" id="att_filename" value="${att_filename}">
		<input type="hidden" name="att_needClone" id="att_needClone" value="${att_needClone}">
		<input type="hidden" name="att_description" id="att_description" value="${att_description}">
		<input type="hidden" name="att_type" id="att_type" value="${att_type}">
		<input type="hidden" name="att_size" id="att_size" value="${att_size}">
		<input type="hidden" name="file_name" id="file_name" value="">
		<div class="hidden"><v3x:fileUpload attachments="${attachments}"  canDeleteOriginalAtts="true" extensions="xsn"  encrypt="false" popupTitleKey="${popTitle}" />
			<script>
				var fileUploadQuantity = 1;
			</script>
		</div>
		<div style="padding:50px 70px 25px 100px;">
		上传全文签批单：<input id="signForm" type="text" readonly="readonly" onclick = "newcategoryFileType()"/><br/>
		是否启用双文单：<input type="radio" id="isDoubleForm1" value="1" name="isDoubleForm" checked="checked"/>是
		<input type="radio" id="isDoubleForm2" name = "isDoubleForm" value="0"/>否
		</div>
	</form>
	<script type="text/javascript">
		var AIP = '${AIP}';
		if(AIP == "true"){
			var path = "${path}";
			var v = "${v}";
			var fileId = "${fileId}";
			var createDate = "${createDate}";
			var filename = "${filename}";
			var str="<div style=\"padding-left:100px;\"><A style=\"\" HREF=\"${path}/fileDownload.do?method=download&v=${ctp:digest_1(fileId)}&isSystemForm=false&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURI(filename)+"\" target=\"temp_iframe\" \>下载全文签批单</A></div>";
			document.write(str);
		}
	</script>
	<div class="hidden">
		<iframe id="temp_iframe" name="temp_iframe">&nbsp;</iframe>
	</div>
</body>
</html>
