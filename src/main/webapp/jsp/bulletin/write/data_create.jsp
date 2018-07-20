<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp" %>
<html style="overflow:hidden;height: 100% ">
<head>
<%@ include file="../../common/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<c:if test="${param.method=='create' }">
<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.7.label' bundle="${v3xCommonI18N}" />
</c:if>
<c:if test="${param.method=='edit' }">
<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.7.label' bundle="${v3xCommonI18N}" />
</c:if>
</title>
	<%@ include file="../include/header.jsp" %>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
<script type="text/javascript">
<!--	
var includeElements_scope="";
var elements_scope="";
	function openAjax(typeId){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "getBulData", false);
		requestCaller.addParameter(1, "String", typeId);
		var ds = requestCaller.serviceRequest();
		if(ds){
			var aMessage = ds.split(';');
			document.getElementById('typeId').value=aMessage[0];
			document.getElementById('typeName').value=aMessage[1];
			document.getElementById('publishDepartmentId').value=aMessage[0];
			document.getElementById('publishDepartmentName').value=aMessage[11];
			document.getElementById('publishScope').value=aMessage[8];
			document.getElementById('publishScopeNames').value=aMessage[9];
			if('${spaceType}' == '1' && aMessage[0] != undefined && aMessage[8] != undefined ){
				includeElements_scope =aMessage[8].indexOf(aMessage[0])!=-1 ? aMessage[8] : "nil" ;
				elements_scope="";
			}else{
				includeElements_scope="";
				elements_scope="";
			}
		}
	}
	
	var bulStyleMap = new Properties();
	function syncBulStyleValue(typeId) {
		document.getElementById("ext1").value = bulStyleMap.get(typeId);
		var requestCaller = new XMLHttpRequestCaller(this, "outerspaceSectionConfigManager", "findSectionNameByBusiness", false);
		requestCaller.addParameter(1, "Long", typeId);
		requestCaller.addParameter(2, "String", "7");
		var ds = requestCaller.serviceRequest();
		if(ds.indexOf(":") > 0){
			
			var dses = ds.split(":");
			document.getElementById("outerSpaceId").value=dses[0];
			document.getElementById("outerSpace").value=dses[1];
			document.getElementById('space').style.display = "inline";
				
		}else{
			document.getElementById('space').style.display = "none";
			document.getElementById('space').style.display = "none";
		}
	}
	
	function myCheckForm(form){		
		if(form.typeId.value==null || form.typeId.value==""){
			alert("<fmt:message key="error.type.notblank" />");
			return false;
		}
		return checkForm(form);
	}
	
	function setTemplateByType(){
		$('templateId').value=hash[$F('typeId')];
	}	
	function loadBulTemplate(){
          	//去掉离开提示
          	window.onbeforeunload = function(){
              	    try {
              	        removeCtpWindow(null,2);
              	    } catch (e) {
              	    }
          	}
			//对Office的处理
			if(confirm('<fmt:message key="info.confirm.load.template" />')){
				$('form_oper').value="loadTemplate";
				$('method').value="create";
				isFormSumit = true;
				
				var ops = $('templateId').options;
				for(var i = 0; i < ops.length; i++){
					if(ops[i].selected){
						document.getElementById('tempIndex').value = i;
						break;	
					}		
				}
				saveAttachment();
				$('dataForm').submit();
			}else{
				var ops = $('templateId').options;
				if('${param.tempIndex}' == null || '${param.tempIndex}' == '') {
					ops[0].selected = true;
				}else{
					ops['${param.tempIndex}'].selected = true;
				}
			}
		
	}

	function quoteDocuments(){
        var atts = v3x.openWindow({
           url: "bulData.do?method=list4QuoteFrame",
           height: 600,
           width: 800
         });
        activeOcx();
      if (atts) {
		   deleteAllAttachment(2);
              for (var i = 0; i < atts.length; i++) {
                var att = atts[i];
                       addAttachment(att.type, att.filename, att.mimeType, att.createDate, att.size, att.fileUrl, true, false, att.description, null,  att.mimeType + ".gif");					   
                 }
        }  
     }   
	
	function loadTemplateContent(){
		var oEditor = FCKeditorAPI.GetInstance('content') ;
		//oEditor.SetHTML(window.frames['templateIframe'].document.getElementById('contentText').innerHTML);
		oEditor.SetHTML(content);
	}
	
	
		function chanageBodyTypeExt(type){
			if(chanageBodyType(type))
			  $('dataFormat').value=type;
		}
		var saveBtnClick = false;
		function saveForm(operType){
			var templateId = document.getElementById("typeId").value;
			if(validAuditUserEnabled(templateId, 'ajaxBulDataManager') ==  'false'){
				alert(v3x.getMessage("bulletin.bulletin_checker_enabled_please_reset"));
				return;
			}
			var flag = validTypeExist('${bean.type.id}', 'ajaxBulDataManager'); 	
	 		if(flag == 'false'){
	 			alert(v3x.getMessage("bulletin.type_deleted"));
	 			isFormSumit = true;
	 			getA8Top().document.getElementById('main').src = "${bulDataURL}?method=index&spaceType=${spaceType}&spaceId=${param.spaceId}"
	 		}else{
	 			if(!checkForm(dataForm)){
	 				return;
	 			}
				var bodyType = document.getElementById("bodyType");
				var changePdf = document.getElementById("c");
				$('dataFormat').value = bodyType.value;
				$('form_oper').value = operType;
				if($('dataForm').onsubmit()) {
					saveAttachment();
					document.getElementById("ext5").value = "";
					if(bodyType.value == "Pdf"){
						var isSuccess = savePdf();
						if(!isSuccess){
							return false;
						}
					}else{
						if((bodyType.value == "OfficeWord"||bodyType.value == "WpsWord") && changePdf && changePdf.checked){
							if(!removeTrailAndSaveOffice()) return false;
							var fileId = getUUID();
							document.getElementById("ext5").value = fileId;
							if(!transformWordToPdf(fileId)) return false;
						}else{
							if(!removeTrailAndSaveOffice()) return false;
						}
					}
					isFormSumit = true;
					if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
					window.onbeforeunload = function(){
            		    try {
            		        removeCtpWindow(null,2);
            		    } catch (e) {
            		    }
        			}
					
					if(!saveBtnClick){
          				saveBtnClick = true;
						$('dataForm').submit();
					}
				}
	 		}
		}
		function viewPage(){
			var ext = document.getElementById("ext1").value;
			var wid = document.body.clientWidth-20;
			var hig = document.body.clientHeight;
			v3x.openWindow({
				url :"${genericController}?ViewPage=bulletin/data_Detail&ext1="+ext,
				width:wid,
				height:hig,
				resizable : "false",
				dialogType : "open"
			});
		}
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachmentAndActiveOcx()"));
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "insertCorrelationFile('resizeFckeditor')"));//关联文档的入口
      
    
		<c:if test="${bean.state != 10}">
    		myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "saveForm('draft');", [1,5], "", null));
    	</c:if>    	
 		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
 		var supportPdfMenu=true;
    	myBar.add(${v3x:bodyTypeSelector("v3x")});
    	if(bodyTypeSelector){
			bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
		}
    	<c:set value="javascript:history.back()" var="backEvent" />
        <c:if test="${param.from == 'top'}">
        <%--TODO yangwulin 2012-11-28 javascript:getA8Top().contentFrame.topFrame.back() --%>
            <c:set value="javascript:getA8Top().back()" var="backEvent" />
        </c:if>
		<%-- 预览、返回 --%>
		   	myBar.add(new WebFXMenuButton("preview", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage()", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));
<%-- 显示当前位置 --%>
	if('${spaceType}' == '1') {
	   var theHtml=toHtml("${v3x:toHTML(bean.type.typeName)}",'<fmt:message key="bul.issue.log"/>');
       showCtpLocation("",{html:theHtml});
	}
	
	//进行解锁
	function unlock(id){
		try {
			if('${param.isAuditEdit}'=='true'){
				return;
			}
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxBulDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		}catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
	//-->
</script>
</head>
<body scroll='no' style="overflow-y:hidden;height: 100%" class="padding5" onunload="unlock('${bean.id }');">
<div style="height:100%;">
<form action="${bulDataURL}" style="height:100%;" name="dataForm" id="dataForm" method="post" onsubmit="return myCheckForm(this)">
<input type="hidden" id="method" name="method" value="save" />
<input type="hidden" id="id" name="id" value="${bean.id}" />
<input type="hidden" id="custom" name="custom" value="${param.custom}" />
<input type="hidden" name="form_oper" id="form_oper" value="draft" />
<input type="hidden" id="dataFormat" name="dataFormat" value="${bean.dataFormat}" />
<input type="hidden" name="spaceId" id="spaceId" value="${param.spaceId}" />
<input type="hidden" id="ext5" name="ext5" value="${bean.ext5}" />
<input type="hidden" name="spaceType" value="${spaceType}" />
<input type="hidden" name="bulTypeId" value="${bean.type.id}" />
<input type="hidden" id="bulBottPre" name="bulBottPre" value="1" />
<input type="hidden" name="tempIndex" id="tempIndex" value="${param.tempIndex}" />
<input type="hidden" name="typeExt1" id="ext1" value="${bean.type.ext1}"/>
<%-- 切换格式为了方便取得附件的ID所以传递AttID --%>
<input type="hidden" name="attRefId" id="attRefId" value="${requestScope.attRefId}" />
<input type="hidden" name="attFlag" id="attFlag" value="${requestScope.attFlag}" />
<input type="hidden" name="isAuditEdit" id="isAuditEdit" value="${param.isAuditEdit}" />
<input type="hidden" name="_createDate" id="_createDate" value="<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/>" />
<%@ include file="../include/dataEdit.jsp" %>
</form>
</div>
<div id="hideIframe" style="display:none">
<iframe id="templateIframe"></iframe>
</div>
</body>
</html>
<script type="text/javascript">
  if(v3x.isFirefox || v3x.isChrome){
  	window.onbeforeunload = function(){
  		return "";
  	}
  }else{
  	window.onbeforeunload = function(){
	   window.event.returnValue = "";
	}
  }
  
  var screenHeight = parseInt(document.body.clientHeight);
  var screenHeight1 = screenHeight - 120;
  var oElem = document.getElementById("editerDiv");
  if (oElem != null && typeof(oElem) != 'undefined') { 
  	 oElem.style.height = screenHeight1 + "px";
  }
   OfficeObjExt.setIframeId("officeFrameDiv"); 

</script>