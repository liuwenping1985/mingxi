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
<title>DeptAdminManagerment</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/apps/organization/member/member4DeptAdmin_js.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/ldap/ldap_tools_js.jsp"%>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'${param.rescode}'"></div>
        <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
            <div id="searchDiv"></div>
        </div>
         <div class="layout_center over_hidden" layout="border:false" id="center">
            <table id="memberTable" class="flexme3" style="display: none"></table>
			<div id="grid_detail" class="">
                <div class="">
                    <div class="clearfix" id="sssssssss">
                        <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("org.external.member.info")}</h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                    ${ctp:i18n('organization.detail_info_external_member')}</div>
                            </div>
                        </div>
                        <div class="form_area" id='form_area'>
                            <%@include file="memberForm.jsp"%>
                        </div>
                    </div>
                    <div class="">
                        <div id="button_area" class="page_color button_container stadic_footer_height border_t padding_t_5" align="center" style="height:35px;">
                            <table width="100%" border="0">
                                <tbody>
                                    <tr width="100%">
                                        <td width="20%" align="center">
                                            <label class="margin_r_10 hand" for="conti" id="lconti" style="font-size:12px;">
                                                <input id="conti" class="radio_com" value="0" type="checkbox"
                                                checked="checked">${ctp:i18n('continuous.add')}&nbsp;
                                            </label>
                                        </td>
                                        <td width="60%" align="center">
                                            <a href="javascript:void(0)" id="btnok"
                                                class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                            <a href="javascript:void(0)" id="btncancel"
                                                class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
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
    <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>