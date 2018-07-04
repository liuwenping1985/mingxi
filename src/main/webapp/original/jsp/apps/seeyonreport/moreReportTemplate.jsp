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
    getCtpTop().hideLocation();
    getCtpTop().showMoreSectionLocation("${columnsName}");
});

function search(){
    $("#searchForm").jsonSubmit();
}
</script>
</head>
<body style="margin-top:0px">
<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
	<form id="searchForm" method="post" action="${path}/seeyonReport/seeyonReportController.do?method=moreReportTemplate&fragmentId=${fragmentId}&ordinal=${ordinal }&columnsName=${ctp:encodeURI(columnsName)}">
      <table border="0" cellpadding="0" cellspacing="0"  class="w100b f0f0f0" align="center">
          <tr>
             <td class="padding_r_10 padding_tb_5" align="right">
                  <input id="searchValue" name="searchValue" value="${searchValue}" type="text"/>
                  <span class="ico16 search_16" onclick="search()"></span>&#13 &nbsp;&nbsp;
             </td>
	   		</tr>
  		</table>
    </form>

	<div id="scrollListDiv">
	  <c:if test="${fn:length(reportTemplates) != 0}">
	        <c:forEach items="${reportTemplates }" var="map">
	        	<c:set var="categoryName" value="${map.key }"/>
	            <c:set var="templates" value="${map.value }"/>
	            <c:if test="${fn:length(templates) != 0}">
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
	                    <c:forEach items="${templates }" var="templete" varStatus="ordinal">
	                      <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%">
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
	                            <c:set var="createTitle" value="${templeteName }&#13${templateCreatorAlt[templete.memberId] }"/>
	                            <a title="${createTitle}" class='defaultlinkcss text_overflow' href="${path }/seeyonReport/seeyonReportController.do?method=redirectSeeyonReport&templateId=${templete.id}"><span class="ico16 text_type_template_16"></span>&nbsp;${templeteShowName }</a> 
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
    </div>
</body>
</html>
