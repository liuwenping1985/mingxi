function edocFormDisplay() {
	if (v3x.isMac) {
		alert("当前功能不支持非windows系统");
		parent.parent.location.href = "edocController.do?method=listIndex&controller=edocController.do&listType=listPending&edocType="
				+ edocType;
	}

	if (formDisableWarning == "yes") {
	    formDisableWarning = "no";//只提醒一次
		alert(_("edocLang.edoc_form_Disable"));
	}
	canUpdateContent = _canUpdateContent;
	enableButton("send");
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xslt");
	// 34171 320单独控制正文，不控制文单
	try {
	    //设置修复字段宽度的传参
	    window.fixFormParam = {"isPrint" : false, "reLoadSpans" : true};
		initSeeyonForm(xml.value, xsl.value);
	} catch (e) {
		alert(_("edocLang.edoc_form_xml_error") + e);
		disableButton("send");
		window.location.href = window.location.href;
		return false;
	}

	setObjEvent();
	initContentTypeState();
	initBodyType();
	
	var bodyType = document.getElementById("bodyType").value;
	// 控制正文类型菜单置灰与否
	// OA-17720 老功能bug：新建自由收文，调用模版，正文类型应该也是不能修改的才对
	// 20150318新增功能：纸质登记可以放开正文类型修改  yangfan
	if (canUpdateContent == false 
		|| (edocType!='1' && isFromTemplate == true && templateType != 'workflow') 
		|| bodyType=='gd'
	    ||((comm == 'distribute' && isA8PaperRegister != "true") || comm == 'register') 
	    || '${waitRegister_recieveId ne null}'=='true') {
	    
		myBar.disabled("bodyTypeSelector");
		
	}
	
	substituteLogo(logoURL);
	// 初始化公文处理意见，有可能来自回退、撤销的待发流程
	if (typeof (opinions) != "undefined") {
		dispOpinions(opinions, sendOpinionStr);
		// 显示文单签批内容
		initHandWrite();
	}
	confirmSelectPersonSetDefaultValue();
	showEdocMark();
	return false;
}

//跟踪相关函数
function setTrackRadiio(){
    var obj = document.getElementById("isTrack");
    if(obj!=null){
        var all = document.getElementById("trackRange_all");
        var part = document.getElementById("trackRange_part");
        var zdgzryName = document.getElementById("zdgzryName");
        if(obj.checked){
            all.disabled = false;
            part.disabled = false;
            
            all.checked = true;
            zdgzryName.style.display="none";
        }else {
            all.disabled = true;
            part.disabled = true;

            all.checked = false;
            part.checked = false;
            zdgzryName.style.display="none";
        }
    }
}

function setTrackCheckboxChecked(){
    var obj = document.getElementById("isTrack");
    if(obj!=null){
        obj.checked = true;
    }
    var all = document.getElementById("trackRange_all");
    if(all.checked==true){
    	 var partText = document.getElementById("zdgzryName");
    	 partText.style.display="none";
    }else{
    	 var partText = document.getElementById("zdgzryName");
    	 partText.style.display="";
    }
}
function selectPeopleFunTrackNewCol(){
    setTrackCheckboxChecked();
    selectPeopleFun_track();
}
function setPeople(elements){
	var tarckName="";
    var memeberIds = "";
    if(elements){
        for(var i= 0 ;i<elements.length ; i++){
            if(memeberIds ==""){
                memeberIds = elements[i].id;
            }else{
                memeberIds +=","+elements[i].id;
            }
            tarckName+=elements[i].name+",";
        }
        document.getElementById("trackMembers").value = memeberIds;
        trackNameFun(tarckName);
    }
}
//截取跟踪指定人长度
function trackNameFun(res){ 
	var userName="";
	var nameSprit="";
  	userName=res.substring(0,res.length-1);
  	//只显示前三个名字
	  //OA-74898跟踪：公文-拟文，设置指定人跟踪，超过三个人包括三个人数据（人名），全部都放开，不加...
	  //	nameSprit=res.split(",");
	  //	if(nameSprit.length>3){
	  //		nameSprit=res.split(",", 3);
	  //		nameSprit+="...";
	  //	}
  	$("#zdgzryName").attr("title",userName);
	var partText = document.getElementById("zdgzryName");
	partText.style.display="";
	 $("#zdgzryName").val(userName);
}
function unload(summaryId){
    try{
        unlockHtmlContent(summaryId);
    }catch(e){
    }
}

//OA-36095 wangchw登记了纸质公文，在待办中转发文--收文关联新发文，收文处理节点查看有关联链接，处理时回退该流程，发起人在待发中查看有此链接直接发送后已发待办中也有，但是若在待发中编辑没有此链接，发送后也没此链接
function relationSendV(){
  var url = "edocController.do?method=relationNewEdoc&recEdocId="+recEdocId+"&recType="+recType+"&forwardType="+forwardType+"&newDate="+new Date();
  window.relationSendVWin = getA8Top().$.dialog({
      title:' ',
      transParams:{'parentWin':window},
      url: url,
      targetWindow:getA8Top(),
      width:"600",
      height:"600"
  });
//  if (rv == "true") {
//    getA8Top().reFlesh();
//}
}

//puyc  关联收文
function relationRecv(){
        var url = relationUrl;
        if(url == null || url == ""){
        	alert(edoc_resourse_notExist);//alert("资源不存在！");
            }else{
        var rv = v3x.openWindow({
            url: url,
            workSpace: 'yes',
            dialogType: "open"
        });
//        if (rv == "true") {
//            getA8Top().reFlesh();
//        }
            }
    }

function loadRelationButton(){
	var newContactReceive = param_newContactReceive;
	// 管理收文
    //OA-32958 收文转发文，选择新发文关联收文。然后在发文-拟文时保存待发，在待发中编辑，发文关联收文的字样不在了。但是发送以后，在已发中打开，可以关联到收文。
    if(!newContactReceive){
      newContactReceive = _newContactReceive;
    }
    var newContactReceives = "";
    var relationRec = document.getElementById("relationRec");
    var relationSen = document.getElementById("relationSen");

    //BUG20120725011863_G6_v1.0_徐州市元申软件有限公司_公文收文结束转发文，调用模板附件、正文、文单内容丢失
    //调用模板后，数据会丢失，要保持传递过来--start

    if(relationRecd=="haveYes"){//关联收文
      document.getElementById("relationRecd").value = "haveYes";
      relationRec.style.display="block";
     }
    if(relationSend=="haveYes"){//关联发文
      document.getElementById("relationSend").value = "haveYes";
    }
    if(receiveEdocIdFromTemplate!="null"){
      document.getElementById("relationRecId").value = receiveEdocIdFromTemplate;//收文Id
    }
    //调用模板后，数据会丢失，要保持传递过来--end
  
    if(newContactReceive != null){
        
        //OA-33197 收文转发文，先保存待发，然后编辑，发送，页面出异常。但是系统消息显示该公文发送成功了。
        //relationRecId 是从待发编辑中查找发文关联的收文时设置的
        if(!relationRecId) relationRecId = _relationRecId;
        
        document.getElementById("relationRecId").value = relationRecId;//收文Id
        newContactReceives = newContactReceive.split(","); 
        for(var i = 0;i<newContactReceives.length;i++){
        if(newContactReceives[i]=="1"){//关联收文
          document.getElementById("relationRecd").value = "haveYes";
          relationRec.style.display="block";
          }
        if(newContactReceives[i]=="2"){//关联发文
          document.getElementById("relationSend").value = "haveYes";
        }
        //OA-36659  收文转发文，拟文页面有个关联收文，还有个关联发文。点击关联发文，报错。应该没有关联发文，只有关联收文。  
        if(param_edocType == 1 && newContactReceives[i]=="2"){
          relationSen.style.display="block";  
        }
       }
    }   

    //puyc 分发，收文的summaryId，传到分发
    if(recSummaryId != null && recSummaryId != ""){
        document.getElementById("recSummaryIdVal").value = recSummaryId;
        }
  }

function selectDeadline(request,obj,width,height){
	var isChrome=v3x.isChrome;
	if(isChrome){//Chrome浏览器单独处理
		whenstart(request, obj, width, height, 'datetime',null,270, 270,{'callBackFun':callBck});
	}else{
		var now = new Date();//当前系统时间
		whenstart(request, obj, width, height, 'datetime');
		 if(obj.value != ""){
		        var days = obj.value.substring(0,obj.value.indexOf(" "));
		        var hours = obj.value.substring(obj.value.indexOf(" "));
		        var temp = days.split("-");
		        var temp2 = hours.split(":");
		        var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
		        var remind = $("#advanceRemind");
		        var remaindDatetime=ajaxCalcuteNatureDatetime(obj.value,remind[0].value);
		    	var nowDatetime=new Date().format("yyyy-MM-dd HH:mm");
		        if(d1.getTime()<now.getTime()){
		        	alert(edoc_flowtime_validate);
		        }else if(remaindDatetime<nowDatetime){//与提前提醒时间对比
		        	//未设置流程期限或流程期限小于,等于提前提醒时间
		            alert(v3x.getMessage("edocLang.remindTimeLessThanDeadLine"));
		            remind[0].selectedIndex = 0;
		        }
		  }
	}	
}

function callBck(data){
	window.parent.getA8Top().date_win.close();
	if(data != ""){
		var now = new Date();//当前系统时间
        var days = data.substring(0,data.indexOf(" "));
        var hours = data.substring(data.indexOf(" "));
        var temp = days.split("-");
        var temp2 = hours.split(":");
        var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
        var remind = $("#advanceRemind");
        var remaindDatetime=ajaxCalcuteNatureDatetime(data,remind[0].value);
    	var nowDatetime=new Date().format("yyyy-MM-dd HH:mm");
        if(d1.getTime()<now.getTime()){
        	alert(edoc_flowtime_validate);
        }else if(remaindDatetime<nowDatetime){//与提前提醒时间对比
        	//未设置流程期限或流程期限小于,等于提前提醒时间
            alert(v3x.getMessage("edocLang.remindTimeLessThanDeadLine"));
            remind[0].selectedIndex = 0;
        }
    }
}

//G6 V1.0 SP1后续功能_流程期限--start
function selectDateTime(request,obj,width,height){
    var now = new Date();//当前系统时间
    var beforeValue=obj.value;
    whenstart(request,obj, width, height,'datetime');
    
    if(obj.value != ""){
        var days = obj.value.substring(0,obj.value.indexOf(" "));
        var hours = obj.value.substring(obj.value.indexOf(" "));
        var temp = days.split("-");
        var temp2 = hours.split(":");
        var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
        if(d1.getTime()<=(now.getTime()+server2LocalTime)){
            alert(edoc_flowtime_validate);//流程期限不能早于当前系统时间，请重新设置！ 
            obj.value=beforeValue;
            return false;
        }else{
            var deadline = document.getElementById("deadline");
            var isContainCustom=false;
            if(deadline.options.length>0){
                for(var i=0;i<deadline.options.length;i++){
                    if(deadline.options[i].text.length==16){
                        isContainCustom=true;
                        deadline.options[i].selected=true;
                        break;
                    }
                }
            }
            if(isContainCustom){
                var index=deadline.selectedIndex; 
                deadline.options.remove(index);
            }
            var deadlineValue=Math.round((d1.getTime()-now.getTime()-server2LocalTime)/1000/60);
            deadline.options.add(new Option(obj.value,deadlineValue));
            deadline.options[deadline.options.length-1].selected=true;
        }
    }
}

//G6 V1.0 SP1后续功能_流程期限--end

//用于判断表单、附件是否被修改过的方法，保存原始值
function formInitialValue(){

  $("input[id^='my:']").each(function() {
      jQuery(this).attr('_value', jQuery(this).val());
  });
  
  $("select[id^='my:']").each(function() {
      jQuery(this).attr('_value', jQuery(this).val());
  });

  $("textarea[id^='my:']").each(function() {
      jQuery(this).attr('_value', jQuery(this).val());
  });
  
  $("#attachmentArea").attr('_value', $("#attachmentArea").html());
  $("#attachment2Area").attr('_value', $("#attachment2Area").html());

}

function valiDeadAndLcqx(obj){
    //流程期限
    var dl = $("#deadline");
    var remind = $("#advanceRemind");
    var mycal=$("#deadLineDateTimeInput");
    var hiddenObj=$("#deadLineDateTime")[0];
   //流程期限
    if(obj.id=='deadline'){
        var deadLineTime=dl[0].value;
        $("#deadline2").val(deadLineTime);
        //日期计算
        var dateValueStr=getDateTimeValue(deadLineTime);
        if(mycal&&hiddenObj){
            mycal.val(dateValueStr);
            hiddenObj.value=dateValueStr;
        }
        if(getDateTimeValue(remind[0].value) >= getDateTimeValue(dl[0].value) && parseInt(remind[0].value) != 0){
            //未设置流程期限或流程期限小于,等于提前提醒时间
            alert(v3x.getMessage("edocLang.remindTimeLessThanDeadLine")); 
            remind[0].selectedIndex = 0;
            dl[0].selectedIndex = 0;
        }
        if(dl[0].selectedIndex==1){//自定义
            dl.css("width","auto");
            dl.css("float","left");
            $("#deadLineCalender").css("display","block");
            $("#deadLineCalender").parent().css("display","block");//把TD也影藏
            $("#deadLineDateTimeInput").attr("disabled",false);
        }else if(dl[0].selectedIndex==0){//无
            $("#deadLineCalender").css("display","none");
            $("#deadLineCalender").parent().css("display","none");//把TD也影藏
            $("#deadLineDateTimeInput").attr("value","");
            hiddenObj.value="";
            dl.removeAttr("style");
        }else{
        	dl.css("width","auto");
            dl.css("float","left");
            $("#deadLineCalender").css("display","block");
            $("#deadLineCalender").parent().css("display","block");//把TD也影藏
            $("#deadLineDateTimeInput").attr("disabled",true);
        }
    }
    //提醒
    if(obj.id=='advanceRemind'){
    	if(dl[0].selectedIndex==1){//自定义的时候直接取控件上的日期值
            if(mycal){
                if(parseInt(remind[0].value) != 0){
                	var remaindDatetime=ajaxCalcuteNatureDatetime(mycal.val(),remind[0].value);
                	var nowDatetime=new Date().format("yyyy-MM-dd HH:mm");

                	if(remaindDatetime<nowDatetime){
                        //未设置流程期限或流程期限小于,等于提前提醒时间
                        alert(v3x.getMessage("edocLang.remindTimeLessThanDeadLine"));
                        remind[0].selectedIndex = 0;
                    }
                }
            }
        }else{
	        if(parseInt(remind[0].value) != 0 && parseInt(remind[0].value) >= parseInt(dl[0].value)){
	            //未设置流程期限或流程期限小于,等于提前提醒时间
	            alert(v3x.getMessage("edocLang.remindTimeLessThanDeadLine"));
	            remind[0].selectedIndex = 0;
	        }
        }
    }
}

function init_newedoc(){
    _init_();
    var openFrom = parent.parent.openFrom;
    if(typeof(openFrom)!='undefined'){
    	$("#openFrom").val(openFrom);
    }
    var deadLineSelect = $("#deadline");
     $("#deadline option[value='0']").remove();//删除第一项 “无”
     deadLineSelect.prepend("<option value='-2'>"+v3x.getMessage("edocLang.edoc_deadline_custom")+"</option>");  //增加 “自定义”到第一个位置
     deadLineSelect.prepend("<option value='0'>"+v3x.getMessage("edocLang.edoc_deadline_no")+"</option>");  //增加“无”到第一个位置
     //当调用模板的时候，要将流程期限转换成日期值，并赋值给deadlineDatetime
     var mycal = $("#deadLineDateTimeInput");
     var hiddenObj = $("#deadLineDateTime")[0];
     var deadline2=$("#deadline2").val();
     var deadline4tempStr;
     if(deadline2=="-1"||deadline2=="0"||deadline2==""){//流程期限默认值是-1,从待登记中打开是0
         deadLineSelect.val(0);
     }else if(deadline2=="-2"){//-2表示自定义
         deadLineSelect.val(-2);
         deadline4tempStr=$("#deadline4temp").val();
     }
     var isResetRemaind=false;
     // 流程期限
     if (deadLineSelect&&deadLineSelect.length==1) {
        var deadLineTime = deadLineSelect[0].value;
        if(deadLineTime&&deadLineTime!="0"&&deadLineTime!="-2"){
            // 日期计算
            var dateValueStr = getDateTimeValue(deadLineTime);
            if (mycal&&hiddenObj) {
                mycal.val(dateValueStr);
                hiddenObj.value=dateValueStr;
            }
            deadLineSelect.css("width","auto");
            deadLineSelect.css("float","left");
            $("#deadLineCalender").css("display","block");
            $("#deadLineCalender").parent().css("display","block");//把TD也影藏
            $("#deadLineDateTimeInput").attr("disabled",true);
        }else if(deadLineTime!="0"){
        	var deadLineStr=$("#deadLineDateTime").val();
            if(deadLineStr){
                mycal.val(deadLineStr.substring(0,deadLineStr.lastIndexOf(":")));
            }
            if(deadline4tempStr){
                mycal.val(deadline4tempStr);
            }
            if(mycal.val()!=""){
	            deadLineSelect.css("width","auto");
	            deadLineSelect.css("float","left");
	            $("#deadLineCalender").css("display","block");
	            $("#deadLineCalender").parent().css("display","block");//把TD也影藏
	            if(archivedModify){
	            	$("#deadLineDateTimeInput").attr("disabled",true);
	            }
            }else{
            	deadLineSelect.val(0);
            	$("#deadLineCalender").css("display","none");
            	$("#deadLineCalender").parent().css("display","none");//把TD也影藏
            	isResetRemaind=true;
            }
        }
     }
    $("#deadline").bind("change",function(){
        valiDeadAndLcqx(this);
     });
     $("#advanceRemind").bind("change",function(){
        valiDeadAndLcqx(this);      
     });
    //在使用编辑工作流flash的页面，首先清除掉5.0工作流所在框架页面中的 流程相关信息
    clearWorkflowResource(getParentFrame()); 
    if(notOpenSave){
    	//changyi 离开当前页面
        initLeave(edocType);
    }
    edocFormDisplay();
    loadRelationButton();
    formInitialValue();
	
    //快速发文
    var isQuickSend=false;
    if(document.getElementById("isQuickSend")&&document.getElementById("isQuickSend").checked){
    	isQuickSend= true;
    }
    //OA-22567 兼职人员test01的兼职单位将自建流程开关关闭后，调用模板拟文保存待发在编辑，弹出选择模板的窗口
   	//快速发文没有流程
  
    if(!isQuickSend&&selfCreateFlow == false && (archivedModify==null||archivedModify=="") && hasTemplate !="true" && templeteProcessId == ''){//xiangfan 修改 修复设置不允许公文之间流程，拟文 选择个人模板时无限弹出选择模板窗口的错误 GOV-5038
        myBar.disabled("workflow"); 
        openTemplete(templeteCategrory,templete_id == null ? 1 : templete_id);
    }
    
    //G6 V1.0 SP1后续功能_流程期限--start
    if(getSystemProperty == "true"){
	    var deadline=document.getElementById("deadline");
	    if(deadline.disable!=true && finalDeadline > 0 && deadline.value==0 && document.getElementById("deadlineTime").value!=""){
	        var nowValue = finalDeadline;
	        deadline.options.add(new Option(document.getElementById("deadlineTime").value),nowValue);
	        for(var i=0;i<deadline.options.length;i++){
	            if(deadline.options[i].text.length==16){
	                deadline.options[i].selected=true;
	                deadline.options[i].value=nowValue;
	                break;
	            }
	        }
	    }
    }
    //G6 V1.0 SP1后续功能_流程期限--end
    initEdocIe10AutoScroll();
    resizeLayout();
    
    if (isQuickSend){
    	showQuickSend();
        if(document.getElementById("bodyType") && document.getElementById("bodyType").value=='HTML'){
           document.getElementById("fileUrl").disabled="true";
        }	
    }
    if(document.getElementById("isQuickS")){
       if(jsEdocType==0){
         document.getElementById("isQuickS").title = edoc_sendQuick_0_label;
       }else if(jsEdocType==1){
         document.getElementById("isQuickS").title = edoc_sendQuick_1_label;
       }
    }
    
    //套红模板根据当前正文类型过滤
    resetTaohongList();
    
    if(edocSummaryQuick!=null && taohongTemplateUrl!=null && taohongTemplateUrl!=''){
    	myBar.disabled("isQuickS");
    	document.getElementById("isQuickSend").disabled = true;
        taohongFileUrl=document.getElementById("fileUrl").value;
    }
    if(isResetRemaind){
    	var remind = $("#advanceRemind");
    	if(remind[0]){
	    	remind[0].selectedIndex = 0;
    	}
    }
    /*跟踪设置*/
    customTrackSet(isTrackId);
	
	//计算页面高度
	resizeFun();
	
	clickFlag = true;
 }

function customTrackSet(isTrackId){
	var setFlag = true;
	if("" != mids){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocManager", "getTrackName",false);
		requestCaller.addParameter(1, "String", mids);
		var strName=requestCaller.serviceRequest();
        $("#zdgzryName").val(strName);
        $("#zdgzryName").attr("title",strName);
        $("#zdgzryName").css('display',''); 
	}
	if(!fromTemplateFlag && !customSetTrackFlag && isTrackId == ''){
		 $("#isTrack").click();
		 $("#trackRange_all")[0].checked = false;
		 $("#trackRange_all")[0].disabled = true;
		 $("#trackRange_part")[0].disabled = true;
		 setFlag =false;
	}
	if(personalTemplateFlag && customSetTrackFlag){
		$("#isTrack")[0].checked = true;
		 $("#trackRange_all")[0].checked = true;
		 $("#trackRange_all")[0].disabled =false;
		 $("#trackRange_part")[0].disabled = false;
		 setFlag = false;
	}
	if(setFlag && customSetTrackFlag){
		$("#isTrack")[0].checked = true;
		if($("#zdgzryName").val() == ""){
			$("#trackRange_all")[0].checked = true;
			 $("#trackRange_all")[0].disabled =false;
			 $("#trackRange_part")[0].disabled = false;
		}else{
			$("#trackRange_part")[0].checked = true;
			$("#trackRange_part")[0].disabled =false;
			$("#trackRange_all")[0].disabled = false;
		}
	}
	if((waitSendFlag && affairTrackType == 0) || (templatSetTrackNot && fromTemplateFlag)){
		$("#isTrack")[0].checked = false;
		$("#trackRange_all")[0].checked = false;
		 $("#trackRange_all")[0].disabled =true;
		 $("#trackRange_part")[0].checked = false;
		 $("#trackRange_part")[0].disabled = true;
		 $("#zdgzryName").val("");
	    $("#zdgzryName").css('display','none'); 
	}
	
}
 function resetTaohongList(){
 	cacheTaohongList();
 	getTaohongList();
 }
 
 function cacheTaohongList(){
	 var taohongselectObj = document.getElementById("fileUrl");
	 var taohongselectObj_bak = document.getElementById("fileUrl_bak");
	 if(taohongselectObj && taohongselectObj_bak){
	 	for (var i = 0 ; i < taohongselectObj.options.length; i++) {
	 		if (taohongselectObj.options[i].value != '') {
	 			taohongselectObj_bak.appendChild(taohongselectObj.options[i]);
	 			i=i-1;
	 		}
	 	}
	 }
}
 function getTaohongList(){
	 var bType = "";
	 var bodyTypeObj = document.getElementById("bodyType");
	 if(bodyTypeObj != null){
	    bType = bodyTypeObj.value;
	 }
	 var taohongselectObj = document.getElementById("fileUrl");
	 var taohongselectObj_bak = document.getElementById("fileUrl_bak");
	 var selectedOption=null;
	 var defOption=taohongselectObj.options[0];
	 if(taohongselectObj && taohongselectObj_bak){
	 	for (var i = 0 ; i < taohongselectObj_bak.options.length; i++) {
	 		var a = taohongselectObj_bak.options[i].value.split("&");
	 		var selectBodyType = "";
	 		if(a.length == 2){
	 			selectBodyType = a[1];
	 		}
	 		if (selectBodyType == bType.toLowerCase() && selectBodyType!='') {
	 			if(isSameTaohongTemplate(taohongTemplateUrl,taohongselectObj_bak.options[i].value)){
	 				selectedOption = taohongselectObj_bak.options[i];
	 			}
	 			taohongselectObj.appendChild(taohongselectObj_bak.options[i]);
	 			i=i-1;
	 		}
	 	}
	}
	if(selectedOption){
		selectedOption.selected = "selected";
	}else{
		defOption.selected = "selected";
	}
}
 
 function isSameTaohongTemplate(taohongTemplateUrl,optionValue){
		if(taohongTemplateUrl && optionValue){
			var tem1="";
			var tem2="";
			/***纯Windows开发代码。。。**/
			var start2=optionValue.lastIndexOf("\\");
			
			if(start2 == -1){
			    start2 = optionValue.lastIndexOf("/");
			}
			
			var end2=optionValue.lastIndexOf("&");
			tem2=optionValue.substring(start2+3,end2);
			var index=taohongTemplateUrl.indexOf(tem2);
			if(index >= 0){
				return true;
			}
		}
		return false;
	}
 
 function getWFtype(){
	  var type ="";
	  if(param_edocType== 0){
	      type = "edocSend";
	  }else if(param_edocType == 1){
	      type = "recEdoc";   
	  }else{
	      type = "signReport";    
	  }
	  return type;
	}
 
 function getPolicy(type){
	  var policy={};
	  if(type == 'edocSend' || type=='signReport'){
	     policy.name = edoc_element_shenpi;
	     policy.bianma = "shenpi";
	  }else{
	     policy.name = edoc_element_yuedu;
	     policy.bianma = "yuedu";
	  }
	  return policy;
	}
 
 function getParentFrame(){
	  return window.parent.parent.parent;
	}
 function selectPeo(){
	    var top2 = getParentFrame();
	    var type = getWFtype();
	    var selectPanels = "Department,Team,Post";
	    var selectTypePara= "Member,Account,Department,Team,Post,RelatePeople";
	    var policy = getPolicy(type);
	    if(agentToId == ""){
	    	top2.createProcessXml(type,top2,window, 
	    			currentUserId, currentUserName,currentUserAccountName,
	    	        policy.bianma,currentUserAccountId,policy.name,selectPanels,selectTypePara);
	  	}else{
	    	top2.createProcessXml(type,top2,window, 
	    			agentToId, agentToName,agentToId_ctp_OrgAccountName,
	        	policy.bianma,currentUserAccountId,policy.name,selectPanels,selectTypePara);
	  	}
	}
 
 function createEdocWFPersonal() {
	    var type = getWFtype();
	    var policy = getPolicy(type);
	    var top2 = getParentFrame();
	    if(subState == '16'){//指定回退给发起人[直接提交给我]查看
	      top2.showWFCDiagram(getA8Top(),caseId,processId,false,false,null,window,'edoc',null,'');
	    }else if(isRepealTemplate=='true'){//撤销回来的模板流程
	        if(processId){
	            top2.showWFCDiagram(getA8Top(),'',processId,false,false,null,window,'edoc',null,'');
	        }else if(templeteProcessId){//兼容处理，后台没有设置processId
	            
	            var tempEdocFormSelect = document.getElementById("edoctable");
	            var tempEdocFormId = tempEdocFormSelect.options[tempEdocFormSelect.selectedIndex].value;
	            
	            top2.showWFTDiagram(getA8Top(),templeteProcessId,window,currentUserName,currentUserAccountName,'edoc', tempEdocFormId);
	        }
	    }else if(isRepealFree=='true'){//撤销回来的自由流程
	    	if(canSelfCreateFlow == 'false'){
	    		top2.showWFCDiagram(getA8Top(),caseId,processId,false,false,null,window,'edoc',null,'');
	    	}else{
	    		top2.createWFPersonal(getA8Top(),getWFtype(param_edocType), currentUserId, currentUserName
	    				,currentUserAccountName,processId,window,policy.bianma,currentUserAccountId,policy.name);
	    	}
	    }else if((isFromTemplate && templateType !='text')
	        //当后台设置开关时，设置不能自建流程时，就不能编辑流程了，只能查看流程 (最开始 按钮置灰)
	        //而且要在调用模板之后，当templeteProcessId有值时，才能点查看流程
	        || selfCreateFlow == 'false' || canSelfCreateFlow == 'false') {//调用系统模板(非格式模板)后只能查看流程，调用个人模板后可以编辑流程
	        if(templeteProcessId != ''){
	            
	            var tempEdocFormSelect = document.getElementById("edoctable");
                var tempEdocFormId = tempEdocFormSelect.options[tempEdocFormSelect.selectedIndex].value;
                
	            top2.showWFTDiagram(getA8Top(),templeteProcessId,window,currentUserName,currentUserAccountName,'edoc', tempEdocFormId);
	        }
	        //格式模板
	        else{
	          top2.createWFPersonal(getA8Top(),getWFtype(param_edocType), currentUserId, currentUserName
	              ,currentUserAccountName,processId,window,policy.bianma,currentUserAccountId,policy.name);
	        }
	    } else  if(!canSelfCreateFlow || canSelfCreateFlow == 'false'){
	    	 var tempEdocFormSelect = document.getElementById("edoctable");
             var tempEdocFormId = tempEdocFormSelect.options[tempEdocFormSelect.selectedIndex].value;
             
	         top2.showWFTDiagram(getA8Top(),templeteProcessId,window,currentUserName,currentUserAccountName,'edoc', tempEdocFormId);
	    } else{//创建
	      if(agentToId == ""){
	    	  top2.createWFPersonal(getA8Top(),getWFtype(param_edocType), currentUserId, currentUserName
	    	          ,currentUserAccountName,processId,window,policy.bianma,currentUserAccountId,policy.name);
	      }else{
	    	  top2.createWFPersonal(getA8Top(),getWFtype(param_edocType), agentToId, agentToName
	    	          ,agentToId_ctp_OrgAccountName,processId,window,policy.bianma,currentUserAccountId,policy.name);
	      }
		}
	    return false;
	}
 
//因为调用模板时，是从外层框架中调用的，所以需要取消离开当前新建公文时弹出的确认对话框
 function cancel_onbeforeunload(){
   $("body").attr("onbeforeunload","");
 }
 
 function setProcessTypeIdValue(value) {
	    //GOV-5076.【收文管理-新建收文】先选择流程，流程节点默认为审批，再切换为"阅文"，再点击"编辑流程"，出现的页面里，每个人都变成了阅读 暂时pingbi
	    if(edocType) {
	        document.getElementById("processType").value = value;
	        /*if(value == "2") {
	            defaultPermName = "<fmt:message key='node.policy.yuedu' bundle='${v3xCommonI18N}'/>";
	        } else {
	            defaultPermName = "<fmt:message key='node.policy.shenpi' bundle='${v3xCommonI18N}'/>";
	        }*/
	    }
	}
 
 function initEdocIe10AutoScroll(){
	  //OA-23050  调用公文模板后点击保存待发，提示填写标题后，点击确定，保存待发等的toolbar没有了  
	  /*
	    initIe10AutoScroll('formAreaDiv',130);
	    initIe10AutoScroll('noteMinDiv', 120);
	  */
	}

	//OA-29541 后台设置不允许自建流程，前台拟文时关闭了模版的选择界面，填写标题，然后发送，这时正常弹出了无流程的提示，单击提示的确定，继续弹出了流程的选人界面
	function sendCallBack_newEdoc(){
		var checkSend=document.getElementById("isQuickSend");
	    if(null == checkSend || !checkSend.checked){//如果等于null ,就是签报没有快速发文ID，直接验证跟踪人
			if(document.getElementById("trackRange_part") && document.getElementById("trackRange_part").checked){
				if(document.getElementById("zdgzryName").value == ""){
					alert(_trackTitle);
					return;
				}
			 }
		}
	    clickFlag=false;
		var calDateTime=$("#deadLineDateTimeInput");
		var dateTimeObj=$("#deadLineDateTime");
		if(calDateTime&&dateTimeObj){
			dateTimeObj.val(calDateTime.val());
		}
		//保存的时候，如果流程期限是空的，则把提前提醒设置为 无
	    var remind = $("#advanceRemind");
	    if(calDateTime[0]&&remind[0]){
	        if(calDateTime[0].value==""){
	            remind[0].selectedIndex = 0;
	        }
	    }
	  if(selfCreateFlow==false){
	    sendCallBack(1);
	  }else{
	    sendCallBack();
	  }
	}
	
	//快速发文
	function showQuickSend(){
	    //快速发文的标识
	    var isQuickSend=false;
	    if(!document.getElementById("isQuickSend")){return;}
	    if(document.getElementById("isQuickSend").checked){
	    	isQuickSend= true;
	    }

		 if(isQuickSend){
		 	  //流程控件
		 	  document.getElementById("sel_label_workflow").style.display="none";
		 	  document.getElementById("process_info_div").style.display="none";
		 	  $("#process_info_div").parent().attr("width", "60%");//扩大宽度，兼容1024*768
		 	  document.getElementById("workflowInfo_div").style.display="none";
		 	  //交换控件
		 	  if(document.getElementById("sel_label_exchange")){
		 	   document.getElementById("sel_label_exchange").style.display="block";
		 	  }
		      if(document.getElementById("exchangeSel")){
		        document.getElementById("exchangeSel").style.display="block";
		      }
		    
		    //流程期限控件
		    document.getElementById("sel_label_deadline").style.display="none";
		    document.getElementById("deadline_div").style.display="none";
		    
		    //套红控件
		    if(jsEdocType !=1){
		      document.getElementById("sel_label_taohong").style.display="block";
		      document.getElementById("taohong_div").style.display="block";
		    }
		    
		    if(document.getElementById("bodyType") && document.getElementById("bodyType").value=='HTML'){
	          document.getElementById("fileUrl").disabled="true";
	        }

		    //提醒控件
		    document.getElementById("sel_label_tixing").style.display="none";
		    document.getElementById("tixing_div").style.display="none";
		    
		    //跟踪控件
		    document.getElementById("genzong_div").style.display="none";
		    document.getElementById("genzong_label").style.display="none";
		    
		    //归档控件
		    if(document.getElementById("sel_label_guidang") && document.getElementById("guidang_div")){
		       document.getElementById("sel_label_guidang").style.display="block";
		       document.getElementById("guidang_div").style.display="block";
		    }
		    
		    //基准时长
		    if(document.getElementById("jizhunshichang_label_div")){
		    	document.getElementById("jizhunshichang_label_div").style.display="none";
		    }
		    if(document.getElementById("jizhunshichang_label_div2")){
		    	document.getElementById("jizhunshichang_label_div2").style.display="none";
		    }
		    if(document.getElementById("jizhunshichang")){
	            $("#jizhunshichang").hide();
		    }
		    
		    //流程追溯
		    document.getElementById("zhuisu_label_div").style.display="none";
		    document.getElementById("zhuisu_div").style.display="none";
		    
		    //办理类型
		    if(document.getElementById("bllx_label_1")){
		       document.getElementById("bllx_label_1").style.display="none";
		    }
		    if(document.getElementById("bllx_label_2")){
		       document.getElementById("bllx_label_2").style.display="none";
		    }
		    
		    //按钮置灰
		    if(document.getElementById("saveAs") != null) {
		    	myBar.disabled("saveAs");
			    document.getElementById("saveAs").firstChild.className = 'webfx-menu--button-content';
		    }
		    if(document.getElementById("templete") != null) {
		    	myBar.disabled("templete");
		    	document.getElementById("templete").firstChild.className = 'webfx-menu--button-content';
		    }
		    if(document.getElementById("superviseSetup") != null) {
		    	myBar.disabled("superviseSetup");
		    	document.getElementById("superviseSetup").firstChild.className = 'webfx-menu--button-content';
		    }
		    
		  	//隐藏更多按钮
	        $("#show_more_td").hide();
	        //设置td的宽度，快速发文IE8下样式有问题
	        var tdRightObj1=document.getElementById("tdRight1");
	        if(tdRightObj1) {
	        	tdRightObj1.width="100%";
	        }
	        var tdRightObj2=document.getElementById("tdRight2");
	        if(tdRightObj2) {
	        	tdRightObj2.width="100%";
	        }
	   }else{
	        if((jsEdocType==0 && !confirm(edocLang.edoc_quicksend_return_send))||
	           jsEdocType ==1 && !confirm(edocLang.edoc_quicksend_return_rec)){
	          document.getElementById("isQuickSend").checked="true";
	          return;
	        }
	        
	   	  //流程控件
	   		document.getElementById("sel_label_workflow").style.display="block";
	   		document.getElementById("process_info_div").style.display="block";
	   		$("#process_info_div").parent().attr("width", "30%");//扩大宽度，兼容1024*768
	   		document.getElementById("workflowInfo_div").style.display="block";
		 	  //交换控件
		 	  if(document.getElementById("sel_label_exchange")){
		 	   document.getElementById("sel_label_exchange").style.display="none";
		 	  }
		      if(document.getElementById("exchangeSel")){
		        document.getElementById("exchangeSel").style.display="none";
		      }
		    //流程期限控件
		    document.getElementById("sel_label_deadline").style.display="block";
		    document.getElementById("deadline_div").style.display="block";
		    //套红控件
		    if(jsEdocType !=1){
		       document.getElementById("sel_label_taohong").style.display="none";
		       document.getElementById("taohong_div").style.display="none";
		    }

		    
		    //提醒控件
		    document.getElementById("sel_label_tixing").style.display="block";
		    document.getElementById("tixing_div").style.display="block";
		    
		    //跟踪控件
		    document.getElementById("genzong_div").style.display="block";
		    document.getElementById("genzong_label").style.display="block";
		    
		    //归档控件
		    if(document.getElementById("sel_label_guidang") && document.getElementById("guidang_div")){
		      document.getElementById("sel_label_guidang").style.display="none";
		      document.getElementById("guidang_div").style.display="none";
		    }
		    //基准时长
		    if(document.getElementById("jizhunshichang_label_div")){
		    	document.getElementById("jizhunshichang_label_div").style.display="block";
		    }
		    if(document.getElementById("jizhunshichang_label_div2")){
		    	document.getElementById("jizhunshichang_label_div2").style.display="block";
		    }
		    if(document.getElementById("jizhunshichang")){
	            $("#jizhunshichang").show();
		    }
		    
		    //流程追溯
		    document.getElementById("zhuisu_label_div").style.display="block";
		    document.getElementById("zhuisu_div").style.display="block";
		    
		    //办理类型
		    if(document.getElementById("bllx_label_1")){
		       document.getElementById("bllx_label_1").style.display="block";
		    }
		    if(document.getElementById("bllx_label_2")){
		       document.getElementById("bllx_label_2").style.display="block";
		    }
		    
		  	//显示更多按钮
	        $("#show_more_td").show();
		    
		    //按钮还原
		    myBar.enabled("saveAs");
		    myBar.enabled("templete");
		    myBar.enabled("superviseSetup");
		    
	        //设置td的宽度，快速发文IE8下样式有问题
	        var tdRightObj1=document.getElementById("tdRight1");
	        if(tdRightObj1) {
	        	tdRightObj1.width=10;
	        }
	        var tdRightObj2=document.getElementById("tdRight2");
	        if(tdRightObj2) {
	        	tdRightObj2.width=10;
	        }
	   }
	}

	//快速发文--交换类型检查
    var checkExchangeRoleCallbackParam = {};
    function checkExchangeRole(params){
        
        params = params || {};
        var callbackFn = params.callbackFn || function(){};
        var selectDeptFlag = false;
        
          var typeAndIds="";
          msgKey="edocLang.alert_set_departExchangeRole";     
          var obj=document.getElementById("edocExchangeType_depart");
          if(obj==null){return true;}
          var selectObj = document.getElementsByName("memberList")[0];
          var selectdExchangeUserId = (selectObj.options[selectObj.selectedIndex]).value;
          var selectdExchangeUserName = (selectObj.options[selectObj.selectedIndex]).innerHTML;
          var sendUserDepartmentId = "";
          
          if(obj.checked){
              var selectDeptObj = document.getElementsByName("exchangeDeptType")[0];
              var selectDeptIndex = selectDeptObj.selectedIndex;
              var selectDeptType = (selectDeptObj.options[selectDeptIndex]).value;
              
              var toSelectDepts = null;
              
              if(selectDeptType == "Creater"){
                  
                  toSelectDepts = createrExchangeDepts;
              }else if(list != null && list != "undifined" && list != ""){
                  toSelectDepts = list;
              }
              
              if(toSelectDepts != null && toSelectDepts != "undifined" && toSelectDepts != ""){
                  
                  var _url= genericControllerURL+"edoc/selectDeptSender&memberList="+encodeURIComponent(toSelectDepts);
                  var listArr=toSelectDepts.split("|");
                  if(listArr.length>1){
                      
                      checkExchangeRoleCallbackParam.callbackFn = callbackFn;
                      checkExchangeRoleCallbackParam.msgKey = msgKey;
                      selectDeptFlag = true;
                      
                      window.checkExchangeRoleWin = getA8Top().$.dialog({
                            title : '选择交换部门',
                            transParams : {
                                'parentWin' : window,
                                'popWinName' : 'checkExchangeRoleWin',
                                'popCallbackFn' : checkExchangeRoleCallback
                            },
                            url : _url,
                            targetWindow : getA8Top(),
                            width : "342",
                            height : "185"
                        });
                  }else if(listArr.length==1){
                      sendUserDepartmentId=listArr[0].split(',')[0];
                      document.getElementById("returnDeptId").value=sendUserDepartmentId;
                  }
              }
              
            //xiangfan 添加  修复GOV-4911 End
            if(!selectDeptFlag){
                typeAndIds="Department|"+sendUserDepartmentId;    
                selectdExchangeUserId=""; 
            }
          }
          else
          {
            typeAndIds="Account|"+currentUserAccountId;
            msgKey="edocLang.alert_set_accountExchangeRole";
          }
          
          if(!selectDeptFlag){
              _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, callbackFn);
          }
    }
    
    /**
     * 执行交换部门验证
     * @param typeAndIds
     * @param selectdExchangeUserId
     * @param msgKey
     * @param callbackFn
     */
    function _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, callbackFn){
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "checkExchangeRole",false);
            requestCaller.addParameter(1, "String", typeAndIds);
            requestCaller.addParameter(2, "String", selectdExchangeUserId);
        var ds = requestCaller.serviceRequest();
        if(ds=="check ok")
        {
            callbackFn(true);
        }else if(ds == "changed")//xiangfan 添加逻辑判断
        {
            var selectObj = document.getElementsByName("memberList")[0];
            var selectdExchangeUserName = (selectObj.options[selectObj.selectedIndex]).innerHTML;
            
            alert(edoc_Cancel_exchange_privileges1 + selectdExchangeUserName + edoc_Cancel_exchange_privileges2);
            callbackFn(false);
        }
        else
        {
          alert(_(msgKey,ds));
          callbackFn(false);
        }
    }

    /**
     * 分发部门选择回调函数
     * 
     * @returns
     */
    function checkExchangeRoleCallback(sendUserDepartmentId) {
        
        var callbackFn = checkExchangeRoleCallbackParam.callbackFn;
        var msgKey = checkExchangeRoleCallbackParam.msgKey;
        
        if (sendUserDepartmentId == "cancel"
                || typeof (sendUserDepartmentId) == 'undefined') {
            // 取消或者直接点击关闭
            callbackFn(false);
        }else{
            document.getElementById("returnDeptId").value = sendUserDepartmentId;
            var typeAndIds = "Department|" + sendUserDepartmentId;
            var selectdExchangeUserId = "";
            _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, callbackFn);
        }
    }

    
	function showMemberList(){
		var memberListDiv = document.getElementById("selectMemberList");
		memberListDiv.style.display = "";
		
		document.getElementById("selectExchangeDeptType").style.display = "none";
	}
	function hideMemberList(){
		var memberListDiv = document.getElementById("selectMemberList");
		memberListDiv.style.display = "none";
		
		document.getElementById("selectExchangeDeptType").style.display = "";
	}
	
	function guidangFromTemplete(selectObjs){
		if(document.getElementById("isQuickSend") && document.getElementById("isQuickSend").checked){
			pigeonholeEvent(selectObjs,ApplicationCategoryEnumEdoc,'finishWorkItem',this.sendForm);
	  }else{
	  	pigeonholeEvent(selectObjs,ApplicationCategoryEnumEdoc,'',this.sendForm);
	  }
		
	}

	function showTurnRecInfo(){
		V5_Edoc().getCtpTop().turnRecInfoDialog = p_$().dialog({
	        url: "exchangeEdoc.do?method=openTurnRecInfo&summaryId="+supEdocId+"&type=newedoc",
	        width:500,
	        height:450,
	        title:edoc_turn_rec_info, //节点权限操作说明
	        targetWindow:getA8Top(),
	        isClear:false
	        });
	}
	
	function insertAttachmentFn(){
	    insertAttachment(null, null, "resizeLayout", "false");
	    //resizeLayout();
	}
	function quoteDocumentEdocFn(){
	    quoteDocumentEdoc(appType);
	    window.quoteDocument_affterFn = resizeLayout;//该回调在edoc.js中调用
	    //resizeLayout();
	}
	function resizeLayout(){
		$("#attachmentArea img,#attachment2Area img").unbind("click", resizeLayout).bind("click", resizeLayout);
	    var _h=0;
	    if (v3x.isMSIE9){
	        _h=5;
	    }
	    //td的边框和padding等有7px偏差
	    var fixedHeight = 7;
	    $("#textarea_fy").height($("body").height()-$("#tb_height").height()-$("#form_height").height()-_h-60 - fixedHeight);
	    $("#formAreaDiv").css("height", ($("body").height()-$("#tb_height").height()-$("#form_height").height()-_h - fixedHeight) + "px");
	}
	
	function initDate(reader){
	    if(reader){
	        //var codetext = reader.GetBarCodeBuff();//必须有14个^
	    	//内部文号
	    	var serialNo = document.getElementById("my:serial_no");
	        if(serialNo)
	        	serialNo.value = reader.GetSerialNumber();
	        //标题
	        var subject = document.getElementById("my:subject");
	        if(subject)
	            subject.value = reader.GetDocTitle();
	        //来问字号
	        var docMark = document.getElementById("my:doc_mark");
	        if(docMark)
	            docMark.value = reader.GetDocIssue();
	        //主送单位
	        var sendTo = document.getElementById("my:send_unit");
	        if(sendTo)
	            sendTo.value = reader.GetReceCompany();
	        //成文日期
	        var edocDate = document.getElementById("my:createdate");
	        if(edocDate)
	            edocDate.value = reader.GetDocTime();
	        
	        var options;
	        //公文密级
	        var urgentLevel = document.getElementById("my:secret_level");
	        var scanUrgentLevel = reader.GetSecuLevel();
	        if(urgentLevel && scanUrgentLevel){
	            options = urgentLevel.options;
	            if(options){
	                for(var i=0;i<options.length;i++){
	                    if(options[i].text == scanUrgentLevel)
	                        options[i].selected = true;
	                }
	            }
	        }
	        //紧急程度
	        var secretLevel = document.getElementById("my:urgent_level");
	        var scanSecretLevel = reader.GetUrgenLevel();
	        if(secretLevel && scanSecretLevel){
	            options = secretLevel.options;
	            for(var i=0;i<options.length;i++){
	                if(options[i].text == scanSecretLevel)
	                    options[i].selected = true;
	            }
	        }
	    }
	}
	
	function resizeFun(){ 
	    $("#newDiv").height($("body").height()); 
	    $("#deadline").addClass("left"); 
	    $("#lcqx_time").show(); 
	    resizeLayout(); 
	}
	
	//初始化方法，放在onload里面
	function _init_(){
	    
	    $("#noteAreaTd div:eq(0)").click(function(){ 
            $("#noteAreaTd table").height($("#noteAreaTd").parents("table").find("tr:eq(0) td:eq(0)").height()-15) 
        }); 
        $(window).resize(resizeFun); 
        
        //更多按钮操作
        var moreShow_st = 0;//更多状态
        $("#show_more").click(function () {
            if (moreShow_st==0) {
                $(this).html('收起<span class="ico16 arrow_2_t"></span>');
                $(".newinfo_more").show();
                $("#send_td").attr("rowspan",3);
                moreShow_st=1;
            }else {
                $(this).html('展开<span class="ico16 arrow_2_b"></span>');
                $(".newinfo_more").hide();
                $("#send_td").attr("rowspan",2);
                moreShow_st=0;
            }
        });
	}