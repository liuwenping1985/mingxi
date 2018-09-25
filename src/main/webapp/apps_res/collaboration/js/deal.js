    
    $(function(){
        //--------------------------------------------- start: ToolBar 常用按钮  ----------------------------------------//
        var toolbarStr= new Array();
        var barNum;
        try{barNum = parseInt(commonActionNodeCount);}catch(e){barNum = 0;}
        function buildBarStr(id,name,className,clickFunc){
            var bar=new Object();
            bar.id=id;
            bar.name=name;
            bar.className="ico16 "+className;
            bar.click=clickFunc;
            return bar;
        }
        //控制常用按钮在工具栏中显示或隐藏
        function showBarsFunc() {
            for(var i=0;i<barNum;i++){
                  switch($("#tool_"+(i+1)).val()){
                      case '_commonAddNode'://加签
                      toolbarStr[toolbarStr.length]=buildBarStr("_commonAddNode",$.i18n('collaboration.nodePerm.insertPeople.label'),"signature_16",addNode);
                       break;
                     case "_commonAssign"://当前会签
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonAssign",$.i18n('collaboration.nodePerm.Assign.label'),"current_countersigned_16",currentAssign);
                       break;
                     case "_commonDeleteNode"://减签
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonDeleteNode",$.i18n('collaboration.nodePerm.deletePeople.label'),"signafalse_16",deleteNodeFunc);
                       break;
                     case "_commonAddInform"://知会
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonAddInform",$.i18n('collaboration.nodePerm.addInform.label'),"notification_16",addInformFunc);
                       break;
                     case "_commonStepBack"://回退
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonStepBack",$.i18n('collaboration.nodePerm.stepBack.label'),"toback_16",stepBackCallBack);
                       break;
                     case "_commonEditContent"://修改正文
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonEditContent",$.i18n('collaboration.nodePerm.editContent.label'),"modify_text_16",editContentFunc);
                       break;
                     case "_commonUpdateAtt"://修改附件
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonUpdateAtt",$.i18n('collaboration.nodePerm.allowUpdateAttachment'),"editor_16",modifyAttFunc);
                       break;
                     case "_commonStepStop"://终止
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonStepStop",$.i18n('collaboration.nodePerm.stepStop.label'),"termination_16",stepStopFunc);
                       break;
                     case "_commonCancel"://撤销
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonCancel",$.i18n('collaboration.nodePerm.repeal.label'),"revoked_process_16",dealCancelFunc);
                       break;
                     case "_commonForward": //转发
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonForward",$.i18n('collaboration.nodePerm.transmit.label'),"forwarding_16",dealForwardFunc);
                       break;
                     case "_commonSign"://签章
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonSign",$.i18n('collaboration.nodePerm.Sign.label'),"signa_16",openSignature);
                       break;
                     case "_commonTransform"://转事件
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonTransform",$.i18n('collaboration.nodePerm.TransformEvent.label'),"forward_event_16",transformFunc);
                       break;
                     case "_commonSuperviseSet"://督办设置
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonSuperviseSet",$.i18n('collaboration.nodePerm.superviseOperation.label'),"setting_16",superviseSetFunc);
                       break;
                     case "_dealSpecifiesReturn"://指定回退
                         toolbarStr[toolbarStr.length]=buildBarStr("_dealSpecifiesReturn",$.i18n('collaboration.default.stepBack'),"forward_event_16",specifiesReturnFunc);
                       break;
                     default:
                       //
                  }
              }
            }
          showBarsFunc();
          var toolbars = $("#toolb").toolbar({
              toolbar: toolbarStr,
              borderTop:false,
              borderLeft:false,
              isPager:false,
              borderRight:false
          });
          //--------------------------------------------- end: ToolBar 常用按钮  ----------------------------------------//
          //------start： 协同操作-------
          if (startCfg) {
              var _menuSimpleData=[];
              //循环遍历，以确定顺序
              if(nodePerm_advanceActionList != null && nodePerm_advanceActionList.length > 0){
                  for(var i = 0;i < nodePerm_advanceActionList.length; i++){
                      if(canModifyWorkFlow == 'true' || (canModifyWorkFlow == 'false' && startMemberId == affairMemberId)){
                          if (nodePerm_advanceActionList[i] === 'AddNode') {
                              //加签
                              _menuSimpleData.push({
                                  id:"_dealAddNode",
                                  name: $.i18n('collaboration.nodePerm.insertPeople.label'),
                                  className:"signature_16",
                                  customAttr:" advanceAction='AddNode' class='nodePerm'"
                              });
                          }
                          if (nodePerm_advanceActionList[i] === 'JointSign') {
                              //当前会签
                              _menuSimpleData.push({
                                  id:"_dealAssign",
                                  name: $.i18n('collaboration.nodePerm.Assign.label'),
                                  className:"current_countersigned_16",
                                  customAttr:" advanceAction='JointSign' class='nodePerm'"
                              });
                          }
                          if (nodePerm_advanceActionList[i] === 'RemoveNode') {
                              //减签
                              _menuSimpleData.push({
                                  id:"_dealDeleteNode",
                                  name: $.i18n('collaboration.nodePerm.deletePeople.label'),
                                  className:"signafalse_16",
                                  customAttr:" advanceAction='RemoveNode' class='nodePerm'"
                              });
                          }
                          if (nodePerm_advanceActionList[i] === 'Infom') {
                              //知会
                              _menuSimpleData.push({
                                  id:"_dealAddInform",
                                  name: $.i18n('collaboration.nodePerm.addInform.label'),
                                  className:"notification_16",
                                  customAttr:" advanceAction='Infom' class='nodePerm'"
                              });
                          }
                      }
                      if(nodePerm_advanceActionList[i] === 'Return'){
                          //回退
                          _menuSimpleData.push({
                              id:"_dealStepBack",
                              name: $.i18n('collaboration.nodePerm.stepBack.label'),
                              className:"toback_16",
                              customAttr:" advanceAction='Return' class='nodePerm'"
                          });
                      }
                      if ((nodePerm_advanceActionList[i] === 'Edit') && (bodyType != '20') &&  (bodyType != '45')) {
                          //修改正文
                          _menuSimpleData.push({
                              id:"_dealEditContent",
                              name: $.i18n('collaboration.nodePerm.editContent.label'),
                              className:"modify_text_16",
                              customAttr:" advanceAction='Edit' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'allowUpdateAttachment') {
                          //修改附件
                          _menuSimpleData.push({
                              id:"_dealUpdateAttachment",
                              name: $.i18n('collaboration.nodePerm.allowUpdateAttachment'),
                              className:"editor_16",
                              customAttr:" advanceAction='allowUpdateAttachment' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'Terminate') {
                          //终止
                          _menuSimpleData.push({
                              id:"_dealStepStop",
                              name: $.i18n('collaboration.nodePerm.stepStop.label'),
                              className:"termination_16",
                              customAttr:" advanceAction='Terminate' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'Cancel' && (isNewfolw !== 'true')) {
                          //撤销
                          _menuSimpleData.push({
                              id:"_dealCancel",
                              name: $.i18n('collaboration.nodePerm.repeal.label'),
                              className:"revoked_process_16",
                              customAttr:" advanceAction='Cancel' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'Forward') {
                          //转发
                          _menuSimpleData.push({
                              id:"_dealForward",
                              name: $.i18n('collaboration.nodePerm.transmit.label'),
                              className:"forwarding_16",
                              customAttr:" advanceAction='Forward' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'Sign' && bodyType != '45') {
                          //签章
                          _menuSimpleData.push({
                              id:"_dealSign",
                              name: $.i18n('collaboration.nodePerm.Sign.label'),
                              className:"signa_16",
                              customAttr:" advanceAction='Sign' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'Transform') {
                          //转事件
                          _menuSimpleData.push({
                              id:"_dealTransform",
                              name: $.i18n('collaboration.nodePerm.TransformEvent.label'),
                              className:"forward_event_16",
                              customAttr:" advanceAction='Transform' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'SuperviseSet') {
                          //督办设置
                          _menuSimpleData.push({
                              id:"_dealSuperviseSet",
                              name: $.i18n('collaboration.nodePerm.superviseOperation.label'),
                              className:"setting_16",
                              customAttr:" advanceAction='SuperviseSet' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'SpecifiesReturn') {
                          //指定回退
                          _menuSimpleData.push({
                              id:"_dealSpecifiesReturn",
                              name: $.i18n('collaboration.default.stepBack'),
                              className:"forward_event_16",
                              customAttr:" advanceAction='SpecifiesReturn' class='nodePerm'"
                          });
                      }
                  }
              }
              $("#moreLabel").menuSimple({
                  width:100,
                  direction:"BR",
                  offsetLeft:-10,
                  data: _menuSimpleData
              });
          }
          //------end: 协同操作-------
          var commonActs = advanceActs = {};
          $(".nodePerm").each(
              function(i) {
                var t = $(this);
                var ba = t.attr("baseAction");
                var ca = t.attr("commonAction");
                var aa = t.attr("advanceAction");
                if (ba && nodePerm_baseActionList && nodePerm_baseActionList.contains(ba)) {
                  t.show();
                } else if (ca && nodePerm_commonActionList && nodePerm_commonActionList.contains(ca)) {
                  t.show();
                  commonActs[ca] = t;
                } else if (aa && nodePerm_advanceActionList && nodePerm_advanceActionList.contains(aa)) {
                  t.show();
                  advanceActs[aa] = t;
                }
              });
          if(nodePerm_commonActionList) {
              for ( var i = 0; i < nodePerm_commonActionList.length; i++) {
                if (i < nodePerm_commonActionList.length - 2) {
                  var v = nodePerm_commonActionList[i], z = nodePerm_commonActionList[i + 1];
                  if (commonActs[v] && commonActs[z])
                    commonActs[v].after(commonActs[z]);
                }
              }
          }
          if(nodePerm_advanceActionList) {
              for ( var i = 0; i < nodePerm_advanceActionList.length; i++) {
                if (i < nodePerm_advanceActionList.length - 2) {
                  var v = nodePerm_advanceActionList[i];
                  var z = nodePerm_advanceActionList[i + 1];
                  if (advanceActs[v] && advanceActs[z])
                    advanceActs[v].after(advanceActs[z]);
                }
              }
          }
    });
    
    /**
     * $("#_auditPass") 归档回调函数
     * @returns
     */
    function auditPassPigeonCallback(result){
        if(result && result === "cancel"){
            enableOperation();
            setButtonCanUseReady();
            return;
        }
        $("#pigeonholeValue").val(result);
        auditPassAffterPigeon();
    }
    
    /**
     * $("#_auditPass") 归档后调用函数
     * @returns
     */
    function auditPassAffterPigeon(){
        if ($.content.callback.auditPass) {
            $.content.callback.auditPass();
        }
    }
    
    /**
     * $("#_vouchPass") 归档回调
     * @returns
     */
    function vouchPassPigeonCallback(result){
        if(result && result === "cancel"){
            enableOperation();
            setButtonCanUseReady();
            return;
        }
        $("#pigeonholeValue").val(result);
        vouchPassAffterPigeon();
    }
    
    /**
     * $("#_vouchPass") 归档后执行代码
     * @returns
     */
    function vouchPassAffterPigeon(){
        if ($.content.callback.vouchPass) {
            $.content.callback.vouchPass();
        }
    }
    
    
    $(function() {
        //
        $('#_dealAdvanceActionDIV').mouseleave(function(){
            $('#_dealAdvanceActionDIV').hide();
        });
        $("body").click(function(){
            $('#_dealAdvanceActionDIV').hide();
        });
        //转事件
        $("#_dealTransform,#_commonTransform").click(transformFunc);
        //提交
        $("#_dealSubmit").click(function() {
        	 //js事件接口
        	 var sendDevelop = $.ctp.trigger('beforeDealSubmit');
        	 if(!sendDevelop){
        		 return;
        	 }
        	
        	var trackMembersObj=document.getElementById("trackRange_members");
        	if(trackMembersObj&&trackMembersObj.checked){
    			if(document.getElementById("zdgzry").value == ""){
    				$.alert(_trackTitle);
    				return;
    			}
    		}
            //将‘提交’按钮置为不可用
            disableOperation();
            /*var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId,14);
            if(lockWorkflowRe[0] == "false"){
                $.alert(lockWorkflowRe[1]);
                enableOperation();
                setButtonCanUseReady();
                return;
            }
            var lockWorkflowCon = checkWorkflowLock(summaryId, currUserId,14);
            if (lockWorkflowCon[0] == "false") {
            	var messageContent = $.i18n('collaboration.summary.user')+lockWorkflowCon[2]+$.i18n('collaboration.summary.lockContent');
                if (isTemplete) {
                    $.alert(lockWorkflowCon[1]);
                    enableOperation();
                    setButtonCanUseReady();
                    return;
                }else{
                     var confirm = $.confirm({
                              'msg':messageContent,
                              ok_fn: function () {
                              comDealSubmit();
                              },
                              cancel_fn:function(){
                              	enableOperation();
                				setButtonCanUseReady();
                         		return;
                              }
                          });
                }
            } else {
            }*/
            comDealSubmit();
      });

      //修改正文开始
      $("#_commonEditContent,#_dealEditContent").click(editContentFunc);  
      //存为草稿
      $("#_dealSaveDraft").click(function() {
          if ($.content.callback.dealSaveDraft) {
              $.content.callback.dealSaveDraft();
          }
      });
      //暂存待办
      $("#_dealSaveWait").click(function() {
    	  //js事件接口
    	  var sendDevelop = $.ctp.trigger('beforeDealSaveWait');
     	  if(!sendDevelop){
     		 return;
     	  }
    	  
          //将'暂存待办'按钮置为不可用
          disableOperation();
          var canTempPendingResult= canTemporaryPending(workItemId);
          if(canTempPendingResult[0]== "false"){
            $.alert(canTempPendingResult[1]);
            enableOperation();
            setButtonCanUseReady();
            return;
          }
          var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId,14);
          if(lockWorkflowRe[0] == "false"){
            $.alert(lockWorkflowRe[1]);
            enableOperation();
            setButtonCanUseReady();
            return;
          }
          if ($.content.callback.dealSaveWait) {
              $.content.callback.dealSaveWait();
          }
      });
      //核定通过
      $("#_vouchPass").click(function() {
          var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId,14);
          if(lockWorkflowRe[0] == "false"){
              $.alert(lockWorkflowRe[1]);
              return;
          }
          
          if (!dealCommentTrue("vouchPass")){
              return;
          }
          if($("#pigeonhole").size()>0 && $("#pigeonhole")[0].checked){
              var result = pigeonhole(null, null, null, null, null, "vouchPassPigeonCallback");
          }else{
              vouchPassAffterPigeon();
          }
      });
      
      
      //核定不通过
      $("#_vouchNotPass").click(function() {
          var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId);
          if(lockWorkflowRe[0] == "false"){
              $.alert(lockWorkflowRe[1]);
              return;
          }
          
          if (!dealCommentTrue("vouchNotPass")){
              return;
          }
          if ($.content.callback.vouchNotPass) {
              $.content.callback.vouchNotPass();
          }
      });
      
      //审核通过
      $("#_auditPass").click(function() {
          var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId,14);
          if(lockWorkflowRe[0] == "false"){
              $.alert(lockWorkflowRe[1]);
              return;
          }
          
          if (!dealCommentTrue("auditPass")){
              return;
          }
          if($("#pigeonhole").size()>0 && $("#pigeonhole")[0].checked){
              var result = pigeonhole(null, null, null, null, null, "auditPassPigeonCallback");
          }else{
              auditPassAffterPigeon();
          }
          
      });
      
      
      //审核不通过
      $("#_auditNotPass").click(function() {
          var lockWorkflowRe = checkWorkflowLock(wfProcessId, currUserId);
          if(lockWorkflowRe[0] == "false"){
              $.alert(lockWorkflowRe[1]);
              return;
          }
          
          if (!dealCommentTrue("auditNotPass")){
              return;
          }
          if ($.content.callback.auditNotPass) {
              $.content.callback.auditNotPass();
          }
      });
      $("#pushMessageButton").click(function(){
        componentDiv.pushMessageToMembers(null,$('#comment_deal #pushMessageToMembers'),$('#comment_deal #pushMessage'));
      })
      //加签
     // $("#_dealAddNode,#_commonAddNode").click(addNode);
      $("#_dealAddNode",document).click(addNode);
      $("#_commonAddNode",document).click(addNode);
      //知会
      //$("#_dealAddInform,#_commonAddInform").click(addInformFunc);
      $("#_dealAddInform",document).click(addInformFunc);
      $("#_commonAddInform",document).click(addInformFunc);
      //当前会签
      //$("#_dealAssign,#_commonAssign").click(currentAssign);
      $("#_dealAssign",document).click(currentAssign);
      $("#_commonAssign",document).click(currentAssign);
      //减签
     // $("#_dealDeleteNode,#_commonDeleteNode").click(deleteNodeFunc);
      $("#_dealDeleteNode",document).click(deleteNodeFunc);
      $("#_commonDeleteNode",document).click(deleteNodeFunc);
      //回退
      //$("#_dealStepBack,#_commonStepBack").click(stepBackCallBack);
      $("#_dealStepBack",document).click(stepBackCallBack);
      $("#_commonStepBack",document).click(stepBackCallBack);
      //转发
      //$("#_dealForward,#_commonForward").click(dealForwardFunc);
      $("#_dealForward",document).click(dealForwardFunc);
      $("#_commonForward",document).click(dealForwardFunc);
      //终止
     // $("#_dealStepStop,#_commonStepStop,#_dealNotPass").click(stepStopFunc);
      $("#_dealStepStop",document).click(stepStopFunc);
      $("#_commonStepStop",document).click(stepStopFunc);
      $("#_dealNotPass",document).click(stepStopFunc);
      //撤销流程
      //$("#_dealCancel,#_commonCancel").click(dealCancelFunc);
      $("#_dealCancel",document).click(dealCancelFunc);
      $("#_commonCancel").click(dealCancelFunc);
      //修改附件
      //$("#_commonUpdateAtt,#_dealUpdateAttachment").click(modifyAttFunc);
       $("#_commonUpdateAtt",document).click(modifyAttFunc);
       $("#_dealUpdateAttachment",document).click(modifyAttFunc);
      //签章
     // $("#_commonSign,#_dealSign").click(openSignature);
      $("#_commonSign",document).click(openSignature);
      $("#_dealSign",document).click(openSignature);
      // 指定回退
      $("#_dealSpecifiesReturn",document).click(specifiesReturnFunc);
      //督办设置开始
     // $("#_commonSuperviseSet,#_dealSuperviseSet").click(superviseSetFunc);
      $("#_dealSuperviseSet",document).click(superviseSetFunc);
      $("#_commonSuperviseSet",document).click(superviseSetFunc);
      //督办设置结束
      //跟踪设置开始
      $("#trackRange_members").click(function(){
    	  $("#trackRange_members_textbox").show();
          $.selectPeople({
              type:'selectPeople'
              ,panels:'Department,Team,Post,Outworker,RelatePeople'
              ,selectType:'Member'
              ,text:$.i18n('common.default.selectPeople.value')
              ,hiddenPostOfDepartment:true
              ,hiddenRoleOfDepartment:true
              ,showFlowTypeRadio:false
              ,returnValueNeedType: false
              ,params:{
                 value: trackMember
              }
              ,targetWindow:window.top
              ,callback : function(res){
                  if(res && res.obj && res.obj.length>0){
                          $("#zdgzry").val(res.value);
                          $("#trackRange_members_textbox").show().val(res.text).attr("title", res.text);
                          var memberArray = res.value.split(',');
                          var memStr ="";
                          for(var i  = 0 ; i < memberArray.length ; i ++){
                          memStr += "Member|"+memberArray[i]+","
                      }
                      if(memStr.length > 0){
                        memStr = memStr.substring(0,memStr.length-1);
                       trackMember = memStr;
                      }
                      trackName(res);
                  } else {
                         
                  }
             }
          });
      });
      //跟踪设置结束
      //附件
      $('#uploadAttachmentID').click(function(){
          insertAttachmentPoi(commentId);
      });
      //关联文档
      $('#uploadRelDocID').click(function(){
          quoteDocument(commentId);
      });
      //常用语
      $("#cphrase").click(function(){
        showphrase($(this).attr("curUser"));
      });
      //意见隐藏 绑定点击事件，选中该checkbox弹出选人对话框
      $('#showToIdSpan').hide();
      $('#isHidden').click(function(){
          var showToIdSpan = $('#showToIdSpan');
          if($(this).attr('checked')){
              //显示选人界面
              showToIdSpan.show();
              showToIdSpan.removeClass("common_txtbox_dis");
              showToIdSpan.enable();
          }else{
              //隐藏选人界面
              showToIdSpan.hide();
              showToIdSpan.addClass("common_txtbox_dis");
              showToIdSpan.disable();
          }
      });

      //意见影藏结束
      $('#showToIdSpan').disable();
      
      //删除选人返回input中自带的样式
      $("#showToIdInput_txt").removeAttr("style");
      setButtonCanUseReady();
      
      setShowToIdDisplay();
      customTrackSet();
      
      //功能  add by libing
      setDealCommentChange();
    });
     //ready方法结束
    var isclickInput = false;
    var cursorPos=0;
    function setDealCommentChange(){
    	$("#content_deal_comment").on("keyup",function(e){
    		if(e.keyCode != 50){
    			return;
    		}
    		var cursorPosObj = getTextAreaPosition(this);
    		if(this.value.charAt(cursorPosObj.endPos-1) == '@'){
    			isclickInput = false;
    			cursorPos = cursorPosObj.endPos-1;
    			componentDiv.pushMessageToMembers2($("#dealMsgPush"));
    			//另输入框失去焦点,以免多次连续输入@
    			$("#content_deal_comment").trigger("blur");
    		}
    	});
    }
   
   /**
    * 修改textArea中的value
    */
   function addToTextArea(textAreaObj, addedValue){
	   if(textAreaObj == null){
		   textAreaObj = $("#content_deal_comment")[0];
	   }
       if(textAreaObj==null || addedValue==null){return;}
       var startPos = 0, endPos = 0;
       if (document.selection){//IE浏览器
    	   textAreaObj.value = textAreaObj.value.substring(0,cursorPos+1) + addedValue + textAreaObj.value.substring(cursorPos+1,textAreaObj.value.length);
       }else if(textAreaObj.selectionStart || textAreaObj.selectionStart == '0'){//火狐 浏览器
           //得到光标前的位置
           startPos = textAreaObj.selectionStart;
           //得到光标后的位置
           endPos = textAreaObj.selectionEnd;
           if (startPos == 0) {
        	   startPos = 1;
        	   endPos = 1;
           }
           // 在加入数据之前获得滚动条的高度 
           var restoreTop = textAreaObj.scrollTop, createCodeValue = textAreaObj.value; 
           textAreaObj.value = createCodeValue.substring(0, startPos) + addedValue + createCodeValue.substring(endPos, textAreaObj.value.length);
           //如果滚动条高度大于0
           if (restoreTop > 0) {
               textAreaObj.scrollTop = restoreTop;
           }
           textAreaObj.selectionStart = startPos + addedValue.length;
           textAreaObj.selectionEnd = endPos + addedValue.length;
       }  
   }

   /**
    * 获取textArea中光标的位置
    */
   function getTextAreaPosition(t){
       var startPos = 0, endPos = 0;
       if(t!=null){
          if (t.ownerDocument.selection) {
               t.focus();
               var ds = t.ownerDocument.selection;
               var range = ds.createRange();
               var stored_range = range.duplicate();
               stored_range.moveToElementText(t);
               stored_range.setEndPoint("EndToEnd", range);
               startPos = t.selectionStart = stored_range.text.length - range.text.length;
               endPos = t.selectionEnd = t.selectionStart + range.text.length;
               ds = range = null;
           } else if(t.selectionStart) {
               startPos = t.selectionStart;
               endPos = t.selectionEnd;
           } else {
               startPos = endPos = 0;
           }
       }
       return {"startPos":startPos, "endPos":endPos};
   }

   /**
    * 设置textArea光标的位置
    */
   function setTextAreaPosition(t,number){
       if(t==null || number==null){return;}
       selectTextAreaValue(t,number,number);
   }
   
   
    function customTrackSet(){
    	if("" == forTrackShowString &&  affairSubState != '13' && customSetTrackFlag){
    		$("#isTrack").click();
    		var trackRange = $( 'input:radio[name="trackRange"]');
    		trackRange.removeAttr( 'disabled' );
            //将‘全部’置为选中状态
            try{trackRange.get(0).checked = true ;}catch(e){}
            //改变<label>样式
            $( '#label_all' ).removeClass('disabled_color hand' );
            $( '#label_members' ).removeClass('disabled_color hand' );
    	}
    }
    
    function toggleTrackRange_members(){
  	  $("#trackRange_members").click();
    }
    
    //设置有默认意见隐藏不包括的人
    function setShowToIdDisplay() {
        if (displayIds != "") {
            $("#isHidden").attr("checked","true");
            //显示选人界面
            $("#showToIdSpan").show();
            $("#showToIdSpan").removeClass("common_txtbox_dis");
            $("#showToIdSpan").enable();
            $("#showToIdInput").val(displayIds);
            $("#showToIdInput_txt").val(displayNames);
            
            
        }
    }
    
    function setButtonCanUseReady(){
        //其他节点(待办),并发的两个节点，其中一个节点做了指定回退，另外一个的状态就是这个分支
        if(inInSpecialSB){
            setButtonCanUse('_concurrentBranch');
        }else if(state =='3' && (subState == "15" || subState == "16" || subState == "17")){
            setButtonCanUse(subState);
        }
    }
    
    function setButtonCanUse(subState){
        if(subState == "15"){
            // 指定回退
            //$("#_dealSpecifiesReturn").css("color","#ccc").disable();
            $("#_dealSpecifiesReturn").addClass("back_disable_color").disable();
            $("#_dealSpecifiesReturn_a").addClass("common_menu_dis").disable();
            //回退
            //$("#_dealStepBack,#_commonStepBack").css("color","#ccc").disable();
            $("#_dealStepBack,#_commonStepBack").addClass("back_disable_color").disable();
            $("#_dealStepBack_a,#_commonStepBack_a").addClass("common_menu_dis").disable();
            //提交 
            $("#_dealSubmit").addClass("back_disable_color").disable();
            //暂存待办
            $('#_dealSaveWait').addClass("back_disable_color").disable();
            //审核不通过
            $('#_auditNotPass').addClass("back_disable_color").disable();
            //终止
            //$("#_dealStepStop,#_commonStepStop").disable(); OA-43332
            //加签
            $("#_dealAddNode,#_commonAddNode").addClass("back_disable_color").disable();
            $("#_dealAddNode_a,#_commonAddNode_a").addClass("common_menu_dis").disable();
            //减签
            $("#_dealDeleteNode,#_commonDeleteNode").addClass("back_disable_color").disable();
            $("#_dealDeleteNode_a,#_commonDeleteNode_a").addClass("common_menu_dis").disable();
            //当前会签
            $("#_dealAssign,#_commonAssign").addClass("back_disable_color").disable();
            $("#_dealAssign_a,#_commonAssign_a").addClass("common_menu_dis").disable();//基本操作
            //知会
            $("#_dealAddInform,#_commonAddInform").addClass("back_disable_color").disable();
            $("#_dealAddInform_a,#_commonAddInform_a").addClass("common_menu_dis").disable();
            //签章
            $("#_dealSign").addClass("back_disable_color").disable();
            $("#_commonSign_a,#_dealSign_a").addClass("common_menu_dis").disable();
            //督办设置
            $("#_dealSuperviseSet").addClass("back_disable_color").disable();
            $("#_dealSuperviseSet_a,#_commonSuperviseSet_a").addClass("common_menu_dis").disable();
             //修改正文
             $('#_commonEditContent,#_dealEditContent').addClass("back_disable_color").disable();
             $('#_commonEditContent_a,#_dealEditContent_a').addClass("common_menu_dis").disable();
             //修改附件
             $("#_commonUpdateAtt,#_dealUpdateAttachment").addClass("back_disable_color").disable();
             $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").addClass("common_menu_dis").disable();
             //消息推送 
             $("#pushMessageButton").addClass("common_menu_dis").disable();
             $("#pushMessageButtonSpan").addClass("color_gray").disable();
             //意见隐藏
             $("#isHidden").disable();
             $("#isHiddenLable").addClass("color_gray").disable();
             //跟踪
             $("#isTrack").disable();
             $("#isTrackLable").addClass("color_gray").disable();
             //处理后归档
             $("#pigeonhole").disable();
             $("#pigeonholeLable").addClass("color_gray").disable();
             $("#_auditPass").disable();
             $("#_auditNotPass").disable();
             $("#_dealPass1").disable();
        }else if(subState == "16"){
            // 指定回退
            //$("#_dealSpecifiesReturn").disable();
            //$("#_dealSpecifiesReturn_a").disable();
            //回退
            $("#_dealStepBack,#_commonStepBack").addClass("back_disable_color").disable();
            $("#_dealStepBack_a,#_commonStepBack_a").addClass("common_menu_dis").disable();
            //暂存待办
            $('#_dealSaveWait').addClass("back_disable_color").disable();
            //审核不通过
            $('#_auditNotPass').addClass("back_disable_color").disable();
            
            //取回(待办下无此操作)
            //加签
            $("#_dealAddNode,#_commonAddNode").addClass("back_disable_color").disable();
            $("#_dealAddNode_a,#_commonAddNode_a").addClass("common_menu_dis").disable();
            //减签
            $("#_dealDeleteNode,#_commonDeleteNode").addClass("back_disable_color").disable();
            $("#_dealDeleteNode_a,#_commonDeleteNode_a").addClass("common_menu_dis").disable();
            //当前会签
            $("#_dealAssign,#_commonAssign").addClass("back_disable_color").disable();
            $("#_dealAssign_a,#_commonAssign_a").addClass("common_menu_dis").disable();
            //知会
            $("#_dealAddInform,#_commonAddInform").addClass("back_disable_color").disable();
            $("#_dealAddInform_a,#_commonAddInform_a").addClass("common_menu_dis").disable();
        }else if(subState == "17"){
            //修改正文
            $('#_commonEditContent,#_dealEditContent').addClass("back_disable_color").disable();
            $('#_commonEditContent_a,#_dealEditContent_a').addClass("common_menu_dis").disable();
            //签章
            $("#_dealSign").addClass("back_disable_color").disable();
            $("#_commonSign_a,#_dealSign_a").addClass("common_menu_dis").disable();
            //督办设置
            $("#_dealSuperviseSet").addClass("back_disable_color").disable();
            $("#_dealSuperviseSet_a,#_commonSuperviseSet_a").addClass("common_menu_dis").disable();
            //修改附件
            $("#_commonUpdateAtt,#_dealUpdateAttachment").addClass("back_disable_color").disable();
            $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").addClass("common_menu_dis").disable();
            // 指定回退
            $("#_dealSpecifiesReturn").addClass("back_disable_color").disable();
            $("#_dealSpecifiesReturn_a").addClass("common_menu_dis").disable();
            //回退
            $("#_dealStepBack,#_commonStepBack").addClass("back_disable_color").disable();
            $("#_dealStepBack_a,#_commonStepBack_a").addClass("common_menu_dis").disable();
            //暂存待办
            $('#_dealSaveWait').addClass("back_disable_color").disable();
            //审核不通过
            $('#_auditNotPass').addClass("back_disable_color").disable();
            //取回(待办下无此操作)
            //加签
            $("#_dealAddNode,#_commonAddNode").addClass("back_disable_color").disable();
            $("#_dealAddNode_a,#_commonAddNode_a").addClass("common_menu_dis").disable();
            //减签
            $("#_dealDeleteNode,#_commonDeleteNode").addClass("back_disable_color").disable();
            $("#_dealDeleteNode_a,#_commonDeleteNode_a").addClass("common_menu_dis").disable();
            //当前会签
            $("#_dealAssign,#_commonAssign").addClass("back_disable_color").disable();
            $("#_dealAssign_a,#_commonAssign_a").addClass("common_menu_dis").disable();
            //知会
            $("#_dealAddInform,#_commonAddInform").addClass("back_disable_color").disable();
            $("#_dealAddInform_a,#_commonAddInform_a").addClass("common_menu_dis").disable();
            //消息推送 
             $("#pushMessageButton").disable();
             $("#pushMessageButtonSpan").addClass("color_gray").disable();
            //意见隐藏
             $("#isHidden").disable();
             $("#isHiddenLable").addClass("color_gray").disable();
             //跟踪
             $("#isTrack").disable();
             $("#isTrackLable").addClass("color_gray").disable();
             //处理后归档
             $("#pigeonhole").disable();
             $("#pigeonholeLable").addClass("color_gray").disable();
             //提交
             $("#_dealSubmit").addClass("back_disable_color").disable();
        }else if(subState =='_concurrentBranch'){
            // 指定回退
            $("#_dealSpecifiesReturn").addClass("back_disable_color").disable();
            $("#_dealSpecifiesReturn_a").addClass("common_menu_dis").disable();
            //回退
            $("#_dealStepBack,#_commonStepBack").addClass("back_disable_color").disable();
            $("#_dealStepBack_a,#_commonStepBack_a").addClass("common_menu_dis").disable();
            $("#_auditNotPass").disable();
            $("#_vouchNotPass").disable();
        }
    }
    
    //展示常用语
    function showphrase(str) {
        var callerResponder = new CallerResponder();
        //实例化Spring BS对象
        var pManager = new phraseManager();
        /** 异步调用 */
        var phraseBean = [];
        pManager.findCommonPhraseById({
            success : function(phraseBean) {
                  var phrasecontent = [];
                  var phrasepersonal = [];
                  for (var count = 0; count < phraseBean.length; count++) {
                      phrasecontent.push(phraseBean[count].content);
                      if (phraseBean[count].memberId == str && phraseBean[count].type == "0") {
                          phrasepersonal.push(phraseBean[count]);
                      }
                  }
                  $("#cphrase").comLanguage({
                      textboxID : "content_deal_comment",
                      data : phrasecontent,
                      newBtnHandler : function(phraseper) {
                          $.dialog({
                              url : _ctxPath + '/phrase/phrase.do?method=gotolistpage',
                              transParams : phrasepersonal,
                              targetWindow:top,
                              title : $.i18n('collaboration.sys.js.cyy')
                          });
                      }
                  });
                },
                error : function(request, settings, e) {
                    $.alert(e);
                }
          });
    }
    
    //流程说明
    function colShowNodeExplain() {
        var rv = "";
        try {
            var colManagerAjax = new colManager();
            var params = new Object();
            params["affairId"] =  affairId;
            params["templeteId"] =  templeteId;
            params["processId"] =  processId;
            colManagerAjax.getDealExplain(params,{
                success : function (data) {
                    rv = data;
                    if(rv =='undefined') {
                        rv ="";
                    }
                    var intro = document.getElementById("nodeExplainDiv") ;
                    var nodeExplainTd = document.getElementById("nodeExplainTd") ;
                    nodeExplainTd.innerHTML = rv;
                    intro.style.display = "block";
                }
            });
        }catch (ex1) {}
    }
    
    //关闭流程说明
    function hiddenNodeIntroduction() {
        var intro = document.getElementById("nodeExplainDiv") ;
        intro.style.display = "none";
    }
    
    //判断意见是否为空
    function dealCommentTrue(action){
        //节点权限和意见，如果节点权限选择了意见必填或不同意必填意见，添加校验
        if($.trim($("#content_deal_comment").val()) === ""){
        	//vouchPass-核定通过;vouchNotPass-核定不通过;auditPass-审核通过;auditNotPass-审核不通过;stepStop-终止;
        	//comDeal-处理归档;specifiesReturn-指定回退;stepBack-回退;dealCancel-撤销流程;dealPass1-新闻公告审核
        	var isPass = $("#canDeleteORarchive").val() === "true" //处理时必须填写意见 
        		||($("#disAgreeOpinionPolicy").val() === "1" && $("#notagree").is(":checked"))//不同意时必须填写意见 
        		||($("#cancelOpinionPolicy").val() === "1" && (action=="specifiesReturn" || action== "stepBack" || action== "stepStop" || action== "dealCancel"))//撤销/回退/终止时必须填写意见 
        	if(isPass){//不同意必填
        		 $.alert($.i18n('collaboration.common.deafult.dealCommentNotNull'));
             return false;
        	}
        }
        return true;
    }
    function checkYozo(){
    	var isYozoWps = false;
    	if(bodyType && (bodyType == "43" || bodyType == "44")){
    		isYozoWps = true;
    	}
        var isYoZoOffice = parent.isYoZoOffice();
        if(isYozoWps && isYoZoOffice){
     	   //对不起，您本地的永中office软件不支持对当前正文格式的此操作！
     	   $.alert($.i18n('collaboration.alertWpsYozoOffice_modify'));
     	   return true;
        }
        return false;
    }
    //修改正文开始
    var modifyFlag = 0;
    function editContentFunc(){
       //修改HTML正文的时候判断是否有印章，有印章的时候不让修改
        var bodyType = $("#bodyType").val();
        //永中office不支持wps正文修改
    	var isYozoWps = checkYozo(bodyType);
    	if(isYozoWps){
    		return;
    	}
        if(bodyType == "10"){
        	 var zwIframeObj;
	   	   	 if($.browser.mozilla){
	   	   		zwIframeObj =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	   	   	 }else{
	   	   		zwIframeObj =$(window.componentDiv)[0].document.zwIframe;
	   	   	 }
            var mLength=zwIframeObj.$("#iHtmlSignature").length; 
            if(mLength>0){
                $.alert($.i18n("collaboration.alert.CantModifyBecauseOfIsignature"));
                return false;
            }
        }
        // 指定回退状态
        if(isSpecifiesBack())return;
        // if(bodyType>40 && bodyType<=45){
        //     if(componentDiv.getSignatureCount()>0){
        //         $.alert($.i18n("collaboration.common.default.signatureIsSave")); //已经签章,不允许修改！
        //         return;
        //     }
        // }
        updateContent();
    }
    
     //修改正文内容
    function updateContent(){
    	/*if( bodyType != '10'){
    		$.alert($.i18n('collaboration.summary.label.chooseIe'));
    		return;
    	}*/
        //添加正文锁
        var lockWorkflowRe = lockWorkflow(summaryId, currUserId, 15);
        if(lockWorkflowRe[0] == "false"){
            $.alert(lockWorkflowRe[1]);
            return;
        }
        //var fnx =$(window.componentDiv)[0];
        //var zwIframeObj = fnx.document.zwIframe;
        
        var zwIframeObj;
	   	 if($.browser.mozilla){
	   		zwIframeObj =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	   	 }else{
	   		zwIframeObj =$(window.componentDiv)[0].document.zwIframe;
	   	 }
        
        //获取正文内容
        var viewStateold = zwIframeObj.$("#viewState").val();
        zwIframeObj.$("#viewState").val("1");
        var curContent = zwIframeObj.$.content.getContent();
        //if($.browser.msie && ($.browser.version=='7.0' || $.browser.version=='8.0')){
        getA8Top().updataContentOBJ = [window,curContent];
        //alert(getA8Top().updataContentOBJ);
        //}
        zwIframeObj.$("#viewState").val(viewStateold);
        if(bodyType == '10'){
            var url = _ctxPath + "/collaboration/collaboration.do?method=updateContentPage&summaryId="+summaryId;
            var title = $.i18n('collaboration.nodePerm.editContent.label');
            var width = $(getA8Top().document).width() - 100;
            var height = $(getA8Top().document).height() - 50;
            var _updateDialog = $.dialog({
                  url: url,
                  width: width,
                  height: height,
                  title: title,
                  id:'dialogUpdate',
                  transParams:[window,curContent],
                  targetWindow:getCtpTop(),
                  closeParam:{
                      show:true,
                      autoClose:false,
                      handler:function(){
                          var confirm = $.confirm({
                              'msg':$.i18n('collaboration.common.confirmleave'),
                              ok_fn: function () {
                                  _updateDialog.close();
                              },
                              cancel_fn:function(){
                              }
                          });
                  }}
           });
       } else {
    	   
           document.getElementById("modifyFlag").value="1";
         //防止点击其他按钮后控件外层div的style="width:0px;height:0px;overflow:hidden; position: absolute;"导致全屏控件被关闭后无法加载
    	   $(zwIframeObj)[0].$("#officeFrameDiv").attr("style","display:none;height:100%");
           $(zwIframeObj)[0].$("#officeTransIframe").remove();
           $(zwIframeObj)[0].$("#officeFrameDiv").show();
           $(zwIframeObj)[0].checkOpenState();
           $(zwIframeObj)[0].ModifyContent();
           $(zwIframeObj)[0].fullSize();
       }
       summaryChange();
       //设置正文为编辑状态
       zwIframeObj.$("#viewState").val("1");
    }
    
    function setFlagto1(){
        // 标记协同内容有变化，关闭页面时需进行判断
        summaryChange();
        document.getElementById("modifyFlag").value="1";
    }
    function setFlagto0(){
        document.getElementById("modifyFlag").value="0";
    }
    //加签
    function addNode(){
    	//js事件接口
    	var sendDevelop = $.ctp.trigger('beforeDealaddnode');
    	  if(!sendDevelop){
    		 return;
    	  }
    	
        // 指定回退状态
        var isForm = bodyType=='20';
        insertNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId,moduleTypeName,
            isForm,'collaboration',flowPermAccountId,refreshWorkflow,summaryId,affairId,isTemplete);
     }
    //当前会签
    function currentAssign() {
        // 指定回退状态
        //if(isSpecifiesReturn())return;
        var isForm = bodyType=='20'; 
        assignNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId, moduleTypeName,
                isForm, nodePolicy, flowPermAccountId,refreshWorkflow,
                summaryId,affairId);
    }
    
    //减签
    function deleteNodeFunc() {
    	//js事件接口
    	var sendDevelop = $.ctp.trigger('beforeDealdeletenode');
  	    if(!sendDevelop){
  		 	return;
  	  	}
    	
        // 指定回退状态
        //if(isSpecifiesReturn())return;
        isWorkflowChange=false;//点了加签 直接点 减签  弹出离开提示 bug 修复 
        deleteNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId, refreshWorkflow,
                summaryId,affairId);
    }
    
    //知会
    function addInformFunc(){
        // 指定回退状态
        //if(isSpecifiesReturn())return;
        var isForm = bodyType=='20';
        informNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId, moduleTypeName,
                isForm, 'collaboration', currLoginAccount,refreshWorkflow,
                summaryId,affairId);
    }
    //修改附件
    function modifyAttFunc(){
        // 指定回退状态
        if(isSpecifiesBack())return;
        updateAtt(processId,summaryId);
    }
    //终止
    function stepStopFunc(){
    	//js事件接口
    	var sendDevelop = $.ctp.trigger('beforeDealstepstop');
  	  	if(!sendDevelop){
  		 	return;
  	  	}
    	
        disableOperation();
        if (!dealCommentTrue("stepStop")){
            enableOperation();
            setButtonCanUseReady();
            return;
        }
        if ($.content.callback.dealStepStop) {
           $.content.callback.dealStepStop();
        }
    }
    
    //撤销流程
    function dealCancelFunc(){
    	 //js事件接口
    	 var sendDevelop = $.ctp.trigger('beforeDealCancel');
    	  if(!sendDevelop){
    		 return;
    	  }
    	
        disableOperation();
        if ($.content.callback.dealCancel) {
            $.content.callback.dealCancel();
        }
    }

    //转发
    function dealForwardFunc() {
        if ($.content.callback.dealForward) {
            $.content.callback.dealForward();
        }
    }
    
    //转事件
    function transformFunc(){
        AddCalEvent("",affairId,collEnumKey,"",forwardEventSubject);
    }
    //督办设置开始
    function superviseSetFunc(){
        if(isSpecifiesBack())return;
        openSuperviseWindow('1',false,summaryId,templeteId,null,startMemberId);
    }
    //指定回退
    function specifiesReturnFunc() {
    	//js事件接口
    	var sendDevelop = $.ctp.trigger('beforeDealspecifiesReturn');
    	if(!sendDevelop){
    		 return;
    	}
    	
        disableOperation();
        if ($.content.callback.specifiesReturnFunc) {
            $.content.callback.specifiesReturnFunc();
        }
    }
    
    // 是否是指定回退
    function isSpecifiesReturn(type){
        // type === 1表示被回退者不限制
        if(!type || type === 1){
            if(subState == "15" || subState == "17"){
                $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
                enableOperation();
                setButtonCanUseReady();
                return true;
            }
        }
        if(!type){
            if(subState == "16" || subState == "17"){
                $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
                enableOperation();
                setButtonCanUseReady();
                return true;
            }
        }
        return false;
    }
    //是否指定回退被回退者
    function isSpecifiesBacked(){
        if(subState == "16"){
            $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
            enableOperation();
            setButtonCanUseReady();
            return true;
        }
    }
    //是否指定回退者
    function isSpecifiesBack(){
        if(subState == "15" || subState == "17"){
            $.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
            enableOperation();
            setButtonCanUseReady();
            return true;
        }
    }
    
    function comDealSubmit() {
        if (!dealCommentTrue("comDeal")){
            enableOperation();
            setButtonCanUseReady();
            return;
        }
        $("#pigeonholeValue").val("");
        if($("#pigeonhole").size()>0 && $("#pigeonhole")[0].checked){
            var result = pigeonhole(null, null, null, null, null, "comDealSubmitPigeonCallback");
        }else{
            comDealSubmitAffterPigeon();
        }
    }
    
    /**
     * 提交归档回调函数
     * @returns
     */
    function comDealSubmitPigeonCallback(result){
        if(result && result === "cancel"){
            enableOperation();
            setButtonCanUseReady();
            return;
        }
        $("#pigeonholeValue").val(result);
        comDealSubmitAffterPigeon();
    }
    
    function praiseToSummary(){
    	if($("#praiseToObj").hasClass("no_like_16")){ 
    		$("#praiseToObj").removeClass("no_like_16").addClass("like_16");
    		$("#praiseToObj")[0].title=_praisedealCa;
    		$("#praiseInput").val(1);
    	}else{
    		$("#praiseToObj").removeClass("like_16").addClass("no_like_16");
    		$("#praiseToObj")[0].title=_praisedeal;
    		$("#praiseInput").val(0);
    	}
    }
    
    /**
     * comDealSubmit在归档后执行的方法
     * @returns
     */
    function comDealSubmitAffterPigeon(){
        if ($.content.callback.dealSubmit) {
            $.content.callback.dealSubmit();
        }
    }
    
    $(document).bind('keydown', 'esc',function (evt){
        enableOperation();
    });
    
    //截取跟踪指定人长度
    function trackName(res){
    	var userName="";
    	var nameSprit="";
    	if(res.obj.length>0){
      	for(var co = 0 ; co<res.obj.length ; co ++){
    	   userName+=res.obj[co].name+",";
    	}
      	userName=userName.substring(0,userName.length-1);
      	//只显示前三个名字
      	nameSprit=userName.split(",");
      	if(nameSprit.length>3){
      		nameSprit=userName.split(",", 3);
      	}
      	$("#zdgzryName").attr("title",userName);
    	var partText = document.getElementById("zdgzryName");
    	partText.style.display="";
    	 $("#zdgzryName").val(nameSprit+"...");
     }
    }