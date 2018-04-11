<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>


<%-- 写到header.jsp中去 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"  var="v3xEdocI18N"/>
<html:link renderURL='/permission/permission.do' var="perm"/>
<html:link renderURL='/edocController.do' var='edoc' />
<html:link renderURL='/edocElement.do' var='edocElement' />
<html:link renderURL='/edocForm.do' var='edocForm' />
<html:link renderURL='/exchangeEdoc.do' var="exchange" />
<html:link renderURL='/edocDocTemplate.do' var="edocTemplate" />
<html:link renderURL='/edocOpenController.do' var="edocOpenController" />
<html:link renderURL='/edocMark.do' var="mark" />
<html:link renderURL="/edocObjTeamController.do" var="edocObjTeamUrl" />
<html:link renderURL="/edocKeyWordController.do" var="edocKeyWordUrl" />
<html:link renderURL="/metadata.do" var="metadataMgrURL" />
<html:link renderURL="/edocCategoryController.do" var="edocCategoryController" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

var innerMarkUrl="${mark}?method=setInnerMarkDefPage";
//-->

// interval obj
var oMarqueen;
// 移动间隔时间
var iInterval = 10;
// 点击一次移动距离
var iSubLength = 72;
// 移动步长
var iStep = 9;
// 初始化
function left(){
	clearInterval(oMarqueen);
	iSubLength = 100;
	oMarqueen = setInterval(MarqueeLeft, iInterval);
}

function right(){
	clearInterval(oMarqueen);
	iSubLength = 100;
	oMarqueen = setInterval(MarqueeRight, iInterval);
}

// 左移函数
function MarqueeLeft() {
	if (document.getElementById('menuTabDiv').offsetWidth
			- document.getElementById('scrollborder').scrollLeft >= 0) {
		iSubLength -= iStep;
		if (iSubLength >= 0) {
			document.getElementById('scrollborder').scrollLeft += iStep
		}
	}
}
// 右移函数
function MarqueeRight() {
	if (document.getElementById('scrollborder').scrollLeft >= 0) {
		iSubLength -= iStep;
		if (iSubLength >= 0) {
			document.getElementById('scrollborder').scrollLeft -= iStep
		}
	}
}
function initTabs(){
	if(parseInt(document.getElementById('menuTabDiv').clientWidth)>parseInt(document.getElementById('main-table').clientWidth)){
    	document.getElementById('left-td').className='cursor-hand show';
    	document.getElementById('right-td').className='cursor-hand show';
	}
}

isLocationOnLoad = true;
function initPage() {
	isLocationOnLoad = false;
	showEdocLocation();
}

function setDefaultTab_Edoc(pos) {
	var menuDiv = document.getElementById("menuTabDiv");
	var divs = menuDiv.getElementsByTagName("div");
	var index = 1;
	divs[pos*4+index].className = divs[pos*4+index].className+"-sel";
	divs[pos*4+1+index].className = divs[pos*4+1+index].className+"-sel";
	divs[pos*4+2+index].className = divs[pos*4+2+index].className+"-sel";
	var detailIframe = document.getElementById('detailIframe').contentWindow;
	detailIframe.location.href = divs[pos*4+1+index].getAttribute('url');
}

//公文模板新建页面中，点了其他页签，弹出是否离开当前页面，这时其他页签已经变为选中状态了
//如果选择取消，调用该方法将模板管理设置为选中状态
function changeMenuTabBack()
{
  var menuDiv=document.getElementById("menuTabDiv");
  var clickDiv = document.getElementById("firstTab");

  var clickDivStyle=clickDiv.className;
  if(clickDivStyle=="tab-tag-middel-sel"){return;}
  var divs=menuDiv.getElementsByTagName("div");
  var i;
  for(i=0;i<divs.length;i++)
  {    
    clickDivStyle=divs[i].className;    
    if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
    {       
        divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
    }       
  }
  for(i=0;i<divs.length;i++)
  {
        if(clickDiv==divs[i])
        {
          divs[i-1].className=divs[i-1].className+"-sel";
          divs[i].className=divs[i].className+"-sel";
          divs[i+1].className=divs[i+1].className+"-sel";
        }    
  }
}

</script>
<%-- 写到header.jsp中去 --%>
</head>
<body srcoll="no" style="overflow: hidden;border:0;" class="tab-body" onload="setDefaultTab_Edoc(0);onLoadLeft();initPage();" onunload="unLoadLeft()">
<c:set value="${v3x:hasPlugin('edoc')?2:5}" var="directId"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag" style="">
		<table width="100%" id="main-table" cellpadding="0" cellspacing="0" style='table-layout:fixed'>
			<tr>
				<td width='23' valign="bottom" id="left-td" class="cursor-hand hidden">
					<div class='mxt_to_left' id='oMxtToLeft'  onclick="left()">
					</div>
				</td>
				<td style="padding: 0; margin: 0">
					<div id='scrollborder' style='overflow:hidden; height: 26px;width:100%;padding: 0; margin: 0'>
						<div id="menuTabDiv" class="div-float" style="word-break:keep-all;white-space:nowrap; width: auto">
							
							<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							
							<!-- 公文模板 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div id="firstTab" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="<html:link renderURL='collTemplate/collTemplate.do?method=templateSysMgr&categoryType=${!empty param.categoryType ? v3x:toHTML(param.categoryType) : 4}' />"><fmt:message key='menu.edoc.templateManager'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
							<!-- 节点权限 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${perm}?method=list&category=edoc"><fmt:message key='menu.edoc.auth'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
							<!-- 文号管理 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<html:link renderURL='/edocMark.do?method=listMain&companyId=${sessionScope["com.seeyon.current_user"].loginAccount}' var='tempChangeTabURL'/>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${tempChangeTabURL}"><fmt:message key='menu.edoc.wordNoManager'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;" url="dd"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
							<!-- <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							
							<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);" url="${mark}?method=setInnerMarkDefPage"><fmt:message key='edoc.docmark.inner.title' bundle="${v3xEdocI18N}" /></div>
							<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;" url="dd"></div>
							<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							-->
							
							<!-- 
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${edocElement}?method=listMain"><fmt:message key='menu.edoc.property.setup'/></div>
							<div class="tab-tag-right"></div>
							
							<div class="tab-separator"></div>
							-->
							
							<!-- 文单定义 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocForm}?method=listMain"><fmt:message key='menu.edoc.doc.Form'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							<c:if test="${v3x:getSystemProperty('edoc.hasEdocCategory') }">
							<!-- 发文种类 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocCategoryController}?method=listMain"><fmt:message key='edoc.category.send'  bundle='${v3xEdocI18N}'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							</c:if>
							<!-- 套红模板 -->
							<%-- <%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("officeOcx")){ %> --%>
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocTemplate}?method=listMain"><fmt:message key='menu.edoc.edocdoctemplate'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							<%-- <%}%> --%>
							
							<c:if test="${isGroupVer=='false'}">
							</c:if>
							
							<!-- 公文元素 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocElement}?method=listMain"><fmt:message key='menu.edoc.property.setup'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
							<!-- 外部单位 -->
							<c:if test="${v3x:hasPlugin('edoc')}">
								<span class="resCode" resCodeParent="F07_edocSystem">
									<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
									<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${exchange}?method=listMain&modelType=outerAccount"><fmt:message key='menu.edoc.exchangeAccount'/></div>
									<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
									<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								</span>
							</c:if>
							
							<!-- 机构组 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocObjTeamUrl}?method=listMain"><fmt:message key='menu.edoc.ogrTeam'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
							<!-- 公文发起权 -->
							<%--5.0取消公文发起权，由组织模型统一控制角色权限
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocOpenController}?method=showEdocSendSet"><fmt:message key='menu.edocCreateAcc.label' bundle='${v3xEdocI18N}'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
			                --%>
							<!-- 公文开关 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocOpenController}?method=showEdocOpenSet"><fmt:message key='menu.edoc.edocSwitchSet.label' bundle='${v3xEdocI18N}'/></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>	
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>	
							</span>
							
							<!-- 公文开关 -->
							<span class="resCode" resCodeParent="F07_edocSystem">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="${edocKeyWordUrl}?method=listMain"><fmt:message key='menu.edoc.keyword.label' bundle='${v3xEdocI18N}' /></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							
						</div>
						
						<!-- 当前位置 -->
						<%@ include file="currentLocation.jsp" %>
						
					</div>
				</td>
				<td width='23' align="right" valign="bottom" class="cursor-hand hidden" id="right-td"><div class='mxt_to_right' id='oMxtToRight' onclick="right()"></div></td>
			</tr>
		</table>

		</td>
		
	</tr>
	<!-- 
	<tr>
		<td height="26" class="tab-operate-bg" width="100%">
			<a href="<html:link renderURL='/collaboration.do?method=statisticsToExcel'/>" class="non-a"><img align="absmiddle" src="<c:url value='/common/images/toolbar/importExcel.gif'/>" width="16" border="0">&nbsp;<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a>
		</td>
	</tr>
	 -->
	<tr>
		<td class="" style="margin: 0px;padding:0px;padding-top: 1px;">
		<iframe id="detailIframe" name="detailIframe" width="100%" height="100%" scrolling="no" frameborder="0" marginheight="0" marginwidth="0"></iframe>		
		</td>
	</tr>
</table>
</body>
</html>