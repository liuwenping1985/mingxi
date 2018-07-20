<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/triggerDesign.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/linkageDesign.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var currentTr;
    $(document).ready(function() {
        new MxtLayout({
            'id': 'layout',
            'northArea': {
                'id': 'north',
                'height': 40,
                'sprit': false,
                'border': false
            },
            'southArea': {
                'id': 'south',
                'height': 40,
                'sprit': true,
                'border': false,
                'maxHeight': 40,
                'minHeight': 40
            },
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });

        $("#fillFormBase").disable();
        $("#actionSet").disable();

        if ("${formBean.newForm}" == "true") {
            new ShowTop({
                'current': 'linkage',
                'canClick': 'false',
                'module': 'linkage'
            });
            new ShowBottom({
                'show': ['upStep', 'finish'],
                'source': {
                    'upStep': '../form/triggerDesign.do?method=index'
                }
            });
        } else {
            new ShowTop({
                'current': 'linkage',
                'canClick': 'true',
                'module': 'linkage'
            });
            new ShowBottom({
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
            var triggerType= $("#triggerType").attr("value");
            if(triggerName && triggerName!=""){
              var triggerm = new formTriggerDesignManager();
              var result= triggerm.validateTriggerName(triggerId,triggerName,triggerType);
              if(!result){
                $.alert("${ctp:i18n('form.input.triggernameisexist.label') }");
                return;
              }
            }
            saveTriggerFun($(this));
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
</script>