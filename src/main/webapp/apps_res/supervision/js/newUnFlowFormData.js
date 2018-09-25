window.onbeforeunload = function(e){
    var e = e || window.event;
    if(tips){
        if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
            e.returnValue = " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
        }else{
            e.returnValue = ""; //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
        }

    }
};

window.onunload = function(e){
    var e = e || window.event;
    cWindow = document.getElementById("newFormDataFrame").contentWindow;
    if(cWindow.removeSessionMasterData){
        cWindow.removeSessionMasterData();
    }
}


function checkLoad(isNew){
    if(saveProcessBar!=undefined){
        saveProcessBar.close();
    }
    cWindow = document.getElementById("newFormDataFrame").contentWindow;
    if($(cWindow.document).find("#mainbodyDiv").length<=0){
        $("#unflowbtnsave").removeClass("common_button_disable").addClass("common_button_disable").unbind("click");
        $("#unflowbtncancel").unbind("click").bind("click",function(){
        	selfClose();
    	});
    }else{
        $("#unflowbtnsave").unbind("click").bind("click",function(){saveUnflowData(true)});
        $("#unflowbtncancel").unbind("click").bind("click",function(){
        	selfClose();
    	});
    }
    cWindow.checkInstallHw(function(){
    	$("#unflowbtnsave").removeClass("common_button_disable").addClass("common_button_disable").unbind("click");
    });

    if($(cWindow.document).find(".more").length>0){
    	$(cWindow.document).find(".more").click(function(){
            $(this).toggleClass("down");
            if($(this).hasClass("down")){
                $(cWindow.document).find(".down_content").show();
            }else{
                $(cWindow.document).find(".down_content").hide();
            }
        });
    	//因为控件图标占有16px的位置，所以更多padding-right:16px
    	$(cWindow.document).find(".more").css("padding-right","16px");
    }
    $(cWindow.document).find(".log").find("div").hide();
    
    
    var supTypeObj=$(cWindow.document).find("#field0100");
    //如果是新建
	if(isNew=='true' || isNew==true){
		$(cWindow.document).find(".down_content").show();
		//默认状态是未签收
		$(cWindow.document).find("#field0024 option[val4cal='0']").attr("selected","selected");
		$(cWindow.document).find("#field0024_txt").val("待签收");
		$(cWindow.document).find("#field0024_txt").css("background-color","#FFFFFF");
		//设置事项类别
		if(supTypeObj.length>0){
			//当supType！=0 1 2 3时 默认为0 和formDataController的方法newUnFlowFormData中保持一致
			if(supType!='1' && supType!='0' && supType!='2' && supType!='3'){
				supType=0;
			}
			var selectObj=$(cWindow.document).find("#field0100 option[val4cal='"+supType+"'][value!='']");
			selectObj.attr("selected","selected");
			$(cWindow.document).find("#field0100_txt").val(selectObj.text());
		}

		//紧急程度默认为普通
		$(cWindow.document).find("#field0099 option[val4cal='2']").attr("selected","selected");
		$(cWindow.document).find("#field0099_txt").val("普通");
		if(isBreak!='true' && isBreak!=true){
			//初始化督办人
			$(cWindow.document).find("#field0095_txt").val($.ctx.CurrentUser.name);
			$(cWindow.document).find("#field0095").val("Member|"+$.ctx.CurrentUser.id);
			$(cWindow.document).find("#field0095_txt").css("background-color","#FFFFFF");
		}else{//分解时初始化上级信息
			//会议类型
			var meetingType=$("#field0085_txt").val();
			$(cWindow.document).find("#field0085 option[value='"+meetingType+"']").attr("selected","selected");
			$("#field0085",cWindow.document).val($("#field0085").val());
			$("#field0085_txt",cWindow.document).val($("#field0085_txt").val());
			$("#field0085_txt",cWindow.document).css("background-color","#FFFFFF");
			//交办单位
			$("#field0087",cWindow.document).val($("#field0087").val());
			$("#field0087_txt",cWindow.document).val($("#field0087_txt").val());
			//批示领导
			$("#field0088",cWindow.document).val($("#field0088").val());
			$("#field0088_txt",cWindow.document).val($("#field0088_txt").val());
			$("#field0088_txt",cWindow.document).css("background-color","#FFFFFF");
			//会议期次
			$("#field0089",cWindow.document).val($("#field0089").val());
			//会议名称
			$("#field0090",cWindow.document).val($("#field0090").val());
			//议题序号
			$("#field0091",cWindow.document).val($("#field0091").val());
			//立项时间
			$("#field0098",cWindow.document).val($("#field0098").val());
			//批示内容
			$("#field0101",cWindow.document).val($("#field0101").val());
			//来件原文
			var attachmentObj=$(cWindow.document).find("div[id^='attachment2Area']");
			var attachmentId=attachmentObj.attr("id");
			var embedInput=attachmentObj.attr("embedInput");
			for(var i=0;i<docArray.length;i++){
				var g=docArray[i];
				//追加到来文依据中
				cWindow.addAttachmentPoi(g.type, g.filename, g.mimeType, g.createdate, g.size, g.fileUrl, 
						true, false, g.description, g.extension, g.icon, 
						attachmentObj.attr("poi"), "", g.category, null, null, embedInput);
	        }
			attachmentObj.css("background-color","#FFFFFF");
			
			//目标来源
			var selectObj=$(cWindow.document).find("#field0100 option[value='"+$("#field0100").val()+"']");
			selectObj.attr("selected","selected");
			$(cWindow.document).find("#field0100_txt").val($("#field0100_txt").val());
			
			//事项分类
			$(cWindow.document).find("#field0022 option[value='"+$("#field0022").val()+"']").attr("selected","selected");
			$("#field0022_txt",cWindow.document).val($("#field0022_txt").val());
			
			//上级事项
			$("#field0019",cWindow.document).val($("#field0019").val());
			$("#field0131",cWindow.document).val($("#field0131").val());
			
			//重置督办人
			$(cWindow.document).find("#field0095_txt").val('');
			$(cWindow.document).find("#field0095").val('');
			$(cWindow.document).find("#field0095_txt").removeClass("validate");
			
			//分解时如果有关联文档，则重置noWrap
			addNoWrap();
		}
	}else{//修改则初始化承办人
		unitChange();
		//修改时，判断预警是否有值
		var yuJing=$("#field0012",cWindow.document);
		if(yuJing.val()==''){
			$(cWindow.document).find("#field0012 option[val4cal='2']").attr("selected","selected");
			$(cWindow.document).find("#field0012_txt").val("正常");
		}
		
		addNoWrap();
	}
	
	$(cWindow.document).find("#field0019").attr("readonly","readonly");
	$("#field0019",cWindow.document).css("background-color","#F8F8F8");
	var parentTitle=$("#field0019",cWindow.document).val();
	var pSupId=$("#field0131",cWindow.document).val();
	if(parentTitle!=''&&pSupId!=''){
		//修改时判断上级事项是否存在，如果存在，则处理穿透部分,因为上级事项在业务包中是编辑态，解析到页面标签是textarea，无法增加超链接，所以手动append span标签
		var url=_ctxPath+"/supervision/supervisionController.do?method=formIndex&masterDataId="+pSupId+"&isFullPage=true&moduleId="+pSupId+"&moduleType=37&contentType=20&viewState=2";
		var pHtml="<a style=\"cursor: hand;\" title='"+parentTitle+"' onclick=\"openDetailURL('"+url+"')\" class=\"hand\">"+parentTitle+"</a>";
		var spanHTML="<div><span id=\"parentSupervision\" style=\"overflow:hidden\">"+pHtml+"</span></div>";
		
		$("#field0019",cWindow.document).hide();
		$("#field0019_span",cWindow.document).parent().parent().append(spanHTML);
		
		//$("#field0019",cWindow.document).html('');
		//$("#field0019",cWindow.document).append(pHtml);
		$("#parentSupervision",cWindow.document).css("text-overflow","clip");
		$("#parentSupervision",cWindow.document).css("border","1px solid #D7D7D7").css("border-radius","5px 5px 5px 5px");
		$("#parentSupervision",cWindow.document).css("font-size","14px").css("height","20px");
		$("#parentSupervision",cWindow.document).css("max-height","20px").css("min-height","20px");
		$("#parentSupervision",cWindow.document).css("padding","3px");
		$("#parentSupervision",cWindow.document).css("white-space","pre-wrap");
		var width=$("#field0019",cWindow.document).css("width");
		$("#parentSupervision",cWindow.document).css("width",(parseInt(width)-8)+"px");
		$("#parentSupervision",cWindow.document).css("display","block");
	}else{
		$(cWindow.document).find("#field0019_span").parent().show();
	}
	$(cWindow.document).find("#field0100").hide();
	$(cWindow.document).find("#field0100_txt").hide();
	$(cWindow.document).find("#field0100_span").hide();

	//初始化来文依据
	if(isFrom=='govdoc'){//来文转督办，初始化关联公文
		$(cWindow.document).find("#field0023").text(govDocTitle);
		//追加到来文依据中
		var attachmentObj=$(cWindow.document).find("div[id^='attachment2Area']");
		var attachmentId=attachmentObj.attr("id");
		cWindow.addAttachmentPoi("2",govDocTitle, "edoc", createTime, 0, summaryId, true, false,
				affairId, null, "edoc.gif", attachmentObj.attr("poi"), "", "",
				null,null,attachmentObj.attr("embedInput"));

		attachmentObj.css("background-color","#FFFFFF");
	}
	//新建或修改时，承办人选人按钮屏蔽,责任单位、协办单位、交办单位不支持手写输入
	$("#field0134_txt",cWindow.document).next().next().hide();
	$("#field0001_txt",cWindow.document).attr("readonly","readonly");
	
	$("#field0002_txt",cWindow.document).attr("readonly","readonly");
	$("#field0087_txt",cWindow.document).attr("readonly","readonly");
	
	//销账时间只读
	$("#field0126",cWindow.document).attr("readonly","readonly");
	$("#field0126",cWindow.document).css("background-color","#F8F8F8");
	$("#field0126",cWindow.document).next().hide();
	
	//新建或修改时，判断事项分类，如果是来文，则来源依据必填
	if(typeof(supType)!='undefined' && supType=='2'){
		var attachmentObj=$("div[id^='attachmentDiv_']",cWindow.document);
		$("#field0093_span",cWindow.document).addClass("editableSpan");//控件必填则添加editableSpan的class
		if(attachmentObj.length==0){
			var attachment2Area=$("div[id^='attachment2Area']",cWindow.document);
			attachment2Area.css("background-color","#FCDD8B");
		}
	}
	$(cWindow.document).find(".attachmentShowDelete").css("max-width","none");
	
	//判断supType
	if(typeof(supType)!='undefined' && supType!=''){
		var typeName=$("#type"+supType).html();
		$(".xl_bar_select").find("a").html(typeName);
	}
	
	//未知原因：不知道为什么在IE9和IE10设置了兼容性视图后，第一次加载时页面获取IE控件是IE9/10，但是是以IE7标准加载的，通过F12设置兼容，IE版本号则是IE7，所以此处添加宽度差判断
	//获取同一列组织机构控件和完成时限控件宽度差
	var w1=$("#field0001_txt",cWindow.document).width();
	var w2=$("#field0028",cWindow.document).width();
	var w=w2-w1;
	var isCalc=false;
	if(w>8){//当两个控件宽度大于8，则把组织机构控件的宽度+13
		isCalc=true;
	}
	
	//循环需要处理的组织机构组件或选人组件，在IE7下增加宽度
	var changeW=["field0002_txt","field0003_txt","field0087_txt","field0096_txt","field0095_txt","field0134_txt","field0088_txt","field0001_txt"];
	if($.browser.msie && ($.browser.version=='7.0'||isCalc)){
		for(var i=0;i<changeW.length;i++){
			var input=$("#"+changeW[i],cWindow.document);
			var w = input.width()+13;//在jquery.comp-debug.js中的$.fn.selectPeople，当时IE7是宽度-15，反之-2
			if(w>0){
				input.width(w);
			}
		}
	}
	
	var sMinus=9;
	if(isCalc==true && $.browser.msie && !($.browser.version=='7.0'||$.browser.version=='8.0')){
		//当宽度差多大并且不是IE7或IE8，则差=13
		sMinus=13;
	}
	
	//循环下拉框字段在IE7或兼容模式下增加宽度
	var selectW=["field0149_txt","field0024_txt","field0022_txt","field0099_txt","field0085_txt"];
	if(($.browser.msie && ($.browser.version=='7.0'||$.browser.version=='8.0'))||isCalc){
		for(var i=0;i<selectW.length;i++){
			var input=$("#"+selectW[i],cWindow.document);
			var w = input.width()-sMinus;
			if(w>0){
				input.width(w);
			}
		}
	}
	
	for(var i=0;i<selectW.length;i++){
		var input=$("#"+selectW[i],cWindow.document);
		input.next().css("height","28px");
	}
	
}

//选择责任单位 或 部门后查询出本单位或部门的督办联络员
function unitChange(){
	cWindow = document.getElementById("newFormDataFrame").contentWindow;
	var unitId=$(cWindow.document).find("#field0001").val();
	if(unitId==''){
		return;
	}
	if(!$.ctx.plugins.contains('supervision')){
		return;
	}
	var supManager = new supervisionManager();
    var takerIdAndNames=supManager.findUndertakerByUnit(unitId);
    if(takerIdAndNames!='' && takerIdAndNames!=null){
	    var takerObj=eval(takerIdAndNames);
	    if(takerObj!=null && takerObj.valueIds!='undefined'){
	    	$(cWindow.document).find("#field0134").val(takerObj.valueIds);
	    }
	    if(takerObj!=null && takerObj.valueNames!='undefined'){
	    	$(cWindow.document).find("#field0134_txt").val(takerObj.valueNames);
	    }
	    if(takerObj!=null && takerObj.noMsg!='undefined' && takerObj.noMsg!=''){
	    	dbAlert($.i18n('supervision.newinfo.nosupervisemember',takerObj.noMsg));
	    }
    }
}

function addNoWrap(){
	try{
		cWindow = document.getElementById("newFormDataFrame").contentWindow;
		$(".attachmentShowDelete",cWindow.document).each(function(){
			$(this).attr("noWrap","noWrap");
		})
	}catch(e){}
}

function checkLock(){
    var tempLocker = cWindow.formDataLocker;
    if(tempLocker!=undefined&&tempLocker!=''){
        $("#unflowbtnsave").remove();
        $.messageBox({
            'title' : $.i18n('form.formula.engin.systeminfo.label'),//系统提示
            'type' : 0,
            'msg' : tempLocker + $.i18n('form.newdata.isEditor.label'),//正在编辑此记录
            close_fn:function(){
                tips = false;
                selfClose();
            },
            ok_fn : function() {
                tips = false;
                selfClose();
            }
         });
    }
}

function saveUnflowData(needClose){
    if(cWindow==undefined||cWindow.getMainBodyDataDiv$==undefined){
        return;
    }
    
    var field0023Val=$("#field0023",cWindow.document).val();
    if($.trim(field0023Val)==""){
    	dbAlert($.i18n('supervision.name.notnull'));
    	$("#field0023",cWindow.document).val('');
    	$("#field0023",cWindow.document).css("background-color","#fcdd8b");
		return;
    }
    
    var field0004Val=$("#field0004",cWindow.document).val();
    var currentDate=new Date().format("yyyy-MM-dd");
    if(field0004Val!='' && field0004Val<currentDate){
    	dbAlert($.i18n('supervision.date.validate1'));
		return;
	}
	
    var preDate=$("#field0004").val();
	if(preDate!='' && field0004Val>preDate){
		dbAlert($.i18n('supervision.date.validate2'));
		return;
	}
    
    //来文督办保存时 校验是否有 来源/依据
    if(typeof(supType)!='undefined' && supType=='2'){
		var attachmentObj=$("div[id^='attachmentDiv_']",cWindow.document);
		if(attachmentObj.length==0){
			dbAlert($.i18n('supervision.source.notnull'))
			return;
		}
	}
    
    //当紧急程度为空时，重置值
    if($(cWindow.document).find("#field0099_txt").val()==''){
    	$(cWindow.document).find("#field0099").val('');
    }
    
    //判断事项状态，如果是已签收或已销账，则记录对应的时间和操作人
    var status=$(cWindow.document).find("#field0024 option:selected");
    var value_txt=$(cWindow.document).find("#field0024_txt").val();
    var calValue=status.attr("val4cal");
    
    if(calValue=='2' || value_txt=='进行中'){
    	$("#field0133_txt",cWindow.document).val($.ctx.CurrentUser.name);
    	$("#field0133",cWindow.document).val($.ctx.CurrentUser.id);
    	$("#field0125",cWindow.document).val(currentDate);
    }
    if(calValue=='3' || value_txt=='已销账'){
    	$("#field0132_txt",cWindow.document).val($.ctx.CurrentUser.name);
    	$("#field0132",cWindow.document).val($.ctx.CurrentUser.id);
    	$("#field0126",cWindow.document).val(currentDate);
    }
	
    saveProcessBar = new MxtProgressBar({text: ""});
    $("#unflowbtnsave").removeClass("common_button_disable").addClass("common_button_disable").unbind("click");
    tips = false;
    var title = cWindow.getMainBodyDataDiv$().find("#title").val();
    if(title==undefined||title==''){
        title=" ";
    }
    
    
    cWindow.saveContent(_contentAllId,title,
       function(obj,snMsg){//成功回调方法
    	try{
    		if(isFrom=='govdoc' && $.ctx.plugins.contains('supervision')){
	    		var supManager = new supervisionManager();
	    		//保存公文与督办事项关联记录
	            supManager.saveEdocSuperviseRelation(obj.moduleId,summaryId);
    		}

    		if(typeof(snMsg) !="undefined" && snMsg!=""){
    			dbAlert(snMsg);
    		}
    		if($.trim(window.opener) != ""){
    			//来源于栏目时,获得回调函数来执行子自动刷新栏目
    	    	if("unflowSection" == _fromSrc){
    	    		window.opener.unflowSectionCallback();
    	    	}else{
    	    		window.opener.breakId=parentId;
    	    		window.opener.refreshFormDataPage();
    	    	}
    		}
    	}catch(e){}
        if(needClose){
        	//修改后关闭时刷新列表页面
        	/*try{
	        	if(window.opener && (typeof window.opener.refreshFormDataPage != 'undefined')){
	        		window.opener.breakId=parentId;
	        		window.opener.refreshFormDataPage();
	        	}
        	}catch(e){}*/
        	selfClose();
            return;
        }else{
            //保存并新建的时候需要给当前新建的数据进行解锁操作
            if(cWindow.removeSessionMasterData){
                cWindow.removeSessionMasterData();
            }
            cWindow.location.href = cWindow.location.href;
            tips = true;
        }
        $("#unflowbtnsave").removeClass("common_button_disable").unbind("click").bind("click",function(){saveUnflowData(true)});
        saveProcessBar.close();
    },function(obj){//失败回调
    	tips = true;
        $("#unflowbtnsave").removeClass("common_button_disable").unbind("click").bind("click",function(){saveUnflowData(true)});
        saveProcessBar.close();
    });
}

function ruleErrorMsg(msg){
	var errorMessage = $.parseJSON(msg);
	var oldMsg="设置了唯一标示，数据不满足唯一标示组合！";
	var newMsg="事项名称或事项流水号重复，";
	var cWindow = document.getElementById("newFormDataFrame").contentWindow;
	if (errorMessage.ruleError) {
		var errorMsg=errorMessage.ruleError;
		if(errorMsg.indexOf(oldMsg)!=-1){
			errorMsg=errorMsg.substr(errorMsg.indexOf(oldMsg)).replace(oldMsg,newMsg);
		}
		dbAlert(errorMsg);
		var fields = errorMessage.fields;
		for ( var i = 0; i < fields.length; i++) {
			if(typeof cWindow.changeValidateColor != "undefined"){
				cWindow.changeValidateColor(fields[i]);
			}
		}
	}
}
/**
 * 关闭页面
 */
function selfClose(){
    window.close();
}

