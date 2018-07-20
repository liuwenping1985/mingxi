<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<%@ include file="/WEB-INF/jsp/apps/organization/concurrentPost/conPostform_js.jsp"%>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T02_list4Management'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
        <div id="grid_detail" class="">
            <div class="" id="sssssssss">
                <div class="">
                    <div id="welcome">
                        <div class="color_gray margin_l_20">
                            <div class="clearfix">
                                <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("department.parttime.management")}</h2>
                                <div class="font_size12 left margin_t_20 margin_l_10">
                                    <div class="margin_t_10 font_size14">
                                        <span id="count"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="line_height160 font_size14">
                                <span id="conInfo"></span>
                            </div>
                        </div>
                    </div>
                    <div id="form_area" class="form_area">
                        <%@include file="conPostform.jsp"%>
                    </div>
                </div>
            </div>
            <div id="btnArea" class="">
                <div id="button_area" class="page_color button_container border_t padding_t_5" style="height:38px;">
                    <div align="center" class="" style="height:38px;">
                        <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('guestbook.leaveword.ok')}</a>
                        <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('systemswitch.cancel.lable')}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>