<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../edocHeader.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<!-- 覆盖SeeyonForm.css内的相关样式 -->
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edocDisplay.css${v3x:resSuffix()}" />">

<script>
    var logoURL = "${logoURL}";

//处理升级后文号显示为 -8419626473303881442|bbwh|4|1 的问题
//目前只有这样特殊处理一下
function convertEdocMark(docmarkname){
	if(docmarkname){
	  var docmark = document.getElementById(docmarkname);
	  if(!docmark){
		  return;
	  }
	  if(docmark.value.trim()!= ""){
		  var arr = docmark.value.split("|");
		  if(arr.length == 4 ){
			  docmark.value = arr[1];
			  docmark.title = arr[1];
			  var docmarkDiv = document.getElementById(docmarkname+"_div");
			  if(!docmarkDiv){
				  return;
			  }
			  docmarkDiv.innerHTML=arr[1];
			  docmarkDiv.title=arr[1];
		  }
	  }
  	}
}
    
function edocFormDisplay()
{
  var xml = document.getElementById("xml");
  var xsl = document.getElementById("xslt");
  //initSeeyonForm(xml.value,xsl.value);
  
  //设置修复字段宽度的传参
  window.fixFormParam = {"isPrint" : false, "reLoadSpans" : false};
  initReadSeeyonForm(xml.value,xsl.value);
  
  substituteLogo(logoURL);


  convertEdocMark("my:doc_mark");
  convertEdocMark("my:doc_mark2");
  convertEdocMark("my:serial_no");
  return false;
}
function disabledAll()
{
	var i;
	var objs=document.getElementsByTagName("INPUT");
	for(i=0;i<objs.length;i++)
	{
		objs[i].disabled=true;
	}
	var objs=document.getElementsByTagName("SELECT");
	for(i=0;i<objs.length;i++)
	{
		objs[i].disabled=true;
	}
}
formOperation = "aa";
</script>
</head>
<body style= "overflow-x:scroll;overflow-y:scroll" onload="edocFormDisplay();">

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="" class="body-detail-HTML" style="width:100%;">
  <tr>
    <td class="body-left"><img src="javascript:void(0)" height="1" width="20px"></td>
    <td>

    <div id="formAreaDiv">

			<div style="display:none">
			<textarea id="xml" cols="40" rows="10">
				 ${formModel.xml}
         	</textarea>
         	</div>
         	<div style="display:none">
		   	<textarea id="xslt" cols="40" rows="10">
				${formModel.xslt}
			</textarea>
		    </div>
		 	<div id="html" name="html" style="border:1px solid;border-color:#FFFFFF;height:0px;"></div>

		 	<div id="img" name="img" style="height:0px;"></div>
			<div style="display:none">
			<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea>
			</div>

			</div>

			<!-- 发起人附言 -->

	<div class="body-line-sp"></div>
</td>
</tr>
</table>



<!-- 发起人附言 结束-->

    <div name="edocContentDiv" id="edocContentDiv" width="0px" height="0px" style="display:none">
    <input type="hidden" name="bodyContentId" value="${formModel.edocBody.id}">
    <v3x:showContent content="${formModel.edocBody.content}" type="${formModel.edocBody.contentType}" createDate="${formModel.edocBody.createTime}" viewMode ="edit" htmlId="edoc-contentText" />
    </div>
    </td>
    <td class="body-right"><img src="javascript:void(0)" height="1" width="20px"></td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="body-left-sp"><img src="javascript:void(0)" height="1"></td>
    <td class="body-line-sp"><img src="javascript:void(0)" height="1"></td>
    <td class="body-right-sp"><img src="javascript:void(0)" height="1"></td>
  </tr>
</table>
<!--
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="body-left">&nbsp;</td>
    <td class="body-detail-border">
    	<div class="div-float">
			<div class="div-float body-detail-su">
				<fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /><fmt:message key="sender.note.label" />
			</div>
			<div class="div-float-right senderOpinionReply">&nbsp;</div>
		</div>
		<div class="senderOpinionContent wordbreak">${v3x:toHTML(senderOpinion.content)}</div>
	</td>
    <td class="body-right">&nbsp;</td>
  </tr>
</table>
 -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="body-buttom-left"></td>
    <td class="body-buttom-line"></td>
    <td class="body-buttom-right"></td>
  </tr>
</table>
<script>
document.body.scroll="yes";
</script>
</body>
</html>
