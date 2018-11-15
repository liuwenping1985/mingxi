<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2015-10-27 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>基础数据管理</title>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F01_listPending'"></div>
        <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
            <div id="searchDiv"></div>
        </div>
        <div class="layout_west" id="west" layout="width:200">
            <div id="metadata_table_tree"></div>
        </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
            <table id="metadata_column_list" class="flexme3" style="display: none"></table>
            <div id="grid_detail">
                <div>
                    <div id="content_area" class="clearfix" style="position: relative;">
                        <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">属性管理</h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <!-- ${ctp:getApplicationCategoryName(13, pageContext)} -->
                                <div class="line_height160 font_size14">1、新建属性</div>
                            </div>
                        </div>
                        <div class="form_area" id="metadata_column">
                            <%@ include file="metadataConfigEdit.jsp"%>
                        </div>
                    </div>
                    <div id="btnArea">
                        <div id="button_area" align="center" class="page_color button_container border_t padding_t_5" style="height:35px;">
                            <table width="80%" border="0">
                                <tbody>
                                    <tr>
                                        <td width="20%" align="center">
                                            <label class="margin_r_10 hand" for="conti" id="lconti" style="font-size:12px;">
                                                <input id="conti" class="radio_com" value="0" type="checkbox" checked="checked">${ctp:i18n('continuous.add')}&nbsp;
                                            </label>
                                        </td>
                                        <td width="60%" align="center">
                                            <a href="javascript:void(0)" id="btnOk" class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                            <a href="javascript:void(0)" id="btnCancel" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                                        </td>
                                        <td width="20%">&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/ajax.do?managerName=metadataColumnManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=metadataManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=metadataCategoryManager"></script>
    <!-- 页面自己的js -->
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/paramUtil.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfigTree.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfigSearchBox.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfigToolbar.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfigColumnList.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfigEdit.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/metadata/metadataConfig.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
	var config = null;
	$(document).ready(function() {
		config = new MetadataConfig();
		config.init();
    });
   	</script>
</body>
</html>
