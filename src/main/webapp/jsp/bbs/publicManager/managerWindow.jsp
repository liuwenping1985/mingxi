<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><fmt:message key="publicManager.info.menu.manager" /></title>
<html:link renderURL="/bulData.do" var="urlBul" />
<html:link renderURL="/newsData.do" var="urlNews" />
<html:link renderURL="/inquirybasic.do" var="urlInquiryBasic" />
<html:link renderURL='/bbs.do' var="bbs" />
<script type="text/javascript">
var urlBul = "${urlBul}";
var urlNews = "${urlNews}";
var urlInquiryBasic = "${urlInquiryBasic}";
var urlBbs = "${bbs}";
var selected = false;
function select(selectMenu){
  if(selectMenu.id=='bbs'){  
  	if('${bbsMenu}' == 'false')
  		return;
  
    document.getElementById("inquiry").background = "";
    document.getElementById("bulletin").background = "";
    document.getElementById("news").background = "";
    if('${custom}' == 'true'){
    	window.returnValue = urlBbs + "?method=listArticleMain&where=space&dept=dept&custom=true&boardId=${spaceId}";
    }else{
    	window.returnValue = urlBbs +"?method=listAllBoard&where=space&group=${groupFlag}&spaceType=${spaceType}&spaceId=${spaceId}";
    }
  }else if(selectMenu.id=='inquiry'){
    	if('${inqMenu}' == 'false')
  		return;
  
    document.getElementById("bbs").background = "";
    document.getElementById("bulletin").background = "";
    document.getElementById("news").background = "";
	if('${custom}' == 'true'){
		window.returnValue = urlInquiryBasic + "?method=survey_index&where=space&surveytypeid=${spaceId}&group=&mid=mid&custom=true"; 
    }else{
    	window.returnValue = urlInquiryBasic +"?method=getAuthoritiesTypeList&where=space&group=${groupFlag}&spaceType=${spaceType}&spaceId=${spaceId}";
    }
  }else if(selectMenu.id=='bulletin'){
    	if('${bulMenu}' == 'false')
  		return;
  
    document.getElementById("bbs").background = "";
    document.getElementById("inquiry").background = "";
    document.getElementById("news").background = "";  
    if('${groupFlag}' == 'true')
    	window.returnValue = urlBul +"?method=listBoard&where=space&spaceType=0";
    else if('${customSpace}' == 'true')
    	window.returnValue = urlBul +"?method=listBoard&where=space&spaceType=${spaceType}&spaceId=${spaceId}";
    else if('${custom}' == 'true')
    	window.returnValue = urlBul + "?method=listMain&where=space&spaceType=4&type=${spaceId}";
    else
    	window.returnValue = urlBul + "?method=listBoard&where=space&spaceType=1";
  }else if(selectMenu.id=='news'){
    	if('${newsMenu}' == 'false')
  		return;
  
    document.getElementById("bbs").background = "";
    document.getElementById("inquiry").background = "";
    document.getElementById("bulletin").background = ""; 
    
    if('${groupFlag}' == 'true')
    	window.returnValue = urlNews +"?method=listBoard&where=space&spaceType=0"; 
    else if('${customSpace}' == 'true')
    	window.returnValue = urlNews +"?method=listBoard&where=space&spaceType=${spaceType}&spaceId=${spaceId}";
    else if('${custom}' == 'true')
		window.returnValue = urlNews + "?method=listBoardIndex&where=space&spaceType=${spaceType}&newsTypeId=${spaceId}&custom=true";
    else
		window.returnValue = urlNews + "?method=listBoard&where=space&spaceType=1";
  } 
    selectMenu.background = "<c:url value='/apps_res/publicManager/images/bj.gif'/>";   
}

function submit_myselect(){
  if(!window.returnValue){
  		alert('<fmt:message key="publicManager.select.menu.header"/>');
  		return;
  }
  selected = true;
  window.close();
}

function concel_myselect(){
  window.returnValue = null;
  window.close();
}

function onCloseWin(){
  if(selected == true){
    window.close();
  }else{
    window.returnValue = null;
    window.close();
  }  
}

</script>

</head>
<body scroll="no" onkeydown="listenerKeyESC()" onunload="onCloseWin()">
<c:if test="${bulMenu}">
	<c:set value="select(this);submit_myselect()" var="bulClick" />
</c:if>
<c:if test="${inqMenu}">
	<c:set value="select(this);submit_myselect()" var="inqClick" />
</c:if>
<c:if test="${bbsMenu}">
	<c:set value="select(this);submit_myselect()" var="bbsClick" />
</c:if>
<c:if test="${newsMenu}">
	<c:set value="select(this);submit_myselect()" var="newsClick" />
</c:if>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="publicManager.select"/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
<table width="100%" height="100%">
  <tr heitht="45%">
    <td id="bulletin" align="center" onclick="select(this)" style="background-position: center;background-repeat:no-repeat"  ondblclick="${bulClick}">
       <table>
        <tr><td>
        <span class="bulletin_img50" ${v3x:outConditionExpression(bulMenu=='false', 'style="filter: Gray()"', '')}  ></span>
        </td></tr>
        <tr><td><fmt:message key="publicManager.select.menu.bulletin" /></td></tr>
      </table>
    </td>
    <td id="inquiry" align="center" onclick="select(this)" style="background-position: center;background-repeat:no-repeat"  ondblclick="${inqClick}">
      <table>
        <tr><td>
        	 <span class="inquiry_img50" ${v3x:outConditionExpression(inqMenu=='false', 'style="filter: Gray()"', '')}></span>
        </td></tr>
        <tr><td><fmt:message key="publicManager.select.menu.inquiry" /></td></tr>
      </table>
    </td>

        <td id="bbs" height="53%" align="center" style="background-position: center;background-repeat:no-repeat" onclick="select(this)" ondblclick="${bbsClick}">
      <table>
        <tr><td>
         <span class="bbs_img50"  ${v3x:outConditionExpression(bbsMenu=='false', 'style="filter: Gray()"', '')}>
        </span>
        </td></tr>
        <tr><td><fmt:message key="publicManager.select.menu.bss" /></td></tr>
      </table>
    </td>
    <td id="news"  align="center" onclick="select(this)" style="background-position: center;background-repeat:no-repeat"  ondblclick="${newsClick}">      
      <table>
        <tr><td> <span class="news_img50" ${v3x:outConditionExpression(newsMenu=='false', 'style="filter: Gray()"', '')}  ></span>
        </td></tr>
        <tr><td><fmt:message key="publicManager.select.menu.news" /></td></tr>
      </table>
    </td>
  </tr>
</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="submit_myselect()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="concel_myselect()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>