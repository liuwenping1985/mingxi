<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<fmt:message key="common.dateselected.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<form action="" name="mainForm" id="mainForm"  method="post" >
<input type="hidden" id="isalert" value="true">
<input type="hidden" id="method" value="${param.method}">
  <style>
  	.file-check{
  		filter:alpha(opacity=0);       
  		-moz-opacity:0;              
  		-khtml-opacity:0;              
  		opacity: 0;     
  	}
  </style>
<div class="container overflow" id="newData" style="overflow: auto;height: 100%;background-color: white;padding-left: 5px" onmousewheel="mousewheel()">
<input type="hidden" id="startNumber" value="">
	<div class="mainDoc iconList">
		<ul class="docList_ALL overflow" id="newView">
		</ul>
	</div>
</div>
<input type="hidden" id="pageNo" value="1">
<input type="hidden" name="oname" value=""> 
<input type="hidden" name="is_folder" value="">
<input type="hidden" name="isPersonalLib" value="">
<input type="hidden" name="parentId" value="${param.resId}">
<input type="hidden" name="docLibId" value="${param.docLibId}">
<input type="hidden" name="docLibType" value="${param.docLibType}">
<input type="hidden" name="selectedRowId" value="">
<input type="hidden" name="isNewView" value="true">
<div id="docUploadDiv" style="visibility:hidden"><div><v3x:fileUpload applicationCategory="3" /></div></div>
<script>
	var pageSize = 30;
	var start = 0;
	var isRequest = true;
	var fileUploadQuantity = 5;
	$(function(){
		$(window).resize(function(){
		 	setWidth();	
		})
		initNewData();
		setWidth();
		
		showOpe();
		
		$(".span_set,editContent").click(function(e){
			e.stopPropagation();
			$(".div_tool").addClass("show");
			$(".div_tool").removeClass("hide");
			var divTop=$(this).offset().top-15;
			var divLeft=$(this).offset().left+15;
			if(isNewView==true){
				containerWidth=$(".container ").width();
				containerHeight=$(".container ").height();
			}else{
				containerWidth=$("#oldData ").width();
				containerHeight=$("#oldData ").height()-30;
			}

			//$(this).parent().children(".choose").addClass("spanChoose");
			if(divLeft+170>containerWidth){
				if(divTop+210>containerHeight){
					$(".div_tool").css({
						"top":divTop-210,
						"left":divLeft-170
					});
				}else{
					$(".div_tool").css({
						"top":divTop,
						"left":divLeft-170
					});
				}
			}else{
				if(divTop+210>containerHeight){
					$(".div_tool").css({
						"top":divTop-210,
						"left":divLeft
					});
				}else{
					$(".div_tool").css({
						"top":divTop,
						"left":divLeft
					});
				}
				
			}
		});
		var discuss_rightDom  = document.getElementById("newData");
		if (discuss_rightDom.addEventListener) {
			discuss_rightDom.addEventListener('DOMMouseScroll', function(event) {
				mousewheel();
			}, false);
		}
	})
	
	function setWidth(){
		var height=$(window).height()-65;
		$(".container").css("height",height);
		var width=$(".container").width();//
		var length=$(".docList").length;
		for(var i =length;i>0;i--){
			var width_lis=i*231;
			var margin=(width-width_lis)/(i+1);
			if(width_lis < width && margin>10){	
				$(".docList").css("margin-left",margin);
				break;
			}else{
				continue;
			}
		}
		var ulWidth=$(".docList_ALL").width();
		var liNum=Math.floor(ulWidth/139);
		var liMargin=(ulWidth-liNum*135)/(liNum);

		$(".docList_li").css({
			"margin":" 10px  " +liMargin/2+"px"
		});
		$(".discuss_right").css("height",(height-10)+"px");
	}
	
	function changeIcon(id){
			$("#"+id).toggleClass("current");
			if($("#"+id).attr("class").indexOf("current")>0){
				$("#"+id).find(".file-check").attr("checked",true);
			}else{
				$("#"+id).find(".file-check").removeAttr("checked");
			}
			
		}
	
	function initNewData(){
		var end = start+pageSize;
		var html = appandNewData(start,end);
	    $("#newView").append(html);
	    setWidth();
	}
	
	
	function appandNewData(start,end){
		var _htm  = "";
		var _start = parseInt(start);
		<c:forEach items="${docs}" var="docsList"  varStatus="vo_number">
		var  index = "${vo_number.count}";
		
		var d_name = escapeStringToHTML("${v3x:toHTMLWithoutSpaceEscapeQuote(docsList.docResource.frName)}").replace(/\&#039;/g,"\\'");
		var newEvent = "";
		
		<c:forEach items="${docsList.grids}" var="docsRows">
		if(${docsRows.isName == 'true' && docsList.settable == 'true'}){
			if(${param.frType == '40' && param.method ne 'advancedQuery'}){
				newEvent ="OnMouseUp(new DocResource('${docsList.docResource.id}',\'"+d_name+"\','${docsList.docResource.parentFrId}','${docsList.docResource.isFolder}','${docsList.isUploadFile}','${docsList.isLink}','${docsList.docResource.isCheckOut}','${docsList.docResource.checkOutUserId}','${docsList.isPig}','${docsList.isFolderLink}','${docsList.docResource.isLearningDoc}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.mimeTypeId}', '${docsList.docResource.versionEnabled}', '${docsList.docResource.recommendEnable}'), new DocAcl('true','true','true','true','true','true','true'), '${entranceType}','${docsList.isCollect}', '${docsList.vForDocPropertyIframe}','${docsList.vForBorrow}','${docsList.openSquare}','${docsList.vForDocDownload}','${docsList.collect}','${onlyA6}','${onlyA6s}','${isGovVer}',true,'${isOwner}');";
			}else if(${param.frType != '40' && param.method ne 'advancedQuery'}){
				newEvent ="OnMouseUp(new DocResource('${docsList.docResource.id}',\'"+d_name+"\','${docsList.docResource.parentFrId}','${docsList.docResource.isFolder}','${docsList.isUploadFile}','${docsList.isLink}','${docsList.docResource.isCheckOut}','${docsList.docResource.checkOutUserId}','${docsList.isPig}','${docsList.isFolderLink}','${docsList.docResource.isLearningDoc}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.mimeTypeId}', '${docsList.docResource.versionEnabled}', '${docsList.docResource.recommendEnable}'), new DocAcl('${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}','${docsList.docResource.createUserId == v3x:currentUser().id}'),'${entranceType}','${docsList.isCollect}', '${docsList.vForDocPropertyIframe}','${docsList.vForBorrow}','${docsList.openSquare}','${docsList.vForDocDownload}','${docsList.collect}','${onlyA6}','${onlyA6s}','${isGovVer}',true,'${isOwner}');";
			}
		}
		</c:forEach>
		var _a = "";
		var _db = "";
		if(${docsList.isUploadFile == 'false' && docsList.docResource.isFolder=='true'}){
			_a = "<a class=\"font-12px defaulttitlecss\" style=\"word-wrap: break-word;word-break: break-all;display:block;\" "
				 + "href=\"javascript:folderOpenFun('${docsList.docResource.id}','${docsList.docResource.frType}','${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}',"
				 + "'${docsList.browseAcl}','${docsList.listAcl}', 'false','${docsList.v}','${docsList.docResource.projectTypeId}');\">${v3x:toHTMLWithoutSpace(v3x:getLimitLengthString(v3x:_(pageContext, docsList.docResource.frName), 20,'...'))}";
			_db = "folderOpenFun('${docsList.docResource.id}','${docsList.docResource.frType}','${docsList.allAcl}','${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}','false','${docsList.v}','${docsList.docResource.projectTypeId}')";
		}else{
			_a = "<a class=\"font-12px defaulttitlecss\" style=\"word-wrap: break-word;word-break: break-all;display:block;\" "
				 + "href=\"javascript:fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)\">${v3x:toHTMLWithoutSpace(v3x:getLimitLengthString(v3x:_(pageContext, docsList.docResource.frName), 20,'...'))}";
			_db = "fnOpenKnowledge('${docsList.docResource.id}','${entranceType}',null,false,true)";
		}
		
		if(parseInt(index)>=parseInt(_start+1) && parseInt(index)<=parseInt(end)){
			var _li = "<li class=\"docList_li left \" id=\"li_${docsList.docResource.id}\" ondblclick="+_db+" onclick=\"changeIcon('li_${docsList.docResource.id}');chkMenuGrantControl('${docsList.allAcl }',"
					+ "'${docsList.editAcl}','${docsList.addAcl}','${docsList.readOnlyAcl}','${docsList.browseAcl}','${docsList.listAcl}',$(this).find('input')[0],'${docsList.docResource.isFolder}',"
					+ "'${docsList.isFolderLink}','${docsList.isLink}','${docsList.appEnumKey}','${docsList.isSysInit}','${docsList.docResource.createUserId == v3x:currentUser().id}','${docsList.isCollect}',"
					+ "'${onlyA6}','${onlyA6s}');\"><input type=\"checkbox\" name=\"newCheckBox\" value=\"${docsList.docResource.id}\" isCollect=\"${docsList.isCollect}\" class=\"file-check\"/><input type='hidden' id='isUploadFile_${docsList.docResource.id}' value='${docsList.isUploadFile}'>"
					+ "<input type=\"hidden\" id=\"createDate_${docsList.docResource.id}\" value=\"${docsList.createDate}\"><input type=\"hidden\" id=\"sourceId_${docsList.docResource.id}\" value=\"${docsList.docResource.sourceId}\"><input type='hidden' id='isFolder${docsList.docResource.id}' value='${docsList.docResource.isFolder}'><input type='hidden' id='appEnumKey_${docsList.docResource.id}' value='${docsList.appEnumKey}'><input type='hidden' id='new_prop_edit_${docsList.docResource.id}' value='${docsList.allAcl || docsList.editAcl}'>";
			var _span = "<span class=\"choose\"></span><div class=\"docImg\">";
			var _icon = "<span class=\"icon64 unknown_3_7_icon64\" id=\"${docsList.docResource.id}\"></span>";
			var file_hiden = ""
			var file_size = "";
			var file_name = "";
			<c:forEach items="${docsList.grids}" var="docsRows">
				file_hiden = "<input type='hidden' id='${docsList.docResource.id}_IsPig' value='${docsList.isPig || docsList.isLink || docsList.isFolderLink}'>"
	            			+"<input type='hidden' id='${docsList.docResource.id}_UploadFileV' value='${docsList.vForDocDownload}'>"
				if(${docsRows.isName=='true'}){
					file_name = "<input type='hidden' id='${docsList.docResource.id}_Name' value='${v3x:toHTML(v3x:_(pageContext, docsRows.value))}'>"
				}
				if(${docsRows.isSize=='true'}){
					file_size = "<input type='hidden' id='${docsList.docResource.id}_Size' value='${v3x:toHTML(v3x:_(pageContext, docsRows.value))}'>"
				}
				file_hiden = file_hiden + file_name + file_size;
			</c:forEach>
			<c:if test="${docsList.isUploadFile == 'false' && docsList.docResource.isFolder=='true'}">
				_icon =	"<span class=\"icon64 folder_2_5_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 116}">
				_icon =	"<span class=\"icon64 zip_5_2_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 51}">
				_icon =	"<span class=\"icon64 map_3_2_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && (docsList.docResource.mimeTypeId == 23  ||docsList.docResource.mimeTypeId == 25 ||docsList.docResource.mimeTypeId == 101)}">
				_icon =	"<span class=\"icon64 doc_2_6_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && (docsList.docResource.mimeTypeId == 24 	||docsList.docResource.mimeTypeId == 26 ||docsList.docResource.mimeTypeId == 102)}">
				_icon =	"<span class=\"icon64 xls_2_7_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 105}">
				_icon =	"<span class=\"icon64 txt_3_5_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 119}">
				_icon =	"<span class=\"icon64 rar_5_1_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 122}">
				_icon =	"<span class=\"icon64 exe_8_1_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && (docsList.docResource.mimeTypeId == 22 || docsList.docResource.mimeTypeId == 107 || docsList.docResource.mimeTypeId == 108)}">
				_icon =	"<span class=\"icon64 html_3_6_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 103}">
				_icon =	"<span class=\"icon64 pdf_3_3_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 104}">
				_icon =	"<span class=\"icon64 ppt_3_4_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 112}">
				_icon =	"<span class=\"icon64 png_4_2_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 109}">
				_icon =	"<span class=\"icon64 gif_4_1_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 117}">
				_icon =	"<span class=\"icon64 jpg_3_8_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 115}">
				_icon =	"<span class=\"icon64 tif_4_3_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			 <c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 114}">
				_icon =	"<span class=\"icon64 tag_4_4_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 106}">
				_icon =	"<span class=\"icon64 bmp_4_6_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 110}">
				_icon =	"<span class=\"icon64 mpg_4_7_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 113}">
				_icon =	"<span class=\"icon64 rm_4_8_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 1}">
				_icon =	"<span class=\"icon64 col_1_1_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 2}">
				_icon =	"<span class=\"icon64 edoc_1_2_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 3}">
				_icon =	"<span class=\"icon64 plan_1_3_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 4}">
				_icon =	"<span class=\"icon64 meeting_1_4_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 5}">
				_icon =	"<span class=\"icon64 news_1_5_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 6}">
				_icon =	"<span class=\"icon64 bul_1_6_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 7}">
				_icon =	"<span class=\"icon64 inq_1_8_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 8}">
				_icon =	"<span class=\"icon64 bbs_2_1_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 9}">
				_icon =	"<span class=\"icon64 form_2_2_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 10}">
				_icon =	"<span class=\"icon64 email_2_3_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.docResource.mimeTypeId == 15}">
				_icon =	"<span class=\"icon64 info_2_4_icon64\" id=\"${docsList.docResource.id}\"></span>";
			</c:if>
			<c:if test="${docsList.docResource.isFolder=='false' && docsList.isImg == 'true'}">
                _icon = "<img src=\"${pageContext.request.contextPath}/commonimage.do?method=showImage&id=${docsList.file.id}&size=custom&h=64&w=64\" id=\"newView_${docsList.docResource.id}\" width=\"64\" height=\"64\" id=\"${docsList.docResource.id}\"/>";
            </c:if>
			
			var _mid_div = "</div><div title=\"${v3x:toHTMLWithoutSpace(v3x:_(pageContext, docsList.docResource.frName))}\">";
			
			var _span_ico = "</a><span class=\"span_set ico16 setting_16\" style=\"display:none\" id=\"newView_${docsList.docResource.id}\" onclick=\""+newEvent+"\" /></div></li>";
			_htm  += _li+_span+_icon+file_hiden+_mid_div+_a+_span_ico;
		}
		</c:forEach>
		_start = parseInt(pageSize)+parseInt(_start) ;
		$("#startNumber").val(_start);
		return _htm;
	}
	
	//滚鼠加载数据
	var totalheight = 0;
	function mousewheel(){
		
		if(!isRequest){
			return;
		}
		totalheight = $(window).height() + $(".container").scrollTop();
		if ($(".mainDoc").height() <= totalheight+30){
		    start = $("#startNumber").val();
		    var end = parseInt(start)+parseInt(pageSize);
		    var pageNo = $("#pageNo").val();
		    var html = getDocMore(pageNo);
		    if(html==""){
		    }else{
			    $("#newView").append(html);
			    setWidth();
		    }
		    showOpe();
		}
	}
	
	function showOpe(){
		//是否是V5人员
		var isV5Member = '${CurrentUser.externalType == 0}';
		$(".mainDoc.iconList .docList_li").mouseover(function(){
			$(this).children(".choose").addClass("spanChoose");
			if($(this).hasClass("current")){
				$(".div_tool").addClass("hide").removeClass("show");
			}
			if(isV5Member == "true"){
				$(this).find("div span.span_set").css("display","block");
			}
		});

		$(".mainDoc.iconList .docList_li").mouseout(function(){	
			if(!$(this).hasClass("current")){
				$(this).children(".choose").removeClass("spanChoose");
			}
			$(this).find("div span.span_set").css("display","none");
		});
	}
	
	function getDocMore(pageNo){
		var projectTypeId = "${projectTypeId}";
		var v_string = "${v}";
		v_string = "'"+v_string+"'";
		if(projectTypeId==null||projectTypeId==""){
			projectTypeId = 0;
		}
		var params = "";
		var str4html = "";
		var isFromSea = "${isFromSea}";
		if(isFromSea==1){
			params = parent.frames["treeFrame"].document.getElementById("seaUrl").value+"&pageNo="+pageNo;
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "seaDoc4newView", false);
			requestCaller.addParameter(1, "String", params);
			str4html = requestCaller.serviceRequest();
		}else{
			params = "{pageNo:"+pageNo+",resId:${resId},frType:${frType},projectTypeId:"+projectTypeId+",docLibId:${docLibId}"+
					 ",docLibType:${docLibType},isShareAndBorrowRoot:${isShareAndBorrowRoot},all:${all},edit:${edit},add:${add},"+
					 "readonly:${readonly},browse:${browse},list:${list},v:"+v_string+"}";
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "doc4newView", false);
			requestCaller.addParameter(1, "String", params);
			str4html = requestCaller.serviceRequest();
		}
		
		
		var json4html = jQuery.parseJSON(str4html);
		var _html = "";
		if(json4html!=""&&json4html!=null){
			_html = json2html(json4html);
		}
		return _html;
	}
	
	function json2html(json4html){
		var _htm  = "";
		var allDocs = json4html["allDocs"];
		var entranceType = json4html["entranceType"];
		var isA6 = json4html["isA6"];
		var isGovVer = json4html["isGovVer"];
		var onlyA6 = json4html["onlyA6"];
		var onlyA6s = json4html["onlyA6s"];
		var pageNo = json4html["pageNo"];
		$("#pageNo").val(pageNo);
		if(allDocs.length<30){
			isRequest = false;
		}
		for(var i=0;i<allDocs.length;i++){
			var doc_vo = allDocs[i];
			var doc = doc_vo["docResource"];
			var grids = doc_vo["grids"];
			var newEvent = "";
			
			if(doc["projectTypeId"]==undefined){
				doc["projectTypeId"] = "";
			}
			var file = "";
			if(doc_vo["file"]!=undefined){
				file = doc_vo["file"];
			}
			var flag = (doc["createUserId"]==${v3x:currentUser().id})?true:false;
			if(${param.frType == '40' && param.method ne 'advancedQuery'}){
				newEvent = "OnMouseUp(new DocResource('"+doc["id"]+"','"+escapeStringToHTML(doc["frName"]).replace(/\&#039;/g,"\\'")+"','"+doc["parentFrId"]+"','"+doc["isFolder"]+"','"+doc_vo["isUploadFile"]+"','"+doc_vo["isLink"]+"','"+doc["isCheckOut"]+"','"+doc["checkOutUserId"]+"','"+doc_vo["isPig"]+"','"+doc_vo["isFolderLink"]+"','"+doc["isLearningDoc"]+"','"+doc_vo["appEnumKey"]+"','"+doc_vo["isSysInit"]+"','"+doc["mimeTypeId"]+"', '"+doc["versionEnabled"]+"', '"+doc["recommendEnable"]+"'), new DocAcl('true','true','true','true','true','true','true'), '"+entranceType+"','"+doc_vo["isCollect"]+"', '"+doc_vo["vForDocPropertyIframe"]+"','"+doc_vo["vForBorrow"]+"','"+doc_vo["openSquare"]+"','"+doc_vo["vForDocDownload"]+"','"+doc_vo["collect"]+"','"+onlyA6+"','"+onlyA6s+"','"+isGovVer+"',true,'${isOwner}');";
			}else if(${param.frType != '40' && param.method ne 'advancedQuery'}){
				newEvent = "OnMouseUp(new DocResource('"+doc["id"]+"','"+escapeStringToHTML(doc["frName"]).replace(/\&#039;/g,"\\'")+"','"+doc["parentFrId"]+"','"+doc["isFolder"]+"','"+doc_vo["isUploadFile"]+"','"+doc_vo["isLink"]+"','"+doc["isCheckOut"]+"','"+doc["checkOutUserId"]+"','"+doc_vo["isPig"]+"','"+doc_vo["isFolderLink"]+"','"+doc["isLearningDoc"]+"','"+doc_vo["appEnumKey"]+"','"+doc_vo["isSysInit"]+"','"+doc["mimeTypeId"]+"', '"+doc["versionEnabled"]+"', '"+doc["recommendEnable"]+"'), new DocAcl('"+doc_vo["allAcl"]+"','"+doc_vo["editAcl"]+"','"+doc_vo["addAcl"]+"','"+doc_vo["readOnlyAcl"]+"','"+doc_vo["browseAcl"]+"','"+doc_vo["listAcl"]+"', '"+flag+"'),'"+entranceType+"','"+doc_vo["isCollect"]+"', '"+doc_vo["vForDocPropertyIframe"]+"','"+doc_vo["vForBorrow"]+"','"+doc_vo["openSquare"]+"','"+doc_vo["vForDocDownload"]+"','"+doc_vo["collect"]+"','"+onlyA6+"','"+onlyA6s+"','"+isGovVer+"',true,'${isOwner}');";
			}
			
			var _a = "";
			var _db = "";
			if(doc_vo["isUploadFile"] == false && doc["isFolder"] == true){
				_a = "<a class=\"font-12px defaulttitlecss\" style=\"word-wrap: break-word;word-break: break-all;display:block;\" "
					 + "href=\"javascript:folderOpenFun('"+doc["id"]+"','"+doc["frType"]+"','"+doc_vo["allAcl"]+"','"+doc_vo["editAcl"]+"','"+doc_vo["addAcl"]+"','"+doc_vo["readOnlyAcl"]+"',"
					 + ""+doc_vo["browseAcl"]+"','"+doc_vo["listAcl"]+"', 'false','"+doc_vo["v"]+"','"+doc["projectTypeId"]+"');\">"+escapeStringToHTML(getLimitLength(doc["frName"],20));
				_db = "folderOpenFun('"+doc["id"]+"','"+doc["frType"]+"','"+doc_vo["allAcl"]+"','"+doc_vo["editAcl"]+"','"+doc_vo["addAcl"]+"','"+doc_vo["readOnlyAcl"]+"','"+doc_vo["browseAcl"]+"','"+doc_vo["listAcl"]+"', 'false','"+doc_vo["v"]+"','"+doc["projectTypeId"]+"')";
			}else{
				_a = "<a class=\"font-12px defaulttitlecss\" style=\"word-wrap: break-word;word-break: break-all;display:block;\" "
					 + "href=\"javascript:fnOpenKnowledge('"+doc["id"]+"','"+entranceType+"',null,false,true)\">"+escapeStringToHTML(getLimitLength(doc["frName"],20));
				_db = "fnOpenKnowledge('"+doc["id"]+"','"+entranceType+"',null,false,true)";
			}
			
			var state = (doc_vo["allAcl"]||doc_vo["editAcl"])?true:false;
			var _li = "<li class=\"docList_li left \" id=\"li_"+doc["id"]+"\" ondblclick="+_db+" onclick=\"changeIcon('li_"+doc["id"]+"');chkMenuGrantControl('"+doc_vo["allAcl"]+"',"
					+ "'"+doc_vo["editAcl"]+"','"+doc_vo["addAcl"]+"','"+doc_vo["readOnlyAcl"]+"','"+doc_vo["browseAcl"]+"','"+doc_vo["listAcl"]+"',$(this).find('input')[0],'"+doc["isFolder"]+"',"
					+ "'"+doc_vo["isFolderLink"]+"','"+doc_vo["isLink"]+"','"+doc_vo["appEnumKey"]+"','"+doc_vo["isSysInit"]+"','if("+doc["createUserId"]+"==${v3x:currentUser().id})?true:false','"+doc_vo["isCollect"]+"',"
					+ "'"+onlyA6+"','"+onlyA6s+"');\"><input type=\"checkbox\" name=\"newCheckBox\" value=\""+doc["id"]+"\" isCollect=\""+doc_vo["isCollect"]+"\" class=\"file-check\"/><input type='hidden' id='isUploadFile_"+doc["id"]+"' value='"+doc_vo["isUploadFile"]+"'>"
					+ "<input type=\"hidden\" id=\"createDate_"+doc["id"]+"\" value=\""+doc_vo["createDate"]+"\"><input type=\"hidden\" id=\"sourceId_"+doc["id"]+"\" value=\""+doc["id"]+"\"><input type='hidden' id='isFolder"+doc["id"]+"' value='"+doc["isFolder"]+"'><input type='hidden' id='appEnumKey_"+doc["id"]+"' value='"+doc_vo["appEnumKey"]+"'><input type='hidden' id='new_prop_edit_"+doc["id"]+"' value='"+state+"'>";
			var _span = "<span class=\"choose\"></span><div class=\"docImg\">";
			var _icon = "<span class=\"icon64 unknown_3_7_icon64\" id=\""+doc["id"]+"\"></span>";
			var file_hiden = ""
			var file_size = "";
			var file_name = "";
			for(var j=0;j<grids.length;j++){
				var grid = grids[j];
				var state = (doc_vo["isPig"] ||doc_vo["isLink"]||doc_vo["isFolderLink"])?true:false;
				file_hiden = "<input type='hidden' id='"+doc["id"]+"_IsPig' value='"+state+"'>"
		        			+"<input type='hidden' id='"+doc["id"]+"_UploadFileV' value='"+doc_vo["vForDocDownload"]+"'>"
				if(grid.isName==true){
					file_name = "<input type='hidden' id='"+doc["id"]+"_Name' value='"+grid["value"]+"'>"
				}
				if(grid.isSize==true){
					file_size = "<input type='hidden' id='"+doc["id"]+"_Size' value='"+grid["value"]+"'>"
				}
				file_hiden = file_hiden + file_name + file_size;
			}
			
			if(doc_vo["isUploadFile"]==false && doc["isFolder"]==true){
				_icon =	"<span class=\"icon64 folder_2_5_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==116){
				_icon =	"<span class=\"icon64 zip_5_2_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==51){
				_icon =	"<span class=\"icon64 map_3_2_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && (doc["mimeTypeId"]==23 || doc["mimeTypeId"]==25 || doc["mimeTypeId"]==101)){
				_icon =	"<span class=\"icon64 doc_2_6_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && (doc["mimeTypeId"]==24 || doc["mimeTypeId"]==26 || doc["mimeTypeId"]==102)){
				_icon =	"<span class=\"icon64 xls_2_7_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==105){
				_icon =	"<span class=\"icon64 txt_3_5_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==119){
				_icon =	"<span class=\"icon64 rar_5_1_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==122){
				_icon =	"<span class=\"icon64 exe_8_1_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && (doc["mimeTypeId"]==22 || doc["mimeTypeId"]==107 || doc["mimeTypeId"]==108)){
				_icon =	"<span class=\"icon64 html_3_6_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==103){
				_icon =	"<span class=\"icon64 pdf_3_3_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==104){
				_icon =	"<span class=\"icon64 ppt_3_4_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==115){
				_icon =	"<span class=\"icon64 tif_4_3_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==114){
				_icon =	"<span class=\"icon64 tag_4_4_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==106){
				_icon =	"<span class=\"icon64 bmp_4_6_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==110){
				_icon =	"<span class=\"icon64 mpg_4_7_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==113){
				_icon =	"<span class=\"icon64 rm_4_8_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==1){
				_icon =	"<span class=\"icon64 col_1_1_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==2){
				_icon =	"<span class=\"icon64 edoc_1_2_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==3){
				_icon =	"<span class=\"icon64 plan_1_3_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==4){
				_icon =	"<span class=\"icon64 meeting_1_4_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==5){
				_icon =	"<span class=\"icon64 news_1_5_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==6){
				_icon =	"<span class=\"icon64 bul_1_6_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==7){
				_icon =	"<span class=\"icon64 inq_1_8_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==8){
				_icon =	"<span class=\"icon64 bbs_2_1_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==9){
				_icon =	"<span class=\"icon64 form_2_2_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==10){
				_icon =	"<span class=\"icon64 email_2_3_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc["mimeTypeId"]==15){
				_icon =	"<span class=\"icon64 info_2_4_icon64\" id=\""+doc["id"]+"\"></span>";
			}else if(doc["isFolder"]==false && doc_vo["isImg"]==true){
				 _icon = "<img src=\"${pageContext.request.contextPath}/commonimage.do?method=showImage&id="+file["id"]+"&size=custom&h=64&w=64\" id=\"newView_"+doc["id"]+"\" width=\"64\" height=\"64\" id=\""+doc["id"]+"\"/>";
			}
			
			var _mid_div = "</div><div title=\""+escapeStringToHTML(doc["frName"])+"\">";
			
			var _span_ico = "</a><span class=\"span_set ico16 setting_16\" style=\"display:none\" id=\"newView_"+doc["id"]+"\" onclick=\""+newEvent+"\" /></div></li>";
			
			_htm  += _li+_span+_icon+file_hiden+_mid_div+_a+_span_ico;
		}
		return _htm;
	}
	
</script>
</form>