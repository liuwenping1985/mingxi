<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
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
    <link rel="stylesheet" href="${path}/apps_res/template/css/mui.min.css">
    <script type="text/javascript" src="${path}/apps_res/template/js/mui.min.js"></script>
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
    url =  _ctxPath + "/collaboration/collaboration.do?method=newCollForH5&from&templateId="+templateId;
    openCtpWindow({'url':url});
}
</script>
</head>

<body style="margin-top:0px">
<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
<div id="scrollListDiv">
<ul class="mui-table-view mui-table-view-chevron">
<c:if test="${v3x:hasPlugin('edoc') && v3x:isEnableEdoc()}">
        <c:if test="${fn:length(faTemplete) != 0}">
           <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >${ctp:i18n("template.templatePub.postingTemplate")}
            </a>
               <ul class="mui-table-view mui-table-view-chevron">
                    <c:forEach items="${faTemplete }" var="templete" varStatus="ordinal">
					
					<li class="mui-table-view-cell" >
					
                          <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                          </c:choose>
                          <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&edocType=0&templeteId=${templete.id}">
                               <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                       </li>
                    </c:forEach>
					</ul>
                </li>
         
        </c:if>
        <c:if test="${fn:length(shouTemplete) != 0}">
           <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >
		   ${ctp:i18n("template.templatePub.receiptTemplate")}
                   </a>     
                <ul class="mui-table-view mui-table-view-chevron">
                    <c:forEach items="${shouTemplete }" var="templete" varStatus="ordinal">
					 <li class="mui-table-view-cell">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&edocType=1&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                        </li>
                    </c:forEach>
                   </ul>
                
            </li>
        </c:if>
        <c:if test="${fn:length(qianTemplete) != 0}">
           <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >
		   ${ctp:i18n("template.templatePub.theyReportTemplate")}
                   </a>       
                   <ul class="mui-table-view mui-table-view-chevron">
                    <c:forEach items="${qianTemplete }" var="templete" varStatus="ordinal">
					<li class="mui-table-view-cell">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&edocType=2&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                        
						</li>
                    </c:forEach>
                   </ul>
        </li>
        </c:if>
    </c:if>
    <c:if test="${fn:length(categoryNames) != 0}">
        <c:forEach items="${categoryNames }" var="categoryName">
            <c:set var="templetes" value="${collTempleteCategory[categoryName] }"/>
            <c:if test="${fn:length(templetes) != 0}">
             <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >${ctp:toHTML(categoryName)}
                      </a> 
                <ul class="mui-table-view mui-table-view-chevron">
                    <c:forEach items="${templetes }" var="templete" varStatus="ordinal">
					<li class="mui-table-view-cell">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="createTitle" value="${templeteName }&#13${templeteCreatorAlt[templete.memberId] }"/>
                            <a title="${createTitle}" class="defaultlinkcss text_overflow" href="javascript:openNewWindow('${templete.id}');"><span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName }</a> 
                       </li>
                    </c:forEach>
                    </ul>
          </li>
            </c:if>
        </c:forEach>
	</c:if>
	<%--信息报送开始--%>
	<c:if test="${fn:length(infoTemplete) != 0}">
        <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >
                            	${ctp:i18n('collaboration.info.template.label')}
                 </a>    
             <ul class="mui-table-view mui-table-view-chevron">
                <c:forEach items="${infoTemplete }" var="templete" varStatus="ordinal">
				<li class="mui-table-view-cell">
                      <%--开始 --%>
                      <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                       </c:choose>
                      <%--结束--%>
                        <c:if test="${templete.moduleType eq 32}">
                            <a title="${templeteName}" class='defaultlinkcss text_overflow' href="${path}/info/infomain.do?method=infoReport&listType=listCreateInfo&templateId=${templete.id}">
                        </c:if>
                      <span class="ico16 infoTemplate_16 ${templeteIcon[templete.id]}"></span>&nbsp;${templeteShowName}</a>
                  </li>
                </c:forEach>
              </ul>
      </li>
    </c:if>
    <%--信息报送结束--%>
    <c:if test="${fn:length(personalTempletes) != 0}">
       <li class="mui-table-view-cell mui-collapse"><a class="mui-navigate-right" >
                            ${ctp:i18n("template.templatePub.personalTemplates")}
                     </a>
            <ul class="mui-table-view mui-table-view-chevron">
                <c:forEach items="${personalTempletes }" var="templete" varStatus="ordinal">
				 <li class="mui-table-view-cell">
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
                      <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${v3x:getLimitLengthString(templete.subject,38,"...")}</a>
                  </li>
                </c:forEach>
              </ul> 
        </li>
    </c:if>
	
	</ul>
    </div>
</body>
</html>
