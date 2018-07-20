<%--
 $Author: weijh $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@page import="com.seeyon.ctp.common.flag.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>
<c:if test="${isNew=='true' && isBreak!='true'}">
新建
</c:if> 
<c:if test="${isNew=='true' && isBreak=='true'}">
分解
</c:if> 
<c:if test="${isNew!='true'}">
修改
</c:if></title>
<script type="text/javascript">
    var cWindow;
    var saveProcessBar;
    var tips = true;
    var isNew = "${ctp:escapeJavascript(isNew)}";
    var _contentAllId = "${contentAllId}";
    var _fromSrc = '${fromSrc}';
    var isFrom="${isFrom}";
    var summaryId="${summaryId}";
    var affairId="${affairId}";
    var govDocTitle="${ctp:escapeJavascript(govDocTitle)}";
    var createTime="${createTime}";
    var superviseForm=true;
    var supType="${supType}";
    var validatefailure=false;
    var isBreak="${isBreak}";
    var parentId="${parentId}";
    var docArray=new Array();
    //分解时初始化来文依据
    <c:forEach items="${relateDocAtts}" var="g">
    	var doc=new Array();
    	doc["type"]="${g.type}";
    	doc["filename"]="${ctp:escapeJavascript(g.filename)}";
    	doc["mimeType"]="${g.mimeType}";
    	var createDate="${g.createdate}";
    	if(createDate && createDate!='undefined' && createDate!=''){
    		createDate="<fmt:formatDate value='${g.createdate}' pattern='yyyy-MM-dd HH:mm:ss'/>";
    	}else{
    		createDate=new Date().format("yyyy-MM-dd HH:mm:ss");
    	}
    	doc["createdate"]=createDate;
    	doc["size"]="${g.size}";
    	doc["fileUrl"]="${g.fileUrl}";
    	doc["description"]="${g.description}";
    	doc["category"]="${g.category}";
    	doc["extension"]="${g.extension}";
    	doc["icon"]="${g.icon}";
    	docArray.push(doc);
    </c:forEach>
    var rightIdArray=new Array();
    <c:forEach items="${rightMap}" var="g">
    	rightIdArray['${g.key}']='${g.value}';
	</c:forEach>
	function changeType(type,obj){
		//获取对应的ID
		if(supType!=type){
			var confirm = dbConfirm({
                'msg':'更换目标来源，原表单内容可能会丢失，是否继续？',
                ok_fn: function () {
                	supType=type;
            		var rightId=rightIdArray[type];
            		var typeName=$(obj).find("a").html();
            		$(".xl_bar_select").find("a").html(typeName);
            		$(".xl_bar_dropdowm").mouseout();
            		$(".xl_bar_select").mouseout();
            		var url='${path}/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(formTemplateId)}&moduleType=${ctp:toHTML(moduleType)}&rightId='+rightId+'&contentType=20&viewState=1&indexParam=0&supType='+type;
            		document.getElementById("newFormDataFrame").src=url;
                }
            });
		}
	}
</script>
<link rel="stylesheet" href="${path}/apps_res/supervision/css/dialog.css">
<script type="text/javascript" src="${path}/apps_res/supervision/js/dialog.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/newUnFlowFormData.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionEditPage.css">

<style type="text/css">
.parentSupervision{
	border: 1px solid #D7D7D7;
	border-radius: 5px 5px 5px 5px;
	font-size: 14px;
    height: 20px;
    max-height: 20px;
    min-height: 20px;
    padding: 3px;
    width: 306px;
}
</style>
<script type="text/javascript">
</script>
</head>
<body scroll="no">
	<div class="form-header">
        <!--左边部分-->
	        <div class="form-header-left">
	            <b></b>
            	<c:if test="${isNew=='true' && isBreak!='true'}">
					<span>新建</span>
				</c:if> 
				<c:if test="${isNew=='true' && isBreak=='true'}">
					<span>分解</span>
				</c:if> 
				<c:if test="${isNew!='true'}">
					<span>修改</span>
				</c:if>
	        </div>
	        <c:if test="${isNew=='true' && isBreak!='true'}">
		        <div class="xl_bar_select">
		        	<a onclick="javascript:void(0)">上级交办</a>
		        	<span></span>
		        </div>
		        <ul class="xl_bar_dropdowm">
		        	<c:forEach items="${enumItemList}" var="enumItem">
						<li style="cursor: pointer;" onclick="javascript:changeType('${enumItem.enumvalue}',this)">
			        		<a id="type${enumItem.enumvalue}">${enumItem.showvalue}</a>
			        	</li>
					</c:forEach>
		        </ul>
	        </c:if>
    </div>
	<div class="comp" comp="type:'layout'" id="layout">

		<div class="layout_center" style="overflow: hidden;">
			<c:if test="${isNew=='true'}">
				<iframe onload="checkLoad(true)" name="newFormDataFrame"
					id="newFormDataFrame" width="100%" height="80%" frameBorder="no"
					src='${path }/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(formTemplateId)}&moduleType=${ctp:toHTML(moduleType)}&rightId=${ctp:toHTML(rightId)}&contentType=20&viewState=1&indexParam=0&supType=${supType}'></iframe>
			</c:if>
			<c:if test="${isNew!='true'}">
				<iframe onload="checkLoad(false)" name="newFormDataFrame"
					id="newFormDataFrame" width="100%" height="80%" frameBorder="no"
					src='${path }/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(contentAllId)}&moduleType=${ctp:toHTML(moduleType)}&rightId=${ctp:toHTML(rightId)}&contentType=20&viewState=1&indexParam=0&supType=${supType}'></iframe>
			</c:if>
		</div>
		<p class="xlbtn" style="text-align: center; width: 100%;">
			<span></span>
			<input id="unflowbtncancel" type="button" value="取消" class="btn-cancel" />
			<input id="unflowbtnsave" type="button" value="保存" class="btn-save" />
		</p>
		<input type="hidden" id="noMsg" name="noMsg"/>
		<!-- 获取的上级事项  -->
		<input type="hidden" id="field0085" name="field0085" value="${parentValue.field0085[0]}"/>
		<input type="hidden" id="field0085_txt" name="field0085_txt" value="${parentValue.field0085[1]}"/>
		<input type="hidden" id="field0087" name="field0087" value="${parentValue.field0087[0]}"/>
		<input type="hidden" id="field0087_txt" name="field0087_txt" value="${parentValue.field0087[1]}"/>
		<input type="hidden" id="field0088" name="field0088" value="${parentValue.field0088[0]}"/>
		<input type="hidden" id="field0088_txt" name="field0088_txt" value="${parentValue.field0088[1]}"/>
		<input type="hidden" id="field0089" name="field0089" value="${parentValue.field0089[0]}"/>
		<input type="hidden" id="field0090" name="field0090" value="${parentValue.field0090[0]}"/>
		<input type="hidden" id="field0091" name="field0091" value="${parentValue.field0091[0]}"/>
		<input type="hidden" id="field0098" name="field0098" value="${parentValue.field0098[1]}"/>
		<input type="hidden" id="field0101" name="field0101" value="${parentValue.field0101[0]}"/>
		<input type="hidden" id="field0093" name="field0093" value="${parentValue.field0093[0]}"/>
		<input type="hidden" id="field0100" name="field0100" value="${parentValue.field0100[0]}"/>
		<input type="hidden" id="field0100_txt" name="field0100_txt" value="${parentValue.field0100[1]}"/>
		<input type="hidden" id="field0022" name="field0022" value="${parentValue.field0022[0]}"/>
		<input type="hidden" id="field0022_txt" name="field0022_txt" value="${parentValue.field0022[1]}"/>
		<input type="hidden" id="field0019" name="field0019" value="${parentValue.field0023[0]}"/>
		<input type="hidden" id="field0131" name="field0131" value="${param.parentId}"/>
		<input type="hidden" id="field0004" name="field0004" value="${complateDate}"/>
	</div>
	<div>
	<script>
		$(".xl_bar_select").mouseover(function(){
			$(".xl_bar_dropdowm").css("display","block");
		}).mouseout(function(){
			$(".xl_bar_dropdowm").css("display","none");
		})
		$(".xl_bar_dropdowm").mouseover(function(){
			$(this).css("display","block");
		}).mouseout(function(){
			$(this).css("display","none");
		});
	</script>
</body>
<style>
label {
	font-family: 微软雅黑;
	layout-grid-mode: none;
}
</style>
</html>