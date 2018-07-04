<%--
 $Author: muyx $
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript">
    <%@ include file="/WEB-INF/jsp/apps/rss/js/rssManage.js"%>
</script>
<style>
.stadic_footer_height{
    height:28px;
}
.line{
    height:0px;
    overflow:hidden;
}

</style>

</head>
<body>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_rssIndex'"></div>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,maxHeight:40,minHeight:40,border:false,sprit:false">
        <div id="toolbar"></div>    
    </div>
    <div class="layout_west"
        layout="width:200,minWidth:50,maxWidth:300,spiretBar:{show:true,handlerL:function(){$('#layout').layout().setWest(0);},handlerR:function(){$('#layout').layout().setWest(200);}}">
        <div id="rssBackTree"></div>
    </div>
    <div class="layout_center over_hidden" id="center" layout="border:false">
        <table id="rssBackGrid" style="display: none"></table>
                <%--common_center区 --%>
        <div id="div_center_content_for_rss" class="common_center">
            <%--编辑类别频道 --%>
            <div id="div_edit_categoryChannel" class="form_area display_none">
                    <div class="stadic_layout">
                        <div class="stadic_layout_body stadic_body_top_bottom border_t">
                            <div class="one_row margin_t_10 over_y_auto">
                                <table border="0" cellspacing="0" cellpadding="0" class="over_y_auto">
                                    <tr>
                                        <th colspan="2">
                                            <span class="color_red">*</span>${ctp:i18n('common.notnull.label')}
                                        </th>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text"> <span
                                                class="color_red">*</span>${ctp:i18n('common.resource.body.name.label')}:</label>
                                        </th>
                                        <td width="100%"><div class="common_txtbox_wrap">
                                                <input type="text" id="name" maxlength="25" class="validate"
                                                    validate="type:'string',name:'${ctp:i18n('common.resource.body.name.label')}',notNull:true,avoidChar:'-!@#$%^~\\]=\'\{\}\\/;[&*()<>?_+',errorMsg:'${ctp:i18n('rss.channel.alter.name.errorMsg')}'" />
                                                <%--隐藏域 --%>
                                                <input type="hidden" id="id"> <input type="hidden" id="isAdd"
                                                    value="false">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><span
                                                class="color_red">*</span>${ctp:i18n('rss.address.label')}:</label>
                                        </th>
                                        <td><div class="common_txtbox_wrap">
                                                <input type="text" id="url" maxlength="160" class="validate"
                                                    validate="name:'${ctp:i18n('rss.address.label')}',regExp:/(http|https|ftp):\/\/[\s\S]+/i,notNull:true,errorMsg:'${ctp:i18n('rss.channel.alter.address.errorMsg')}'" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text"> <span
                                                class="color_red">*</span>${ctp:i18n('rss.seqno.label')}:</label></th>
                                        <td><div class="common_txtbox_wrap">
                                                <input type="text" id="orderNum" maxlength="8" class="validate"
                                                    validate="name:'${ctp:i18n('rss.seqno.label')}',notNull:true,regExp:/^-?\d+$/,errorMsg:'${ctp:i18n('rss.channel.ordernum.errorMsg')}'" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><span
                                                class="color_red">*</span>${ctp:i18n('rss.category.label')}:</label>
                                        </th>
                                        <td><div class="common_txtbox clearfix">
                                                <select id="categoryId" class="validate"
                                                    validate="type:'string',name:'${ctp:i18n('rss.category.label')}',notNull:true,errorMsg:'${ctp:i18n('rss.category.alter.name.null')}'">
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text">
                                                ${ctp:i18n('common.description.label')}:</label>
                                        </th>
                                        <td><div class="common_txtbox  clearfix">
                                                <textarea class="validate w100b"
                                                    validate="name:'${ctp:i18n('common.description.label')}',maxLength:120"
                                                    cols="30" rows="3" id="description"></textarea>
                                            </div></td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="stadic_layout_footer stadic_footer_height">
                          <div class="align_center bg_color_gray">
                            <a id="href_categoryChannel_submit" href="javascript:void(0)"
                                class="common_button common_button_emphasize">${ctp:i18n('guestbook.leaveword.ok')}</a>
                            <a id="href_categoryChannel_cancel" href="javascript:void(0)"
                                class="common_button common_button_grayDark">${ctp:i18n('rss.btn.cannel')}</a>
                          </div>
                        </div>
                    </div>
            </div>
            <%--使用帮助 --%>
            <div id="div_edit_introduce" class="margin_l_10 display_none">
                <div class="color_gray margin_l_20">
                    <div class="clearfix">
                        <h2 class="left">${ctp:i18n('menu.rss')}</h2>
                        <div class="font_size12 left margin_t_20 margin_l_10">
                            <div class="margin_t_10 font_size14">
                                ${ctp:i18n('rss.business.total.label')}</div>
                        </div>
                    </div>
                    <div class="line_height160 font_size14">${ctp:i18n('rss.info.explain')}</div>
                </div>
            </div>
        </div>
    </div>
    </div>
</body>
</html>
