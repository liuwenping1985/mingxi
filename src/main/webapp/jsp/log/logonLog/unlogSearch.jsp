<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<html>
<head>
<%@include file="logHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
//getA8Top().showLocation(2403);

function doIt(){
    var startDay = document.getElementById("startDay").value;
    var endDay = document.getElementById("endDay").value;
    form1.isExprotExcel.value = "false" ;
    if(startDay != "" && endDay != ""){
        if(compareDate(startDay,endDay)>0){
            alert(v3x.getMessage("LogLang.log_search_overtime"))        
            return false;
        }
    }
    form1.submit();
}

function export2Excel(){
  var formObj = document.getElementById("form1") ;
  if(formObj){
    formObj.target = "targetFrame";
    formObj.isExprotExcel.value = "true" ;
    formObj.submit();
  }
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<%@include file="labelPage.jsp"%>
<tr>
    <td height="20" style="border-right: solid 1px #A4A4A4;">
        <script>    
            var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
            myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:export2Excel()", [2,6], "", null));
            myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:doPrint()", [1,8], "", null));
            document.write(myBar);
            document.close();
        </script>
    </td>
</tr>

<tr>
    <td class="page-list-border-LRD" valign="top">
    <table width="100%" height="100%" border="0" cellspacing="0"
        cellpadding="0">
        <tr>
            <td width="100%" height="40" align="center"
                class="lest-shadow">
            <form method="post" id="form1" action="${logonLog}?method=unlogSearch">
            <input type="hidden" name="isExprotExcel" id="isExprotExcel" value="">
            <b><fmt:message key="logon.templete.branch.search.label" /></b>
                <fmt:message key="logon.search.selectTime"/>:
                <input type="text" name="startDay" id="startDay" class="cursor-hand" value="${startDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
                <fmt:message key="logon.search.to"/>
                <input type="text" class="cursor-hand" name="endDay" id="endDay" value="${endDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
                <input type="button" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="doIt()">
            </form>
            </td>
        </tr>
        <tr height="24">
            <td class="webfx-menu-bar-gray border-top">&nbsp;&nbsp;&nbsp;<fmt:message key="label.mail.search" bundle="${v3xMailI18N}" /></td>
        </tr>
        <tr>
            <td height="100%" valign="top">
            <div class="scrollList" id="dataList">
            <form>
            <v3x:table data="${results}" var="result" htmlId="aaa" isChangeTRColor="true" showHeader="true" showPager="true"  pageSize="20" subHeight="130">
              <v3x:column width="25%" type="String" label="logon.stat.person" maxLength="40" value="${result[1]}" >
                
              </v3x:column>
             
             <c:if test="${v3x:getSysFlagByName('sys_isGroupVer')=='true'}">
              <v3x:column width="20%" label="log.toolbar.title.account" maxLength="40" type="String" value="${result[3]}"/>
             </c:if>                
            <v3x:column width="20%" label="logon.org.post" type="String" maxLength="40" value="${result[2]}" /> 
              
              <c:choose>
                <c:when test="${ result[4]==null}">
                  <v3x:column width="25%" type="String" label="logon.search.lasLogonTime" maxLength="40" value="${v3x:_(pageContext,'logon.noLogRecord')}" />
                </c:when>
                <c:otherwise>
                  <v3x:column width="25%" type="String" label="logon.search.lasLogonTime" maxLength="40">
                    <fmt:formatDate value="${result[4]}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
                  </v3x:column>
                </c:otherwise>
              </c:choose>
              <c:set value="${v3x:getMember(result[0])}" var="user"></c:set>
              <c:choose>
                <c:when test="${user.state == 1}">
                    <v3x:column width="10%" label="logon.search.user.state" type="String" maxLength="40" value="${v3x:_(pageContext,'logon.user.state.1')}" />
                </c:when>
                <c:otherwise>
                    <v3x:column width="10%" label="logon.search.user.state" type="String" maxLength="40" value="${v3x:_(pageContext,'logon.user.state.2')}" />
                </c:otherwise>
              </c:choose>
            </v3x:table>
            </form>
            </div>
            </td>
        </tr>
    </table>
    </td>
    </tr>
</table>
<iframe id="targetFrame" name="targetFrame" width="0" height="0"></iframe>
</body>
</html>