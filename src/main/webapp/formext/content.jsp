<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    boolean isPureHtmlView = "10".equals(request.getParameter("contentType")) && "2".equals(request.getParameter("viewState"));
    if(isPureHtmlView){
        // 表单转协同保留js引用
        java.util.List l = (java.util.List)request.getAttribute("contentList");
        if(l!=null){
            com.seeyon.ctp.common.content.mainbody.CtpContentAllBean content =  (com.seeyon.ctp.common.content.mainbody.CtpContentAllBean) l.get(0);
            if(content!=null && content.getContent()!=null){
	            if(content.getContent().contains("formmain")){
	                isPureHtmlView = false;
	            }
            }
        }
    }
%>
<%--谁再敢再正文组件里，乱写代码，把代码搞的很多，很乱，弄死， 王峰留 --%>
<%if(request.getParameter("isFullPage")!=null){ %>

<%if(isPureHtmlView){ %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<%
    boolean isDevelop = AppContext.isRunningModeDevelop();
	String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
        + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  $.ctx = {};
  $.ctx.disableAutoInit = true;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';

</script>
<script type="text/javascript" src="/seeyon/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/v3x-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/Moo-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/jsonGateway-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.jsonsubmit-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.checkform-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.json-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.print-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.dialog-debug.js"></script>

<script type="text/javascript" src="/seeyon/common/js/jquery.comp-debug.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="/seeyon/main.do?method=headerjs&login=${loginTime}"></script>

<%}else{%>
<%
    request.setAttribute("editor.enabled","true");
    java.util.List l = (java.util.List)request.getAttribute("contentList");
    if(l!=null){
        com.seeyon.ctp.common.content.mainbody.CtpContentAllBean content =  (com.seeyon.ctp.common.content.mainbody.CtpContentAllBean) l.get(0);
        if(content!=null && 20 == content.getContentType()){
            request.setAttribute("editor.enabled","true");
        }
    }
%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%}%>
<script type="text/javascript" src="/seeyon/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/office/license.js${ctp:resSuffix()}"></script>

<%--引入正文内容展现扩展js文件 --%>
<c:if test="${mainBodyDisplayJSPath ne null and  mainBodyDisplayJSPath ne ''}">
	<script type="text/javascript" src="${mainBodyDisplayJSPath}${ctp:resSuffix()}"></script>
</c:if>
<%--引入页面加载默认执行的js方法 --%>
<script type="text/javascript">
	$(function(){
	    _bodyOnLoad();
	});

	function _bodyOnLoad(){
		<c:if test="${mainBodyOnloadMethodName ne null}">
			var onLoadFun = ${mainBodyOnloadMethodName};
			if(typeof(onLoadFun) == "function"){
				onLoadFun();
			}
		</c:if>
	}
</script>
<html>
<head>
<script>
function GetRequest(url) {

   var url = url||location.search; //获取url中"?"符后的字串

   var theRequest = {};

   if (url.indexOf("?") != -1) {

      var str = url.substr(1);

      strs = str.split("&");

      for(var i = 0; i < strs.length; i ++) {

         theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);

      }

   }

   return theRequest;

}
function valuePass(recordId,txt,level){

	var p = $("tr[recordId="+recordId+"]");
	if(p.length>0){
		//console.log(p.find("span[name=field0008]"));
		var targetNode = p.find("input[name=field0007]");

		targetNode.val(txt);
		targetNode.blur()
		//console.log(targetNode.parent().attr("fieldval"));
			//console.log($.parseJSON);
			var val = $.parseJSON(targetNode.parent().attr("fieldval"));
			val.value=txt;
			targetNode.parent().attr("fieldval",JSON.stringify(val));
			//console.log(JSON.stringify);
			var levelNode = p.find("input[name=field0008]");
			levelNode.val(level);
			levelNode.blur();
			var val2 = $.parseJSON(levelNode.parent().attr("fieldval"));
			val2.value=level;
			levelNode.parent().attr("fieldval",JSON.stringify(val2));
	}

}
function clickMe(loginName,recordId){

	var _url = "/seeyon/form/extform.do?method=openPersonAffairLink&linkTplIds=-4679650058905172061,-3220873770960730919,-640281432140132614&oaLoginName="+loginName;
	$.get(_url,function(data){
		if(data.result){
			var afId = data.affairId;
			window.open("/seeyon/collaboration/collaboration.do?method=summary&fromjixiao=true&recordId="+recordId+"&openFrom=listPending&affairId="+afId);
		}else{
			if(data.reason == "AFFAIR_NOT_FOUND"){

				alert("该员工的绩效表单没有找到,请联系被考核人");
			}else{

				alert(data.reason);
			}
		}

	})
}
$(document).ready(function(){
	var p = window.parent;
	if(p){
		var pp = p.parent;
		if(pp){
			///seeyon/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId=4369223031188048854
			var params = GetRequest(pp.location.search);
			var _url = "/seeyon/form/extform.do?method=checkFormIsOk&affairId="+params["affairId"]+"&tplId=4369223031188048854";
			$.get(_url,function(data){
				  if(data.result){
					var fields = $("span[name=field0011]");
	                var names = [];
	                $.each(fields,function(index,item){
						var pNode = $(item).parent().parent().parent().parent().attr("recordid");
						//console.log(pNode);
		            $(item).html("<a onclick='clickMe(\""+$(item).html()+"\",\""+pNode+"\")'>考核评价链接</a>");
	              });
				}else{

					if(params.fromjixiao=="true"){

					}

				}
				//console.log(data);
			})
		}
	}



});
</script>
<link href="/seeyon/common/content/content.css${ctp:resSuffix()}" rel="stylesheet" type="text/css" />
    <c:if test="${param.contentType ne 20}">
        <!-- 修改编辑内容后，文本样式缺失的问题  -->
        <link href="/seeyon/common/all-min.css${ctp:resSuffix()}" rel="stylesheet" type="text/css" />
    </c:if>
<title></title>
</head>
<body onkeydown="_keyDown()" onload="_bodyOnLoad();" <c:if test="${contentList[0].contentType==20}">style="background:#FFF;"</c:if>>
<div id="bodyBlock" class=" content_view " style="background:#FFF;">
<%}%>
<%if(request.getParameter("isFullPage")==null){ %>
<script type="text/javascript" src="/seeyon/common/isignaturehtml/js/isignaturehtml.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/office/js/hw.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/office/license.js${ctp:resSuffix()}"></script>
<%}%>
<%@ include file="/WEB-INF/jsp/common/content/include/include_variables.jsp"%><%--必要的JS变量--%>
<c:if test="${contentList[0].contentType==20}">
        <div id="mainbodyDiv" class="mainbodyDiv" style="background:#FFF;line-height:normal;">
        <%@ include file="/WEB-INF/jsp/common/content/include/include_changeModel.jsp"%><%--切换查看模式区域--%>
</c:if>
<c:if test="${contentList[0].contentType!=20}">
    <div id="mainbodyDiv" class="mainbodyDiv clearfix ${contentList[0].contentType!=10 ? 'h100b' : ''}" >
</c:if>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_mainbody.jsp"%><%--正文区域--%>
</div>
    <c:if test="${contentCfg.useWorkflow}">
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" /><%--工作流相关--%>
    </c:if>
	    <%@ include file="/WEB-INF/jsp/common/content/include/include_html_hw.jsp"%><%--HTML签章相关--%>
    <script type="text/javascript">
        var content = {};
        content.contentType = "${contentList[0].contentType}";
        content.moduleType = "${contentList[0].moduleType}";
        content.style = "${style}";
        hasDealArea = "${param.hasDealArea}";
        var resend = "${resend}";
    </script>
    <script type="text/javascript" src="/seeyon/common/content/content_js_end.js${ctp:resSuffix()}"></script>
<%if(request.getParameter("isFullPage")!=null){ %>
</div>
</body>
</html>
<%} %>
<%--谁再敢再正文组件里，乱写代码，把代码搞的很多，很乱，弄死， 王峰留 --%>
