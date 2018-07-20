<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<title></title>
<style type="text/css">
   html, body{
      width: 100%;
      height: 100%;
      border: 0;
      padding: 0;
      overflow: hidden;
   }
</style>
<script type="text/javascript">
   function _init_(){
       var subIframes = document.getElementsByTagName("iframe");
       if(subIframes){
           for(var i = 0; i < subIframes.length; i++){
               var htmlIframeObj = subIframes[i].contentWindow.document.getElementById("htmlFrame");
               if(htmlIframeObj){
                   
                   var htmlIframeDoc = htmlIframeObj.contentWindow.document;
                   var htmlIframeHeight = 0;
                   var htmlIframeWidth = 0;
                   
                   //excel转换
                   var excelFrames = htmlIframeDoc.getElementsByName("frSheet");
                   if(excelFrames && excelFrames.length > 0){
                       var excelFrame = excelFrames[0];
                       htmlIframeDoc = excelFrame.contentWindow.document;
                       htmlIframeHeight = 38;
                   }else{
                       //Word
                   }
                   
                   var htmlIframeHTML = htmlIframeDoc.documentElement;
                   var htmlIframeBody = htmlIframeDoc.body;
                   
                   htmlIframeHeight += Math.max( htmlIframeBody.scrollHeight, htmlIframeBody.offsetHeight, 
                           htmlIframeHTML.clientHeight, htmlIframeHTML.scrollHeight, htmlIframeHTML.offsetHeight);
                   htmlIframeWidth  += Math.max( htmlIframeBody.scrollWidth, htmlIframeBody.offsetWidth, 
                           htmlIframeHTML.clientWidth, htmlIframeHTML.scrollWidth, htmlIframeHTML.offsetWidth);
                   
                   htmlIframeWidth = htmlIframeWidth * (100/99) + 24;
                   
                   var parentIframe = window.parent.document.getElementById("summaryContentIframe");
                   parentIframe.style.height = htmlIframeHeight + "px";
                   
                   var parentIframeTabel = window.parent.document.getElementById("summaryContentIframeTable");
                   if(parentIframeTabel){
                       parentIframe.style.width = htmlIframeWidth + "px";
                   }
                   
                   window.parent.document.getElementById("summaryContentIframeTD").style.height = htmlIframeHeight + "px";
                   
                   break;
               }
           }
       }
       
   }
</script>
</head>
<body class="body-bgcolor" style="" onload="_init_()">
	<v3x:showContent content="${summary.content}" type="${summary.dataFormat}" createDate="${summary.createDate}" htmlId="summary-contentText" />
</body>
</html>