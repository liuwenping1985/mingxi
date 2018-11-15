<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title></title>
</head>
<body scroll="no">
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="font_size12 margin_t_10">
    <tr>
        <td>
            <table cellspacing="2" cellpadding="2" width="95%" border="0">
                <tr>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.parent.folder.label')}：
                    </td>
                    <td width="250" class="padding_t_10">
                        <div class="common_txtbox_wrap">
                            <input type="text" id="parentFolder" name="parentFolder" class="hand" value=""
                                   readonly="readonly"/>
                            <input type="hidden" id="parentFolderId" name="parentFolderId" value=""/>
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                </tr>
                <tr>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.folder.label')}：
                    </td>
                    <td width="250" class="padding_t_10">
                        <div class="common_selectbox_wrap" style="line-height: 26px;">
                            <select id="folder" name="folder" style="margin: 0px; height: 24px;">
                                <option value=""></option>
                                <c:forEach var="field" items="${fieldList}">
                                    <option id="${field['id']}" value="${field['name']}" display="{${field['display']}}">${field['display']}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                </tr>
                <tr>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100" class="padding_t_10">&nbsp;</td>
                    <td width="250" class="padding_t_10">
                        <label for="isCreate" class="hand">
                            <input type="checkbox" id="isCreate" name="isCreate" checked="checked"/>
                            <span class="margin_l_5">${ctp:i18n('form.bind.set.pigeonhole.folder.create.label')}</span>
                        </label>
                    </td>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                </tr>
                <!-- 文档关键字 -->
                <tr height="30px">
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.archive.keyword.label')}：
                    </td>
                    <td class="padding_t_10" nowrap="nowrap">
                        <div class=" common_txtbox_wrap">
                            <input readonly="readonly" id="archiveKeyword" name="archiveKeyword" type="text" class="w100b validate"
                                   validate="type:'string',china3char:true,maxLength:255,name:'${ctp:i18n('form.bind.set.pigeonhole.archive.keyword.label')}'">
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">
                        <a class="common_button margin_l_5" href="javascript:void(0)" id="archiveKeywordSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                    </td>
                </tr>
                <tr>
                <td width="50" class="padding_t_10">&nbsp;</td>
                    <td colspan="2" align="center"> 
                    	<label style="color: red;">
                    		<c:if test="${redTemplete != 'true' }">
                    			${ctp:i18n('form.bind.set.pigeonhole.archivecontent.attachmentNoBody.label')}
                    		</c:if>
                    		<c:if test="${redTemplete == 'true' }">
                    			${ctp:i18n('form.bind.set.pigeonhole.archivecontent.attachment.label')}
                    		</c:if>
                    	</label>
                    </td>
                <td width="50" class="padding_t_10">&nbsp;</td>
                </tr>
                <!-- 预归档内容 表单 正文 需求调整，只显示一个控件，为“仅正文” -->
                <tr id="hasredTemplete" <c:if test="${redTemplete != 'true' }">class="hidden"</c:if> >
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.archivecontent.label')}：
                    </td>
                    <td width="250" class="padding_t_10">
                        <label for="archiveText" class="hand">
                            <input type="checkbox" id="archiveText" name="archiveText"/>
                            <span class="margin_l_5">${ctp:i18n('form.bind.set.pigeonhole.archivetext.label')}</span>
                        </label>
                        <label for="archiveAttachment" class="hand" style="margin-left:20px;">
                            <input type="checkbox" id="archiveAttachment" name="archiveAttachment"/>
                            <span class="margin_l_5">${ctp:i18n('form.bind.set.pigeonhole.archiveAttachment.label')}</span>
                        </label>
                    </td>
                    <td width="50" class="padding_t_10">&nbsp;</td>
                </tr>
                <!-- 归档后正文名称 -->
                <tr class="hidden" id="archivecont">
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.archivetext.name.label')}：
                    </td>
                    <td width="250" class="padding_t_10" nowrap="nowrap">
                        <div class=" common_txtbox_wrap">
                            <input readonly="readonly" id="archiveTextName" name="archiveTextName" type="text" class="w100b validate"
                                   validate="type:'string',china3char:true,maxLength:255,name:'${ctp:i18n('form.bind.set.pigeonhole.archivetext.name.label')}'">
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">
                        <a class="common_button margin_l_5"
                           href="javascript:void(0)"
                           id="archiveTextNameSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                    </td>
                </tr>
                <tr id="archiveAttachmentPath"><!-- 附件归档目录 -->
                    <td width="50" class="padding_t_10">&nbsp;</td>
                    <td align="right" width="100"
                        class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.attachmentArchiveName.name.label')}:
                    </td>
                    <td width="250" class="padding_t_10" nowrap="nowrap">
                        <div class=" common_txtbox_wrap">
                            <input id="attachmentArchiveName" name="attachmentArchiveName" readonly="readonly" type="text" class="w100b validate">
                       		<input type="hidden" id="attachmentArchiveId" name="attachmentArchiveId" value=""/>
                        </div>
                    </td>
                    <td width="50" class="padding_t_10">
                        <a class="common_button margin_l_5"
                           href="javascript:void(0)"
                           id="clearTextName">${ctp:i18n('form.bind.set.pigeonhole.clear.js')}</a><!-- 清除 -->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
<script type="text/javascript">
    var transParams = window.dialogArguments;
    $().ready(function () {
        //上级文件夹
        $("#parentFolderId").val(transParams.parentFolderId);
        if (transParams.parentFolderName == "") {
            $("#parentFolder").val("${ctp:i18n('form.timeData.none.lable')}");
        } else {
            $("#parentFolder").val(transParams.parentFolderName);
            $("#parentFolder").attr("title",transParams.parentFolderName.escapeHTML());
        }
        //预归档到
        $("#folder").val(transParams.fieldName);
        //若不存在则创建
        if (transParams.isCreate == "true") {
            $("#isCreate").attr("checked", true);
        } else {
            $("#isCreate").attr("checked", false);
        }

        //归档内容 正文
        if (transParams.archiveText == "true") {
            $("#archiveText").attr("checked", true);
            <c:if test="${redTemplete == 'true' }">
            $("#archivecont").removeClass("hidden");
            </c:if>
        } else {
            $("#archiveText").attr("checked", false);
            $("#archivecont").removeClass("hidden").addClass("hidden");
        }
        //附件归档路径
        if (transParams.archiveAttachment == "true") {
            $("#archiveAttachment").attr("checked", true);
        } else{
        	<c:if test="${redTemplete == 'true' }">
        	$("#archiveAttachment").attr("checked", false);
        	$("#archiveAttachmentPath").removeClass("hidden").addClass("hidden");
            </c:if>
        } 
      
        //归档后正文名称
        $("#archiveTextName").val(transParams.archiveTextName);
        //附件归档路径
         $("#attachmentArchiveName").val(transParams.attachmentArchiveName);
         $("#attachmentArchiveId").val(transParams.attachmentArchiveId);
        //文档关键字
        $("#archiveKeyword").val(transParams.archiveKeyword);

        //上级文件夹事件
        $("#parentFolder").click(function () {
            pigeonhole(2, null, false, false, "fromTempleteManage", "pigeonholeCallback");
        });
        //附件归档路径事件
        $("#attachmentArchiveName").click(function () {
            pigeonhole(2, null, false, false, "fromTempleteManage", "pigeonholeFileCallback");
        });
        //正文框事件
        $("#archiveText").change(function () {
            $("#archiveTextName").val("");
            if ($("#archiveText").attr("checked")) {
                $("#archivecont").removeClass("hidden");
            } else {
                $("#archivecont").removeClass("hidden").addClass("hidden");
            }
        });
        //附件框事件
        $("#archiveAttachment").change(function () {
           $("#attachmentArchiveName").val("");
            if ($("#archiveAttachment").attr("checked")) {
                $("#archiveAttachmentPath").removeClass("hidden");
            } else {
                $("#archiveAttachmentPath").removeClass("hidden").addClass("hidden");
            }
        });
        //归档后正文名称设置事件
        $("#archiveTextNameSet").click(function () {
            if ($("#process_info").val() == "" || $("#process_info").val() == "undefined" || $("#process_info").val() == "null") {
                $.alert("${ctp:i18n('form.bind.setFlow.err')}");
                return false;
            }
            //将名称后缀去掉，在返回的时候再加上
            var textName = $("#archiveTextName").val();
            if(textName){
                textName = textName.substring(0,textName.length - 4);
            }
            var formulaArgs = getFormulaArgs(function (formulaStr) {
                if(formulaStr){
                    $("#archiveTextName").val(formulaStr + ".doc");
                }else{
                    $("#archiveTextName").val("");
                }
            }, '0', "formula_archiveset", textName, null);
            formulaArgs.title = "${ctp:i18n('form.bind.set.pigeonhole.archivetext.name.label')}";
            formulaArgs.noCheck = true;
            formulaArgs.flowTitle = true;//正文名称和关键字同流程标题设置一样的处理，只是仅显示数据域
            formulaArgs.allowSubFieldAloneUse = false;//edit by chenxb from true to false bug OA-88505
            showFormula(formulaArgs);
        });
        //文档关键字设置事件
        $("#archiveKeywordSet").click(function () {
            if ($("#process_info").val() == "" || $("#process_info").val() == "undefined" || $("#process_info").val() == "null") {
                $.alert("${ctp:i18n('form.bind.setFlow.err')}");
                return false;
            }
            //_formulaType_varchar
            var formulaArgs = getFormulaArgs(function (formulaStr) {
                $("#archiveKeyword").val(formulaStr);
            }, '0', "formula_archiveset", $("#archiveKeyword").val(), null);
            formulaArgs.title = "${ctp:i18n('form.bind.set.pigeonhole.archive.keyword.set.label')}";
            formulaArgs.noCheck = true;
            formulaArgs.flowTitle = true;//正文名称和关键字同流程标题设置一样的处理，只是仅显示数据域
            formulaArgs.allowSubFieldAloneUse = false;//edit by chenxb from true to false bug OA-88505
            showFormula(formulaArgs);
        });
        //清除附件归档目录
        $("#clearTextName").click(function (){
        	$("#attachmentArchiveName").val("");
        	$("#attachmentArchiveId").val("");
        });
    });

    //上级文件夹事件回调函数
    function pigeonholeCallback(re) {
        if ("cancel" != re && "" != re) {
            var r = re.split(",");
            var bManager = new formBindDesignManager();
            var fullPath = bManager.getDocResFullPath(r[0]);
            $("#parentFolder").val(fullPath);
            $("#parentFolderId").val(r[0]);
        }
        if($("#parentFolder").val() != ""){
            $("#parentFolder").attr("title",$("#parentFolder").val().escapeHTML());
        }
    }

    function OK() {
        var parentFolderId = $("#parentFolderId").val();
        //var attachmentArchiveId = $("#attachmentArchiveId").val();
        var folder = $("#folder").find("option:selected");
        var folderValue = $("#folder").val();
        if (parentFolderId == "" && folderValue != "") {
            $.alert("${ctp:i18n('form.bind.set.pigeonhole.parent.folder.error.label')}");
            return false;
        }
        if ($("#archiveText").attr("checked") && (!$("#archiveTextName").val())) {
            $.alert("${ctp:i18n('form.bind.set.pigeonhole.archive.text.name.error.label')}");
            return false;
        }
        if ($("#archiveAttachment").attr("checked") && (!$("#attachmentArchiveName").val()) && !$("#hasredTemplete").is('.hidden')) {
            $.alert("${ctp:i18n('form.bind.set.pigeonhole.attachmentarchive.text.name.error.label')}");
            return false;
        }
        var obj = {};
        obj.parentFolderId = parentFolderId;
        obj.parentFolderName = $("#parentFolder").val();
        //obj.attachmentArchiveId = attachmentArchiveId;
        obj.fieldName = folderValue;
        obj.fieldDisplay = folder.attr("display");
        if ($("#isCreate").attr("checked")) {
            obj.isCreate = "true";
        } else {
            obj.isCreate = "false";
        }
        if ($("#archiveText").attr("checked")) {
            obj.archiveText = "true";
        } else {
            obj.archiveText = "false";
        }
        
        if($("#archiveAttachment").attr("checked")){
        	obj.archiveAttachment = "true";
        }else{
        	obj.archiveAttachment = "false";
        }
        obj.archiveTextName = $("#archiveTextName").val();
        obj.attachmentArchiveName = $("#attachmentArchiveName").val();
         if($("#attachmentArchiveName").val()=="" || $("#attachmentArchiveName").val()==null){
        	obj.attachmentArchiveId = "";
        }else{ 
        	obj.attachmentArchiveId = $("#attachmentArchiveId").val();
        } 
        
        obj.archiveKeyword = $("#archiveKeyword").val();
        return obj;
    }
    
    //附件归档路径事件回调函数
    function pigeonholeFileCallback(re) {
        if ("cancel" != re && "" != re) {
            var r = re.split(",");
            var bManager = new formBindDesignManager();
            var fullPath = bManager.getDocResFullPath(r[0]);
            $("#attachmentArchiveName").val(fullPath);
            $("#attachmentArchiveId").val(r[0]);
        }
        if($("#attachmentArchiveName").val() != ""){
            $("#attachmentArchiveName").attr("title",$("#attachmentArchiveName").val().escapeHTML());
        }
    }
</script>
</html>