<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<html>
<head>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%
    response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = "http://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>';
  var _isDevelop = <%=isDevelop%>;
</script>
<link rel="stylesheet" href="${path}/common/all-min.css">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
</c:if>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js"></script>
<script type="text/javascript" src="${path}/common/all-min.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-<%=locale%>.js"></script>
<script type="text/javascript" src="${path}/main.do?method=headerjs"></script>
<script type="text/javascript">
$.ctx._currentPathId = '${_currentPathId}';
$.ctx.fillmaps = <c:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
</script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js${ctp:resSuffix()}"></script>

<link href="${ctp_contextPath}/common/content/content.css" rel="stylesheet" type="text/css" />
<script src="${path}/apps_res/print/js/LodopFuncs.js"></script>
<script src="${path}/apps_res/print/js/printerControl.js"></script>
<style>
.header {
	background: #ededed;
}
</style>


<script type="text/javascript">
$(document).ready(function(){  
	  $('#print1').click(function(){
	       printIt(1);
	  });
	  $('#print2').click(function(){
		
	       printIt(8);
	  });
	  $('#print3').click(function(){
	       printIt(7);
	  });
	  $('#print4').click(function(){
	       thisclose();
	  });
	  $('#print5').click(function(){
	       doChangeSize('bigger')
	  });
	  $('#print6').click(function(){
	       doChangeSize('smaller')
	  });
	  $('#print7').click(function(){
	       doChangeSize('self')
	  });
	  if (!$.browser.msie) {
	    $('#print2').hide();
	    $('#print3').hide();
	  }
	});

var LODOP; //声明为全局变量 
function printIt(n){
  var _WebBrowser = document.getElementById('WebBrowser');
  if(n==1){
	  prn1_print();
  }else if(n==7){
	  prn1_preview();
  }else if(n==8){
	  
	  printSetting();
  }else{
    try {
      _WebBrowser.ExecWB(n,1);
    }catch(e){}
  }
}

function CreateOneFormPage(){
	LODOP=getLodop();  
	LODOP.PRINT_INIT("表单打印");
	LODOP.ADD_PRINT_HTM("5","5","360","600",document.getElementById("content_view").innerHTML);
};	

//打印预览
function prn1_preview() {	
	LODOP=getLodop();  
	LODOP.PRINT_INIT("表单打印");
	
	var strFormHtml=document.getElementById("content_view").innerHTML;
	LODOP.ADD_PRINT_HTM("5","5","360","600",strFormHtml);

	LODOP.SET_PRINT_STYLEA(0,"HOrient",3);
	LODOP.SET_PRINT_STYLEA(0,"VOrient",3);
	LODOP.PREVIEW();	
	
	
};
//打印
function prn1_print() {	
	CreateOneFormPage();	
	LODOP.PRINT();	
};
//打印设置
function printSetting() {
    window.open("${ctp_contextPath}/common/print.do?method=printSetting&moduleId=", "_blank", "resizable=0, width=700 , height=500");
}
//------放大缩小
var _currentZoom = 0;
function doChangeSize(changeType){
  var content = document.getElementById("context") ;
  if(changeType == "bigger") {
      thisMoreBig(content);
  }else if(changeType == "smaller"){
      thisSmaller(content);
  }else if(changeType == "self"){
      thisToSelf(content);
  }else if(changeType == "customize"){
      thisCustomize(content) ;
  }
}
function thisMoreBig(content,size){
  if(!size){
    size = 0.05 ;
  }
  zoomIt(content,size);
}
function thisSmaller(content,size){
  if(!size){
    size = -0.05 ;
  }else {
    size = size * -1;
  }
  zoomIt(content,size);
}
function thisToSelf(content){
  zoomIt(content);
}
function thisCustomize(content){
  var print8 = document.getElementById("print8") ;
  
  if(content && print8 && print8.value != "" ){
      if(isNaN(print8.value)){
        alert("${ctp:i18n('common.print.ratio.number.label')}") ;
         return ;
      }
      _currentZoom = 0;
      zoomIt(content, parseFloat(print8.value / 100) - 1);
  }
}
function zoomIt(content,size) {
  if(content){
    if(!size) {
      size = 0;
      _currentZoom = 0;
    }
    _currentZoom = _currentZoom + size;

    if ($.browser.version == '8.0') {
        if(_currentZoom>0){
            $('.body').css('overflow','scroll');
        }else{
            $('.body').css('overflow','auto');
        }
    }
    if(content.style.zoom) {
      content.style.zoom = 1 + _currentZoom ;
    }else {
      $(content).css({"-moz-transform":'scale('+(1+_currentZoom)+')'});
    }
    clearnText() ;
  }
}

function clearnText(){
    var print8 = document.getElementById("print8") ;
    var context = document.getElementById("content_view") ;
    if(print8 &&  context){
      var size = 1+_currentZoom;
      print8.value = parseInt(size * 100);
    }
    //_currentZoom = 0;
}

//------放大缩小

	function thisclose(){
	    if(!window.close()){
	    //如不能正常关闭，则调用IE的关闭命令
	       printIt(45);
	    }
	}


</script>
<title>高级打印</title>
</head>
<body onkeydown="_keyDown()" >
	<div id="header" class="header">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding-left: 10px;">
				<a id="print1" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('print.label')}</a>
				<a id="print2" class="common_button common_button_gray"	href="javascript:void(0)">${ctp:i18n('print.setting.label')}</a>
				 <a id="print3" class="common_button common_button_gray"	onc>${ctp:i18n('print.preview.label')}</a> <a
					id="print4" class="common_button common_button_gray"
					href="javascript:void(0)">${ctp:i18n('print.close.label')}</a>
					<div class="margin_t_5 margin_b_5 font_size12"
						id="_showOrDisableButton">
						<a id="print5" class="common_button common_button_gray"
							href="javascript:void(0)">${ctp:i18n('person.format.bigger')}</a>
						<a id="print6" class="common_button common_button_gray"
							href="javascript:void(0)">${ctp:i18n('person.format.smaller')}</a>
						<a id="print7" class="common_button common_button_gray"
							href="javascript:void(0)">${ctp:i18n('person.format.self')}</a> <span
							class="margin_l_5">${ctp:i18n('person.format.size')}：</span><input
							type=text id="print8"
							style="border: 1px #b6b6b6 solid; height: 24px; width: 30px;"
							value="100" onblur="doChangeSize('customize')" />%
					</div></td>
				<td style="padding-right: 10px;">
					<div id="checkOption"
						class="common_checkbox_box clearfix align_right"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="content_view" class="content_view" style="background: #FFF;">
<%@ include
			file="/WEB-INF/jsp/common/content/include/include_variables.jsp"%><%--必要的JS变量--%>
		<c:if test="${contentList[0].contentType==20}">
			<div id="mainbodyDiv" class="mainbodyDiv"
				style="background: #FFF; line-height: normal;">
				<%@ include
					file="/WEB-INF/jsp/common/content/include/include_changeModel.jsp"%><%--切换查看模式区域--%>
		</c:if>
		<c:if test="${contentList[0].contentType!=20}">
			<div id="mainbodyDiv" class="mainbodyDiv h100b">
		</c:if>
		<%@ include
			file="/WEB-INF/jsp/common/content/include/include_mainbody.jsp"%><%--正文区域--%>
	</div>
	<c:if test="${contentCfg.useWorkflow}">
		<jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" /><%--工作流相关--%>
	</c:if>
	<%@ include
		file="/WEB-INF/jsp/common/content/include/include_html_hw.jsp"%><%--HTML签章相关--%>
	<script type="text/javascript">
		var content = {};
		content.contentType = "${contentList[0].contentType}";
		content.moduleType = "${contentList[0].moduleType}";
		content.style = "${style}";
	</script>
	<script type="text/javascript"
		src="${ctp_contextPath}/common/content/content_js_end.js${ctp:resSuffix()}"></script>
	<%if(request.getParameter("isFullPage")!=null){ %>
	
</body>
</html>
<%} %>