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
       		//隐藏office控件区域，防止弹出的页面闪烁
        	var officeFrameDiv = $("#officeFrameDiv");
        	if(officeFrameDiv.length > 0) {
        		officeFrameDiv.css("visibility","hidden");
        	}
            doPigeonhole_pre('new', _applicationCategoryEnum_collaboration_key, 'templete');
            break;
        default :
            theForm.archiveId.value = document.getElementById("prevArchiveId").value;
            return;
    }
}


function beforeCloseCheck(){
	  if(!isSubmitOperation){
	      if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
              return " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
          }else{
              return "";  //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
          }
	  }
}
function checkTemNumber(value){
    var txt = value.replace(/[ ]/g,"");
    if(txt.length <=0){
        return true;
    }else if(txt.length > 20){
        return true;
    }else if(/^[_a-zA-Z0-9]{0,20}$/.test(txt)){
        var sx = value.split(" ");
        if(sx.length > 1){
            //请填写20位以内的字母、数字或下划线组合!
            $.alert($.i18n('template.systemNewTem.lable1'));
            return false;
        }
        return true;
    }
    //请填写20位以内的字母、数字或下划线组合!
    $.alert($.i18n('template.systemNewTem.lable1'));
    return false;
}

function setAuth(){
    $.selectPeople({
           type:'selectPeople'
           ,panels:'Department,Team,Post,Level,Outworker,Account'
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
               } else{
            	   $("#authInfo").val("");
            	   templateAuthInfo="";
               }
           }
       });
   
}

function setSelectVal(value,obj){
    if(!value){
        return;
    }
    for(var i =0; i<obj.length; i ++){
        if(obj[i].value == value){
            obj.selectedIndex = i;
            break;
        }
    }
}

function setInit(){
    //设置高级属性下面三个下拉框的值
    var deadline = document.getElementById("deadline");
    var advanceRemind = document.getElementById("advanceRemind");
    var referenceTime = document.getElementById("referenceTime");
    var importantLevel = document.getElementById("importantLevel");
    var colPigeonhole = document.getElementById("colPigeonhole");
    var projectId = document.getElementById("projectId");

    var canForward = document.getElementById("canForward");
    var canModify = document.getElementById("canModify");
    var canEdit = document.getElementById("canEdit");
    var canEditAttachment = document.getElementById("canEditAttachment");
    var canArchive = document.getElementById("canArchive");
    var canAutoStopFlow = document.getElementById("canAutoStopFlow");
    var canMergeDeal = document.getElementById("canMergeDeal");
    
    setSelectVal(_summary_deadline,deadline);
    setSelectVal(_summary_advanceRemind,advanceRemind);
    setSelectVal(_template_standardDuration,referenceTime);
    //重要程度
    setSelectVal(_summary_importantLevel,importantLevel);
    //新建过来的时候 设置显示当前选择的分类 
    setSelectVal(_categoryId,document.getElementById("categoryId"));
    //修改的时候 置灰
      if(_templateNotNull == 'true'){
        if(_template_type != "template"){
            deadline.disabled=true; 
            advanceRemind.disabled=true;
            referenceTime.disabled=true;
            importantLevel.disabled=true;
            colPigeonhole.disabled=true;
            try{projectId.disabled=true;}catch(e){}
            canForward.disabled=true;
            canEdit.disabled=true;
            canEditAttachment.disabled=true;
            canEditAttachment.disabled=true;
            canArchive.disabled=true;
            canAutoStopFlow.disabled=true;
        }
        if(_template_type == "workflow"){
            canModify.disabled = false;
            canMergeDeal.disabled = false;
        }
        if(_template_type == "text"){
            $("#copyFlow")[0].disabled = true;
        }
    }
    /**增加追朔流程的选项**/
    var _canTrackWorkFlow = document.getElementById("canTrackWorkFlow");
    setSelectVal(_template_cantrackworkflowtype,_canTrackWorkFlow);
    
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
    //协同标题,流程添加默认值显示
    new inputChange($("#subject"), $.i18n('common.default.subject.value'));
    if($("#process_info").val() == ""){
        $("#process_info").val($.i18n('collaboration.default.workflowInfo.value'));
    }
    $("#toolbar").toolbar({
        borderTop:false,
        borderLeft:false,
        borderRight:false,
      toolbar : [ {
        id : "save",
        name : $.i18n('common.toolbar.save.label'),
        className : "ico16 save_up_16",
        click : function() {
            saveCollaborationTemplate();
        }
      }, {
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
        subMenu: $.content.getMainbodyChooser("toolbar",_bodyType,contentBack)
      },{
        id : "supervise",
        name : $.i18n('common.toolbar.supervise.label'),
        className : "ico16 setting_16",
        click:function(){
            openSuperviseWindow4Template();
        }
      }]
    });
  });
function openSuperviseWindow4Template(){
    var templateId = $("#templateMainData #id").val();
    openSuperviseWindow("1",false,null,templateId,null,null);
}

$(function(){
    $("#advance").click(function(){
        var tn = document.getElementById('templeteNumber');
        var dialog = new MxtDialog({
            id : "advanceDialog",
            width: 380,
            height: 400,
            title : $.i18n('collaboration.col.advance.label'),
            url : _ctxPath+"/collTemplate/collTemplate.do?method=handleAdvance",
            targetWindow : getCtpTop(),
            transParams : [$("#advanceHTML").clone(true), $('#advanceHTML select, #advanceHTML input')],
            buttons:[{
                text : $.i18n('template.category.submit.label'),
                handler:function(){
                    var result = dialog.getReturnValue();
                    var isRight = true;
                    $(result).each(function(index, elem){
                      var elemValue = $(elem).val();
                      var elemName = $(elem).attr("name");
                      
                      if(elemName == "templeteNumber"){
                    	  if(!checkTemNumber(elemValue)){
                    		  isRight = false;
                              return false;
                          }
                      }
                      $("#" + elemName).val(elemValue);
                      if($(elem).attr("type") == "checkbox"){
                        $("#" + elemName)[0].checked = $(elem)[0].checked;
                      }
                    });
                    if(isRight){
                    	dialog.close({isFormItem:true});
                    }
            	}
            },{
                text : $.i18n('template.category.cancel.label'),
                handler:function(){dialog.close();}
            }]
        });
    });
    //修改进来的时候设置页面值
    setInit();
    //
    $("#copyFlow").click(function(){
      var dialog = $.dialog({
        url : _ctxPath+'/collTemplate/collTemplate.do?method=selectSourceTemplate&templateId='+$("#id").val()+'&categoryId='+$("#categoryId").val(),
        width : 700, 
        height : 430, 
        title : $.i18n('template.systemNewTem.selectSourceTemplate'), //选择源模板
        targetWindow : getCtpTop(),
        buttons : [ {
          text :$.i18n('template.category.submit.label'),
          handler : function() {
            var category = dialog.getReturnValue();
            if(category == -1){
                //请选择一个模板!
                $.alert($.i18n('template.systemNewTem.selectOneTemplate'));
                return;
            }
            $("#process_info_bak").val($("#process_info").val());
            $("#process_xml_bak").val($("#process_xml").val());
            cloneWFTemplate(getCtpTop(), "collaboration", "", "",category,window,null,$.ctx.CurrentUser.id,$.ctx.CurrentUser.name,
            		$.ctx.CurrentUser.loginAccountName,$.ctx.CurrentUser.loginAccount,null,null,null,null);
            if(!$.browser.msie){
            	dialog.close();
            }else{
            	dialog.hideDialog();
            }
          }
        }, {
          text : $.i18n('template.category.cancel.label'),
          handler : function() {
        	  if(!$.browser.msie){
              	dialog.close();
              }else{
              	dialog.hideDialog();
              }
          }
        }]
      });
    });
    addScrollForDocument();
    
    if (_bodyType == 45) {
        $("#canEdit")[0].disabled = true;
        $("#canEdit")[0].checked = false;
    }
    
    $("#adtional_ico").click(function () {
        $("#comment_deal").toggleClass("adtional padding_l_5");
        $(".editadt_title,.editadt_box").toggleClass("hidden");
        $(".adtional_text").toggleClass("padding_l_5");
        $(this).find("em").toggleClass("arrow_2_l arrow_2_r margin_t_5");

        //计算textarea的高度
        var newTemplateTableHeight = $(".newTemplateTableHeight").height();
        var newTemplateTextareaHeight = newTemplateTableHeight - 50;
        $("#content_coll").css("height", newTemplateTextareaHeight);
    })
});

function contentBack(bodyType) {
    //如果是PDF正文，不能修改正文
    if (bodyType == 45) {
        $("#canEdit")[0].disabled = true;
        $("#canEdit")[0].checked = false;
    } else {
        $("#canEdit")[0].disabled = false;
        $("#canEdit")[0].checked = true;
    }
}