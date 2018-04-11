<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/automaticDesign.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/design/top.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	//判断是否表单高级插件
	var _isAdvanced = true;
	var currentTr;
	var _colModuleType = "";

    $(document).ready(function(){
        new MxtLayout({
            'id': 'layout',
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        $("#fillFormBase").disable();
        $("#actionSet").disable();
        if(!${formBean.newForm }){
        	parent.ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
            parent.ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/bindDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=linkage'}});
        }
        if(!${formBean.newForm }){
            $("li[cando='1']").click(function(){
                $("#saveAll").jsonSubmit({action:$("#saveAll").prop("action")+"&step="+$(this).prop("id")});
            });
        }
        $("#newTrigger").click(function(){
        	newTriggerFun("${timeQuartz}");
        });

        $("#reset").click(function(){
        	resetFun($(this));
        });
        $("#actionType").change(function(){
        	actionReset($(this).val());
        });

        $("#saveTrigger").click(function(){
            var triggerId= $("#triggerId").attr("value");
            var triggerName= $("#triggerName").attr("value");
            if(isMark(triggerName)){
                $.alert("名称含有非法字符串" + " \:,<>\/|\'\"?#$%&\^\*");
                return;
            }
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
        $("#updateTrigger").click(function(){
        	updateTriggerFun();
        });
        $("#delTrigger").click(function(){
        	delTriggerFun();
        });
        $("#timeSet").click(function(){
        	timeSetFun($(this));
        });
        $("#ruleSet","#cloneRow").click(function(){
            ruleSetFun($(this));
        });
        $("#targetbillSet","#cloneRow").click(function(){
            targetbillSetFun($(this));
        });
        $("#repeatRowLoactionSet","#cloneRow").click(function(){
            repeatRowLoactionSetFun($(this));
        });
        $(":radio","#triggerConditionSet").click(function(){
        	resetTimeQuartz("");
        });
        $(":checkbox","#triggerBody").click(function(){
        	$("#newTrigger").click();
        	disableTrigger();
        });

        //放到最后
        $("body").data("cloneActionRow",$("#cloneRow").clone(true));
    });

    function newCloneTr(){
    	var newTr = $("body").data("cloneActionRow").clone(true);
    	newTr.comp();
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
