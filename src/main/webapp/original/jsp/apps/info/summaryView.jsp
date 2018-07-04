<%--
 $Author:  libing$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<script type="text/javascript" src="${path}/ajax.do?managerName=govTemplateManager"></script>
<!-- 查看处理页面 -->
<title>${ctp:i18n('collaboration.summary.pageTitle')}</title>
<style type="text/css">
    .stadic_head_height{}
    .stadic_body_top_bottom{bottom: 0;overflow:hidden;}
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
var templateId ='${templateId}';
var appType = "${v3x:escapeJavascript(appType)}";
var formId = '${formId}';
$(function(){
	var gtManager = new govTemplateManager();
	 var obj = new Object();
	 obj.templateId = templateId;
	 obj.formId = formId;
	 obj.appType = appType;
	 obj.type= 0;
	 gtManager.ajaxFillFormDate(obj,{
       success : function(map){
           var xml_text = map.xml;
           var xsl_text = map.xsl;
           $("#xml").val(xml_text);
           $("#xsl").val(xsl_text);
           infoReadFormDisplay();
       }, 
       error : function(request, settings, e){
           $.alert(e);
       }
   });
})

function infoFormDisplay(){
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	//buttondnois();
	//document.getElementById("content").value = xsl.value;
	$("#document","#forformlist").val(xsl.value);
	if(xml.value!="" && xsl.value!="") {
		try{
			initSeeyonForm(xml.value, xsl.value);
			//setObjEvent();
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		//substituteLogo(logoURL);
		return false;
	} else {
		//autoWidthAndHeight(false);
	}
}
</script>
</head>
<body  onunload="">
    <div>
        <%@ include  file="/WEB-INF/jsp/apps/gov/govform/form_show.jsp" %>
    </div>
</body>
</html>