<%--
 $Author: muj$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n('collaboration.transmit.col.label')}</title>
<c:set value="${param.showType eq 'model'}" var="isModel" />
<script type="text/javascript">
var paras =transParams || transParams.parentWin;
$(document).ready(function () {
    $("#process_info").click(function(){
    	var col = new colManager(); 
    	var defaultNodeMap =  col.getColDefaultNode($.ctx.CurrentUser.loginAccount);
        createProcessXmlForward('1', window, window, false, "${param.showType eq 'model' ? '' : ''}",defaultNodeMap.defaultNodeName,defaultNodeMap.defaultNodeLable);
    });
    
    
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
* 防表单重复提交
* @type {boolean}
 */
var submitting = false;

function OK(){
    //判断流程是否为空 
    var process_lc = $("#process_xml").val();
    if(!process_lc){
        $.infor({
        	'imgType':2,
            msg : "${ctp:i18n('collaboration.forward.workFlowNotNull')}",
            ok_fn: function () {
                $("#process_info").click();
            }
        });
        return -1;
    }
    //判断附言字数2000以内
    var commentLength = $("#comment").val().length;
    if(commentLength>2000){
    	var warnStr="${ctp:i18n('collaboration.forward.commentwbzyn')}";
    	warnStr=warnStr.replace("{0}",commentLength);
    	var mbox = $.messageBox({
    		'title':"${ctp:i18n('system.prompt.js')}",
    		'imgType':2,
    	    'msg': warnStr,
    	    ok_fn:function () { $("#comment").select();}
    	});
    	return -1;
    }
    
    var domains = [];
    $.content.getWorkflowDomains("1", domains);
    domains.push('MainData');

    if(submitting){
        return;
    }
    submitting = true;

    $("#sendForm").jsonSubmit({
        beforeSubmit: function(){
            $("#tb1").disable();
            $("#tb2").disable();
            try{
                window.parentDialogObj.showForwardDialog.disabledBtn('okButton');
                window.parentDialogObj.showForwardDialog.disabledBtn('cancelButton');
            }
            catch(e){
            }
        },
        domains : domains,
        debug : false,
        callback : function(rs){
            submitting = false;
            $.infor({
                msg: "${ctp:i18n('collaboration.forward.forwardSuccess')}",
                ok_fn: function () {
                    _closeInfoFn();
                },
                close_fn:function(){
                    _closeInfoFn();
                 }
            });
        }
    });
    
    return -1;
}

//转发成功后回调函数
function _closeInfoFn(){
    try{
        //OA-71478【项目协同】更多页面，【转发】文字链接显示错误，且点击不动---老bug
        //刷新关联项目更多页面
        window.top.$("#main")[0].contentWindow.$("#body")[0].contentWindow.refreshProjectWindow();
    }catch(e){
    }
    try{
        //项目协同转发刷新栏目
        getA8Top().up.refreshSection();
    }catch(e){}
    
    if(window.parentDialogObj && window.parentDialogObj.showForwardDialog){
        setTimeout(function(){
            window.parentDialogObj.showForwardDialog.buttons[0].OKFN();            
        }, 10);
    }
    else{
        transParams.parentWin.callbackForwardColV3x();
        closeWindow();
    }
}

function setCssOverFlow(){
	//alert(2);
	//if($.browser.msie && $.browser.version =='7.0'){
	    $("#attachment2Area").css("overflow","hidden");
	    $("#attachment2Area").css("max-height","none");
	//}
}
function closeWindow(){
	getA8Top().toCollWin.close();
}
</script>
</head>
<body class="h100b over_hidden page_color ">
<form method="post" id="sendForm" name="sendForm" action='collaboration.do?method=doForward'>
<table id="selectPeopleTable" width="100%" height="100%" border="0" class="bg-body" align="center" cellpadding="0" cellspacing="0">
    <tr valign="top">
        <td>
            <div id="MainData" class="font_size12">
                <input type="hidden" id="data" name="data" value="${ctp:toHTML(param.data)}"/>
                <div style="padding:16px 20px;">
                    <p class="line_height160" style="width: 112px;text-align: right; padding-right: 5px;float: left;float: left;">${ctp:i18n('collaboration.forward.selectForwardMenuber')}</p>
                    <div class="common_txtbox_wrap" style="float:left;width: 340px;display:inline-block;">
                        <!-- 点击新建流程 -->
                        <input style="color:#333;" type="text" id="process_info" value="${ctp:i18n('collaboration.default.workflowInfo.value')}">
                    </div>
                    <p class="line_height160 padding_t_5" style="width: 110px;color:#333;padding-right: 7px;float: left;float: left;text-align:right">${ctp:i18n('collaboration.forward.postscript')}</p>
                    <div class="common_txtbox  clearfix" style="float:left;width: 350px;margin-top:6px;">
                        <textarea cols="30" style="height: 100px;color:#333;" name="comment" id="comment" validate="maxLength:2000" class="validate w100b"></textarea>
                    </div>
                    <p class="green" style="float: left; width: 340px; padding-left:120px;">${ctp:i18n('collaboration.forward.page.label1')}</p>
                    <!--最后一个不用margin_r_10-->
                    <div class="common_checkbox_box clearfix margin_t_10" style="float: left;color:#333; width: 340px;margin-top:20px;padding-left:120px;">
                        <label for="forwardOriginalNote" class="margin_r_10 hand">
                            <!-- 转发原附言 -->
                            <input type="checkbox" value="1" id="forwardOriginalNote" name="forwardOriginalNote" class="radio_com" checked="checked">${ctp:i18n('collaboration.forward.page.label2')}</label>
                        <label for="forwardOriginalopinion" class="margin_r_10 hand">
                            <!-- 转发原意见 -->
                            <input type="checkbox" value="1" id="forwardOriginalopinion" name="forwardOriginalopinion" class="radio_com" checked="checked">${ctp:i18n('collaboration.forward.page.label3')}</label>
                        <label for="track" class="margin_r_10 hand">
                            <!-- 跟踪 -->
                            <input type="checkbox" value="1" id="track" name="track" class="radio_com" checked="checked">${ctp:i18n('collaboration.forward.page.label4')}</label>
                    </div>
                    <div class="margin_t_5" style="float: left; width: 340px;margin-top:20px;padding-left:120px;">
                    	<c:if test="${newColNodePolicy.uploadAttachment}">
                        	<a href="javascript:insertAttachment()"><span class="ico16 affix_16  margin_r_5"></span>${ctp:i18n("common.attachment.label")}</a> (<span id="attachmentNumberDiv">0</span>)
                        </c:if>
                        <c:if test="${newColNodePolicy.uploadRelDoc}">
                        	<a href="javascript:quoteDocument()"><span class="ico16 associated_document_16  margin_r_5"></span>${ctp:i18n('collaboration.attachment.relation')}</a> (<span id="attachment2NumberDiv">0</span>)
                        </c:if>
                    </div>
                    <div class="newinfo_area margin_t_5" style="float: left; width: 470px;margin-top:10px;">
                        <div class="content_area" id="commentAttFilesDiv" style="overflow: hidden">
                            <div id="commentAttFiles" class="comp" comp="type:'fileupload',applicationCategory:'1'" ></div>
                        </div>
                    </div>
                    <div class="newinfo_area margin_t_5" style="float: left; width: 470px;margin-top:10px;">
                        <div class="content_area" id="commentAttDocsId">
                            <div id="commentAttDocs" class="comp" comp="type:'assdoc', modids:'1,3'"></div>
                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
        </td>
    </tr>
    </table>
    
    <c:if test="${param.showType eq 'model'}">
        <div  id="btns" class="stadic_layout_footer stadic_footer_height page_color align_right" style="background:#4d4d4d;color:#fff;height:50px;">
                <input id="tb1" type="button" onClick="OK();" value="${ctp:i18n('common.button.ok.label')}" class="common_button  margin_t_10 common_button_emphasize" style="linn-height:28px; height: 30px; padding: 0 21px;">&nbsp;
                <input id="tb2" type="button" onclick="closeWindow();"  value="${ctp:i18n('common.button.cancel.label')}" class="common_button common_button_gray margin_t_10 margin_r_10" style="linn-height:28px; height: 30px; padding: 0 21px;">
        </div>
    </c:if>
    </form>
</body>
</html>
