<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<fmt:setLocale value="${v3x:getLanguage(pageContext.request)}" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=11,chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="${pageContext.request.contextPath}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="../../common/css/default.css" media="all">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<style>
   .appendInfo{
     border-bottom:#c5cad2 1px solid !important;
     width:720px;
     font-size: 12px;
   }
   .body-detail-HTML,.body-detail{
     width:800px;
   } 
   .contentText p, td, UL, LI, div, a, ol, pre{
     font-family: "Microsoft YaHei",SimSun,Arial,Helvetica,sans-serif;
     font-size: 16px;
     line-height: 1.5;
     #line-height: 1.5;
     _line-height: 1.5;
     word-break:break-all;
   } 
 </style>
<div id="linkList"></div>

<style media=print>
 .PageNext{page-break-after:always;}  
 .Noprint{display:none;}
  .tdfirstclass{
    border-right:solid 1px #999999;
    border-bottom:solid 1px #999999;
 } 
</style>
<style>
<%-- 打印页面专用 --%>

.body-class {
    border:10px #ededed solid;
    border-bottom:0px #ededed solid;
    margin:0px;
    background:#fff;
}
.body-class-print{
    border:0px #ededed solid;
    margin:0px;
    background:#fff;
}
.header{
    background:#ededed;
}
#context{
    overflow:hidden;
    background:#ffffff;
    margin:0px auto;
    min-width:1024px;
    
}
.contentText{
  padding: 0px;
}
@media print{
    #header{
        display:none;
    }
    .body{
        border:0px;
        margin:0px;
    }
}

#checkOption label{
font-weight: normal;
}

.buttonSmall{
width: 47px;!importent
}
.xdLayout .xdTextBox{
  border: none;
}
</style>
<script type="text/javascript" charset="UTF-8" src="../../common/js/V3X.js${v3x:resSuffix()}" ></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/SeeyonForm3.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/print/i18n");
var parent = v3x.getParentWindow();
var webRoot ="";
var isReportPerfermance = "${param.isReportPerfermance eq '1'}";
if(typeof(parent)!='undefined' && parent) webRoot = parent.webRoot;
function thisclose(){
     if(!window.close()){
        <%--如不能正常关闭，则调用IE的关闭命令--%>
        printIt(45);
     }
}
function printIt(n){
    try{
        
        if(n!=8){
        <%--打印前隐藏边框--%>
            document.getElementById('bg').className = 'body-class-print';
            if(document.getElementById('TempDiv_context')){
                printObjInnerHTML = document.getElementById('TempDiv_context').outerHTML ;
                document.getElementById('TempDiv_context').outerHTML = "" ;
            }
        }
        if(n==1){
    	//去掉选中背景
        jQuery("#context tbody tr").removeClass('sort-select');

        //奇数tr 重新加背景
		var trLength = jQuery("#context tbody tr").length;
    	for(i = 0; i <= trLength; i+=2)
       	{
   			jQuery("#context tbody tr:eq(" + i + ")").addClass('erow');
       	}
        window.print()
        }else{
    	//去掉选中背景
        jQuery("#context tbody tr").removeClass('sort-select');

        //奇数tr 重新加背景
		var trLength = jQuery("#context tbody tr").length;
    	for(i = 0; i <= trLength; i+=2)
       	{
   			jQuery("#context tbody tr:eq(" + i + ")").addClass('erow');
       	}
        document.all.WebBrowser.ExecWB(n,1);
        }
        if(n!=8){
        <%--弹出预览后，显示边框--%>
            document.getElementById('bg').className = 'body-class';
            disabled($('context')) ;
        }
    }
    catch(e){}
}

  function $(id){ 
    return document.getElementById(id); 
  } 
  function disabled(o)   { 
      var browser=navigator.appName 
      var b_version=navigator.appVersion 
      var version=b_version.split(";"); 
      var trim_Version=version[1].replace(/[ ]/g,""); 
      if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){ 
          var temp; 
          var selects = o.getElementsByTagName("select");
          if(selects){
              for(var j=0;j<selects.length;j++){   
                  selects[j].onchange = function(){
                      alert(_('printLang.print_preview_not_allow_modify_alert'));
                      this.value = temp;
                  };
                  selects[j].onfocus = function(){
                      temp = this.value;
                  };                
              }
          }
      } 
      var div = document.createElement("div"); 
      div.setAttribute("id","TempDiv_" + o.id); 
      document.body.appendChild(div); 
      div = $("TempDiv_" + o.id); 
      with(div.style){
          position = "absolute";
          backgroundColor = "#FFFFFF";
          width = o.offsetWidth;
          height = o.offsetHeight;
          left = o.offsetLeft;
          top = o.offsetTop;
          opacity = "0";
          filter = "alpha(opacity=0)";
     } 
 }
 
function thisMoreBig(content,size){
  if(!size){
    size = 0.01 ;
  }
  if(content){
    content.style.zoom = parseFloat(content.style.zoom) + size ;
    clearnText() ;
  }
}

function thisSmaller(content,size){
  if(!size){
    size = 0.01 ;
  }
  if(content){
    content.style.zoom = parseFloat(content.style.zoom) - size ;
    clearnText() ;
  }
}
function thisToSelf(content){
  if(content){
    content.style.zoom = 1 ;
    clearnText() ;
  }
}

function thisCustomize(content){
  var print8 = document.getElementById("print8") ;
  
  if(content && print8 && print8.value != "" ){
      if(isNaN(print8.value)){
         alert("缩放的大小必须是数字！") ;
         return ;
      }
     content.style.zoom = parseFloat(print8.value / 100) ;
  }
}

function doChangeSize(changeType){
  var content = document.getElementById("context") ;
  if(content && content.style.zoom) {   
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
}

function clearnText(){
    var print8 = document.getElementById("print8") ;
    var context = document.getElementById("context") ;
    if(print8 &&  context){
      var size = context.style.zoom ;
      print8.value = parseInt(size * 100) ;
    }
}

function showOrDisableButton(){
      var browser=navigator.appName 
      var b_version=navigator.appVersion 
      var version=b_version.split(";"); 
      var trim_Version=version[1].replace(/[ ]/g,""); 
      if(!v3x.isMSIE){
        document.getElementById('print2').style.display="none";
        document.getElementById('print3').style.display="none";
      }
      if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){
        var _showOrDisableButton = document.getElementById("_showOrDisableButton") ;
            _showOrDisableButton.className = "" ;
      } 
}
function loadSign(){
    //直接装载父页面的印章。
    if((typeof(parent.summary_id)!='undefined' && parent.summary_id)
            &&(typeof(parent.isNeedLoadISignatureHtml4Print)!='undefined' && parent.isNeedLoadISignatureHtml4Print)){
        loadSignatures(parent.summary_id);
    }
    //拖动列表打印样式替换
    var mxtgrid = jQuery(".mxtgrid");
    if(mxtgrid.length > 0 ){//是否有拖动表格判断
        
        var tableHeader = jQuery(".table-header");
        var tableBody = jQuery(".table-body");
        //var tableFooter = jQuery(".table_footer");
        var str = "";
        var headerHtml =tableHeader.html();
        var bodyHtml = tableBody.html()
        //var footerHtml= tableFooter.html();
        if(headerHtml == null || headerHtml == 'null')
            headerHtml ="";
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        //if(footerHtml== null || footerHtml=='null'){
        //  footerHtml="";
        //}
        str+="<table class='table-header-print' border='0' cellspacing='0' cellpadding='0'>"
        str+="<thead>"
        str+=headerHtml;
        str+="</thead>"
        str+="<tbody>"
        str+=bodyHtml;
        str+="</tbody>"
        //str+="<tfoot><tr><td colspan='100' height='25' class='footer'>"
        //str+=footerHtml;
        //str+="</td></tr></tfoot>"
        str+="</table>"
        var parentObj = mxtgrid.parent();
        mxtgrid.remove();
        parentObj.html(str);
        jQuery(".mxtgrid a").removeAttr('onclick');
        /**
        mxtgrid.css('position','static');
        jQuery(".hDiv").css('position','static');
        jQuery(".bDiv").css('position','static');
        jQuery(".bDiv").css('height','auto');
        jQuery(".fDIV").css('position','static');
        var go = jQuery(".go");
        if(go.length>0){
            go.css('line-height','10px');
        }
        **/

		//加载打印预览页面前去掉 选中背景
        jQuery("#context tbody tr").removeClass('sort-select');

        //奇数tr 重新加背景
		var trLength = jQuery("#context tbody tr").length;
    	for(i = 0; i <= trLength; i+=2)
       	{
   			jQuery("#context tbody tr:eq(" + i + ")").addClass('erow');
       	}
    }
    
    var _contextDiv =  document.getElementById('context');
    if(_contextDiv){
        var _contextDivScrollWidth = parseInt(_contextDiv.scrollWidth);
        var _contextDivOffsetWidth = parseInt(_contextDiv.offsetWidth);
        if(_contextDivScrollWidth && _contextDivOffsetWidth){
            if(_contextDivScrollWidth>_contextDivOffsetWidth){
                _contextDiv.style.width = (_contextDivScrollWidth)+"px";
                document.getElementById('bg').style.width = (_contextDivScrollWidth+70)+"px";
                
            }   
        }

    }
    
    
}
//页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置
window.onresize = function (){
  try{
    moveISignatureOnResize();
  }catch(e){}
}   
function onbeforeunload(){
    if(typeof(releaseISignatureHtmlObj) != "undefined"){
        releaseISignatureHtmlObj();
    }
}
function removeClick(){
  if(!jQuery("#context")) return;
  if(!jQuery("#context").find) return;
	//此处可能存在性能问题
	jQuery("#context").find("*").each(function(){
		if(this.onclick){
			jQuery(this).attr("onclick","");
			this.onclick=null;
		}
		if(this.href){
		    try{
		      jQuery(this).attr("href","#");
		      this.href = "#";
		    }catch(e){}
		}
	});
}

function paddIdOut()
{
	jQuery("#paddId").find("table").attr("width","730px");
	jQuery("#paddId").find("table").attr("align","center");
	
	var headerWidth = jQuery("#header").width();
	var contentWidth = jQuery(".content").width();
	if(contentWidth > headerWidth)
	{
		jQuery("#header").width(contentWidth);
	}
}
setTimeout("paddIdOut()",500);
//-->
</script>
<SCRIPT language=javascript for=SignatureControl 
    event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
      //作用：重新获取签章位置
      if(SignatureControl && EventId == 4 ){
        CalculatePosition();
        SignatureControl.EventResult == true;
      }
</SCRIPT>
</head>
<body onLoad="printLoad();disabled($('context'));showOrDisableButton();loadSign();removeClick();" onbeforeunload="onbeforeunload();" id="bg" class="body-class">

            <div id="header" class="header">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                        <%--顶部打印按钮--%>
                                <input type=button id="print1" class=" buttonSmall"  value="<fmt:message key='print.label' bundle='${v3xCommonI18N}'/>" onClick="printIt(1)" />
                                <c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}">
                                    <input type=button id="print2" class=""  value="<fmt:message key='print.setting.label' bundle='${v3xCommonI18N}'/>" onClick="printIt(8)" /> 
                                    <input type=button id="print3" class=""  value="<fmt:message key='print.preview.label' bundle='${v3xCommonI18N}'/>"  onclick="printIt(7)" />
                                </c:if>
                                <input type=button id="print4" class=" buttonSmall"  value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}'/>" onClick="thisclose()" />
                                <c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request) || param.isReportPerfermance eq '1'}">
                                <div  id="_showOrDisableButton" style='margin:5px 0px;'>
                                <input type=button id="print5" class=" buttonSmall"  value="<fmt:message key='person.format.bigger' bundle='${v3xCommonI18N}'/>" onClick="doChangeSize('bigger')" />
                                <input type=button id="print6" class=" buttonSmall"  value="<fmt:message key='person.format.smaller' bundle='${v3xCommonI18N}'/>" onClick="doChangeSize('smaller')" />
                                <input type=button id="print7" class=" buttonSmall"  value="<fmt:message key='person.format.self' bundle='${v3xCommonI18N}'/>" onClick="doChangeSize('self')" />
                                <span style="font-size:12px;color:#1039b2;"><fmt:message key='person.format.size'  bundle='${v3xCommonI18N}'/>：</span><input type=text id="print8" class="input-date"    value="100"  onblur ="doChangeSize('customize')" />%
                                </div>
                                </c:if>
                         </td>
                        <td>
                            <div id="checkOption" class="common_checkbox_box clearfix align_right"></div>
                        </td>
                    </tr>
                    <tr height="20px">
                     <td></td>
                    </tr>
                    
                </table>
            </div>  
            
            <div class="content" id="context" style="zoom:1;">
            </div>
            <OBJECT id=WebBrowser classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2 height=0 width=0></OBJECT> 
</body>
</html>