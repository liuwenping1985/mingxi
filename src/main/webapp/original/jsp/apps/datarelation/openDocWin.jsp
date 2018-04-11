<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../ctp/common/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
var atts = [];
/**
 * checkbox回调方法
 * obj, checkbox对象 this
 * subject, 标题
 * documentType, 应用类型
 *  url，关联内容的id
 */
function quoteDocumentSelected(obj, subject, documentType, url){
  if(!obj){
    return;
  }
  
  if(!obj.checked){
    var result = quoteDocumentUnSelected(url);
    if(result == 1){
      obj.checked = true;
    }
    return;
  }

  if(!subject || !documentType || !url || fileUploadAttachments.containsKey(url)){
    return;
  }
  
  if(fileUploadAttachments.values().size() > 19){
  	obj.checked = false;
	  alert("${ctp:i18n('ctp.dr.only.select.20.js')}");
	  return;
  }
  
  var type = "2";
  var filename = subject;
  var mimeType = documentType;
  var createDate = "2013-01-01 00:00:00";
  if (obj.getAttribute("createDate")) {
    createDate = obj.getAttribute("createDate");
  }
  var fileUrl = url;
  var description = url;
  
  var mimeTypeId = documentType ;
  var isFolder = obj.getAttribute("isfolder");
  if(isFolder == "true"){
  	mimeTypeId = 31;
  }
  
  atts.push({"id":url,"mimeTypeId":mimeTypeId,"frName":subject});

 addAttachmentPoi(type, filename, mimeType, createDate, '0', fileUrl, true,
     null, description, documentType, documentType + ".gif",'${(empty param.poi) ?  "" : param.poi }', '${(empty param.referenceId) ?  "" : param.referenceId }', '${ (empty param.applicationCategory) ?  "" : param.applicationCategory }');
}

function quoteDocumentUnSelected(url) {
    return deleteAttachment(url, fileUploadAttachments.containsKey(url));
}


function initAtt(atts){
  if(atts){
	  var checkbox ={"checked":true,"getAttribute":function(){}};
	  for(var i = 0; i < atts.length; i++) {
	        var att = atts[i];
	        quoteDocumentSelected(checkbox,att.frName,att.mimeTypeId,att.id);
	  }
  }
 }

function OK(){
  var _atts = [];
	var selectedAts = fileUploadAttachments.values().toArray();
	for(var i = 0; i < selectedAts.length; i++) {
		for(var j = 0; j < atts.length; j++) {
	        var att = atts[j];
	        if(att.id == selectedAts[i].fileUrl){
	        	_atts.push(att);
	        	break;
	        }
	    }
	}
  return _atts;
}

$(function() {
	var transParams = window.parentDialogObj["_doctWin"].getTransParams();
	initAtt(transParams);
});
</script>
</head>
<body scroll="no" class="bg_color" >
<div id='layout' class="comp" comp="type:'layout'">
  <div class="layout_center padding_l_5 padding_r_5 over_hidden" layout="border:false">
    <iframe id="quoteDocumentFrame"  src="/seeyon/doc.do?method=docQuoteFrame&from=dataRelation" name="quoteDocumentFrame" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
  </div>
  <div class="layout_south over_hidden" layout="sprit:false,border:false,height:120,maxHeight:120,minHeight:120,spiretBar:{show:false}">
     <table width="100%" height="110" border="0" cellspacing="0" cellpadding="0" class="border_t">
      <tr>
          <td height="30" style="padding-left: 15px; line-height:30px;">${ctp:i18n("channel.selected.label")}</td>
      </tr>
      <tr>
          <td height="50" style=""><div style="height:50px; width: 98%;margin-left:5px;float: left; overflow-y: auto" id="attachment2Area${ (empty param.poi) ?  '' : param.poi }"></div></td>
      </tr>
   </table>
  </div>
</div>
</body>
</html>