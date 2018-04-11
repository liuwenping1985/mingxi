<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js"></script>
<%@page import="java.util.*"%>
<html>
<head>
<style type="text/css">
.area_page{
    overflow: auto;
}
</style>
<title></title>
<script type="text/javascript">
    
	<%@ include file="/WEB-INF/jsp/apps/doc/js/personalShare.js"%>
    
</script>
</head>
<%--个人分享 --%>
<body class="page_color over_hidden">
    <div class="area_page" id="divPageId">
    <br>
            <div class="margin_lr_10 margin_b_10">
                <div class="page_color padding_10 clearfix"><em class="relation_ico left margin_r_10">1</em>${ctp:i18n('doc.personal.share.doctype')}</div>
                <%--文档介绍 --%>
                <div style="width: 96%">
                    <div class="w60b common_center">
                        <div class="common_txtbox margin_tb_5">
                            <a id="aNewFile" class="common_button common_button_icon common_button_emphasize" href="javascript:void(0)"><em
                                class="ico16 folder_16"></em>${ctp:i18n('doc.log.add.folder')}</a>
                        </div>
                        <%--文档树 --%>
                        <table width="100%" class="border_all over_auto" style="table-layout:fixed">
                            <tr>
                                <td height="160">
                                    <div class="w100b h100b over_auto">
                                        <%--文档树 --%>
                                        <div id="divDocTree"></div>
                                    </div></td>
                            </tr>
                        </table>
                    </div>
                    <div class="page_color margin_tb_5">
                        <table class="w100b padding_10">
                            <tr>
                                <td><em class="relation_ico left margin_r_10">2</em>${ctp:i18n('role.oper.create')}/${ctp:i18n('doc.log.upload')}</td>
                                <td class="right green">${ctp:i18n('doc.personal.share.uploactype')}${fileMaxSize}MB</td>
                            </tr>
                        </table>
                    </div>
                    <div id="updateDocAreaId">
                        <div class="w60b common_center">
                            <div class="padding_b_5">
                                <table>
                                    <tr height="5">
                                        <td><a id="aFileUploadId" class="common_button common_button_icon common_button_emphasize"
                                            href="javascript:void(0)"><em class="ico16 affix_16"></em>${ctp:i18n('doc.log.upload')}</a>
                                        </td>
                                        <td>&nbsp;&nbsp;&nbsp;</td>
                                        <td>${ctp:i18n('doc.personal.share.noupload')}</td>
                                        <td class="margin_t_5"><a id="aNewDoc" disable="disable">${ctp:i18n('doc.jsp.add.title')}</a><span
                                            class="ico16 arrow_2_r margin_b_5"></span></td>
                                        <td id="domainTop">
                                           <div id="attachmentDivNone" class="display_none">
                                                <!-- 上传文件件数量 -->
                                                <li><span id="attachmentNumberDiv" class="display_none"></span></li>
                                                <li id="domainsSub"><input id="myfile" type="text" class="comp"
                                                    isGrid="false"
                                                    comp="type:'fileupload',callMethod:'fnFileUploadCallBack',takeOver:false,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,quantity:1,isEncrypt:false"
                                                    attsdata='${attachmentsJSON}'>
                                                </li>
                                            </div>
                                             <div id="docDivNone" class="display_none">
                                                <li><span id="newDocumentIconId"></span><a id="newDocumentNameId"
                                                    href="#"></a><span id="hrefRmoveDocId"></span></li> <!-- 隐藏域 -->
                                             </div>
                                            <div class="display_none" id="domainsSub2">
                                                <input type="hidden" id="id"> 
                                                <input type="hidden" id="docLibId">
                                                <input type="hidden" id="docLibType"> 
                                                <input type="hidden" id="docResourceId"> 
                                                <input type="hidden" id="parentCommentEnabled">
                                                <input type="hidden" id="parentVersionEnabled">
                                                <input type="hidden" id="parentRecommendEnable">
                                                <input type="hidden" id="vForBorrowS">
                                                <input type="hidden" id="nodeId">
                                                <input type="hidden" id="all">
                                                <input type="hidden" id="edit">
                                                <input type="hidden" id="create">
                                                <input type="hidden" id="readonly">
                                                <input type="hidden" id="read">
                                                <input type="hidden" id="list">
                                            </div></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="page_color padding_10 clearfix"><em class="relation_ico left margin_r_10">3</em>${ctp:i18n('doc.personal.share.fieldseting')}</div>
                        <div class="w60b common_center form_area">
                            <table class="w100b">
                                <tr>
                                    <td>
                                        <div class="padding_5">
                                            <span class="color_red">*</span>${ctp:i18n('doc.personal.share.introduce')}:
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="common_txtbox">
                                            <textarea id="frDesc" class="validate w100b padding_l_5"
                                                validate="type:'string',name:'${ctp:i18n('doc.personal.share.introduce')}',notNull:true,maxLength:500"
                                                rows="6"></textarea>
                                        </div></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="margin_tb_5">
                                            <span class="color_red">*</span>${ctp:i18n('doc.personal.share.keywords')}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input id="keyWords" type="text" class="validate font_size12" maxlength="80"
                                                validate="type:'string',name:'${ctp:i18n('doc.personal.share.keywords')}',notNull:true">
                                        </div></td>
                                </tr>
                            </table>
                            <div id="shareDivId" class="common_radio_box clearfix margin_tb_5">
                                <label>${ctp:i18n('doc.personal.share.setting')}:&nbsp;</label> <label id="shareLabelId"
                                    class="margin_r_10 hand" for="share"> <input id="share" class="radio_com"
                                    name="option" value="0" type="radio" checked="checked">${ctp:i18n('doc.jsp.knowledge.opentosquare')}</label>
                                <label id="secrecyLabelId" class="margin_r_10 hand" for="secrecy"> <input id="secrecy"
                                    class="radio_com" name="option" value="1" type="radio">${ctp:i18n('doc.personal.share.private')}</label>
                                <label class="margin_r_10 hand" for="custom"> <input id="custom"
                                    class="radio_com" name="option" value="2" type="radio">${ctp:i18n('doc.jsp.properties.label.borrow')}</label>
                                <label><a id="hrefSettingId"
                                    class="common_button common_button_icon common_button_disable"
                                    href="javascript:void(0)"><em class="ico16 setting_16"></em>${ctp:i18n('doc.personal.seting')}</a>
                                </label>
                            </div>
                            <div id="setPotentId">
                                <label >&#12288;&#12288;&#12288;&#12288;&nbsp;&nbsp;</label>
                                <label class="margin_r_10 hand" for="readOnlyBox"> <input id="readOnlyBox"
                                    class="radio_com" name="option2" value="0" type="radio">${ctp:i18n('common.readonly')}</label>
                                <label class="margin_r_10 hand" for="listBox"> <input id="listBox"
                                    class="radio_com" name="option2" value="0"  checked="checked" type="radio">${ctp:i18n('file.upload.browse')}</label>
                            </div>
                            <%--线 --%>
                            <div class="common_txtbox clearfix margin_tb_5"></div>
                            <div class="common_checkbox_box clearfix">
                             <label class="margin_r_10 hand" for="commentEnabled"> 
                             <input id="commentEnabled" class="radio_com" name="option3" value="0" type="checkbox" checked="checked">
                                    ${ctp:i18n('doc.personal.option.comment')}</label> <label class="margin_r_10 hand"
                                    for="recommend"> <input id="recommend" class="radio_com" name="option4"
                                    value="0" type="checkbox" checked="checked">
                                    ${ctp:i18n('doc.personal.allow.recommend')}</label> <span id="versionEnabledFont"> <label
                                    class="margin_r_10 hand" for="versionEnabled"> <input id="versionEnabled"
                                        class="radio_com" name="option5" value="1" type="checkbox">${ctp:i18n('doc.on.version.management')}</label>
                                    <label class="green"><span class="font_bold">${ctp:i18n('doc.personal.note')}：</span>${ctp:i18n('doc.does.not.support.version.management')}</label>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divFootId" class="w60b common_center align_center margin_t_10">
            <div class="padding_5 common_center">
                <a id="btnSubmit" class="common_button common_button_emphasize" href="javascript:void(0)"
                    title="${ctp:i18n('metadata.manager.ok')}">${ctp:i18n('metadata.manager.ok')}</a> <a
                    id="btnCancelId" class="common_button common_button_grayDark" href="javascript:void(0)"
                    title="${ctp:i18n('systemswitch.cancel.lable')}">${ctp:i18n('systemswitch.cancel.lable')}</a>
            </div>
       </div>
</body>
</html>