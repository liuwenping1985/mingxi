<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<c:set var="controller" value="magazine.do"/>
<html>
<head>
<title>
</title>
	
<script type="text/javascript">
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

    var type = "2";
      var filename = subject;
      var mimeType = documentType;
      var createDate = "2013-01-01 00:00:00";
      if (obj.getAttribute("createDate")) {
        createDate = obj.getAttribute("createDate");
      }
      var fileUrl = url;
      var description = url;

      addAttachmentPoi(type, filename, mimeType, createDate, '0', fileUrl, true,
          null, description, documentType, "notice.gif",'Doc1', url, '32');
    }

  	function quoteDocumentUnSelected(url) {
	    return deleteAttachment(url, fileUploadAttachments.containsKey(url));
	}

	function OK(){
		var atts = fileUploadAttachments.values().toArray();
		return atts;
	}
</script>
</head>
<body onkeydown="">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="popupTitleRight">
<tr>
	<td height="300">
		<iframe src="${path }/info/magazine.do?method=showContent&type=${ctp:toHTML(param.type)}&magazineId=${param.magazineId}" id="quoteDocumentFrame" name="quoteDocumentFrame" style="width:100%;height: 100%;" border="0px" frameborder="0" scrolling="no"></iframe>		
	</td>
</tr>
<tr>
	<td height="20" style="padding-left: 15px;"><span style="font-size: 12px;">${ctp:i18n('infosend.magazine.label.selectInfo')}<!-- 已选择的信息 -->：</span></td>
</tr>
<tr>
	<td height="60" style="padding: 0px 15px 0px 15px;"><div style="height: 100%; width: 100%;float: left; overflow-y: auto;font-size: 12px;" id="attachment2AreaDoc1">&nbsp;</div></td>
</tr>
<%--<tr>
	<td height="42" align="right" class="bg-advance-bottom">
		<input type="button"  onclick="doSubmit();" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
		<input type="button" onclick="doCancle();" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
	</td>
</tr> --%>
</table>
<script type="text/javascript">
var fileUploadAtts = null;
if(window.dialogArguments){
    fileUploadAtts = window.dialogArguments[0].fileUploadAttachments;
}else{
    fileUploadAtts = window.parent.fileUploadAttachments;
}
if(fileUploadAtts){
    var atts = fileUploadAtts.values();
    for(var i = 0; i < atts.size(); i++) {
        var att = atts.get(i);
        fileUploadAttachments.put(att.fileUrl, att);
        showAtachmentObject(att, true);
    }
}
</script>
</body>
</html>