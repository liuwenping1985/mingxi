<%--
 $Author: dengxj $
 $Rev: 43101 $
 $Date:: 2014-12-11 20:13:46#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>枚举模板页面</title>
</head>
<body scrolling="no">
	<div class="comp" comp="type:'layout'" id="layout">
		<%-- 顶部按钮区域 --%>
		 <div id="north" style="border:none;" class="layout_north" layout="width:260,height:40,maxHeight:40,minHeight:40,sprit:false,spiretBar:{show:false}">
         <div id="toolbar"></div>
        </div>
        <%-- 左侧树组件 --%>
        <div class="layout_west" layout="width:260" style="border-left: none;">
         <div class="hidden margin_5" id="orgcondition"  style="width:100%;">
         	<select id="orgselect"  style="width:200px;">
         		<option value="">${ctp:i18n('metadata.manager.account.lable')}</option>
         		${orgHTML} 
         	</select>
         </div>
        <div class="condition_box hidden" id="condition_box" style="float:none;" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr bordercolor="red">
					<td width="30%">
						<div class="margin_5">
							<select id="condition" name="condition">
								<option value=""><font size="12">--${ctp:i18n("metadata.select.find")}--</font></option>
								<option value="enumName"><font size="12">${ctp:i18n('metadata.select.enum.name')}</font></option>
								<option value="enumItemName"><font size="12">${ctp:i18n('metadata.select.value.name')}</font></option>
							</select>
						</div>
					</td>
					<td width="50%" class="hidden" id="editTr">
							<input type="text" name="data" id="data" value="" style="width: 95%"/>
					</td>
					<td>
						<div class="left margin_l_5"  id="searchBtn"><EM class="ico16 search_16"></EM></div>
					</td>
				</tr>
			</table>
		</div>

            <div id="tree"></div>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;">
        	<div id="center_north" class="f0f0f0 clearfix" style="width:100%;">
        		<div id="toolbar_center" class="left"></div>
	        	<div id="searchSys" class="right hidden font_size12" style="margin-top:7px;">
	        		${ctp:i18n('metadata.select.enum.name')}: <input  name="name" id="name" value="" type="text" style="width:120px;"><span class="ico16 search_16" id="searchSysBtn"></span>
				</div>
			</div>
			<div class="" id="content" style="width:100%;position:absolute;bottom:0;top:0;border-left: 1px solid #b6b6b6;">
				<table id="mytable" class="flexme3" style="display: none"></table>
				<div id="grid_detail">
					<iframe id="bottomIframe" src=""  width="100%" height="100%" frameBorder="no" scrolling="no"></iframe>
				</div>
			</div>
			<!-- 作为删除或者其他动作用的,对于页面显示没有任何作用的 -->
			<iframe class="hidden" id="delIframe" src=""></iframe>
			<input id="myfile" type="hidden" class="comp" comp="type:'fileupload',applicationCategory:'1',isEncrypt:false,extensions:'xls,xlsx',quantity:1,firstSave:true,showReplaceOrAppend:true">
        </div>
    </div>
    <%@ include file="enumTemplate.js.jsp" %>
</body>
</html>
