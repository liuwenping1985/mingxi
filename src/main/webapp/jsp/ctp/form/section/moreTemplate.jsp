<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title></title>
<style type="text/css">
.page2-header-bg {
    font-size: 24px;
    font-weight: bold;
    color: #219FDA;
    width:380px;
    text-shadow:1px 2px 2px #cccccc;
}
.div-float a{
    color: #1039B2;
    text-decoration:none;
    cursor: pointer;
}
.sorts {
    border-bottom:dotted 1px #ccc;
    font-size: 22px;
    PADDING-LEFT: 8px;
    PADDING-TOP: 8px;
    PADDING-BOTTOM: 8px;
}
a {
    font-size: 12px;
    cursor: pointer;
    color: #007CD2;
    text-decoration: none;
}
body{
    margin-left: 32px;
    margin-top: 12px;
}
</style>
<script type="text/javascript">
$(document).ready(function () {
    //返回 绑定点击事件
    $('#backLink').click(function(){
        getA8Top().back();
    });
    //
    $("#searchValue").keydown(function(event){
      if(event.keyCode === 13){
        search();
      }
    });
    getA8Top().hideLocation();
    getCtpTop().showMoreSectionLocation("${ctp:i18n('formtemplete.section.name')}");
});

function search(){
  $("#searchValueHide").val(escape($("#searchValue").val()));
  $("#searchForm").jsonSubmit();
}
function openBlank(link,workSpaceType){
	getCtpTop().openCtpWindow({'url':link});
	/*
	var openArgs = {};
	openArgs["url"] = link;
	openArgs["dialogType"] = "open";
	openArgs["resizable"] = "yes";
	openArgs[workSpaceType] = "yes";
	if(link.indexOf("linkSystemController") != -1){
		openArgs["closePrevious"] = "no";
	}
	var rv = v3x.openWindow(openArgs);
	*/
}
</script>
</head>
<body>
<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
    <tr class="page2-header-line">
	   <td width="100%" height="38" valign="top">
           <form id="searchForm" method="post" action="${path}/form/formSection.do?method=moreTemplate&templateCategoryId=${param.templateCategoryId}">
    	       <table width="100%"  border="0" cellpadding="0" cellspacing="0">
    	           <tr class="page2-header-line">
    	               <td class="page2-header-bg">${ctp:i18n('form.bindseeyon.section.moretemplate')}</td><!-- 我的模板 -->
                       <td class="page2-header-line page2-header-link" align="right">
                            <input id="searchValue" name="searchValue" value="${searchValue}"/>
                            <span class="ico16 search_16" onclick="search()"></span>&#13
                       </td>
                       <td width="10%" align="center">
                       </td>
                       <td width="1%">
                       </td>
    			   </tr>
    		  </table>
          </form>
	   </td>
    </tr>
    <tr><td style="display: block;">
    <div class="scrollList" id="scrollListDiv" style="overflow: auto;height: 100%;">
    <c:if test="${fn:length(list) != 0}">
        <c:forEach items="${list }" var="categoryName">
              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                      <div class="div-float no-wrap">
                          <span class="ico16 folder_16"></span>
                          <a class="display-inline">
                            <b>${v3x:toHTML(categoryName.name)}</b>
                          </a>
                      </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${categoryName.value }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  width="25%">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when>
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="createTitle" value="${templeteName }&#13${templeteCreatorAlt[templete.memberId] }"/>
                            
                            <a title="${createTitle}" class='defaultlinkcss' onclick="javascript:openBlank('${path }/collaboration/collaboration.do?method=newColl&templateId=${templete.id}','workSpaceRight');" href="#"><span class="ico16 ${templeteIcon[templete.id]} }"></span>
                            &nbsp;${templeteShowName }</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
              </table>
        </c:forEach>
	</c:if>
    </div>
    </td></tr>
</table>
</body>
</html>
