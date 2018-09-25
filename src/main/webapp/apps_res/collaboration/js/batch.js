function BatchData(affairId,summaryId,category,subject,processId){
    this.affairId = affairId;
    this.summaryId = summaryId;
    this.category = category;
    this.subject = subject;
    this.code ;
    this.parameter;
    this.processId = processId;
    this.attitude = '1';//态度
    this.opinion = '0';//意见必填
    this.conditionsOfNodes; //分支信息
}
BatchData.prototype.toInput = function(){
    return "<input type='hidden' name='affairId' value="+this.affairId+">"
        +"<input type='hidden' name='summaryId' value="+this.summaryId+">"
        +"<input type='hidden' name='category' value="+this.category+">"
        +"<input type='hidden' name='processId' value="+this.processId+">"
        +"<input type='hidden' name='code' value="+this.code+">"
        +"<input type='hidden' name='parameter' value='"+(this.attitude+","+this.opinion)+"'>";
}
window.globalBatch = null;

/**
 * 初始化
 */
function BatchProcess(){
    this.batchElement = new ArrayList();
    window.globalBatch = this;
    this.batchAttitude = null;
    this.batchOpinion = null;
    this.doBatchResult = new ArrayList();
}
/**
 * 添加数据，传出affairId,summaryId,category,subject
 */
BatchProcess.prototype.addData = function(affairId,summaryId,category,subject,processId){
    var ele = new BatchData(affairId,summaryId,category,subject,processId);
    this.batchElement.add(ele);
}



/**
 * 执行批处理
 */
BatchProcess.prototype.doBatch = function(fun){
	var _this = this;
    if(this.batchElement.size() ==0){
        $.messageBox({
            'type' : 0,
            'title':$.i18n('collaboration.system.prompt.js'), //系统提示
            'msg' : $.i18n('collaboration.batch.batchDataEmpty'), //要批处理的数据为空 
            ok_fn : function() {}
          });
        return false;
    }
    
    var hasNoPass = this.preSend();
    if(hasNoPass){
        var ur1 = _ctxPath+"/collaboration/batchController.do?method=preBatch";
        var dialog1 = $.dialog({
            url : ur1,
            title: $.i18n('collaboration.system.prompt.js'), //系统提示
            width: 450,
            height: 370,
            targetWindow:getCtpTop(),
            isDrag:true,
            transParams:window.globalBatch,
            buttons: [{
                text: $.i18n('collaboration.batch.continueProcessing'), //继续处理
                disabled:window.globalBatch.getCancelData().size() === window.globalBatch.eleSize(),
                handler: function (){

                	window.globalBatch.doBatchUI();
                    
                    var data = _this.getCancelData();
                    for(var i=0;i<data.size();i++) {
                		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
                	}	
                    dialog1.close();
                }
            }, {
                text: $.i18n('collaboration.dialog.close'),//关闭
                handler: function () {
                	 var data = _this.batchElement;
                     for(var i=0;i<data.size();i++) {
                 		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
                 	 }
                     dialog1.close();
                    dialog1.close();
                    
                }
            }],
            closeParam: {
            	show : true,
                handler : function() {
                	var data = _this.batchElement;
                    for(var i=0;i<data.size();i++) {
                		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
                	}
                    dialog1.close();
                }
            },
            minParam: {
                show: false
            },
            maxParam: {
                show: false
            }
        });
    }else{
        this.doBatchUI();
    }
}

/**
 * 执行批页面显示
 */
BatchProcess.prototype.doBatchUI = function(){
	var data = this.getProcessBatchData();
    var ur2=_ctxPath+"/collaboration/batchController.do?method=batch";
    ur2+="&attitude="+this.batchAttitude+"&opinion="+this.batchOpinion;
    var dialog2 = $.dialog({
        url : ur2,
        title: $.i18n('collaboration.batch.deal'),//批处理
        width: 450,
        height: 300,
        targetWindow:getCtpTop(),
        buttons: [{
            text: $.i18n('collaboration.button.ok.label'),//确定,
            btnType : 1,
            handler: function () {
                var result=dialog2.getReturnValue();
                if(result){
                	showMask();
                    var proce = $.progressBar();
                    
                    for(var i=0;i<data.size();i++){
                    	var param = new Object();
                    	param["affairId"]   = data.get(i).affairId;
                    	param["summaryId"]  = data.get(i).summaryId;
                    	param["category"]   = ""+data.get(i).category;
                    	param["parameter"]  = data.get(i).attitude+","+data.get(i).opinion;
                    	param["attitude"]   = result[0];
                    	param["content"]    = result[1];
                    	param["conditionsOfNodes"] = data.get(i).conditionsOfNodes;
                    	window.globalBatch.submitForm(param);
                    }
                    
                    window.globalBatch.showResult();
                    
                    proce.close();
                    dialog2.close();
                    for (var i=0;i<window.globalBatch.batchElement.size();i++) {
                        try{closeOpenMultyWindow(window.globalBatch.batchElement.get(i).affairId);}catch(e){};
                    }

                    for(var i=0;i<data.size();i++) {
                		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
                	}
                }
            }
        }, {
            text: $.i18n('collaboration.button.cancel.label'),//取消
            handler: function () {
            	for(var i=0;i<data.size();i++) {
            		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
            	}
                dialog2.close();
            }
        }],
        closeParam: {
        	show : true,
            handler : function() {
                for(var i=0;i<data.size();i++) {
            		releaseWorkflowByAction(data.get(i).processId, $.ctx.CurrentUser.id, 14);
            	}
            	dialog2.close();
            }
        },
        minParam: {
            show: false
        },
        maxParam: {
            show: false
        }
    });
}
BatchProcess.prototype.submitForm = function(param){
	
	var __batchManager = new batchManager();
    var rs=__batchManager.transDoBatch(param);
	if(rs != 'OK'){
		globalBatch.doBatchResult.add(rs);
	}
}
//BatchProcess.prototype.createBatchForm = function(result){
//    var theForm = document.getElementById("batchDataForm");
//    if(theForm){
//        theForm.innerHTML = "";
//    }else{
//        var theIframeDiv = document.createElement("div");
//        document.body.appendChild(theIframeDiv);
//        theIframeDiv.innerHTML = "<iframe name='batchDataFrame' width='0' height='0' border='0'></iframe>";
//        theForm = document.createElement("form");
//        theForm.setAttribute('name','batchDataForm');
//        theForm.setAttribute('id','batchDataForm');
//        theForm.setAttribute('target','batchDataFrame');
//        theForm.setAttribute('action','');
//        theForm.id='batchDataForm';
//        document.body.appendChild(theForm);
//    }
//    var html = this.createInput("attitude",result['attitude']);
//    html += this.createInput("content",result['content']);
//    html += this.createInput("conditionsOfNodes",result['conditionsOfNodes']);
//    html += this.createInput("trace",result['trace']);
//    var data = this.getProcessBatchData();
//    for(var i=0;i<data.size();i++){
//        var d = data.get(i);
//        html += d.toInput();
//    }
//    theForm.innerHTML = html;
//}
BatchProcess.prototype.createInput = function(name,value){
    var values = value;
    if (name == "content"){
        values = escapeStringToHTML(value,false,false);
    }
    return "<input type='hidden' name='"+name+"' value='"+values+"'>";
}
BatchProcess.prototype.showResult = function(){
    
    if(globalBatch.doBatchResult && globalBatch.doBatchResult.length >0){
        var ur=_ctxPath+"/collaboration/batchController.do?method=showResult"
        var dialog1 = $.dialog({
            url : ur,
            title: $.i18n('collaboration.system.prompt.js'), //消息提示
            width: 450,
            height: 400,
            targetWindow:getCtpTop(),
            isDrag:false,
            transParams:window.globalBatch,
            buttons: [{
                text: $.i18n('collaboration.batch.continueProcessing'), //继续处理
                disabled:window.globalBatch.getCancelData().size() === window.globalBatch.eleSize(),
                handler: function (){
                    var rv = dialog1.getReturnValue();
                    if(rv){
                        window.globalBatch.doBatchUI();
                    }else{
                    }
                    dialog1.close();
                    for (var i=0;i<window.globalBatch.batchElement.size();i++) {
                        try{closeOpenMultyWindow(window.globalBatch.batchElement.get(i).affairId);}catch(e){};
                    }
                }
            }, {
                text: $.i18n('collaboration.dialog.close'),//关闭
                handler: function () {
                    dialog1.close();
                    
                }
            }],
            minParam: {
                show: false
            },
            maxParam: {
                show: false
            }
        });
    }
    //getA8Top().contentFrame.topFrame.refreshWorkspace();
    if(typeof(batchReflash)!="undefined" && batchReflash!=null && batchReflash!=undefined){
        var url="";
        if(edocTypeReflash == "0"){//发文
            if(batchReflash=="listPending"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=sendManager&listType=listPending";
            }else if(batchReflash=="listZcdb"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=sendManager&listType=listZcdb";
            }
        }
        if(edocTypeReflash == "1"){//收文
            if(batchReflash=="listPending"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=recManager&listType=listPending";
            }else if(batchReflash=="listZcdb"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=recManager&listType=listZcdb";
            }
        }
        if(edocTypeReflash == "2"){//签报
            if(batchReflash=="listPending"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=signReport&listType=listPending";
            }else if(batchReflash=="listZcdb"){
                url=_ctxPath+"/edocController.do?method=entryManager&entry=signReport&listType=listZcdb";
            }
        }
        window.location.href = url;
    }else{
     try{
    	 if($("#listPending").size() !=0){
    		 $("#listPending").ajaxgridLoad();
    		 try{
	    		 var totle = grid.p.total-1;
	    		 if(totle == -1 ){
	    			 totle =0;
	    		 }
	    		 $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+totle);
    		  }catch(e){}
    	 }else if($("#moreList").size()!= 0){
    		 $("#moreList").ajaxgridLoad();
			 setTimeout(function(){
	            loadTitle(grid.p.total);
	         },1000);
    	 }else{
    		 window.location.reload();
    	 }
    	 hideMask();
     }catch(e){
    	 window.location.reload();
    	 hideMask();
     }
    }
}

//预执行-返回是否全部可以批处理
BatchProcess.prototype.preSend = function(){
    //记录code，如果有不通过的，给提示。选择提示为true，返回true。否则false
    // 全部通过，直接返回true；
    var affairs = [],summarys = [],categorys=[];
    for(var i = 0 ; i < this.batchElement.size();i++){
        var el = this.batchElement.get(i);
        affairs[affairs.length] = el.affairId;
        summarys[summarys.length] = el.summaryId;
        categorys[categorys.length] = ""+el.category;
    }

    var proce = $.progressBar();

    var batchM = new batchManager();
    var tempMap = new Object();
    tempMap["affairs"] = affairs;
    tempMap["summarys"] = summarys;
    tempMap["categorys"] = categorys; 
    var rs=batchM.checkPreBatch(tempMap);

    var hasNoPass = false;
    if(rs){
        for(var i = 0;i<rs.length;i++){
            var batchResult = rs[i];
            var ele = this.getBatchData(batchResult.affairId,batchResult.summaryId);
            if(ele){
                ele.code  = batchResult.resultCode;
                if(batchResult.message){
                    ele.parameter = batchResult.message;
                    ele.conditionsOfNodes = batchResult.conditionsOfNodes;
                    if (ele.parameter.length == 3) {
                        ele.msg = ele.parameter[2];
                    };
                }
                if(parseInt(ele.code,10) > 10){
                    hasNoPass = true;
                }else if(ele.parameter){
                    ele.attitude = ele.parameter[0];
                    ele.opinion = ele.parameter[1];
                    if(this.batchAttitude == null || parseInt(ele.attitude) < this.batchAttitude){
                        this.batchAttitude = parseInt(ele.attitude);
                    }
                    if(this.batchOpinion == null || parseInt(ele.opinion)==parseInt(1)){//|| parseInt(ele.opinion) > this.batchOpinion
                        this.batchOpinion = parseInt(ele.opinion);
                    }
                }
            }
        }
    }

    proce.close();

    return hasNoPass;
}
BatchProcess.prototype.getCancelData = function(){
    var result = new ArrayList();
    for(var i = 0 ; i < this.batchElement.size();i++){
        var ele =  this.batchElement.get(i);
        if(ele && ele.code && parseInt(ele.code,10) > 10){
            result.add(ele);
        }
    }
    return result;
}
BatchProcess.prototype.getProcessBatchData = function(){
    var result = new ArrayList();
    for(var i = 0 ; i < this.batchElement.size();i++){
        var ele =  this.batchElement.get(i);
        if(ele && (typeof ele.code)=="number" && parseInt(ele.code,10) < 10){
            result.add(ele);
        }
    }
    return result;
}
BatchProcess.prototype.isEmpty = function(){
    return this.batchElement.size() == 0;
}
BatchProcess.prototype.eleSize = function(){
    return this.batchElement.size();
}
BatchProcess.prototype.getBatchData = function(affairId,summaryId){
    for(var i = 0 ; i < this.batchElement.size();i++){
        var el = this.batchElement.get(i);
        if(el.affairId == affairId && el.summaryId == summaryId){
            return el;
        }
    }
}