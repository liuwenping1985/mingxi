<%--
/**
 * $Author: wangchw $
 * $Rev: 40258 $
 * $Date:: 2014-09-05 16:35:12#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
</head>
<body>
<div class="form_area align_center">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td id="policyDiv" colspan="2" valign="top" style="padding:0 10px;">
        <div id="policyHTML">
            <table class="only_table edit_table" width="100%" border="0" cellspacing="0" cellpadding="0">
            	<thead>
	            	<tr>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.customFunction.list.1")}<!-- 序号 --></th>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.designer.node.name.label")}<!-- 节点名称 --></th>
	            		<th style="text-align:left;">${ctp:i18n("workflow.label.branch.calculateProcess")}<!-- 计算过程 --></th>
	            	</tr>
            	</thead>
            	<tbody>
            		<c:forEach items="${processLogDetailList}" var="processLogDetail" varStatus="status">
	            		<tr class="padding_5">
		            		<td valign="top">${status.index+1}</td>
		            		<td style="text-align:left;" valign="top">${processLogDetail.nodeName}</td>
		            		<td style="text-align:left;">${processLogDetail.nodeMsg}</td>
	            		</tr>
            		</c:forEach>
            	</tbody>
        	</table>
      </div>
     </td>
    </tr>
</table>
</div>
</body>
</html>