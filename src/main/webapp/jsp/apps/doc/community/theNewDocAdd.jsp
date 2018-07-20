<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-12-12 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<script type="text/javascript" charset="UTF-8" src="/seeyon/common/js/V3X.js?V=V5_0_product.build.date"></script>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('doc.jsp.add.title')}</title>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript" charset="UTF-8">
    v3x.loadLanguage("/common/js/i18n");
    v3x.loadLanguage("/apps_res/doc/i18n");
    var docLibId = "${docLibId}";
	var docLibType = "${docLibType}";
	var isShareAndBorrowRoot = "${v3x:escapeJavascript(param.isShareAndBorrowRoot)}"
    var bIsClearContentPadding = true;
    var bIsContentIframe = true;
    var bIsContentNewPage = true;
	var isDialog = true;
    <%@include file="/WEB-INF/jsp/apps/doc/js/theNewDocAdd.js"%>
</script>
</head>
<body class="page_color">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:95,sprit:false,border:false">            
            <div id="layoutN_height" class="form_area">
                <div class="form_area align_center">
                    <div id="dataSubmitDomain">
                    <c:if test="${not param.personalShare}">
					<div  class="body_location align_left border_b padding_5 ${openFrom eq 'project' ? 'display_none':''}">
						<span class="location_text">
							${ctp:i18n('doc.now.location.label')}<span id="nowLocation"></span>        
						</span>
						<script type="text/javascript">
							var locationHead = "<a>${ctp:i18n('doc.knowledge.zone')}</a> - ";
							if('${onlyA6}' == 'true'){
								locationHead = "";
							}
							var sLocation= "<a>${ctp:i18n('doc.tree.struct.lable')}</a> - ";//"";
							showLocationText(sLocation+"${parentLocation}");
						</script>
					</div>
					</c:if>
                        <table id="dataSubmitDomainTabId" border="0" cellSpacing="0" cellPadding="0" class="w100b font_size12">
                            <tbody>
                                <tr>
                                    <td rowspan="2" valign="top" width="1%" class="padding_tb_5 padding_l_5" nowrap="nowrap"><a href="javascript:void(0)" id="hrefFnSaveId" onClick="fnSave();" class="display_inline-block align_center new_btn">${ctp:i18n('doc.log.save')}</a></td>
                                    <td valign="top" height="22">
                                        <div id="toolbar"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="padding_l_5">
                                        <table border="0" cellSpacing="0" cellPadding="0" class="w100b font_size12">
                                            <tr>
                                                <th width="1%" nowrap="nowrap" class="padding_l_5">${ctp:i18n('doc.title')}：</th>
                                                <td>
                                                    <div id="frName" class="common_txtbox_wrap">
                                                        <input type="text" id="name" maxlength="80" class="validate font_size12"                                                  
                                                            validate="type:'string',name:'${ctp:i18n('doc.column.name')}',notNull:true,avoidChar: '\|\\\/\<\>&quot',errorMsg:'${ctp:i18n('doc.input.title.warning')}'" />
                                                        <input type="hidden" id="id" value="${docId}">
                                                        <input type="hidden" id="subject" name="subject" value="${ctp:i18n('doc.jsp.add.title')}" />
                                                    </div>
                                                </td>
                                                <th width="1%" nowrap="nowrap" class="padding_l_20">
                                                    <c:if test="${contentTypeFlag == 'true'}">
                                                        <label class="margin_r_10" for="text">${ctp:i18n('doc.type')}:</label>
                                                    </c:if>
                                                </th>
                                                <td id="contentType" width="20%" class="bg-summary align_left padding_r_5">
                                                    <c:if test="${contentTypeFlag == 'true'}">
                                                        <input id="oldCTypeId" type="hidden" value="0">
                                                        <select id="contentTypeId" name="contentTypeId" class="w90b" ${onlyA6 ? 'disabled="disabled"':''}  style="font-size: 12px; height: 22px;">
                                                                <c:forEach items="${contentTypes}" var="contentType">
                                                                    <option value='${contentType.id}' title="${v3x:toHTML(v3x:_(pageContext,contentType.name))}">
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
                                        <table border="0" cellSpacing="0" cellPadding="0" class="w100b font_size12">
                                            <tr id="assdoc">
                                                <td noWrap="nowrap" style="width:105px; height: 23px" align="right"><div id="attachment2TRposition1" style="display:none;">
                                               	<span class="ico16 relate_file_16"></span>(<span id="attachment2NumberDivposition1"></span>)&nbsp;：</div></td>
                                                <td id="attachment1">
                                                    <div class="comp"  comp="type:'assdoc',callMethod:'fnFileUploadCallBack',attachmentTrId:'position1', modids:'1,3'" attsdata='${attachmentsJSON}'></div>
                                                </td>
                                            </tr>
                                            <tr id="fileUpload">
                                                <td noWrap="nowrap" style="width:105px;height: 23px" align="right"><div id="attachmentTR" class="font_size12" style="display:none;">
                                                <span class="ico16 affix_16"></span>(<span id="attachmentNumberDiv"></span>)&nbsp;：</div></td>
                                                <td id="attachment2"><div class="comp"
                                                        comp="type:'fileupload',callMethod:'fnFileUploadCallBack',takeOver:false,applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:false,isEncrypt:false,quantity:5"
                                                        attsdata='${attachmentsJSON}'></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div id="docEditDomain">
                            <%@include file="docEditProperties.jsp"%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="docContent" src="${path }/content/content.do?isFullPage=true&moduleId=${docId}&moduleType=3&isNew=true&contentType=${bodyType}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
              <div id="fromAction"></div>
        </div>
   </div>
 
</body>
</html>