    //记录是否进行了正文修改
	var contentUpdate=false;
	var changeWord = false ;//正文修改，主要用于区别套红 签章操作与修改正文
  var hasTaohong = false;//套红记录
  var changeSignature = false ;//签章
  var SignatureCount = 0;//有效签章个数
  var extendArray = new Array();
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
        for(var i =0;i<nodePerm_baseActionList.length;i++){
        	if(nodePerm_baseActionList[i]==="FaDistribute"){
        		$("#fenfadanwei").show();
        	}
        }
        //控制常用按钮在工具栏中显示或隐藏
        function showBarsFunc() {
        	//toolbarStr[toolbarStr.length]=buildBarStr("_dealSpecifiesReturn",$.i18n('collaboration.default.stepBack'),"forward_event_16",specifiesReturnFunc);
            for(var i=0;i<barNum;i++){
                  switch($("#tool_"+(i+1)).val()){
                     case '_commonAddNode'://加签
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonAddNode",$.i18n('collaboration.nodePerm.insertPeople.label'),"signature_16",addNode);
                         break;
                     case '_commonMoreSign'://多级会签
                	     toolbarStr[toolbarStr.length]=buildBarStr("_commonMoreSign","多级会签","multilevel_sign_16",moreSignNew);
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
/*新公文不需要修改文单                     case "_commonEditContent"://修改正文
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonEditContent",$.i18n('collaboration.nodePerm.editContent.label'),"modify_text_16",editContentFunc);
                       break;*/
                     case "_commonUpdateAtt"://修改附件
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonUpdateAtt",$.i18n('collaboration.nodePerm.allowUpdateAttachment'),"editor_16",modifyAttFunc);
                       break;
                     case "_commonStepStop"://终止
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonStepStop",$.i18n('collaboration.nodePerm.stepStop.label'),"termination_16",stepStopFunc);
                       break;
                     case "_commonCancel"://撤销
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonCancel",$.i18n('collaboration.nodePerm.repeal.label'),"revoked_process_16",dealCancelFunc);
                       break;
                     case "_commonSign"://签章
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonSign",$.i18n('collaboration.nodePerm.edocSign.label'),"signa_16",openSignature);
                       break;
                     case "_commonTransform"://转事件
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonTransform",$.i18n('collaboration.nodePerm.TransformEvent.label'),"forward_event_16",transformFunc);
                       break;
                     case "_commonSuperviseSet"://督办设置
                         toolbarStr[toolbarStr.length]=buildBarStr("_commonSuperviseSet",$.i18n('collaboration.nodePerm.superviseOperation.label'),"setting_16",superviseSetFunc);
                       break;
                     case "_commonFaDistribute": //发文分发
                    	 $("#fenfadanwei").show();
                       break;
                     case "_dealSpecifiesReturn"://指定回退
                         toolbarStr[toolbarStr.length]=buildBarStr("_dealSpecifiesReturn",$.i18n('collaboration.default.stepBack'),"specify_fallback_16",specifiesReturnFunc);
                       break;
                     case "_distribute"://分办  xiex
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_distribute",$.i18n('collaboration.default.distribute'),"plan_totask_16",distributeFunc);
                    	 break;
                     case "_jointlyIssued"://联合发文
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_jointlyIssued",$.i18n('permission.operation.JointlyIssued'),"check_group_16",_jointlyIssued);
                    	 break;
                     case "_commonEdit"://修改公文正文 Edit  yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonEdit",$.i18n('collaboration.nodePerm.editContent.label'),"modify_text_16",editGovdocContentFunc);
                    	 break;
                     case "_commonEdocTemplate"://正文套红  EdocTemplate yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonEdocTemplate",$.i18n('collaboration.nodePerm.EdocTemplate.label'),"body_red_16",govdocContentTaohong);
                    	 break;
                     case "_commonScriptTemplate"://文单套红  ScriptTemplate yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonScriptTemplate",$.i18n('collaboration.nodePerm.ScriptTemplate.label'),"wen_single_red_16",govdocFormTaohong);
                    	 break;
                     case "_commonTanstoPDF"://WORD转PDF  TanstoPDF yf 生成版式
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonTanstoPDF",$.i18n('collaboration.nodePerm.TanstoPDF.label'),"word_to_pdf_16",govdocConvertToPdf);
                   	 break;
                     case "_commonTransToOfd"://正文转OFD  TanstoOFD 生成ofd版式
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonTransToOfd",$.i18n('collaboration.nodePerm.TransToOFD.label'),"word_to_pdf_16",govdocConvertToOfd);
                    	 break;
                     case "_commonContentSign"://正文盖章 ContentSign yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonContentSign",$.i18n('collaboration.nodePerm.ContentSign.label'),"signa_16",openGovdocSignature);
                    	 break;
                     case "_commonHtmlSign"://文单签批  HtmlSign yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonHtmlSign",$.i18n('collaboration.nodePerm.HtmlSign.label'),"wen_shan_issuing_16",htmlSignFunc);
                    	 break;
                     case "_commonPDFSign"://全文签批  PDFSign yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonPDFSign",$.i18n('collaboration.nodePerm.PDFSign.label'),"wen_shan_issuing_16",readyToPDF);
                    	 break;
                     case "_commonSignChange"://签批缩放  SignChange yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonSignChange",$.i18n('collaboration.nodePerm.SignChange.label'),"data_task_16",signZoom);
                    	 break;
                     case "_commonTransmitBulletin"://转公告  TransmitBulletin yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonTransmitBulletin",$.i18n('collaboration.nodePerm.TransmitBulletin.label'),"transfer_bulletin_16",dealTransmitBulletin);
                    	 break;
                     case "_commonPassRead"://传阅  PassRead yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonPassRead",$.i18n('collaboration.nodePerm.PassRead.label'),"circulated_16",passReadFunc);
                    	 break;
                     case "_commonTurnRecEdoc"://转收文  TurnRecEdoc yf
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonTurnRecEdoc",$.i18n('collaboration.nodePerm.TurnRecEdoc.label'),"turn_agenda_16",turnRecEdocFunc);
                    	 break;
                     case "_commonTranstoSupervise":
                    	 toolbarStr[toolbarStr.length]=buildBarStr("_commonTranstoSupervise",$.i18n('permission.operation.TranstoSupervise'),"setting_16",transtoSuperviseFunc);
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

                      //if(canModifyWorkFlow == 'true' || (canModifyWorkFlow == 'false' && startMemberId == affairMemberId)){
                	  if(canModifyWorkFlow == 'true') {
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

                      if (nodePerm_advanceActionList[i] === 'FaDistribute') {
                          //分发
                    	  $("#fenfadanwei").show();
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
/*  新公文不需要修改文单                    if ((nodePerm_advanceActionList[i] === 'UpdateForm') && (bodyType != '20') &&  (bodyType != '45')) {
                          //修改正文
                          _menuSimpleData.push({
                              id:"_dealEditContent",
                              name: $.i18n('collaboration.nodePerm.editContent.label'),
                              className:"modify_text_16",
                              customAttr:" advanceAction='Edit' class='nodePerm'"
                          });
                      }*/
                      if(canEditAttachment == 'true' || (canEditAttachment == 'false' && startMemberId == affairMemberId)){
	                      if (nodePerm_advanceActionList[i] === 'allowUpdateAttachment') {
	                          //修改附件
	                          _menuSimpleData.push({
	                              id:"_dealUpdateAttachment",
	                              name: $.i18n('collaboration.nodePerm.allowUpdateAttachment'),
	                              className:"editor_16",
	                              customAttr:" advanceAction='allowUpdateAttachment' class='nodePerm'"
	                          });
	                      }
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
                      if (nodePerm_advanceActionList[i] === 'Sign' && bodyType != '45') {
                          //签章
                          _menuSimpleData.push({
                              id:"_dealSign",
                              name: $.i18n('collaboration.nodePerm.edocSign.label'),
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
                      if (nodePerm_advanceActionList[i] === 'TranstoSupervise') {
                          //转督办
                          _menuSimpleData.push({
                              id:"_dealTranstoSupervise",
                              name: $.i18n('permission.operation.TranstoSupervise'),
                              className:"setting_16",
                              customAttr:" advanceAction='TranstoSupervise' class='nodePerm'"
                          });
                      }
                      if (nodePerm_advanceActionList[i] === 'SpecifiesReturn') {
                          _menuSimpleData.push({
                              id:"_dealSpecifiesReturn",
                              name: $.i18n('collaboration.default.stepBack'),
                              className:"specify_fallback_16",
                              customAttr:" advanceAction='SpecifiesReturn' class='nodePerm'"
                          });
                      }
                    //分办  xiex
                      if (nodePerm_advanceActionList[i] === 'Distribute') {
                    	  _menuSimpleData.push({
                    		  id:"_distribute",
                    		  name: $.i18n('collaboration.default.distribute'),
                    		  className:"plan_totask_16",
                    		  customAttr:" advanceAction='SpecifiesReturn' class='nodePerm'"
                    	  });
                      }
                    //联合发文
                      if (nodePerm_advanceActionList[i] === 'JointlyIssued') {
                    	  _menuSimpleData.push({
                    		  id:"_jointlyIssued",
                    		  name: $.i18n('permission.operation.JointlyIssued'),
                    		  className:"check_group_16",
                    		  customAttr:" advanceAction='SpecifiesReturn' class='nodePerm'"
                    	  });
                      }
                      //修改正文  Edit
                      if (nodePerm_advanceActionList[i] === 'Edit') {
                    	  _menuSimpleData.push({
                    		  id:"_dealEdit",
                    		  name: $.i18n('collaboration.nodePerm.editContent.label'),
                    		  className:"modify_text_16",
                    		  customAttr:" advanceAction='Edit' class='nodePerm'"
                    	  });
                      }
                      //正文套红  EdocTemplate
                      if (nodePerm_advanceActionList[i] === 'EdocTemplate') {
                    	  _menuSimpleData.push({
                    		  id:"_dealEdocTemplate",
                    		  name: $.i18n('collaboration.nodePerm.EdocTemplate.label'),
                    		  className:"body_red_16",
                    		  customAttr:" advanceAction='EdocTemplate' class='nodePerm'"
                    	  });
                      }
                      //文单套红  ScriptTemplate
                      if (nodePerm_advanceActionList[i] === 'ScriptTemplate') {
                    	  _menuSimpleData.push({
                    		  id:"_dealScriptTemplate",
                    		  name: $.i18n('collaboration.nodePerm.ScriptTemplate.label'),
                    		  className:"wen_single_red_16",
                    		  customAttr:" advanceAction='ScriptTemplate' class='nodePerm'"
                    	  });
                      }
                      //WORD转PDF  TanstoPDF
                      if (nodePerm_advanceActionList[i] === 'TanstoPDF') {
                    	  _menuSimpleData.push({
                    		  id:"_dealTanstoPDF",
                    		  name: $.i18n('collaboration.nodePerm.TanstoPDF.label'),
                    		  className:"word_to_pdf_16",
                    		  customAttr:" advanceAction='TanstoPDF' class='nodePerm'"
                    	  });
                      }
                    //WORD转OFD  TransToOfd
                      if (nodePerm_advanceActionList[i] === 'TransToOfd') {
                    	  _menuSimpleData.push({
                    		  id:"_dealTransToOfd",
                    		  name: $.i18n('collaboration.nodePerm.TransToOFD.label'),
                    		  className:"word_to_pdf_16",
                    		  customAttr:" advanceAction='TanstoOfd' class='nodePerm'"
                    	  });
                      }
                      //正文盖章ContentSign
                      if (nodePerm_advanceActionList[i] === 'ContentSign') {
                    	  _menuSimpleData.push({
                    		  id:"_dealContentSign",
                    		  name: $.i18n('collaboration.nodePerm.ContentSign.label'),
                    		  className:"signa_16",
                    		  customAttr:" advanceAction='ContentSign' class='nodePerm'"
                    	  });
                      }
                      //文单签批  HtmlSign
                      if (nodePerm_advanceActionList[i] === 'HtmlSign') {
                    	  _menuSimpleData.push({
                    		  id:"_dealHtmlSign",
                    		  name: $.i18n('collaboration.nodePerm.HtmlSign.label'),
                    		  className:"wen_shan_issuing_16",
                    		  customAttr:" advanceAction='HtmlSign' class='nodePerm'"
                    	  });
                      }


                      //全文签批  PDFSign yf
                      if (nodePerm_advanceActionList[i] === 'PDFSign') {
                    	  _menuSimpleData.push({
                    		  id:"_dealPDFSign",
                    		  name: $.i18n('collaboration.nodePerm.PDFSign.label'),
                    		  className:"wen_shan_issuing_16",
                    		  customAttr:" advanceAction='PDFSign' class='nodePerm'"
                    	  });
                      }

                      //签批缩放  SignChange yf
                      if (nodePerm_advanceActionList[i] === 'SignChange') {
                    	  _menuSimpleData.push({
                    		  id:"_dealSignChange",
                    		  name: $.i18n('collaboration.nodePerm.SignChange.label'),
                    		  className:"data_task_16",
                    		  customAttr:" advanceAction='SignChange' class='nodePerm'"
                    	  });
                      }

                    //转公告  TransmitBulletin yf
                      if (nodePerm_advanceActionList[i] === 'TransmitBulletin') {
                    	  _menuSimpleData.push({
                    		  id:"_dealTransmitBulletin",
                    		  name: $.i18n('collaboration.nodePerm.TransmitBulletin.label'),
                    		  className:"transfer_bulletin_16",
                    		  customAttr:" advanceAction='TransmitBulletin' class='nodePerm'"
                    	  });
                      }

                    //传阅  PassRead yf
                      if (nodePerm_advanceActionList[i] === 'PassRead') {
                    	  _menuSimpleData.push({
                    		  id:"_dealPassRead",
                    		  name: $.i18n('collaboration.nodePerm.PassRead.label'),
                    		  className:"circulated_16",
                    		  customAttr:" advanceAction='PassRead' class='nodePerm'"
                    	  });
                      }
                      //多级会签
                      if (nodePerm_advanceActionList[i] === 'moreSign') {
                    	  _menuSimpleData.push({
                    		  id:"_dealMoreSign",
                    		  name: "多级会签",
                    		  className:"multilevel_sign_16",
                    		  customAttr:" advanceAction='moreSign' class='nodePerm'"
                    	  });
                      }
                    //转收文  TurnRecEdoc yf
                      if (nodePerm_advanceActionList[i] === 'TurnRecEdoc') {
                    	  _menuSimpleData.push({
                    		  id:"_dealTurnRecEdoc",
                    		  name: $.i18n('collaboration.nodePerm.TurnRecEdoc.label'),
                    		  className:"turn_agenda_16",
                    		  customAttr:" advanceAction='TurnRecEdoc' class='nodePerm'"
                    	  });
                      }
                  }
              }
             if(_menuSimpleData.length > 0){
            	 $("#moreLabel").menuSimple({
                     width:100,
                     direction:"BR",
                     offsetLeft:-10,
                     offsetButtom:-15,
                     data: _menuSimpleData
                 });
             }else{
            	 $('#moreLabel').remove();
             }
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
    //数组去重
    Array.prototype.myUnique = function()
    {
    	var n = [this[0]]; //结果数组
    	for(var i = 1; i < this.length; i++) //从第二项开始遍历
    	{
    		//如果当前数组的第i项在当前数组中第一次出现的位置不是i，
    		//那么表示第i项是重复的，忽略掉。否则存入结果数组
    		if (this.indexOf(this[i]) == i) n.push(this[i]);
    	}
    	return n;
    }
    function filterOrg(val){
    	val = val.replaceAll("ExchangeAccount\\|","");
    	val = val.replaceAll("Account\\|","");
    	val = val.replaceAll("Department\\|","");
    	val = val.replaceAll("OrgTeam\\|","");
    	return val;
    }
    String.prototype.replaceAll = function(s1,s2){
    	return this.replace(new RegExp(s1,"gm"),s2);
    	}

    //点击确认或者暂存待办前，把文单中意见处理框的值传递到此页面  zhangdong 20170329 start
    function beforeSubmitButton(){
      var zwIframe = componentDiv.zwIframe;
      //意见态度
      var childrenPageAttitude = zwIframe.document.getElementsByName("attitude");
      if(childrenPageAttitude){
          for(var i=0;i<childrenPageAttitude.length;i++){
             if(childrenPageAttitude[i].checked==true){
            	 document.getElementsByName("attitude")[i].checked=true;
             }
          }
      }

      //意见处理
      if(zwIframe.document.getElementById("contentOP")){
    	  document.getElementById("content_deal_comment").value=zwIframe.document.getElementById("contentOP").value;
      }
    }
    ////判断是否有word转pdf权限及是否已经转换过
    function checkWordToPdfAttention(){
    	var bodyType = document.getElementById("govdocBodyType").value;
		if(bodyType == 'Ofd' || bodyType == 'HTML') {
	      return false;
	    }
    	var reValue = false;
    	var isConvertPdf = $("#isConvertPdf").val();
    	//若有转word转pdf策略，并且没的转pdf，则转一次
    	if(($("#_commonTanstoPDF_span").length > 0 || $("#_dealTanstoPDF").length > 0  ) && isConvertPdf == ''){
    		reValue = true;
    	}
    	return reValue;
    }

    //点击确认或者暂存待办前，把文单中意见处理框的值传递到此页面  zhangdong 20170329 end
    function transDoZCDB(){
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
        saveAttachments();
        checkLianhe(function(){
      	  if ($.content.callback.dealSaveWait) {
                $.content.callback.dealSaveWait();
            }
    		});
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
        	//判断是否有word转pdf权限及是否已经转换过 zhangdong 20170407 start
        	/*if(checkWordToPdfAttention()){
        		if(confirm("还未执行过word转pdf，是否要执行操作？"))
        		 {
        			govdocConvertToPdf();
        		 }
        	}*/

        	//判断是否有word转pdf权限及是否已经转换过 zhangdong 20170407 end


        	//提交之前判断流程密级---start
        	 if($.ctx.plugins.contains('secret')){
        		 var mProcessXml = $("#process_xml").val();
            	 var mSecretLevel = $("#secretLevel").val();
            	 var supervisorIds = $("#supervisorIds")?"":$("#supervisorIds").val();
            	 var zdgzry = $("#zdgzry").val();
        		 $.ajax({url : _ctxPath + "/secret/secretController.do?method=checkWorkflowSecretLevel",
     	    		type: "post",
     	    		dataType: "json",
     	 			data: {
     	 				processXml: mProcessXml,
     	 				secretLevel: mSecretLevel,
     	 				supervisorIds: supervisorIds,
     	 				zdgzry: zdgzry,
     	 				processId: wfProcessId
     	 			}
     	    		 ,success : function(data){
     	 	  			if(data && data.res=="false"){
	     	 	  			$.alert(data.msg);
	     	        		 return false;
     	 	  			}else{
     	 	  				sendGovdoc();
     	 	  			}
     	 	  		}
     	 	  	});
        	 }else{
        		 sendGovdoc();
        	 }

      });

      //修改正文开始
      /* 新公文不需要修改文单 $("#_commonEditContent,#_dealEditContent").click(editContentFunc); */
      //存为草稿
      $("#_dealSaveDraft").click(function() {
          if ($.content.callback.dealSaveDraft) {
              $.content.callback.dealSaveDraft();
          }
      });
      //暂存待办
      $("#_dealSaveWait").click(function() {
    	  //js事件接口
    	  transDoZCDB();
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
    	 if(newGovdocView==1){
    		 commentIframe.pushMessageToMembers(null,$('#comment_deal #pushMessageToMembers'),$('#comment_deal #pushMessage'));
    	 }else{
    		 componentDiv.pushMessageToMembers(null,$('#comment_deal #pushMessageToMembers'),$('#comment_deal #pushMessage'));
    	 }

      })
      //加签
     // $("#_dealAddNode,#_commonAddNode").click(addNode);
      $("#_dealAddNode",document).click(addNode);
      $("#_commonAddNode",document).click(addNode);

    //传阅
       $("#_dealPassRead",document).click(passReadFunc);
       $("#_commonPassRead",document).click(passReadFunc);

      //cx
      //分发
      $("#fenfa_input").click(myDistribute);
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
      //转公告
      $("#_dealTransmitBulletin",document).click(dealTransmitBulletin);
      $("#_commonTransmitBulletin",document).click(dealTransmitBulletin);
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

       $("#_commonSignChange",document).click(signZoom);
       $("#_dealSignChange",document).click(signZoom);
      //签章
      //$("#_commonSign,#_dealSign").click(openSignature);
      $("#_commonSign",document).click(openSignature);
      $("#_dealSign",document).click(openSignature);
      // 指定回退
      $("#_dealSpecifiesReturn",document).click(specifiesReturnFunc);
      //督办设置开始
     // $("#_commonSuperviseSet,#_dealSuperviseSet").click(superviseSetFunc);
      $("#_dealSuperviseSet",document).click(superviseSetFunc);
      $("#_commonSuperviseSet",document).click(superviseSetFunc);
      $("#_dealTurnRecEdoc",document).click(turnRecEdocFunc);
      $("#_dealMoreSign",document).click(moreSignNew);
      //督办设置结束
      //转督办
      $("#_dealTranstoSupervise",document).click(transtoSuperviseFunc);
      $("#_commonTranstoSupervise",document).click(transtoSuperviseFunc);
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
      //分办  xiex
      $("#_distribute",document).click(function(){
    	  distributeFunc();
      });
      $("#_jointlyIssued",document).click(function(){
    	  _jointlyIssued();
      });
    //修改正文  Edit
      $("#_commonEdit",document).click(function(){
    	  editGovdocContentFunc();
      });
      $("#_dealEdit",document).click(function(){
    	  editGovdocContentFunc();
      });
    //正文套红  EdocTemplate
      $("#_commonEdocTemplate",document).click(function(){
    	  govdocContentTaohong();
      });
      $("#_dealEdocTemplate",document).click(function(){
    	  govdocContentTaohong();
      });
    //文单套红  ScriptTemplate
      $("#_commonScriptTemplate",document).click(function(){
    	  govdocFormTaohong();
      });
      $("#_dealScriptTemplate",document).click(function(){
    	  govdocFormTaohong();
      });
    //WORD转PDF  TanstoPDF
      $("#_dealTanstoPDF",document).click(function(){
    	  govdocConvertToPdf();
      });
      $("#_dealTransToOfd",document).click(function(){
    	  govdocConvertToOfd();
      });
    //正文盖章 ContentSign
      $("#_commonContentSign",document).click(function(){
    	  openGovdocSignature();
      });
      $("#_dealContentSign",document).click(function(){
    	  openGovdocSignature();
      });
      //文单签批
      $("#_dealHtmlSign",document).click(function(){
    	  htmlSignFunc();
      });
      //全文签批
      $("#_dealPDFSign",document).click(function(){
    	  readyToPDF();
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

    function sendGovdoc (){
    	//将相关意见框的意见同步到主页面 zhangdong 20170329 start
    	beforeSubmitButton();
    	//将相关意见框的意见同步到主页面 zhangdong 20170329 end
    	//客开 作者 :mly 项目名称 ：自流程  修改功能:续办 加签 start
    	if($("#customDealWith").attr("checked") == 'checked'){
    		var selectOpt = $("#memberRange option:selected");
    		if(selectOpt.val() == -1 || selectOpt.val() == 0){
    			$.alert("请选择续办人");
    			return;
    		}
    		var processXMLObj = $("#process_xml");
    		var customDealWith = new Object();
    		var newNodeArr = new Array();//存放新增activityId
    		//返回人员
           	var nextMember = $("#nextMember");
           	if(nextMember != null && nextMember.get(0) != null){
           		customDealWith.userId=[nextMember.attr("userId")];
    		customDealWith.userName =[nextMember.attr("userName")];
    		customDealWith.userType=["Member"];
    		customDealWith.userExcludeChildDepartment=["false"];
    		customDealWith.accountId=[nextMember.attr("accountId")];
    		customDealWith.dealTerm="0";
    		customDealWith.remindTime="0";
    		customDealWith.policyId=[nextMember.attr("policyId")];
    		customDealWith.policyName=[nextMember.attr("policyName")];
    		customDealWith.flowType="2";
    		customDealWith.node_process_mode=["all"];
    		customDealWith.formOperationPolicy="1";
    		customDealWith.summaryId= summaryId;
          	customDealWith.affairId= affairId;
         	customDealWith.caseId= $(caseId).val();
    		var baseXML = processXMLObj.val();
    		var messageDataList= "";
            var messageDataListObj = $("#process_message_data");
          	if(messageDataListObj.size()>0){
            	messageDataList= messageDataListObj.val();
           	}
    		result = wfAjax.addNode(wfProcessId, wfActivityId, wfActivityId, currUserId, 1, customDealWith, baseXML, "",messageDataList, getProcessChangeMessage());
    			if("false"==result[2]){
             	$.alert(result[3]);
            	return;
          	}
          	if(result && result[0]){
            	processXMLObj.val(result[0]);
           	}
           	if(result && result[4] && messageDataListObj.size()>0){
          		messageDataListObj.val(result[4]);
          		messageDataListObj=null;
          	}
            if(result && result[5]){
           		setProcessChangeMessage(result[5]);
           		var nodes = ($.parseJSON(result[5]))["nodes"];
           		newNodeArr.push(nodes[nodes.length - 1]["id"]);////得到这次加签的activityID
           	}
           	//调用回调函数
         	var callBackObj = {
            	type : 1
            	,currentNodeId:wfActivityId
                ,names:customDealWith.userName
               	,messageDataList :result[4]
          	}
          	//refreshWorkflow(callBackObj);
           	}
    		//续办人员
    		customDealWith.userId=[selectOpt.attr("userId")];
    		customDealWith.userName =[selectOpt.attr("userName")];
    		customDealWith.userType=["Member"];
    		customDealWith.userExcludeChildDepartment=["false"];
    		customDealWith.accountId=[selectOpt.attr("accountId")];
    		customDealWith.dealTerm="0";
    		customDealWith.remindTime="0";
    		var permissionOpt = $("#permissionRange option:selected");
    		customDealWith.policyId=[permissionOpt.val()];
    		customDealWith.policyName=[permissionOpt.attr("title")];
    		customDealWith.flowType="2";
    		customDealWith.node_process_mode=["all"];
    		customDealWith.formOperationPolicy="1";
    		var baseXML = processXMLObj.val();
    		var messageDataList= "";
            var messageDataListObj = $("#process_message_data");
          	if(messageDataListObj.size()>0){
            	messageDataList= messageDataListObj.val();
           	}
         	customDealWith.summaryId= summaryId;
          	customDealWith.affairId= affairId;
         	customDealWith.caseId= $(caseId).val();
    		var result = wfAjax.addNode(wfProcessId, wfActivityId, wfActivityId, currUserId, 1, customDealWith, baseXML, "",messageDataList, getProcessChangeMessage());
           	if("false"==result[2]){
             	$.alert(result[3]);
            	return;
          	}
           	if(result && result[0]){
              	processXMLObj.val(result[0]);
     		}
         	if(result && result[4] && messageDataListObj.size()>0){
          		messageDataListObj.val(result[4]);
          		messageDataListObj=null;
          	}
            if(result && result[5]){
           		setProcessChangeMessage(result[5]);
           		var nodes = ($.parseJSON(result[5]))["nodes"];
           		newNodeArr.push(nodes[nodes.length - 1]["id"]);//得到这次加签的activityID
           	}
           	//调用回调函数
         	var callBackObj = {
            	type : 1
            	,currentNodeId:wfActivityId
                ,names:customDealWith.userName
               	,messageDataList :result[4]
          	}
          	// refreshWorkflow(callBackObj);
          	$("#customDealWithActivitys").val(newNodeArr.join(","));
    	}
    	//客开 作者 :mly 项目名称 ：自流程  修改功能:续办 加签 end
    	//cx
    	//获取单位部门
    	var faxingVal = "";
    	//if(!($("#fenfadanwei").is(":hidden"))){
		var exchange = new govdocExchangeManager();
		//标题
		var subjectTextArea = $(window.frames["componentDiv"].frames["zwIframe"].document).find("[mappingField=subject]");
		if(subjectTextArea&&subjectTextArea.is(":input")&&$.trim(subjectTextArea.val())==""){
			subjectTextArea.css("background-color","#FCDD8B");
			$.messageBox({
				'type' : 0,
				'imgType':2,
				'title':$.i18n('system.prompt.js'), // 系统提示
				'msg' : $.i18n('collaboration.common.titleNotNull'),// 标题不能为空
				ok_fn : function() {
					//element.focus();
				}
			});
			return ;
		}else{
			subjectTextArea.css("background-color","#FFFFFF");
		}

		//如果是发行
		var outAccount = "";
//		if ($.content.callback.preSubmitForm) {
//    		$.content.callback.preSubmitForm();
//    	}

		var zw = componentDiv.zwIframe;
		//非分送节点需要判断内部文号重复
		var docMark = $(zw.document).find("[mappingField=doc_mark]");
		if(docMark && docMark.attr("id")) {
			if(checkGovdocMarkUsed("", "doc_mark")) {
				return;
			}
		}
		//非分送节点需要判断内部文号重复
		var serialNo = $(zw.document).find("[mappingField=serial_no]");
		if(serialNo && serialNo.attr("id")) {
			if(checkGovdocMarkUsed("", "serial_no")) {
				return;
			}
		}

		//非分送节点需要判断签收编号重复
		var signMark = $(zw.document).find("[mappingField=sign_mark]");
		if(signMark && signMark.attr("id")) {
			if(checkGovdocMarkUsed("", "sign_mark")) {
				return;
			}
		}

		if(!($("#fenfadanwei").is(":hidden"))){
			/*var test = exchange.validateDocMark(summaryId,"mark");
        	if(test && test =="haveMark"){
        		alert("公文文号重复,请重新选择!");
        		return; 
        	}*/
			var orgIds = new Array();
			var orgTempIds = new Array();
			var orgNames = new Array();
			
			try{
			    var cm= new colManager();
			    if(cm.isNotDistribute(affairId,summaryId)){
			    	alert("该文已分送，不允许多次分送，当前节点将直接提交");
			    }else{
			    	zw.$("span[id^='field'][id$='_span']").each(function(){
						var fieldVal = $(this).attr("fieldVal");
						fieldVal = $.parseJSON(fieldVal);
						var mappingField = "";
						if($(this).children()[0]){
							mappingField = $($(this).children()[0]).attr("mappingField");
						}
						if(mappingField=="send_to"||mappingField=="copy_to"||mappingField=="report_to"){
							if($(this).hasClass("edit_class")){//编辑状态
								var value = $(this).find("input").attr("value");
								if(value!=''){
									orgTempIds=orgTempIds.concat(value.split(","));
			    				}
							}else if($(this).hasClass("browse_class")){//查看状态
								var value = fieldVal.value;
								if(value!=''){
									orgTempIds=orgTempIds.concat(value.split(","));
			    				}
							}
						}
					});
					if(orgTempIds.length>0){
						var reg = /([a-zA-Z]+\|)?(-?[0-9]{6,})/;
						for(var i =0;i<orgTempIds.length;i++){
							var r = orgTempIds[i].match(reg);
							if(r!=null&&typeof(r[1])!='undefined'){
								orgIds.push(filterOrg(orgTempIds[i]));
							}
						}
					}
					if(orgIds.length!=orgTempIds.length){
						if(!confirm("手写单位不能交换，是否继续?")){
							return;
						}
					}
					if(orgTempIds.length<=0){//如果表单中也没有值
						$.alert("分送单位不能为空");
		        		return;
					}else{
						//去除单位与部门同时存在的情况
						orgIds = orgIds.myUnique();
						//判断是否包含外部单位
						outOrgIds = exchange.validateExistAccountOrDepartment(orgIds.join(","));
						if(outOrgIds!=''&&outOrgIds!=null){
							var testArray = new Array();
							var outArray = outOrgIds.split(",");
							for(var i =0;i<outArray.length;i++){
								for(var j =0;j<orgIds.length;j++){
									if(outArray[i] == orgIds[i]){
										testArray.push(orgIds[i]);
									}
								}
							}
							if(orgIds.length == testArray.length){
		    					if(!confirm('外部单位不能交换，是否继续？')){
		    						return;
		    					}
		    				}
						}

						//if(outAccount!=""){
//							alert("发行单位中包含外部单位 "+ outAccount+",请重新选择");
//							return;
						//}
//						}else{
						faxingVal = exchange.changeOrgId(orgIds.join(","));
//						}
					}
					//检查是否套红和盖章
					var govdocBodyType = document.getElementById("govdocBodyType").value;
					if(( govdocBodyType=="OfficeWord"  ||  govdocBodyType=="WpsWord" )
							&& (!(getSignatureCount() || hasSpecialSignature()) || !(getBookmarksCount() > 0))){
						if(!window.confirm("当前公文尚未进行套红或盖章,是否继续提交？")){
							return;
						}
					}
			    }
		    }catch(e){}
		    
			
  	  	}
		document.getElementById("fenfa_input_value").value = faxingVal;

		if(faxingVal!=""){
	    	var returnVal = exchange.validateExistAccount(faxingVal);
	    	if(returnVal && returnVal !=""){
	    		alert($.i18n("govdoc.not.signWorkflow")+":\n  "+returnVal);
	    	}
		}
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
    	saveAttachments();

    	var reSign = document.getElementById("reSign");
    	//如果是签收节点
    	if(reSign&&reSign.value=="1"){
//    		var exchange = new govdocExchangeManager();
//    		var test = exchange.validateDocMark(summaryId,"signMark");
//    		if(test && test =="haveSignMark"){
//    			alert("签收编号重复,请重新输入!");
//    			return;
//        	}else{
        		for(var i =0;i<nodePerm_baseActionList.length;i++){
        			if(nodePerm_baseActionList[i]=='Distribute'){//如果签收节点有分办策略
        				var random = $.messageBox({
        					'imgType':'4',
        					'type': 100,
        					'msg': '该权限有分办权限，是否直接进行分办',
        					buttons: [{
        						id:"id1",
        						text: "是",
        						handler: function () {
        							distributeFunc("1");
        							random.close();
        						}
        					},{
        						id:"id2",
        						text: "否",
        						handler: function () {
        							checkLianhe(function(){
        								disableOperation();
        								comDealSubmit();
        							});
        							random.close();
        						}
        					}]
        				});
        				return;
        			}
        		}
//        	}
    	}
        //将‘提交’按钮置为不可用
    	checkLianhe(function(){
    		disableOperation();
            comDealSubmit();
    	});
    }
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

    function signZoom(){
    	if(PDFId!=''){
    		showSignContentView(null,'signChange');
		}else{
			$.alert("没有全文签批单或者没有启用双文单，请确认");
		}

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
/*新公文不需要修改文单             $('#_commonEditContent,#_dealEditContent').addClass("back_disable_color").disable();
             $('#_commonEditContent_a,#_dealEditContent_a').addClass("common_menu_dis").disable();*/
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
           //传阅
             $("#_dealPassRead,#_commonPassRead").addClass("back_disable_color").disable();
             $("#_dealPassRead_a,#_commonPassRead_a").addClass("common_menu_dis").disable();
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
            //传阅
            $("#_dealPassRead,#_commonPassRead").addClass("back_disable_color").disable();
            $("#_dealPassRead_a,#_commonPassRead_a").addClass("common_menu_dis").disable();
        }else if(subState == "17"){
            //修改正文
/*新公文不需要修改文单            $('#_commonEditContent,#_dealEditContent').addClass("back_disable_color").disable();
            $('#_commonEditContent_a,#_dealEditContent_a').addClass("common_menu_dis").disable();*/
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
          //传阅
            $("#_dealPassRead,#_commonPassRead").addClass("back_disable_color").disable();
            $("#_dealPassRead_a,#_commonPassRead_a").addClass("common_menu_dis").disable();
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
   //cx  分发
    function myDistribute(){
    	var par = new Object();
    	par.value = $("#fenfa_input_value").val();
		par.text = $("#fenfa_input").val();
    	$.selectPeople({
            panels: 'Account,Department,OrgTeam',
            selectType: 'Account,Department,OrgTeam',
            hiddenPostOfDepartment:true,//隐藏岗位
            showAllOuterDepartment:true,//显示所有外部单位
            isCanSelectGroupAccount:false,//是否可选集团单位
            params : par,
            minSize:0,
            callback : function(ret) {
            	$("#fenfa_input_value").val(ret.value);
                $("#fenfa_input").val(ret.text);
            }
          });
    }
  //联合发文选单位
    function _jointlyIssued(){
    	var par = new Object();
    	par.value = $("#_jointlyIssued_value2").val();
		par.text = $("#_jointlyIssued_text2").val();
    	$.selectPeople({
            panels: 'Account',
            selectType: 'Account',
            hiddenPostOfDepartment:true,//隐藏岗位
            showAllOuterDepartment:false,//显示所有外部单位
            isCanSelectGroupAccount:false,//是否可选集团单位
            //excludeElements:"Account|"+currLoginAccount,
            preReturnValueFun:"validateAccount",
            isAllowContainsChildDept:true,
            isConfirmExcludeSubDepartment:true,
            params : par,
            minSize:1,
            callback : function(ret) {
            	$("#_jointlyIssued_value2").val(ret.value);
                $("#_jointlyIssued_text2").val(ret.text);
                $("#_jointlyIssued_value").val(ret.value);
                $("#_jointlyIssued_text").val(ret.text);
            }
          });
    }
    function validateAccount(elements){
    	if(elements!=null&&elements.length>0){
    		var o = [];
    		for(var i=0;i<elements.length;i++){
    			o[i] = elements[i].id;
    		}
    		var manager = new govdocTemplateDepAuthManager();
    		var error = manager.validateAuthTemplate(o);
    		if(error != ""){
    			return [false,"以下单位未设置或者已经停用联合发文模板，请取消勾选后再发送！\r\t"+error];
    		}
    	}
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
    //修改公文正文开始
    var isUpdateedContent = false;
    function editGovdocContentFunc(editFlag){
      if(!isShowContent() || "false" == showContentByGovdocNodePropertyConfig){
    	  $.alert($.i18n("govdoc.can.not.do.operation"));
    	  return;
      }
      var bodyType = $("#govdocBodyType").val();
      if(editFlag != false) {
	      //永中office不支持wps正文修改
	      if(bodyType == "Pdf"){
	        alert("Pdf格式正文不允许修改！");
	        return;
	      } else if(bodyType == "Ofd") {
	        alert("OFD格式正文不允许修改！");
	        return;
	      }
      }
      var isYozoWps = checkYozo($("#bodyType").val());
      if(isYozoWps){
        return;
      }
      if(editFlag != false) {
	      modifyBody(summaryId,hasSign);
	      summaryChange();
	      isUpdateedContent = true;
      }
      try{
    	  $("#componentDiv").contents().find("#zwIframe").contents().find("select[comptype='chooseMark']").hide().show();
      }catch(e){}
    }
  //正文被修改，关闭窗口时弹出提示
    function summaryChange(){
    	if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
    		confirmClose();
    	}
    }

    function confirmClose(){
    	var mute = arguments.length > 0;
    	if($.browser.mozilla){
    		window.onbeforeunload=function (e){
    			if(!mute){
    				return edocLang.edoc_update_content_alert_confirm;
    			}
    		}
    	}else{
    		document.body.onbeforeunload = function(){
    			// submit时屏蔽提示
    			if(!mute){
    				window.event.returnValue = edocLang.edoc_update_content_alert_confirm;
    			}
    		};
    	}
    }

    function modifyBody(summaryId,hasSign) {
    	  var puobj = getProcessAndUserId();
    	  //修改正文加锁
    	  //var re = EdocLock.lockWorkflow(puobj.processId, puobj.currentUser,EdocLock.UPDATE_CONTENT);
    	  //正文锁和流程锁分离，这里要传入summaryId
    	  var bodyType = document.getElementById("govdocBodyType").value;
    	  if(bodyType=="gd"){
    		  $.alert($.i18n("govdoc.gdnofuntion.text"));
    	      return;
    	  }
    	  var re = lockWorkflow(summaryId, _currentUserId, 15);
    	  if(re[0] == "false"){
    	    parent.parent.$.alert(re[1]);
    	    return;
    	  }
    	  var puobj = getProcessAndUserId();
    	  //v5.7有待验证次方法的作用  TODO
    	  var result= canStopFlow(puobj.caseId);
    		  if(result[0] != 'true'){
    			  	alert(result[1]);
    			  	return;
    		  }
    	  if(bodyType=="HTML")
    	  {
    	    if(typeof (htmlContentIframe) != "undefined" && htmlContentIframe.hasHtmlSign()){
    	      alert(v3x.getMessage($.i18n("govdoc.alertCantModifyBecauseOfIsignature.text")));
    	      return;
    	    }
    	    contentUpdate=true;
    	    popupContentWin();
    	  }else if(bodyType=="Pdf"){
    		  if(!isHandWriteRef())return;
    	       popupContentWin();
    	        var tempContentUpdate=ModifyContent(hasSign);
    	        if(contentUpdate==false)
    	             contentUpdate=tempContentUpdate;

    	        if(changeWord == false)
    	             changeWord = tempContentUpdate;
    	  }else{
    	    if(!isHandWriteRef())return;
    	    //检查正文区域是否装载完成
    	    if(!hasLoadOfficeFrameComplete()) return false;
    	    //是否将公文单中的内容自动更新到公文正文中
    	    //1.修改正文 2.书签>0，3.给出套红提示。
    	    checkOpenState();
    	    var tempContentUpdate=ModifyContent(hasSign);//先检查是否允许修改  允许修改才刷新标签
    	    if(getBookmarksCount()>0 && tempContentUpdate){
    	      if(confirm($.i18n("govdoc.refreshContentAuto.text"))){
    	        //GOV-3632 公文正文套红后，处理公文时进行【修改正文】操作，选中将文单中的内容更新到正文中，结果查看正文中并没有更新，还是显示原来的。
    	    	//容错处理下
    	    	var sendForm;
    	    	if($(window.componentDiv)[0].document.zwIframe){
    	    		sendForm=$($(window.componentDiv)[0].document.zwIframe.document);
    	    	}else{
    	    		sendForm=$($(window.componentDiv)[0].zwIframe.document);
    	    	}
    	        refreshGovdocOfficeLable(sendForm);
    	      }
    	    }
    	    popupContentWin();
    	    //先签章,后修改正文,有问题
    	    //if(contentUpdate==true){return;}
    	  if(contentUpdate==false){
    	    contentUpdate=tempContentUpdate;
    	  }
    	    if(changeWord == false)
    	     changeWord = tempContentUpdate;
    	  }
    	}
    //修改公文正文结束
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
        var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, 15);
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
           checkOpenState();
           ModifyContent();
           fullSize();
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
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,3);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
    	//js事件接口
    	var sendDevelop = $.ctp.trigger('beforeDealaddnode');
    	  if(!sendDevelop){
    		 return;
    	  }

        // 指定回退状态
        var isForm = bodyType=='20';
        isForm = false;
        insertNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId,moduleTypeName,
            isForm,defaultPolicyId,flowPermAccountId,refreshWorkflow,summaryId,affairId,isTemplete);
     }

    //传阅 ctt
    function passReadFunc(){
        // 指定回退状态
        var isForm = bodyType=='20';
        isForm = false;
        passRead(wfItemId,wfProcessId,wfActivityId, currUserId,moduleTypeName,flowPermAccountId,summaryId,affairId,departmentId,refreshWorkflow);
     }

    //当前会签
    function currentAssign() {
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,3);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
        // 指定回退状态
        //if(isSpecifiesReturn())return;
        var isForm = bodyType=='20';
        isForm = false;
        assignNode(wfItemId,wfProcessId,
                wfActivityId, currUserId,
                wfCaseId, moduleTypeName,
                isForm, nodePolicy, flowPermAccountId,refreshWorkflow,
                summaryId,affairId);
    }

    //多级会签
    function moreSignNew(){
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,3);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
     	 multistageSign(
   			jsonPerm.subAppName,
   			jsonPerm.summaryId,
   			jsonPerm.affairId,
   			jsonPerm.currentUserId,
   	        jsonPerm.workitemId,
   	        jsonPerm.processId,
   	        jsonPerm.currentNodeId,
   	        jsonPerm.currentUserId,
   	        jsonPerm.currentUserName,
   	        jsonPerm.currentUserAccount,
   	        jsonPerm.flowPermAccountId,
   	        null,
   	        null,
   	        jsonPerm.departmentId,null);
     }

    //减签
    function deleteNodeFunc() {
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,3);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
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
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,3);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
        // 指定回退状态
        //if(isSpecifiesReturn())return;
        var isForm = bodyType=='20';
        isForm = false;
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
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,11);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
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
    	//流程锁
    	var resultLock= lockWorkflow(wfProcessId, currUserId,12);
	    if(resultLock[0]=='false'){
	       $.alert(resultLock[1]);
	       return;
	    }
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

  //检查正文是否被修改(新公文)
    function ocxContentIsModify()
    {
      var bodyType = document.getElementById("govdocBodyType").value;
        if(bodyType=="HTML" || bodyType == 'Pdf' || bodyType == 'Ofd' || bodyType == 'gd')
        {
          return false;
        }
        else
        {
          return contentIsModify();
        }
    }
    //转公文
    function dealTransmitBulletin(){
    	var govdocBodyType = document.getElementById("govdocBodyType").value;
    	//如果是书生交换的收文，不允许转发 START
    	if('gd'==govdocBodyType){
    		alert("书生交换不予续转公告！");
    		return;
    	} else if('Ofd' == govdocBodyType) {
    		alert($.i18n("govdoc.ofdnofuntion.text"));
    		return;
    	}
    	//580增加判断，如果公文的最新正文是ofd，暂时不支持转公告
    	var issueManager=new bulIssueManager();
    	var isOfd=issueManager.isOfdBulIssue(summaryId);
    	if(isOfd!='' && (isOfd=='true'||isOfd==true)){
        	$.alert("OFD正文暂时不支持转公告！");
        	return;
    	}

      if(ocxContentIsModify()==true)
      {//正文为修改状态，是否进行保存
          if(window.confirm("正文为修改状态，是否进行保存"))
          {
              if(!saveContent()){return;}
          }
      }
      bulletin
      //Ajax判断是否有发布新闻、公告的权限
      var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "AjaxjudgeHasPermitIssueNewsOrBull", false);
      requestCaller.addParameter(1, "String", 'bulletionaudit');
      var rs = requestCaller.serviceRequest();
      if(rs == "false"){
    	  alert("您没有发布权限!");
          return ;
      }
      var type = "govdoc";
      if(govdocBodyType != "Pdf" && govdocBodyType != "Ofd" && govdocBodyType != "HTML") {
	      //检查当前正文状态是否允许转公告
	      if(1 != getShowType()){
	    	  alert("手写批注或者清稿状态下不能进行该操作!");
	    	  return;
	      }
	      //转公告 清除痕迹提示
	      if(!confirm($.i18n("govdoc.alertAcceptAllRevisions2"))){
	   	   	  return;
	      }
	      //清除所有痕迹
	      removeTrail();
      }
      edocBulletinIssue(summaryId,govdocBodyType,bulletinIssueBack,type);
    }
    //转公文回调函数
    function bulletinIssueBack(rv){
      if(rv){
    	 alert("公文转公告成功");
        //alert(v3x.getMessage("edocLang.edoc_transferred_announcement"));
      }

    }
    //转事件
    function transformFunc(){
    	if(ocxContentIsModify()==true)
        {//正文为修改状态，是否进行保存
            if(window.confirm("正文为修改状态，是否进行保存"))
            {
                if(!saveContent()){return;}
            }
        }
        AddCalEvent("",affairId,collEnumKey,"",forwardEventSubject);
    }
    //督办设置开始
    function superviseSetFunc(){
        if(isSpecifiesBack())return;
        try {
			var arr = $(window.componentDiv)[0].document.zwIframe.document.getElementsByTagName("select");
			if(arr && arr.length > 0){
				for(var i = 0; i < arr.length;i ++){
					if($(arr[i]).attr("mappingField") == "secret_level"){
						document.getElementById("secretLevel").value = $(arr[i].options[arr[i].selectedIndex]).attr("val4cal");
					}
				}
			}
		} catch (e) {}
		openSuperviseWindow('3',false,summaryId,templeteId,null,startMemberId);
    }
    //转督办
    function transtoSuperviseFunc(){
    	//判断督办插件是否存在
    	if(!$.ctx.plugins.contains('supervision')){
    		$.alert("督查督办插件未启用！");
    		return;
    	}
    	//var url=_ctxPath+"/supervision/supervisionController.do?method=superviseCategory&affairId="+affairId+"&summaryId="+summaryId+"&isFrom=govdoc";
    	var url=_ctxPath+"/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&viewId=0&formTemplateId=0&formId=0&moduleType=37&isSupervise=true&supType=0&affairId="+affairId+"&summaryId="+summaryId+"&isFrom=govdoc";
    	openCtpWindow({"url":url});
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
        //发行之前 清稿正文
        var govdocBodyType = document.getElementById("govdocBodyType").value;
        if(!($("#fenfadanwei").is(":hidden")) && ( govdocBodyType=="OfficeWord"  ||  govdocBodyType=="WpsWord" )){

        	//内蒙古自治区巴彦淖尔市政府紧急bug2017-07-05 17:00，分送节点pdf盖章后无法保存
        	//Word转Pdf以后，如果PDF加盖了专业签章，保存PDF
        	try{
        		if ($("#contentIframe")[0].contentWindow.checkContentModify()) {
        			$("#contentIframe")[0].contentWindow.savePdf();
        		}
        	} catch(e) {
        		try{
        			if ($("#govdocPdfiframe")[0].contentWindow.checkContentModify()) {
        				$("#govdocPdfiframe")[0].contentWindow.savePdf();
        			}
        		} catch(e) {}
        	}

        	// 清除正文痕迹并且保存
        	if (!removeTrailAndSaveWhenTemplate())
        		return;
        }else{
        	//保存公文正文
        	saveGovdocContent();
        }
  	  	doSaveSign();
        $("#pigeonholeValue").val("");
        if($("#pigeonhole").size()>0 && $("#pigeonhole")[0].checked){
            var result = pigeonhole(null, null, null, null, "govdocsent", "comDealSubmitPigeonCallback");//新公文增加参数
        }else{
            comDealSubmitAffterPigeon();
        }
    }
    function doSaveSign(){
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "isCompeteOver",false);
    	  requestCaller.addParameter(1, "String", $("#affair").val());
    	  var ds = requestCaller.serviceRequest();
    	  if(ds=="true"){
    	    if(!componentDiv.zwIframe.saveHwData())
    	    {
    	      enablePrecessButtonEdoc();
    	      throw new Error(v3x.getMessage("edocLang.edoc_Release_lock9"));
    	        return;
    	    }
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
    function distributeFunc(isSign){
    	/*if ($("input[name='attitude']:checked" ).val()== "collaboration.dealAttitude.disagree"){//不同意
    		return;
    	}*/
    	var colManagerAjax = new colManager();
    	var hasFenbanRoot = colManagerAjax.checkRoot("F20_newDengji");
    	if(!hasFenbanRoot){
    		$.alert($.i18n("govdoc.alert.root.noDistributePerm"));
    		return;
    	}

    	var zw = componentDiv.zwIframe;
		var docMark = $(zw.document).find("[mappingField=sign_mark]");
		if(docMark && docMark.attr("id")) {
			var markstr;
			var docMarktxt = $(zw.document).find("#" + docMark.attr("id") + "_txt");
			if(docMarktxt && docMarktxt.attr("id")) {
				markstr = docMarktxt.val();
			} else {
				markstr = docMark.html();
			}
			if(checkGovdocMarkUsed(markstr, "sign_mark")) {
				return;
			}
		}

    	if(fenbanStatus=='hasFenban'){
    		var confirm = $.confirm({
                'msg':'此公文已经分办，是否继续处理提交？',
                ok_fn: function () {
                    $("#_dealSubmit").click();
                },
                cancel_fn:function(){
                	confirm.close();
                }
            });
    	}else{
    		$("#isDistribureOperate").val("1");
        	if($("#openNewWindow").val() == "false"){
        		var parmas = "";
        		getCtpTop().showSummayDialogByURL("/seeyon/collaboration/collaboration.do?method=newColl&contentDataId=" + $("#contentDataId").val() + "&contentTemplateId=" + $("#contentTemplateId").val() + "&distributeAffairId=" + affairId + "&formAppId=" + formAppId + "&app=4&sub_app=2&oldSummaryId="+summaryId,"新建",parmas);
        		distributePage = window.location.href="/seeyon/collaboration/collaboration.do?method=listDesc&type=listPending&size="+parent.grid.p.total+"&r=" + Math.random();
        	}else{
        		var theUrl = "/seeyon/collaboration/collaboration.do?method=newColl&contentDataId=" + $("#contentDataId").val() + "&contentTemplateId=" + $("#contentTemplateId").val() + "&distributeAffairId=" + affairId + "&formAppId=" + formAppId + "&app=4&sub_app=2&oldSummaryId="+summaryId;
        		if(isSign!='undefined'&&isSign=='1'){
        			$("#signAndDistribute").val(1);
        			theUrl+="&signAndDistribute="+isSign;
        		}else{
        			$("#isDistribute").val(1);
        			theUrl+="&isDistribute=1";
        		}
//        		if(opener.open==null){
//        		    distributePage = window.open(theUrl);
//        		}else{
//        			distributePage = opener.open(theUrl);
//        		}
        		$("#fbNewUrl").val(theUrl);
        	}
        	transDoZCDB();
    	}

    }
    function getGovdocOpinionsForTaoHong(templateType){
    	try {
    	      var ops = new Array();
    	      var isContainNiwenOrDengji = false;
    	      var opinions = null;
    	      var opinionSpans = null;
    	      var pw ;
    	      if(templateType=="govdoc"&&typeof(componentDiv)!='undefined'){
    	    		 opinions = componentDiv.zwIframe.opinions;
    	    		  opinionSpans = componentDiv.zwIframe.opinionSpans;
    	      }else{
    	    	  pw = transParams.parentWin.componentDiv.zwIframe;
    	    	  opinions = pw.opinions;
    	    	  opinionSpans = pw.opinionSpans;
    	      }
    	      for(i=0;i<opinions.length;i++)
    	      {
    	        spanObj = componentDiv.zwIframe.$("#opinion_"+opinions[i][0])[0];
    	        if(spanObj&&spanObj!=null){
    	          var sopin = new Array();
    	          sopin[0] = opinions[i][0];
    	          componentDiv.zwIframe.$("span[id='"+opinions[i][0]+"_span']").each(function(){
    	        	  if($(this).children()[0].tagName=='DIV'){
	    	        	  var mappingField = $($($(this).children()[0]).children()[0]).attr("mappingField");
	    	        	  sopin[0] = mappingField;
    	        	  }else{

    	        	  }
    	          });
    	          var html = spanObj.innerText;
					var reg =/[\t\r\n]+/g;///[\x20\t\f\r\n]+/g;
		            var arr = html.split(reg);
    	          sopin[1] = arr.join("\r\n");
    	          ops.push(sopin);
    	          if(opinions[i][0] =='niwen'  || opinions[i][0] == 'dengji')
    	            isContainNiwenOrDengji = true;
    	        }
    	      }
    	      var opArr = new Array();
    	      opArr[0] = ops;
    	      if(isContainNiwenOrDengji == false)
    				opArr[1] = componentDiv.zwIframe.sendOpinionStr;
    	      else
    	        opArr[1] = '';
    	      return opArr;
    	    }catch(e){
    	      return new Array();
    	    }
    }
    function htmlSignFunc(){
    	showContentView();
    	    //是edge浏览器
    	    if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
    	        alert("当前浏览器不支持office签章！");
    	        return;
    	    }
    	    var ii = 0;
    	    	var zw = componentDiv.zwIframe;
    	    	zw.$("span[id^=field][id$=_span]").each(function(){
    	    		if($(this).attr("fieldVal")){
    	    			var fieldVal = $.parseJSON($(this).attr("fieldVal"));
    	    			if(fieldVal.inputType=='edocflowdealoption'){
        	    			if($(this).attr("class").indexOf("edit_class")!=-1){
        	    				ii++;
        	    			}
        	    			var t = $($(this).children()[0]).children();
        	    			var theObjStr = $($($(this).children()[0]).children()[0]).attr("comp");
        	    			if(typeof(theObjStr)!='undefined'){
    	    	    			var tj = $.parseJSON('{'+theObjStr+'}');
    	    	    			if(t.length>0&&t[0].tagName.toLowerCase()==="input"){
    	    	    	              var twidth = 0;
    	    	    	              if(t.css("width")==="100%"||t.width()==0){
    	    	    	                  twidth = t.parent("div").width();
    	    	    	              }else{
    	    	    	                  twidth = t.width();
    	    	    	              }
    	    	    	              tj.recordId = summaryId;
    	    	    	              var theight = t.height();
    	    	    	              if(twidth==0){
    	    	    	                  twidth = 100;
    	    	    	              }
    	    	    	              if(theight==0){
    	    	    	                  theight = 20;
    	    	    	              }
    	    	    	              if(tj.showButton == true){
    	    	    	                  var button = $("<span></span>");
    	    	    	                  button.attr("id","signButton");
    	    	    	                  button.attr("class",tj.buttonClass ? tj.buttonClass : "ico16 signa_16");
    	    	    	                  if(tj.enabled===1){
    	    	    	                      button.unbind("click").bind("click",function(){
    	    	    	                    	  componentDiv.zwIframe.handWrite(tj.recordId,t[0],false,'',$.ctx.CurrentUser.id,function(){
    	    	    	                    		  showNowHeight();
    	    	    	                    	  });
    	    	    	                      });
    	    	    	                  }
    	    	    	                  t.after(button);
    	    	    	                  twidth = twidth-button.width()-2;
    	    	    	              }
    	    	    	              t[0].initWidth = twidth+"";
    	    	    	              t[0].initHeight = theight+"";
    	    	    	              t.attr("initWidth",twidth+"");
    	    	    	              t.attr("initHeight",theight+"");
    	    	    	          }
    	    	    	          tj.signObj = t[0];
    	    	    	          tj.currentUserId = $.ctx.CurrentUser.id;
    	    	    	          var hwObj1 = componentDiv.zwIframe.createHandWrite(tj.objName,tj.userName,tj.recordId,t[0],true,affairId);
    		    	    	  	  if(tj.enabled == "1"){
    		    	    	  		hwObj1.Enabled = tj.enabled;
    		    	    	  	  }
    		    	    	  	  if(componentDiv.zwIframe.loadObjData(hwObj1)==false){alert("调入手写批注失败");};
    		    	    	  	  var pdiv = $($(this).children()[0]);
    		    	    	  	  if(typeof(pdiv)!='undefined'){
    		    	    	  		$(this).children("span[id='"+fieldVal.name+"']").css({"height":"auto"});
    			    	            var fieldBorderColor = pdiv.css("border-color");
    			    	            //非设计态下，如果签章单元格没设置边框，那么使用黑色边框1像素
    			    	            if(fieldBorderColor==null||fieldBorderColor==''||fieldBorderColor!="#000000"){
    			    	            	pdiv.css("border","1px solid #000000");
    			    	            }
    		    	    	  	  }

        	    			}
        	    		}
    	    		}

    	    	});
    	    if(ii==0){
    	    	$.alert($.i18n("govdoc.alert.noSign.message"));
    	    }else{
    	    	showNowHeight();
    	    }
    }
function showNowHeight(){
    	var nowHeight = componentDiv.zwIframe.$("#mainbodyDiv").height();
    	 componentDiv.$("#cc").height(nowHeight);
    	 componentDiv.$("#cc").parent().height(nowHeight);
    	 componentDiv.$("#zwIframe").height(nowHeight);
}
function saveContent(){
  return saveGovdocContent();
}

//处理时保存公文正文
function saveGovdocContent() {
	var ajaxStr = "" ;//记录的是修改的类型的记录
	var affair_IdValue = document.getElementById("affair_id") ;
	var summary_IdValue = document.getElementById("summary_id");
	var ajaxUserId = document.getElementById("ajaxUserId");
	var redFormObj = document.getElementById("redForm");
	if(redFormObj)  {
		var redFormValue = redFormObj.value ;
		if(redFormValue == "true" && affair_IdValue && summary_IdValue){
			ajaxStr = ajaxStr + ",taohongwendan" ;
		}
	}

	//Word转Pdf以后，如果PDF加盖了专业签章，保存PDF
	try{
		if ($("#contentIframe")[0].contentWindow.checkContentModify()) {
			$("#contentIframe")[0].contentWindow.savePdf();
		}
	} catch(e) {
		try{
			if ($("#govdocPdfiframe")[0].contentWindow.checkContentModify()) {
				$("#govdocPdfiframe")[0].contentWindow.savePdf();
			}
		} catch(e) {}
	}

	if(contentUpdate==false){
		submitToRecord();
		return true;
	}
	var bodyType = document.getElementById("govdocBodyType").value;
	if(bodyType=="HTML") {
		//保存专业签章
		if(typeof(htmlContentIframe) != "undefined" && htmlContentIframe.isInstallIsignatureHtml()){
			htmlContentIframe.saveISignatureHtml(3);
		}
		try {
			var ds;
			var url = window.location.search;
			var ajaxColManager = new colManager();
			var params = new Object();
			params.content = getHtmlContent();
			var summaryId2 = GetQueryString(url,"summaryId");
			if(!summaryId2){
				summaryId2 = summaryId;
			}
			params.summaryId = summaryId2;
			params.contentType = "10";
			ajaxColManager.saveGovdocContent(params, {
				success: function(rs){
					ds = rs;
				}
			});
			//var rtVal = tBS.testAjaxBean2(ajaxTestBean);
			ajaxStr = ajaxStr + ",contentUpdate" ;
			submitToRecord();
			return (ds=="true");
		} catch (ex1) {
			alert("Exception : " + (ex1.number & 0xFFFF)+ex1.description);
			return false;
		}
	} else if(bodyType=="Pdf"){
		savePdf();
		if(contentUpdate) {
			if(changeWord){
				ajaxStr = ajaxStr + ",contentUpdate" ;
			}
		}
		submitToRecord();
	} else if(bodyType=="Ofd"){//Ofd暂时不处理
	}

	{
		/**
		 * 记录正文被修改的记录
		 */
		if(contentUpdate) {
			if(changeWord){
				ajaxStr = ajaxStr + ",contentUpdate" ;
			}
		}
		/**
		 * 记录正文套红
		 */
		if(hasTaohong) {
			var redContentValue = redContent;
			if(redContentValue && redContentValue.value == "true")
				ajaxStr = ajaxStr + ",taohong" ;
		}
		/**
		 * 签章
		 */
		if(changeSignature && bodyType!="Pdf") {
			var count = getSignatureCountCount();
			if(count != SignatureCount){
				ajaxStr = ajaxStr + ",qianzhang" ;
			}
		}


		if(saveOffice()==false) {
			return false;
		}
	}
	/**
	 * 修改正文并且导入了新文件，需要记录应用日志
	 */
	try{
		if(isLoadNewFileEdoc) {
			ajaxStr = ajaxStr + ",isLoadNewFile" ;
		}
	}catch(e){}
	submitToRecord();
	// AJax记录操作日志
    function submitToRecord(){
        if(ajaxStr != ""  && affair_IdValue && summary_IdValue && ajaxUserId) {
        	recordChangeWord(affair_IdValue.value ,summary_IdValue.value ,ajaxStr, ajaxUserId.value)
        	ajaxStr = "" ;
        }
    }
    return true;
}
/**
* AJax记录流程日志
*/
function recordChangeWord(affair_IdValue ,summary_IdValue ,ajaxStr,userId) {
	if(null == affair_IdValue || "" == affair_IdValue){
		var url = window.location.search;
		affair_IdValue = GetQueryString(url,"affairId");
	}
	if(null == summary_IdValue || "" == summary_IdValue){
		var url = window.location.search;
		var summaryId2 = GetQueryString(url,"summaryId");
	  if(!summaryId2){
		  summaryId2 = summaryId;
	  }
		summary_IdValue = summaryId2;
	}
  if(affair_IdValue == "" && summary_IdValue == "" && ajaxStr == "")
    return ;
    try{
        if(affair_IdValue && summary_IdValue) {
        	var colManagerAjax = new colManager();
            var params = new Object();
            params["affairId"] =  affair_IdValue;
            params["summaryId"] =  summary_IdValue;
            params["changeType"] =  ajaxStr;
            params["userId"] =  userId;
            colManagerAjax.recoidChangeWord(params);
        }
    }catch(e){
    }
}



//获取指定url里面参数的值，没有则返回空
function GetQueryString(url,name){
    if(null == name || "" == name || undefined == name
        || null == url || "" == url || undefined == url){
        return null;
    }
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = url.substr(1).match(reg);
    if(r!=null)return  unescape(r[2]); return null;
}

//公文正文套红
function govdocContentTaohong(){
	//只有WORD和WPS才能
    var bodyType=document.getElementById("govdocBodyType").value;
    if (bodyType == "HTML") {
        alert($.i18n("govdoc.htmlnofuntion.text"));
        return;
    }
    if (bodyType == "OfficeExcel")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.excelnofuntion.text"));
        return;
    }
    if (bodyType == "WpsExcel")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.wpsetnofuntion.text"));
        return;
    }
    if (bodyType == "Pdf") {
        alert($.i18n("govdoc.pdfnofuntion.text"));
        return;
    }
    if (bodyType == "Ofd") {
        alert($.i18n("govdoc.ofdnofuntion.text"));
        return;
    }
    changeBackCurrentVer();
	if(getBookmarksCount() > 0){
		var random = $.messageBox({
		    'type': 100,
		    'msg':'正文已套红，是否需要更改套红模板，点击是选择新套红模板，点击否则只更新正文书签内容。',
		    buttons: [{
		    id:'btn1',
		        text: "是",
		        handler: function () {
		        	if(!isShowContent() || "false" == showContentByGovdocNodePropertyConfig){
	            	  	  $.alert($.i18n("govdoc.can.not.do.operation"));
	            	  	  return;
	            	    }
	            	    var isYozoWps = checkYozo();
	            	    if(isYozoWps){
	            	      return;
	            	    }
	            	    taohong('edoc');
	            	    summaryChange();
		        }
		    }, {
		    id:'btn2',
		        text: "否",
		        handler: function () {
		        	var sendData = null;
	            	if(navigator.userAgent.indexOf("MSIE")>0) {
	            		sendData = $($(window.componentDiv)[0].document.zwIframe.document);
	            	} else {
	            		sendData = $($($(window.componentDiv)[0].document).find('#zwIframe').prop('contentWindow').document);
	            	}
	            	refreshGovdocTaohong(sendData);
	            	contentUpdate = true;
		        }
		    }, {
		    id:'btn3',
		        text: "取消",
		        handler: function () { random.close(); }
		    }]
		});
	}else{
		if(!isShowContent() || "false" == showContentByGovdocNodePropertyConfig){
  	  	  $.alert($.i18n("govdoc.can.not.do.operation"));
  	  	  return;
  	    }
  	    var isYozoWps = checkYozo();
  	    if(isYozoWps){
  	      return;
  	    }
  	    taohong('edoc');
  	    summaryChange();
	}
}
//world转pdf
function govdocConvertToPdf(){
	if(!isShowContent()){
  	  $.alert($.i18n("govdoc.can.not.do.operation"));
  	  return;
    }
	//只有WORD和WPS具有转PDF的功能
    var bodyType=document.getElementById("govdocBodyType").value;
    if( bodyType=="OfficeWord"  ||  bodyType=="WpsWord" ){
       if("2" == getShowType()){
    	   $.alert($.i18n("govdoc.can.not.do.operation.showType"));
    	   return;
       }
       //word转pdf 清除痕迹提示
       if(!confirm($.i18n("govdoc.alertAcceptAllRevisions"))){
    	   return;
       }

       if(govdocConvertWordToPdf()){
         $.alert($.i18n("govdoc.tans2PdfSuccess.label"));
       }else{
    	   if("2" == getShowType()){
    		   $.alert($.i18n("govdoc.can.not.do.operation.showType"));
    	   }else{
    		   $.alert($.i18n("govdoc.tans2PdfError.label"));
    	   }
       }
    }else{
    	$.alert($.i18n("govdoc.tans2PdfOnlyWordAndWps.label"));
    }
}

function govdocConvertWordToPdf(){
	  //var isunit     = document.getElementById("isUniteSend");
	  //var hasExchange = document.getElementById("edocExchangeType_depart");
	  var newPdfIdFirst  = document.getElementById("newPdfIdFirst").value;
	  var newPdfIdSecond = document.getElementById("newPdfIdSecond").value;
	  //if(hasExchange && canTransformToPdf=="true"){


	  //GOV-4596  联合发文正文套红后点击正文转pdf没有反应
	  //这里以前注释掉了，现在联合发文需要支持转pdf的功能
	       //联合发文不支持转PDF
	     //if(isunit && isunit.value=="true") return true;

	     if(!transformWordToPdf(newPdfIdFirst))
	     {
	       return false;
	     }
	       //联合发文暂时不支持转PDF，但是代码机构基本出来了，所以保留，下面联合发文的代码，但是实际执行的时候进不到下面来的。
//	       if(isunit && isunit.value=="true"){
//	            if(!transformWordToPdf(newPdfIdSecond))
//	            {
//	              return true;
//	            }
//	       }
	        //增加这个隐藏域主要是用来告诉服务器当前操作是否成功的执行了转PDF操作，如果是的话后台需要保存PDF相关的信息。
	  document.getElementById("isConvertPdf").value="isConvertPdf";
	  //document.getElementById("newPdfIdFirst").value=newPdfIdFirst;
	    //  document.getElementById("newPdfIdSecond").value=newPdfIdSecond;
	  //}
	  return true;
}
//公文文单套红
function govdocFormTaohong(){
    taohong('script');
    summaryChange();
}
//处理过程中的正文套红
var tempTaohongIsUniteSend = "";
var tempTaohongTemplateType = "";
function taohong(templateType) {
	var puobj = getProcessAndUserId();
    if(templateType == "edoc"){
    	//正文锁
    	var lockWorkflowRe = lockWorkflow(summaryId, puobj.currentUser,15);
    	if (lockWorkflowRe[0] == "false") {
    		$.alert(lockWorkflowRe[1]);
    		return;
    	}
    }else if(templateType == "script"){

    	// 判断是否有其他用户在修改文单，文单锁
		// G6V5.7 版本不需要判断文单锁
    	/*if(checkAndLockEdocEditForm(puobj.summaryId)){
    		 return;
    	}*/
    }

    var bodyType = document.getElementById("govdocBodyType").value;
    tempTaohongIsUniteSend = document.getElementById("isUniteSend").value;
    var orgAccountId = document.getElementById("orgAccountId").value;

    if (bodyType == "HTML" && templateType == "edoc") {
        alert($.i18n("govdoc.htmlnofuntion.text"));
        return;
    }
    if (bodyType == "OfficeExcel" && templateType == "edoc")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.excelnofuntion.text"));
        return;
    }
    if (bodyType == "WpsExcel" && templateType == "edoc")// excel不能进行正文套红。
    {
        alert($.i18n("govdoc.wpsetnofuntion.text"));
        return;
    }
    if (bodyType == "Pdf" && templateType == "edoc") {
        alert($.i18n("govdoc.pdfnofuntion.text"));
        return;
    }
    if (bodyType == "Ofd" && templateType == "edoc") {
        alert($.i18n("govdoc.ofdnofuntion.text"));
        return;
    }
    if (bodyType == "gd" && templateType == "edoc") {
        alert($.i18n("govdoc.gdnofuntion.text"));
        return;
    }


    // 加验证——————是否可以进行提交
    var canObj = getCanTakeBacData();
    var re = edocCanWorkflowCurrentNodeSubmit(canObj.workitemId);
    if (re != null && re[0] != 'true') {
        alert(re[1]);
        return;
    }
    // 判断文号是否为空
    if (templateType == "edoc") {
        if (checkEdocWordNoIsNull() == false) {
            return;
        }
    }
    // Ajax判断是否存在套红模板
    if (templateType == "script") {
        bodyType = "";
    }
    if (!hasEdocDocTemplate(orgAccountId, templateType, bodyType)) {
        if (templateType == 'edoc') {
          $.alert($.i18n('govdoc.docTemplate.record.content.notFound.text',
                    bodyType));
        } else {
            $.alert($.i18n('govdoc.docTemplate.record.notFound'));
        }
        return;
    }

    if (bodyType.toLowerCase() == "officeword"
            || bodyType.toLowerCase() == "wpsword" || templateType == "script") {
        if (templateType == "edoc") {

            if (!isHandWriteRef())
                return;
            // 判断是否有印章，有印章的时候不允许套红。
            if (getSignatureCount() > 0) {
                alert($.i18n("govdoc.notaohong.signature"));
                return;
            }
            // 正文套紅將會自動清稿，你確定要這麼做嗎?
            if (confirm($.i18n("govdoc.alertAutoRevisions"))) {
            	saveContent();
                // 清除正文痕迹并且保存
                if (!removeTrailAndSave())
                    return;
            } else {
                return;
            }
        }
        var govdocTemplateURL = _ctxPath+"/edocDocTemplate.do";
        window.taohongWin = getA8Top().$.dialog({
            title:'选择套红模版',
            transParams:{'parentWin':window, "popWinName":"taohongWin", "popCallbackFn":window.taohongCallback},
            url: govdocTemplateURL + "?method=taoHongEntry&templateType="
                    + templateType + "&bodyType=" + bodyType + "&isUniteSend="
                    + tempTaohongIsUniteSend + "&orgAccountId=" + orgAccountId,
            targetWindow:getA8Top(),
            width:"350",
            height:"150"
        });
        tempTaohongTemplateType = templateType;
    }
}

//在多人执行时，判断是否有人修改正文。
function checkAndLockEdocEditForm(summaryId){
 var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "editObjectState",false);
  requestCaller.addParameter(1, "String", summaryId);
  var ds = requestCaller.serviceRequest();
  //TODO 这里通过ajax返回的UserUpdateObject 对象是一个字符串了，是不对的，需要平台组来改
  if(ds.get("curEditState")=="true")
  {
        canUpdateWendan=false;
        alert("govdoc.cannotedit");
        return true;
  }
  //新建文档，不需要更新
  if(ds.get("lastUpdateTime")==null){return false;}
  return false;
}

function getCanTakeBacData(){
	  var obj = {};
	  var processId = _summaryProcessId;
	  var workitemId = _summaryItemId;
	  var nodeId = _affairActivityId;
	  var caseId = _summaryCaseId;
	  obj.processId = processId;
	  obj.workitemId = workitemId;
	  obj.nodeId = nodeId;
	  obj.caseId = caseId;
	  return obj;
}

//是否能够进行提交
function edocCanWorkflowCurrentNodeSubmit(workitemId){
	var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "edocCanWorkflowCurrentNodeSubmit",false);
	  requestCaller.addParameter(1, "String", workitemId);
	  var rs = requestCaller.serviceRequest();
	  return rs;
}

/*判断公文文号是否为空*/
function checkEdocWordNoIsNull(){
  var markStr="";
  var sendData = null;
  if(navigator.userAgent.indexOf("MSIE")>0) {
	  sendData = $($(window.componentDiv)[0].document.zwIframe.document);
  } else {
	  sendData = $($($(window.componentDiv)[0].document).find('#zwIframe').prop('contentWindow').document);
  }

  var sendDataFiled = sendData.find("[id^=field]");
  var docMack = null;
  $.each(sendDataFiled,function(index,data){
	  if(data.getAttribute("mappingField") == "doc_mark"){
		  docMack = data;
		  return false;
	  }
  });
  if(docMack!=null)
  {
    if(docMack.nodeName == "SELECT"){
      markStr = docMack.options[docMack.selectedIndex].innerHtml;
      //BUG_普通_V5_V5.71_无_青海省海东工业园区管理委员会_进行套红模板操作时，提示公文文号为空
      if(markStr==""){
    	  markStr = docMack.options[docMack.selectedIndex].text;
      }
    }else{
      markStr=docMack.value;
    }
    if(markStr=="")
    {
      if(confirm($.i18n("govdoc.taohong.mark.alter.not.null"))){
    	 return true;
      }else{
          return false;
      }

    }
  }
  return true;
}
function _getWordNoValue(inputObj){
  var markStr="";
  var inputValue="";
  if(inputObj.tagName=="INPUT" && (inputObj.type=="text" || inputObj.type=="hidden"))
  {
    inputValue=inputObj.value;
    if(inputValue && inputValue.indexOf("|")>-1){
    	markStr=inputValue.split("|")[1];
    }else{
    	markStr=inputValue;
    }
  }
  else if(inputObj.tagName=="SELECT")
  {
    inputValue=inputObj.options[inputObj.selectedIndex].value;
    if(inputValue==""){return "";}
    markStr=inputValue.split("|")[1];
  }else if(inputObj.tagName=="TEXTAREA"){
    inputValue=inputObj.value;
    markStr=inputValue;
  }
  return markStr;
}

//ajax判断是否存在套红模板
function hasEdocDocTemplate(orgAccountId,templateType,bodyType){
  var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocDocTemplateController", "hasEdocDocTemplate",false);
  requestCaller.addParameter(1, "Long", orgAccountId);
    requestCaller.addParameter(2, "String", templateType);
    requestCaller.addParameter(3, "String", bodyType);
    var ds = requestCaller.serviceRequest();
    //"0":没有，“1”：有
    if(ds=="1"){return true;}
    else {return false;}
}

/**
 * 审批流程时套红回调函数
 */
function taohongCallback(receivedObj) {

    if (!receivedObj) {
        return;
    }
    var contentNumObj = document.getElementById("currContentNum");
    var taohongSendUnitType = "";

    var taohongTemplateContentType = "";
    if (tempTaohongIsUniteSend == "true" && tempTaohongTemplateType == "edoc") {
        var ts = receivedObj[0].split("&");
        taohongTemplateContentType = ts[1];
        receivedObj[0] = ts[0];
        taohongSendUnitType = ts[2];
    } else {
        var ts = receivedObj.split("&");
        taohongTemplateContentType = ts[1];
        receivedObj = ts[0];
        taohongSendUnitType = ts[2];
    }
    var sendUnitTypeInput = document.createElement("input");
    sendUnitTypeInput.id = "taohongSendUnitType";
    sendUnitTypeInput.name = "taohongSendUnitType";
    sendUnitTypeInput.type = "hidden";
    sendUnitTypeInput.value = taohongSendUnitType;

    // GOV-3253 【公文管理】-【发文管理】-【待办】，处理待办公文时进行'文单套红'出现脚本错误
    // IE7不支持这句，而且在文单套红时也把选择单位或部门的去掉了，所以这里不用了
    // contentIframe.document.getElementsByName("sendForm")[0].appendChild(sendUnitTypeInput);

    if (taohongTemplateContentType == "officeword") {
        taohongTemplateContentType = "OfficeWord";
    } else if (taohongTemplateContentType == "wpsword") {
        taohongTemplateContentType = "WpsWord";
    }

    // 记录字段值为TRUE，JS用来记录套红操作
    var redContent = document.getElementById("redContent");
    if (redContent && tempTaohongTemplateType == "edoc") {
        redContent.value = "true";
    }

    if (tempTaohongTemplateType == "script") {
        var taohongIfameURL = _ctxPath+"/govDoc/govDocController.do";
        var urlStr = taohongIfameURL + "?method=govdocwendanTaohongIframe&summaryId="
                + document.getElementById("summary_id").value;
        urlStr += "&tempContentType=" + taohongTemplateContentType;

        page_receivedObj = receivedObj;
        page_templateType = tempTaohongTemplateType;
        page_extendArray = extendArray;

        window.formTaohongWin = getA8Top().$.dialog({
            title:'文单套红',
            transParams:{'parentWin':window, "popWinName":"formTaohongWin", "popCallbackFn":function(){}},
            url: urlStr,
            targetWindow:getA8Top(),
            width: getA8Top().screen.availWidth,
            height: getA8Top().screen.availHeight
        });
        var redForm = document.getElementById("redForm");
        if (redForm) {
            redForm.value = "true";
        }
    } else {
    	var newOfficeId=contentOfficeId.get('0',null);//套红时获取原正文ID
        setOfficeOcxRecordID(newOfficeId);

        var sendData = null;
        if(navigator.userAgent.indexOf("MSIE")>0) {
        	sendData = $($(window.componentDiv)[0].document.zwIframe.document);
        } else {
        	sendData = $($($(window.componentDiv)[0].document).find('#zwIframe').prop('contentWindow').document);
        }

        var sendFileData = sendData.find("[id^=field]");
        if (tempTaohongIsUniteSend != "true") {
        	officegovdoctaohong(
            		sendData,
                    receivedObj, tempTaohongTemplateType, extendArray);
            contentUpdate = true;
            hasTaohong = true;
        } else {
            officegovdoctaohong(
            		sendData,
                    receivedObj[0], tempTaohongTemplateType, extendArray);
            contentNumObj.value = receivedObj[1];
            contentUpdate = true;
            hasTaohong = true;
        }
    }
}
function addOFDFile(ofdId){
	//ong summaryId,String isConvertOFD,long ofdFileId)
	if (window.console){
		 window.console.log(parent.summaryId+" == "+ofdId);
	}

	  var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "createOFDBodies", false);
	  requestCaller.addParameter(1,"String",parent.summaryId);
	  requestCaller.addParameter(2,"String",ofdId);
	  requestCaller.serviceRequest();
}
function taohongRs(){
	alert("taohongRs");
}
//----------------------------  公文套红部分中

//套红的时候，如果是联合发文，会用两个单位的套红模板将正文分别套红，形成两套正文。
//套红的时候，如果是联合发文，检查公文的第一套正文或者第二套正文是否已经被创建，没有创建就创建，已经创建就返回当前正文ID
//创建的方式：createContentBody会在后台向edocbody表中添加记录，并且返回新的正文ID（newOfficeID）,
//        并且将newOfficeID赋值给控件的fileID.,这样保存的时候就会创建新的正文，并且向file表中添加新的记录。
function checkExistBody(){
var isUniteSend=document.getElementById("isUniteSend").value;
var summaryId=document.getElementById("summary_id").value;
var contentNum=document.getElementById("currContentNum").value;
var bodyType = document.getElementById("govdocBodyType").value;
if(contentUpdate==false || isUniteSend!="true"){return ;}
if(contentOfficeId.get(contentNum,null)==null)
  {
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocManager", "createContentBody",false);
  requestCaller.addParameter(1, "String", summaryId);
  requestCaller.addParameter(2, "int", contentNum);
  requestCaller.addParameter(3, "String", contentOfficeId.get("0",null));
  requestCaller.addParameter(4, "String", bodyType);
  var ds = requestCaller.serviceRequest();
  fileId=ds;
  contentOfficeId.put(contentNum,ds);
  }
  else
  {
    fileId=contentOfficeId.get(contentNum,null);
  }
  return fileId;
  //setOfficeOcxRecordID(fileId);
}

function isShowContent(){
	var ajaxColManager = new colManager();
	var url = window.location.search;
    var affairId = GetQueryString(url,"affairId");
	var summaryId2 = GetQueryString(url,"summaryId");
	if(!summaryId2){
		summaryId2 = summaryId;
	}
    return ajaxColManager.isShowContentByAffairId(affairId,summaryId2);
}
function turnRecEdocFunc(){
	var dialog = $.dialog({
        id : "turnRecEdoc",
        height:"400",
        width:"400",
        url : _ctxPath + '/collaboration/collaboration.do?method=toTurnRecEdoc&summaryId=' + summaryId,
        title : '转收文',
        buttons: [{
            id : "okButton",
            text: $.i18n("collaboration.button.ok.label"),
            btnType:1,
            handler: function () {
                var rv = dialog.getReturnValue();
                if(rv == null){
            		$.alert("没有选择单位");
                	return;
                }
                if(rv.opinion.length>1000){
                	$.alert("办理意见不能超过1000字！");
                	return;
                }
                var selectUnitId = rv.selectUnitId;
                var colManagerajax = new colManager();
        		var result = colManagerajax.verifyUnitExists(selectUnitId,summaryId);
        		if(result != null){
        			var confirm = $.confirm({
                        'msg':"已经为以下单位("+ result.names + ")发送，确定继续发送？？(确定继续发送，取消排除已发送单位)",
                        ok_fn: function () {
                            var timestamp = (new Date()).valueOf();
                            $.ajax({
                                url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                                data : {affairId : $("#affairId").val(),unitId : selectUnitId,opinion:rv.opinion},
                                success : function(data){
                                	var exchangeManager = new govdocExchangeManager();
                                	var returnVal = exchangeManager.validateExistAccount(selectUnitId);
                                	if(returnVal&&returnVal!=""){
                                		$.alert("以下单位公文发送不成功，详见详情<br/><br/>"+returnVal);
                                	}else{
                                		$.alert("已转收文");
                                	}
                                	dialog.close();
                                }
                            });
                        },
                        cancel_fn:function(){
                        	selectUnitId = result.finalIds;
                        	if(selectUnitId == ""){
                        		$.alert("没有选择单位");
                        		return;
                        	}
                            var timestamp = (new Date()).valueOf();
                            $.ajax({
                                url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                                data : {affairId : $("#affairId").val(),unitId : selectUnitId,opinion:rv.opinion},
                                success : function(data){
                                	$.alert("已转收文");
                                	dialog.close();
                                }
                            });
                        },
                        close_fn: function (){
                        	confirm.close();
                        }
                    });
        		}else{
        			var timestamp = (new Date()).valueOf();
                    $.ajax({
                        url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                        data : {affairId : $("#affairId").val(),unitId : selectUnitId,opinion:rv.opinion},
                        success : function(data){
                        	var exchangeManager = new govdocExchangeManager();
                        	var returnVal = exchangeManager.validateExistAccount(selectUnitId);
                        	if(returnVal&&returnVal!=""){
                        		$.alert("以下公文发送不成功，详见详情<br/>"+returnVal);
                        	}else{
                        		$.alert("已转收文");
                        	}
                        	dialog.close();
                        }
                    });
        		}
            }
        }, {
            id:"cancelButton",
            text: $.i18n("collaboration.button.cancel.label"),
            handler: function () {
                dialog.close();
            }
        }]
    });
}

function checkLianhe(subm){
	var lianheValue2 = $("#_jointlyIssued_value2").val();
	var lianheText2 = $("#_jointlyIssued_text2").val();
	var lianheValue = $("#_jointlyIssued_value").val();
	var lianheText = $("#_jointlyIssued_text").val();
	var lianheValue1 = $("#_jointlyIssued_value1").val();
	var lianheText1 = $("#_jointlyIssued_text1").val();
	if(lianheValue!=""&&lianheValue1!=""){
		var manager = new govdocExchangeManager();
		//检查联合发文流程 单位下是否有人
		var res = manager.validateJointlyHasNextPersion(summaryId,lianheValue2);
		if(res[0]!=""){
			$.alert(res[0]);
			enableOperation();
			return;
		}
		var re = manager.validateJointlyIssyedUnit(summaryId,lianheValue2);
		if(re[0]!=""){
			var con = $.messageBox({
				'imgType':'3',
				'title':'联合发文',
			    'type': 100,
			    'msg': '已经发送给如下单位('+re[0]+')，确定继续发送吗?点击是，重复再触发一条，点击否，只发起新的协办单位流程!',
			    buttons: [{
			    id:'btn1',
			        text: "是",
			        handler: function () {
			        	$("#_jointlyIssued_value").val(lianheValue2)
			        	$("#_jointlyIssued_text").val(lianheText2);
			        	subm();
			        	con.close();
			        }
			    }, {
			    id:'btn2',
			        text: "否",
			        handler: function () {
			        	$("#_jointlyIssued_value").val(re[1])
			        	$("#_jointlyIssued_text").val(re[2]);
			        	subm();
			        	con.close();
			        }
			    }, {
			    id:'btn3',
			        text: "取消",
			        handler: function () {enableOperation();con.close();}
			    }],
			    close_fn:function(){enableOperation();}
			});
		}
	}else{
		subm();
	}
}

//正文转OFD
function govdocConvertToOfd(){
	//只有WORD和WPS具有转PDF的功能
    var bodyType=document.getElementById("govdocBodyType").value;
    if( bodyType=="OfficeWord"  ||  bodyType=="WpsWord" ){
       if("2" == getShowType()){
    	   $.alert($.i18n("govdoc.can.not.do.operation.showType"));
    	   return;
       }
    }
	var bodyType = $("#bodyType").val();
	if(bodyType!="WpsWord"){
		alert("WPS正文才能转为OFD");
		return;
	}
	var confirmText="确定要将Wps正文转为Ofd?";
	if(confirm(confirmText)) {
		document.getElementById("isConvertOFD").value = "true";
		alert("转为OFD成功，提交或者暂存待办后生效");
	} else {
		document.getElementById("isConvertOFD").value = "false";
	}
}

function wpsContentModify(){
	var zwIframeObj;
	if($(window.componentDiv)[0].document){
	   	 if($.browser.mozilla){
	   		zwIframeObj =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow.document;
	   	 }else{
	   		zwIframeObj =$(window.componentDiv)[0].document.zwIframe.document;
	   	 }
	}
   	refreshGovdocOfficeLable(zwIframeObj)
}
