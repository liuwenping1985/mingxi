<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">

.div-float a{
    color: #1039B2;
    text-decoration:none;
    cursor: pointer;
}
.sorts {
    border-bottom:dotted 1px #ccc;
    font-size: 22px;
    PADDING-LEFT: 30px;
    PADDING-TOP: 10px;
    PADDING-BOTTOM: 10px;
}
a {
    font-size: 12px;
    cursor: pointer;
    color: #000;
    text-decoration: none;
}
body{
    margin-left: 0px;
    margin-top: 12px;
}
</style>
<script type="text/javascript">
$(document).ready(function () {
    $("#searchValue").keydown(function(event){
      if(event.keyCode === 13){
        search();
      }
    });
    //getCtpTop().hideLocation();
});

function search(){
    $("#searchForm").jsonSubmit();
}
function openNewWindow(templateId) {
    url =  _ctxPath + "/collaboration/collaboration.do?method=newColl&from&templateId="+templateId;
    openCtpWindow({'url':url});
}
</script>
</head>
<body style="margin-top:0px">
<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
<table border="0" cellpadding="0" cellspacing="0" class="w100b h100b page_color padding_t_10" align="center">
    <tr>
	   <td width="100%" valign="top" class="border_b padding_l_10">
           <form id="searchForm" method="post" action="${path}/collTemplate/collTemplate.do?method=moreTemplate&columnsName=${ctp:encodeURI(columnsName)}">
    	       <table width="100%"  border="0" cellpadding="0" cellspacing="0">
    	           <tr>
    	               <td class="font_size24 font_bold color_gray2">${ctp:toHTML(columnsName)}</td><!-- 我的模板 -->
                       <%--OA-51738  我的模板更多页面，当模板名称比较长时，右边的查询条件和模板配置折行显示了   --%>
                       <%--设置了宽度，就不会折行显示了 --%>
                       <td width="25%" class="padding_r_10" align="right">
                            <input id="searchValue" name="searchValue" value="${searchValue}"/>
                            <input type="hidden" id="fragmentId" name="fragmentId" value="${fragmentId}">
                            <input type="hidden" id="ordinal" name="ordinal" value="${ordinal}">
                            <span class="ico16 search_16" onclick="search()"></span>&#13 &nbsp;&nbsp;
                            <a href="${path }/collTemplate/collTemplate.do?method=showTemplateConfig&category=${category}">${ctp:i18n('template.templatePub.configurationTemplates')}</a><!-- 配置模板 -->
                       </td>
    			   </tr>
    		  </table>
          </form>
	   </td>
    </tr>
    </table>

	<div id="scrollListDiv">
    <c:if test="${v3x:hasPlugin('edoc') && v3x:isEnableEdoc()}">
        <c:if test="${fn:length(faTemplete) != 0}">
            <table  border="0" cellpadding="0" cellspacing="0" align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                      <div class="div-float no-wrap">
                          <!-- 发文模板 -->
                          <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.postingTemplate")}
                          </span>
                      </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${faTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                          <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                          </c:choose>
                          <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=1'});">
                               <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                      <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                          <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                      </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(shouTemplete) != 0}">
            <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                        <div class="div-float no-wrap">
                            <!-- 收文模板 -->
                            <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.receiptTemplate")}
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${shouTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  style="padding-top:0;padding-bottom:5px;" width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=2'});">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(qianTemplete) != 0}">
            <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                        <div class="div-float no-wrap">
                          <!-- 签报模板 -->
                            <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.theyReportTemplate")}
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${qianTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=3'});">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
    </c:if>
    <c:if test="${fn:length(categoryNames) != 0}">
        <c:forEach items="${categoryNames }" var="categoryName">
            <c:set var="templetes" value="${collTempleteCategory[categoryName] }"/>
            <c:if test="${fn:length(templetes) != 0}">
              <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10" >
                      <div class="div-float no-wrap">
                          <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:toHTML(categoryName)}
                          </span>
                      </div>
                    </td>
                </tr>
                <tr> 
                    <c:forEach items="${templetes }" var="templete" varStatus="ordinal">
                      <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="createTitle" value="${templeteName }&#13${templeteCreatorAlt[templete.memberId] }"/>
                            <a title="${createTitle}" class="defaultlinkcss text_overflow" href="javascript:openNewWindow('${templete.id}');"><span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName }</a> 
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
              </table>
            </c:if>
        </c:forEach>
	</c:if>
	<%--信息报送开始--%>
	<c:if test="${fn:length(infoTemplete) != 0}">
        <table border="0" cellpadding="0" cellspacing="0"  align="center" style="table-layout:fixed" class="w100b  padding_l_5  padding_t_10">
            <tr>
                <td colspan="4" class="sortsHead border_b padding_l_10">
                    <div class="div-float no-wrap">
                        <span class="ico16 folder_16"></span>
                        <span class="font_size12 font_bold">
                            	${ctp:i18n('collaboration.info.template.label')}
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <c:forEach items="${infoTemplete }" var="templete" varStatus="ordinal">
                  <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                      <%--开始 --%>
                      <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getSafeLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                       </c:choose>
                      <%--结束--%>
                        <c:if test="${templete.moduleType eq 32}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/info/infomain.do?method=infoReport&listType=listCreateInfo&templateId=${templete.id}">
                        </c:if>
                      <span class="ico16 infoTemplate_16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                  </td>
                  ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                  <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                </c:forEach>
                <c:if test="${i !=0}">
                    <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                        <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                    </c:forTokens>
                </c:if>
            </tr>
        </table>
    </c:if>
    <%--信息报送结束--%>
    <c:if test="${fn:length(personalTempletes) != 0}">
        <table border="0" cellpadding="0" cellspacing="0"  align="center" style="table-layout:fixed" class="w100b  padding_l_5  padding_t_10">
            <tr>
                <td colspan="4" class="sortsHead border_b padding_l_10">
                    <div class="div-float no-wrap">
                        <span class="ico16 folder_16"></span>
                        <span class="font_size12 font_bold">
                            <!-- 个人模板 -->
                            ${ctp:i18n("template.templatePub.personalTemplates")}
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <c:forEach items="${personalTempletes }" var="templete" varStatus="ordinal">
                  <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                      <c:set var="templeteName" value="${templete.subject }"/>
                        <c:if test="${templete.moduleType eq 19}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&edocType=0&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 20}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&edocType=1&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 21}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&edocType=2&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 32}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/info/infocreate.do?method=createInfo&templateId=${templete.id}&action=template">
                        </c:if>
                        <c:if test="${templete.moduleType ne 19 && templete.moduleType ne 20 && templete.moduleType ne 21 && templete.moduleType ne 32}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="javascript:openNewWindow('${templete.id}');">
                        </c:if>
                         <c:if test="${templete.moduleType eq 401}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' target="_blank" onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=1'});">
                        </c:if>
                         <c:if test="${templete.moduleType eq 402}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' target="_blank" onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=2'});">
                        </c:if>
                        <c:if test="${templete.moduleType eq 404}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' target="_blank" onclick="javascript:getCtpTop().openCtpWindow({'url':'${path}/collaboration/collaboration.do?method=newColl&templateId=${templete.id}&app=4&sub_app=3'});">
                        </c:if>
                      <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${v3x:getSafeLimitLengthString(templete.subject,38,"...")}</a>
                  </td>
                  ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                  <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                </c:forEach>
                <c:if test="${i !=0}">
                    <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                        <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                    </c:forTokens>
                </c:if>
            </tr>
        </table>
    </c:if>
    </div>
</body>
</html>
