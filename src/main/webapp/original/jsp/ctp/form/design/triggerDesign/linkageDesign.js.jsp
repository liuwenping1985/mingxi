<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/triggerCommon.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/linkageDesign.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var currentTr;
    $(document).ready(function() {
        new MxtLayout({
            'id': 'layout',
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });

        $("#fillFormBase").disable();
        $("#actionSet").disable();

        if ("${formBean.newForm}" == "true") {
            parent.ShowBottom({
                'show': ['upStep','nextStep', 'finish'],
                'source': {
                    'upStep': '../form/triggerDesign.do?method=index',
                    'nextStep' : '../form/triggerDesign.do?method=automatic'
                }
            });
        } else {
            parent.ShowBottom({
                'show': ['doSaveAll', 'doReturn']
            });
        }

        $("#newTrigger").click(function() {
            newTriggerFun();
        });
        $("#updateTrigger").click(function() {
            updateTriggerFun();
        });
        $("#delTrigger").click(function() {
            delTriggerFun();
        });
        $("#saveTrigger").click(function() {
            var triggerId= $("#triggerId").attr("value");
            var triggerName= $("#triggerName").attr("value");
            if(isMark(triggerName)){
                $.alert("名称含有非法字符串" + " \:,<>\/|\'\"?#$%&\^\*");
                return;
            }
            var triggerType= $("#triggerType").attr("value");
            var triggerm = new formTriggerDesignManager();
            var result = "";
            if(triggerName && triggerName!=""){
                result= triggerm.validateTriggerName(triggerId,triggerName,triggerType);
                if(!result){
                    $.alert("${ctp:i18n('form.input.triggernameisexist.label') }");
                    return;
                }
            }
            //校验是否存在死循环的可能
            var targetIds = "";
            $("tr[id='cloneRow']", "#actionTable").each(function() {
                var fId = $("#formId", $(this)).val();
                if(fId){
                    targetIds += fId + ",";
                }
            });
            var state = $("input:checked","#triggerNameSet").val();
            if(state == "0"){
                //停用不用校验死循环，直接保存
                saveTriggerFun($(this));
            }else {
                result = triggerm.checkTriggerDeadCycle(targetIds);
                if (result) {
                    var msg = $.i18n("form.trigger.settings.dead.cycle.label", $.i18n("form.trigger.triggerSet.linkage.set.label"), result);
                    $.confirm({
                        'msg': msg,
                        ok_fn: function () {
                            saveTriggerFun($(this));
                        }
                    });
                } else {
                    saveTriggerFun($(this));
                }
            }
        });
        $("#reset").click(function() {
            resetFun($(this));
        })
        $("input:radio", "#triggerConditionSet").click(function() {
            triggerConditionSetFun($(this));
        });
        $("#content", "#cloneRow").click(function() {
            chooseTriggerTemplate(_ctxPath + "/form/triggerDesign.do?method=triggerTemplateList&formcategory=2&templateId=" + $("#templateId", currentTr).val(), "${ctp:i18n('form.trigger.triggerSet.linkage.unflow.template.js')}", false);
        });
        $("#copySet", "#cloneRow").click(function() {
            copySetFun($(this));
        });
        $(":checkbox", "#triggerBody").click(function() {
            $("#newTrigger").click();
            disableTrigger();
        });
        //放到最后
        $("body").data("cloneActionRow", $("#cloneRow").clone(true));
    });

    var actionCountManager = actionCount();
    function newCloneTr() {
        var newTr = $("body").data("cloneActionRow").clone(true);
        newTr.comp();
        var tempCount = actionCountManager();
        if ($.v3x.isMSIE7) {
            var html = ""; 
            <c:forEach items="${actionList }" var="action" varStatus="status">
                html += '<label for="${action.id }" class="margin_l_10">';
                html += '    <input type="radio" id="${action.id }" name="actionType-"' + tempCount + ' value="${action.id }" ${status.index eq 0 ? "checked=\"checked\"" : "" } /><span class="margin_l_5">${action.name }</span>';
                html += '</label>';
            </c:forEach>
            $("#actionTypeTd", newTr).html(html);
        } else {
            $("input:radio", newTr).each(function() {
                $(this).prop("name", "actionType-" + tempCount);
            });
        }
        $("input:radio", newTr).bind("click", function() {
            actionTypeSetFun($(this));
        });
        return newTr;
    }

    function isMark(str) {
        var myReg = /[\\:,()<>\/|\'\"?#$%&\^\*]/;
        if (myReg.test(str)) {
            return true;
        }
        return false;
    }
</script>