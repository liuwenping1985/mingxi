<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%-- 写到header.jsp中去 --%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/govdoc/css/govdocPendingMain.css${v3x:resSuffix()}" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<!-- <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js" />"></script> -->
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
function toAllTabMenu(pos) {
	var menuDiv = document.getElementById("menuTabDiv");
	var divs = menuDiv.getElementsByTagName("div");
	var index = 1;
	if(divs[pos*4+index].className.indexOf("-sel")>0){
		return;
	}

	for (var i = 0; i < divs.length; i++) {
		clickDivStyle = divs[i].className;
		if (clickDivStyle.substr(clickDivStyle.length - 4) == "-sel") {
			divs[i].className = clickDivStyle.substr(0,
					clickDivStyle.length - 4);
		}
	}
	divs[1].className = divs[1].className+"-sel";
	divs[2].className = divs[2].className+"-sel";
	divs[3].className = divs[3].className+"-sel";
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
function addColumn(){
	var dialog = $.dialog({
         targetWindow:getCtpTop(),
         // url:"/seeyon/addPage.jsp",
         url:"${path}/govDoc/govDocController.do?method=listConfig",
         width: 570,
          //height: 300,
          title:'分类配置',
          buttons: [{
              id : "btn1",
              btnType:"1",
              text: "确定", //确定
              handler: function () {
            	  var rv=dialog.getReturnValue();
                  if(rv!=0&&rv!=null&&rv!=""){
                	  rv.jsonSubmit({
              			callback:function(data){
                		  reg = /^t,.+,.+$/;
                		 if(data=="false"){
            					 alert("分类名字不能重复！");
           				 }else if(data != ""&&!reg.test(data)){
           					alert("添加失败，请稍后重试！");
               			 }else{
               				location.reload();
                   			/* var array = data.split(",");
                   			var resCodeId = array[1];
                   			var resCodeName = array[2];
               				dialog.close();
               				var add_columnDiv = $("#add_column");
               				add_columnDiv.before("<span class=\"resCode\" style=\"display: inline;\" resCodeParent=\"F07_edocSystem\"><div class=\"tab-tag-left\" style=\"clear: right; white-space: nowrap; word-break: keep-all;\"></div><div class=\"tab-tag-middel\" id=\"firstTab_" + resCodeId + "\" style=\"clear: right; white-space: nowrap; position: relative; word-break: keep-all;\" onclick=\"javascript:changeMenuTab(this);showEdocLocation();\" url=\"/seeyon/govDoc/govDocController.do?method=listPending&amp;app=4&amp;sub_app=1,2,4&amp;listCfgId=" + resCodeId + "\">" + resCodeName + "<span title=\"删除\" class=\"ico16 canceled_16\" style=\"top: 0px; right: 0px; display: none; position: absolute;\" onclick=\"label_click('" + resCodeId + "')\"></span></div><div class=\"tab-tag-right\" style=\"clear: right; white-space: nowrap; word-break: keep-all;\"></div><div class=\"tab-separator\" style=\"clear: right; white-space: nowrap; word-break: keep-all;\"></div></span>");
               				showIcon(); */
               			 }
              			 }
              		 });
                 //
                  }

              }
          }, {
              text:"取消", //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
}

$(document).ready(function(){
	showIcon();
})

function showIcon(){
	$(".tab-tag-middel").hover(function() {
		$(this).find("span").show();

	}, function() {
		$(this).find("span").hide();
	});
}

function label_click(v, evt){
	$("#firstTab_"+v).attr("url","");
	var e = evt ? evt : window.event;
	$.ajax({ url: "${path}/govDoc/govDocController.do?method=deleteGovdocListConfig&govdocListConfigId="+v, success: function(
			){
		//window.location.reload(true);
		$("#firstTab_"+v).parent().remove();
		//return false;
      }});
    //组织冒泡事件strat
	if ( e &&  e.stopPropagation){
		 e.stopPropagation();
   }
   else{
   	 e.cancelBubble=true;
   }
	//组织冒泡事件end
}
</script>
<%-- 写到header.jsp中去 --%>
</head>
<body srcoll="no" style="overflow: hidden;border:0;" class="tab-body" onload="setDefaultTab_Edoc(0);onLoadLeft();initPage();" onunload="unLoadLeft()">
<c:set value="${v3x:hasPlugin('edoc')?2:5}" var="directId"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
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

							<!-- 全部 -->
							<c:forEach var="list" items="${govdocPendingAll}" varStatus="status">
							<c:if test="${list eq 1 && status.index==0}">
							<span class="resCode" resCodeParent="F20_govdocPending">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div id="firstTab" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="<html:link renderURL='/govDoc/govDocController.do?method=listPending&app=4&sub_app=1,2,3,4' />">全部</div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							</c:if>
							<c:if test="${list eq 1 && status.index==1}">
							<span class="resCode" resCodeParent="F20_govdocPending">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div id="firstTab" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="<html:link renderURL='/govDoc/govDocController.do?method=listPending&app=4&sub_app=1,2,3,4&listCfgId=daiban' />">${ctp:i18n('edoc.stat.result.list.pending')}</div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							</c:if>
							<c:if test="${list eq 1 && status.index==2}">
							<span class="resCode" resCodeParent="F20_govdocPending">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div id="firstTab" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="<html:link renderURL='/govDoc/govDocController.do?method=listPending&app=4&sub_app=1,2,3,4&listCfgId=daiyue' />">${ctp:i18n('edoc.element.receive.reading')}</div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							</c:if>
							</c:forEach>
							<c:forEach var="list" items="${permissionL}" varStatus="status">
							<c:if test="${list.name ne 'govdoc.pending.all'}">
							<span class="resCode" resCodeParent="F20_govdocPending">
								<div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div id="firstTab_${list.id}" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;position:relative;" onclick="javascript:changeMenuTab(this);showEdocLocation();" url="<html:link renderURL='/govDoc/govDocController.do?method=listPending&app=4&sub_app=1,2,3,4&listCfgId=${list.id}' />">${fn:escapeXml(list.name)}<span class="ico16 canceled_16" style="position:absolute;top:0;right:0; display:none" title="删除" onclick="label_click('${list.id}', event)"></span></div>
								<div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
								<div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
							</span>
							</c:if>
									</c:forEach>
							<div id="add_column" title="新增" onclick="addColumn()">+</div>

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
	<tr>
		<td class="" style="margin: 0px;padding:0px;padding-top: 1px;">
		<iframe id="detailIframe" name="detailIframe" width="100%" height="100%" scrolling="no" frameborder="0" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
</table>
</body>
</html>