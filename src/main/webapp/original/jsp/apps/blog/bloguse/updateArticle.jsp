<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp" %>
<script type="text/javascript">

var hasDiagram = <c:out value="${hasWorkflow}" default="false" />;        
var appName = "blog";


function save()
{	
	isSaveAction = true;
	var sendForm = document.getElementById("sendForm");
	var articleSubject = "${v3x:escapeJavascript(article.subject)}";
	if(checkForm(sendForm))
	{
		var subject = document.getElementById("subject").value;
		<c:forEach items="${articleModellist}" var="obj">
            var obj_arr='${v3x:escapeJavascript(obj.subject)}';
    		if(obj_arr==subject){
    			if(articleSubject != obj_arr){
    				alert('<fmt:message key="blog.alert.title.exist" />'); 
    				return;
    			}
    		}
        </c:forEach>

	var size = fileUploadAttachments.size();
	var keys = fileUploadAttachments.keys();

	for(var i = 0; i < keys.size(); i++){
		var att1 = fileUploadAttachments.get(keys.get(i), null);
		var filename1 = att1.filename;
		//alert(filename1 + "      " + att1.size);
		for(var j = i + 1; j < keys.size(); j++){
			var att2 = fileUploadAttachments.get(keys.get(j), null);
			var filename2 = att2.filename;
			if(filename2 == filename1){
				alert(parent.v3x.getMessage('BlogLang.blog_upload_attachment_dupl_name'));
				return;
			}
		}
	}

	//�ڱ��渽��֮ǰ���ж������size�ǲ��ǳ���͹涨�Ĵ�С

	var sizeSum = 0;//�����Ĵ�С�ܺ�
	for(var i = 0; i < keys.size(); i++){
		var size = Number(fileUploadAttachments.get(keys.get(i), null).size);
		//alert(Number(size));
		sizeSum = sizeSum + size;//���
		
	}
	//alert(sizeSum);
	var requestCaller = new XMLHttpRequestCaller(this, "docSpaceManager",
							"judgeBlogSpace", false);
	requestCaller.addParameter(1, "Long", sizeSum + Number('${article.articleSize}'));
			
	var sizeResult = requestCaller.serviceRequest();
	//alert(sizeResult);
	if(sizeResult == "false"){
		alert(parent.v3x.getMessage('BlogLang.blog_create_space_no_enough'));
		return;
	}

	saveAttachment();	
	isFormSumit = true;
	sendForm.action = "${detailURL}?method=saveArticleAfterUpdate&articleId=${article.id}";
	sendForm.submit();
	}		
}

function closeAndShow(url){

	
	v3x.openWindow({
			url: url,
			workSpace: 'yes'
			}); 
	
	window.close();



}
var selectedElements = null;

var showOriginalElement_wf = false;
</script>
</head>


<body scroll="no" >
<form name="sendForm" id="sendForm" method="post" >

<input type="hidden" name="id" value="${summary.id}">
<input type="hidden" name="comm" value="${comm}" />

<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0" class="page2-list-border">
  <tr>
    <td colspan="9" height="22" valign="top">
		<script type="text/javascript">
		
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		myBar.add(new WebFXMenuButton("save", "<fmt:message key='blog.article.save' />", "save()", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
		
		var insert = new WebFXMenu;
		insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
		if(v3x.getBrowserFlag("hideMenu") == true){
			myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
		}
			<c:if test="${isFromTemplate != true}">
				var bodyTypeSelector = new WebFXMenu;
				bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_HTML%>')", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
				bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
				bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
			</c:if>
		
		document.write(myBar);
		document.close();
		</script>

	</td>
  </tr>
  <tr class="lest-shadow">
    <td width="8%" height="29" class="bg-gray bg-summary"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
    <td width="62%" class="bg-summary"><fmt:message key="common.default.subject.value" var="defSubject" bundle="${v3xCommonI18N}" />
        <input name="subject" type="text" id="subject" class="input-100per" maxlength = "80"
        	deaultValue="${defSubject}" validate="isDeaultValue,notNull"
            inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"
            value="${v3x:toHTML(article.subject)}${resendLabel}"
            ${v3x:outConditionExpression(readOnly, 'readonly', '')}
            onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"><input class="hidden">
        </td>
  <td width="8%" nowrap="nowrap" height="18" class="bg-gray bg-summary" valign="top"></td>
  <td width="14%" colspan="3" class="bg-summary bg-summary">  
  			<c:if test="${article.state == '0'}">
  				<label for="state">
  					<input type="checkbox" id="state" name="state" checked="checked"> <fmt:message key="blog.share.flag" />
  				</label>
  			</c:if>
  			
  			<c:if test="${article.state == '1'}">
  				<label for="state">
  					<input type="checkbox" id="state" name="state"> <fmt:message key="blog.share.flag" />
  				</label>
  			</c:if>
 						

	</td>
  <td width="8%" nowrap="nowrap" height="18" class="bg-gray bg-summary" valign="top" align="right">

  </td>
  </tr>

  <tr id="attachmentTR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
      <td colspan="8" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
		<v3x:fileUpload  applicationCategory="18" attachments="${attachments}" canDeleteOriginalAtts="true"/>
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
				<c:choose>
			  	<c:when test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
			  		<v3x:editor htmlId="content" content="${body.content}" type="${body.bodyType}" createDate="${body.createDate}" originalNeedClone="${cloneOriginalAtts}" category="<%=ApplicationCategoryEnum.blog.getKey()%>" />
			  	</c:when>
			  	<c:otherwise>
			  		<textarea id="content" name="content" style="height: 100%;width: 100%">${body.content}</textarea>
			  		<input type='hidden' name='bodyType' id='bodyType' value='HTML'>
					<input type="hidden" name="bodyCreateDate" id="bodyCreateDate" value="${body.createDate}">
					<input id="contentNameId" type="hidden" name="contentName" value="">	
			  	</c:otherwise>
			  </c:choose>
			</td>
		</tr>
	</table>
	</td>
  </tr>
</table>
	
</form>
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