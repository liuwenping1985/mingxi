<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.webmail.resources.i18n.WebMailResources" var="v3xMailI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"  var="v3xDocI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Result Page</title>

<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="<c:url value="/skin/${CurrentUser.skin}/skin.css" />">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css" />">
</c:if>
<link href="<c:url value="/apps_res/index/css/searchresult.css${v3x:resSuffix()}" />" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/index/js/searchresult.js${v3x:resSuffix()}" />"></script>
<html:link renderURL='/index/indexController.do' var='indexURL'/>
<script Language="JavaScript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/index/js/i18n/");


//getA8Top().hiddenNavigationFrameset();
//getA8Top().showLocation(null, "<fmt:message key='menu.index' bundle="${v3xMainI18N}" />");

 var keyword="${v3x:escapeJavascript(keyword)}";
 var accessoryName = "${v3x:escapeJavascript(accessoryName)}";
  var str = "${indexURL}"+"?method=searchAll&keyword="+encodeURIComponent(keyword)+"&accessoryName="+encodeURIComponent(accessoryName)+"&iframeSearch=iframeSearch" + "&_appCategory=" + "${_appCategory}";
  String.prototype.trim=function(){   
        return this.replace(/(^(\s|\*)*)|(\s*$)/g, "");    
    } 
    function IsNull(value){    
        if(value.length==0){    
            return true;   
        }
        return false;
    }

function searchAction(){

    var ids = document.getElementsByName("library");
    var selectCount = 0;
    for(var i = 0; i < ids.length; i++){
        if(ids[i].checked){
            selectCount++;
        }
    }
    if(selectCount <= 0){
        alert(v3x.getMessage("indexLang.indexquery_selectone_type"));
                return false;
    }
    var keyword=document.getElementById("kword").value.trim();
    var accessoryName=document.getElementById("accessoryName").value.trim();
    var author=document.getElementById("author").value.trim();
    var title=document.getElementById("title").value.trim();
    document.getElementById("kword").value = keyword;
    document.getElementById("accessoryName").value = accessoryName;
    document.getElementById("author").value =author;
    document.getElementById("title").value =title;
    if(IsNull(keyword)&&IsNull(author)&&IsNull(title)&&IsNull(accessoryName)){
        alert(getA8Top().v3x.getMessage("V3XLang.index_input_error"));
        return;
    }
    var myform=document.getElementById("form1");
    var beginDate = myform.SEARCHDATE_BEGIN;
    var endDate = myform.SEARCHDATE_END;
    if(beginDate.value !='' && endDate.value !='' && beginDate.value>endDate.value){
        alert(getA8Top().v3x.getMessage("V3XLang.index_input_endDate_less_beginDate"));
        return;
    }
        myform.submit();
       myform.search.disabled=true;
}


//回车执行查询 
function doKeyPressedEvent()
{
   if(event.keyCode==13){
     searchAction();
   }
}
function returnBack(){
      getA8Top().contentFrame.topFrame.back();
    }   

function enableType()
{
     var indextypedocument=document.getElementById("indextype");
     var library=document.getElementsByName("library");
     var display=indextypedocument.style.display;
       if(display==null||display=='')
       {
           indextypedocument.style.display="none";
           for(var i=0;i<library.length;i++)
          {
                var idCheckBox=library[i];
                idCheckBox.disabled=true;
           }
           
       }else{
           indextypedocument.style.display="";
           for(var i=0;i<library.length;i++)
           {
                var idCheckBox=library[i];
                idCheckBox.disabled=false;
           }
            }
}

function selectAll(obj){
    var checkBox = document.getElementsByName("library");
    if(checkBox && checkBox.length>0){
        //alert(checkBox.length +'---------'+ obj.getAttribute('checked'));
        var flag = obj.checked;
        for(var i = 0; i<checkBox.length; i++){
            var temp = checkBox[i];
            if(temp){
                temp.checked = flag;
                //temp.setAttribute('checked',flag);
            }
        }
    }
}
function isChecked(){
    var checkBox = document.getElementsByName("library");
    var flag = true;
    if(checkBox && checkBox.length>0){
        for(var i = 0; i<checkBox.length; i++){
            var temp = checkBox[i];
            if(temp){
                var checkedStr = temp.checked
                if(checkedStr == false){
                    flag = false;
                    break;
                }
            }
        }
    }   
    document.getElementById('allSelect').checked = flag;
}

//-->
var tohtml = "<SPAN class=nowLocation_content><fmt:message key='doc.now.location.PersonalTools' bundle='${v3xDocI18N}'/>" +
    " > <A href=javascript:showMenu('"+
    v3x.baseURL+"/index/indexController.do?method=search')><fmt:message key='index.com.seeyon.v3x.index.jsp.title'/></A></SPAN>"
showCtpLocation("",{html:tohtml});
</script>
${v3x:skin()}
</head>

<body scroll="no" style="padding:0px;margin:0px;" class="bg_color"  onkeydown="doKeyPressedEvent()">
<form action="<html:link renderURL='/index/indexController.do?method=searchAll'/>"  method="post" id="form1" target="dataIFrame">
<input name="iframeSearch" value="iframeSearch" type="hidden"/>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg" id="mainDivId">
<!--  大标题栏 TR -->
  <tr>
    <td  width="100%" valign="top" height="60">
                <div id="searhBarId">            
        <table width="100%" height="60" border="0" cellpadding="0" cellspacing="0" >
          <tr>
            <td align="center" valign="top" style="padding: 5px 5px 5px 5px;">
                
                    <table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right gov_nobackground" style="border:1px solid #cdcdcd;">
                        <tr>
                        	<td width="100" class="sectionTitleLine sectionTitleLineBackground" valign="top" style="padding: 5px;">
                                <span class="searchSectionTitle"><fmt:message key='common.search.condition.label' bundle="${v3xCommonI18N}"/>:</span>
                            </td>
                        </tr>
                        <tr>
                            <td width="100" class="sectionTitleLine sectionTitleLineBackground" valign="top" style="padding: 5px;">
                            </td>
                            <td class="" align="center" style="padding: 5px;">
                            
                                 <table width="700" height="100%" border="0" cellpadding="0" cellspacing="0" class="">
                                     <tr height="25">
                                     <td width="20%" align="right"><fmt:message key="index.com.seeyon.v3x.index.keword"/>:</td>
                                       <td width="20%">
                                          <input type="text" id="kword" name="keyword" value="${v3x:toHTML(keyword)}"  maxlength="40" style="width:200px" />
                                       </td>
                                    
                                       <td width="20%" align="right"><fmt:message key='index.com.seeyon.v3x.index.startUser' />:
                                       </td>
                                        <td width="20%" nowrap="nowrap">
                                         <input type="text" name="author" id="author"  style="width:199px" maxlength="40"/>
                                        </td>
                                         <td width="10%"  style="vertical-align:middle;" align="right" > 
                                         <a onClick="enableType();"  class="link-blue" onmouseOver="javascript:this.className='link-orange'" onmouseOut="javascript:this.className='link-blue'">[<fmt:message key='index.com.seeyon.v3x.index.advance' />]</a>
                                       </td>
                                       <td></td>
                                      </tr>
                                      <tr height="25">
                                       <td width="20%" align="right"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/>:</td>
                                       <td width="20%"><input type="text" name="title" id="title"  style="width:200px" maxlength="40" />
                                       </td>
                                    
                                    
                                       <td width="20%" align="right">
                                        <fmt:message key='index.com.seeyon.v3x.index.strat_end'  />
                                            </td>
                                          <td width="20%" nowrap="nowrap">
                                           <input type="text" style="width:87px" id="SEARCHDATE_BEGIN" name="SEARCHDATE_BEGIN" onClick="whenstart('/seeyon',this,300,340);" value="${SEARCHDATE_BEGIN}" readonly="readonly"/>
                                           <fmt:message key='index.com.seeyon.v3x.index.to'  />
                                            <input type="text" style="width:87px" id="SEARCHDATE_END" name="SEARCHDATE_END" onClick="whenstart('/seeyon',this,300,340);" value="${SEARCHDATE_END}" readonly="readonly"/>
                                         </td>
                                         <td width="20%" align="right"></td>
                                          <td nowrap="nowrap" align="center" width="50" height="40">
                                        </td>
                                     </tr>
                                     <tr height="25">
                                     <td width="20%" align="right">附件名:</td>
                                       <td width="20%">
                                          <input type="text" id="accessoryName" name="accessoryName" value="${v3x:toHTML(accessoryName)}"  maxlength="40" style="width:200px" />
                                       </td>
                                    
                                       <td width="20%" align="right">
                                       </td>
                                        <td width="20%" nowrap="nowrap">
                                         
                                        </td>
                                         <td width="10%"  style="vertical-align:middle;" align="right" > 
                                       </td>
                                       <td></td>
                                      </tr>
                                      <tr height="25" style="display:none;" id="indextype">
                                          <td width="20%" align="right"><fmt:message key="common.type.label" bundle="${v3xCommonI18N}"/>:</td>
                                       <td width="80%" colspan="3"> 
                                            <c:forEach items="${appLibs}" var="lib" varStatus="status">
                <label for="appCheck${lib}"><input id="appCheck${lib}" type="checkbox" name="library" onClick="showMemberDisable();isChecked()" value="${lib}" checked="checked" disabled="disabled" /><fmt:message key='index.application.${lib}.label'/></label>
                                                <c:if test="${status.count%8==0&&status.count!=0}">
                                                        <br>
                                            </c:if>
                
                                            </c:forEach>
                                       </td>
                                       <td align="center">
                                       <label for="allSelect"><input id="allSelect" type="checkbox" onClick="selectAll(this)"  checked="checked" /><fmt:message key='index.select.all.label'/></label>
                                       </td>
                                       <td></td>
                                    </tr>
                                    <tr height="25">
                                    	<td nowrap="nowrap" align="center" width="100%" height="40" colspan="5">
                                            <input type="button" class="deal_btn" onMouseOver="javascript:this.className='deal_btn_over'" onMouseOut="javascript:this.className='deal_btn'" onClick="searchAction()" id="searchBtn" name="search" value="<fmt:message key='index.com.seeyon.v3x.index.search'  />" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
            
            </td>
          </tr>
        </table>
                </div>      
    </td>
  </tr>
  <tr>
    <td valign="top">
    <div class="common_content_area" style="height:100%;border:0;" id="contentAreaId">     
    <c:choose>
    <c:when test="${ empty keyword && empty accessoryName}"> 
    <iframe marginheight="0" marginwidth="0" height="100%" src="<html:link renderURL='/index/indexController.do?method=showNullList'/>" name="dataIFrame" scroll="no" id="dataIFrame" width="100%" frameborder="0"></iframe>
    </c:when>
    <c:otherwise>
    <script>
    <!--
    document.write("<iframe marginheight=\"0\" marginwidth=\"0\" height=\"100%\" src=\""+str+"\" name=\"dataIFrame\" scroll=\"no\" id=\"dataIFrame\" width=\"100%\" frameborder=\"0\"></iframe>");
    //-->
    </script>
    </c:otherwise>
    </c:choose>
    
 </div>
    
    </td>
  </tr>
</table>
 </form>
</body>
</html>
