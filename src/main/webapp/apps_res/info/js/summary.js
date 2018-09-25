var isSubmitOperation = false;
var _resubmitMessage = null;//重复提交时窗口关闭，先检查弹出框是否已关闭

$(document).ready(function () {
	
//summary.jsp移植的js代码
	
	//页面加载 样式初始化
    layout = new MxtLayout({
        'id': 'layout',
        'centerArea': {
            'id': 'center',
            'border': true,
            'minHeight': 20
        }
    });
    summaryHeadHeight();

    $("#content_workFlow").css("overflow","auto");
    if('${docFlag}' =='yes'){
    	_showHastenButton=false;
    }
	
	if ($.browser.msie){
        if($.browser.version < 7){
            $("#componentDiv").height($("#content_workFlow").height());
            $(window).resize(function(){
                $("#componentDiv").height($("#content_workFlow").height());
            })
        }
    }
	
	
  // 正文加载
  proce = $.progressBar();

	/* 初始化样式相关 */
  initStyle();
	/* 初始化按钮 */
  if(openFrom == 'Pending') {
	  initToolbar();
  }

	/* 初始化绑定事件 */
  initBindClickEvent();
	/* 初始化文单和意见定位 */
  initInfoFormAndOpinion();

  	/** 初始化指定回退  */
  	initStepBack();

  	colseProce();
  	setButtonDisabled();

  	//绑定页面离开时事件，直接在body里面写onunload，暴力关闭浏览器时不会执行，
  	//这样操作也只能支持IE，firefox和Chrome不支持
  	if (window.attachEvent) {
        window.attachEvent("onunload", _winOnunload);
    } else if (window.addEventListener) {
        window.addEventListener("unload", _winOnunload, false);
    }
});

/**
 * 页面离开时，对报送单和流程进行解锁
 */
function _winOnunload(){
	infoDelLock(affairId);
}

 function setButtonDisabled(){
	 if(beCalledFlag =='yes'){
		 disabledButs();
	 }
 }
 
 /**
  * 禁用按钮
  * @param btnCodes
  */
 function disableDealBtns(btnCodes){
     
     if(btnCodes){
         for(var i = 0; i < btnCodes.length; i++){
             var code = btnCodes[i];
             if(code == "step_back"){//回退
                 $("#_commonStepBack_a").addClass("common_menu_dis common_button_disable")
                                        .attr("disabled","disabled")
                                        .unbind("click");
             }else if(code == "stop_flow"){//终止
                 $("#_commonStepStop_a")
                 .addClass("common_menu_dis common_button_disable")
                 .attr("disabled","disabled")
                 .unbind("click");
               
           }else if(code == "zcdb"){//暂存待办
               
               $("#_dealSaveWait")
                 .addClass("common_menu_dis common_button_disable")
                 .attr("disabled","disabled")
                 .unbind("click");
               
           }else if(code == "submit"){//提交
               $("#_dealSubmit")
               .addClass("common_menu_dis common_button_disable")
               .attr("disabled","disabled")
               .unbind("click");
               
           }else if(code == "push_msg"){//消息推送
               
               $("#pushMessageButton")
               .addClass("common_menu_dis common_button_disable")
               .attr("disabled","disabled")
               .unbind("click");
               
           }else if(code == "pigeonhole"){//处理后归档
               
               $("#isArchive,#pigeonhole").attr("disabled","disabled");
               $("#isArchive").unbind("click");
               $("#pigeonhole").unbind("change");
               
           }else if(code == "track"){//跟踪设置
               
               //跟踪 绑定点击事件，选中该 checkbox，默认选中‘全部’
               $("#isTrack")
                 .attr("disabled","disabled")
                 .unbind("click");//enable的时候要enable两个radio
               
           }else if(code == "add_flow_node"){//加签
               
               $("#_commonAddNode")
               .addClass("common_menu_dis common_button_disable")
               .attr("disabled","disabled")
               .unbind("click");
               
           }else if(code == "del_flow_node"){//减签
               
               $("#_dealDeleteNode")
               .addClass("common_menu_dis common_button_disable")
               .attr("disabled","disabled")
               .unbind("click");
               
           }else if(code == "current_assign"){//当前会签
               
               $("#_dealAssign")
               .addClass("common_menu_dis common_button_disable")
               .attr("disabled","disabled")
               .unbind("click");
               
           }else if(code == "more_assign"){//多级加签 - 普通

        	   if(isInMoreMenu("_moreAssign")){
                   $("#_moreAssign").addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind();
               }else{
                   $("#_moreAssign")
                   .addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind("click");
               }
               
           }else if(code == "modify_text"){//修改正文 - 普通
               if(isInMoreMenu("_dealEditContent")){
                   $("#_dealEditContent").addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind();
               }else{
                   $("#_dealEditContent")
                   .addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind("click");
               }
               
           }else if(code == "modify_att"){//修改附件 - 普通
               if(isInMoreMenu("_dealUpdateAttachment")){
                   $("#_dealUpdateAttachment").addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind();
               }else{
                   $("#_dealUpdateAttachment")
                   .addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind("click");
               }
               
           }else if(code == "specifies_return"){//指定回退 - 普通
               if(isInMoreMenu("_dealSpecifiesReturn")){
                   $("#_dealSpecifiesReturn").addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind();
               }else{
                   $("#_dealSpecifiesReturn")
                   .addClass("common_menu_dis common_button_disable")
                   .attr("disabled","disabled")
                   .unbind("click");
               }
           }
         }
     }
 }
 
 /**
  * 检验按钮是否在更多里面
  * @param menuId
  */
 function isInMoreMenu(menuId){
     if(window._menuSimpleData){
         for(var i = 0; i < _menuSimpleData.length; i++){
             var tempId = _menuSimpleData[i]["id"];
             if(tempId == menuId){
                 return true;
             }
         }
     }
     return false;
 }

 
/**
 * 设置按钮可以，包括事件绑定
 * @param btnCodes
 */
function enableDealBtns(btnCodes){
     
     if(btnCodes){
         for(var i = 0; i < btnCodes.length; i++){
             var code = btnCodes[i];
             
             if(code == "step_back"){//回退
                 $("#_commonStepBack_a")
                   .removeClass("common_menu_dis common_button_disable")
                   .removeAttr("disabled")
                   .unbind("click")
                   .bind("click", stepBackCallBack);
             }else if(code == "stop_flow"){//终止
                 $("#_commonStepStop_a")
                   .removeClass("common_menu_dis common_button_disable")
                   .removeAttr("disabled")
                   .unbind("click")
                   .bind("click", infoStepStop);
                 
             }else if(code == "zcdb"){//暂存待办
                 
                 $("#_dealSaveWait")
                   .removeClass("common_menu_dis common_button_disable")
                   .removeAttr("disabled")
                   .unbind("click")
                   .bind("click", doZcdb);
                 
             }else if(code == "submit"){//提交
                 $("#_dealSubmit")
                 .removeClass("common_menu_dis common_button_disable")
                 .removeAttr("disabled")
                 .unbind("click")
                 .bind("click", dealSubmit);
                 
             }else if(code == "push_msg"){//消息推送
                 
                 $("#pushMessageButton")
                 .removeClass("common_menu_dis common_button_disable")
                 .removeAttr("disabled")
                 .unbind("click")
                 .bind("click", messagePushFun);
                 
             }else if(code == "pigeonhole"){//处理后归档
                 
                 $("#isArchive,#pigeonhole").removeAttr("disabled");
                 $("#isArchive").unbind("click").bind("click", pigeonholeCheckClick);
                 $("#pigeonhole").unbind("change").bind("change", pigeonholeOnChange);
                 
             }else if(code == "track"){//跟踪设置
                 
               //跟踪 绑定点击事件，选中该 checkbox，默认选中‘全部’
                 $("#isTrack")
                   .removeAttr("disabled")
                   .unbind("click")
                   .bind("click", isTrackOnClick);//enable的时候要enable两个radio
                 
             }else if(code == "add_flow_node"){//加签
                 
                 $("#_commonAddNode")
                 .removeClass("common_menu_dis common_button_disable")
                 .removeAttr("disabled")
                 .unbind("click")
                 .bind("click", addNode);
                 
             }else if(code == "del_flow_node"){//减签
                 
                 $("#_dealDeleteNode")
                 .removeClass("common_menu_dis common_button_disable")
                 .removeAttr("disabled")
                 .unbind("click")
                 .bind("click", deleteNodeFunc);
                 
             }else if(code == "current_assign"){//当前会签
                 
                 $("#_dealAssign")
                 .removeClass("common_menu_dis common_button_disable")
                 .removeAttr("disabled")
                 .unbind("click")
                 .bind("click", currentAssign);
                 
             }else if(code == "more_assign"){//多级加签
                 if(isInMoreMenu("_moreAssign")){
                     
                 }else{
                     $("#_moreAssign")
                     .removeClass("common_menu_dis common_button_disable")
                     .removeAttr("disabled")
                     .unbind("click")
                     .bind("click", multistageSignInfo);
                 }
                 
             }else if(code == "modify_text"){//修改正文
                 
                 if(isInMoreMenu("_dealEditContent")){
                     
                 }else{
                     $("#_dealEditContent")
                     .removeClass("common_menu_dis common_button_disable")
                     .removeAttr("disabled")
                     .unbind("click")
                     .bind("click", _modifyText);
                 }
                 
             }else if(code == "modify_att"){//修改附件
                 
                 if(isInMoreMenu("_dealUpdateAttachment")){
                     
                 }else{
                     $("#_dealUpdateAttachment")
                     .removeClass("common_menu_dis common_button_disable")
                     .removeAttr("disabled")
                     .unbind("click")
                     .bind("click", modifyAttFunc);
                 }
                 
             }else if(code == "specifies_return"){//指定回退
                 
                 if(isInMoreMenu("_dealSpecifiesReturn")){
                     
                 }else{
                     $("#_dealSpecifiesReturn")
                     .removeClass("common_menu_dis common_button_disable")
                     .removeAttr("disabled")
                     .unbind("click")
                     .bind("click", specifiesReturn);
                 }
             }
         }
     }
 }
 
 function disabledButs(){
     
     //禁用按钮
     disableDealBtns(["step_back","stop_flow","add_flow_node","del_flow_node","current_assign", "more_assign"
                      ,"modify_text","modify_att","more_assign","specifies_return"]);
 }

 function initInfoFormAndOpinion(){
	 if(openFrom=="Pending" && affairState == "3" && hasUpdateInfoForm){
		 var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, "100");
		    if(lockWorkflowRe[0] == "false"){
		      $.alert(lockWorkflowRe[2]+"正在修改当前报送单!");
		      infoReadFormDisplay();

		      //屏蔽修改正文按钮
		      $('#_dealEditContent').disable();
		    }else{
		    	infoEditFormDisplay();
		    }
	 }else{
		 infoReadFormDisplay();
	 }
	 // 意见定位
	 if(openFrom === 'Pending' && affairState === '3'){
	 	showOpinionsInputForm();
	 }
	 dispOpinions(opinions, sendOpinionStr);
	 removeOpinionBorder(opinionElements);
	 initNoteOpinionClick();
	 summaryHeadHeight();
}

/*************************操作初始化*********************************/
 function initToolbar(){
 	  window._menuSimpleData = [];//设置为全局变量
	  if(nodePerm_ActionList != null && nodePerm_ActionList.length > 0){
	      
		  // alert(nodePerm_ActionList);
		  for(var i = 0;i < nodePerm_ActionList.length; i++){
			  /*if(nodePerm_ActionList[i] === 'JointSign' && show_MoreSign!="true"){
				  // 当前会签
				  _menuSimpleData.push({
				    id:"_dealAssign",
				    name: $.i18n('collaboration.nodePerm.Assign.label'),
				    className:"current_countersigned_16",
				    customAttr:" advanceAction='JointSign' class='nodePerm'"
				  });
			  }*/
			  if(nodePerm_ActionList[i] === 'UpdateInfoForm'){
				  hasUpdateInfoForm = true;
			  }
			  if(nodePerm_ActionList[i] === 'moreSign' && show_MoreSign!="true"){
				  // 多级会签
				  _menuSimpleData.push({
				    id:"_moreAssign",
				    name: $.i18n('infosend.nodePerm.moreAssign.label'),
				    className:"current_countersigned_16",
				    customAttr:" advanceAction='moreSign' class='nodePerm'",
				    handle: function() {
				    	multistageSignInfo();
				    }
				  });
			  }
			  /*if(nodePerm_ActionList[i] === 'Infom'){
				  // 知会
				  _menuSimpleData.push({
				      id:"_dealAddInform",
				      name: $.i18n('collaboration.nodePerm.addInform.label'),
				      className:"notification_16",
				      customAttr:" advanceAction='Infom' class='nodePerm'"
				  });
			  }*/
			  //if(_contentType == "10" || $.browser.msie){//非IE浏览器下,正文类型为Office类型，屏蔽修改正文按钮
				  if(nodePerm_ActionList[i] === 'Edit' && show_InfoContent!="true"){
					  // 修改正文
					  _menuSimpleData.push({
					      id:"_dealEditContent",
					      name: $.i18n('collaboration.nodePerm.editContent.label'),
					      className:"modify_text_16",
					      customAttr:" advanceAction='Edit' class='nodePerm'",
					      handle: function (json) {
					    	  _modifyText();
				            }
					  });
				  }
			  //}
			  if(nodePerm_ActionList[i] === 'allowUpdateAttachment' && show_UpdateAtt!="true"){
				  // 修改附件
				  _menuSimpleData.push({
				      id:"_dealUpdateAttachment",
				      name: $.i18n('collaboration.nodePerm.allowUpdateAttachment'),
				      className:"editor_16",
				      customAttr:" advanceAction='allowUpdateAttachment' class='nodePerm'",
				      handle: function (json) {
				    	  modifyAttFunc();
			            }
				  });
			  }
			  /*if(nodePerm_ActionList[i] === 'InfoTanstoPDF'){
				  // World转PDF
				  _menuSimpleData.push({
					  id:"_dealInfoTanstoPDF",
					  name: $.i18n('infosend.nodePerm.InfoTanstoPDF.label'),
					  className:"word_to_pdf_16",
					  customAttr:" advanceAction='InfoTanstoPDF' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'InfoDepartPigeonhole'){
				  // 部门归档
				  _menuSimpleData.push({
					  id:"_dealInfoDepartPigeonhole",
					  name: $.i18n('infosend.nodePerm.InfoDepartPigeonhole.label'),
					  className:"filing_16",
					  customAttr:" advanceAction='InfoDepartPigeonhole' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'Cancel'){
				  // 撤销
				  _menuSimpleData.push({
				      id:"_dealCancel",
				      name: $.i18n('collaboration.nodePerm.repeal.label'),
				      className:"revoked_process_16",
				      customAttr:" advanceAction='Cancel' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'Forward'){
				  // 转发
				  _menuSimpleData.push({
				      id:"_dealForward",
				      name: $.i18n('collaboration.nodePerm.transmit.label'),
				      className:"forwarding_16",
				      customAttr:" advanceAction='Forward' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'Sign'){
				  // 签章
				  _menuSimpleData.push({
				      id:"_dealSign",
				      name: $.i18n('collaboration.nodePerm.Sign.label'),
				      className:"signa_16",
				      customAttr:" advanceAction='Sign' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'Transform'){
				  // 转事件
				  _menuSimpleData.push({
				      id:"_dealTransform",
				      name: $.i18n('collaboration.nodePerm.TransformEvent.label'),
				      className:"forward_event_16",
				      customAttr:" advanceAction='Transform' class='nodePerm'"
				  });
			  }*/
			  /*if(nodePerm_ActionList[i] === 'SuperviseSet'){
				  // 督办设置
				  _menuSimpleData.push({
				      id:"_dealSuperviseSet",
				      name: $.i18n('collaboration.nodePerm.superviseOperation.label'),
				      className:"setting_16",
				      customAttr:" advanceAction='SuperviseSet' class='nodePerm'"
				  });
			  }*/
			  if(nodePerm_ActionList[i] === 'SpecifiesReturn' && show_SpecifiesReturnBack!="true"){
				  // 指定回退
				  _menuSimpleData.push({
				      id:"_dealSpecifiesReturn",
				      name: $.i18n('collaboration.default.stepBack'),
				      className:"specify_fallback_16",
				      customAttr:" advanceAction='SpecifiesReturn' class='nodePerm'",
				      handle: function (json) {
				    	  specifiesReturn();
			          }
				  });
			  }
		  }
	  }
	  $("#_moreOperation").menuSimple({
	      width:85,
	      direction:"BR",
	      offsetLeft:50,
	      data: _menuSimpleData
	  });
 }


/*************************事件绑定*********************************/
 function initBindClickEvent(){

     
     enableDealBtns(["submit","stop_flow","step_back","zcdb","track"
                     ,"pigeonhole","push_msg","add_flow_node","del_flow_node","current_assign"
                     ,"more_assign","modify_text","modify_att","specifies_return"]);//初始话按钮并切绑定事件


 	// 设置iframe高度后,再加载
	  $( "#iframe_content").attr( "src" , "content_view.html" );
	  
	  // 新增附言 绑定点击事件
	  $( '#add_new').click( function (){
	      $( '.textarea').removeClass( 'display_none' );
	  });

	  // 新增附言取消 绑定点击事件
	  $( '#cancel').click( function (){
	      $( '.textarea').addClass( 'display_none' );
	  });
	  
	  // 跟踪设置开始trackRange_members
	  $("#trackRange_members").click(function(){
	      $.selectPeople({
	          type:'selectPeople',
	          panels:'Department,Team,Post,RelatePeople',
	          selectType:'Member',
	          text:$.i18n('common.default.selectPeople.value'),
	          hiddenPostOfDepartment:true,
	          hiddenRoleOfDepartment:true,
	          showFlowTypeRadio:false,
	          returnValueNeedType: false,
	          params:{
	             value: trackMember
	          },
	          targetWindow:window.top,
	          callback : function(res){
	              if(res && res.obj && res.obj.length>0){
	                      $("#zdgzry").val(res.value);
	                      var memberArray = res.value.split(',');
	                      var memStr ="";
	                      for(var i  = 0 ; i < memberArray.length ; i ++){
	                      memStr += "Member|"+memberArray[i]+","
	                  }
	                  if(memStr.length > 0){
	                    memStr = memStr.substring(0,memStr.length-1);
	                   trackMember = memStr;
	                  }
	              } else {

	              }
	         }
	      });
	  });
	  // 跟踪设置结束


 	$("#_moreLabel").click(function(){
	      if(!isShowMoreLabel){
	        $("#detail_more_operation").show();
	        $("#arrow_2_b").css("display","none");
	        $("#arrow_2_t").css("display","inline-block");
	        isShowMoreLabel = true;
	      }else {
	        $("#detail_more_operation").hide();
	        $("#arrow_2_b").css("display","inline-block");
	        $("#arrow_2_t").css("display","none");
	        isShowMoreLabel = false;
	      }
	      summaryHeadHeight();
	  });

	  /* 默认页面加载后不显示更多操作，并隐藏起来 */
	  var isShowMoreLabel = false;
	  $("#detail_more_operation").hide();

	  // 督办设置 绑定点击事件
	  //$( '#showSuperviseSettingWindow').click(superviseSettingFunc);

	  // 督办绑定点击事件
	  //$( '#showSuperviseWindow').click(superviseFunc);

	  // 查看明细日志 绑定点击事件
	  $( '#showDetailLog').click(showDetailLogFunc);
	  // 打印 绑定点击事件
	  $( '#print').click( function (){
	    GovPrinter.infoFormPrint();
	  });
	  // 属性设置 绑定点击事件
	  $( '#attributeSetting').click( function (){
	      attributeSettingDialog(sendAffairId);
	  });
	  // 盖章
	  $( "#_commonSign, #_dealSign").click(openSignature);
	  
	  // 右侧 半屏展开
	  $( "#deal_area_show").click( function () {
	    $( ".deal_area #hidden_side").trigger( "click" );
	  });
	  
	// 右侧 收缩
	  $( ".deal_area #hidden_side").click( function () {
	    if ($( "#east" ).outerWidth() == 350) {
	          layout.setEast(38);
	          $( ".deal_area" ).hide();
	          $( "#deal_area_show" ).show();
	      } else {
	          layout.setEast(348);
	          $( ".deal_area" ).show();
	          $( "#deal_area_show" ).hide();
	      }
	  });
	  
	  // 给跟踪按钮加事件
	  $( "#gzbutton").bind( "click" ,function (){
	      setTrack();
	  });

	  $( "#gz").change( function () {
	      var a8obj = getCtpTop().document;
	      var value = $( this ).val();
	      var _gz_ren = $( "#gz_ren" ,a8obj);
	      switch (value) {
	          case "0" :
	              _gz_ren.hide();
	              break ;
	          case "1" :
	              _gz_ren.show();
	              break ;
	      }
	  });
	  // 指定人弹出选人窗口
	  $( "#radio4").bind( 'click' ,function (){
	       $.selectPeople({
	              type: 'selectPeople'
	              ,panels: 'Department,Team,Post,RelatePeople'
	              ,selectType: 'Member'
	              ,text:$.i18n( 'collaboration.default.selectPeople.value' )
	              ,params:{
	                 value: forTrackShowString
	              }
	              ,targetWindow:getCtpTop()
	              ,callback : function (res){
	                  if (res && res.obj && res.obj.length>0){
	                      var selPeopleId="" ;
	                      for (var i = 0; i < res.obj.length; i ++){
	                          if (i == res.obj.length -1){
	                              selPeopleId +=res.obj[i].id;
	                          } else {
	                              selPeopleId+=res.obj[i].id + "," ;
	                          }
	                      }
	                      forTrackShowString = res.value;
	                      $( "#zdgzry" ).val(selPeopleId);
	                  } else {

	                  }
	              }
	          });
	    });
	  // 修改流程绑定点击事件
	  $('#edit_workFlow').click( function (){
	      editWFCDiagram(getCtpTop(),_summaryCaseId,_summaryProcessId,
	              '', 'collaboration' ,isFromTemplate,
	              flowPermAccountId,'collaboration' ,$.i18n( "permission.col_flow_perm_policy"),refreshWorkflow,$.i18n( 'supervise.col.label' ));
	  });

	  //处理后归档
	  $("#archiveTo").hide();
 }

 function isTrackOnClick(){

     //跟踪 绑定点击事件，选中该 checkbox，默认选中‘全部’
     var trackRange = $('input:radio[name="trackRange"]');
     if($("#isTrack").attr('checked' )){
         trackRange.removeAttr('disabled');
         // 将‘全部’置为选中状态
         trackRange.get(0).checked = true ;
         // 改变<label>样式
         $('#label_all').removeClass('disabled_color hand' );
         $('#label_members').removeClass('disabled_color hand' );
     } else{
         trackRange.attr('disabled', 'true');
         // 去掉选中状态
         trackRange.removeAttr('checked');
         // 改变<label>样式
         $('#label_all').addClass('disabled_color hand' );
         $('#label_members').addClass('disabled_color hand' );
     }
 }
 
 /**
  * 归档下拉选择
  */
 function pigeonholeOnChange(){
     var value = $("#pigeonhole").find("option:selected").val();
     if(value == "2"){
         var result = pigeonhole(32,null,"",true,0, "infoPigeonholeCallback");
         infoPigeonholeCallbackParam.$targetObj = $("#pigeonhole");
     }
   
 }
 
 /**
  * 归档INput框点击事件
  */
 function pigeonholeCheckClick(){
     if($("#isArchive").attr("checked")){
         $("#archiveTo").show();
     }else{
         $("#archiveTo").hide();
     }
 }
 
 /**
  * 归档回调相关
  */
 var infoPigeonholeCallbackParam = {};
 function infoPigeonholeCallback(result){
     
     var $targetObj = infoPigeonholeCallbackParam.$targetObj;
     
     if(result && result != "cancel"){
         result = result.split(",");
         $("#folderId").val(result[0]);
         if($("#pigeonhole option").length == 2){
             $targetObj.append("<option value='" + result[0] + "'>" + result[1] + "</option>");
         }else{
             $("#pigeonhole option:last").attr("text",result[1]).attr("value",result[0]);
         }
         $("#pigeonhole option:last").attr("selected",true);
     }else{
         var oldOption = document.getElementById("defaultOption");
          oldOption.selected = true;
     }
 }
 
 //*************************************************************样式初始化*********************************************//
 function initStyle(){
 	  if (openFrom != 'glwd' && openFrom != 'docLib'){
	    openType = getCtpTop();
	  } else {
	    openType = window;
	  }
	  // 从首页portal打开时，在弹出框中添加'标题'显示
	  if(window.parentDialogObj && window.parentDialogObj['dialogDealColl' ]){
		  if('Send' == openFrom){
			  window.parentDialogObj['dialogDealColl' ].setTitle();//已上报进来的
		  }else{
			  window.parentDialogObj['dialogDealColl' ].setTitle(escapeStringToJavascript(subject));
		  }
	   }
	  if( trackType =='1' ){
	    $( "#isTrack[name=isTrack]").attr( 'checked' ,'checked' );
	    $( "#label_all[for=trackRange_all]").removeClass( "disabled_color" );
	    $("#label_members[for=trackRange_members]" ).removeClass( "disabled_color");
	    $("#trackRange_all" ).removeAttr( 'disabled').attr( "checked" ,"checked" );
	    $( "#trackRange_members").removeAttr( 'disabled' );
	} else if (trackType == '2'){
	    $( "#isTrack[name=isTrack]").attr( 'checked' ,'checked' );

	    $( "#label_all[for=trackRange_all]").removeClass( "disabled_color" );
	    $("#label_members[for=trackRange_members]" ).removeClass( "disabled_color");
	    $( "#trackRange_all").removeAttr( 'disabled' );
	    $("#trackRange_members" ).removeAttr( 'disabled').attr( "checked" ,"checked" );
	}

	 if ($.browser.msie){
		 if ($.browser.version < 8) {
		    $( "#iframe_content" ).css("height" , $(".stadic_layout_body" ).height());
		 }
		 if($.browser.version < 8){
		    setIframeHeight_IE7();
		    $(window).resize(function(){
		    setIframeHeight_IE7();
		    });
		  }
	}

 }
 //****************************************************************方法区**************************************************//
 // 正文保存
 function modifyBodySave() {
     if (hasOffice($("#contentType").val(), true)) {
    	 if(!_saveOffice()) {
    		 return;
    	 }
     }
     disableButton("save");
     disableButton("cancel");
     theForm.submit();
 }

 function dealSubmit(){
	doSubmit();
 }

 /**
  * 验证意见框内容
  */
 function vilidateOption(){
	//验证意见长度,最大长度为4000
	if($("#attitudeOp").val().length > 4000){
		$.alert($.i18n('infosend.alert.maxOptionLength'));
		return false;
	}
	return true;
 }
 
 function addOne(n){
	    return parseInt(n)+1;
	}
 var submitCount=0;
 function doSubmit(){
	
	//意见态度
	var childrenPageAttitude =document.getElementsByName("attitude");
	if(childrenPageAttitude){
		for(var i=0;i<childrenPageAttitude.length;i++){
			if(childrenPageAttitude[i].checked==true){
				$("#attitudeFlag").val(document.getElementsByName("attitude")[i].value);
				$("#attitudeOp").val($("#contentOP").val());
			}
		}
	}

	//验证处理意见是否必填
	 if(_nodePolicyOpinionPolicy == "1"){//必填
		 if($("#attitudeOp").val() == ""){
			 $.alert($.i18n('infosend.alert.notNullOption'));
			 return false;
		 }
	 }

	//验证文单信息
	if(validateGovForm()) {
	    return false;
	}

	if(!vilidateOption()){
		return false;
	}

	var isArchive=$("#isArchive");
	if(isArchive && isArchive[0] && isArchive[0].checked){// 假设选择了处理后归档，则判断是否选择了文件路径
		 var folderId=$("#folderId").val();
		 if(folderId==''){
			 alert($.i18n('infosend.listInfo.alert.selectArchivePath'));//请选择归档路径！
			 return ;
		 }
	}
	 //此处用来防止重复提交，连续点击提交，会将此处置灰
	  //重复提交检验，点的太快了disable也不管用
	    submitCount = addOne(submitCount);
	    if(parseInt(submitCount)>=2){
		  submitCount=0;
	      return false;
	    }
    //optionType=3退回时办理人选择意见覆盖方式,其他情况保留最后意见
	//optionType=4退回时办理人选择意见覆盖方式,其他情况保留所有意见
	//affairState==5 Affair的state取消：该情况取消。OA-49715 意见绑定在同一个框中，当第3个处理节点回退了，第1个节点取回后提交，提示意见保留方式了，应该不提示
	//affairState==6 Affair的state回退
	//affState=16 Affair的subState被指定回退
	if(!isOutOpinions && (optionType=='3' || optionType=='4') && (stepBackAffairState=='6' || subState=='16' || subState=='2')) {
			chooseStepBackDialog = $.dialog({
		        url:  _ctxPath + "/info/info.do?method=openChooseStepBackWayDialog",
		        width: 300,
		        height: 200,
		        title: $.i18n('infosend.listInfo.pleaseSelect'),//请选择
		        id:'chooseStepBackDialog',
		        transParams:window,
		        targetWindow:getCtpTop(),
		        closeParam:{
		            show:true,
		            autoClose:false,
		            handler:function(){
		            	chooseStepBackDialog.close();
		            }
		        },
		        buttons: [{
		            id : "okButton",
		            btnType : 1,//按钮样式
		            text: $.i18n("common.button.ok.label"),
		            handler: function () {
		            	var choose = chooseStepBackDialog.getReturnValue();
		            	if(choose) {
		            		chooseStepBackDialog.close();
		            		$("#stepBackWay").val(choose);
		            		formSubmit();
		            	}
		           }
		        }, {
		            id:"cancelButton",
		            text: $.i18n("common.button.cancel.label"),
		            handler: function () {
		            	chooseStepBackDialog.close();
		            }
		        }]
		    });
	} else {
		var info = new infoManager();
		var flag=info.deleteUpdateObjAndIsAffairEnd(summaryId,affairId);
		if(flag==true){
			_resubmitMessage = $.messageBox({
			    'type': 0,
			    'msg': $.i18n('infosend.alert.repeatDeal', subject),//subject已经被处理!
			    'imgType':2,
			     ok_fn: function () {
			    	 try {
			    		 closeInfoDealPage("listInfoPending");
			    	 } catch(e) {
			    		 message.close();
			    	 }
			     }
			});
		}else{
			formSubmit();
		}

	}

}


 function formSubmit() {
		preSendOrHandleWorkflow(window,_summaryItemId,_contextProcessId,_summaryProcessId,activityId, _currentUserId,_contextCaseId,accountId,"","info",$("#process_xml").val(),window,-1,submitFunc);
 }
 function submitFunc(){
	 var lockWorkflowRe = checkWorkflowLock(_summaryProcessId, _currentUserId,14);
     if(lockWorkflowRe[0] == "false"){
         $.alert(lockWorkflowRe[1]);
         enableOperation();
         return;
     }

	 if (!isAffairValid(affairId)) return;
	  $("#bodyType").val(getBodyType($("#contentType").val()));
	 /**通过组件保存正文**/
	  $("#viewState").val("1");
	  if ($("#contentType").val()=='10' || hasOffice($("#contentType").val(), true)==true) {
			  saveOrUpdate({
				   needSubmit:true
			   });
	  }
	   //alert($("#attActionLogDomain").html());
	   var url =_ctxPath+"/info/infoDetail.do?method=transFinishWorkItem";
		var domains =[];
	   	domains.push("colSummaryData");
	   	domains.push("workflow_definition");
	   	domains.push("govFormData");
	   	domains.push("attFileDomain1");
	   	domains.push("assDocDomain1");
	   	domains.push("comment_deal");
	   	domains.push("trackDiv_detail");

	   	if($("#attModifyFlag").val()=="1") {
	   		domains.push("assDocDomain");
		   	domains.push("attFileDomain");
		   	$("#attFileDomain").html("");
		   	$("#assDocDomain").html("");
		   	domains.push('attActionLogDomain');
	   		saveAttachmentPart("assDocDomain");
		    saveAttachmentPart("attFileDomain");

	   	}
	   	saveAttachmentPart("attFileDomain1");
	    saveAttachmentPart("assDocDomain1");

	   	$("#center").jsonSubmit({
		    domains : domains,
		    debug : false,
		    action:url,
		    callback: function(data){
		    	if(_resubmitMessage && _resubmitMessage.close){//关闭快速点击提交时出现的 重复提交提示
		    		_resubmitMessage.close();
		    	}
		    	closeInfoDealPage("listInfoPending");
	        }
	    });
 }
 function infoStepStop(){
	 var lockWorkflowRe = lockWorkflow(_summaryProcessId, _currentUserId, 11);
     if (lockWorkflowRe[0] == "false" ){
         $.alert(lockWorkflowRe[1]);
         return ;
     }
     if(confirm($.i18n('collaboration.confirmStepStopItem'))){
    	 doInfoStepStop();
     }
 }
 function doInfoStepStop(){
	 var url =_ctxPath+"/info/infoDetail.do?method=stepStop";
     var domains =[];
  	 domains.push("colSummaryData");
  	 domains.push("workflow_definition");
  	 $("#center").jsonSubmit({
         domains : domains,
         action:url,
         debug : false,
         callback: function(data){
        	 closeInfoDealPage("listInfoPending");
           }
     });

 }

 function infoStepBack(){
	 doInfoStepBack();
 }
 function doInfoStepBack(){
    var lockWorkflowRe = lockWorkflow(_summaryProcessId, _currentUserId, 9);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        return;
    }
	 var url =_ctxPath+"/info/infoDetail.do?method=stepBack";
     var domains =[];
  	 domains.push("colSummaryData");
  	 domains.push("workflow_definition");
  	 $("#center").jsonSubmit({
         domains : domains,
         action:url,
         debug : false,
         callback: function(data){
        	 closeInfoDealPage("listInfoPending");
           }
     });

 }

 function doZcdb(obj) {
	 var lockWorkflowRe = checkWorkflowLock(_summaryProcessId, _currentUserId,14);
     if(lockWorkflowRe[0] == "false"){
       $.alert(lockWorkflowRe[1]);
       enableOperation();
       return;
     }
	//意见态度
		var childrenPageAttitude =document.getElementsByName("attitude");
		if(childrenPageAttitude){
			for(var i=0;i<childrenPageAttitude.length;i++){
				if(childrenPageAttitude[i].checked==true){
					$("#attitudeFlag").val(document.getElementsByName("attitude")[i].value);
					$("#attitudeOp").val($("#contentOP").val());
				}
			}
		}

		if(!vilidateOption()){
			return false;
		}

		 $("#bodyType").val(getBodyType($("#contentType").val()));
		 $("#viewState").val("1");
		//验证文单信息
		if(validateGovForm()) {
			return false;
		}

		/**通过组件保存正文**/
		if ($("#contentType").val()=='10' || hasOffice($("#contentType").val(), true)==true) {
				saveOrUpdate({
					needSubmit:true
				});
		}
	// 保存当前处理人所提交处理意见所带的附件
	// saveAttachment();

	  $("#attFileDomain1").html("");
	  $("#assDocDomain1").html("");

	var url =_ctxPath+"/info/infoDetail.do?method=doZCDB";
	var domains =[];
  	domains.push("colSummaryData");
  	domains.push("workflow_definition");
  	domains.push("govFormData");
  	domains.push('trackDiv_detail');
  	domains.push('attActionLogDomain');
  	domains.push("comment_deal");
   	if($("#attModifyFlag").val()=="1") {
   		domains.push("assDocDomain");
	   	domains.push("attFileDomain");
	   	$("#attFileDomain").html("");
	   	$("#assDocDomain").html("");
   		saveAttachmentPart("assDocDomain");
	    saveAttachmentPart("attFileDomain");
   	}
   	domains.push("attFileDomain1");
   	domains.push("assDocDomain1");
   	saveAttachmentPart("attFileDomain1");
    saveAttachmentPart("assDocDomain1");
	$("#center").jsonSubmit({
        domains : domains,
	    action:url,
	    debug : false,
	    callback: function(data) {
	    	closeInfoDealPage("listInfoPending");
        }
    });
}
	// 处理时保存修改的报送单
	function saveInfoForm() {
	 	document.theform.action = _ctxPath+"/info/infoDetail.do?method=updateFormData";
	 /** * */
	 	var domains =[];
	 	domains.push("colSummaryData");
	 	domains.push("govFormData");
	 	domains.push("attachment2TR" + commentId);
	 	domains.push("attachmentTR" + commentId);

	 	$("#center").jsonSubmit({
	        domains : domains,
	        debug : false,
	        callback: function(data){
	          	   // location.href =
					// "infolist.do?method=listInfoSend&listType=${param.listType}";
	          }
	    });
	  /* *** */
	// var retData=ajaxFormSubmit(document.theform);

	 }
	 function initCaseProcessXML(){
			if(isLoadProcessXML == false){
				try {
					var requestCaller = new XMLHttpRequestCaller(null, "ajaxColManager", "getXML", false, "POST");
					requestCaller.addParameter(1, "String", caseId);
					requestCaller.addParameter(2, "String", processId);
					var processXMLs = requestCaller.serviceRequest();
					if(processXMLs){
						caseProcessXML = processXMLs[0];
						caseLogXML = processXMLs[1];
						caseWorkItemLogXML = processXMLs[2];
						document.getElementById("process_xml").value = caseProcessXML;
						document.getElementById("process_desc_by").value = "xml";
					}
				}
				catch (ex1) {
				}
				isLoadProcessXML = true;
			}
		}
	function ajaxFormSubmit(formObj) {
		var AjaxParams=new AjaxParameter();
		var xmlRequest=getHTTPObject();
		var _queryString=AjaxParams.FormToAjaxParameter(formObj);
		xmlRequest.open("post",formObj.action,false);
		xmlRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlRequest.send(_queryString);
		if (xmlRequest.readyState == 4) {
			if (xmlRequest.status == 200) {
				var returnValue = xmlHandle(xmlRequest.responseXML);
				if(returnValue==null) {
					returnValue=xmlRequest["responseText"];
					if(returnValue.search("<")>0) {
						returnValue=returnValue.substr(returnValue.search("<"));
						returnValue=getXMLDoc(returnValue);
						returnValue = xmlHandle(returnValue);
					} else {
						return returnValue;
					}
				}
				if(!returnValue) {
					returnValue = xmlRequest.responseTEXT;
				}
				return returnValue;
			} else {
				return false;
			}
		}
		return false;
	}


	//将所有操作置为可用状态
	 function enableOperation(){
	  //提交
	  $("#_dealSubmit").enable();
	  //存为草稿
	  $('#_dealSaveDraft').enable();
	  //暂存待办
	  $('#_dealSaveWait').enable();
	  //态度
	  $("input[name='attitude']").enable();
	  //加签
	  $("#_dealAddNode_a,#_commonAddNode_a").enable();
	  //知会
	  $("#_dealAddInform_a,#_commonAddInform_a").enable();
	  //当前会签
	  $("#_dealAssign_a,#_commonAssign_a").enable();

	  //多级会签
	  $("#_moreAssign").enable();

	  //减签
	  $("#_dealDeleteNode_a,#_commonDeleteNode_a").enable();
	  //回退
	  $("#_dealStepBack_a,#_commonStepBack_a").enable();
	  //转发
	  $("#_dealForward_a,#_commonForward_a").enable();
	  //终止
	  $("#_dealStepStop_a,#_commonStepStop_a").enable();
	  //撤销流程
	  $("#_dealCancel_a,#_commonCancel_a").enable();
	  //修改附件
	  $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").enable();
	  //签章
	  $("#_commonSign_a,#_dealSign_a").enable();
	  // 指定回退
	  $("#_dealSpecifiesReturn_a").enable();
	  //修改正文
	  $('#_commonEditContent_a,#_dealEditContent_a').enable();
	  //督办设置开始
	  $("#_commonSuperviseSet_a,#_dealSuperviseSet_a").enable();
	  //转事件
	     $("#_dealTransform_a,#_commonTransform_a").enable();
	  //意见隐藏
	  $("#isHidden").enable();
	  //跟踪
	  $("#isTrack").enable();
	  //处理后归档
	  $('#pigeonholeSpan').enable();
	  //常用语
	  $('#cphrase').enable();
	  //更多
	  $('#moreLabel').enable();
	  //消息推送
	  $('#pushMessageButton').enable();
	  //关联文档
	  $('#uploadRelDocID').enable();
	  //附件
	  $('#uploadAttachmentID').enable();
	  //通过并发布
	  $('#_dealPass1').enable();
	  //不通过
	  $('#_dealNotPass').enable();
	  //审核通过
	  $('#_auditPass').enable();
	  //审核不通过
	  $('#_auditNotPass').enable();
	  //核定通过
	  $('#_vouchPass').enable();
	  //核定不通过
	  $('#_vouchNotPass').enable();
	 }
	 //将所有操作置为不可用
	 function disableOperation(){
	  //提交
	  $("#_dealSubmit").disable();
	  //存为草稿
	  $('#_dealSaveDraft').disable();
	  //暂存待办
	  $('#_dealSaveWait').disable();
	  //态度
	  $("input[name='attitude']").disable();
	  //加签
	  $("#_dealAddNode_a,#_commonAddNode_a").disable();
	  //知会
	  $("#_dealAddInform_a,#_commonAddInform_a").disable();
	  //当前会签
	  $("#_dealAssign_a,#_commonAssign_a").disable();

	  //多级会签
	  $("#_moreAssign").disable();

	  //减签
	  $("#_dealDeleteNode_a,#_commonDeleteNode_a").disable();
	  //回退
	  $("#_dealStepBack_a,#_commonStepBack_a").disable();
	  //转发
	  $("#_dealForward_a,#_commonForward_a").disable();
	  //终止
	  $("#_dealStepStop_a,#_commonStepStop_a").disable();
	  //撤销流程
	  $("#_dealCancel_a,#_commonCancel_a").disable();
	  //修改附件
	  $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").disable();
	  //签章
	  $("#_commonSign_a,#_dealSign_a").disable();
	  // 指定回退
	  $("#_dealSpecifiesReturn_a").disable();
	  //修改正文
	  $('#_commonEditContent_a,#_dealEditContent_a').disable();
	  //督办设置开始
	  $("#_commonSuperviseSet_a,#_dealSuperviseSet_a").disable();
	  //转事件
	     $("#_dealTransform_a,#_commonTransform_a").disable();
	  //意见隐藏
	  $("#isHidden").disable();
	  //跟踪
	  $("#isTrack").disable();
	  //处理后归档
	  $('#pigeonholeSpan').disable();
	  //常用语
	  $('#cphrase').disable();
	  //更多
	  $('#moreLabel').disable();
	  //消息推送
	  $('#pushMessageButton').disable();
	  //关联文档
	  $('#uploadRelDocID').disable();
	  //附件
	  $('#uploadAttachmentID').disable();
	  //通过并发布
	  $('#_dealPass1').disable();
	  //不通过
	  $('#_dealNotPass').disable();
	  //审核通过
	  $('#_auditPass').disable();
	  //审核不通过
	  $('#_auditNotPass').disable();
	  //核定通过
	  $('#_vouchPass').disable();
	  //核定不通过
	  $('#_vouchNotPass').disable();
}

// 将‘提交’按钮由'禁用'状态改为'可用'
 function releaseApplicationButtons(){
    enableOperation();
    setButtonCanUseReady();
 }

 /**
	 * 示例代码 所保护字段
	 * DocForm.SignatureControl.FieldsList="XYBH=协议编号;BMJH=保密级别;JF=甲方签章;HZNR=合作内容;QLZR=权利责任;CPMC=产品名称;DGSL=订购数量;DGRQ=订购日期"
	 */
 function getProjectField4Form(){
	 var projectArr=new Array();
     var projectData= "";
	 var projectValue= "";
     var ff = new Properties();
     var form  = componentDiv.getFieldVals4hw();
     projectArr.push(form.displayStr);
     projectArr.push(form.valueStr);
     return projectArr;
 }

 /**
	 * 1、HTML编辑状态不能盖章 2、对修改正文的地方增加限制：已经加盖了专业签章的地方不能修改正文 3、表单数据域保护
	 */
 function openSignature(){
  alert("签章");
 }
/* function popupContentWin(){
   componentDiv.checkOpenState();
   componentDiv.fullSize();
 }*/

 function downloadAttrList(fileUrl,uploadTime,fileName,fileType,v){
   var url=_ctxPath + "/fileDownload.do?method=download&v="+v+"&fileId="+fileUrl+"&createDate="+uploadTime+"&filename="+encodeURIat(fileName);
   if($.trim(fileType)!==""){
     url+="."+fileType;
   }
   $("#downloadFileFrame").attr("src",url);
 }

  /**
	 * 修改完流程，解除流程同步锁
	 */
  function colDelLock(affairId){
    if(typeof(colManager) == 'function'){
        var cm = new colManager();
        cm.colDelLock(affairId);
    }
  }

  /**
	 * 向具体位置中增加附件
	 */
  function addAttachmentPoiDomain(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone, description, extension, icon, poi, reference, category, onlineView, width, embedInput) {
	  canDelete = canDelete == null ? true : canDelete;
    needClone = needClone == null ? false : needClone;
    description = description ==null ? "" : description;
    if(attachDelete != null) canDelete = attachDelete;
    if(fileUrl == null){
      fileUrl=filename;
    }
    var attachment = new Attachment('', '', '', '', type, filename, mimeType, createDate, size, fileUrl, description, needClone,extension,icon, false);
    attachment.showArea=poi;
    attachment.embedInput=embedInput;

    fileUploadAttachments.put(fileUrl, attachment);
    showAtachmentObject(attachment, canDelete, null);
    // 更新关联文档隐藏域
    var file=attachment;
    if(file.type==2  && $("#"+file.embedInput).size()>0){
        var assArray =new Array();
        if($("#"+file.embedInput).attr("value")){
          assArray=$("#"+file.embedInput).attr("value").split(",");
        }

        if(!assArray.contains(file.fileUrl)){
          assArray.push(attachment.fileUrl);
        }
        $("#"+file.embedInput).attr("value", assArray);
    }
    showAtachmentTR(type,'',poi);
    if(attachCount)
      showAttachmentNumber(type,attachment);
    if(typeof(currentPage) !="undefined" && currentPage== "newColl"){
      addScrollForDocument();
    }
  }

function saveAttachmentActionLog(){
  if(typeof(attActionLog) != 'undefined' && attActionLog){
      var result = "";
      var attLogListObj=$("#attActionLogDomain");
      if(attActionLog.logs != null && typeof(attActionLog.logs) != 'undefined' ){
          for(var i = 0 ; i< attActionLog.logs.size();i++){
        	  var attObj=attActionLog.logs.get(i);
        	  if(!checkIsExist(attLogListObj,attObj)){
        		  result += attActionLog.logs.get(i).toInput();
        	  }
          }
      }
      $("#attActionLogDomain").append($(result));
  }
}
// 检查当前的attActionLog是否已经记录了这个附件
function checkIsExist(attLogListObj,attObj){
	var attTitle=attObj.des;
	for(var i=0;i<attLogListObj.size();i++){
		var attLogObj=attLogListObj.get(i);
		var attLogHTML="";
		if(attLogObj&&attLogObj.innerHTML){
			attLogHTML=attLogObj.innerHTML;
		}
		if(attLogHTML==""&&attLogObj&&attLogObj.outerHTML){
			attLogHTML+=attLogObj.outerHTML;
		}
		if(attLogHTML&&attLogHTML.indexOf(attTitle)!=-1){
			return true;
		}
	}
	return false;
}
/* 附件相关方法 -----------------------end */


function clearAttOrDocShowArea(id){
  var showDiv = document.getElementById(id);
  if(showDiv){
    showDiv.innerHTML="";
  }
}
function hideTr(attachmentTrId){
  var attachmentTr = document.getElementById(attachmentTrId);
  if(attachmentTr){
    attachmentTr.style.display = "none";
  }
}

function transmitColById(data){
  alert("transmitColById");
}

// 搜索
function doSearch(flag){
  if(typeof(flag)=='undefined' || flag == null){
      flag = 'forward';
  }
  var t = document.getElementById('searchText').value;
  componentDiv.$.content.commentSearchCreate(t, flag);
  return false;
}
function enterKeySearch(e) {
  var c;
  if ("which" in e) {
    c = e.which;
  } else if ("keyCode" in e) {
    c = e.keyCode;
  }
  if (c == 13) {
    doSearch("forward");
  }
}

function advanceViews(flag,obj) {
  alert("advanceViews");
}

// 跟踪
function setTrack(){
  alert("跟踪");
}

/**
 * 查看属性设置信息 弹出对话框
 */
function attributeSettingDialog(affairId){
	var dialog = $.dialog({
        url : _ctxPath+'/info/infoDetail.do?method=getAttributeSettingInfo&affairId='+affairId,
        width : 500,
        height : 320,
        targetWindow:openType,
        title : $.i18n('collaboration.common.flag.findAttributeSetting'),  // 查看属性状态设置
        buttons : [{
            text :$.i18n('collaboration.dialog.close'),// 关闭
            handler : function() {
              dialog.close();
            }
        }]
    });
}
function showDetailLogFunc(){
  showDetailLogDialog(summaryId,_contextProcessId);
}
/**
 * 明细日志 弹出对话框
 */
function showDetailLogDialog(summaryId,processId){
  alert("明细日志");
}
/**
 * 明细日志 弹出对话框
 */
function showDetailLogDialog(summaryId,processId){
  var dialog = $.dialog({
      url : _ctxPath+'/detaillog/detaillog.do?method=showDetailLog&summaryId='+summaryId+'&processId='+processId,
      width : 800,
      height : 400,
      title :$.i18n('collaboration.sendGrid.findAllLog'), // 查看明细日志
      targetWindow:openType,
      buttons : [{
          text : $.i18n('collaboration.dialog.close'),
          handler : function() {
            dialog.close();
          }
      }]
  });
}

// 弹出 更多操作
function showMessageBox2() {
  // TODO
    alert("showMessageBox2");
}

// 刷新流程图
function refreshWorkflow(callBackObj){
	  // 加签的情况
	  if(callBackObj && (callBackObj.type == 1
	      || callBackObj.type == 2
	      || callBackObj.type == 3
	      || callBackObj.type == 4)){
	    summaryChange();
	  }
	  showWorkFlowView();
	  var isTemplate = isFromTemplate;

	  var wfurl = _ctxPath+"/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate="+isTemplate+"&scene="+_scene+"&processId="+_contextProcessId+"&caseId="+_contextCaseId+"&currentNodeId="+activityId+"&appName=info&formMutilOprationIds="+operationId;
	     // 加载流程页面 待办、已办、已发、
	     if(affairState == '1'){// =-待发
	          wfurl += "&currentUserName="+_currentUserName+"&currentUserId="+_currentUserId;
	     }else{
	         if((affairState == '2'||(affairState == '4' && isCurrentUserSupervisor=='true'))
	             && isFinish!="true" && openFrom!='glwd'&& openFrom!='subFlow' && summaryReadOnly!=='true'){
	             wfurl+="&showHastenButton="+_showHastenButton;
	         }
	     }
	  $("#iframeright").attr("src",encodeURI(wfurl));

}

function superviseSettingFunc(){
  // TODO
  alert("superviseSettingFunc");
}

// 刷新流程图 （用于修改流程时回调）
var isWorkflowChange = false;
function summaryChange(){
  isFormSubmit = false;
  isWorkflowChange = true;
  var dialogDealColl = getCtpTop().dialogDealColl;
  if(dialogDealColl){
    dialogDealColl.isWorkflowChange = true;
  }
  if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']) {
		window.parentDialogObj['dialogDealColl'].isWorkflowChange = true;
  }
  if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
    $.confirmClose();
  }
}
// 流程图展现
function showWorkFlowView(){
    $("#form_view_li").removeClass("current");
    $("#content_view_li").removeClass("current");
    $("#workflow_view_li").addClass("current");
    $("#content_workFlow").css("overflow","");
    $("#display_content_view").hide();
    $("#contentDiv").hide();
    $("#iframeright").show();
    $("#componentDiv").hide();
    // 1.如果是 督办未结办时 显示修改流程按钮
    // 2.如果是已办列表中当前用户是督办人，并且流程未结束 显示修改流程按钮
    if((isSupervise||isCurSuperivse) && !isFinish){
        $("#show_edit_workFlow").show();
        var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
        var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
        if(attachment == 0 && realDoc == 0){
          $('.stadic_body_top_bottom').css('top','120px');
        }else if(attachment != 0 || realDoc != 0){
          $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+5);
        }
    }
}

// 文单展现
function showFormView(){
  $("#workflow_view_li").removeClass("current");
  $("#content_view_li").removeClass("current");
  $("#form_view_li").addClass("current");
  $("#content_workFlow").css("overflow","auto");
  $("#iframeright").hide();
  $("#contentDiv").hide();
  $("#componentDiv").show();
  $("#display_content_view").show();
  // 将'修改流程'按钮隐藏,并且把样式上移
  $("#show_edit_workFlow").hide();
  var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
  var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
  if(attachment == 0 && realDoc == 0){
    $('.stadic_body_top_bottom').css('top','90px');
  }else if(attachment != 0 || realDoc != 0){
      $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
  }
  summaryHeadHeight();
}
// 加签
function addNode(){
    // 指定回退状态
    insertNode(_contextItemId,_contextProcessId,activityId,performer,_contextCaseId,"info",false,"审核",flowPermAccountId,refreshWorkflow,summaryId,affairId);
 }
// 减签
// 调用工作流减签接口
function deleteNodeFunc(){
	deleteNode(_contextItemId,_contextProcessId,activityId,performer,_contextCaseId,refreshWorkflow,summaryId,affairId,refreshWorkflow);
}
// 当前会签
function currentAssign() {
    // 指定回退状态
    assignNode(_contextItemId,_contextProcessId,
    		activityId, _currentUserId,
    		_contextCaseId, "info",
            false, $("#nodePolicy").val(), accountId,refreshWorkflow,
            summaryId,affairId);
}
// 多级会签
function multistageSignInfo(){
	multistageSign(
			"info",
			summaryId,
			affairId,
			_currentUserId,
			_contextItemId,
			_contextProcessId,
			activityId,
	        _currentUserId,
	        _currentUserName,
	        loginAccount,
	        flowPermAccountId,
	        null,
	        null,
	        departmentId,refreshWorkflow);
}

function modifyAttFunc(){
    // 指定回退状态
    updateAtt();

}
function updateAtt(){
   var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, 16);
     if(lockWorkflowRe[0] == "false"){
       $.alert(lockWorkflowRe[1]);
        return;
     }
	// 取得要修改的附件
    var attachmentList = new ArrayList();
	var keys = fileUploadAttachments.keys();
	// 过滤非正文区域的附件
	var keyIds=new ArrayList();
	for(var i = 0; i < keys.size(); i++) {
		var att = fileUploadAttachments.get(keys.get(i));
		if(att.showArea=="showAttFile"||att.showArea=="Doc1"){
			attachmentList.add(att);
			keyIds.add(keys.get(i));
		}
	}
	editAttachments(attachmentList,summaryId,summaryId,'1',keyIds);
}
//弹出修改附件页面
function editAttachments(atts, reference, subReference, category, keyIds) {
	if (attActionLog == null) {
		attActionLog = new AttActionLog(reference, subReference, null, atts);
	}
	reference = reference || "";
	subReference = subReference || "";
	var dialog = $.dialog({
		id : "showForwardDialog",
		url : _ctxPath
				+ "/genericController.do?ViewPage=apps/collaboration/fileUpload/attEdit&category="
				+ category + "&reference=" + reference
				+ "&subReference=" + subReference,
		title : "修改附件",
		targetWindow : getCtpTop(),
		transParams : {
			attActionLog : attActionLog
		},
		width : 550,
		height : 430,
		buttons : [
			{
				id : "okButton",
				btnType : 1,//按钮样式
				text : $.i18n("common.button.ok.label"),
				handler : function() {
					var retValue = dialog.getReturnValue();
					if (retValue) {
						var attachmentList = new ArrayList();
						var inst = retValue[0].instance;
						for (var i = 0; i < inst.length; i++) {
							var att = copyAttachment(inst[i]);
							att.onlineView = false;
							attachmentList.add(att);
						}
						var logList = new ArrayList();
						inst = retValue[1].instance;
						if (inst.length == 0) {
							dialog.close();// 关闭窗口
							return false;
						}
						for (var i = 0; i < inst.length; i++) {
							var att = copyActionLog(inst[i]);
							logList.add(att);
						}
						var save = saveEditAttachments(logList,
								attachmentList);
						if (!save) {
							dialog.close();// 关闭窗口
							return null;
						}
						var result = attActionLog.editAtt;
						if(result){
					        // 标记协同内容有变化，关闭页面时需进行判断
						    summaryChange_content();
							// 将修改后的附件，与本地更新。
							var toShowAttTemp=new ArrayList();
							for(var i = 0; i < theToShowAttachments.size(); i++) {
								var att  = theToShowAttachments.get(i);
								toShowAttTemp.add(att);
							}
							for(var i = 0; i < toShowAttTemp.size(); i++) {
								var att  = toShowAttTemp.get(i);
								if(att.showArea!="showAttFile"&&att.showArea!="Doc1"){
									theToShowAttachments.remove(att);
								}
							}
							updateAttachmentMemory(result,summaryId,summaryId,'');

						}else{
							theToShowAttachments=attachmentList;
							//取消修改附件解锁
							releaseWorkflowByAction(summaryId, _currentUserId, 16);
						}
						try{
							clearAttOrDocShowArea("attachmentNumberDivshowAttFile");
							clearAttOrDocShowArea("attachmentAreashowAttFile");
							clearAttOrDocShowArea("attachment2NumberDivDoc1");
							clearAttOrDocShowArea("attachment2AreaDoc1");
							hideTr("attachmentTRshowAttFile");
							hideTr("attachment2TRDoc1");
						}catch(e){
						}
						for(var k=0;k<keyIds.size();k++){
							fileUploadAttachments.remove(keyIds.get(k));
						}
						for(var i=0;i<theToShowAttachments.size();i++){
							var att = theToShowAttachments.get(i);
							var poi;
							if(att.type==0){
								poi='showAttFile';
							}else if(att.type==2){
								poi='Doc1';
							}
							addAttachmentPoiDomain(att.type, att.filename, att.mimeType, att.createDate ? att.createDate.toString() : null, att.size,
									att.fileUrl, false, false,
									att.description, att.extension, att.icon, poi, att.reference,
									att.category, true);
						}
						$("#attFileDomain").html("");
						$("#assDocDomain").html("");
						saveAttachmentPart("attFileDomain");
						saveAttachmentPart("assDocDomain");
						saveAttachmentActionLog();

						$("#attModifyFlag").val('1');

						summaryHeadHeight();
					}
					dialog.close();// 关闭窗口
				},
				OKFN : function() {
					dialog.close();
				}
			}, {
				id : "cancelButton",
				text : $.i18n("common.button.cancel.label"),
				handler : function() {
					dialog.close();
				}
			} ]
	});
}
// 正文展现
function showContentView(){
	var contentEditState = $("#contentEditState").val();
	if(_contentType && _contentType != "10"){
	    var ocxObj = officeEditorFrame.document.getElementById("WebOffice");
	    //关闭痕迹
	    ocxObj.editType="0,0"; 
		fullSize();
	}else {// 标准正文
		$("#content_workFlow").css("overflow","");
		'&rightId='+rightId+'&contentEditState='+contentEditState;
		$("#workflow_view_li").removeClass("current");
		$("#form_view_li").removeClass("current");
		$("#content_view_li").addClass("current");
		$("#iframeright").hide();
		$("#componentDiv").hide();
		$("#contentDiv").show();
		$("#display_content_view").show();
		// 将'修改流程'按钮隐藏,并且把样式上移
		$("#show_edit_workFlow").hide();
		var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
		var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
		if(attachment == 0 && realDoc == 0){
		  $('.stadic_body_top_bottom').css('top','90px');
		}else if(attachment != 0 || realDoc != 0){
		    $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
		}
		summaryHeadHeight();
		// window.parent.frames[3].$("#cc").css('height',((document.documentElement.scrollHeight
		// - $("#summaryHead").height())-12) + "px");
	}
}

// 督办方法
function superviseFunc(){
    alert("superviseFunc");
}

// 正文保存失败
function mainbody_callBack_failed(){
  enableOperation();
  setButtonCanUseReady();
  return;
}

// 将标题部分高度改为动态值
function summaryHeadHeight(){
   $("#content_workFlow").css("top",$("#summaryHead").height()+10);
}

function getParentWindow(win){
  if(win.dialogArguments){
    return win.dialogArguments;
  }else{
    return win.opener || win;
  }
}

function colseProce(){
  if (proce==""){
      setTimeout(colseProce,300);
  }else{
      proce.close();
  }
}

function setIframeHeight_IE7(){
    setTimeout(function(){
            $("#content_workFlow").height($("#center").height()-$("#summaryHead").height()-10);
            $("#iframeright").height($("#content_workFlow").height());
            $("#componentDiv").height($("#content_workFlow").height());
    },0);
}

//ajax判断事项是否可用。
function isAffairValid(affairId){
  var cm = new colManager();
  var msg = cm.checkAffairValid(affairId);
  if($.trim(msg) !=''){
       $.messageBox({
           'title' : $.i18n('collaboration.system.prompt.js'), //系统提示
           'type': 0,
           'imgType':2,
           'msg': msg,
          ok_fn:function(){
               enableOperation();
               setButtonCanUseReady();
               closeInfoDealPage();
          }
        });

       return false;
  }
  return true;
}

//修改正文
function _modifyText() {
	if(!hasOffice(_contentType)) return;
	summaryChange_content();
	canEdit="true";//正文可修改

	updateInfoContent();
	if(_contentType && _contentType != "10"){//Office正文
		_changeOfficeToEditable();
	}
}

//正文被修改，关闭窗口时弹出提示
function summaryChange_content() {
	if(window.parentDialogObj && window.parentDialogObj['dialogDealColl']) {
		window.parentDialogObj['dialogDealColl'].isWorkflowChange = true;
	}
	if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
		confirmClose();
	}
}

function confirmClose(){
	var mute = arguments.length > 0;
    document.body.onbeforeunload = function(){
      // submit时屏蔽提示
      if(!mute){
        window.event.returnValue = "您修改了正文内容，离开当前页面后将会丢失修改的内容，确认关闭当前页面吗？";
      }
    };
}

//提交或暂存待办时要取消离开弹出框
function cancelConfirm(){
	document.body.onbeforeunload = null;
}




/**
 * 让Office可编辑
 */
function _changeOfficeToEditable(){
	if(hasLoadOfficeFrameComplete()){
		ModifyContent();
//	    var ocxObj=officeEditorFrame.document.getElementById("WebOffice");
//	    if(ocxObj.editType != "1,0"){
//	    	ocxObj.editType="1,0";
//	    	ocxObj.EnableMenu(officeEditorFrame.window.getOfficeLanguage("menu_OpenFile"));//打开本地文件按钮
//	    }
    }else{
    	setTimeout(_changeOfficeToEditable, "500");
    }
}

