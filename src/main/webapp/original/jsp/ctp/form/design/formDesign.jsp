<%--
  Created by IntelliJ IDEA.
  User: daiyi
  Date: 2015-12-2
  Time: 13:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
    <c:set var="isNewForm" value="${formBean.newForm }"/>
    <c:if test="${formBean.formType eq 2 }">
        <title>${ctp:i18n('form.base.formtype.message.make.title')}</title>
    </c:if>
    <c:if test="${formBean.formType eq 1 }">
        <title>${ctp:i18n('form.base.formtype.templete.make.title')}</title>
    </c:if>
    <c:if test="${formBean.formType eq 3 }">
        <title>${ctp:i18n('form.base.formtype.basedata.make.title')}</title>
    </c:if>
    <c:if test="${isNewForm }">
        <style>
            .step_menu li.step_complate_last span {
                color: #d2d2d2;
            }
        </style>
    </c:if>
</head>
<body style="height: 100%;overflow: hidden" >
<div id="layout" class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,border:false,sprit:false">
        <form action="${path}/form/fieldDesign.do?method=formDesignSave" id="topForm"></form>
        <div class="page_color step_menu clearfix margin_tb_5 margin_l_10">
            <ul id="topUl">
                <c:forEach items="${managers}" var="manager" varStatus="status">
                    <li style="cursor: pointer;" class="${status.first ? 'first_step current' : ''} ${isNewForm?'':'step_complate' } ${status.last ? 'last_step' : ''}" id="${manager.id}li" step="nextStep" source="/seeyon/${manager.url}">
                            ${status.last ? '' : '<b> </b>'}
                        <span>${manager.moduleName }</span>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div id="designContent" class="layout_center" style="overflow: hidden">
        <div style="width: 100%;height: 100%;">
            <iframe id="contentIframe" formId="${formBean.id}" src="" width="100%" height="100%" frameborder="no"></iframe>
        </div>
    </div>
    <div class="layout_south  page_color bg_color" layout="height:40,border:false,sprit:false" style="text-align: center;margin-top: 5px;">
        <form action="${path}/form/formDesign.do?method=save4design&formId=${formBean.id}" id="bottomForm"></form>
        <div id="buttom_table" class="page_color align_right" style="width:100%;height:40px;overflow:hidden;bottom:0;">
            <div style="margin-right: 50px">
                <c:if test="${subTableSize >= 2 and isAdvanced eq true}" >
                    <a id="subRelation" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.baseinfo.subtable.relation.label') }">${ctp:i18n('form.baseinfo.subtable.relation.label') }</a>
                </c:if>
                <a id="upStep" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.pagesign.ascendpace.label') }">${ctp:i18n('form.pagesign.ascendpace.label') }</a>
                <a id="nextStep" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.pagesign.nextpace.label') }">${ctp:i18n('form.pagesign.nextpace.label') }</a>
                <a id="finish" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.pagesign.finish.label') }">${ctp:i18n('form.pagesign.finish.label') }</a>
                <c:if test="${canCreate}">
                    <a id="otherFormSave" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.baseinfo.othersave') }">${ctp:i18n('form.baseinfo.othersave') }</a>
                </c:if>
                <a id="doSaveAll" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.pagesign.savethispage') }">${ctp:i18n('form.pagesign.savethispage') }</a>
                <a id="doReturn" href="javascript:void(0)" class="common_button common_button_gray" style="display: none" title="${ctp:i18n('form.pagesign.quit.label') }">${ctp:i18n('form.pagesign.quit.label') }</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/form/design/top.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var changePageNoAlert = false;//离开页面是否需要提醒
    var canSaveData = true;
    var isReturn = false;
    var isNewForm = ${isNewForm};
    var tableFlag = ${tableFlag};

    /**
     * 跳转到表单列表界面
     */
    function toListPage() {
        winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
    }

    function bindEvent() {
        if(!isNewForm){
            ShowTop();
        }
        $("#upStep").click(function(){
            if (validateAndSaveData()) {
                showPrev();
            }
        });
        $("#nextStep").click(function(){
            if (validateAndSaveData()) {
                showNext();
            }
        });
        $("#finish").unbind("click").bind("click",function(){
            saveAll();
        });
        $("#otherFormSave").click(function(){
            if (validateCurrentData()) {
                changePageNoAlert=true;
                otherOpen('bottomForm');
            }
            enableShowBtn();
        });
        $("#doSaveAll").unbind("click").bind("click",function(){
            saveAll();
        });
        $("#doReturn").click(function(){

            changePageNoAlert = false;
            if(tableFlag == true){
                self.close();

            }else{
                toListPage();
            }
        });

        $("#subRelation").click(function(){
            getCurrentWindow().subTableRelationSet();
        });

        window.onbeforeunload = function (event) {
            var e = event || window.event;
            if (!changePageNoAlert) {
                if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
                    e.returnValue = " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
                }else{
                    e.returnValue = ""; //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
                }

            }else {
                return;
            }
        };

        window.onunload = function() {
            var fm = new formManager();
            fm.removeEditForm();
            var wfDynamicForm = new wFDynamicFormManager();
            wfDynamicForm.removeMacthDataFromCache("${formBean.id}");
            if(getCtpTop().processBar)getCtpTop().processBar.close();
            getCtpTop().isFormEditer=false;
            getCtpTop().isLeaveFormEditer=true;
        };
        getCtpTop().isFormEditer=true;
        getCtpTop().isLeaveFormEditer=false;
    }
    function saveAll(){
        disableShowBtn();
        var tempObj = $("#bottomForm");
        var actionUrl = tempObj.attr("action");
        if (!validateAndSaveData()) {
            enableShowBtn();
            return;
        }
        changePageNoAlert = true;
        if (formState4Save == "0" || formState4Save == "-1" || formState4Save == "-2") {
            $.confirm({
                'msg': "${ctp:i18n('form.base.saveFormAlert')}",
                ok_fn: function () {
                    getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                    makeMask(getCtpTop().processBar);
                    actionUrl = actionUrl + "&state=2";
                    if(tableFlag){
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {
                            },callback: function () {
                                self.close();
                            }
                        });
                    }else {
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {

                            }
                        });
                    }
                },
                cancel_fn: function () {
                    getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                    makeMask(getCtpTop().processBar);
                    if(tableFlag){
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {
                            },callback: function () {
                                self.close();
                            }
                        });
                    }else {
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {
                            }
                        });
                    }
                }
            });
            enableShowBtn();
        } else {
            if (canSaveData) {
                if ("doReturn" == $(this).prop("id")) {//返回的时候需要提示
                    isReturn = true;
                    window.location.href = $("#bottomForm").prop("action") + "&step=doReturn";
                } else {
                    getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                    makeMask(getCtpTop().processBar);
                    if(tableFlag == true){
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {}, callback: function () {
                                self.close();
                            }
                        });
                    }else{
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {}
                        });
                    }
                }
            }
        }

    }
    //OA-91962	表单制作-保存表单制作时，点击了二维码设置的计算公式箭头图标，直接报异常.
    //不知道为什么，这里创建的进度条没有遮罩了。
    function makeMask(processBar){
        //获取客户端页面宽高
        var _client_width = document.body.clientWidth;
        var _client_height = (document.documentElement.scrollHeight>document.documentElement.clientHeight?document.documentElement.scrollHeight:document.documentElement.clientHeight);
        var maskId = processBar.id;
        $("body").prepend("<div id='" + maskId + "_mask' class='mask' style='width:" + _client_width + "px;height:" + _client_height + "px;'>&nbsp;</div>");
        if ($.browser.msie && ($.browser.version == '8.0')) {
            $(".mask").css("position","absolute");
        }
    }

    var formState4Save;
    <c:if test="${formBean != null}">
    formState4Save = "${formBean.state}";
    </c:if>
    <c:if test="${fb != null}">
    formState4Save = "${fb.state}";
    </c:if>
    $(document).ready(function () {
        closeProcessBar();
        showCurrent();
        bindEvent();
    });
    function otherOpen(form) {
        var url = '${path}/form/fieldDesign.do?method=formohterPage';
        dialog = $.dialog({
            url: url,
            title: "${ctp:i18n('form.baseinfo.othersave')}",
            width: 600,
            height: 500,
            transParams: window,
            targetWindow: getCtpTop(),
            closeParam: {
                'show': true,
                handler: function () {
                    enableShowBtn();
                }
            },
            buttons: [{
                text: "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
                id: "sure",
                isEmphasize: true,
                handler: function () {
                    dialog.startLoading();
                    dialog.disabledBtn("sure");
                    dialog.disabledBtn("exit");
                    // proce.start();
                    var formobj = getCurrentData();
                    if (dialog.getReturnValue() == null) {
                        dialog.endLoading();
                        dialog.enabledBtn("sure");
                        dialog.enabledBtn("exit");
                        return;
                    }
                    var obj = $.parseJSON(dialog.getReturnValue());
                    if (obj['formnewname'].length === 0) {
                        dialog.endLoading();
                        $.alert("${ctp:i18n('form.forminputchoose.titlecantnull')}");
                        dialog.enabledBtn("sure");
                        dialog.enabledBtn("exit");
                        return;
                    }
                    var form = new formFieldDesignManager();
                    getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                    makeMask(getCtpTop().processBar);
                    form.otherFormSave(formobj, obj, {
                        success: function (retObj) {
                            dialog.endLoading();
                            if (retObj && retObj.success) {
                                $.messageBox({
                                    'title': "${ctp:i18n('form.base.dealmessage.label')}",
                                    'imgType': 0,
                                    'type': 0,
                                    'msg': "${ctp:i18n('form.formlist.savesucess')}",
                                    ok_fn: function () {
                                        dialog.close();
                                        $("#otherFormSave").removeProp("disabled");
                                        if(tableFlag == true){
                                            self.close();
                                        }else{
                                            toListPage();
                                        }
                                    }, close_fn: function () {
                                        dialog.close();
                                        $("#otherFormSave").removeProp("disabled");
                                        if(tableFlag == true){
                                            self.close();
                                        }else{
                                            toListPage();
                                        }
                                    }
                                });
                            } else {
                                if (retObj.showUnFlowFormList) {
                                    retObj.callback = function() {
                                        if(tableFlag == true){
                                            self.close();
                                        }else{
                                            toListPage();
                                        }
                                    };
                                    retObj.ok_fn = function(){
                                        if(tableFlag == true){
                                            self.close();
                                        }else{
                                            toListPage();
                                        }
                                    };
                                    showMsg4BizValidate(retObj);
                                } else {
                                    $.alert({
                                        msg:retObj.msg,
                                        ok_fn:function(){
                                            dialog.close();
                                            if(tableFlag == true){
                                                self.close();
                                            }else{
                                                toListPage();
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        error: function (retObj) {
                            dialog.endLoading();
                            $.messageBox({
                                'title': "${ctp:i18n('form.base.dealmessage.label')}",
                                'imgType': 1,
                                'type': 0,
                                'msg': $.parseJSON(retObj.responseText).message,
                                ok_fn: function () {
                                    dialog.close();
                                    if(tableFlag == true){
                                        self.close();
                                    }else{
                                        toListPage();
                                    }
                                }, close_fn: function () {
                                    dialog.close();
                                    if(tableFlag == true){
                                        self.close();
                                    }else{
                                        toListPage();
                                    }
                                }
                            });
                        }
                    })
                }
            }, {
                text: "${ctp:i18n('form.query.cancel.label')}",
                id: "exit",
                handler: function () {
                    dialog.close();
                    $("#otherFormSave").prop("disabled", false);
                }
            }]
        });
    }
</script>
</body>
</html>
