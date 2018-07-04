<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-12-12 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<style type="text/css">
.stadic_head_height{height:70px;}
.stadic_layout_body{
    top:70px;
    bottom:0;
}
</style>
<script type="text/javascript">
var v3x = new V3X();
var bIsContentIframe = true;
var bIsClearContentPadding = true;
var bIsContentNewPage = true;

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/doc/i18n");
var fromGenius = false;
try{
	fromGenius = getA8Top().location.href.indexOf('a8genius.do') > -1;
}catch(e){}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>文档编辑</title>
<script type="text/javascript" src="${path}/common/office/license.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript" charset="UTF-8">
    <%@include file="/WEB-INF/jsp/apps/doc/js/knowledgeBrowseEdit.js"%>
</script>
</head>
<body class="page_color">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:70,sprit:false,border:false">  
            <div id="layoutN_height" class="form_area">
                <div class="form_area align_center">
                    <div id="dataSubmitDomain">
                        <table id="toolbarTabId" border="0" cellSpacing="0" cellPadding="0" class="w100b">
                            <tbody>
                                <tr>
                                    <td rowspan="2" valign="middle" width="1%" nowrap="nowrap" class="padding_tb_5 padding_l_5"><a id="hrefFnSaveId" href="javascript:void(0)" onClick="fnSave();" class="display_inline-block align_center new_btn">${ctp:i18n('doc.log.save')}</a></td>
                                    <td align="left">
                                        <div id="toolbar"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellSpacing="0" cellPadding="0" class="w100b">
                                            <tr>
                                                <td nowrap="nowrap" width="1%" class="padding_l_10">${ctp:i18n('doc.title')}：</td>
                                                <td>
                                                    <div id="frName" class="common_txtbox_wrap">
                                                        <input type="text" id="name" maxlength="80" class="validate font_size12"
                                                            value="${doc.frName}"
                                                            validate="type:'string',name:'名称',notNull:true,avoidChar:'\|\\\/\<\>\&quot',errorMsg:'文档标题不允许为空且不包含特殊字符!'" />
                                                        <input type="hidden" id="id" value="${doc.id}">
                                                        <input type="hidden" id="originalFileId" value="${originalFileId}">
                                                        <input type="hidden" id="fileId" value="${fileId}">
                                                    </div>
                                                </td>
                                                <td noWrap="nowrap" width="1%" class="padding_l_20 padding_r_5">
                                                    <c:if test="${contentTypeFlag == 'true'}">
                                                        <label class="margin_r_10" for="text">${ctp:i18n('doc.type')}：</label>
                                                    </c:if>
                                                </td>
                                                <td id="contentType" width="20%" class="bg-summary padding_r_5">
                                                    <c:if test="${contentTypeFlag == 'true'}">
                                                    <input id="oldCTypeId" type="hidden" value="0">
                                                    <select id="contentTypeId" name="contentTypeId" ${onlyA6 ? 'disabled="disabled"':''} class="input-50per w100b">
                                                            <c:forEach items="${contentTypes}" var="contentType">
                                                                <option value='${contentType.id}' ${contentType.id==doc.frType? 'selected':''}
                                                                title="${v3x:toHTML(v3x:_(pageContext,contentType.name))}">
                                                                ${v3x:toHTML(v3x:_(pageContext,contentType.name))}</option>
                                                            </c:forEach>
                                                    </select>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellSpacing="0" cellPadding="0" class="w100b">
                                            <tr id="assdoc">
                                                <td noWrap="nowrap" width="105" style="height: 23px" align="right"><div id="attachment2TRposition1" style="display:none;">
                                                <label class="margin_lr_5" for="text">${ctp:i18n('doc.jsp.open.label.rel')}&nbsp;(<span 
                                                        id="attachment2NumberDivposition1"></span>)&nbsp;：</label></div></td>
                                                <td id="attachment1" class="left margin_t_5">
                                                    <div class="comp"  comp="type:'assdoc',callMethod:'fnFileUploadCallBack',attachmentTrId:'position1', modids:'1,3' ,applicationCategory:'3',referenceId:'${param.docResId}'" attsdata='${attachmentsJSON}' id="ririir"></div>
                                                </td>
                                            </tr>
                                            <tr id="fileUpload">
                                                <td noWrap="nowrap" width="105" style="height: 23px" align="right"><div id="attachmentTR" style="display:none;">
                                                <label class="margin_r_5" for="text">${ctp:i18n('doc.jsp.open.label.att')}&nbsp;(<span
                                                        id="attachmentNumberDiv"></span>)&nbsp;：</label></div></td>
                                                <td id="attachment2" class="left margin_t_5"><div class="comp"
                                                        comp="type:'fileupload',callMethod:'fnFileUploadCallBack',canFavourite:false,takeOver:false,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,isEncrypt:false,quantity:5"
                                                        attsdata='${attachmentsJSON}'></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                            <%@include file="docEditProperties.jsp"%>
                    </div>
                </div>
            </div>
        </div>
        <div class="layout_center  over_hidden" layout="border:false" width="0" height="0">
            <c:choose>
                <c:when test="${isCanEditOnline && isUploadFile}">
                    <v3x:editor htmlId="content" originalNeedClone="${doc.versionEnabled}" content="${uploadFileContent}" type="${uploadFileBodyType}" createDate="${uploadFile.createDate}" category="<%=ApplicationCategoryEnum.collaboration.getKey()%>" />
                </c:when>
                <c:otherwise>
                    <iframe id="docContent" src="${path }/content/content.do?isFullPage=true&moduleId=${doc.id}&moduleType=3&viewState=1&rightId=1&contentType=${doc.mimeTypeId}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                </c:otherwise>
              </c:choose>
        </div>
   </div>
   <div id="fromAction"></div>
</body>
</html>