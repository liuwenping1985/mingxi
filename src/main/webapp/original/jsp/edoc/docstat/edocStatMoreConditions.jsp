<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">

<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<script type="text/javascript">
//OA-31512  公文统计栏目，进入更多页面，删除一个记录，提示空白。  
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/edoc/js/i18n");

<!--	
function del(id){
  if(!confirm(edocLang.edoc_sureto_delete)){
    return;
  }
  var url = '<c:url value="/edocStat.do?method=delEdocStat&columnsName=${columnsName}"/>';
  location.href=url+"&id="+id;
}
	
function openDetail(id){
  var url = '<c:url value="/edocStat.do?method=openEdocStat"/>';
  url = url + "&id="+id;
  
  window.openDetailWin = getA8Top().$.dialog({
      title:'<fmt:message key='edoc.statistical.results'/>',
      transParams:{'parentWin':window},
      url: url,
      targetWindow:getA8Top(),
      width:"1200",
      height:"700"
  });
}	
	
function search(){
  searchForm.submit();
}

function returnFirst(){
  getA8Top().back();
}
//-->
</script>
</head>
<body scroll="no">

        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr height="35">
                <td>&nbsp;
                <span class="left page2-header-bg">
                    <%-- <fmt:message key='edoc.stat.label'/> --%>
                    ${columnsName}
                </span></td>
                <td>
                    <div class="div-float-right" style="margin-right:10px;">
                        <div class="div-float">
                            <%--
                            <a href="#" onclick="returnFirst();"><span class="ico16 home_16"></span></a>
                             --%>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td>
                    <form action="<c:url value="/edocStat.do?method=getEdocStatConditions"/>" name="searchForm" id="searchForm" method="post">
                    <div class="div-float-right">
                        <div class="div-float">
                         <input type="text" name="subject" value="${v3x:toHTML(param.subject)}"/>
                         <input type="hidden" name="columnsName" value="${columnsName }"/>
                        </div>
                                    
                        <div onclick="javascript:search();" class=" div-float condition-search-button"></div>       
                    </div>     
                    </form>
                </td>
            </tr>
        </table>  
        
        <table  border="0" cellpadding="0" cellspacing="0" align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
       <tr>
           <c:forEach items="${list }" var="model" varStatus="ordinal">
               <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                 <a title="" class='defaulttitlecss' href="javascript:openDetail('${model.stat.id}');">
                      <span class="ico16 official_statistics_16"></span>&nbsp;${ctp:toHTML(model.stat.title)}</a>
                  <span style="margin-bottom: 2px;" title="<fmt:message key='edoc.form.deleteform'/>" class="ico16 affix_del_16" onclick="del('${model.stat.id}')"></span>      
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


</body> 
</html>

