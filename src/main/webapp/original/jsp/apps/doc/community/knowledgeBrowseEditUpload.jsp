<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/property.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}"/>"></script>
<title><fmt:message key='doc.jsp.add.title.edit'/></title>
<html:link renderURL="/doc.do" var="detailURL" />
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript" language="javascript">
    v3x.loadLanguage("/apps_res/doc/i18n");
    var jsURL = "${detailURL}";
    var whitespace = " \t\n\r";
    var fileReplaceFlag = false;

    var oldName = "<c:out value='${doc.frName}' escapeXml='true' />";

    function propertiesChanged() {

    }

    function validate() {
        var i;
        var name = document.myform.docName.value;
        if ((name == null) || (name.length == 0)) {
            return true;
        }
        for (i = 0; i < name.length; i++) {
            var c = name.charAt(i);
            if (whitespace.indexOf(c) == -1) {
                return false;
            }
        }
        return true;
    }

    function OK() {
        return saveIt('${isUploadFile}', '${isCanEditOnline}');
    }

    function saveIt(isFile, canEditOnline) {
        var count = 0;
        var size = fileUploadAttachments.size();
        var keys = fileUploadAttachments.keys();
        for (var i = 0; i < size; i++) {
            var att = fileUploadAttachments.get(keys.get(i), null);
            if (att.type == 0) {
                count++;
            }
        }
        disableDocButtons('true');
        if (!checkForm(myform)) {
            enableDocButtons('true');
            return;
        }
        var docResId = document.getElementById("docResId").value;
        var newName = document.myform.docName.value.escapeHTML();
        if (newName && oldName != newName) {
            var exist = dupliName('${doc.parentFrId}', newName, '${doc.frType}', false);
            if ('true' == exist) {
                alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert', newName));
                enableDocButtons('true');
                document.myform.docName.focus();
                return;
            }
        }
        if (isFile == "false") {
            if (!saveOffice()) {
                enableDocButtons('true');
                return;
            }
        } else if ("true" == canEditOnline) {
            if (!saveOffice('true')) {
                enableDocButtons('true');
                return;
            }
        } else {
            if (fileReplaceFlag) {
                var count = 0;
                var size = fileUploadAttachments.size();
                var keys = fileUploadAttachments.keys();
                for (var i = 0; i < size; i++) {
                    var att = fileUploadAttachments.get(keys.get(i), null);
                    if (att.type == 0) {
                        count++;
                    }
                }
                if (count == 0) {
                    alert(v3x.getMessage("DocLang.doc_edit_file_replace_upload_alert"));
                    enableDocButtons('true');
                    return;
                } else {
                    // 对于上传文件需要替换的情况，在saveAttachment()之前，将替换的文件提取出来，另行处理
                    for (var i = 0; i < keys.size(); i++) {
                        var att = fileUploadAttachments.get(keys.get(i), null);
                        if (att.type == 0) {
                            if ("${v3x:toHTML(uploadFile.filename)}" != att.filename) {
                                if (!window.confirm(v3x.getMessage('DocLang.doc_replace_different_name_confirm'))) {
                                    deleteAttachment(att.fileUrl, false);
                                    enableDocButtons('true');
                                    return;
                                }
                                var exist = dupliName('${doc.parentFrId}', att.filename, '${doc.frType}', false);
                                if ('true' == exist) {
                                    alert(v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert', att.filename));
                                    deleteAttachment(att.fileUrl, false);
                                    enableDocButtons('true');
                                    return;
                                }
                            }
                            document.getElementById("file_fileUrl").value = att.fileUrl;
                            document.getElementById("file_mimeType").value = att.mimeType;
                            document.getElementById("file_size").value = att.size;
                            document.getElementById("file_createDate").value = att.createDate;
                            document.getElementById("file_filename").value = escapeStringToHTML(att.filename);
                            document.getElementById("file_type").value = att.type;
                            document.getElementById("file_needClone").value = att.needClone;
                            document.getElementById("file_description").value = att.description;
                            document.getElementById("file_reference").value = att.reference;
                            document.getElementById("file_subReference").value = att.subReference;
                            document.getElementById("file_category").value = att.category;
                            document.getElementById("docName").value = escapeStringToHTML(att.filename);
                            deleteAttachment(att.fileUrl, false);
                            break;
                        }
                    }

                }
            } else {
                var keys = fileUploadAttachments.keys();
                for (var i = 0; i < keys.size(); i++) {
                    var att = fileUploadAttachments.get(keys.get(i), null);
                    if (att.type == 0) {
                        deleteAttachment(att.fileUrl, false);
                    }
                }
            }
        }

        isFormSumit = true;

        saveAttachment();
        myform.action = myform.action + "&fileReplaceFlag=" + fileReplaceFlag;
        var theform = $('#myform');
        $.ajax({
            url: myform.action,
            data: theform.serialize(),
            async: false,
            type: "POST"
        });
        document.myform.docName.focus();
        //getA8Top().frames['main'].isRefresh = true;
        return true;
    }

    // 上传文件的替换处理，生成页面元素
    function myAttToInput(att) {
        var str = "";
        str += "<input type='hidden' name='file_id' value='" + att.id + "'/>";
        str += "<input type='hidden' name='file_reference' value='" + att.reference + "'/>";
        str += "<input type='hidden' name='file_subReference' value='" + att.subReference + "'/>";
        str += "<input type='hidden' name='file_category' value='" + att.category + "'/>";
        str += "<input type='hidden' name='file_type' value='" + att.type + "'/>";
        str += "<input type='hidden' name='file_filename' value='" + escapeStringToHTML(att.filename) + "'/>";
        str += "<input type='hidden' name='file_mimeType' value='" + att.mimeType + "'/>";
        str += "<input type='hidden' name='file_createDate' value='" + att.createDate + "'/>";
        str += "<input type='hidden' name='file_size' value='" + att.size + "'/>";
        str += "<input type='hidden' name='file_fileUrl' value='" + att.fileUrl + "'/>";
        str += "<input type='hidden' name='file_description' value='" + att.description + "'/>";
        str += "<input type='hidden' name='file_needClone' value='" + att.needClone + "'/>";
        document.getElementById("docName").value = escapeStringToHTML(att.filename);

        return str;
    }

    function backDocAdd() {
        myform.action = "${detailURL}?method=cancelModifyDoc&docResId=${doc.id}";
        myfrom.submit();
    }

    function docDownLoad(fileId, fileName, theDate) {
        docFrame.document.location = "/seeyon/fileUpload.do?method=download&fileId=" + fileId + "&createDate=" + theDate + "&filename=" + encodeURI(fileName);

    }

    function changeUploadFile() {
        var oUploadBtn = $("#uploadBtn");
        if (myform.fileAction[1].checked) {
            // 替换
            fileReplaceFlag = true;
            // 如果已经上传过，保存fileUrl
            var size = fileUploadAttachments.size();
            var keys = fileUploadAttachments.keys();
            var oldFileUrl = '';
            if (size > 0) {
                for (var i = 0; i < size; i++) {
                    var att = fileUploadAttachments.get(keys.get(i), null);
                    if (att.type == 0) {
                        oldFileUrl = att.fileUrl;
                        break;
                    }
                }
            }

            // 上传
            insertAttachmentPoi('position0');
            // 遍历，判断type == 0 的size，如果超过1个，删除老的
            var count = 0;
            size = fileUploadAttachments.size();
            keys = fileUploadAttachments.keys();
            for (var i = 0; i < size; i++) {
                var att = fileUploadAttachments.get(keys.get(i), null);
                if (att.type == 0) {
                    count++;
                }
            }

            if (count == 1) {
                deleteAttachment(oldFileUrl, false);
            }

        } else {
            fileReplaceFlag = false;
            var size = fileUploadAttachments.size();
            var keys = fileUploadAttachments.keys();

            oUploadBtn.attr("disabled", "disabled");
            oUploadBtn.addClass("common_button_disable");
            oUploadBtn.unbind("click");
        }
    }

    function fnRadioClick() {
        var oUploadBtn = $("#uploadBtn");
        oUploadBtn.removeAttr("disabled");
        oUploadBtn.removeClass("common_button_disable");
        oUploadBtn.unbind("click");
        oUploadBtn.bind("click", changeUploadFile);
        oUploadBtn.click();
    }

    $(function() {
        $('select#contentTypeId').change(function() {
            var options = {
                url: '${detailURL}?method=changeContentType',
                params: {
                    contentTypeId: $(this).val(),
                    docResId: $('input#docResId').val(),
                    oldCTypeId: $('input#oldCTypeId').val()
                },
                success: function(json) {
                    $("div#extendDiv").html(json[0].htmlStr);
                }
            };
            getJetspeedJSON(options);
        });
        var oUploadBtn = $("#uploadBtn");
        oUploadBtn.attr("disabled", "disabled");
        oUploadBtn.addClass("common_button_disable");
        oUploadBtn.unbind("click");
    });

    function choseContentType() {
        var choseObj = document.getElementById('contentTypeId2');
        if (choseObj) {
            var docResId = document.getElementById('docResId').value;
            var selectValue = choseObj.options[choseObj.selectedIndex].value
            var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
                "checkDocResourceIsSystem", false);
            requestCaller.addParameter(1, "String", selectValue);
            requestCaller.addParameter(2, "String", docResId);
            var requestCaller = new XMLHttpRequestCaller(this, "ajaxHtmlUtil",
                "getNewHtml", false);
            requestCaller.addParameter(1, "long", selectValue);
            var ret = requestCaller.serviceRequest();
            document.getElementById('extendDiv').innerHTML = ret;
            var isSystem = requestCaller.serviceRequest();
            if (isSystem == 'true') {
                var button1 = document.getElementById("button1");
                if (button1) {
                    button1.disabled = true;
                }
            } else {
                var button1 = document.getElementById("button1");
                if (button1) {
                    button1.disabled = false;
                }
            }
        }
    }

    function fnFileUploadCallBack(fileid, repet) {
        document.getElementById("fileId").value = fileid;
    }
</script>
</head>
<body scroll="no" onunload="unlockAfterAction('${doc.id}');" style="background:rgb(250,250,250);">
<form name="myform" method="post" action="${detailURL}?method=modifyDoc" target="docFrame" id="myform">
<input type="hidden" name="docResId" id="docResId" value="${doc.id}"/>
<input type="hidden" name="docLibType" value="${param.docLibType}"/>    
<input type="hidden" name="oldCTypeId" value="${doc.frType}">
<input type="text" class="hidden" id="contentTypeId" id="contentTypeId" value="${doc.frType}">
<input type="hidden" id="fileId" name="fileId" value="${uploadFile.id}"/>
<input type="hidden" id="file_fileUrl" name="file_fileUrl" value="${uploadFile.id}"/>
<input type="hidden" id="file_mimeType" name="file_mimeType"/>
<input type="hidden" id="file_size" name="file_size"/>
<input type="hidden" id="file_createDate" name="file_createDate"/>
<input type="hidden" id="file_filename" name="file_filename"/>
<input type="hidden" id="file_type" name="file_type"/>
<input type="hidden" id="file_needClone" name="file_needClone"/>
<input type="hidden" id="file_description" name="file_description"/>
<input type="hidden" id="file_reference" name="file_reference"/>
<input type="hidden" id="file_subReference" name="file_subReference"/>
<input type="hidden" id="file_category" name="file_category"/>

<div class="form_area  margin_5" style="margin:0;padding:0px 20px;background: rgb(250,250,250);height:295px;color:#333;">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
        <tr align="left">
            <td nowrap="nowrap" align="right"><label for="text"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:</label></td>
            <td width="100%" colspan="4"><div class="common_txtbox_wrap">
                <fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
                	<input id="docSuffix" type="hidden" name="docSuffix" value="${docSuffix}" >
                    <input style="color:#999;" type="text" name="docName" id="docName" class="input-100per" maxSize="80" deaultValue="${defName}"  validate="isDeaultValue,notNull,notSpecCharWithoutApos" inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" value="<c:out value="${docPrefix}" escapeXml="true" default='${defName}' />" ${v3x:outConditionExpression(readOnly, 'readonly', '')} onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"/>
            </div></td>
        </tr>
          <c:choose>
             <c:when test="${contentTypeFlag == 'true'}">
                 <tr align="left">
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><fmt:message key='doclib.jsp.contenttype'/>:</label></th>
                    <td width="100%" colspan="4" ><div class="common_selectbox_wrap">
                             <select id="contentTypeId2" name="contentTypeId" class="input-100per" onchange="choseContentType()">
                                <c:forEach items="${contentTypes}" var="contentType">
                                    <option id="Opt${contentType.id}" value='${contentType.id}' <c:if test='${contentType.id==doc.frType}'>selected</c:if>>
                                        ${v3x:_(pageContext, contentType.name)}                     
                                        <script type="text/javascript">
                                            var opt = document.getElementById("Opt${contentType.id}");
                                            //alert(opt)
                                            opt.style.color = 'black';
                                        </script>
                                </c:forEach>
                            </select>
                    </div></td>
                </tr>
             </c:when>
            <c:otherwise>
                <input type="text" class="hidden" id="contentTypeId" id="contentTypeId" value="${doc.frType}">
            </c:otherwise>
        </c:choose>
        <tr><td colspan="5" class="padding_t_5 border_b">&nbsp;</td></tr>
        <c:if test="${!isCanEditOnline}">
            <tr class="padding_b_10">
                 <th nowrap="nowrap" colspan="5">
                     <div class="common_radio_box clearfix align_left margin_l_10" style="margin-bottom:16px;">
                        <label class="hand display_block" for="fileAction0">
                            <input id="fileAction0" class="radio_com" name="fileAction" value="0" type="radio" onclick="changeUploadFile();" checked><fmt:message key='doc.jsp.edit.file.hold'/></label>
                        
                        <label class="hand display_block nowrap" for="fileAction2">
                            <input id="fileAction2" class="radio_com" name="fileAction" value="2" type="radio" onclick="fnRadioClick();"><fmt:message key='doc.jsp.edit.file.replace'/>
                               <a disabled="disabled" class="common_button margin_l_5"  id="uploadBtn" href="javascript:void(0)"><fmt:message key='doc.jsp.edit.file.upload'/></a>
                                <div class="comp" comp="type:'fileupload',attachmentTrId:'position0',callMethod:'fnFileUploadCallBack',takeOver:false,applicationCategory:'3',canDeleteOriginalAtts:true,originalAttsNeedClone:false,isEncrypt:false,quantity:1"
                                                attsdata='${attachmentsJSON}'>
                                </div>
                        </label>
                     </div>
                </th>
            </tr>
            <tr class="padding_t_10">
                <v3x:fileUpload applicationCategory="3"/>
                <script>
                    var fileUploadQuantity = 1;
                </script>
                <td id="assdoc" noWrap="nowrap" class="border_t padding_t_10" style="padding-top:20px;">
                   <fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />
                          
                </td>
                <td class="border_t padding_t_10">
                    <div id="attachment2TRposition1" style="display:none;">(<span id="attachment2NumberDivposition1"></span>)</div>
                </td>
                 <td class="border_t padding_t_10" style="padding-top:20px;">
                    :
                </td>
                <td class="border_t padding_t_5" style="padding-top:20px;">
                  <a id="btnclose" onclick="quoteDocument('position1');"  class="common_button common_button_gray margin_l_10 clearfix" href="javascript:void(0)"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" /></a>
                </td>
                <td id="attachment1" class="border_t" colspan="1">
                    <div class="comp clearfix"
                        comp="type:'assdoc',attachmentTrId:'position1', modids:'1,3',applicationCategory:'3',referenceId:'${doc.id}'"
                        attsdata='${attachmentsJSON}'></div>
                </td> 
            </tr>
        </c:if>
        <tr>
            <td colspan="5" class="padding_t_10" align="left">
                <a id="btnclose" onclick="editDocProperties('0');" class="common_button common_button_gray margin_l_10" href="javascript:void(0)"><fmt:message key='doc.jsp.properties.label.advanced'/><fmt:message key='doc.log.setting'/></a>
            </td>
        </tr>
     </table>
</div>

<%@include file="docEditProperties.jsp"%>
</form>
<iframe name="docFrame" id="docFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
</body>
</html>
