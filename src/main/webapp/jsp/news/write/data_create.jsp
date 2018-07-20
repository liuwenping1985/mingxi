<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

 <!DOCTYPE html>
 <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html style="height:100%;position:fixed;top:0;width:100%;">
<title>
<c:if test="${param.method=='create' }">
<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.8.label' bundle="${v3xCommonI18N}" />
</c:if>
<c:if test="${param.method=='edit' }">
<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.8.label' bundle="${v3xCommonI18N}" />
</c:if>
</title>
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
	<%@ include file="../../common/INC/noCache.jsp" %>
<script type="text/javascript">
<!--
	if('${param.spaceType}' == '2') {
		if("${v3x:getSysFlagByName('sys_isGroupVer')}"=="true")  {
		  //TODO getA8Top().showLocation(7041, "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");
		} else {
		  //TODO getA8Top().showLocation(714, "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");
		}
	}else if('${param.spaceType}' == '3'){
		//TODO getA8Top().showLocation(7042, "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");
 		//getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(21, "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");
    }
	function setPeopleFields(elements){
		alert(elements);
	}
	
	function myCheckForm(form){		
		if(form.typeId.value==null || form.typeId.value==""){
			alert("<fmt:message key="news.data.type" />"+"<fmt:message key="error.notblank" />");
			return false;
		}
		//yangwulin 2012-11-13 字数限制 var content =FCKeditorAPI.GetInstance('content') ;
		//alert(content);
		return checkForm(form);
	}
  
	<%--
	//var hash=$H();
	//hash['']='';
	//<c:forEach items="${typeList}" var="type">
	//hash['${type.id}']='${type.defaultTemplate.id}';
	//</c:forEach>
	--%>
	function setTemplateByType(){
		$('templateId').value=hash[$F('typeId')];
	}	

	function loadNewsTemplate(){
		//对Office的处理
		if(confirm('<fmt:message key="info.load.template" />')){
			//$('templateIframe').src='<c:url value="/newsTemplate.do?method=detail" />&preview=true&load=true&id='+$F('templateId');;
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
    		//去掉离开提示
      		window.onbeforeunload = function(){
          	    try {
          	        removeCtpWindow(null,2);
          	    } catch (e) {
          	    }
    		}
			saveAttachment();
			$('dataForm').submit();
		}else{
			var ops = $('templateId').options;
			if('${param.tempIndex}' == null || '${param.tempIndex}' == '')
				ops[0].selected = true;
			else
				ops['${param.tempIndex}'].selected = true;
		}
	}
	
	function loadTemplateContent(content){
		var oEditor = FCKeditorAPI.GetInstance('content') ;
		//oEditor.SetHTML(window.frames['templateIframe'].document.getElementById('contentText').innerHTML);
		oEditor.SetHTML(content);
	}
	
		function chanageBodyTypeExt(type){
			if(chanageBodyType(type))
			  $('dataFormat').value=type;
		}
		
		//初始化图片地址
		function initImgUrl(){
			var frames = document.getElementsByTagName("iframe");
			for(var i=0;i<frames.length;i++){//内容iframe
				if(frames[i].className !="" && frames[i].className.indexOf("cke_wysiwyg_frame")!=-1){
					var ckeIframe = frames[i].contentWindow;
					if(ckeIframe && ckeIframe.document){
						var imgs = ckeIframe.document.getElementsByTagName("img");
						if(imgs.length > 0){//可以增加对图片属性高，宽的判定，但是产品说不用
							var imgUrl = document.getElementById("imgUrl");
							var imgSrc = "";
							for(var j=0; j < imgs.length ;j++ ){
								imgSrc = imgs[j].src;
								if(imgSrc.indexOf("/seeyon/fileUpload.do")!=-1){//seeyon/前缀
									imgSrc = imgSrc.substr(imgSrc.indexOf("seeyon/fileUpload.do")-1);
									break;
								}else if(imgSrc.indexOf("common/ckeditor43/plugins/fakeobjects/images/spacer.gif")!=-1 || imgSrc.length > 499){//地址超长或者表情都不采集
									imgSrc = "";
								}else{
									break;
								}
							}
							imgUrl.value = imgSrc;
						}
					}
				}
			}
		}
		var saveBtnClick = false;
		function saveForm(operType){
			initImgUrl();
			var templateId = document.getElementById("typeId").value;
			if(validAuditUserEnabled(templateId, 'ajaxNewsDataManager') ==  'false'){
				alert(v3x.getMessage("bulletin.bulletin_checker_enabled_please_reset"));
				return;
			}
			var imageNews = document.getElementById("imageNews");
			var imageId = document.getElementById("imageId").value;
			if(imageNews.checked && imageId == ""){
				alert(v3x.getMessage("NEWSLang.imagenews_must_upload_image"));
				return;
			}
			
			var flag = validTypeExist('${bean.type.id}', 'ajaxNewsDataManager');
			$('dataFormat').value=document.getElementById("bodyType").value;
			
			window.onbeforeunload = function(){
  		        removeCtpWindow(null,2);
			}
            
	 		if(flag == 'false'){
	 			alert(v3x.getMessage("bulletin.type_deleted"));
	 			isFormSumit = true;
	 			getA8Top().document.getElementById('main').src = "${newsDataURL}?method=index&spaceType=${spaceType}&spaceId=${param.spaceId}"
	 			//parent.location.href = "${newsDataURL}?method=index&spaceType=${spaceType}&spaceId=${param.spaceId}";
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
			              if(bodyType.value == "OfficeWord" && changePdf && changePdf.checked){
			                  if(!removeTrailAndSaveOffice()) return false;
			                  var fileId = getUUID();
			                  document.getElementById("ext5").value = fileId;
			                  if(!transformWordToPdf(fileId)) return false;
			              }else{
			                  if(!removeTrailAndSaveOffice()) return false;
			              }
			          }
			          isFormSumit = true;
			          if(!saveBtnClick){
			          	saveBtnClick = true;
			          	$('dataForm').submit(); 
			          }
			      }
	 		}
		}
		function returnList(){
			//parent.window.location.href='${bulDataURL}?method=publishListMain';
		
		//	dataForm.target="_parent";
		//	dataForm.action="${newsDataURL}?method=publishListMain";
		//	dataForm.submit();
		
		self.history.back();
		}
		
		//新闻预览(打开方式改为open而非模态对话框,以便可以复制 added by Meng Yang 2009-06-18)
		function viewPage(){
			v3x.openWindow({
				url :"${genericController}?ViewPage=news/data_Detail",
				workSpace : true,
				scrollbars: false,
				resizable : "false",
				dialogType : "open"	
			});
		}	
		
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
      
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "insertCorrelationFile('resizeFckeditor')"));//关联文档的入口
    	    	
    	//var bodyTypeSelector = new WebFXMenu;
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_HTML", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_HTML%>');", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeWord", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>');", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_OfficeExcel", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>');", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    	//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsWord", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
		//bodyTypeSelector.add(new WebFXMenuItem("menu_bodytype_WpsExcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyTypeExt('<%=Constants.EDITOR_TYPE_WPS_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>")); 
    	

				<c:if test="${bean.state != 10}">
    	myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "saveForm('draft');", [1,5], "", null));
    	     	</c:if>    	
 		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
    	//myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));
    	var supportPdfMenu=true;
    	myBar.add(${v3x:bodyTypeSelector("v3x")});
    	if(bodyTypeSelector){
			bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
		}
    	//预览
    	myBar.add(new WebFXMenuButton("preview", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage()", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));
    	//myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "returnList();", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));    	
    	//document.write(myBar);
    	//document.close();
    	function validate(){
    		if($('brief').value==v3x.getMessage("NEWSLang.pls_input_brief"))
    		{		
    			$('brief').value="";
    			return false;
    		}
    	}
    	function validate1(){
    		if($('keywords').value==v3x.getMessage("NEWSLang.pls_input_keywords"))
    		   {
    			$('keywords').value="";   			
    			return false;
    		}
    	}
    	//-->
	//进行解锁
	function unlock(id){
		try {
			if('${param.isAuditEdit}'=='true'){
				return;
			}
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		}catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
	
	function resizeFckeditor () { 
		try{
			 var fckTdBlock = document.getElementById("editerDiv_td"); 
	         var fckOuterBlock = document.getElementById("editerDiv"); 
	         var fckBlock = document.getElementById("cke_1_contents"); 
	         fckOuterBlock.style.display = "none"; 
	         var nTdHeight = fckTdBlock.clientHeight; 
	         fckOuterBlock.style.height = nTdHeight + "px"; 
	         fckOuterBlock.style.display = "block"; 
	         fckBlock.style.height = (nTdHeight - 50) + "px"; 
		}catch(e){
			//防止打开pdf内容后获取不到ckedit
		}
	} 
	
    function deletAttrCallBackFun() {
    	resizeFckeditor();
    }
	
	function reSize(){
  		document.getElementById("editerDiv").style.height=document.getElementById("editerDiv_td").clientHeight+"px";
  	    if(v3x.isMSIE8){//112 140 128+24 152
  		    try{
  	        	var editerDiv_tdHeight = document.getElementById("editerDiv_td").clientHeight;
  	    		editerDiv_tdHeight = editerDiv_tdHeight-112;
  	        	if(document.documentElement.clientWidth<1024){
  	        		editerDiv_tdHeight=editerDiv_tdHeight-40;
  	        	}else{
  	        	    editerDiv_tdHeight=editerDiv_tdHeight-28;
  	        	}
  	            document.getElementById("editerDiv_td").style.height=editerDiv_tdHeight+"px";
  	            document.getElementById("editerDiv").style.height=editerDiv_tdHeight+"px";
  		    }catch(e){
  		    }
  	    }
  	}
//板块改变更新推送栏目信息
	function typeChange(){
		var typeId= document.getElementById("typeId").value;
		var requestCaller = new XMLHttpRequestCaller(this, "outerspaceSectionConfigManager", "findSectionNameByBusiness", false);
		requestCaller.addParameter(1, "Long", typeId);
		requestCaller.addParameter(2, "String", "8");
		var ds = requestCaller.serviceRequest();
		var oSpace = document.getElementById('space');
		var aLabel = oSpace.getElementsByTagName("label");
		if(ds.indexOf(":") > 0){
			var dses = ds.split(":");
			document.getElementById("outerSpaceId").value=dses[0];
			document.getElementById("outerSpace").value=dses[1];
			for(var i = 0; i < aLabel.length; i++){
				aLabel[i].style.display = "inline";
			}
			//document.getElementById('space').style.display = "inline";
				
		}else{
			document.getElementById("pushToSpace").checked = false;
			for(var i = 0; i < aLabel.length; i++){
				aLabel[i].style.display = "none";
			}
		   // document.getElementById('space').style.display = "none";
			 
		
		}
	}
</script>
</head>
<body  scroll='no' style="overflow-y:hidden;height:100%;" class="padding5" onload='initIe10AutoScroll("officeFrameDiv",120);reSize();' onunload="unlock('${bean.id }')">
<form style="height:100%;" action="${newsDataURL}" name="dataForm" id="dataForm" method="post"  onsubmit="return myCheckForm(this)">
<input type="hidden" name="method" id="method" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="custom" id="custom" value="${custom}" />
<input type="hidden" name="spaceId" id="spaceId" value="${param.spaceId}" />
<input type="hidden" name="form_oper" id="form_oper" value="draft" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<input type="hidden" name="spaceType" value="${spaceType}" />
<input type="hidden" id="ext5" name="ext5" value="${bean.ext5}" />
<input type="hidden" name="newsTypeId" value="${bean.type.id}" />
<input type="hidden" id="bulBottPre" name="bulBottPre" value="1" />
<input type="hidden" name="tempIndex" id="tempIndex" value="${param.tempIndex}" />
<input type="hidden" name="isAuditEdit" id="isAuditEdit" value="${param.isAuditEdit}" />
<!-- 切换格式为了方便取得附件的ID所以传递AttID -->
<input type="hidden" name="attRefId" id="attRefId" value="${requestScope.attRefId}" />
<input type="hidden" name="attFlag" id="attFlag" value="${requestScope.attFlag}" />
<input type="hidden" name="imgUrl" id="imgUrl"/>
<%@ include file="../include/dataEdit.jsp" %>
</form>
<div id="hideIframe" style="display:none">
<iframe id="templateIframe"></iframe>
</div>
</body>
</html> 
<script type="text/javascript">
  if(v3x.isFirefox||v3x.isChrome){
  	window.onbeforeunload = function(){
  		return "";
  	}
  }else{
  	window.onbeforeunload = function(){
	    try {
	    	window.event.returnValue="";
	    } catch (e) {
	    }
	}
  }
   OfficeObjExt.setIframeId("officeFrameDiv");
</script>
