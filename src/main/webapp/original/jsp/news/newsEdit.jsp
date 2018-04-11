<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html style="height:100%;">
<%@ include file="./header.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><c:if test="${param.newsId=='' }">
<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.8.label' bundle="${v3xCommonI18N}" />
</c:if> <c:if test="${param.newsId!='' }">
<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.8.label' bundle="${v3xCommonI18N}" />
</c:if></title>
<link rel="stylesheet" type="text/css" href="${path}/skin/default/news.css${v3x:resSuffix()}">
<script type="text/javascript" src="${path}/apps_res/news/js/newsEdit.js${v3x:resSuffix()}"></script>
<script type="text/javascript">
var _path = '${path}';

function setPeopleFields(elements) {
  if (!elements) {
    return;
  }
  document.getElementById('publishDepartmentId').value=getIdsString(elements,false);
  document.getElementById('publishDepartmentName').value=getNamesString(elements);
  activeOcx();
}

var myBar = new WebFXMenuBar("${path}");
<c:if test="${param.newsId=='' || bean.state==0 || bean.state==40}">
myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "saveForm('draft');", [1,5], "", null));
</c:if>
//正文类型
var supportPdfMenu=true;
myBar.add(${v3x:bodyTypeSelector("v3x")});
if(bodyTypeSelector){
  bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
}
//预览
myBar.add(new WebFXMenuButton("preview", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage()", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));

var alert_noNull = "<fmt:message key='news.alert.newsType.is.noNull' />";
var alert_temp = "<fmt:message key='news.alert.load.template' />";

var _spaceType = '${spaceType}';
var _isAuditEdit = ${param.isAuditEdit eq 'true' ? true : false};
//新闻版块列
var typeListMap;
</script>
<style>
.hand{cursor: pointer;}
</style>
</head>
<body scroll='no' class="padding5" style="overflow: hidden;height:100%;" onload='initIe10AutoScroll("officeFrameDiv",120);reSize();' onunload="unlock('${bean.id }')">
<form style="height:100%;" action="${newsDataURL}" name="dataForm" target="_blank" id="dataForm" method="post"  onsubmit="return true">
<input type="hidden" name="method" id="method" value="newsEdit" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="spaceId" id="spaceId" value="${param.spaceId}" />
<input type="hidden" name="form_oper" id="form_oper" value="draft" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<input type="hidden" id="ext5" name="ext5" value="${bean.ext5}" />
<input type="hidden" name="newsTypeId" id="newsTypeId" value="${newsTypeId}" />
<input type="hidden" name="templateId" id="templateId" value="${param.tempId}" />
<input type="hidden" name="isAuditEdit" id="isAuditEdit" value="${param.isAuditEdit}" />
<!-- 切换格式为了方便取得附件的ID所以传递AttID -->
<input type="hidden" name="attRefId" id="attRefId" value="${requestScope.attRefId}" />
<input type="hidden" name="openFlag" id="openFlag" value="${requestScope.openFlag}" />
<input type="hidden" name="imgUrl" id="imgUrl"/>
<input type="hidden" name="showPublish" id="showPublish" value="${bean.showPublishUserFlag}"/>
<input type="hidden" name="commentPermit" id="commentPermit" value="${bean.commentPermit}"/>
<input type="hidden" name="messagePermit" id="messagePermit" value="${bean.messagePermit}"/>
<input type="hidden" name="hasImg" id="hasImg" value="${bean.imageNews}"/>
<input type="hidden" name="shareWeixin" id="shareWeixin" value="${bean.shareWeixin}"/>
<input type="hidden" name="pdf" id="pdf" value="${empty bean.ext5? 'false':'true'}"/>

<input type="hidden" id="typeJson" value="${v3x:toHTML(typeJson)}"/>
<input type="hidden" id="templJson" value="${v3x:toHTML(templJson)}"/>
<!-- 预览 -->
<input type="hidden" id="previewTitle" name="previewTitle" value="${v3x:toHTML(bean.title)}"/>
<input type="hidden" id="previewBrief" name="previewBrief" value="${v3x:toHTML(bean.brief)}"/>
<input type="hidden" id="previewKeywords" name="previewKeywords" value="${v3x:toHTML(bean.keywords)}"/>

<style>
#officeFrameDiv{height:100%;}
.input-100per{width: 100%;}
.input-99per{width: 99.3%;}
.input-98per{width: 98%;}
.input-66per{width: 66%;}
#webfx-menu-object-1{padding-left:10px;}
</style>
<table class="sponsor_table" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" >
    <tr>
        <td height="40" style="background: #f0f0f0;">
            <script type="text/javascript">document.write(myBar);</script>
        </td>
    </tr>
    <tr >
    <td height="10" class="bg-summary padding_t_10 padding_r_5">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" >
    <tr class="bg-summary" >
        <fmt:message key="oper.send" var="oper_send"/>
        <fmt:message key="news.save" var="news_save"/>
        <fmt:message key="oper.publish" var="oper_publish"/>
        <td rowspan="3" width="1%" nowrap="nowrap" valign="top"><a onclick="javaScript:saveForm('submit');" id='sendId'  class="margin_l_20 margin_r_10 inline-block align_center new_btn">${param.isAuditEdit?news_save:(isAduit?oper_send:oper_publish)}</a></td>
        <td width="36%" align="left">
                <fmt:message key="news.data.title" var="_myLabel"/>
                <fmt:message key="label.please.input" var="_myLabelDefault">
                    <fmt:param value="${_myLabel}" />
                </fmt:message>
                <c:set var="_value" value="${v3x:toHTML(bean.title)}" />
                <input type="text" class="input-66per" name="title" id="title"
                    value="<c:out value="${bean.title}" default="${_myLabelDefault}" escapeXml="true" />" 
                    title="${_value}"
                    defaultValue="${_myLabelDefault}"
                    onfocus="checkDefSubject(this, true)"
                    onblur="checkDefSubject(this, false)"
                    inputName="${_myLabel}"
                    validate="notNull,isDefaultValue,isWord"
                    maxSize="65"
                
                    ${v3x:outConditionExpression(readOnly, 'disabled', '')}
                />
                <select class="corSelect choice right input-30per" onchange="changeSelect();" id = "spaceType" name="spaceType" ${param.isAuditEdit eq 'true'?'disabled':''}>
                    <c:choose>
                      <c:when test="${spaceType==18}"><option value="18" selected><fmt:message key="news.custom.group"/></option></c:when>
                      <c:when test="${spaceType==17}"><option value="17" selected><fmt:message key="news.custom.corporation"/></option></c:when>
                      <c:when test="${spaceType==4}"><option value="4" selected><fmt:message key="news.custom.team"/></option></c:when>
                      <c:otherwise>
                        <c:if test="${hasGroup}">
                        <option value="3" ${spaceType == 3 ? 'selected' : ''}><fmt:message key="menu.group.news"/></option>
                        </c:if>
                        <c:if test="${hasCorp}">
                        <option value="2" ${spaceType == 2 ? 'selected' : ''}><fmt:message key="menu.account.news"/></option>
                        </c:if>
                      </c:otherwise>
                    </c:choose>
                </select>
        </td>
        <td width="30%" style="padding-left:10px;">
            <select class="corSelect input-99per" id="newsType" name="newsType" onchange="changeNewsType();" ${param.isAuditEdit eq 'true'?'disabled':''}>
            <c:if test="${spaceType==4}"><option value="${param.spaceId}" selected>${v3x:toHTML(customName)}</option></c:if>
            </select>
        </td>
        <td width="30%" style="padding-left:6px;">
            <!-- 发布部门 -->
            <c:set value="${v3x:getOrgEntity('Department', bean.publishDepartmentId).name}" var="publishScopeValue"/>
            <c:set value="${v3x:parseElementsOfIds(bean.publishDepartmentId, 'Department')}" var="defauDepar"/>
            <v3x:selectPeople id="dept" originalElements="${defauDepar}" panels="Department" selectType="Department" 
            jsFunction="setPeopleFields(elements)" departmentId="${v3x:currentUser().departmentId}" maxSize="1" minSize="1" />
            <input type="hidden" id="publishDepartmentId" name="publishDepartmentId" value="${bean.publishDepartmentId}"/>
            <input class="titleInput input-98per" type="text" id="publishDepartmentName" name="publishDepartmentName" 
                readonly="true" value="${publishScopeValue}" onclick="selectPeopleFun_dept();"/>
        </td>
   </tr>
   <tr class="bg-summary">
        <td width="32%" >
            <fmt:message key='news.data.brief' var="_myLabel" /> 
            <fmt:message key="label.please.input" var="_myLabelDefault">
                <fmt:param value="${_myLabel}" />
            </fmt:message>
            <input class="titleInput sendArea input-99per" name="brief" id="brief" type="text" 
                value="<c:out value="${bean.brief}" default="${_myLabelDefault}" escapeXml="true" />" 
                validate="maxLength" maxSize="120" 
                inputName="${_myLabel}" defaultValue="${_myLabelDefault}"
                onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)" />
        </td>
        <td width="32%" style="padding-left:10px;">
            <fmt:message key="news.data.keywords" var="_myLabel" /> 
            <fmt:message key="label.please.input" var="_myLabelDefault">
                <fmt:param value="${_myLabel}" />
            </fmt:message>
            <input class="titleInput input-98per" type="text" name="keywords" id="keywords" 
                value="<c:out value="${bean.keywords}" default="${_myLabelDefault}" escapeXml="true" />" 
                validate="maxLength" maxSize="60" 
                inputName="${_myLabel}" defaultValue="${_myLabelDefault}"
                onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)"/>
        </td>
        <td width="32%" style="padding-left:6px;">
            <select class="input-99per" id="newsTempl" name="newsTempl" onchange="loadNewsTemplate();">
              <option value="0"><fmt:message key="news.template" /></option>
              <c:if test="${spaceType == 4}">
                  <c:forEach items="${corp}" var="temp">
                    <option value="${temp.id}">${temp.templateName}</option>
                  </c:forEach>
              </c:if>
            </select>
        </td>
   </tr>
   <tr class="bg-summary row3">
   <td class="padding_t_5 col0_2" colspan="4">
      <ul class="" id="checkbox">
        <li class="left">
          <em id="showPublishUser" class="checkBox ${v3x:outConditionExpression(bean.showPublishUserFlag, 'checked', '')}"></em>
          <span class="hand"><fmt:message key="news.dataEdit.showPublishUser"/></span>
        </li>
        <li class="left hidden" id="commentLi">
          <em id="comPermit" class="checkBox ${v3x:outConditionExpression(bean.commentPermit, 'checked', '')}"></em>
          <span class="hand"><fmt:message key='news.allowComments' /></span>
        </li>
        <li class="left hidden" id="msgLi">
          <em id="msgPermit" class="checkBox ${v3x:outConditionExpression(bean.messagePermit, 'checked', '')}"></em>
          <span class="hand"><fmt:message key='news.allow.receive.comments'/></span>
        </li>
        <li class="left">
          <em id="imgNews" class="checkBox ${v3x:outConditionExpression(bean.imageNews, 'checked', '')}"></em>
          <span class="hand"><fmt:message key='news.image_news' /></span>
        </li>
        <li id="share_weixin_1" class="left" style="${bean.dataFormat == 'HTML' ? '' : 'display:none;'}">
          <em id="weixin" class="checkBox ${v3x:outConditionExpression(bean.shareWeixin, 'checked', '')}"></em>
          <span class="hand"><fmt:message key='news.allow.to.weixin' /></span>
        </li>
        <li id="changePdf" class="left" style="${bean.dataFormat == 'OfficeWord' ? '' : 'display: none;'}">
          <em id="toPdf" class="checkBox ${empty bean.ext5 ? '' : 'checked'}"></em>
          <span class="hand"><fmt:message key="common.transmit.pdf" bundle='${v3xCommonI18N}' /></span>
        </li>
        <li class="left hand" id="loadImage" style="display:none;">
          <input type="hidden" name="imageId" id="imageId" value="${bean.imageId}">
          <input type="button" name="uploadImage" id="uploadImage" class="uploadImage hand" value="<fmt:message key='news.upload.image' />" onclick="javascript:uploadImage4News();"/>
          <script type="text/javascript">
              var imageId = '${bean.imageId}';
              var imageNews = document.getElementById("imgNews");
              if(document.getElementById("imgNews").getAttribute('class').indexOf('checked')!=-1
                  && imageId != null && imageId != "" && imageId != 1){
                  document.getElementById("loadImage").style.display = "";
              }
          </script>
          <li class="left">
            <div id="attachment5Area"></div>
          </li>
        </li>
      </ul>
   </td>
   </tr>
   <tr class="row4">
      <td width="1%"></td>
      <td class="col0_2" colspan="3" width="99%">
        <ul class="overflow">
          <li class="left">
            <em class="icon16 file_attachment_16"></em>
            <span class="hand" onclick="insertAttachmentNew();"><fmt:message key='news.add.attachment' /></span>
          </li>
          <li class="left">
            <em class="icon16 addRelatDoc_16"></em>
            <span class="hand" onclick="insertCorrelationFile('resizeFckeditor');"><fmt:message key='news.add.correlationfile' /></span>
          </li>
        </ul>
      </td>
    </tr>
    <tr>
      <td width="1%"></td>
      <td colspan="3">
        <div id="attachment2TR" style="display:none;" class="reply_relation margin_b_5 margin_t_5">
          <span class="attachment_count left margin_r_10">
            <em class="icon16 relation_file_16"></em>
            <span class="td_attachment_num">(<span id="attachment2NumberDiv"></span>)</span>
          </span>
          <div id="attachment2Area" style="overflow: auto;"></div>
        </div>
      </td>
    </tr>
    <tr>
      <td width="1%"></td>
      <td colspan="3">
          <div id="attachmentTR" style="display:none;" class="my_reply_attchment margin_b_5 margin_t_5">
              <span class="attachment_count left margin_r_10">
                <em class="icon16 file_attachment_16"></em>
                <span class="td_attachment_num">(<span id="attachmentNumberDiv"></span>)</span>
              </span>
              <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
          </div>
      </td>
    </tr>
    </table></td></tr>
    <tr id="bodyTr">
        <td id="editerDiv_td" valign="top" height="100%" >
        <div id="editerDiv" style="display: block;height:100%;">
            <c:if test="${originalNeedClone==null}">
                <c:set var="originalNeedClone" value="false" scope="request" />
            </c:if>
            <v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" category="6" originalNeedClone="${originalNeedClone}" />
        </div>
        </td>
    </tr>
</table>
</form>
<div id="hideIframe" style="display:none">
<iframe id="templateIframe"></iframe>
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