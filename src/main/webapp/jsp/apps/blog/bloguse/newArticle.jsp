<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../../common/INC/noCache.jsp"%>
<title>Insert title here</title>
<%@ include file="../header.jsp" %>
<script type="text/javascript">
<!--
var hasDiagram = <c:out value="${hasWorkflow}" default="false" />;        
var appName = "blog";
var btnSave=null;

function save()
{
	isSaveAction = true;
	var form = document.getElementById("sendForm");
	if(checkForm(form))
	{
		var subject = document.getElementById("subject").value;
		<c:forEach items="${articleModellist}" var="obj">
        var obj_arr="${v3x:escapeJavascript(obj.subject)}";
		if(obj_arr==subject){
		alert('<fmt:message key="blog.alert.title.exist" />'); 
		return;
		}
        </c:forEach>

        var keys = fileUploadAttachments.keys();
        var sizeSum = 0;
    	for(var i = 0; i < keys.size(); i++){
    		var size = Number(fileUploadAttachments.get(keys.get(i), null).size);
    		//alert(Number(size));
    		sizeSum = sizeSum + size;
    		
    	}
    	var requestCaller = new XMLHttpRequestCaller(this, "docSpaceManager",
    							"judgeBlogSpace", false);
    	requestCaller.addParameter(1, "Long", sizeSum + Number('${article.articleSize}'));
    			
    	var sizeResult = requestCaller.serviceRequest();
    	if(sizeResult == "false"){
    		alert(_('BlogLang.blog_create_space_no_enough'));
    		return;
    	}
		saveAttachment();
		form.action = "${detailURL}?method=createArticle";
		form.comm.value = "";
		isFormSumit = true;
		form.submit();
		var sv = document.getElementById("save");
		if(navigator.appName == "Microsoft Internet Explorer"){
			sv.disabled = true;
		} else {
			sv.setAttribute("class","disabled webfx-menu--button");
			sv.setAttribute("onmouseover","");
			sv.setAttribute("onmouseout","");
			sv.setAttribute("onclick","");
		}
		
		
	}
}


var selectedElements = null;

var showOriginalElement_wf = false;
//-->
</script>
</head>
<body scroll="no">
<form name="sendForm" id="sendForm" method="post" target="blogNewIframe" >
<input type="hidden" name="id" value="${summary.id}">
<input type="hidden" name="comm" value="${comm}" />
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="9" height="22" valign="top">
	<script type="text/javascript">
		<!--
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		<!-- 如果没有开通博客，保存按钮不可用 -->
		btnSave=new WebFXMenuButton("save", "<fmt:message key='blog.article.create' />", "save()", [1,4], "", null);
		
		myBar.add(btnSave);
			
		var insert = new WebFXMenu;
		insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
		if(v3x.getBrowserFlag("hideMenu") == true){
			myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
		}
		<c:if test="${isFromTemplate != true}">
			var bodyTypeSelector = new WebFXMenu;
			bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_HTML%>')", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
			bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
			bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
		</c:if>
		
		document.write(myBar);
		document.close();
		//-->
	</script>
	</td>
  </tr>
  <!-- 标题 -->
  <tr class="bg-summary" align="left">
    <td height="29" align="right" nowrap="nowrap"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
    <td colspan="4"><fmt:message key="common.default.subject.value" var="defSubject" bundle="${v3xCommonI18N}" />
        <input name="subject" type="text" id="subject" class="input-100per" maxlength = "80" style="margin-left: 5px"
        	deaultValue="${defSubject}" validate="isDeaultValue,notNull"
            inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"
            value="<c:out value="${summary.subject}" escapeXml="true" default='${defSubject}' />${resendLabel}"
            ${v3x:outConditionExpression(readOnly, 'readonly', '')}
            onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"><input class="hidden">
    </td>
      <!-- 分类 -->
    <td nowrap="nowrap" colspan="4">
        <label for="state" style="margin-left: 10px">
        	<input type="checkbox" id="state" name="state" checked="checked"> <fmt:message key="blog.share.flag" />
        </label>
    </td>
  </tr>
  <tr id="attachment2TR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="middle"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="middle"><div class="div-float" style="margin-top:4px">(<span id="attachment2NumberDiv"></span>个)</div>
      <div><c:url value='/common/images/toolbar/bodyType_excel.gif'/></div><div id="attachment2Area" style="overflow: auto;"></div></td>
  </tr>
  <tr id="attachmentTR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="middle"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="middle" ><div class="div-float" style="margin-top:4px">(<span id="attachmentNumberDiv"></span>个)</div>
		<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="true" />
      </td>
  </tr>
  <tr>
  	<td colspan="9" height="6" class="bg-b"></td>
  </tr>
  <tr valign="top">
	<td colspan="9">
    	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    		<tr valign="top">
    			<td>
                    <div id="docBodyDivId">
        			<c:choose>
        			  	<c:when test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
        			  		<v3x:editor htmlId="content" content="${body.content}" type="${body.bodyType}" createDate="${body.createDate}" originalNeedClone="${cloneOriginalAtts}" category="<%=ApplicationCategoryEnum.blog.getKey()%>" />
        			  	</c:when>
        			  	<c:otherwise>
        			  		<textarea id="content" name="content" style="height: 100%;width: 100%"></textarea>
        			  		<input type='hidden' name='bodyType' id='bodyType' value='HTML'>
        					<input type="hidden" name="bodyCreateDate" id="bodyCreateDate" value="">
        					<input id="contentNameId" type="hidden" name="contentName" value="">	
        			  	</c:otherwise>
        			  </c:choose>
                      </div>
    			</td>
    		</tr>
    	</table>
	</td>
   </tr>
  </table></td>
  </tr>
</table>
</form>
    <iframe name="blogNewIframe" id="blogNewIframe" scrolling="no" frameBorder="0" height="0" width="0"></iframe>
</body>
</html>
<script type="text/javascript">
window.onload = function (){tout=setTimeout("init()",1000);}
function init(){
    var isIE6 = !-[1,] && !window.XMLHttpRequest;
   //判断页面是否加载完成
   if (document.readyState=='complete')
   {
        //停止定时器
       clearTimeout(tout);
       if(isIE6){
           var RTEEditorDivHeight = document.documentElement.clientHeight-84;
           document.getElementById('RTEEditorDiv').style.height= RTEEditorDivHeight +'px';
       } 
   }
}
</script>