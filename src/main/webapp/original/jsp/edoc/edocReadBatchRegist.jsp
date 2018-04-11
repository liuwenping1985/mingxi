<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<script type="text/javascript">
$(document).ready(function () {
    $("#process_info").click(function(){
        var selectPanels = "Department,Team,Post";
        var selectTypePara= "Member,Account,Department,Team,Post,Outworker,RelatePeople";
        var policyName= "${ctp:i18n('edoc.element.yuedu')}";
        createProcessXml("recEdoc",window,window,
                '${currentUserId}', '${ctp:escapeJavascript(currentUserName)}','${currentUserAccountName}',
                "yuedu",'${currentUserAccountId}','阅读',selectPanels,selectTypePara,false,null,null,'concurrent');
    });
    
    var paras = window.dialogArguments;
    
    function doAtts(attsJsonStr){
        if (attsJsonStr) {
            var atts = $.parseJSON(attsJsonStr);
            for ( var i = 0; i < atts.length; i++) {
                var att = atts[i];
                addAttachment(att.type, att.filename, att.mimeType, att.createDate, 
                  att.size, att.fileUrl, true,
                  true, att.description, att.extension, att.icon, att.reference, att.category, false);
            }
        }
    }

    if(paras != null){
        $("#comment").val(paras.commentContent);
        doAtts(paras.commentAttFiles);
        doAtts(paras.commentAttDocs);
    }
});

/**
 * 页面校验
 */

function OK() {
    //判断流程是否为空 
    var process_lc = $("#process_xml").val();
    if (!process_lc) {
        $.infor({
            'imgType' : 2,
            msg : "${ctp:i18n('collaboration.forward.workFlowNotNull')}",
            ok_fn : function() {
                $("#process_info").click();
            }
        });
        return -1;
    }
    //$("#processXml").val(process_lc);

    //工作流内容
    //判断附言字数2000以内
    var commentLength = $("#comment").val().length;
    if (commentLength > 2000) {
        var warnStr = "${ctp:i18n('edoc.readBatch.comment')}";
        warnStr = warnStr.replace("{0}", commentLength);
        var mbox = $.messageBox({
            'title' : "${ctp:i18n('system.prompt.js')}",
            'imgType' : 2,
            'msg' : warnStr,
            ok_fn : function() {
                $("#comment").select();
            }
        });
        return -1;
    }
    var comment_val = $("#comment").val();//设置附言内容
	var returnValue= new Array();
	returnValue[0]= process_lc;
	returnValue[1]= comment_val;
    return returnValue;
}
</script>
</head>
<body class="h100b over_hidden page_color ">
<form method="post" id="sendForm" name="sendForm" action=''>
<table id="selectPeopleTable" width="100%" height="100%" border="0" class="bg-body" align="center" cellpadding="0" cellspacing="0">
    <tr valign="top">
        <td>
            <div id="MainData" class="font_size12">
                <input type="hidden" id="registerStr" name="registerStr" value="${param.data}"/>
                <input type="hidden" id="processXml" name="processXml" value=""/>
                <div class="padding_10">
                	<c:if test="${openType eq 'dengji'} ">
	                    <p class="line_height160">${ctp:i18n('edoc.toolbar.batchRegist.label')} </p><!-- 阅文批量登记 -->
                	</c:if>
                	<c:if test="${openType eq 'fenfa'} ">
	                    <p class="line_height160">${ctp:i18n('batch.read.title')}</p>
                	</c:if>
                    <div class="common_txtbox_wrap">
                        <!-- 点击新建流程 -->
                        <input type="text" id="process_info" value="${ctp:i18n('default.workflowInfo.value')}">
                    </div>
                    <div class="common_txtbox  clearfix">
                        <textarea cols="30" style="height: 270px" name="comment" id="comment" validate="maxLength:2000" class="validate w100b"></textarea>
                    </div>
                    <p class="green">${ctp:i18n('collaboration.forward.page.label1')}</p>
                </div>
            </div>
            <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
        </td>
    </tr>
</body>
</html>