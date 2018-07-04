<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html style="height:100%;">
<head>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/summary_topic.js${ctp:resSuffix()}"></script>
<style type="text/css">
	.metadataItemDiv {
		float: left;
		padding-right: 5px;
		font-size: 12px;
		color: black;
	}
	.edoc_deal_table{
		margin:0 -10px;
	}
	.edoc_deal{
		border-top:1px #bebdbd solid;
		border-bottom:1px #bebdbd solid;
	}
</style>
<script type="text/javascript">
<!--
$(function(){
    $("#cc #mainbodyDiv").css("overflow",'visible');
    if("${affair.bodyType}"=='20'){
        try{
            if(getFlowDealOpinion().length>0){
              parent.$("#isHidden").attr("disabled",true);
            } 
        }catch(e){
        }
       $("#cc").css("width",'auto');
    }else if("${affair.bodyType}"=='41' 
        || "${affair.bodyType}"=='42' 
        || "${affair.bodyType}"=='43' 
        || "${affair.bodyType}"=='44' 
        || "${affair.bodyType}"=='45'){
         $("#cc").attr("style",'height:559px;width:100%;margin-bottom:2px;');
         $(".content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
    } else if ("${affair.bodyType}"=='10') {
        $("#cc").css("overflow",'auto');
    }
    $(parent.window.document.getElementById("content_workFlow")).css("visibility","visible");

/*setTimeout(function(){
    var _ccc = document.getElementById('cc');
    var _cccScrollWidth = parseInt(_ccc.scrollWidth);
	var _cccClientWidth = parseInt(_ccc.clientWidth);
    
    if("${affair.bodyType}"=='20'){
        var _htmlWidth = parseInt(document.documentElement.scrollWidth);
        var _bodyWidth = parseInt(document.body.clientWidth);
        if(_bodyWidth<_htmlWidth){
            _ccc.style.width = (_htmlWidth+35)+"px";
        }
    }else{
    	if(_cccScrollWidth>_cccClientWidth){
    		_ccc.style.width = (_cccScrollWidth+35)+"px";
    		$('#display_content_view').width(_cccScrollWidth+35).css("margin","0 auto");
            $(".content_view").css("height","");
    	}
    }
},100);*/

/*function setOfficeHeight() {
    setTimeout(function(){
        try{
        	var docIframe = document.frames["officeTransIframe"].document.frames["htmlFrame"];
        	if ($(docIframe).size() > 0) {
            	var docIframeHeight = docIframe.document.body.clientHeight;
            	$("#cc").css("height",parseInt(docIframeHeight+50)+'px');
            	//Office转换后的正文，当宽度比外层的iframe宽的时候，设置外层iframe的宽度，避免出现滚动条
            	var docIframeWidth=docIframe.document.body.clientWidth;
            	var tableWidth=$("table",docIframe.document).width();
				if(docIframeWidth<tableWidth){
					$("#cc").css("width",parseInt(tableWidth+100)+'px');
				}
        	}
        }catch(e){
            setOfficeHeight(); 
        }
    },300);
}*/

//setOfficeHeight();
infoFormDisplay();
if(parent.openFrom === 'Pending' && parent.affairState === '3'){
	showOpinionsInputForm();
}
//正文加载完毕的时候,关闭加载项
window.parent.colseProce();
});
//var officecanPrint =  parent.officecanPrint;
//var canEdit = parent.canEdit;

/*
 * 文单初始化
 */
function infoFormDisplay(){
	//var xml = document.getElementById("xml");
	//var xsl = document.getElementById("xsl");
	//buttondnois();
	$("#content").val($("#xsl").val());
	if($("#xml").val()!="" && $("#xsl").val()!="") {
		try{
			initSeeyonForm($("#xml").val(), $("#xsl").val());
			//autoWidthAndHeight(true);
			//setObjEvent();
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		//substituteLogo(logoURL);
		return true;
	} else {
		//autoWidthAndHeight(false);
	}
}
//-->
</script>
</head>
<body style="height:100%;background:#F3F3F3;">
<div class='' style="height:100%;">
<input type="hidden" id="content" name="content" value="" />
<ul class="view_ul align_left" id='display_content_view'>
    <li id="cc" class="view_li" style="margin-bottom: 2px;min-width:100%;">
        <%--<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /> --%>
        <%--文单区域 --%>
        <%@ include  file="/WEB-INF/jsp/apps/gov/govform/form_show.jsp" %>
    </li>
    <!--附言区域-->
    <%--<jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />--%>
</ul>
</div>
</body>
</html>