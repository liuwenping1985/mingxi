function beforeCloseCheck(){
	  if(!isSubmitOperation){
	      if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
	            return " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
	        }else{
	            return "";  //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
	        }
	  }
}
//取消离开时提醒
function canclLeavePromp(){
    window.onbeforeunload = null;
}

function setSelectVal(value,obj){
    if(!value){
        return;
    }
    for(var i =0; i<obj.options.length; i ++){
        if(obj.options[i].value == value){
            obj.selectedIndex = i;
            break;
        }
    }
}

//修改流程图后取消回调方法
function recoverWorkFlowHistoryData(){
  if(isCopyFlow){
    $("#process_info").val($("#process_info_bak").val());
    $("#process_xml").val($("#process_xml_bak").val());
    $("#process_info_bak").val("");
    $("#process_xml_bak").val("");
    isCopyFlow = false;
  }
}
//是否是复制流程操作
var isCopyFlow = false;
// 修改流程图后确认回调方法
function finishWorkFlowModify(){
  isCopyFlow = false;
}
function addScrollForDocument(){
    var lt = $("#layout").layout();
    try{
        if($.browser.msie && ($.browser.version=="6.0"||$.browser.version=="7.0")){
            lt.setNorth(parseInt($("#toolbar").css("height")) + parseInt($(".form_area").css("height")) + parseInt($("#attachmentArea").css("height"))+ 15);
        }else{
            lt.setNorth(parseInt($("#toolbar").css("height")) + parseInt($(".form_area").css("height")) + parseInt($("#attachmentArea").css("height"))+ 10);
        }
    }catch(e){
        lt.setNorth(parseInt($("#toolbar").css("height")) + parseInt($(".form_area").css("height"))+10);
    }
    $("#myAttonly").css("margin-left","20px");
}



$(function() {
	if(formDisableName != "") {
        $.alert('该模板使用的报送单['+formDisableName+']已被停用，已替换为默认报送单。');
    }
    //协同标题,流程添加默认值显示
    new inputChange($("#subject"), $.i18n('common.default.subject.value'));
    if($("#process_info").val() == ""){
        $("#process_info").val($.i18n('collaboration.default.workflowInfo.value'));
    }
    $("#toolbar").toolbar({
    	isPager:false,
        borderTop:false,
        borderLeft:false,
        borderRight:false,
      toolbar : [ {
        id : "save",
        name : $.i18n('common.toolbar.save.label'),
        className : "ico16 save_up_16",
        click : function() {
            saveInfoTemplate();
        }
      },{
          id : "auth",
          name : $.i18n('common.toolbar.auth.label'),
          className : "ico16 authorize_16",
          click: function(){
              setAuth();
          }
        },{
        id : "workflow",
        name : $.i18n('common.design.workflow.label'),
        className : "ico16 process_16",
        click:function(){
            $("#process_info").click();
        }
      },{
        id : "insert",
        name : $.i18n('common.toolbar.insert.label'),
        className : "ico16",
        subMenu : [ {
            name : $.i18n('common.toolbar.insert.localfile.label'),
            click : function(){
                insertAttachment();
           }
        } ]
      },{
        id : "conotentType",
        name : $.i18n('template.systemNewTem.bodyType'),  //正文类型
        className : "ico16 text_type_16",
        subMenu: $.content.getMainbodyChooser("toolbar", $("#contentType").val())
      },{
        id : "contentText",
        name : $.i18n('infosend.label.text'),//正文
        className : "ico16 text_type_16",
        click:function(){
    	  updateInfoContent();
        }
      }]
    });

	if($("#from").val()==""){

		
		/**没有安装Office，或浏览器不支持Office插件**/
	   	if(!hasOffice(contentType)){
	   		$.content.switchContentTypeNoComfirm("toolbar", 10);
			contentType = 10;
			bodyType = 'Html';
	   	}else{
	   		
	   		var localOfficeType = getDefaultContentType();//获取用户本地安装的Word类型
	   		var localBodyType = getBodyType(localOfficeType);
	   		var changeBodyTypeFlag = false;
	   		
	        if(document.getElementById("newBusiness").value =="1") {//新建
	        	changeBodyTypeFlag = true;//创建时后台默认为Office Word文档，需要更具用户本地情况进行加载
	   		}else {//修改和模版创建时判断是否和原来一致
	   			if(contentType != localBodyType){
	   			    //changeBodyTypeFlag = true;
	   			}
			}
	        
	        if(changeBodyTypeFlag){
	        	//按照用户本地Word安装情况进行正文类型切换(后台写死为Office Word)
	       		localOfficeType = parseInt(localOfficeType);
	       		$.content.switchContentTypeNoComfirm("toolbar", localOfficeType);
	       		contentType = localOfficeType;
	    		bodyType = localBodyType;
	        }
	   	}
		
   	   	 /** contentType为切换正文类型的返回值 *//*
   	   	 var contentType = getOfficeContentType(contentType);
   	   	 *//** 切换正文类型 word*//*
   	   	 if(contentType=="41"){
	   	   	$.content.switchContentTypeNoComfirm("toolbar", 41);
	  			contentType = 41;
	  			bodyType = "OfficeWord";
	  	 *//** 切换正文类型 wps*//*
 	   	 }else if(contentType=="43"){
	   	   	$.content.switchContentTypeNoComfirm("toolbar", 43);
	  			contentType = 43;
	  			bodyType = 'WpsWord';
	  	 *//** 切换正文类型 标准正文*//*
   	   	 }else{
   			$.content.switchContentTypeNoComfirm("toolbar", 10);
   				contentType = 10;
   				bodyType = 'Html';
   	   	 }*/
   	}

  });


$(function(){
    addScrollForDocument();
    if(document.getElementById("newBusiness").value =="1") {//新建
    	infoEditFormDisplay();
    }else{
        initTemplateData();
    	fillFormInfo();
    }
    $("#formId").change(function() {
		doChangeForm($(this));
	});
});

function fillFormInfo(){
	var gtManager = new govTemplateManager();
	 var obj = new Object();
	 obj.templateId = document.getElementById("id").value;
	 obj.formId = _summary_formId;
	 obj.appType = appType;
	 obj.type= 0;
	 gtManager.ajaxFillFormDate(obj,{
        success : function(map){
            var xml_text = map.xml;
            var xsl_text = map.xsl;
            $("#xml").val(xml_text);
            $("#xsl").val(xsl_text);
            infoEditFormDisplay();
            setObjEvent();
        },
        error : function(request, settings, e){
            $.alert(e);
        }
    });
}

function initTemplateData(){
	var deadLine = document.getElementById("deadline");
	var advanceRemind = document.getElementById("advanceRemind");
	setSelectVal(_summary_deadline,deadLine);
    setSelectVal(_summary_advanceRemind,advanceRemind);
}

function infoFormDisplay(){
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	//buttondnois();
	//document.getElementById("content").value = xsl.value;
	$("#document","#forformlist").val(xsl.value);
	if(xml.value!="" && xsl.value!="") {
		try{
			initSeeyonForm(xml.value, xsl.value);
			//setObjEvent();
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		//substituteLogo(logoURL);
		return false;
	} else {
		//autoWidthAndHeight(false);
	}
}

function validateSubjectNotEmpty(element){
	  var value = element.value;
	  var inputName = element.getAttribute("inputName");
	  if($.i18n('common.default.subject.value') == value || $.trim(value) ==""){//<点击此处填写标题>
	      $.messageBox({
	          'type' : 0,
	          'title':$.i18n('system.prompt.js'), //系统提示
	          'msg' : $.i18n('collaboration.common.titleNotNull'),//标题不能为空
	          'imgType':2,
	          ok_fn : function() {
	              element.focus();
	          }
	        });
	      return false;
	  }
	  return true;
	}

function saveInfoTemplate(){
	//TODO 提交前的验证
	var theForm = document.getElementById('sendForm');
	if(!validateSubjectNotEmpty(theForm.subject)){//标题校验
        return;
    }
	/** 验证报送单必填项 */
	if(validateGovForm(false)) {
		return false;
	}
	
	//验证报送单的标题是否含有特殊字符
	var $formSubject = $("input[id='my:subject']");
	if($formSubject.val() && !(/^[^\|\\"']*$/.test($formSubject.val()))){//这里正则表达式的验证请与新建信息时的标题保存一直
		var inputName = $formSubject.attr("inputName");
		//$.alert(inputName + "不能包含特殊字符（|\"'\），请重新输入！");
	   $.alert({
           msg: inputName + "不能包含特殊字符（|\"'\），请重新输入！",
           ok_fn: function (){
        	   try{
        		   $formSubject.focus();
        		   $formSubject.select();
        	   }catch(e){}
           },
           close_fn: function(){
        	   try{
        		   $formSubject.focus();
        		   $formSubject.select();
        	   }catch(e){}
           }
       });
	   
		return false;
	}
	
	var subject = theForm.elements['subject'].value;
	var id=$("#templateMainData #id").val();
	var callerResponder = new CallerResponder();
    var temManager = new templateManager();
 	var ids =[];
 	ids[0] = subject;
 	ids[1] = document.getElementById("appType").value;
 	ids[2] = document.getElementById("newBusiness").value;
 	ids[3] = id;
 	ids[4] = '1';
 	var returnVal = temManager.checkNameRepeat(ids);
 	if(returnVal != null) {
		var count = returnVal.length;
		for(var i = 0; i < count; i++){
			var tObj = returnVal[i];
			if(tObj.subject == subject){//需要验证大小写
				$.alert($.i18n('infosend.listInfo.alert.existsTemplet'));//模板名称已经存在
				return;
			}
		}
 	}
//	if(count >= 1){
//		$.alert($.i18n('infosend.listInfo.alert.existsTemplet'));//模板名称已经存在
//		return;
//	}
	//校验流程如果没有就弹出
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
		return;
	}
	//提交
	//var domains = [];
	//domains.push("templateMainData");
	//domains.push("workflow_definition");
	//domains.push("govFormData");
	//domains.push("_currentDiv");
	//domains.push(getMainBodyDataDiv());
	//$("#sendForm").jsonSubmit({
	//	domains : domains
	//});
	var moduleId = $("#templateMainData #id").val();
   	setTemplateParam(moduleId,$("#subject"));
   	canclLeavePromp();//取消提示
	$.content.getContentDomains(function(domains){
        if (domains) {
        	domains.push('templateMainData');
            domains.push('govFormData');
            $("#sendForm").attr("action", _path + "/govTemplate/govTemplate.do?method=saveInfoTemplate");
            $("#sendForm").jsonSubmit({
              errorIcon : false,
              errorAlert:true,
              domains : domains,
              debug : false
            });
          }
    });
}

//授权信息
function setAuth(){
    $.selectPeople({
           type:'selectPeople'
           ,panels:'Department,Team,Post,Level,Account'
           ,selectType:'Department,Member,Account,Team,Post,Level'
           ,minSize:0
           ,text:$.i18n('common.default.selectPeople.value')
           ,returnValueNeedType: true
           ,showFlowTypeRadio: false
           ,isNeedCheckLevelScope:false
           ,params:{
              value: templateAuthInfo
           }
           ,hiddenPostOfDepartment:true
           ,targetWindow:getCtpTop()
           ,callback : function(res){
               if(res && res.text){
                   $("#authInfo").val(res.value);
                   templateAuthInfo = res.value;
               } else {
               }
           }
       });

}

//归档信息
function pigeonholeEvent(obj){
    var theForm = document.getElementsByName("sendForm")[0];
    switch(obj.selectedIndex){
        case 0 :
            var oldArchiveId = theForm.archiveId.value;
            if(oldArchiveId != ""){
                theForm.archiveId.value = "";
            }
            break;
        case 1 :
            doPigeonhole_pre('new', _applicationCategoryEnum_collaboration_key, 'templete');
            break;
        default :
            theForm.archiveId.value = document.getElementById("prevArchiveId").value;
            return;
    }
}

/**
* 预归档
* 模板页面和新建页面都走这里
*/
var doPigeonhole_preCallbackParam = {};
function doPigeonhole_pre(flag, appName, from) {
    doPigeonhole_preCallbackParam.flag = flag;
    doPigeonhole_preCallbackParam.appName = appName;
    doPigeonhole_preCallbackParam.from = from;
    if (flag == "no") {
        //TODO 清空信息
    }
    else if (flag == "new") {
        var result;
        if(from == "templete"){
            result = pigeonhole(appName, null, false, false,'templeteManage', "doPigeonhole_preCallback");
        }else{
            result = pigeonhole(appName,null, "", "", "", "doPigeonhole_preCallback");
        }
    }
}

/**
 * 预归档回调函数
 */
function doPigeonhole_preCallback(result){
    var flag = doPigeonhole_preCallbackParam.flag;
    var appName = doPigeonhole_preCallbackParam.appName;
    var from = doPigeonhole_preCallbackParam.from;
    var theForm = document.getElementsByName("sendForm")[0];
    if(result == "cancel"){
        var oldPigeonholeId = theForm.archiveId.value;
        var selectObj = theForm.colPigeonhole;
        if(oldPigeonholeId != "" && selectObj.options.length >= 3){
            selectObj.options[2].selected = true;
        }
        else{
            var oldOption = document.getElementById("defaultOption");
            oldOption.selected = true;
        }
        return;
    }
    var pigeonholeData = result.split(",");
    pigeonholeId = pigeonholeData[0];
    pigeonholeName = pigeonholeData[1];
    if(pigeonholeId == "" || pigeonholeId == "failure"){
        theForm.archiveName.value = "";
        $.alert($.i18n("collaboration.alert.pigeonhole.failure"));
    }
    else{
        var oldPigeonholeId = theForm.archiveId.value;
        theForm.archiveId.value = pigeonholeId;
        if(document.getElementById("prevArchiveId")){
            document.getElementById("prevArchiveId").value = pigeonholeId;
        }
        var selectObj = document.getElementById("colPigeonhole");
        var option = document.createElement("OPTION");
        option.id = pigeonholeId;
        option.text = pigeonholeName;
        option.value = pigeonholeId;
        option.selected = true;
        if(oldPigeonholeId == "" && selectObj.options.length<=2){
            selectObj.options.add(option, selectObj.options.length);
        }
        else{
            selectObj.options[selectObj.options.length-1] = option;
        }
    }
}

function checkDeadLine(){
	var deadline = document.getElementById('deadline');
	var remind = document.getElementById('advanceRemind');
	if(parseInt(deadline.value) <= parseInt(remind.value) && parseInt(remind.value) != 0){
        //未设置流程期限或者流程期限小于，等于提前提醒时间!
		$.alert($.i18n('template.templatePub.noSetFlow'));
		remind.selectedIndex = 0;
	}
}

