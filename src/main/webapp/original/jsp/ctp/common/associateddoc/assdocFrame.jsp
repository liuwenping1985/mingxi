<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ page import="com.seeyon.ctp.common.constants.SystemProperties,java.util.Map,com.seeyon.ctp.common.assdoc.AssdocDefinition" %>
<c:set var="assMap"  value="<%=com.seeyon.ctp.common.assdoc.AssdocInitial.getAssMap() %>"  />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' /></title>

<script type="text/javascript">
<!--
var appurlMap=new Properties();
<%
Map<String,AssdocDefinition > assBeanMap= com.seeyon.ctp.common.assdoc.AssdocInitial.getAssMap();
for(String key: assBeanMap.keySet()){
    %>
    appurlMap.put("<%= key%>","<%= assBeanMap.get(key).getUrl()%>&referenceId=${param.referenceId}");
    <%
}
%>

var _from = '${from}';

function change(appid,obj){

  //需要附上应用路径
  //_ctxPath
  quoteDocumentFrame.location.href = _ctxPath+appurlMap.get(appid);
  //quoteDocumentFrame.location.href = appurlMap.get("assdoc.appurl.app-"+appid, "");
    //$(".common_tabs a").css("background","url(" + _ctxPath +"'skin/default/images/control_bg.png')");
    //$(obj).css("background","#fff");
    $(".common_tabs li").removeClass('current');
    $(obj).parent().addClass('current');
}

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
  if(_from && _from == 'formTable' && fileUploadAttachments.containsKey(url)){
    alert("文档"+subject+"已经存在，不允许重复添加!") ;
    obj.checked = false;
    return;
  }
  if(_from && _from == 'formTable'){
    var _theShowUploadAtts = window.dialogArguments.dialogArguments.theToShowAttachments;
    if(_theShowUploadAtts){
      for(var len = 0 ; len < _theShowUploadAtts.size() ; len++) {
        var attobj = _theShowUploadAtts.get(len);
        if(attobj.fileUrl == url){
          alert("文档"+subject+"已经存在，不允许重复添加!") ;
          obj.checked = false;
          return ;
        }
      }
    }
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
        null, description, documentType, documentType + ".gif",'${ (empty param.poi) ?  "" : param.poi }', '${ (empty param.referenceId) ?  "" : param.referenceId }', '${ (empty param.applicationCategory) ?  "" : param.applicationCategory }');
  }

  function quoteDocumentUnSelected(url) {
    return deleteAttachment(url, fileUploadAttachments.containsKey(url));
  }



  function quoteDocumentOK() {
    var atts = fileUploadAttachments.values().toArray();

    if (!atts || atts.length < 1) {
    alert($.i18n('assdoc.choose.atleastone.mesg'));
      return;
    }

    //parent.window.returnValue = atts;
    //parent.window.close();
    var callback = null;
    if(typeof(transParams) !="undefined"){
        transParams.parentWin.quoteDocumentCallback(atts,transParams.divid);
         <c:if test="${not empty param.callMethod}" >
            if( transParams.parentWin.${param.callMethod}) {
            	callback =  transParams.parentWin.${param.callMethod};
            	callback();
                }
        </c:if>
    }else{
        parent.window.returnValue = atts;
                <c:if test="${not empty param.callMethod}" >
            if(parent.${param.callMethod}) {
            	callback = parent.${param.callMethod};
            	callback();
                }
        </c:if>
    }
    windowClose();
  }

function windowClose(){
    try{
	    showOfficeObj();
	} catch(e){}
    if(getCtpTop().addassDialog){
        getCtpTop().addassDialog.close();
    }else if(getA8Top().addassDialog){
        getA8Top().addassDialog.close();
    }else{
        window.close();
    }
}
  function quoteDocumentOKForm() {
    var _parent = window.opener;
    if (_parent == null) {
      _parent = window.dialogArguments;
    }
    var _parentFarther = _parent.opener;
    if (_parentFarther == null) {
      _parentFarther = _parent.dialogArguments;
    }
    var dv = _parentFarther.extendField;
    var extendFieldWidth = _parentFarther.extendWidth;//表单上传附件字段的宽度
    var atts = fileUploadAttachments.values().toArray();//得到所有的MAP中的数据

    if (!atts || atts.length < 1) {
      alert(getA8Top().v3x
          .getMessage('collaborationLang.collaboration_alertQuoteItem'));
      return;
    }

    var att;
    var subReference = dv.value
    if (!subReference) {
      subReference = getUUID();
      dv.value = subReference;
    }
    if (dv) {
      for ( var i = 0; i < atts.length; i++) {
        att = atts[i];
        if (dv.label && dv.label != null) {
          dv.label = dv.label + att.filename;
        } else {
          dv.label = att.filename;
        }
        if (att.extSubReference != "") {
          continue;
        }
        _parentFarther.addAttachment('4', att.filename, att.mimeType,
            att.createDate, att.size, att.fileUrl, true, false,
            att.description, null, att.mimeType + ".gif", "", "", false,
            extendFieldWidth)
        _parentFarther.fileUploadAttachments.get(att.fileUrl).extSubReference = subReference;
      }
    }

    parent.window.close();
  }
  $(function(){
		$('#quoteDocumentFrame').attr('src', $('#quoteDocumentFrame').attr('src'));
  })
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" class="bg_color" onload="cruuentAddLoad()">
<%-- 公文:4、文档中心:3、会议：6 --%>
<%-- 复选框的事件是：onclick="parent.quoteDocumentSelected(this, subject, ${applicationCategoryType.name}, id)"  --%>
<c:set var="canCol"  value="<%= AppContext.hasPlugin(\"collaboration\") && (AppContext.getCurrentUser().hasResourceCode(\"F01_listPending\") || AppContext.getCurrentUser().hasResourceCode(\"F01_listSent\") || AppContext.getCurrentUser().hasResourceCode(\"F01_listDone\")) %>" />
<%--a6s去掉公文模块--%>
<c:set var="canOffice"  value="${ctp:getSystemProperty('system.ProductId') eq '7'}?false:<%= AppContext.getCurrentUser().hasResourceCode(\"F07_sendManager\") %>" />
<c:choose>
	<c:when test="${ctp:getSystemProperty('system.ProductId') eq '7'}">
		<c:set var="canOffice"  value="false" />
	</c:when>
	<c:otherwise>
	<%--F07_sendDone--%>
		<c:set var="canOffice"  value="<%= AppContext.getCurrentUser().hasResourceCode(\"F07_sendManager\") %>" />
	</c:otherwise>
</c:choose>

<%-- <c:set var="canDoc"  value="<%= AppContext.getCurrentUser().hasResourceCode(\"F04_docIndex\") || AppContext.getCurrentUser().hasResourceCode(\"F04_myDocLibIndex\") %>" /> --%>
<c:set var="canDoc"  value="<%= AppContext.hasPlugin(\"doc\") %>" /> <%-- 因A6-S 版的资源权限不能确认，暂时设置成不判断 --%>

<c:set var="canMeeting"  value="<%= AppContext.getCurrentUser().hasResourceCode(\"F09_meetingPending\") %>" />

    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="sprit:false,border:false,height:33,spiretBar:{show:false}">
            <div class="common_tabs clearfix" style="margin: 0 20px; background: none;">
                <ul class="left">
                    <c:set var="defaulturl" value="" />
                    <c:set var="allAssModules" value="1,4,3,6"/>
                    <c:forEach var="appid"  items='${fn:split(param.exAssModules,",")}'>
                    <c:set var="allAssModules"  value='${fn:replace(allAssModules,appid, "rm")}'/>
                    </c:forEach>

                    <%-- <c:forEach var="appid" items='${fn:split(param.isBind,",")}'> --%>
                    <c:forEach var="appid" items='${fn:split(allAssModules,",")}'>
                        <c:if test="${ appid ne 'rm' && assMap[appid] != null }">
                            <c:if test="${ (fn:trim(appid) eq '1' && canCol) || (CurrentUser.externalType == 0 && fn:trim(appid) eq '4' && canOffice) || (fn:trim(appid) eq '3' && canDoc) || (CurrentUser.externalType == 0 && fn:trim(appid) eq '6' && canMeeting)  }">
                                <li><a class="no_b_border" hidefocus="true" onclick="change(${appid },this)"
                                    tgt="tab1_iframe"> <span><fmt:message
                                                key="assdocapplication.${appid}.label" bundle='${v3xCommonI18N}' /></span></a></li>
                                <c:if test="${empty defaulturl }">
                                    <c:set var="defaulturl" value="${ assMap[appid]}" />
                                </c:if>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    <li><a class="last_tab no_b_border"
                        style="width: 1px; padding: 0px; min-width: 1px; border-left: 0px;"></a></li>
                </ul>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
             <iframe id="quoteDocumentFrame"  src="about:blank" name="quoteDocumentFrame" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
        </div>
        <div class="layout_south over_hidden" layout="sprit:false,border:false,height:188,maxHeight:188,minHeight:188,spiretBar:{show:false}">
               <table width="100%" height="188" border="0" cellspacing="0" cellpadding="0" class="border_t">
                <tr>
                    <td style="padding-left: 15px; line-height:30px; height: 30px;">${ctp:i18n("channel.selected.label")}</td>
                </tr>
                <tr>
                    <td style="height:108px;"><div style="height:108px; width: 98%;margin-left:5px;float: left; overflow-y: auto" id="attachment2Area${ (empty param.poi) ?  '' : param.poi }"></div></td>
                </tr>
                <c:if test="${v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
                <tr>
                
                <c:choose>
                <c:when test="${from == 'formTable'}">
                        <td height="50" align="right" class="bg-advance-bottom">
                            <input type="button" onclick="quoteDocumentOKForm()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
                            <input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
                        </td>
                </c:when>
                <c:otherwise>
                    <td height="50" align="right" class="bg-advance-bottom">
                        <input type="button" onclick="quoteDocumentOK()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
                        <input type="button" onclick="windowClose()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
                    </td>
                </c:otherwise>
                </c:choose>
                </tr>
                </c:if>

             </table>
        </div>
    </div>

<script type="text/javascript">
var fileUploadAtts = null;

if(typeof(transParams) !="undefined"){
    fileUploadAtts =transParams.parentWin.fileUploadAttachments;
}else{
    if(window.dialogArguments){
        fileUploadAtts = window.dialogArguments.fileUploadAttachments;
    }else{
        fileUploadAtts = window.parent.fileUploadAttachments;
    }
}

if(fileUploadAtts){
    var atts = fileUploadAtts.values();
    for(var i = 0; i < atts.size(); i++) {
        var att = atts.get(i);
        if ((att.type == 2 || att.type == 4) && att.showArea =="${ (empty param.poi) ?  '' : param.poi }" ){
            fileUploadAttachments.put(att.fileUrl, att);
            showAtachmentObject(att, true);
        }
    }
}

if(_from == 'formTable' ){
    var _fileUploadAtts = null;
    if(window.dialogArguments){
        _fileUploadAtts = window.dialogArguments.dialogArguments.fileUploadAttachments;
    }else{
        _fileUploadAtts = window.parent.parent.fileUploadAttachments;
    }
       if(_fileUploadAtts){
        var _atts = _fileUploadAtts.values();
        for(var j = 0; j < _atts.size();j++) {
            var _att = _atts.get(j);
            if ((_att.type == 2 || _att.type == 4) && att.showArea =="${ (empty param.poi) ?  '' : param.poi }" ){
                fileUploadAttachments.put(_att.fileUrl, _att);
                showAtachmentObject(_att, true);
            }
        }
    }
}

/**
 * 页面加载方法放在最后，目的是需要获取defaulturl.url
 */
function cruuentAddLoad(){
    $(".common_tabs li:first").addClass('current');
    <c:if test="${ '' ne  defaulturl }">
        //页面加载完成后再进行iframe加载
        quoteDocumentFrame.location.href = "${pageContext.request.contextPath}${defaulturl.url}";
    </c:if>
}

 /**
 *IE8的兼容性问题,刷新iframe的高度
 */
 $(function(){
     $('#quoteDocumentFrame').attr('src', $('#quoteDocumentFrame').attr('src'));
     $("#quoteDocumentFrame").css({
        "width":$("#center1").width()-40,
        "margin-left":"20px"
     })
})
</script>
</body>
</html>
