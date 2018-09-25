
$(function() {
  function savePlan() {
         var frmobj = $("#planform").formobj();
            //日计划，将结束日期附上值(因为日计划在选择的时候结束日期是置灰的，没值)
            if($("#type").val()==='1'){
              frmobj.endTime = frmobj.startTime;
            }
            var pm = new planManager();
            if(frmobj.publishStatus==='1'){
              //如果由原来的草稿状态变为发送,需要一个标识，因为发送的消息不一样
              relationDatas.draftToFormal = 1;
            }        
            frmobj.publishStatus = '2';//已发
            var formId = $("input[id='contentTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
            var planid = $("#planId").val();
            if(formId!="0"){//表单计划
                var formDataId =$("input[id='contentDataId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
                var fieldIdStr = getFormUsersField();
                var sendUser = getSendUser();
                var noRangeUserIds =""+ pm.getNoRangeUserId(fieldIdStr,formDataId,sendUser);//不在发送范围内的人员id
                var mentionedInfo = getFormRecordAndUser(noRangeUserIds);
                relationDatas.formDataId = formDataId;
                relationDatas.fieldIdStr = fieldIdStr;
                relationDatas.formId = formId;
                relationDatas.planId= planid;
                relationDatas.mentionedInfo = mentionedInfo;
            }
            
            if($("#isModifyInput").val()==="1"){
               var isUpdateNo = pm.updatePlanForBO(frmobj,relationDatas);
               if(isUpdateNo == -1) {
                 $.messageBox({
                   'title':$.i18n('collaboration.system.prompt.js'),
                   'type': 0,
                   'msg': $.i18n('plan.noexist'),
                   'imgType':0,
                   ok_fn:function(){
                     window.close();
                     removeCtpWindow('123123123123123123',2);
                     removeCtpWindow('123123123123123123456',2);
                     removeCtpWindow(null,2);
                   }
                 });
                 return;
               }
               if($("#contentType").val()==='20'){
                      //如果是表单那么先更新状态
                      var obj= new Object();
                       var currentMasterDataId = $("#contentDataId",getIFrameDOM('mainbodyFrame')).val();
                       var currentFormId = $("#contentTemplateId",getIFrameDOM('mainbodyFrame')).val();
                       obj.formId=currentFormId;
                       obj.dataId=currentMasterDataId;
                       obj.state= 1;
                       pm.updateFormState(obj);
                    }
               $("#planform").jsonSubmit({
                 domains : [ "plan_table" ],
                 debug : false,
                 callback : function(res) {
                    if($("#contentType").val()==='20'){//修改，并且正文是表单时才需要取该值
                        var planid =  $("#planId").val();
                        pm.checkRefRelation(planid);
                    }
                    closeProgressBar();
                    refreshPage();
               	 	window.close();
               	 	removeCtpWin();
                 }
              });
            }else{
              pm.savePlan(frmobj,relationDatas);
              $("#planform").jsonSubmit({
                domains : [ "plan_table" ],
                debug : false,
                callback : function(res) {
                    if($("#contentType").val()==='20'){//修改，并且正文是表单时才需要取该值
                        var planid =  $("#planId").val();
                        pm.checkRefRelation(planid);
                    }
                    closeProgressBar();
                    refreshPage();
              		window.close();
              		removeCtpWin();
                }
              });
            }
}
  
function removeCtpWin() {
	removeCtpWindow('123123123123123123',2);
	removeCtpWindow('123123123123123123456',2);
	removeCtpWindow(null,2);
}
function refreshPage() {
	try {
      if (window.opener.location.href.indexOf("getPlanList")!=-1) {//从我的计划中打开，发送成功后刷新列表
        if(window.opener.refreshPlanListAndContentFrame) {
          window.opener.refreshPlanListAndContentFrame();
        }
      } else {
    	  var _win = getCtpTop().opener.getCtpTop().$("#main")[0].contentWindow;
    	  if (_win != undefined) {
              //判断当前是否是首页栏目
    		  if (_win.sectionHandler != undefined) {
            	  //刷新计划栏目
                  _win.sectionHandler.reload("planMyPlan",true);//刷新 我的计划 栏目
                  _win.sectionHandler.reload("planDepartmentPlan",true);//刷新 部门计划 栏目
              } else {
              	  try{
              	  	getCtpTop().opener.getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectPlanAndMtAndEvent",true);//刷新 项目计划/会议/事件  栏目
              	  }catch(e){}
            	  //刷新列表
                  var url = _win.location.href;
                  if (url.indexOf("planListHome") != -1) {
                	  var iframeSrc = $("#tab_iframe",_win.document).attr("src");
                	  if(iframeSrc.indexOf("getPlanList") != -1) {
                		  _win.location =  _win.location;
                	  }
                  }
                  if (url.indexOf("arrangeTime") != -1) {
                      _win.location =  _win.location;
                  }
              }
          }
      }
    } catch (e){
      window.location =  $("#pathInput").val() +"/plan/plan.do?method=planListHome&type="+$("#type").val();
    }
}
function disabledSendButton(){
    $("#send").addClass("common_button_disable");
	  $("#send").unbind("click");
}

function unDisabledSendButton(){	
      $("#send").removeClass("common_button_disable");
	    $("#send").bind("click",saveAllInfo);
}
  //发送计划
  function saveAllInfo(){
    disabledSendButton();
    if(isFormSubmit) {
        isFormSubmit = false;
    }  
    if(needChangeOfficeID){
        var officeExcelId =  getUUID();
        //alert(officeExcelId);
        //如何操作不是"10"类型的正文重新生成正文41-44
        document.frames['mainbodyFrame'].fileId = officeExcelId;
        var contextObj = getIFrameDOM('mainbodyFrame');
        $("input[id='contentDataId'][type='hidden']",contextObj).val(officeExcelId);
    }
    var title = $("#title").val(); 
    var defaultTitle = $.i18n('collaboration.newcoll.clickfortitle');
    if($.trim(title) == "" || $.trim(title).indexOf(defaultTitle) >= 0){ 
      $.alert($.i18n('calendar.event.subject.can.not.null'));
      $("#title").val("");
      $("#send").removeClass("common_button_disable");
	    $("#send").bind("click",saveAllInfo);
      return false; 
    }
    var planId = $("#planId").val();
    var pm = new planManager();
    var isTemplate = pm.checkTemplate(templateIdTemp);
    if(typeof(isTemplate) != "undefined" && isTemplate != 'yes'){
        $.alert(isTemplate);
        unDisabledSendButton();
    }else{
        if($("#isModifyInput").val()==="1"&&oldContentType==="20"&&ischangeTemplate==true){
            pm.delFormData(oldPlanId);
        }
        if($("#planform").validate()&&validReleUsers()&&validIsRepeatPlan()){
            if($("#isModifyInput").val()==="1"){//修改时才需要取该值
            if(typeof(testcontentid) == "undefined")
                testcontentid = $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
            }
            if(testcontentid){//修改时才会有值
                var templateId = $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
                $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(testcontentid);
                if($("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val()=="-1"){ //如果是修改成其他表单模板时，为该hidden域赋值
                    $("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(templateId);
                }
            }else{
                //content组件不完善,新建的时候moduleTemplateId统一为-1L
                $("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(-1);
            }
           
          if(window.frames["mainbodyFrame"].contentWindow!=undefined){
            //firefox下的调用方式
            window.frames["mainbodyFrame"].contentWindow.preSubmitData(function(){submitPlanData();},function(){loseSaveContent();},null);
          }else{
            window.frames["mainbodyFrame"].window.preSubmitData(function(){submitPlanData();},function(){loseSaveContent();},null);
          }
        }else{
          unDisabledSendButton();
        }
      
    }
  }
  function getSendUser(){
  	 var sendUser="";
         sendUserStr=$("#planToMainUser").val()+","+$("#planSubMainUser").val()+","+$("#planTellUser").val();
         var reg = /true/g;
         var temp ="";
         var sendStr = new Array(); 
         if(reg.test(sendUserStr)){//加载计划新建页面的时候，这个发送人里面的字符串是"|Member|人员id|部门id｜true",这样的，这里做个处理，只取人员id
             sendStr= sendUserStr.split(",");
             for(var i=0;i<sendStr.length;i++){
                sendStr[i] = sendStr[i].replace(/Member\|/g,"");
                sendStr[i] = sendStr[i].substring(0,sendStr[i].indexOf("|"));
                temp+=sendStr[i]+",";
             }
             sendUser = temp;
         }else{//在点了选人界面以后，发送人里面的字符串却是"|Member|人员id"这样的
             sendUser =$("#planToMainUser").val().replace(/Member\|/g,"")+","+$("#planSubMainUser").val().replace(/Member\|/g,"")+","+$("#planTellUser").val().replace(/Member\|/g,"");
         }
      return sendUser;
  }
  function submitPlanData(){//提交前先验证表单中的提及人员是否在发送人员中
     var fieldIdStr = getFormUsersField();
     //alert(fieldIdStr);
     var planid = $("#planId").val();
     var formId = $("input[id='contentTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
     delOldData();
     if(formId!="0"){//是表单计划
         var formDataId =$("input[id='contentDataId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
         var sendUser = getSendUser();
         var pm = new planManager();
         var norangeUser = "";
         var noRangeUserIds = pm.getNoRangeUserId(fieldIdStr,formDataId,sendUser);//不在发送范围内的人员id
         var recordAndUserIdAndField = getFormRecordAndUser(noRangeUserIds);
         norangeUser = pm.getNoRangeUser(fieldIdStr,formDataId,sendUser);
         if(norangeUser!=""){//弹出表单中提及人员，但是却不在发送范围内
            var message = $.i18n('plan.noRangeUser',norangeUser);//"您在计划中提及{0},但其不在发送范围内，继续发送请点击[确定]，返回修改请点击[取消]";
            var confirm = $.confirm({
            'msg': message,
            ok_fn: function () {
            	startProgressBar("");
                pm.saveMentionInfo(formId,planid,recordAndUserIdAndField);
                if(window.frames["mainbodyFrame"].contentWindow!=undefined){
                	//firefox下的调用方式
                	window.frames["mainbodyFrame"].contentWindow.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
                }else{
                	window.frames["mainbodyFrame"].window.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
                }
            },
            cancel_fn:function(){
              unDisabledSendButton();
            },
            close_fn : function(){
              unDisabledSendButton();
            }
            });
         }else{
            startProgressBar("");
            pm.saveMentionInfo(formId,planid,recordAndUserIdAndField);
            if(window.frames["mainbodyFrame"].contentWindow!=undefined){
                //firefox下的调用方式
                window.frames["mainbodyFrame"].contentWindow.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
              }else{
                window.frames["mainbodyFrame"].window.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
              }
         }
    }else{//非表单计划，直接保存
        startProgressBar("");
        if(window.frames["mainbodyFrame"].contentWindow!=undefined){
          //firefox下的调用方式
          window.frames["mainbodyFrame"].contentWindow.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
        }else{
          window.frames["mainbodyFrame"].window.saveContent(planid,jstoHTMLWithoutSpacetitle(),function(){savePlan();},function(){loseSaveContent();});
        }
    }
      
}
function getFormUsersField(){//获取表单中人员控件中的fieldid,即选人控件的字段名fieldxxx
     var allField = $("span[fieldVal]",getIFrameDOM('mainbodyFrame'));
     var fieldIdStr = "";
     allField.each(function(){
        var fieldval = $(this).attr("fieldVal");
        var fieldJson = eval("(" + fieldval + ")");  
        if(fieldval.indexOf("member")>-1&&(fieldJson.isMasterFiled=="false"||fieldJson.isMasterFiled==false)){//取到选人控件,并且不是主表选人控件
            if(fieldIdStr.indexOf($(this).attr("id").replace("_span","")+",")==-1){//去重
                fieldIdStr+=$(this).attr("id").replace("_span","")+",";//取出来的字符是fieldxxx_span,替换下
            }
            
        }
      });
      return fieldIdStr;
}

function getFormRecordAndUser(noRangeUserIds){//取得recordid -> user 键值
    var alltr = getTrObj();//获取每个重复项的tr
    var str = "";
    if(alltr.length > 0) {
      alltr.each(function(){
          var thisTr=this;//由于嵌套了两个each为了区分里面的this和外面的this这里把外面的this定义为thisTr
          var recordid = $(thisTr).attr("recordid");//获取每个recordid
          var thisTrTd = $("span[fieldVal]",thisTr);//当前重复项行的td
          var needDisplayField = "";//需要显示的重复项列头
          var eachTdUsers = "";
          var eachTrUsers = "";
          str +=recordid+":";
          thisTrTd.each(function(){
              var fieldval = $(this).attr("fieldVal");
              var fieldJson = eval("(" + fieldval + ")");  
              if(fieldval.indexOf("member")>-1&&(fieldJson.isMasterFiled=="false"||fieldJson.isMasterFiled==false)){//取到选人控件,并且不是主表选人控件
                   //var perStr = $(this).find("span input").val();
                   var perStr = $("input[id='"+fieldJson.name+"']",this).val();
                   eachTdUsers = disFormatPersonIds(perStr,noRangeUserIds);
                   var everyUser = eachTdUsers.split(",");//重复项每一行的人员再去重
                   for(var i=0;i<everyUser.length;i++){
  	                 if(eachTrUsers.indexOf(everyUser)==-1){
  	                    eachTrUsers+=everyUser+",";
  	                 }
                   }
              }
              //一级维度field0005、二级维度field0006、事项描述field0014、开始时间field0009、结束时间field0010
              //需要显示的5个字段，如果表单中有，就加进去
              if(fieldJson.displayName=="一级维度"||fieldJson.displayName=="二级维度"||fieldJson.displayName=="事项描述"||fieldJson.displayName=="开始时间"||fieldJson.displayName=="结束时间"||fieldJson.displayName=="开始日期"||fieldJson.displayName=="结束日期"){
                  if(needDisplayField.indexOf(fieldJson.name)==-1){//过滤掉重复的字符
                      needDisplayField+=fieldJson.name+",";
                  }
              }
          });
          str +=eachTrUsers + "#" +needDisplayField+"!";//record:userid,userid#field005,field006...!,格式
      });
    }
    return str;//最终返回的格式是record:userid,userid#field005,field006!record:userid,userid#field005,field006...!
}
function disFormatPersonIds(str,noRangeUserIds){
    if(str==""){return "";}
    var ids = str.split(",");
    var formatId="";
    var personIds="";
    for(var i=0;i<ids.length;i++){
        var id = ids[i];
        formatId = id.split("|");
        var perid = formatId[1];
        var norangers = noRangeUserIds.split(",");
        var isInNorange = false; //选人控件中的人员ID是否是在 本计划的发送范围外，在本计划发送范围外的人，不用保存
        for(var j=0;j<norangers.length;j++){
        	if(perid==norangers[j]){
        		isInNorange = true;
        	}
        }
        if(!isInNorange){
        	if(personIds.indexOf(perid)==-1){
                    personIds += perid;
                    if(i!=ids.length-1){
                        personIds+=",";
                    }
                } 
        }
        
    }
    return personIds;
}
  //保存计划为草稿
  function saveAllInfoAs(){
    disabledSendButton();
    if(isFormSubmit) {
        isFormSubmit = false;
    }
    var pm = new planManager();
    var isTemplate = pm.checkTemplate(templateIdTemp);
    if(typeof(isTemplate) != "undefined" && isTemplate != 'yes'){
        $.alert(isTemplate);
        unDisabledSendButton();
    }else{  
        var title = $("#title").val(); 
        var defaultTitle = $.i18n('collaboration.newcoll.clickfortitle');
        if($.trim(title) == "" || $.trim(title).indexOf(defaultTitle) >= 0){ 
        $.alert($.i18n('calendar.event.subject.can.not.null'));
        $("#title").val("");
        $("#send").removeClass("common_button_disable");
	    $("#send").bind("click",saveAllInfo);
          return false; 
        }
        var planid = $("#planId").val();
        if($("#isModifyInput").val()==="1"){//修改时才需要取该值
            if(typeof(testcontentid) == "undefined")
                testcontentid = $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
        }
        if(testcontentid){//修改时才会有值
            var templateId = $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
            $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(testcontentid);
            if($("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val()=="-1"){ //如果是修改成其他表单模板时，为该hidden域赋值
                $("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(templateId);
            }
        }else{
            //content组件不完善,新建的时候moduleTemplateId统一为-1L
            $("input[id='moduleTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val(-1);
        }
        if($("#planform").validate()&&validReleUsers()&&validIsRepeatPlan()){
          startProgressBar("");
          delOldData();
          if(window.frames["mainbodyFrame"].contentWindow!=undefined){
            //firefox下的调用方式
            window.frames["mainbodyFrame"].contentWindow.saveContent(planid,$("#toHTMLWithoutSpacetitle").val(),function(){savePlanAs();},function(){loseSaveContent();});
          }else{
            window.frames["mainbodyFrame"].window.saveContent(planid,$("#toHTMLWithoutSpacetitle").val(),function(){savePlanAs();},function(){loseSaveContent();});
          }
        }else{
          unDisabledSendButton();
        }
    }
  }
  var proce = null;
  /**
   * 启动进度条
   * @param meg 进度显示信息
   */
  function startProgressBar(meg) {
      proce = $.progressBar({
          text : meg
      });
  }

  /**
   * 关闭进度条
   */
  function closeProgressBar() {
      if (proce && proce != null) {
          proce.close();
          proce = null;
      }
  }
  
  function loseSaveContent(){
    //正文保存失败的情况处理
    closeProgressBar();
    unDisabledSendButton();
  }
  
  function savePlanAs() {
        var frmobj = $("#planform").formobj();
        //日计划，将结束日期附上值(因为日计划在选择的时候结束日期是置灰的，没值)
        if($("#type").val()==='1'){
          frmobj.endTime = frmobj.startTime;
        }
        var pm = new planManager();
        //保存计划
        frmobj.planStatus = '1';//未开始
        frmobj.publishStatus = '1';//草稿
        if($("#contentType").val()==='20'){
          //如果是表单那么先更新状态
          var obj= new Object();
           var currentMasterDataId = $("#contentDataId",getIFrameDOM('mainbodyFrame')).val();
           var currentFormId = $("#contentTemplateId",getIFrameDOM('mainbodyFrame')).val();
           obj.formId=currentFormId;
           obj.dataId=currentMasterDataId;
           obj.state=0;
           var pm = new planManager();
           pm.updateFormState(obj);
        }
        if( $("#isModifyInput").val()==="1"){
          pm.updatePlanForBO(frmobj,relationDatas);
          //保存附件
          $("#planform").jsonSubmit({
            domains : [ "plan_table" ],
            debug : false,
            callback : function(res) {
              //delOldData();
              refreshPage();
              //window.location=  $("#pathInput").val() +"/plan/plan.do?method=planListHome&type="+$("#type").val();
              window.close();
              removeCtpWindow('123123123123123123',2);
              removeCtpWindow('123123123123123123456',2);
              removeCtpWindow(null,2); 
          }
         });
       }else{
          pm.savePlan(frmobj,relationDatas);
          $("#planform").jsonSubmit({
            domains : [ "plan_table" ],
            debug : false,
            callback : function(res) {
              //delOldData();
              //window.location=  $("#pathInput").val() +"/plan/plan.do?method=planListHome&type="+$("#type").val();
              refreshPage();
              window.close();
              removeCtpWindow('123123123123123123',2);
              removeCtpWindow('123123123123123123456',2);
              removeCtpWindow(null,2);
          }
          });
       }       
  }
  
  window.plantoolbar = $("#colToolbar").toolbar(
          {
            toolbar : [
                {
                  id:"save",
                  name : $.i18n('common.toolbar.save.label'),
                  className : "ico16 save_traft_16",
                  click : saveAllInfoAs
                },
                {
                  name : $.i18n('common.toolbar.insert.label'),
                  className : "ico16 affix_16",
                  subMenu : [ {
                    name : $.i18n('common.toolbar.insert.localfile.label'),
                    click : function() {
                      insertAttachment();
                    }
                  }, {
                    name : $.i18n('common.toolbar.insert.mydocument.label'),
                    click : function() {
                      quoteDocument('position1');
                    }
                  } ]
                },
                {
                  id: "planConotentTypeSubmenu",
                  name:$.i18n('collaboration.newcoll.conotentType'),
                  className: "ico16 text_type_16",
                  subMenu: getContentTypeChooser('colToolbar','10',function(){
                      changePlanFormat();                 
                  })
              },{
                  id: "copyFun",
                  name: $.i18n('plan.copy.copyfrom'),
                  className: "ico16 copy_from_16",
                  subMenu: copyFun(copyFunCb)
              },{
                id: "referItem",
                name: $.i18n('plan.label.refer'),
                className: "ico16 correlation_form_16",
                click: relationPlanAll
            }, {
            	id: "printPlan",
                name: $.i18n('collaboration.newcoll.print'),
                className: "ico16 print_16",
                click: function () {
                	var printObj = initPrintObj();
                    doPrint(printObj);
                }
            } ]
  });
  $("#send").bind("click",saveAllInfo);
});

// 正文组件打获取正文切换Toolbar定义实现
// 注：这段代码从正文组件中提取出来，与协同一样各自维护，因为正文组件为了轻表单，将该功能抽离出来了
var _mt_toolbar_id = "", _lastMainbodyType, _mainbodyOcxObj, _clickMainbodyType;
function getContentTypeChooser(toolbarId, defaultType, callBack){
	if (!toolbarId)
		toolbarId = "toolbar";
	_mt_toolbar_id = toolbarId;
	var r = [];
	for ( var i = 0; i < mtCfg.length; i++) {
		var mt = mtCfg[i].mainbodyType;
		mtCfg[i].value = mt;
		mtCfg[i].id = "_mt_" + mt;
		if (defaultType != undefined && defaultType != "") {
			if (mt == defaultType) {
				mtCfg[i].disabled = true;
				_lastMainbodyType = mt;
			}
		} else if (i == 0) {
			mtCfg[i].disabled = true;
			_lastMainbodyType = mt;
		}
		mtCfg[i].click = function() {
			var cmt = $(this).attr("value");
			_clickMainbodyType = cmt;
			if (callBack) {
				switchContentTypeFun(cmt, function() {
//					if (_lastMainbodyType) {
//						$("#" + _mt_toolbar_id).toolbarEnable("_mt_" + _lastMainbodyType);
//					}
//					$("#" + _mt_toolbar_id).toolbarDisable("_mt_" + cmt);
//					_lastMainbodyType = cmt;
					callBack(cmt);
				});
			}
		};
		try {
			if ($.ctx.isOfficeEnabled(mt))
				r.push(mtCfg[i]);
		} catch (e) {
		}
	}
	return r;

}

function switchContentTypeFun(mainbodyType, successCallback) {
	if (successCallback){
		successCallback();
	}
};

function copyFun(callBack){
    var  myplanList = myplanListAll;
    var r =[];
    if(myplanList){
        var expact= 5;
        for(var i = 0;i < myplanList.length;i++){
                var  mpl = myplanList[i];
                myplanList[i].id="_mt_" + mpl.planId;
                myplanList[i].value = mpl.contentType;
                var showName;
                if(mpl.planName.length > 15){
                    showName = mpl.planName.substring(0,14) +"...";
                }else{
                    showName = mpl.planName;
                }
                myplanList[i].name = mpl.planName;
                myplanList[i].click = function(){
                    var planId = $(this).attr("id");
                    var ct = $(this).attr("value");
                    if(callBack){
                        callBack(planId,ct);
                    }
                }
                expact -- ;
                r.push(myplanList[i]);
         }
         var addobj={};
         for(var m= 0 ; m <expact; m ++){
             addobj.id="_mt_expact"+m;
             addobj.value = "&nbsp;";
             addobj.name = "&nbsp;";
             r.push(addobj);
         }
         
    }
    return r;
}

function copyFunCb(planId,ct){
    var copyplanId = planId.substring(4,planId.length-2);// _mt_-5181276951909545000_a
    var curTemplateId = templateIdTemp;
    var obj= new Object();
    if(isModifyFlag){//如果是修改传入被修改的计划ID
       obj.beModifiedPlanId =  $("#planId").val();      
    }
    obj.curTemplateId = $("#templateId").val();
    obj.copyplanId = copyplanId;
    obj.copyplanct = ct;
    obj.contentType = $("#contentType").val();
    var pm = new planManager();
    pm.checkPotent(copyplanId,{
        success:function(ret){
        if(ret=="true"){
          var reObj = pm.copyFunction(obj);
          //提示语言的种类style表示
          var isForm  = reObj.isform; // 想要复制计划的类型是否是表单
          var isSameContent = reObj.isSameContent; // 想要复制计划的类型 不是表单的时候是否是相同正文类型
          var form_sameTemplate = reObj.form_sameTemplate; 
          if(reObj.style =='tip1'){
              var confirm = "";
                  confirm = $.confirm({
                      'msg': $.i18n('plan.copy.contentwillbereplace'),//督办时间比当前时间早，是否继续？
                      ok_fn: function () {
                          ischangeTemplate = true;
                          oldPlanId = $("#planId").val();
                          oldContentType = $("#contentType").val();
                          doCopyAtts(pm,copyplanId);
                          doChangeConntent(obj,reObj);
                      },
                      cancel_fn:function(){
                      }
                  });
          }else if(reObj.style =='tip2'){
              var confirm = "";
              confirm = $.confirm({
                  'msg': $.i18n('plan.copy.formatdifferent.contentwillbereplace'),//督办时间比当前时间早，是否继续？
                  ok_fn: function () {
                      ischangeTemplate = true;
                      oldPlanId = $("#planId").val();
                      oldContentType = $("#contentType").val();
                      doCopyAtts(pm,copyplanId);
                      doChangeConntent(obj,reObj);
                  },
                  cancel_fn:function(){
                  }
              });
          }else if(reObj.style == 'tip3'){
              $.alert($.i18n('plan.copy.nocompetence'));
          }
        }else if(ret=="false"){
          $.alert($.i18n('plan.alert.nocopy'));
        }else if(ret=="absence"){
          $.alert($.i18n('plan.alert.deleted'));
        }
      }
    }); 
}
function adjustTopHeight(){
    $("#mainbodyArea").height($("body").height()-$("#formArea").height());  
}
function doCopyAtts(pm,planId){
    var attachments = pm.getAttsByPlanId(planId);
    var attachments = attachments.replace(/\&nbsp;/g,' ');
    fileUploadAttachments.clear();
    $("#attachmentArea").html("");
    $("#attachment2Areaposition1").html("");
    parseAttData(attachments,null,true,true,false,false);
    parseAttData(attachments,"position1",false);
    if($("#attachmentArea").html().length == 0) {
        $("#attachmentTR").hide();
    }
    if($("#attachment2Areaposition1").html().length == 0) {
        $("#attachment2TRposition1").hide();
    }
}
function doChangeConntent(obj,reObj){
    isCopy = true;
    if(obj.copyplanct =='20'){
        var _fromCopy = reObj.contentAllId;
        $("#mainbodyFrame").attr("src",$("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+reObj.tId+"&moduleType=5&viewState=1&fromCopy="+_fromCopy);
        plantoolbar.showBtn("referItem");
    }else{
        $("#mainbodyFrame").attr("src",$("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+obj.copyplanId+"&moduleType=5&viewState=1&isNew=false&contentType="+obj.copyplanct);
        plantoolbar.hideBtn("referItem");
    }
    
    //修改moduleId
    window.intertm = window.setInterval(function(){
            try{
                dochangeparam(obj,reObj);
            }catch(e){}},100);
      
}
function delOldData(){
    if(isModifyFlag && useForCopyFlag){
        //alert("需要删除老正文");
        var pm = new planManager();
        var obj = new Object();
        obj.planId =  $("#planId").val();
        obj.beModifiedContentAllId =beModifiedContentAllId;
        obj.beModifiedContentType = beModifiedContentType;
        obj.beModifiedContentConTemId= beModifiedContentConTemId;
        obj.beModifiedContentDataId = beModifiedContentDataId;
        var reObj = pm.delContentData(obj);
    }
}

var needChangeOfficeID= false;
var beModifiedContentAllId;
var beModifiedContentType;
var beModifiedContentConTemId;
var beModifiedContentDataId;
var useForCopyFlag =false;
function dochangeparam(obj,reObj){
    if(getIFrameDOM("mainbodyFrame").readyState=="complete"){
        useForCopyFlag = true;
        window.clearInterval(intertm);
        var contextObj = getIFrameDOM('mainbodyFrame');
        if(reObj.isform == "no"){//不是表单
            _lastMainbodyType = obj.copyplanct;
            $("#contentType").val(_lastMainbodyType);//变化正文类型
            if(reObj.isSameContent=="no"){
                $("#templateId")[0].selectedIndex = 0;//正文类型不一致,计划格式都切换为无
				var targetCntType = obj.contentType;
				if (obj.contentType == 20) {
					targetCntType = 10;
				}
                $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + targetCntType);//打开页面本身正文类型
                $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + _lastMainbodyType);//关闭目标正文类型
            }
            $("input[id='id'][type='hidden']",contextObj).val("");//id
            $("input[id='moduleId'][type='hidden']",contextObj).val("");//moduleId
            
            if(obj.copyplanct != '10'){
            	needChangeOfficeID = true;
            }           
        }else{//表单格式
            //变化正文类型
        	needChangeOfficeID = false;
            $("#contentType").val(20);
            if(reObj.form_sameTemplate == "no"){//不是同一个表单计划格式
                var targetPlanTid = reObj.tId;//切换计划格式为目标计划格式
                var selInput = $("#templateId")[0];
                for(var a = 0; a < selInput.length ; a ++){
                    if(selInput[a].value == targetPlanTid){
                        selInput.selectedIndex = a;
                        break;
                    }
                }
				_lastMainbodyType = 10;
				$("#" + _mt_toolbar_id).toolbarEnable("_mt_" + obj.contentType);//打开页面本身正文类型
                $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + _lastMainbodyType);//关闭目标正文类型
            }
        }
        if(isModifyFlag){//如果修改的时候复制自的时候 需要 发送后需要删除以前该计划对应的正文数据
            beModifiedContentAllId =  reObj.beModifiedContentAllId;
            beModifiedContentType  = reObj.beModifiedContentType;
            beModifiedContentConTemId = reObj.beModifiedContentConTemId;
            beModifiedContentDataId = reObj.beModifiedContentDataId;
        }
    }   
}
var isComplete;
var oldId;    //(OA-49236调用了计划格式发起的计划，修改正文类型为office，修改后查看，计划正文区出现两个按钮)
//因为修改表单计划切换计划正文之后，保存会新建一份数据，即一个计划就有了两份正文数据，
//所以需要将现有计划正文的ID赋过去，这样就不会在数据库创建新的数据，而只是做更新操作。
function changePlanFormat(){
     var confirm = $.confirm({
            'msg': $.i18n('content.switchtype.message'),
            ok_fn: function () {
                  oldId = $("#mainbodyFrame").contents().find("#id").val();
                  ischangeTemplate = true;
                  oldPlanId = $("#planId").val();
                  oldContentType = $("#contentType").val();
				  if (_lastMainbodyType != oldContentType) {
					  if (oldContentType == 20) {
						  _lastMainbodyType = 10;
					  } else {
						  _lastMainbodyType = oldContentType;
					  }
				  }
                  if(_lastMainbodyType){
                    $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + _lastMainbodyType);
                  }
                  $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + _clickMainbodyType);
                  _lastMainbodyType = _clickMainbodyType;
                  $("#contentType").val(_clickMainbodyType);
                  $("#templateId").val("-1");
                  contentFormat = null;
                  $("#mainbodyFrame").attr("src",$("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#planId").val()+"&moduleType=5&viewState=1&isNew=true&contentType="+_clickMainbodyType);
                  isComplete = window.setInterval(function(){
                      if(getIFrameDOM("mainbodyFrame").readyState=="complete"){
                          $("#mainbodyFrame").contents().find("#id").val(oldId);
                          window.clearInterval(isComplete);
                      }
                  },100);
                  showOrHidenReferBtn();
            },
              cancel_fn:function(){
              }
          });
  }
function getIFrameDOM(id){
      return document.getElementById(id).contentDocument || document.frames[id].document;
}
var contentFormat;
var templateIdTemp;
var testcontentid;//正文内容ID 切换模板时，记录该计划原来的正文ID，发送时将现在正文ID修改。否则修改后的正文ID与以前不一样，会被当作一条新的计划保存。
var ischangeTemplate = false; //是否切换了计划模板  ---true:不执行初始化关联数据
var oldPlanId;      //修改表单计划为非表单计划，需要删除之前表单的数据，这里需要记录老计划的ID和正文类型
var oldContentType;

//选择模板时切换链接
function changeTemplate(){
    if($("#isModifyInput").val()==="1"){//修改时才需要取该值
        if(typeof(testcontentid) == "undefined")
            testcontentid = $("input[id='id'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
    }
  var confirm = $.confirm({
    'msg': $.i18n('content.switchtype.message'),
    ok_fn: function () {
      oldPlanId = $("#planId").val();
      oldContentType = $("#contentType").val();
      ischangeTemplate = true;     
      relationDatas = new Object();   //切换表单格式的时候将原来的关系置空
      templateIdTemp = $("#templateId").val();
      if($("#templateId").val()==="-1"){
        $("#contentType").val(10);
        contentFormat = null;
        $("#hengx").addClass("hidden");
        $("#mainbodyFrame").attr("src", $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#planId").val()+"&moduleType=5&viewState=1&isNew=true&contentType=10");
	  }else{
        var pm = new planManager();
        contentFormat = pm.getContentTemplateById($("#templateId").val());
        //判断是否是来自于后台计划格式
        if(contentFormat!==null){
            var contentTypeValue = 10;
            if(contentFormat.templateFormat=="OfficeWord"){
              contentTypeValue= 41;
            }else if(contentFormat.templateFormat=="OfficeExcel"){
              contentTypeValue= 42;
            }else if(contentFormat.templateFormat=="WpsWord"){
              contentTypeValue= 43;
            }else if(contentFormat.templateFormat=="WpsExcel"){
              contentTypeValue= 44;
            }
            $("#hengx").addClass("hidden");
            $("#contentType").val(contentTypeValue);
            $("#mainbodyFrame").attr("src",$("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#templateId").val()+"&moduleType=1039&viewState=1&contentType="+contentTypeValue);
        }else{
          $("#contentType").val(20);
          $("#hengx").removeClass("hidden");
          $("#mainbodyFrame").attr("src",$("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#templateId").val()+"&moduleType=5&viewState=1");
          window.formdefaultintert = window.setInterval(function(){changeValueDefault()},1000);
        }
      }
      changePlanConotentType($("#contentType").val());
      showOrHidenReferBtn();
    },
    cancel_fn:function(){
      $("#templateId").val(templateIdTemp);
    },
    close_fn : function(){
      $("#templateId").val(templateIdTemp);
    }
  });
}
function changePlanConotentType(typeValue){
    var typeReplace = [];
    typeReplace['41'] = '43';
    typeReplace['43'] = '41';
    typeReplace['42'] = '44';
    typeReplace['44'] = '42';
    var contentTypeValue = typeValue;
    if(typeValue == 20){
        contentTypeValue = 10;
    }
    _clickMainbodyType = contentTypeValue;
	if (oldContentType == 20) {
		_lastMainbodyType = 10;
	} else {
		_lastMainbodyType = oldContentType;
	}
    if(_lastMainbodyType){
        $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + _lastMainbodyType);
    }
    if($.ctx.isOfficeEnabled(contentTypeValue)){
        $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + contentTypeValue);
        _lastMainbodyType = contentTypeValue;
    }else if($.ctx.isOfficeEnabled(typeReplace[contentTypeValue])){
        $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + typeReplace[contentTypeValue]);
        _lastMainbodyType = typeReplace[contentTypeValue];
    }
    //_lastMainbodyType = _clickMainbodyType;
    
}

function afterDelRow(crecordid){
  if(relationDatas.allDatas!=undefined){
    for(var i=0;i<relationDatas.allDatas.length;i++){
      var hasRecordId = relationDatas.allDatas[i].recordId;
      try{
        if(crecordid==hasRecordId){
          relationDatas.allDatas.splice(i,1);
          relationDatas.allData.splice(i,1);
          break;
        }
      }catch(e){
      }
    }
  }
}

function showOrHidenReferBtn() {
  try {
    if($("#contentType").val() != 20) {
      plantoolbar.hideBtn("referItem");
    } else {
      plantoolbar.showBtn("referItem");
    }
  } catch (e) {}
}

//调用计划关联页面
function relationPlan(obj){
  var recordHTML = $(obj).parent().find("textarea");
  var recordid;
  if(window.frames["mainbodyFrame"].contentWindow!=undefined){
    //firefox下的调用方式
    recordid =  window.frames["mainbodyFrame"].contentWindow.getRecordIdByJqueryField(recordHTML);
  }else{
    recordid =  window.frames["mainbodyFrame"].window.getRecordIdByJqueryField(recordHTML);
  }
  var curSubTableName = recordHTML.attr("subTableName");
  planRelationFrame(recordid,curSubTableName);
}

//获取需要显示的列头名称
function getHeaderName() {
  var headerNameStr = "";
  var trObj = getTrObj();// 获取每个重复项的tr
  var descTrObj = null;
  if(trObj.length > 0) {	
	for (var i = 0; i < trObj.length; i++) {
		var tempAllField = $("span[fieldVal]", trObj[i]);
		tempAllField.each(function() {
			var fieldValue = $(this).attr("fieldVal");
			var fieldJsonObj = eval("(" + fieldValue + ")");
			if (fieldJsonObj.displayName == "事项描述") {
				descTrObj = trObj[i];
			}
		});
		if (descTrObj != null && descTrObj != "null") {
			break;
		}
	}
    var allField = $("span[fieldVal]", descTrObj);// 得到重复项字段对象
    var discriptionNum = null;
    var fieldName = "";
    var index = 0;// 用于记录事项描述所在的第几个位置，用于后面界面设置宽度比
    allField.each(function() {
      var fieldval = $(this).attr("fieldVal");
      var fieldJson = eval("(" + fieldval + ")");
      if (fieldJson.displayName == "一级维度" || fieldJson.displayName == "二级维度" || fieldJson.displayName == "事项描述" || fieldJson.displayName == "开始时间"
          || fieldJson.displayName == "结束时间" || fieldJson.displayName == "开始日期" || fieldJson.displayName == "结束日期") {
        headerNameStr += fieldJson.displayName + ",";
        index = index + 1;
        if (fieldJson.displayName == "事项描述") {// 事项描述记录下它的列
          discriptionNum = index;
          fieldName = fieldJson.name;
        }
      }
    });
    if (headerNameStr.length > 0) {
      headerNameStr = headerNameStr.substring(0, headerNameStr.length - 1);// 去掉最后一个逗号
    }
    headerNameStr += "!" + discriptionNum + "!" + fieldName;// 后面加一个事项描述所占的列号
  }
  return headerNameStr;
}

function getTrObj() {
  var trObj = "";
  if($("table[id^=formson_] tr[recordid]",getIFrameDOM('mainbodyFrame')).length>0){
    trObj = $("table[id^=formson_] tr[recordid]",getIFrameDOM('mainbodyFrame'));
  }else if($("div[id^=formson_] div[recordid]",getIFrameDOM('mainbodyFrame')).length>0){
    trObj = $("div[id^=formson_] div[recordid][class='xdRepeatingSection xdRepeating']",getIFrameDOM('mainbodyFrame'));
  }
  return trObj;
}
/**
 * 获取事项描述为空的重复项recordid
 */
function getEmptyDescRecordId(){
  var recordid = "-2";
  var trObj = getTrObj();
  var tempRecordId = [];
  trObj.each(function(){
    var rowData = null;
    var fildeDatas = null;
    if(window.frames["mainbodyFrame"].contentWindow!=undefined){
      //firefox下的调用方式
      rowData =  window.frames["mainbodyFrame"].contentWindow.getRowData($(this));
    }else{
      rowData =  window.frames["mainbodyFrame"].window.getRowData($(this));
    }
    if(rowData != null && rowData.datas.length >0) {
      fildeDatas = rowData.datas;
    }
    if(fildeDatas != null) {
      for(var i=0;i<fildeDatas.length;i++) {
        if(fildeDatas[i].displayName == "事项描述") {
          if($("textarea[name^="+fildeDatas[i].name+"]",$(this)).val().length == 0) {
            tempRecordId.push(rowData.id);
          } else {
            tempRecordId = [];
          }
          break;
        }
      }
    }
  });
  if(tempRecordId.length > 0) {
    recordid = tempRecordId[0];
  }
  return recordid;
}

/**
 * 判断事项描述控件是否存在
 */
function isExistDesc() {
  var isExist = false;
  var trObj = getTrObj();
  if(trObj.length > 0) {
    trObj.each(function(){
      $("textarea[name^=field]",$(this)).each(function(){
          var fieldValStr = $(this).parent().attr("fieldVal");
          if(fieldValStr!=null&&fieldValStr!=undefined){
              var fieldValObj = $.parseJSON(fieldValStr);
              if(fieldValObj.displayName == "事项描述") {
                isExist = true;
              }
          }
      });
    });
  }
  return isExist;
}

function relationPlanAll() {
  var isExistDs = isExistDesc();
  var curSubTableName = "";
  var textareaObj = $("textarea[name^=field]", getIFrameDOM('mainbodyFrame'));
  if (textareaObj.length > 0) {
	  for (var i = 0; i < textareaObj.length; i++) {
		  var fieldValStr = $(textareaObj[i]).parent().attr("fieldVal");
		  if(fieldValStr!=null&&fieldValStr!=undefined){
			  var fieldValObj = $.parseJSON(fieldValStr);
			  if(fieldValObj.displayName == "事项描述") {
				  curSubTableName = $(textareaObj[i]).attr("subTableName");
				  break;
			  }
		  }
	  }	
  }
  if(isExistDs) {
    var recordid = getEmptyDescRecordId();
    planRelationFrame(recordid,curSubTableName);
  } else {
    $.alert($.i18n('plan.alert.plandetail.noeventdesc'));
  }
}

var planRelationFrame = function (recordid,curSubTableName){
  var needDisplayNames = getHeaderName();
  var relDatas = "";
  var formId = $("input[id='contentTemplateId'][type='hidden']",getIFrameDOM('mainbodyFrame')).val();
  //通过recordid找到页面缓存中的匹配的关系数据
  if(relationDatas.allDatas!=undefined){
    for(var i=0;i<relationDatas.allDatas.length;i++){
      var hasRecordId = relationDatas.allDatas[i].recordId;
      try{
        if(recordid==hasRecordId){
          relDatas = relationDatas.allData[i];
          break;
        }
      }catch(e){
      }
    }
  }
  var url=_ctxPath+"/plan/plan.do?method=planReference&&recordId="+recordid+"&relDatas="+$.toJSON(relDatas)+"&curPlanId="+$("#planId").val()+"&formId="+formId+"&subTableName="+curSubTableName+"&needDisplayNames="+encodeURI(encodeURI(needDisplayNames));
  var dialog = $.dialog({
      url: url,
      width: $(getA8Top().document).width() - 100,
      height: 500,
      title:$.i18n('plan.alert.plannew.refertitle'),
      targetWindow:getCtpTop(),
      buttons: [{
          text: $.i18n('plan.alert.plannew.confirm'),
          handler: function () {
             var rv = dialog.getReturnValue();
             rv = $.parseJSON(rv);
             if(rv==""){
               $.alert($.i18n('plan.alert.plannew.chooseplanortask'));
               return false;
             }
             //当前所选子表数据参数
             relationDatas.data = rv;
             //所有所选的数据
             if(relationDatas.allData!=undefined){
               
               $.merge(relationDatas.allData,rv);
             }else{
               relationDatas.allData = rv;
             }
             //当前表单主数据id
             relationDatas.isRelation = "true";
             relationDatas.currentMasterDataId = $("#contentDataId",getIFrameDOM('mainbodyFrame')).val();
             relationDatas.rightId = $("#rightId",getIFrameDOM('mainbodyFrame')).val();
             relationDatas.subTableName = curSubTableName;
             relationDatas.currentFormId = $("#contentTemplateId",getIFrameDOM('mainbodyFrame')).val();
             relationDatas.recordid = recordid;
             relationDatas.planId = $("#planId").val();//当前的计划id
             relationDatas.ischangeTemplate = ischangeTemplate;
             //请求得到表单数据并回填
             if(rv.length>0){
               var formData = prm.getSelectedFormData(relationDatas);
               //当前选择的回填数据
               relationDatas.datas = formData.datas;
               //所有选择的回显数据
               if(relationDatas.allDatas!=undefined){
                 //有可能选了再选，所以要根据recordid剔除原来的再合并
                 for(var i=0;i<relationDatas.allDatas.length;i++){
                   var hasRecordId = relationDatas.allDatas[i].recordId;
                   try{
                     if(recordid==hasRecordId){
                       relationDatas.allDatas.splice(i,1);
                       relationDatas.allData.splice(i,1);
                       break;
                     }
                   }catch(e){
                   }
                 }
                 $.merge(relationDatas.allDatas,formData.datas);
               }else{
                 relationDatas.allDatas = formData.datas;
               }
               if(window.frames["mainbodyFrame"].contentWindow!=undefined){
                   window.frames["mainbodyFrame"].contentWindow.fillBackRowData($.toJSON(formData));
                   window.frames["mainbodyFrame"].contentWindow.fnResizeContentIframeHeight();
               }else{
                   window.frames["mainbodyFrame"].window.fillBackRowData($.toJSON(formData));
                   window.frames["mainbodyFrame"].window.fnResizeContentIframeHeight();
               }
             }
             dialog.close();
          }
      }, {
          text: $.i18n('plan.alert.plannew.cancel'),
          handler: function () {
              dialog.close();
          }
      }]
  });
}

//正文组件onload加载方法,如果是后台计划格式,需要先加载一个空白正文组件，再赋值，原因是后台格式不是调用的正文组件，是另外一套，就因为这个花了整整两天时间！
function loadContent(){ 
    //如果是HTML格式才添加定时器方法，否则无法销毁会一直执行。
  if($("#contentType").val()==='10'&&contentFormat!==null&&contentFormat!==undefined&&contentFormat!==""&&contentFormat.content!==null&&!isCopy){
    window.intert = window.setInterval(function(){
        try{
            setPlanContent(contentFormat.content);
        }catch(e){}},100);
  }
  isCopy = false;
}



function setPlanContent(planContent){
  if($("#mainbodyFrame")[0].contentWindow.$("#fckedit").attr("editorReadyState")==="complete"){
    window.clearInterval(intert);
    if(window.frames["mainbodyFrame"].contentWindow!=undefined){
      window.frames["mainbodyFrame"].contentWindow.setContent(planContent);
    }else{
      window.frames["mainbodyFrame"].window.setContent(planContent);
    }
  }
}

//验证主送等人员的合法性
function validReleUsers(){
  if($("#planToMainUser").val()===""&&$("#planSubMainUser").val()===""&&$("#planTellUser").val()===""){
      $.alert($.i18n('plan.alert.plannew.notsameblank'));
      return false;
  }else{
      return true;
  }
}

//验证是否在同一时间段有重复的计划
function validIsRepeatPlan(){
  var formIframeobj;
  if(window.frames["mainbodyFrame"].window!=undefined){
    formIframeobj = window.frames["mainbodyFrame"].window;
  }else{
    formIframeobj = window.frames["mainbodyFrame"].contentWindow;
  }
  var isDescNull = false;
  //先判断必填项
  var allfieldVals = $("span[id$='_span']",$(formIframeobj.document)).each(function(){
      if($(this).attr("fieldVal")!=undefined){
        var filedVal = $.parseJSON($(this).attr("fieldVal"));
        if(filedVal.displayName=="事项描述"){
          var targetSpId = $(this).attr("id");
          var targetId = targetSpId.split("_")[0];
          if(targetSpId!=undefined&&targetId!=undefined){
              var idInp = $(this).find("textarea[id="+targetId+"]");
              if(idInp.size()>0){
                if(idInp.val().trim()==""){
                    isDescNull = true;
                }
              }
          }
        }
      }
    });
  if(!isDescNull){
    if($("#type").val()!=='4'){
      //非任意期的计划才需要判断
      var frmobj = $("#planform").formobj();
      //日计划，将结束日期附上值
      if($("#type").val()==='1'){
        frmobj.endTime = frmobj.startTime;
      }
      var pm = new planManager();
      var isRepeat = pm.isPlanRepeated(frmobj);
      if(isRepeat == "yes"){
        $.alert($.i18n('plan.alert.plannew.repeatplan'));
        return false;
      }else if(isRepeat == $.i18n('template.cannot.use')){
          $.alert(isRepeat);
          return false;
      }else{
        return true;
      }
    }else{
      return true;
    }
  }else{
    $.alert($.i18n('plan.alert.plannew.eventdescnotblank'));
    return false;
  }
}

//检查时间和计划类型相匹配
function checkStartTime(obj){
  var date = obj.date.print("%Y-%m-%d");
  checkTime(date,false);
}
//检查时间和计划类型相匹配
function checkEndTime(obj){
  var date = obj.date.print("%Y-%m-%d");
  checkTime(date,true);
}
//将计算出来的日期补上0,比如2012-12-3日转换为2012-12-03(测试稳定后可以提为公共方法)
function formatStandardDate(startDate){
  startarray = startDate.split("-");
  var years = startarray[0];
  var month = startarray[1];
  var days = startarray[2];
  if(month<10){
    month = "0"+month;
  }
  if(days<10){
    days = "0"+days;
  }
  startDate = years + "-" + month + "-" + days;
  return startDate;
}

//计算时间(月开始的时间和结束的时间,周计划的周初和周末等)
var isClickStart = false;
var isClickEnd = false;
function checkTime(date,isEnd){
  var startDate;
  var endDate;
  if($("#type").val()==='1'){
      startDate = date;
      endDate = date;
  }
  if($("#type").val()==='2'){
      if(isEnd){
        if(!isClickStart){
          startDate = new Date().dateAdd(new Date().getWeekStart(date), 1);
          startDate = formatStandardDate(startDate);
        }else{
          startDate = $("#startTime").val();
        }
        endDate = date;
        if(compareDate(startDate, endDate) > 0){
          $.alert($.i18n('plan.alert.plannew.beginnotmorethanend'));
          endDate = "";
        }
        isClickEnd = true;
        if(!checkWeekDate(date,startDate,endDate)){
          $.alert($.i18n('plan.alert.plannew.timemistask'));
          endDate = "";
        }
      }else{
        if(!isClickEnd){
          endDate = new Date().dateAdd(new Date().getWeekEnd(date), -1);
          endDate = formatStandardDate(endDate);
        }else{
          endDate = $("#endTime").val();
        }
        startDate = date;
        if(compareDate(startDate, endDate) > 0){
          $.alert($.i18n('plan.alert.plannew.beginnotmorethanend'));
          startDate = "";
        }
        isClickStart = true;
        if(!checkWeekDate(date,startDate,endDate)){
          $.alert($.i18n('plan.alert.plannew.timemistask'));
          startDate = "";
        }
      }
  }
  if($("#type").val()==='3'){
     startDate = new Date().getMonthStart(date);
     endDate = new Date().getMonthEnd(date);       
  }
  if($("#type").val()==='4'){
      if(isEnd){
          startDate = $("#startTime").val();
          endDate = date;
          if(compareDate(startDate, endDate) > 0){
              $.alert($.i18n('plan.alert.plannew.beginnotmorethanend'));
              endDate = "";
          }
          isClickEnd = true;
      }else{
          startDate = date;
          endDate = $("#endTime").val();
          if(compareDate(startDate, endDate) > 0){
            $.alert($.i18n('plan.alert.plannew.beginnotmorethanend'));
            startDate = "";
          }
          isClickStart = true;
      }
  }
  $("#startTime").val(startDate);
  if($("#type").val()!=='1'){
    $("#endTime").val(endDate);
  }
}
//检查周开始和结束时间的合理性:date当前选中的时间,计算出来的开始和结束时间
function checkWeekDate(date,startDate,endDate){
  var planStartDate = new Date().dateAdd(new Date().getWeekStart(date), -1);
  planStartDate = formatStandardDate(planStartDate);
  var planEndDate = new Date().dateAdd(new Date().getWeekEnd(date), 1);
  planEndDate = formatStandardDate(planEndDate);
  if(compareDate(planStartDate, startDate)>0||compareDate(endDate, planEndDate)>0){
    return false;
  }else{
    return true;
  }
}
function initPlanRefRelationData() {
    var contentType = $("#contentType").val();
    var oldplanRefRelations = getplanRefRelations();
    if(contentType==="20" && oldplanRefRelations!=""&&oldplanRefRelations!=undefined && ischangeTemplate != true){
      var planRefRelations = $.parseJSON(oldplanRefRelations);
      var relationDataList = new Array();
      var recordid = -1;
      if(relationDatas.allData == undefined) {
          if(planRefRelations != undefined && planRefRelations.length > 0){
              for(var i=0;i<planRefRelations.length;i++){
                  var relationDataObj = new Object();
                  relationDataObj.id=planRefRelations[i].sourceDataId;//重复项的id(对应表单的recordid)
                  relationDataObj.name="";//名称(对应事项描述)
                  if(planRefRelations[i].sourceType == 5) {//参照计划还是参照任务
                      relationDataObj.type="myPlan";
                  } else if (planRefRelations[i].sourceType == 30){
                      relationDataObj.type="myTask";
                  } else {
                      relationDataObj.type="myMeeting";
                  }
                  relationDataObj.sourceid=planRefRelations[i].sourceId;//planid(计划参照时有用)
                  relationDataObj.sourceDataId = planRefRelations[i].sourceDataId;
                  relationDataObj.toDataId=planRefRelations[i].toDataId;//关联的重复项的recordid
                  relationDataObj.sourceCreator = planRefRelations[i].sourceCreator;//源计划或者任务创建者
                  relationDataList.push(relationDataObj);
              }
              relationDatas.allData = relationDataList;
              relationDatas.data = relationDataList;
          }
      }   
      //当前表单主数据id
      relationDatas.isRelation = "true";
      relationDatas.currentMasterDataId = $("#contentDataId",getIFrameDOM('mainbodyFrame')).val();
      relationDatas.rightId = $("#rightId",getIFrameDOM('mainbodyFrame')).val();
      relationDatas.subTableName = "";
      relationDatas.currentFormId = $("#contentTemplateId",getIFrameDOM('mainbodyFrame')).val();
      relationDatas.recordid = recordid;
      relationDatas.planId = $("#planId").val();//当前的计划id
      relationDatas.ischangeTemplate = ischangeTemplate;
      //请求得到表单数据并回填
      if(typeof(relationDatas.allData) != 'undefined' && relationDatas.allData.length>0){
        var formData = prm.getSelectedFormData(relationDatas);
        //当前选择的回填数据
        relationDatas.datas = formData.datas;
        //所有选择的回显数据
        relationDatas.allDatas = formData.datas;
     }
   }
}

function initPlan(){
	//OA-61694.升级测试：IE9新建计划，关联项目默认显示为空
	if($.browser.msie&&parseInt($.browser.version,10)==9){
		if($("#relateProject").val()==null){
			$("#relateProject").val("-1");
		}
	}
  //新建计划时，在form填充的时候触发了form验证，新建时标题为空，但为了防止这种错误，title有一个默认值，这样form验证通过，onload之后将其置为空
  if($("#isModifyInput").val()!=="1"){
    document.getElementById("title").onfocus = function(){
        if($("#title").val() == "<"+$.i18n('collaboration.newcoll.clickfortitle')+">"){
            $("#title").val("");
        }
    }
    document.getElementById("title").onblur = function(){
        var title = $("#title").val();
        if($.trim(title) == ""){
            $("#title").val("<"+$.i18n('collaboration.newcoll.clickfortitle')+">");
        }
    }
    $("#title").blur();
    $("#title").val("<"+$.i18n('collaboration.newcoll.clickfortitle')+">");
    //new inputChange($("#title"),"点击此处填写标题");
  }
//修改的话隐藏保存按钮
  if($("#isModifyInput").val()==="1"){
      if($("#contentType").val()=="10"){
       // plantoolbar.disabled("htmllabel");
      }else if($("#contentType").val()=="41"){
          $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + "10");
          $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + "41");
       // plantoolbar.disabled("wordlabel");
      }else if($("#contentType").val()=="42"){
        //plantoolbar.disabled("excellabel");
          $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + "10");
          $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + "42");
      }
      
      if($("#publishStatus").val()!=="1"){
          try{
            plantoolbar.hideBtn("save");
          }catch(e){}
      }
      if($("#title").val() != "<"+$.i18n('collaboration.newcoll.clickfortitle')+">") {
        $("#subject").val($("#title").val());
        $("#title").keyup(function (){
          $("#subject").val($("#title").val());
        });
      }
      //修改时的正文链接
      $("#mainbodyFrame").attr("src", $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#planId").val()+"&moduleType=5&viewState=1&contentType=10");
  }else{
      if($("#contentType").val()=="10"){
        //plantoolbar.disabled("htmllabel");
        $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + "10");
        $("#contentType").val(10);
        //新增状态的正文链接
        var src = "";
        if($("#templateIdInput").val()=='-1'||$("#templateIdInput").val()==''){
            src = $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#planId").val()+"&moduleType=5&contentType=10&isNew=true";
        }else{
            src = $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#templateIdInput").val()+"&moduleType=1039&viewState=1&contentType=10";
        }
        $("#mainbodyFrame").attr("src",src);
      }else if($("#contentType").val()=="20"){
        //表单
        $("#contentType").val(20);
        //新增状态的正文链接
        $("#mainbodyFrame").attr("src", $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#templateIdInput").val()+"&moduleType=5&viewState=1");
      }else{ //office格式
        //plantoolbar.disabled("wordlabel");
          $("#" + _mt_toolbar_id).toolbarEnable("_mt_" + "10");
          if($("#contentType").val()=="41") {        //word
              $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + "41");
          }else{
              $("#" + _mt_toolbar_id).toolbarDisable("_mt_" + "42");    //EXCEL
          }
          
        $("#contentType").val($("#contentType").val());
        //新增状态的正文链接
        var src = "";
        if($("#templateIdInput").val()=='-1'){
            src = $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#planId").val()+"&moduleType=1039&contentType="+$("#contentType").val()+"&isNew=true";
        }else{
            src = $("#pathInput").val() +"/content/content.do?isFullPage=true&moduleId="+$("#templateIdInput").val()+"&moduleType=1039&viewState=1&contentType="+$("#contentType").val();
        }
        $("#mainbodyFrame").attr("src",src);
      }
  }
	if(!$.browser.chrome){
	//初始化组件的值，选人组件不支持form回填,时间日期组件要格式化
				  if($("#type").val()==="4"&&$("#isModifyInput").val()!=="1"){
				    //任意期计划开始结束时间都有空
				    $("#startTime").val('');
				    $("#endTime").val('');
				  }else if($("#type").val()==="1"){
				    //日计划，结束日期不可选
				    $("#startTime").val($("#stime").val());
				    $("#endTime").attr("disabled", "true");
				    $("#endTime").parent().find(".calendar_icon").css("display","none");
				    $("#endTime").val('');
				  }else{
				    $("#startTime").val($("#stime").val());
				    $("#endTime").val($("#etime").val());
				  }
	}
  //赋值并支持回写选人组件,同时要排除另外两个选人选择的人员，主送选择了，那么抄送的选人自动就没有了
  $("#planToMainUser").comp({value:$("#planToMainUserInput").val(),text:$("#planToMainUserNameInput").val(),excludeElements:$("#planSubMainUserInput").val()+$("#planTellUserInput").val()});
  $("#planToMainUser").val(parseElementsOfTypeAndIdplanToMainUser());
  $("#planSubMainUser").comp({value:$("#planSubMainUserInput").val(),text:$("#planSubMainUserNameInput").val(),excludeElements:$("#planToMainUserInput").val()+$("#planTellUserInput").val()});
  $("#planSubMainUser").val(parseElementsOfTypeAndIdplanSubMainUser());
  $("#planTellUser").comp({value:$("#planTellUserInput").val(),text:$("#planTellUserNameInput").val(),excludeElements:$("#planToMainUserInput").val()+$("#planSubMainUserInput").val()});
  $("#planTellUser").val(parseElementsOfTypeAndIdplanTellUser());
  if($("#isModifyInput").val()==="1"){
      var relateDnTxt;
      if($("#relateDepartmentNameInput").val()){
          relateDnTxt = $("#relateDepartmentNameInput").val();
      }else{
          relateDnTxt = $.i18n('plan.add.department2');
      }
      $("#relateDepartment").comp({value:$("#relateDepartmentInput").val(),text:relateDnTxt});
  }else{
      //alert('${ctp:i18n('plan.add.department')}');
      $("#relateDepartment").comp({value:$("#relateDepartmentInput").val(),text:$.i18n('plan.add.department2')});
      if($("#relateDepartmentNameInput").val()){
          $("#relateDepartment").comp({value:$("#relateDepartmentInput").val(),text:$("#relateDepartmentNameInput").val()});
      }
  }  
  $("#relateDepartment").val(parseElementsOfTypeAndIdrelateDepartment());
  
  //记录当前的模板值
  templateIdTemp = $("#templateIdInput").val();
  //如果是表单模板，为表单的部门、人员、岗位赋上初始值
  if($("#contentType").val()=="20"){
    window.formdefaultintert = window.setInterval(function(){changeValueDefault()},1000);
    $("#hengx").removeClass("hidden");
  }
  $("#formArea").resize(function(){
      $("#mainbodyArea").height($("body").height()-$("#formArea").height());
  });
  showOrHidenReferBtn();
  //OA-63041.chrome下新建任意类型的计划，计划开始日期结束日期显示了时间点
  if($.browser.chrome){
  		var intert = window.setInterval(function(){
  			if(getIFrameDOM("mainbodyFrame").readyState=="complete"){
  				window.clearInterval(intert);
  				//初始化组件的值，选人组件不支持form回填,时间日期组件要格式化
				  if($("#type").val()==="4"&&$("#isModifyInput").val()!=="1"){
				    //任意期计划开始结束时间都有空
				    $("#startTime").val('');
				    $("#endTime").val('');
				  }else if($("#type").val()==="1"){
				    //日计划，结束日期不可选
				    $("#startTime").val($("#stime").val());
				    $("#endTime").attr("disabled", "true");
				    $("#endTime").parent().find(".calendar_icon").css("display","none");
				    $("#endTime").val('');
				  }else{
				    $("#startTime").val($("#stime").val());
				    $("#endTime").val($("#etime").val());
				  }
   			}
  	  	},100);
  }
}


function changeValueDefault(){
//为表单的部门、人员、岗位赋上初始值
  var peopleObj = {};
  peopleObj.id="Member|"+$("#currentUserid").val();
  peopleObj.text=$("#currentUsername").val();
  var depObj = {};
  depObj.id="Department|"+$("#depId").val();
  depObj.text=$("#depname").val();
  var postObj = {};
  postObj.id = "Post|"+$("#postId").val();
  postObj.text = $("#postName").val();
  var formIframeobj;
  if(window.frames["mainbodyFrame"].window!=undefined){
    formIframeobj = window.frames["mainbodyFrame"].window;
  }else{
    formIframeobj = window.frames["mainbodyFrame"].contentWindow;
  }
  if(formIframeobj!=undefined&&getIFrameDOM("mainbodyFrame").readyState=="complete"){
	  
	var _width1 = $("#mainbodyDiv",getIFrameDOM("mainbodyFrame"))[0].scrollWidth; //计划格式切换到超长表单格式时，表单格式的滚动宽度
   	var _width2 = $("#mainbodyFrame").width(); //当前页面iframe的宽度
   	if(_width1>=_width2){ //会出滚动条，但是高度不够，导致滚动条被遮挡
   		$("#mainbodyArea").height($("body").height()-$("#formArea").height()-20);  //于是减去滚动条的高度
   	}
   	  
    if($("#isModifyInput").val()!="1" || ischangeTemplate == true){
         var allfieldVals = $("span[id$='_span']",$(formIframeobj.document)).each(function(){
              if($(this).attr("fieldVal")!=undefined){
                var filedVal = $.parseJSON($(this).attr("fieldVal"));
                if(filedVal.displayName=="发起者姓名"){
                  if(formIframeobj.setFormFieldVal!=undefined){
                    formIframeobj.setFormFieldVal($(this),peopleObj);
                  }
                }
                if(filedVal.displayName=="发起者部门"){
                  if(formIframeobj.setFormFieldVal!=undefined){
                    formIframeobj.setFormFieldVal($(this),depObj);
                  }
                }
                if(filedVal.displayName=="发起者岗位"){
                  if(formIframeobj.setFormFieldVal!=undefined){
                    formIframeobj.setFormFieldVal($(this),postObj);
                  }
                }
              }
            });
    }
    //初始化关联数据
    initPlanRefRelationData();
    //执行成功之后清理定时器
    window.clearInterval(formdefaultintert);
    }
}

//修改主送的时候将已选的人员从抄送和告知中排除
function changeMainPeople(ret){
  $("#planSubMainUser").comp({excludeElements:ret.value+","+$("#planTellUser").val()});
  $("#planTellUser").comp({excludeElements:ret.value+","+$("#planSubMainUser").val()});
}
//修改抄送的时候将已选的人员从主送和告知中排除
function changeSubPeople(ret){
  $("#planToMainUser").comp({excludeElements:ret.value+","+$("#planTellUser").val()});
  $("#planTellUser").comp({excludeElements:ret.value+","+$("#planToMainUser").val()});
}
//修改告知的时候将已选的人员从抄送和主送中排除
function changeTellPeople(ret){
  $("#planToMainUser").comp({excludeElements:ret.value+","+$("#planSubMainUser").val()});
  $("#planSubMainUser").comp({excludeElements:ret.value+","+$("#planToMainUser").val()});
}

$(document).ready(function(){
    //$.confirmClose();
    adjustTopHeight();
    intert = window.setInterval(function(){
        resizeContentFrame();
    },300);
});
var intert;
//ie7下表单右边显示不出，需要动态设置表单宽度，但是会改变表单原来的样式。
function resizeContentFrame(){
    if(getIFrameDOM("mainbodyFrame").readyState == "complete"){
        window.clearInterval(intert);
        //ie7
        if($.browser.msie&&parseInt($.browser.version,10)<=7){  
                $("table.xdLayout",getIFrameDOM("mainbodyFrame")).each(function(){
                    var width = this.scrollWidth;
                    $(".xdRepeatingTable",$(this)).each(function(){
                        width = this.scrollWidth>width?this.scrollWidth:width;
                    });
                    $(this).width(width);
                });         
        }
    }
        
}

function getIFrameWindow(id){
	  return document.getElementById(id).contentWindow || document.frames[id].window;
}

/**
 * 初始化打印信息
 *
 */
function initPrintObj() {
	var printObj = new Object();
	printObj.contentType = $("#contentType").val();
	printObj.subject = $("#title").val();
	printObj.creater = $("#createUserName").val();
	printObj.departName = $("#createUserDept").val();
	printObj.postName = $("#createUserPost").val();
	printObj.createDate = $("#createTime").val();
	if ($("#attachmentNumberDiv").html().length == 0) {
		printObj.attNumber = 0;
	} else {
		printObj.attNumber = $("#attachmentNumberDiv").html();
	}
	printObj.attNameHtml = cleanSpecial(getFileAttachmentName(0));
	printObj.operaType = "edit";
	return printObj;
}

/**
 * 修改计划不保存，移除Session中当前表单数据缓存对象
 */
function removeSessionMasterData() {
    var currentMasterDataId = $("#contentDataId", getIFrameDOM("mainbodyFrame")).val();
    if (currentMasterDataId) {
        var tempFormManager = new formManager();
        tempFormManager.removeSessionMasterData({
            "masterDataId": currentMasterDataId
        });
    }
}