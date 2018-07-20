<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/triggerDesign/triggerDesign.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	//判断是否表单高级插件
	var _isAdvanced = ${isAdvanced};
	var currentTr;
	var _colModuleType = ${colModuleType}
	var _sendSMS = ${sendSMS };
	
    $(document).ready(function(){
        new MxtLayout({
            'id': 'layout',
            'northArea': {
                'id': 'north',
                'height':40,
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
        if(!${formBean.newForm }){
        	new ShowTop({'current':'trigger','canClick':'true','module':'trigger'});
        	new ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
        	new ShowTop({'current':'trigger','canClick':'false','module':'trigger'});
        	new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/bindDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=linkage'}});
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

        $("input:radio","#cloneRow").click(function(){
          	radiofunction(this);
        });
        $("input:radio","#triggerConditionSet").click(function(){
        	triggerConditionSetFun($(this));
        });

        $("#saveTrigger").click(function(){ 
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

        $("#msgContent","#cloneRow").click(function(){
          	setTriggerMsgContent();
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
        
        $("#taskName","#cloneRow").click(function(){
        	taskNameFun();
        });
        $("#messageMem_txt","#cloneRow").click(function(){
        	messageMemFun();
        });
        $("#content","#cloneRow").click(function(){
        	chooseTriggerTemplate(_ctxPath + "/form/triggerDesign.do?method=triggerTemplate&templateId="+$("#templateId",currentTr).val()+"&moduleType="+$("#moduleType",currentTr).val(),
        			$.i18n('formsection.config.choose.template.title'), true);
        });
        $("#copySet","#cloneRow").click(function(){
        	copySetFun($(this));
        });
        $(":radio","#triggerConditionSet").click(function(){
        	resetTimeQuartz("");
        });
        $(":checkbox","#triggerBody").click(function(){
        	$("#newTrigger").click();
        	disableTrigger();
        });

        checkHasFormAdvanced();
        
        //放到最后
        $("body").data("cloneActionRow",$("#cloneRow").clone(true));
        
    });
    
	var actionCountManager = actionCount();
    function newCloneTr(){
    	var newTr = $("body").data("cloneActionRow").clone(true);
    	newTr.comp();
    	var tempCount = actionCountManager();
    	if($.v3x.isMSIE7) {
    	  var name = "memType-"+tempCount;
    	  var html = "<div class=\"left\" style=\"margin-top: 5px;margin-bottom: 5px;width: 170px;\"><input type=\"hidden\" id=\"entityMemType\" value=\"appoint\" forChecked=\"true\"/><label for='"+name+"-1' style=\"width: 134px;\">"
                          + "<input <c:if test="${formBean.formType != 1 }">class=\"hidden\"</c:if> type=\"radio\" checked=\"checked\" id='" + name + "-1' name='" + name +"' value=\"appoint\" checkId=\"entityMemType\"/>"
                          + "<input id=\"flowMem_txt\" readonly=\"readonly\" name=\"flowMem_txt\" type=\"text\" style=\"cursor: hand;width: ${formBean.formType eq 1 ? '140' : '160'}px;\" value=\"${ctp:i18n('form.trigger.triggerSet.clickToPerson.label')}\" class=\"validate\" validate=\"func:checkFlowMem,errorMsg:'${ctp:i18n("form.trigger.triggerSet.template.sender") }'\"/>"
                          + "<input id=\"flowMem\" name=\"flowMem\" type=\"hidden\" /><span style=\"width: 5px;display: inline-block;\"></span></label></div>";
         <c:if test="${formBean.formType == 1 }">
		var flowhtml = "<div class=\"left\" style=\"margin-top: 5px;margin-bottom: 5px;width: 110px;\"><label for='" + name + "-2'><input type=\"radio\" id='"+name+"-2' name='"+name+"' value=\"currentFlowStartMember\" checkId=\"entityMemType\"/><span id=\"currentPerson\">${ctp:i18n('form.trigger.triggerSet.currentSponsors.label')}</span></label><span style=\"width: 5px;display: inline-block;\"></span></div>"
			    + "<div class=\"left\" style=\"margin-top: 5px;margin-bottom: 5px;width: 100px;\"><label id=\"memType3Label\" for='"+name+"-3'><input type=\"radio\" id='"+name+"-3' name='"+name+"' value=\"currentFlowNode\" checkId=\"entityMemType\"/><span id=\"currentNode\">${ctp:i18n('form.trigger.triggerSet.unflow.triggernode')}</span></label></div>";
		html += flowhtml;
         </c:if>
         $("#showmemtype",newTr).html(html);
         
         name = "sendsmsradio-"+tempCount;
         var smshtml = "<div class=\"common_radio_box clearfix\"><input type=\"hidden\"  id = \"sendsms\" name = \"sendsms\" value = \"false\"><label class=\"margin_r_10 hand\" for='"+name+"1'><input name='"+name+"' class=\"radio_com\" id='"+name+"1' type=\"radio\" value=\"true\">${ctp:i18n('common.yes') }</label>"
                            + "<label class=\"margin_r_10 hand\" for='"+name+"4'><input name='"+name+"' class=\"radio_com\" id='"+name+"4' type=\"radio\" value=\"false\">${ctp:i18n('common.no') }</label></div>";
         $("#smshtml",newTr).html(smshtml);
         $("input:radio",newTr).bind("click",function(){
           radiofunction(this);
         });
    	} else {
	    	$("input:radio",newTr).each(function(index){
	    	  if($(this).attr("id").indexOf("sendsms") == -1){
				$(this).prop("name","memType-"+tempCount);
				$(this).prop("id","memType-"+tempCount+"-"+index);
				$(this).parent().attr("for","memType-"+tempCount+"-"+index);
	    	  }else {
	    	    $(this).prop("name","sendsmsradio-"+tempCount);
	    	    $(this).prop("id","sendsmsradio-"+tempCount+"-"+index);
	    	    $(this).parent().attr("for","sendsmsradio-"+tempCount+"-"+index);
	    	  }
	        });
    	}
        return newTr;
    }

</script>
