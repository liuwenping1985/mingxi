<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=enumManagerNew"></script>
<script type="text/javascript">
    var ssTest = {'show': ['upStep', 'finish'], 'source': {'upStep': 'ertt', 'nextStep': ''}, 'module': 'field'}
    var tempFormSubmitObj;
    var changePageNoAlert = false;//离开页面是否需要提醒
    if (getCtpTop().processBar)getCtpTop().processBar.close();
    var canSaveData = true;
    var isReturn = false;
    function winReflesh(u, win) {//刷新页面
        if (win == null) {
            win = window;
        }
        changePageNoAlert = true;
        if (u == null) {
            win.location.reload();
        } else {
            win.location.href = u;
        }
    }
    function ShowBottom(obj, formObj) {
        window.onbeforeunload = function (e) {
            var e = e || window.event;
            if (!changePageNoAlert) {
                if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
                    e.returnValue = " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
                }else{
                    e.returnValue = ""; //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
                }

            }
        }
        tempFormSubmitObj = formObj;
        var show = obj.show;
        var source = obj.source;
        if (show) {
            for (var s = 0; s < show.length; s++) {
                $("#" + show[s], "#buttom_table").parent().removeClass("hidden");
            }
        }
        if ($("li.current", "#topUl").hasClass("last_step")) {
            $("#nextStep").parent().removeClass("hidden").addClass("hidden");
        }
        if (source) {
            for (var s in source) {
                $("#" + s, "#buttom_table").attr("source", source[s]);
            }
        }
        if (obj.module) {
            $("input", "#buttom_table").attr("module", obj.module);
        }
        $("#moveControl").parent().removeClass("hidden");
    }
    var formState4Save;
    <c:if test="${formBean != null}">
    formState4Save = "${formBean.state}";
    </c:if>
    <c:if test="${fb != null}">
    formState4Save = "${fb.state}";
    </c:if>
    $(document).ready(function () {
        if (getCtpTop().processBar)getCtpTop().processBar.close();
        $("input", "#buttom_table").click(function () {
            if (getCtpTop().processBar) {
                getCtpTop().processBar.close();
            }
            //返回还是需要提示离开页面的
            if ("doReturn" != $(this).prop("id")) {
                changePageNoAlert = true;
            }
            //如果是保存全部按钮，那么将这个按钮禁用，防止两次点击
            if ("doSaveAll" == $(this).prop("id")) {
                $("#doSaveAll").prop("disabled", true);
                $("#otherFormSave").prop("disabled", true);
                $("#doReturn").prop("disabled", true);
            }
            var tempObj = $("#bottomForm");
            if (tempFormSubmitObj) {
                tempObj = tempFormSubmitObj;
            }
            try {
                //OA-7417 新建or修改字段为数据关联类型，关联对象为空，另存为的时候没有提示
                //另存为时进行基本的查核,不进行数据查核
                if ("otherFormSave" == $(this).prop("id") && !validateFormData4OtherSave()) {
                    $("#doSaveAll").prop("disabled", false);
                    $("#otherFormSave").prop("disabled", false);
                    $("#doReturn").prop("disabled", false);
                    return;
                }
                //另存为也不进行数据查核
                else if ("otherFormSave" != $(this).prop("id") && "doReturn" != $(this).prop("id") && !validateFormData()) {
                    $("#doSaveAll").prop("disabled", false);
                    $("#otherFormSave").prop("disabled", false);
                    $("#doReturn").prop("disabled", false);
                    return;
                } else if ("doReturn" != $(this).prop("id") && !validateExchangeTask()) {
                    $("#doSaveAll").prop("disabled", false);
                    $("#otherFormSave").prop("disabled", false);
                    $("#doReturn").prop("disabled", false);
                    return;
                }
            } catch (e) {
            }
            var actionUrl = tempObj.prop("action") + "&step=" + $(this).prop("id");
            var currentLi = $("li.current", "#topUl");
            var sourceUrl = currentLi.attr("source");
            if ("upStep" == $(this).prop("id")) {
                sourceUrl = currentLi.prev().attr("source");
            } else if ("nextStep" == $(this).prop("id")) {
                sourceUrl = currentLi.next().attr("source");
            }
            actionUrl = actionUrl + "&source=" + sourceUrl;
            if ($(this).attr("module")) {
                actionUrl = actionUrl + "&module=" + $(this).attr("module");
            }
            //单独执行
            if ($(this).attr("clickEvent") != null) {
                if (tempObj.validate()) {
                    otherOpen('bottomForm', actionUrl);
                }
                $("#doSaveAll").prop("disabled", false);
                $("#otherFormSave").prop("disabled", false);
                $("#doReturn").prop("disabled", false);
                return;
            }
            if (("finish" == $(this).prop("id") || "doSaveAll" == $(this).prop("id")) && (formState4Save == "0" || formState4Save == "-1" || formState4Save == "-2")) {
                var processBar;
                $.confirm({
                    'msg': "${ctp:i18n('form.base.saveFormAlert')}",
                    ok_fn: function () {
                        getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                        actionUrl = actionUrl + "&state=2";
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {

                            }
                        });
                    },
                    cancel_fn: function () {
                        getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {

                            }
                        });
                    }
                });
                $("#doSaveAll").prop("disabled", false);
                $("#otherFormSave").prop("disabled", false);
                $("#doReturn").prop("disabled", false);
            } else if ("otherFormSave" == $(this).prop("id")) {
                $("#doSaveAll").prop("disabled", false);
                $("#otherFormSave").prop("disabled", false);
                $("#doReturn").prop("disabled", false);
                return;
            } else {
                if (canSaveData) {
                    if ("doReturn" == $(this).prop("id")) {//返回的时候需要提示
                        isReturn = true;
                        window.location.href = $("#bottomForm").prop("action") + "&step=doReturn";
                    } else {
                        getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
                        tempObj.jsonSubmit({
                            action: actionUrl, validate: false, beforeSubmit: function () {

                            }
                        });
                    }
                }
            }
        });
        <%if(!"".equals(com.seeyon.ctp.form.util.Enums.FormType.getEnumByKey(((com.seeyon.ctp.form.bean.FormBean)request.getAttribute("formBean")).getFormType()).getInitJS())){%>
        <jsp:include page='<%=com.seeyon.ctp.form.util.Enums.FormType.getEnumByKey(((com.seeyon.ctp.form.bean.FormBean)request.getAttribute("formBean")).getFormType()).getInitJS()%>'/>
        <%}%>
    });
    function otherOpen(form, actionUrl) {
        $("#otherFormSave").prop("disabled", true);
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
                    $("#otherFormSave").prop("disabled", false);
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
                    var tempObj = $("#bottomForm");
                    if (tempFormSubmitObj) {
                        tempObj = tempFormSubmitObj;
                    }
                    var formobj = tempObj.formobj();
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
                                        winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
                                    }, close_fn: function () {
                                        dialog.close();
                                        $("#otherFormSave").removeProp("disabled");
                                        winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
                                    }
                                });
                            } else {
                                if (retObj.showUnFlowFormList) {
                                    retObj.callback = function() {
                                        winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
                                    };
                                    retObj.ok_fn = function(){
                                        winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
                                    };
                                    showMsg4BizValidate(retObj);
                                } else {
                                    $.alert({
                                        msg:retObj.msg,
                                        ok_fn:function(){
                                            dialog.close();
                                            winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
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
                                    winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
                                }, close_fn: function () {
                                    dialog.close();
                                    winReflesh("${path}/form/formList.do?method=index&formType=${formBean.formType}&property=myForm");
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
                    //$("#otherFormSave").removeProp("disabled");
                }
            }]
        });
    }
</script>
<form action="${path}/form/fieldDesign.do?method=formDesignSave" id="bottomForm"></form>
<div class="hr_heng"></div>
<table height="100%" align="right" id="buttom_table">
    <tr>
        <!-- 上一步 -->
        <td class="hidden" height="20">
            <input type="button" class="common_button common_button_gray margin_r_5" id="upStep"
                   value="${ctp:i18n('form.pagesign.ascendpace.label') }">
        </td>
        <!-- 下一步 -->
        <td class="hidden" height="20">
            <input type="button" class="common_button common_button_gray margin_r_5" id="nextStep"
                   value="${ctp:i18n('form.pagesign.nextpace.label') }">
        </td>
        <!-- 完成 -->
        <td class="hidden" height="20">
            <input type="button" class="common_button common_button_gray margin_r_5" id="finish"
                   value="${ctp:i18n('form.pagesign.finish.label') }">
        </td>
        <!-- 另存为 -->
        <td class="hidden" height="20">
            <input type="button" clickEvent="open" class="common_button common_button_gray margin_r_5"
                   id="otherFormSave" value="${ctp:i18n('form.baseinfo.othersave') }">
        </td>
        <!-- 全部保存 -->
        <td class="hidden" height="20">
            <input type="button" class="common_button common_button_gray margin_r_5" id="doSaveAll"
                   value="${ctp:i18n('form.pagesign.savethispage') }">
        </td>
        <!-- 返回 -->
        <td class="hidden" height="20">
            <input type="button" class="common_button common_button_gray margin_r_5" id="doReturn"
                   value="${ctp:i18n('form.pagesign.quit.label') }">
        </td>
        <!-- 返回 -->
        <td class="hidden" height="20"><span
                id="moveControl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        </td>
    </tr>
</table>