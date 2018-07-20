<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2014-11-12 14:38:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导入Excel数据</title>
<script type="text/javascript">
var listDataObj = null;

/**
 * 初始化列表数据
 */
function initListData() {
    listDataObj = $("#resultList").ajaxgrid(
                    {
                    	render : rend,
                        resizable:false,
                        colModel : [ {
                                    display : "${ctp:i18n('import.data')}",
                                    name : 'dataStr',
                                    sortable : true,
                                    width : '25%'
                                }, {
                                    display : "${ctp:i18n('import.result')}",
                                    name : 'result',
                                    sortable : true,
                                    width : '15%'
                                }, {
                                    display : "${ctp:i18n('import.description')}",
                                    name : 'description',
                                    width : '60%',
                                    sortable : true
                                } ],
                        rp: 10,        
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "importExcelMannager",
                        managerMethod : "getImportExcelResult"
                    });
}

function rend(text, row, rowIndex, colIndex,col) {
	return text;
}
$(document).ready(function() {
	initListData();
}); 
</script>
</head>
<body class="h100b">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:50,sprit:false,border:false">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="h100b margin_l_10" align="center" id="file_info">
				<tr>
					<td width="30%"><label class="font_size12" for="text">${ctp:i18n("import.filename")}:</label></td>
					<td width="70%"><label class="font_size12" for="text" id="file_name">xxxxxxx</label></td>
				</tr>
				<tr>
					<td colspan="2"><label class="font_size12" for="text" id="result_description"></label></td>
				</tr>
			</table>
<!--             <div id="setup" class="color_black font_size12 padding_5">导入数据xx条，异常数据XX条</div> -->
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="resultList" class="flexme3" style="display: none"></table>
        </div>       
    </div>
</body>
</html>