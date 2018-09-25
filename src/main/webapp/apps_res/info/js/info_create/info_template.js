
function handleTemplate() {
	callTemplate('32',"",getTemplateId);
}

function getTemplateId(templateId){
	if(templateId && templateId != ''){
		if(!window.isSubmitOperation){
			window.isSubmitOperation = true;//解除页面离开提示
		}
		if($("#action").val() == "forward"){
			$.confirm({
	            'msg': $.i18n('infosend.magazine.manager.transferCovering'), // 正文内容将被覆盖，您是否继续？
	            ok_fn: function() {
	            	window.location = _ctxPath + "/info/infocreate.do?method=createInfo&templateId="+templateId+"&action=template";
	            }
	        });
		}else{
			window.location = _ctxPath + "/info/infocreate.do?method=createInfo&templateId="+templateId+"&action=template";
		}
	}
}

function saveAsTemplete() {
	/**验证模板是否可用**/
	var tIdCheck = $("#colMainData #tId").val();
	if(tIdCheck){
		if(!(checkTemplateCanUse(tIdCheck))){
              $.alert($.i18n('template.cannot.use'));
              return;
        }
	}
	$("#saveAsFlag").val('saveAsPersonal');
	/**验证标题**/
	var theForm = document.getElementsByName("sendForm")[0];
	var subject = document.getElementById("my:subject").value;
	/**流程的一些判断**/
	var process_lc = document.getElementById("process_info");
	var defaultPro = $("#process_info").attr("defaultValue");
	if (defaultPro==$.trim(process_lc.value)) {
	    $("#process_info").attr("value","");
    }
	if(process_lc && process_lc.value==""){
	    $.messageBox({
	        'type' : 0,
	        'title':$.i18n('system.prompt.js'),
	        'msg' : $.i18n('collaboration.forward.workFlowNotNull'), //流程不能为空
	        'imgType':2,
	        ok_fn : function() {
	    		$("#process_info").click();
	        }
	      });
		return true;
	}
	var _cbody = getMainBodyDataDiv$();
	var _ctype = $("#contentType",_cbody).val();

	var dialog = $.dialog({
		 targetWindow:getCtpTop(),
	     id: 'saveAsTemplate',
	     url: _ctxPath + "/govTemplate/govTemplate.do?method=saveAsTemplate&subject="+escapeStringToHTML(encodeURIComponent(subject)),
	     width: 350,
	     height: 150,
	     title: $.i18n('collaboration.newcoll.saveAsTemplate'),  //另存为个人模板
	     buttons: [{
	         text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
	         btnType : 1,//按钮样式
	         handler: function () {
                var rv = dialog.getReturnValue();
                //activeOcx(); //TODO office等加office控件
        		if (!rv) {
        	        return;
        	    }
        		var over = rv[0];
        	    var overId = rv[1];
        	    var type = rv[2];
        	    var subject = rv[3];
        	    if(over == 5){
                    var confirm = "";
                    confirm = $.confirm({
                        'msg': $.i18n('collaboration.saveAsTemplate.isHaveTemplate',escapeStringToHTML(subject)),  //模板 '+subject+'已经存在，是否将原模板覆盖?
                        ok_fn: function () {
                            confirm.close();
                            doSaveTemplate(1,subject,overId,type,dialog);
                        },
                        cancel_fn:function(){
                          confirm.close();
                        }
                     });
                  }else{
                     doSaveTemplate(over,subject,overId,type,dialog);
                  }
            }
	     }, {
	         text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
	         handler: function () {
	             dialog.close();
	         }
	     }]
	 });
}

//超期提醒与提前提醒时间设置的比较
function compareTime(){
	var newCollForm = document.getElementsByName("sendForm")[0];
	//var advanceRemind = newCollForm.advanceRemind.options[newCollForm.advanceRemind.selectedIndex];
	//var deadline = newCollForm.deadline.options[newCollForm.deadline.selectedIndex];
	var advanceRemindTime = document.getElementById("advanceRemind").value;
	var deadLineTime = document.getElementById("deadline").value;
	if(deadLineTime==0){
		var allow_auto_stop_flow=document.getElementById('canAutostopflow');
		if(allow_auto_stop_flow){
			allow_auto_stop_flow.disabled=true;
		}
	}
	var advanceRemindNumber = new Number(advanceRemindTime);
	var deadLineNumber = new Number(deadLineTime);
	if(deadLineNumber <= advanceRemindNumber && !(advanceRemindNumber ==0 && deadLineNumber ==0)){
	    //未设置流程期限或流程期限小于,等于提前提醒时间
        $.alert($.i18n('collaboration.newColl.alert.lcqx'));
		newCollForm.advanceRemind.selectedIndex = 0;
		return false;
	}
	else{
		return true;
	}
}

function doSaveTemplate(over,subject,overId,type,dialog){
    //校验超期提醒，提前提醒时间
    if(!compareTime()){
        return;
    }
    var theForm = document.getElementsByName("sendForm")[0];
    theForm.saveAsTempleteSubject.value = subject;
    var moduleId = getUUID();
    if( null != overId && !("" == overId)){
        moduleId = overId;//覆盖
    }
    var contentDiv = getMainBodyDataDiv$();
    //协同V5.0 OA-34229
	//新建事项调用一个系统流程模板后，存为模板后，点击保存待发；
	//然后进入待发事项编辑该协同存为模板，再次保存待发；依次重复上诉操作，就会报JS错误
    //保存上次的ID 以免产生新的正文  出现多正文的情况
    var oldZWId = $("#id",contentDiv).val();
    $("#id",contentDiv).val(-1);
    var oldZWModuleId = $("#moduleId",contentDiv).val();
    $("#moduleId",contentDiv).val(moduleId);
    var oldZWModuleTemplateID =  $("#moduleTemplateId",contentDiv).val();
    $("#moduleTemplateId",contentDiv).val(-1);//存为个人模板 正文的moduleTemplateId要存成-1

	/**后台存ctp_content_all表的时候会用到这个参数**/
    document.getElementById('useForSaveTemplate').value='yes';

    var template_dom = document.createElement("input");
    template_dom.id="personTid";
    template_dom.name="personTid";
    template_dom.type="hidden";
    template_dom.value = moduleId;
    if($("#colMainData #personTid").size() > 0){//多次存为个人模板的时候，要先判断是否已经存在该数据域 不然会按分组提交
        $("#colMainData #personTid").val(moduleId);
    }else{
        $("#colMainData").append(template_dom);
    }

    var overId_dom= document.createElement("input");
    overId_dom.id="overId";
    overId_dom.name="overId";
    overId_dom.type="hidden";
    overId_dom.value=overId;
    if($("#colMainData #overId").size() > 0){
        $("#colMainData #overId").val(overId);
    }else{
        $("#colMainData").append(overId_dom);
    }

    var pobj = $("#workflow_definition #processId")[0];
    var alreayPid =pobj.value;//现在遵循的原理 即使存个人模板全生成新的流程 （insert wf_process_templete）
    pobj.value='-1';
    theForm.method = "POST";
setSummaryParam2();
    /**提交数据域**/
    $.content.getContentDomains(function(domains){
        if (domains) {

			$("#bodyType").val($("#contentType").val());
        	$("#assDocDomain").html("");
            $("#attFileDomain").html("");
            domains.push('assDocDomain');
            domains.push('attFileDomain');
            domains.push('colMainData');
            domains.push('govFormData');
            domains.push('comment_deal');
           saveAttachmentPart("assDocDomain");
           saveAttachmentPart("attFileDomain");

            $("#sendForm").jsonSubmit({
              action: _ctxPath + "/govTemplate/govTemplate.do?method=saveTemplate",
              domains : domains,
              validate:false,
              callback:function(){//加入回调函数，可以让页面不跳转，实现异步
                  $.infor($.i18n('collaboration.newColl.susscessSaveTemplate'));  //成功保存个人模板
              }
            });
          }
    	},'saveAs',null,mainbody_callBack_failed);
    document.getElementById('useForSaveTemplate').value='no';
    pobj.value = alreayPid;
  //如果是创建，那么给出新的ID和moduleID 否则沿用原来的 防止调用模板后 再次保存待发，保存为新的数据
    var currentAction = document.getElementById('currentAction').value; 
    if('create' == currentAction){
    	 //如果是新建 非待发修改 那么新给一个ID和moduleid
    	 var nid = getUUID();
    	 $("#id").val(nid);
    	 $("#moduleId").val(nid);
    	 $("#id",contentDiv).val(nid);
         $("#moduleId",contentDiv).val(nid);
    }else{
        $("#id",contentDiv).val(document.getElementById('infoSummaryId').value);//回填上次的正文ID 和 业务ID
        $("#moduleId",contentDiv).val(document.getElementById('infoSummaryId').value);
        $("#id").val(document.getElementById('infoSummaryId').value);//回填上次的正文ID 和 业务ID
        $("#moduleId").val(document.getElementById('infoSummaryId').value);
        
    }
    $("#moduleTemplateId",contentDiv).val(oldZWModuleTemplateID);//存为个人模板 正文的moduleTemplateId要存成-1
    dialog.close();
}
