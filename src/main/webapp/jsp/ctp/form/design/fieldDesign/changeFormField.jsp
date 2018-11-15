<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2012-09-14 00:08:40#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.app.matchpagetitle.label')}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/form/design/changeFormField.js${ctp:resSuffix()}"></script>
<script type="text/javascript">

$(document).ready(function(){
  	$("div[name='matchDIV']").click(function(){
    	getDataMacthIndex(this);
  	});
  	$("#select_selected").click(match);
  	$("#select_unselect").click(delect);
});

</script>
</head>
<body style="overflow: hidden;">
	<form id="datamatch" method="post" action="" onSubmit="" name="datamatch" target="" class="font_size12">
		<div id="tabs2" class="comp" comp="type:'tab',width:600,height:410">
            <div id="tabs2_head" class="common_tabs clearfix">
                <ul class="left">
                	<%-- 字段 --%>
                    <li class="current"><a href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('form.edit.field.label')}</span></a></li>
                    <%--视图
                    <li><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n('form.edit.view.label')}</span></a></li>
                    --%>
                </ul>
            </div>
            <div id="tabs2_body" class="common_tabs_body ">
            	<%-- 字段页签 --%>
            	<div id="tab1_div">
            		<table>
            			<tr>
            				<td width="270">
            					<%-- 新增数据 --%>
			           			<div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.datamatch.adddata.label')}</div>
			           			<div class="w100b" style="height: 180px;">
					               	<select class="border_all" name="adddata" id="adddata" style="width: 100%;height: 100%;" size="11">
					                   	<c:forEach items="${newselelst}" var="field" varStatus="status">
					                   		<option value="${field.value}" tablename="${field.tableName}">${field.value}</option>
					                   	</c:forEach>
					               	</select>
					           </div>
					           <%-- 删除数据 --%>
				           	   <div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.datamatch.deldata.label')}</div>
				           	   <div class="w100b" style="height: 180px;">
				               		<select class="border_all" name="deldata" id="deldata" style="width: 100%;height: 100%;" size="11">
				                   		<c:forEach items="${deleselelst}" var="field" varStatus="status">
				                   			<option value="${field.value}" tablename="${field.tableName}">${field.value}</option>
				                   		</c:forEach>
				               		</select>
				           	   </div>
            				</td>
            				<td>
            					<span id="select_selected" class="ico16 select_selected"></span><br><br>
		           				<span id="select_unselect" class="ico16 select_unselect"></span>
            				</td>
            				<td width="270">
            					<div class="clearfix" style="line-height: 20px;">
				           		<%-- 新上传字段 --%>
				               <div id="left0" class="left font_bold" style="width:120px" >${ctp:i18n('form.datamatch.newfield.label')}</div>
				               <%-- 旧字段 --%>
				               <div id="right0" class="left font_bold" style="width:120px">${ctp:i18n('form.datamatch.oldfield.label')}</div>
				           		</div>
						       <div id="matcharea" class="border_all" style="width: 270px;height: 380px;overflow: auto;">
						           <c:forEach items="${selefieldlst}" var="field" varStatus="status">
							           <div id="matchDiv${status.index}" name="matchDIV" class="w100b clearfix" style="line-height: 20px;text-align: left;">
							               <div id="left${status.index}" class="left over_hidden" name="${field.value}" tablename="${field.tableName}" style="width:120px"title="${field.value}">${field.value}</div>
							               <div id="right${status.index}" class="left over_hidden" name="${field.value}" tablename="${field.tableName}" style="width:120px" title="${field.value}">${field.value}</div>
							           </div>
						           </c:forEach>
						       </div>
            				</td>
            			</tr>
            		</table>
               </div>
               <!-- 视图页签 
               <div id="tab2_div" class="hidden">
				    <table>
            			<tr>
            				<td width="270">
            					<%-- 新增数据 --%>
			           			<div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.datamatch.adddata.label')}</div>
			           			<div class="w100b" style="height: 180px;">
					               	<select class="border_all" name="adddate" id="adddate" style="width: 100%;height: 100%;" size="11">
					                   	<c:forEach items="${newselelst}" var="field" varStatus="status">
					                   		<option value="${field.value}"tablename="${field.tableName}">${field.value}</option>
					                   	</c:forEach>
					               	</select>
					           </div>
					           <%-- 删除数据 --%>
				           	   <div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.datamatch.deldata.label')}</div>
				           	   <div class="w100b" style="height: 180px;">
				               		<select class="border_all" name="deldata" id="view_deldata" style="width: 100%;height: 100%;" size="11">
				                   		<c:forEach items="${deleselelst}" var="field" varStatus="status">
				                   			<option value="${field.value}" tablename="${field.tableName}">${field.value}</option>
				                   		</c:forEach>
				               		</select>
				           	   </div>
            				</td>
            				<td>
            					<span id="view_select_selected" class="ico16 select_selected"></span><br><br>
		           				<span id="view_select_unselect" class="ico16 select_unselect"></span>
            				</td>
            				<td width="270">
            					<div class="clearfix" style="line-height: 20px;">
				           		<%-- 新上传字段 --%>
				               <div id="view_left0" class="left font_bold" style="width:120px" >${ctp:i18n('form.datamatch.newfield.label')}</div>
				               <%-- 旧字段 --%>
				               <div id="view_right0" class="left font_bold" style="width:120px">${ctp:i18n('form.datamatch.oldfield.label')}</div>
				           		</div>
						       <div id="view_matcharea" class="border_all" style="width: 270px;height: 380px;overflow: auto;">
						           <c:forEach items="${selefieldlst}" var="field" varStatus="status">
							           <div id="view_matchDiv${status.index}" name="matchDIV" class="w100b clearfix" style="line-height: 20px;text-align: left;">
							               <div id="view_left${status.index}" class="left over_hidden" name="${field.value}" tablename="${field.tableName}" style="width:120px"title="${field.value}">${field.value}</div>
							               <div id="view_right${status.index}" class="left over_hidden" name="${field.value}" tablename="${field.tableName}" style="width:120px" title="${field.value}">${field.value}</div>
							           </div>
						           </c:forEach>
						       </div>
            				</td>
            			</tr>
            		</table>
               </div>
               -->
          </div>
     </div>
     
     <table>
		<tr>
			<%-- 说明 --%>
			<td>${ctp:i18n('form.log.explain')}：</td>
			<%-- 1、如果是新增数据或者是更改表单样式，直接点击确定 --%>
			<td>${ctp:i18n('form.update.frominfopass.style')}</td>
		</tr>
		<tr>
			<td></td>
			<%-- 2、如果是新数据项替换老数据项，上下配对选择后，点击向右箭头，点击确定。 --%>
			<td>${ctp:i18n('form.update.frominfopass.change')}</td>
		</tr>
		<tr>
			<td></td>
			<%-- 3、修改表单时只能新增或者替换字段，不能删除字段。 --%>
			<td>${ctp:i18n('form.update.frominfopass.rule')}</td>
		</tr>
	</table>
</form>
</body>
</html>
