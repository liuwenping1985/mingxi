var isShowSon = false;//是否有子事项展开，主要是在展开子事项后，后面的父事项查看是有问题的，要进行特殊处理的
var _windowsMap = new Properties();//定义全局的map，在window.open中打开的地址放入此map中，因为弹出框中无getCtpTop()对象
function callBackTotal(n){
    $("#titleDiv").find("div>div>span").html(n);
}
/**
 * 刷新列表页面
 */
function refreshFormDataPage(){
    $("#mytable").ajaxgridLoad(gridPramsObj);
};

//页面作为弹出对话框点击确定的时候的返回值方法
function OK(){
    var selectedBox = new ArrayList();
    $("#mytable").find("input[type='"+selectBtmType+"']").each(function(){
        if(this.checked){
            selectedBox.add(this);
        }
    });
    var selectArray = new Array();
    var viewFrame = $("#viewFrame");
    var moduleId = viewFrame[0].contentWindow.getParameter!=undefined?viewFrame[0].contentWindow.getParameter("moduleId"):"0";
    /**返回数据格式
    *{toFormId:yyyy,
    selectArray:[{masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]},
    {masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]}]
    }
    */
    $(selectedBox.toArray()).each(function(masterIndex){
        var jqThis = $(this);
        var tempObj = new Object();
        tempObj.masterDataId = jqThis.val();
        var subData = new Array();
        for(var i=0;i<toFormBean.tableList.length;i++){
            var tempTable = toFormBean.tableList[i];
            if(tempTable.tableType.toLowerCase()==="slave"){
                var tempSubData = new Object();
                tempSubData.tableName = tempTable.tableName;
                if(jqThis.val()==moduleId){
                    var subDom = $("#"+tempTable.tableName,viewFrame);
                    var tempSubArray = new Array();
                    if(subDom){
                        var allCheckedBox = $(":checkbox[checked][tableName='"+tempTable.tableName+"']",$(viewFrame[0].contentWindow.document));
                        if(allCheckedBox.length==0){
                            allCheckedBox = $(":checkbox[tableName='"+tempTable.tableName+"']:eq(0)",$(viewFrame[0].contentWindow.document));
                        }
                        allCheckedBox.each(function(){
                            tempSubArray.push($(this).val());
                        });
                    }
                    tempSubData.dataIds = tempSubArray;
                }
                subData.push(tempSubData);
            }
        }
        tempObj.subData = subData;
        selectArray.push(tempObj);
    });
    var obj = new Object();
    obj.selectArray = selectArray;
    obj.toFormId = toFormBean.id;
    return $.toJSON(obj);
}

//外部写入显示格式是枚举,需要客户手工选择枚举后才能显示值
function selectEnums4search(param,id){
    var obj = new Array();
    obj[0] = window;
    var dialog = $.dialog({
            url:_ctxPath + "/enum.do?method=bindEnum&isfinal=false&isFinalChild=false&bindId=0&isBind=false",
            title : $.i18n('form.field.bindenum.title.label'),//绑定枚举
            width:500,
            height:520,
            targetWindow:getCtpTop(),
            transParams:obj,
            buttons : [{
              text : $.i18n('form.trigger.triggerSet.confirm.label'),
              id:"sure",
              handler : function() {
                  var result = dialog.getReturnValue();
                  if(result){
                    var fMgr = new formManager();
                    var html = fMgr.getFieldHTML4Select(result.enumId,result.isFinalChild==null?false:result.isFinalChild,result.nodeType);
                    html = html.replace("id='field' name='field'","id='"+id+"' name='"+id+"'");
                    html = "<input type='text' style='width:50%' value='"+result.enumName+"' onclick='selectEnums4search($(this),\""+id+"\")'>"+html;
                    param.parent().html(html);
                    $("#"+id).css('width','50%');
                    dialog.close();
                  }
              }
            }, {
              text : $.i18n('form.query.cancel.label'),
              id:"exit",
              handler : function() {
                  returnObj = false;
                  dialog.close();
              }
            }]
    });
}

$('#fieldname').change(function(){
    if($(this).children('option:selected').val()!=''){
        $("#formula").removeProp("disabled");
        $("#formula ").get(0).selectedIndex=0;
    }else{
        $("#formula").val("");
        $("#formula").prop("disabled",true);
    }
});

//查核删除按钮是否可用
function checkDel(data){
    $("#del_a").removeProp("disabled");
    if( _formType === "2" && data.start_member_id !== $.ctx.CurrentUser.id){
        $("#del_a").prop("disabled",true);
    }
}

function dblclk(data, r, c){
	//查看子事项时不调用该方法，同时只要有展开的子事项，后续父事项获取不正确，跳过---start xuym
	var tb = document.getElementById("mytable");
	var id = tb.rows [r].id;
	if(id.indexOf("formson_tr") > -1){
		return;
	}
	//有子事项展开进行处理
	if(isShowSon){
		if(!data || id.indexOf(data.id) == -1){
			var dataObj = grid.grid.getSelectRows();
			data = dataObj[0];
		}
	}

	//查看子事项时不调用该方法，，同时只要有展开的子事项，后续父事项获取不正确，跳过---end
    if(isFormSection == 'true'){
        //视图ID和新建权限ID ，_formType ==="2" 表示信息管理
        if (_formType ==="2") {
            _editAuth = _editAuthJson;
        }
        //信息管理
        if(_moduleType == "37"){
            var _editAuthObj = $.parseJSON(_editAuth);
            if(_editAuthObj == "" || _editAuthObj.length == 0){
                clk(data, r, c);
                return;
            }
        }
        dblclickFun(data.id,_formId,_formTemplateId,_moduleType,_editAuth,"formMasterDataList");
    }else{
        if(delnum!==0){
            checkDel(data);
        }
        //改为使用dialog而不是模态对话框，因为模态对话框下刷新页面要自己打开一个新窗口
        /*var dialog = $.dialog({
            url:getUnflowFormViewUrl("true",data.id,_moduleType,_firstRightId,2),
            title : " ",
            targetWindow : getCtpTop(),
            width:$(getCtpTop()).width()-100,
            height:$(getCtpTop()).height()-100,
            isClear:false
        })*/
        var rCode=document.getElementById("rCode").value;
		var url=_ctxPath+"/supervision/supervisionController.do?method=formIndex&masterDataId="+data.id+"&isFullPage=true&moduleId="+data.id+"&moduleType="+_moduleType+"&rightId="+_firstRightId+"&contentType=20&viewState=2&rCode="+rCode+"&supType="+supType;
		openCtpWindow({"url":url});
    }
}

function getTHWidthTable(thCount){
    if(thCount>=10){
          return "10%";
    }
    return 100/thCount+"%";
}


//逐条查询完成情况、领导是否关注和是否有分解事项
var lastFeedBack,isAttention,hasSon;
function getInfoBeforReady(id,isMaster){
	var supManager = new supervisionManager();
	var result = supManager.getJSonBeforeReady(id,supType,isMaster);
	if(result && result[0]){
		lastFeedBack = typeof(result[0].lastFeedBack)=="undefined"?"":result[0].lastFeedBack;
		isAttention = typeof(result[0].isAttention)=="undefined"?false:result[0].isAttention;
		hasSon = typeof(result[0].hasSon)=="undefined"?false:result[0].hasSon;
	}else{
		lastFeedBack = "";
		isAttention = false;
		hasSon = false;
	}
}

function rend(txt, data, r, c,col) {
    //是否已锁定
    if ("*"==txt) {
        return txt;
    }
    if(col.name == 'field0012'){
    	//领导查关注和完成情况
    	getInfoBeforReady(data.id,true);
    }else if(col.name == 'field0023' || col.name == 'field0027'){//事项名称
    	//设置两行
    	return getSubjectText(txt,data,false);
    }else if(col.name == 'field0024'){//事项状态
    	return stateText(data);
    }else  if(col.name == 'field0026'){//操作
    	return getOptionText(data);

    }else if(col.name == 'field0028'){//完成进度
    	return progressbarText(txt,data);
    }

    if((supType == '0' && c ==7 ) || (supType == '1' && c ==6 ) || (supType == '2' && c == 8) || (supType == '3' && c == 8)){
    	return lastFeedBack;
    }


    if((data.state === 3 || data.state === "3") && c === 1 &&  _formType  === "2"){
        return '<span class="ico16 locking_16"></span>';
    } else if(col.isDisplayImage && col.isDisplayImage == "true" && txt && txt != ""){
        var imgSrc = _ctxPath+"/fileUpload.do?method=showRTE&fileId="+txt+"&expand=0&type=image";
        return "<img class='showImg' src='"+imgSrc+"' height=25 />";
    } else {
        var tempval = ""+txt;
        var regexpBr = new RegExp("<br/>","gm");
        var resTxt = tempval.replace(regexpBr,"");
        var isUrl = false;
        if(urlFieldList){
            for(i in urlFieldList){
                if(urlFieldList[i] == col.name){
                    isUrl = true
                    break;
                }
            }
        }
        if(isUrl){
            return '<a class="noClick" href='+resTxt+' target="_blank">'+resTxt+'</a>';
        }else{
            return resTxt;
        }
    }
}

function getSubjectText(txt,data,isSon){
	var str = "";
	if(!isSon){
		var width = "0px";
		if(hasSon){
			width = "19px";
		}
		str = "<i id=\"breaki"+data.id+"\" class='noClick' style='width:"+width+";' onclick='obtainSubList(\""+data.id+"\",this)'></i>";
	}
	str = str + "<span class='xl_name'>"+txt+"</span>&nbsp;";
	if(data.field0099 !==""&& data.field0099 == '急'){//添加紧急程度
		str = str+'<img class="quick" src="'+_ctxPath+'/apps_res/supervision/img/urgent.png">';
	}
	return str;
}

/**
 *
 * @param data
 * @param isShowForUnitSpace  承办人空间，子事项的承办人是否为本人，true:子事项承办人不是当前人
 * @return
 */
function getOptionText(data,isShowForUnitSpace){
	if(isCo_manager){
		return "";
	}
	var str = "";
	if(rCode=='F20_SuperviseLeaderSpace'){//领导
		/*
		 * 2017-6-10  经核实领导角色可以对主子事项进行批示，故先注释
		 * if(data.field0096.indexOf(""+$.ctx.CurrentUser.name) > -1){*///分管领导不是当前登录人的不显示批示
		if(data.field0024 != "已销账"){//已销账不能进行批示
			str = str +"&nbsp;&nbsp;<input type='button' class='noClick' value='批示' onclick=\"comments('"+data.id+"')\"/>";
		}
		//列表加载，判断是关注还是取消关注
		if(isAttention){
			str = str + "&nbsp;&nbsp;<input type='button' value='取消关注' class='noClick' style='width:66px' onclick=\"attention('"+data.id+"',this)\"/>";
		}else{
			str = str + "&nbsp;&nbsp;<input type='button' value='关注' class='noClick' onclick=\"attention('"+data.id+"',this)\"/>";
		}
	}
	if(rCode=='F20_SuperviseStaffSpace' && data.field0024 != "已销账"){//督办人,已销毁的不可进行分解
		if(typeof(isShowForUnitSpace)=="undefined"){//一级事项
			str = str + "&nbsp;&nbsp;<input type='button' value='分解' class='noClick' onclick=\"breakSup('"+data.id+"','"+data.field0004+"','"+data.field0100+"')\"/>";
		}
		if((typeof(isShowForUnitSpace)=="undefined" || isShowForUnitSpace) && data.field0024 != "已销账"){//一级事项或者二级事项为督办人
			str = str + "&nbsp;&nbsp;<input type='button' value='催办' class='noClick' onclick=\"hasten('"+data.id+"')\"/>";
		}
	}
	if(rCode=='F20_ResponsibleUnitSpace'){//承办人,进行中的事项进行分解
		if(typeof(isShowForUnitSpace)=="undefined"  && data.field0024 == "进行中"){//二级不显示分解
			str = str + "&nbsp;&nbsp;<input type='button' value='分解' class='noClick' onclick=\"breakSup('"+data.id+"','"+data.field0004+"','"+data.field0100+"')\"/>";
		}
		if(isShowForUnitSpace && data.field0024 != "已销账"){//分解事项,当前人为事项的创建人
			str = str + "&nbsp;&nbsp;<input type='button' value='催办' class='noClick' onclick=\"hasten('"+data.id+"')\"/>";
		}
	}

	return str;
}

/**
 * 完成进度显示内容
 * txt：完成进度
 * data：事项对象
 * @return
 */
function progressbarText(txt,data){
	var point = txt.substring(0,txt.length-1);
	txt =  "<span class='progressbar_1'><span class='bar' style='width:"+(txt==""?"0%":txt)+"'></span></span>&nbsp;<span class='progressTxt'>"+(txt==""?"0%":txt)+"</span>";
	//添加评、签和销图标
	if(data.field0024 == "待签收"){//事项状态为未签收时，显示签
		txt =  txt + '<img class="progressbar_icon" src="'+_ctxPath+'/apps_res/supervision/img/qian.png">';
	}else if(data.field0024 == "进行中" && point < 100){//事项状态为进行中时，显示评
		txt =  txt + '<img class="progressbar_icon" src="'+_ctxPath+'/apps_res/supervision/img/ping.png">';
	}else if(point == 100 && data.field0024 != "已销账"){//事项状态为未签收时，显示签
		txt =  txt + '<img class="progressbar_icon" src="'+_ctxPath+'/apps_res/supervision/img/xiao.png">';
	}else if(data.field0024 == "已销账"){//如果已销账
		txt =  txt + '<img class="progressbar_icon" src="'+_ctxPath+'/apps_res/supervision/img/yixiao.png">';
	}
	return txt;
}

/**
 *
 * @param data
 * @return
 */
function stateText(data){
	var tHtml = "";
	if(data.field0010 != "" && data.field0010 != "0"){
		tHtml = tHtml + '<span class="remind" title="催办'+data.field0010+'次"><b class="remind-01"></b><span>'+data.field0010+'</span></span>';
	}
	if(data.field0115 != "" && data.field0115 != "0"){
		tHtml = tHtml + '<span class="remind" title="关注'+data.field0115+'次"> <b class="remind-02"></b> <span>'+data.field0115+'</span> </span>';
	}
	if(data.field0118 != "" && data.field0118 != "0"){
		tHtml = tHtml + '<span class="remind" title="批示'+data.field0118+'次"> <b class="remind-03"></b><span>'+data.field0118+'</span> </span>'
	}
	if(tHtml.length == 0){
		tHtml = "无";
	}
	return tHtml;
}

function add(){
	var url =_ctxPath+"/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&viewId=0&formTemplateId=0&formId=0&moduleType=37&isSupervise=true&supType=" + supType;
	openCtpWindowDb({"url":url});
}

function doHideRefresh(rightId,ids){
    //"表单数据刷新修改中..."
    getCtpTop().processBar =  getCtpTop().$.progressBar({text: $.i18n('form.data.edit.hide.fresh.label')});
    var rapidEditor = new formDataManager();
    rapidEditor.fixDefaultValue4HiddenRefresh(rightId,ids,_formTemplateId,toFormBean.id,{
        success: function(result){
            afterBatchOperation(result,'form.modifiy.hide.suc.label','form.modifiy.hide.error.label',ids.length);
        }});
}

/**
 *获取被选中的数据的id，返回id数组
 */
 function getSelectedIds(){
     var returnArray = [];
     $("#mytable").find("input[type='checkbox']").each(function(){
         if(this.checked==true){
             returnArray.push($(this).val());
         }
     });
     return returnArray;
 }
var locking = false;
//锁定
 function lock(){
     if (locking) {
         return;
     }
     var ids = getSelectedIds();
     var delid = "";
     if(ids.length!=1){
         if(ids.length<1){
             dbAlert($.i18n('form.formlist.pleasechooseone'));
             return;
         }else{
             for(var i=0;i<ids.length;i++){
                 if(i===ids.length-1){
                     delid+=ids[i];
                 }else{
                     delid+=(ids[i]+",");
                 }
             }
         }
     }else{
         delid = ids[0];
     }
     locking = true;
     var form = new formManager();
     form.setLock(_formId,delid,_formTemplateId,{
         success: function(check){  //查核通过
             if(check){
            	 dbInfor($.i18n('form.formmasterdatalist.lockedsucess'));
                 //刷新数据,而不是整个页面
                 $("#mytable").ajaxgridLoad(gridPramsObj);
             }else{
                 //提交
                 dbAlert($.i18n('form.formmasterdatalist.lockederror'));
             }
             locking = false;
         }
     });
 }
 //解锁
 function unlock(){
     if (locking) {
         return;
     }
     var ids = getSelectedIds();
     var delid = "";
     if(ids.length!=1){
         if(ids.length<1){
             dbAlert($.i18n('form.formlist.pleasechooseone'));
             return;
         }else{
             for(var i=0;i<ids.length;i++){
                 if(i===ids.length-1){
                     delid+=ids[i];
                 }else{
                     delid+=(ids[i]+",");
                 }
             }
         }
     }else{
         delid = ids[0];
     }
     locking = true;
     var form = new formManager();
     form.unLock(_formId,delid,_formTemplateId,{
         success: function(check){  //查核通过
             if(check){
            	 dbInfor($.i18n('form.formmasterdatalist.unlocksucess'));
                 //刷新数据,而不是整个页面
                 $("#mytable").ajaxgridLoad(gridPramsObj);
             }else{
                 //提交
                 dbAlert($.i18n('form.formmasterdatalist.unlockerror'));
             }
             locking = false;
         }
     });
 }

 function printFormContent(){
 	 /*
 	  * 为表单定做打印功能
 	  */
 	 $("#viewFrame").unbind("load");
     window.open(_ctxPath+"/common/form/common/print/printForm.jsp");
     /**
      * 注释掉之前的打印功能
      */
//     //如果是关联表单弹出列表，需要在重复项和重复节之前添加选择框
//     if(_type==="formRelation"&&this.contentWindow.initRelationSubTable){
//         this.contentWindow.initRelationSubTable(relationInitParam);
//     }
//     //将打印操作放到viewframe的load方法中去，不然viewFrame都是空的怎么打印啊，亲。
//     var colBody = $(document.getElementById('viewFrame').contentWindow.document.body);
//
//     var currentViewContent = $("#mainbodyHtmlDiv_"+$("#_currentDiv",colBody).val(),colBody);
//     var colBodyFrag = new PrintFragment('', currentViewContent.html());
//     var cssList = new ArrayList();
//     cssList.add("/apps_res/collaboration/css/collaboration.css");
//     var pl = new ArrayList();
//     pl.add(colBodyFrag);
//     getCtpTop().PrintHtml = currentViewContent;
//     printList(pl,cssList,null,null,20);
//     //OA-42658  基础数据/信息管理列表中选中一条记录打印后，关闭打印界面，此时新建、修改、删除记录确定后，都会自动弹出打印界面。
//     $("#viewFrame").unbind("load");
 }

//模板下载
 function downTemplate(){
     var newFormAuth = _newFormAuth;
     var strs = newFormAuth.split(".");
     var viewId = strs[0];
     var rightId = strs[1];
     var url = _ctxPath + "/form/formData.do?method=downTemplate&formTemplateId=" + _formTemplateId + "&formId=" + _formId + "&rightId="+rightId+"&supType="+supType;
     $("#downTemplate").attr("src",url);
 }
 //导入excel
 function inportExcel(){
     insertAttachment("callBk");
 }

//删除
 function del(){
     var form = new formManager();
     var ids = getSelectedIds();
     var delid = "";
     if(ids.length!=1){
         if(ids.length<1){
             dbAlert($.i18n('form.formlist.pleasechooseone'));
             return;
         }else{
             for(var i=0;i<ids.length;i++){
                 if(i===ids.length-1){
                     delid+=ids[i];
                 }else{
                     delid+=(ids[i]+",");
                 }
             }
         }
     }else{
         delid = ids[0];
     }
   //当前登录的为督办人可以删除，如果没有督办人，有创建人这可删除---start
     var supManager = new supervisionManager();
     for(var i=0;i<ids.length;i++){
    	 var data = supManager.getMasterDateById(ids[i]);
    	 if(data == null){
    		 dbAlert("事项已不存在！");
    		 refreshFormDataPage();
	         return;
    	 }
	     if( _formType ==="2"&& !(data.field0095 == $.ctx.CurrentUser.name || (data.field0095 == "" && data.start_member_id == $.ctx.CurrentUser.id))){
	         dbAlert("您没有权限删除\""+data.field0023+"\"事项！");
	         return;
	     }
     }
     //不是自己新建的督办不可删除---end


     dbConfirm({
         'msg' : "该操作不能恢复，分解的事项将同步删除，是否进行删除操作?",
         ok_fn : function() {
             form.checkLock(_formId,delid,{
                 success: function(check){  //查核通过
                     if(check){
                         //提交
                         dbAlert($.i18n('form.formmasterdatalist.belockedcantdel'));
                         return;
                     }else{
                         var str = form.checkDataLock(delid);
                         if (str != ""){
                             dbAlert(str);
                             return;
                         }
                         getCtpTop().processBar1 =  getCtpTop().$.progressBar({text: '数据删除中……'});
                         var supManager = new supervisionManager();
                         supManager.delFormData(delid,_formTemplateId,{
	                         success: function(check){  //查核通过
                                 if (getCtpTop().processBar1) {
                                     getCtpTop().processBar1.close();
                                 }
	                             if(check){
	                                 /*$.infor({
	                                 'msg' : $.i18n('form.formlist.delcategorysucess'),
	                                 ok_fn : function() {
	                                 }
	                                 });*/
	                            	 dbInfor($.i18n('form.formlist.delcategorysucess'));
	                                 //刷新数据,而不是整个页面
	                                 $("#mytable").ajaxgridLoad(gridPramsObj);
	                                 $("#viewFrame").attr("src","");
	                                 $("#titleDiv").show();
	                             }else{
	                                 //提交
	                                 dbAlert($.i18n('form.formlist.delcategoryerror'));
	                             }
	                         }
                         });
                     }
                 }
             });
         }
     });
 }

//导出excel
 function exporttoExcel(){
     if(showFields.length>255){
     	//EXCEL的最大支持列数是255,目前已经超过,请联系管理员!
         dbAlert($.i18n('excel.download.column.error'));
         return;
     }
     var queryConditionStr = $.toJSON(gridPramsObj);
     var newFormAuth = _newFormAuth;
     var strs = newFormAuth.split(".");
     var viewId = strs[0];
     var rightId = strs[1];
     var fm = new formManager();
     var result = fm.canDownload(_formId, _formTemplateId, $.ctx.CurrentUser.id);
     if (result && result.success) {
         var confirm = dbConfirm({
             'msg': $.i18n('form.export.excel.msg'),
             ok_fn: function () {
                 $.batchExport($("#mytable")[0].p.total,function(page,size,queryConditionStr1){
                     $("#exporttoExcel").attr("src",_ctxPath + "/form/formData.do?method=exporttoExcel&formTemplateId=" + _formTemplateId + "&formId=" + _formId + "&rightId="+rightId+"&page="+page+"&size="+size+"&queryConditionStr="+encodeURIComponent(encodeURIComponent(queryConditionStr))+"&supType="+supType);
                 });
             }
         });
     } else {
         if (result && result.errorKey == "haveRecord") {
             dbAlert($.i18n('form.export.excel.msg'));
         }
     }
 }


//打印
 function print(){
     var ids = getSelectedIds();
     var id = "";
     if(ids.length!=1){
         if(ids.length<1){
             dbAlert($.i18n('form.formlist.pleasechooseone'));
             return;
         }else{
             dbAlert($.i18n('form.formlist.canonlychooseone'));
             return;
         }
     }else{
         id = ids[0];
     }
     if($("#viewFrame").attr("src")!=""&&$("#viewFrame").attr("src").indexOf(id)>=0){//已加载选中数据正文，直接打印；
         printFormContent();
     }else{  //否则先加载正文后再执行打印
         //直接选中列表中的数据时打印：在内容区域打开表单，然后获取页面HTML代码打印。
         $("#viewFrame").attr("src",getUnflowFormViewUrl("true",id,_moduleType,_firstRightId,2));
         $("#viewFrame").unbind("load").bind("load",function(){setTimeout("printFormContent()",500);});
     }
 }

//单行日志
 function singleLog(){
     var ids = getSelectedIds();
     var id = "";
     if(ids.length!=1){
         if(ids.length<1){
             dbAlert($.i18n('form.formlist.pleasechooseone'));
             return;
         }else{
             dbAlert($.i18n('form.formmasterdatalist.onlyviewone'));
             return;
         }
     }else{
         id = ids[0];
     }
     var url = _ctxPath + "/form/formData.do?method=showLog&single=true&recordId="+id+"&formId=" + _formId + "";
     var dialog = $.dialog({
         url: url,
         title : $.i18n('log.record.single.label'),
         width:850,
         height:500,
         targetWindow:getCtpTop(),
         buttons : [{
             text : $.i18n('form.trigger.triggerSet.confirm.label'),
             id:"sure",
             handler : function() {
                 dialog.close();
             }
         }]
     });
 }

//所有日志
 function allLog(){
     var url = _ctxPath + "/form/formData.do?method=showLog&single=false&formId=" + _formId + "&formType=" + _formType + "";
     var dialog = $.dialog({
         url: url,
         title : $.i18n('form.formmasterdatalist.alllogs'),
         width:850,
         height:500,
         targetWindow:getCtpTop(),
         buttons : [{
             text : $.i18n('form.trigger.triggerSet.confirm.label'),
             id:"sure",
             handler : function() {
                 dialog.close();
             }
         }]
     });
 }


//统计
 function doReport(id){
     var url = _ctxPath + "/report/queryReport.do?method=goIndexRight&type=query&openfrom=datalist&reportId="+id;
     queryOrReportDialog = $.dialog({
         url: url,
         title : $.i18n('formsection.homepage.statistic.label'),
         width:$(top.document.body).width() - 60,
         height:$(top.document.body).height() - 100,
         targetWindow:getCtpTop(),
         transParams : window,
         buttons : [{
             text : $.i18n('DataDefine.Close'),
             id:"sure",
             handler : function() {
               queryOrReportDialog.close();
             }
         }]
     });
 }

 function doSearch(){
     var conditon=$("#condition option:selected").val();
     gridPramsObj[conditon]= $("#"+conditon).val();
     $("#mytable").ajaxgridLoad(gridPramsObj);
 }

//第二个参数值若为1：覆盖，否则追加
 function callBk(filemsg,repeat){
     var newFormAuth = _newFormAuth;
     var strs = newFormAuth.split(".");
     var viewId="",rightId="";
     if(strs != ""){
    	 viewId = strs[0];
    	 rightId = strs[1];
     }
     var fileId=filemsg.instance[0].fileUrl;
     if(getCtpTop().processBar){
         getCtpTop().processBar.close();
     }
     getCtpTop().processBar =  getCtpTop().$.progressBar({text: $.i18n('formsection.import.ing')});
     var form = new formManager();
     form.saveDataFromImportExcel(_formId,_formTemplateId,fileId,rightId,repeat,unlockAuth,_templateName+"@@#@@"+supType,{
         success: function(msg){  //查核通过
             getCtpTop().processBar.close();
             if(msg.length===0){
                 //$.infor($.i18n('formsection.import.success'));
            	 //dbInfor($.i18n('formsection.import.success'));
            	 dbInfor($.i18n('supervision.import.success'));
                 $("#mytable").ajaxgridLoad(gridPramsObj);
             }else{
                 dbAlert(msg);
                 $("#mytable").ajaxgridLoad(gridPramsObj);
             }
         }
     });
 }

 function setSearchToolbar(){
     var condition = _commonSearchFields;
     var searchFields = condition.commonSearchFields;
     if(searchFields.length>0){
    	 if(supType == "0"){
    		 var tempFields = new Array();
    		 var num = 0;
    		 //重点工作显示两项
    		 for(var i=0;i<searchFields.length;i++){
    			 if(searchFields[i].id == 'field0023' || searchFields[i].id == 'field0001'){
    				 tempFields[num] = searchFields[i];
    				 num++;
    			 }
    		 }
    		 searchFields = tempFields;
    	 }

         for(var i=0;i<searchFields.length;i++){

        	 //将列表显示字段重命名为要求的名称
        	changeFieldName(searchFields[i]);

             if(searchFields[i].type=="custom"){
            	 if(searchFields[i].fieldType == "project"){
            		 var html = $("<div>" + searchFields[i].customHtml + "</div>");
            		 html.find("#"+searchFields[i].name).width(120);
            		 searchFields[i].customHtml = html.html();
            	 }
                 searchFields[i].getValue = function(kId){
                     var bigContainor = $("#"+searchobj.p.id+"_ul");
                     var c = $("#"+kId+"_container",bigContainor);
                     $.getFieldValueByKey(c,kId);
                     return {'fieldName':kId,'fieldValue':$("#fieldValue",c).val(),'operation':$("#operation",c).val()};
                 }
             }else if(searchFields[i].type=="customPanel"){
                 searchFields[i].customHandler = function(oo){
                     var panelId = oo.currentTarget.id;
                     var kId = panelId.substring(panelId.indexOf("field"),panelId.indexOf("_panel"));
                     var cp = $("#"+kId+"_panel_main");
                     var c = $("input:checked",cp);
                     var show= "";
                     var ids = "";
                     if(c.length>0){
                         c.each(function(i){
                             var text = $(this).parent().text();
                             if (!text){
                                 text=$(this).attr("showvalue");
                             }
                             show = show + text;
                             ids = ids + $(this).val();
                             if(i!=c.length-1){
                                 ids = ids + ",";
                                 show = show + ",";
                             }
                         });
                     }
                     var bigContainor = $("#"+searchobj.p.id+"_ul");
                     var cb = $("#"+kId+"_container",bigContainor);
                     $("#"+kId,cb).val(show);
                     $("#"+kId+"_ids",cb).val("'fieldName':'"+kId+"','fieldValue':'"+ids+"','operation':'"+$("#operation",cp).val()+"'");
                 };
                 searchFields[i].customLoadHandler = function(oId){
                     var idss = $("#"+oId+"_ids").val();
                     if(idss!=""){
                         var ssObj = $.parseJSON("{"+idss+"}");
                         if(ssObj!=null&&ssObj.fieldValue!=""){
                             var idssp = ","+ssObj.fieldValue+",";
                             $(":checkbox","#"+oId+"_span").each(function(){
                                 if(idssp.indexOf(","+$(this).val()+",")>-1){
                                     $(this).prop("checked",true);
                                 }else{
                                     $(this).prop("checked",false);
                                 }
                             });
                         }
                     }
                 };
                 searchFields[i].getValue = function(kId){
                     var bigContainor = $("#"+searchobj.p.id+"_ul");
                     var c = $("#"+kId+"_container",bigContainor);
                     return $.parseJSON("{"+$("#"+kId+"_ids",c).val()+"}");
                 };
             }
         }
     }
     var searchobj = $.searchCondition({
         top:2,
         right:20,
         searchHandler: function(){
             var valueObj = searchobj.g.getReturnValue();
             //新建对象擦除痕迹；
             gridPramsObj = new Object();
           //督办单独加的条件-------start
             setGridDefaultParam(gridPramsObj);
             //督办单独加的条件-------end

             if(valueObj==null){
                 return;
             }
             if(valueObj.condition!=""){
                 gridPramsObj[valueObj.condition]=valueObj.value;
                 queryConditionMap = {};
                 var valueObjeValue ={};
                 //处理汉字
                 if(valueObj.type ==='custom'){
                     valueObjeValue.fieldValue = encodeURIComponent(valueObj.value.fieldValue);
                     valueObjeValue.fieldName = valueObj.value.fieldName;
                     valueObjeValue.operation = valueObj.value.operation;
                     queryConditionMap[valueObj.condition] = valueObjeValue;
                 } else {
                     queryConditionMap[valueObj.condition] = valueObj.value;
                 }
             }

             //获取预警或者是责任的查询条件
             getSelfCondition(gridPramsObj);
             $("#mytable").ajaxgridLoad(gridPramsObj);
         },
         conditions: searchFields
     });
     $("li:not(:first):not(:last)","#"+searchobj.p.id+"_ul").removeClass("hidden");//解决IE7下  选择组织机构comp显示框很小的问题
     $("input[comp*='selectPeople']","#"+searchobj.p.id+"_ul").each(function(){
         var comp = $(this).attr("comp");
         comp += ",extendWidth:false";
         $(this).attr("comp",comp);
         $(this).width(120);
     });
     $("#"+searchobj.p.id+"_ul").comp();
     $("li:not(:first):not(:last)","#"+searchobj.p.id+"_ul").addClass("hidden");
     $("#advanceSearchDiv").css("display","block");
     $(":radio[value='0']","#"+searchobj.p.id+"_ul").each(function(){
         $(this).parents("li:eq(0)").addClass("margin_t_5");
     });
     //特殊处理下拉框样式
     $("li:not(:first):not(:last)","#"+searchobj.p.id+"_ul").find(".common_selectbox_wrap").each(
         function(){
             $(this).find(".common_drop_list").hide();
             $(this).find("input[id$='_txt']").width(105);
         }
     );
     //OA-79713ie7下无流程列表普通查询-枚举字段查询时查询框和输入框直接分开了
    if($.v3x.isMSIE7){
         $("li[id$='_container']","#"+searchobj.p.id+"_ul").each(function(){
             var _this = $(this);
             var _dateLen = $(_this.find("input[class*='input_date']")).length;
             if(_dateLen ==0){
                 _this.css("width","120px");
             }else{
                 _this.css("width","300px");
             }
         });
     }
 }

 /**
  * editAuth : 修改权限
  * hideRefresh : 是否配置了隐藏修改
  */
 function edit(){
     var ids = getSelectedIds();
     if (ids.length < 1) {
         //请选择一条数据!
         dbAlert($.i18n('form.formlist.pleasechooseone'));
         return;
     }

     var id = "";
         if (ids.length > 1) {
             //只能选择一条数据进行编辑!
             dbAlert($.i18n('form.formmasterdatalist.canonlychooseonetoedit'));
             return;
         } else {
             id = ids[0];
         }

         var supManager = new supervisionManager();
         var data = supManager.getMasterDateById(id);

         //校验数据是否存在
         if (!data || data == null || data == 'null') {
             dbAlert($.i18n('form.formmasterdatalist.deletecantedit'));
             $("#mytable").ajaxgridLoad(gridPramsObj);
             return;
         }

         //不是自己新建的督办不可修改---Start
    	 if( _formType ==="2"&& !(data.field0095 == $.ctx.CurrentUser.name || (data.field0095 == "" && data.start_member_id == $.ctx.CurrentUser.id))){
             dbAlert($.i18n('form.formmasterdatalist.noeditauth'));
             return;
         }
    	 //不是自己新建的督办不可修改---end

         //查看是否销账
         if(data.field0024 == "已销账"){
        	 dbAlert("已销帐，不可修改");
             return;
         }


         //校验数据是否锁定
         var form = new formManager();
         form.checkLock(_formId, id, {
             success: function (check) {
                 if (check) {
                     dbAlert($.i18n('form.formmasterdatalist.lockeddatacantedit'));
                     return;
                 } else {
                	 var url =_ctxPath+"/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId="+id+"&isNew=false&viewId=0&formTemplateId=0&formId=0&moduleType=37&isSupervise=true&supType=" + supType;
                	 openCtpWindow({"url":url});
                 }
             }
         });


   //  }
 }

 //查询
 var queryOrReportDialog;
 function doQuery(id){
     var url = _ctxPath + "/form/queryResult.do?method=queryExc&hidelocation=false&type=query&openfrom=datalist&queryId="+id;
     queryOrReportDialog = $.dialog({
         url: url,
         title : $.i18n('form.query.querybutton'),
         width:$(top.document.body).width() - 60,
         height:$(top.document.body).height() - 100,
         targetWindow:getCtpTop(),
         transParams: window,
         buttons : [{
             text : $.i18n('DataDefine.Close'),
             id:"sure",
             handler : function() {
               queryOrReportDialog.close();
             }
         }]
     });
 }
 function closeDialog(){
	 queryOrReportDialog.close();
 }

 //批量刷新
 function bathRefreshFun(){
	 var ids = getSelectedIds();
	 if(ids.length == 0){
		 //请至少选择一条数据
		 dbAlert($.i18n('form.data.more.select.one.label'));
		 return;
	 }
	 //您确定需要对这些数据重新做计算、系统/数据关联、数据校验和满足条件的触发吗？
	 var confirm = dbConfirm({
         'msg': $.i18n('form.data.confirm.refresh.label'),
         //绑定自定义事件
         ok_fn: function () {
        	 //"表单数据刷新修改中..."
        	 getCtpTop().processBar =  getCtpTop().$.progressBar({text: $.i18n('form.data.edit.hide.fresh.label')});
             var fdManager = new formDataManager();
             fdManager.saveBatchRefresh(ids,_formId,_moduleType,_formTemplateId,{
                 success: function(result){
                     var res = $.parseJSON(result);
                     afterBatchOperation(res,'form.data.refresh.suc.label','form.data.refresh.error.label',ids.length);
             }});
         },
         cancel_fn:function(){
        	 confirm.close();
         }
	 });
 }

 //定义点击详情弹出的页面函数
 getCtpTop().window.formBatchRefreshErrorFun = function(data){
	 if(data && data.length > 0){
		 var html = "<div class='list_content relative' style='height:100%;'>";
		 var header = data[0];
		 var _width = "";
		 //处理固定表头
		 html += "<div class=' table_head relative'>";
		 html += "<table width='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed' class='only_table edit_table'>";
	     html += "<tbody><tr>";
		 for(var j = 0;j < header.length;j++){
			 var val = header[j];
			 if($.trim(val) == ""){
				 val = "&nbsp;";
			 }
			 //列宽
			 _width = getWidthForErrorList(header.length,j);
			 var _title = val.replaceAll("'", "\"").replaceAll("<br>","").replaceAll("</br>","").replaceAll("<br/>","");
			 html += "<th width='"+_width+"%' title='" + _title + "' class='text_overflow'>" + val + "</th>";
    	 }
		 html += "</tr></tbody></table></div>";
		 //处理表格数据
		 html += "<div class='table_body absolute'>";
		 html += "<table width='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed' class='only_table edit_table'>";
		 html += "<tbody>";
		 for(var i = 1;i < data.length;i++){
			 var list = data[i];
			 html += "<tr>";
			 for(var j = 0;j < list.length;j++){
				 var val = list[j];
				 if($.trim(val) == ""){
					 val = "&nbsp;";
				 }
				 //列宽
				 _width = getWidthForErrorList(list.length,j);
				 var title = val.replaceAll("'", "\"").replaceAll("<br>","").replaceAll("</br>","").replaceAll("<br/>","");
				 html += "<td width='" + _width + "%' title='" + title+ "' class='text_overflow'>" + val + "</td>";
			 }
			 html += "</tr>";
		 }
		 html += "</tbody></table></div></div>";
		 var dialog = $.dialog({
			 title: $.i18n('form.data.refresh.fail.detail.label'),//"详情"
			 html:html,
			 width:800,
			 height:450,
			 overflow:'hidden',
			 targetWindow:getCtpTop(),
			 buttons : [ {
				 text : $.i18n("form.forminputchoose.enter"),
				 id : "sure",
				 handler : function() {
					 dialog.close();
				 }
			 }]
		 });
	 }
 }

 /**
  * 计算列宽
  * @param columnSize 列的总数
  * @param index 第几列
  * @returns {___anonymous32219_32224}
  */
function getWidthForErrorList(columnSize,index){
	var _width = "";
	var _r = 100%columnSize;
	if(_r == 0){
	    _width = 100/columnSize;
	}else{
	    _width = (100 - _r)/columnSize
	    if(index == columnSize -1){
	        _width = _width + _r;
	    }
	}
	return _width;
}
function bathUpdate(){
    var ids = getSelectedIds();
    if(ids.length == 0){
        //请至少选择一条数据
        dbAlert($.i18n('form.data.more.select.one.label'));
        return;
    }
    var url = _ctxPath + "/form/formData.do?method=batchUpdateData&formId="+toFormBean.id+"&formTemplateId="+_formTemplateId;
    var dialog = $.dialog({
        url:url,
        title: $.i18n('form.bind.bath.update.label'),
        width:400,
        height:550,
        targetWindow:getCtpTop(),
        id:"bathUpdate",
        transParams: window,
        buttons : [ {
            text : $.i18n("form.forminputchoose.enter"),
            id : "sure",
            handler : function() {
                var obj = dialog.getReturnValue();
                if (obj.success){
                    var fdManager = new formDataManager();
                    dialog.close();
                    //"表单数据刷新修改中..."
                    getCtpTop().processBar =  getCtpTop().$.progressBar({text: $.i18n('form.data.edit.hide.fresh.label')});
                    var interval = window.setInterval(function(){
                        var key = fdManager.getProgress4UpdateData4BatchUpdate(toFormBean.id,$.ctx.CurrentUser.id);
                        if (key) {
                            var nums = key.split("/");
                            getCtpTop().processBar.setText("需要修改的总条数为" + nums[1]+",当前修改第" + nums[0] + "条");
                        }
                    },2000);
                    fdManager.updateData4BatchUpdate(toFormBean.id,_formTemplateId,ids,obj.updateType,obj.data,{
                        success:function(result){
                            afterBatchOperation(result,'form.bind.bath.update.suc.label','form.bind.bath.update.error.label',ids.length);
                            window.clearInterval(interval);
                        }
                    });
                }
            }
        }, {
            text : $.i18n('form.forminputchoose.cancel'),
            id : "exit",
            handler : function() {
                dialog.close();
            }
        } ]
    });
}
/**
 * 后期处理批量操作
 * result.errorSize 操作失败数据数
 * result.sucSize 操作成功数
 * result.detailData 操作失败详情
 * successi18n 操作成功提示国际化key，包含成功数参数
 * errori18n 操作失败提示国际化key，包含两个参数：总操作数，操作失败数
 */
function afterBatchOperation(result,successi18n,errori18n,total){
    if (result.errorSize == 0){
    	dbInfor($.i18n(successi18n,result.sucSize));
    } else {
    	dbInfor($.i18n(errori18n,total,result.errorSize)+"[<a href='#' onclick='formBatchRefreshErrorFun("+ $.toJSON(result.detailData) +")'>" + $.i18n('form.data.refresh.fail.detail.label') + "</a>]");
    }
    getCtpTop().processBar.close();
    refreshFormDataPage();
}

function showSupervisionListField(showFields,theadarr,width){
	if(supType == "0"){//重点工作
		showListField_0(showFields,theadarr,width);
	}else if(supType == "1"){//会议
		showListField_1(showFields,theadarr,width);
	}else if(supType == "2"){//来文文件
		showListField_2(showFields,theadarr,width);
	}else if(supType == "3"){//领导交办
		showListField_3(showFields,theadarr,width);
	}else if(supType == "20" || supType == "30" || supType == "40" || supType == "50" || supType == "60" || supType == "90" || supType == "100"){
		showListField_4(showFields,theadarr,width);
	}else if(supType == "70" || supType == "80"){
		showListField_5(showFields,theadarr,width);
	}
	return theadarr;
}

/**
 * 上级交办
 * @param showFields
 * @param theadarr
 * @param width
 * @return
 */
function showListField_0(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
//        showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
        if(showFields[i].name =='field0023'){
        	showFields[i].width = "25%";
			showFields[i].display = "目标事项";
			theadarr.push(showFields[i]);
        }
		/*if(showFields[i].name =='field0001'){
			showFields[i].width = "20%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
		//进度、
		if(showFields[i].name =='field0028'){
			//完成进度前面添加【一季度】
			var f = new Object();
			f.width = "15%";
			f.align ='left';
			f.display = "一季度";
			f.name = "feedback1";
			theadarr.push(f);

			f = new Object();
			f.width = "15%";
			f.align ='left';
			f.display = "二季度";
			f.name = "feedback2";
			theadarr.push(f);

			f = new Object();
			f.width = "15%";
			f.align ='left';
			f.display = "三季度";
			f.name = "feedback3";
			theadarr.push(f);

			f = new Object();
			f.width = "15%";
			f.align ='left';
			f.display = "四季度";
			f.name = "feedback4";
			theadarr.push(f);

			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}*/
        if(showFields[i].name =='field0004'){
        	showFields[i].width = "10%";
			showFields[i].display = "完成时限";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0001'){
			showFields[i].width = "15%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
		//事项类别、
		if(showFields[i].name =='field0022'){
			showFields[i].width = "10%";
			showFields[i].display = "事项类别";
			theadarr.push(showFields[i]);
		}
		//完成进度
		if(showFields[i].name =='field0028'){
			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)和操作（督查要求）
		if(showFields[i].name =='field0024' || showFields[i].name =='field0026'){
			if(showFields[i].name =='field0024'){
				//状态前面添加【完成情况】
				var f = new Object();
				f.name = "lastFeedBack";
				f.width = "15%";
				f.align ='left';
				f.display = "完成情况";
				theadarr.push(f);

				showFields[i].width = "15%";
				showFields[i].display = "状态";
				theadarr.push(showFields[i]);
			}
			if(rCode=='F20_SuperviseLeaderSpace' && showFields[i].name =='field0026'){//领导人有操作列
				showFields[i].width = "15%";
				showFields[i].display = "操作";
				theadarr.push(showFields[i]);
			}
		}
    }
}

/**
 * 会议议定展示列：预警、议定事项（事项名称）、责任单位、完成时间、类型、完成情况（自评）、完成进度、状态和操作
 * @param showFields
 * @param theadarr
 * @param width
 * @return
 */
function showListField_1(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
//        showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	 showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
        if(showFields[i].name =='field0023'){
        	showFields[i].width = "25%";
			showFields[i].display = "议定事项";
			theadarr.push(showFields[i]);
        }
        if(showFields[i].name =='field0004'){
        	showFields[i].width = "10%";
			showFields[i].display = "完成时限";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0001'){
			showFields[i].width = "15%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
		//事项类别、
		if(showFields[i].name =='field0022'){
			showFields[i].width = "10%";
			showFields[i].display = "事项类别";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0028'){
			//状态前面添加【完成情况】
			var f = new Object();
			f.name = "lastFeedBack";
			if(rCode=='F20_SuperviseStaffSpace'){
				f.width = "15%";
			}else{
				f.width = "15%";
			}
			f.align ='left';
			f.display = "完成情况";
			theadarr.push(f);

			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)和操作（督查要求）
		if(showFields[i].name =='field0024' || showFields[i].name =='field0026'){
			if(showFields[i].name =='field0024'){
				showFields[i].width = "15%";
				showFields[i].display = "状态";
				theadarr.push(showFields[i]);
			}
			if(rCode=='F20_SuperviseLeaderSpace' && showFields[i].name =='field0026'){//领导人有操作列
				showFields[i].width = "15%";
				showFields[i].display = "操作";
				theadarr.push(showFields[i]);
			}
		}
    }
}
/**
 * 来文办件：预警、文件标题和文号、实际完成时间、分管领导、责任单位、督办（承办）人、批示意见、完成情况
 * @param showFields
 * @param theadarr
 * @param width
 * @return
 */
function showListField_2(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
        showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	 showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0096'){
			showFields[i].width = "15%";
        	theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0023'){
			showFields[i].width = "20%";
			showFields[i].display = "文件标题";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0004'){
			showFields[i].width = "10%";
			showFields[i].display = "完成时限";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0001'){
			showFields[i].width = "15%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0095'){
			showFields[i].width = "15%";
			showFields[i].display = "督办人";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0101'){
			showFields[i].width = "15%";
			showFields[i].display = "批示意见";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0028'){
			//状态前面添加【完成情况】
			var f = new Object();
			f.name = "lastFeedBack";
			f.width = "15%";
			f.align ='left';
			f.display = "完成情况";
			theadarr.push(f);

			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)和操作（督查要求）
		if(showFields[i].name =='field0024' || showFields[i].name =='field0026'){
			if(showFields[i].name =='field0024'){
				showFields[i].width = "15%";
				showFields[i].display = "状态";
				theadarr.push(showFields[i]);
			}
			if(rCode=='F20_SuperviseLeaderSpace' && showFields[i].name =='field0026'){//领导人有操作列
				showFields[i].width = "15%";
				showFields[i].display = "操作";
				theadarr.push(showFields[i]);
			}
		}
    }
}
/**
 * 领导批示：预警、批示事项及内容、批示领导、批示时间（不加了吗？？）、完成时间、（事项）类型、责任单位、督办人、完成情况、完成进度
 * @param showFields
 * @param theadarr
 * @param width
 * @return
 */
function showListField_3(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
        showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	 showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
        if(showFields[i].name =='field0088'){
        	showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        if(showFields[i].name =='field0023'){
        	showFields[i].width = "25%";
        	showFields[i].display = "批示事项及内容";
        	theadarr.push(showFields[i]);
        }
        if(showFields[i].name =='field0004'){
        	showFields[i].width = "10%";
			showFields[i].display = "完成时限";
			theadarr.push(showFields[i]);
		}
        //事项类别、
		if(showFields[i].name =='field0022'){
			showFields[i].width = "10%";
			showFields[i].display = "事项类别";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0001'){
			showFields[i].width = "15%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0095'){
			showFields[i].width = "15%";
			showFields[i].display = "督办人";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0028'){
			//状态前面添加【完成情况】
			var f = new Object();
			f.name = "lastFeedBack";
			f.width = "15%";
			f.align ='left';
			f.display = "完成情况";
			theadarr.push(f);
			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)和操作（督察要求）
		if(showFields[i].name =='field0024' || showFields[i].name =='field0026'){
			if(showFields[i].name =='field0024'){
				showFields[i].width = "15%";
				showFields[i].display = "状态";
				theadarr.push(showFields[i]);
			}
			if(rCode=='F20_SuperviseLeaderSpace' && showFields[i].name =='field0026'){//领导人有操作列
				showFields[i].width = "15%";
				showFields[i].display = "操作";
				theadarr.push(showFields[i]);
			}
		}
    }
}
/**
 * 我分管事项列表
 * @param showFields 预警、事项名称、完成时限、事项类别、责任单位、完成进度、状态和操作
 * @param theadarr
 * @param width
 * @return
 */
function showListField_4(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
       // showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	 showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
        //事项名称
        if(showFields[i].name =='field0023'){
        	showFields[i].width = "20%";
        	theadarr.push(showFields[i]);
        }
        if(showFields[i].name =='field0004'){
        	showFields[i].width = "8%";
        	showFields[i].display = "完成时限";
        	theadarr.push(showFields[i]);
        }
        if(showFields[i].name =='field0001'){
        	showFields[i].width = "15%";
        	showFields[i].display = "责任单位";
        	theadarr.push(showFields[i]);
        }
        //事项类别、
        if(showFields[i].name =='field0022'){
        	showFields[i].width = "8%";
        	showFields[i].display = "事项类别";
        	theadarr.push(showFields[i]);
        }
        //完成进度
		if(showFields[i].name =='field0028'){
			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)和操作（督察要求）
		if(showFields[i].name =='field0024' || showFields[i].name =='field0026'){
			if(showFields[i].name =='field0024'){
				showFields[i].width = "13%";
				showFields[i].display = "状态";
				theadarr.push(showFields[i]);
			}
			if(showFields[i].name =='field0026'){
				showFields[i].width = "15%";
				showFields[i].display = "操作";
				theadarr.push(showFields[i]);
			}
		}
    }
}
/**
 * 台账列表
 * @param showFields 预警、事项名称、完成时限、事项类别、责任单位、完成进度、状态
 * @param theadarr
 * @param width
 * @return
 */
function showListField_5(showFields,theadarr,width){
	for(var i=0;i<showFields.length;i++){
        showFields[i].width = width;
        showFields[i].align ='left';
        var v = showFields[i].display;
        showFields[i].display = v.replace("D1","");
        if(showFields[i].name =='field0012'){
        	 showFields[i].width = "4%";
			showFields[i].display = " ";
			theadarr.push(showFields[i]);
		}
        //完成进度
		if(showFields[i].name =='field0028'){
			showFields[i].width = "15%";
			theadarr.push(showFields[i]);
		}
		//事项类别、
		if(showFields[i].name =='field0022'){
			showFields[i].width = "10%";
			showFields[i].display = "事项类别";
			theadarr.push(showFields[i]);
		}
		//事项名称
		if(showFields[i].name =='field0023'){
			showFields[i].width = "27%";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0004'){
			showFields[i].width = "10%";
			showFields[i].display = "完成时限";
			theadarr.push(showFields[i]);
		}
		if(showFields[i].name =='field0001'){
			showFields[i].width = "15%";
			showFields[i].display = "责任单位";
			theadarr.push(showFields[i]);
		}
        //添加状态(事项状态)
		if(showFields[i].name =='field0024'){
			showFields[i].width = "17%";
			showFields[i].display = "状态";
			theadarr.push(showFields[i]);
		}
    }
}

/**
 * 每次打开分解项重新查询
 * @param id
 * @param obj
 * @return
 */
function obtainSubList(id,obj){
	var clName = obj.className;
	if(clName.indexOf('break') > 0){
		isShowSon = false;
		//删除
		$("tr[id='formson_tr"+id+"']").remove();
		$(obj).toggleClass("break");
		return;
	}
	isShowSon = true;
	var supManager = new supervisionManager();
	var param = new Object();
	param.formmainId = id;
	var idx = $(obj).closest('tr').index();
	var tb = document.getElementById("mytable");
	var vlist;
	/*if(supType == "0"){
		vlist = supManager.getGovworkSubDataList(param);
	}else{*/
		vlist = supManager.getSubList(param);
	//}
	if(vlist != null && vlist.length > 0){
		for(var i = 0;i<vlist.length;i++){
			var supervision = vlist[i];

			getInfoBeforReady(supervision.id,false);

		     var newTr = tb.insertRow(idx+1);//添加新行，trIndex就是要添加的位置
		     newTr.setAttribute('id','formson_tr'+id);
		     newTr.setAttribute('style','background-color: #f6f6f6');
		     newTr.setAttribute("onclick","showBreak('"+supervision.id+"',event)");

		     //获取列表头进行分解事项显示。设置td的宽度与th一样
		     var tdHeader = $(".hDivBox table").find("tr").eq(0).find("th");
		     //根据上级事项列表显示字段显示子事项,将督查督办用到的所以列表用map保存
		     var tdHtml = new Object();
		     //gridrowcheckbox="68942560_grid_classtag"数字与一级的一致
		     var autoCode = $("#list input[value="+id+"]").attr("gridrowcheckbox");
		     tdHtml["id"] = '<td align="left" abbr="undefined"><div class="text_overflow" style="text-align: center;">' +
	    	 	'<input class="noClick" type="checkbox" value="'+supervision.id+'" row="'+supervision.id+'" gridrowcheckbox="'+autoCode+'" isSon="1" onclick="changeTrStyle(this)"></div></td>';//复选框列

		     var imgSrc = "<img class='showImg' src='"+_ctxPath+"/fileUpload.do?method=showRTE&fileId="+supervision.field0012+"&expand=0&type=image' height=25 />";
		     tdHtml["field0012"] = '<td align="left" abbr="field0012"><div class="text_overflow" style="width: 32px; text-align: left;">'+imgSrc+'</div></td>';//预警列
		     tdHtml["field0023"] = '<td align="left" abbr="field0023"><div title="'+supervision.field0023+'" class="text_overflow" style="padding-left:25px;text-align: left;width:'+(tdHeader.eq(2).width()-32)+'px"><b class="xl_pic_b"></b>'+getSubjectText(supervision.field0023,supervision,true)+'</div></td>';//事项名称
		     tdHtml["field0001"] = '<td align="left" abbr="field0001"><div title="'+supervision.field0001+'" class="text_overflow" style="text-align: left;">'+supervision.field0001+'</div></td>';//责任单位
		     tdHtml["feedback1"] = '<td align="left" abbr="feedback1"><div title="'+supervision.feedback1+'" class="text_overflow" style="text-align: left;">'+supervision.feedback1+'</div></td>';//第一季
		     tdHtml["feedback2"] = '<td align="left" abbr="feedback2"><div title="'+supervision.feedback2+'" class="text_overflow" style="text-align: left;">'+supervision.feedback2+'</div></td>';//第二季
		     tdHtml["feedback3"] = '<td align="left" abbr="feedback3"><div title="'+supervision.feedback3+'" class="text_overflow" style="text-align: left;">'+supervision.feedback3+'</div></td>';//第三季
		     tdHtml["feedback4"] = '<td align="left" abbr="feedback4"><div title="'+supervision.feedback4+'" class="text_overflow" style="text-align: left;">'+supervision.feedback4+'</div></td>';//第四季
		     tdHtml["field0004"] = '<td align="left" abbr="field0004"><div title="'+supervision.field0004+'" class="text_overflow" style="text-align: left;">'+supervision.field0004+'</div></td>';//完成时限
		     tdHtml["field0022"] = '<td align="left" abbr="field0022"><div title="'+supervision.field0022+'" class="text_overflow" style="text-align: left;">'+supervision.field0022+'</div></td>';//事项类别
		     tdHtml["lastFeedBack"] = '<td align="left" abbr=""><div title="" class="text_overflow" style="text-align: left;">'+lastFeedBack+'</div></td>';//完成情况
		     tdHtml["field0096"] = '<td align="left" abbr="field0096"><div title="'+supervision.field0096+'" class="text_overflow" style="text-align: left;">'+supervision.field0096+'</div></td>';//分管领导
		     tdHtml["field0095"] = '<td align="left" abbr="field0095"><div title="'+supervision.field0095+'" class="text_overflow" style="text-align: left;">'+supervision.field0095+'</div></td>';//督办人
			 tdHtml["field0101"] = '<td align="left" abbr="field0101"><div title="'+supervision.field0101+'" class="text_overflow" style="text-align: left;">'+supervision.field0101+'</div></td>';//批示内容
			 tdHtml["field0088"] = '<td align="left" abbr="field0088"><div title="'+supervision.field0088+'" class="text_overflow" style="text-align: left;">'+supervision.field0088+'</div></td>';//批示领导
			 var v = supervision.field0028 == ""?'0%':supervision.field0028;
			 tdHtml["field0028"] = '<td align="left" abbr="field0028"><div title="'+v+'" class="width:120px;text_overflow" style="text-align: left;">'+progressbarText(v,supervision)+'</div></td>';//完成进度
			 tdHtml["field0024"] = '<td align="left" abbr=""><div title="" class="text_overflow" style="text-align: left;">'+stateText(supervision)+'</div></td>';//状态
			 var optionTXT = "";
			 if(supType != '70' && supType != '80' && !(rCode=='F20_SuperviseStaffSpace' && supType >= 0&& supType < 10)){
		    	 //由我办理列表，督办人为当前人或督办人空创建人为当前人可以进行催办
		    	 var supervisor = supervision.field0095;
		    	 var flag = (supervisor && supervisor.indexOf(""+$.ctx.CurrentUser.id) >-1) || (!supervisor && supervision.field0121 == $.ctx.CurrentUser.name) ? true:false;
		    	 optionTXT='<td align="left" abbr=""><div class="text_overflow" style="text-align: left;">'+getOptionText(supervision,flag)+'</div></td>';//操作
		     }
			 tdHtml["field0026"] = optionTXT;

			 for(var j = 0;j < tdHeader.length;j++){
				 newTd1 = newTr.insertCell();
				 newTd1.innerHTML= tdHtml[tdHeader.eq(j).attr("colmode")];
			 }

		}
	}
	$(obj).toggleClass("break");
}

function changeTrStyle(obj){
	/*var t = $(obj);
	alert(t.attr("selected"));
	if(_checked){
		t.siblings().removeClass('trSelected');
		t.addClass('trSelected');
	}else{
		t.removeClass('trSelected');
	}*/
}

//列表添加默认查询（基本的）
function setGridDefaultParam(gridPramsObj){
	gridPramsObj.formId = toFormBean.id;
    gridPramsObj.formTemplateId = _formTemplateId;
    gridPramsObj.sortStr = _sortStr;
	gridPramsObj.supType = supType;

	gridPramsObj.fromFormId = _fromFormId;
    gridPramsObj.fromDataId = _fromDataId;
    gridPramsObj.fromRecordId = _fromRecordId;
    gridPramsObj.fromRelationAttr = _fromRelationAttr;
	if(supTypeId != "0"){//四种类型，按照事项分类查询
		gridPramsObj.field0100 = {'fieldName':'field0100','fieldValue':supTypeId,'operation':"="};//根据事项分类field0100进行查询：来文、领导、关注、会议
		//督办人的四大分类是在督办事项台账的基础上进行分类的
		if(rCode=='F20_SuperviseStaffSpace'){
			gridPramsObj.supMemberIds = supMemberIds;
			gridPramsObj.dbfield0001 = 'true';
		}
	}else if(supType=='20'){//由我分管事项：field0096为分管领导
		gridPramsObj.field0096 = {'fieldName':'field0096','fieldValue':$.ctx.CurrentUser.id,'operation':"like"};
	}else if(supType=='50'){//超期事项：field0095为督办承办人、field0012预警
		var warningId;
		for(var i = 0; i<warningOptions.length; i++){
			if(warningOptions[i].showvalue=='超期'){
				warningId = warningOptions[i].id;
	    	}
		}
		gridPramsObj.field0012 = {'fieldName':'field0012','fieldValue':warningId,'operation':"="};
	}else if(supType == '70'){
		//登录人所在单位所有督办人员的事项or责任单位=当前登录人所在单位/部门
		gridPramsObj.supMemberIds = supMemberIds;
		gridPramsObj.dbfield0001 = 'true';
		gridPramsObj.isPersonal = isPersonal;
	}else if(supType == '80'){//责任单位
		gridPramsObj.organizer = 'true';
	}else if(supType == '90'){//由我办理事项
		gridPramsObj.field0003 = {'fieldName':'field0134','fieldValue':$.ctx.CurrentUser.id,'operation':"like"};
	}
}


function addConditions(){
	//添加预警
	var strhtml = "<div id='selfDiv' class='xl_selfDiv' style='float:right;width：700px;display:inline;margin-top:9px;z-index: 1000;height:50px;'>";

	//添加功能按钮
	if(supType == '40'){//添加style区分有无左侧菜单
		strhtml = strhtml + "<a id='mb_new_a' onclick=\"add("+supType+")\" class='new_create' style='margin-right: 38px;'><em></em>新建</a>";
	}
	if(supType == '40' || supType == '50' || supType == '90'){
		if(supType == '50' || supType == '90'){
			strhtml = strhtml + "<a id='mb_edit_a' onclick=\"edit()\" style='margin-right: 38px;'><em class='mb_edit_em'></em><span id='mb_edit_span' class='menu_span' title='修改'>修改</span></a>";
		}else{
			strhtml = strhtml + "<a id='mb_edit_a' onclick=\"edit()\"><em class='mb_edit_em'></em><span id='mb_edit_span' class='menu_span' title='修改'>修改</span></a>";
		}
		strhtml = strhtml + "<em class='seperate'></em><a onclick=\"del()\"><em class='mb_del_em'></em><span id='mb_edit_span' class='menu_span' title='删除'>删除</span></a>";
	}
	if((rCode=='F20_SuperviseStaffSpace' || rCode=='F20_ResponsibleUnitSpace') && supType != '40'){
		if(supType == '80'){
			strhtml = strhtml + "<a onclick=\"exporttoExcel()\" style='margin-right: 38px;'>";
		}else if(supType == '50'){
			strhtml = strhtml + "<em class='seperate'></em><a onclick=\"exporttoExcel()\">";
		}else{
			strhtml = strhtml + "<a onclick=\"exporttoExcel()\" style='margin-right: 10px;'>";
		}

		strhtml = strhtml + "<em class='mb_export_em'></em><span id='mb_import_span' class='menu_span' title='导出'>导出</span></a>";
	}
	if(supType == '40'){
		strhtml = strhtml + "<em class='seperate'></em><a id=\"importAndExport\" style='width:105px'><em class='mb_import_em'></em><span id='mb_import_span' class='menu_span' title='导入/导出'>导入/导出</span><span class=\"xl_down_icon\"></span></a>";
	}
	//添加责任和协办：督查事项台账和领导的四大分类
	if(supType == '80' || supType == '100' || (rCode=='F20_SuperviseLeaderSpace' && supType >=0 && supType <10)){
		strhtml = strhtml + "<ul class='choose_menu'>";
		if(rCode=='F20_SuperviseLeaderSpace'){
			//领导需要加全部，要查全部和协助
			strhtml = strhtml + "<li id='all' class='bg_hover'><a onclick='searchList(\"\",\"false\")'>全部</a></li>"
						+ "<li id='mainAccout'><a onclick='searchList(\"organizer\",\"true\")'>责任</a></li>"
		}else{
			strhtml = strhtml + "<li id='mainAccout' class='bg_hover'><a onclick='searchList(\"organizer\",\"true\")'>责任</a></li>";
		}
		strhtml = strhtml + "<li id='assistAccout'><a onclick='searchList(\"co_organizer\",\"true\")'>协办</a></li></ul>";
	}

	if(supType != '50'){//超期实现不显示
		if(supType == 20 || supType == 30 || supType == 40){//添加style区分有无左侧菜单
			strhtml = strhtml +"<ul class='choose_menu'  style='margin-right: 38px;'><li id='warning' class='bg_hover'><a onclick='searchList(\"field0012\",\"\")'>全部</a></li>";
		}else{
			strhtml = strhtml +"<ul class='choose_menu'><li id='warning' class='bg_hover'><a onclick='searchList(\"field0012\",\"\")'>全部</a></li>";

		}
		for ( var i = 0; i < warningOptions.length; i++) {
			strhtml = strhtml +"<li id='warning_"+warningOptions[i].id+"'><a onclick='searchList(\"field0012\",\""+warningOptions[i].id+"\")'>"+warningOptions[i].showvalue+"</a></li>";
		}
	}
	strhtml = strhtml + "</ul>";



	strhtml = strhtml + "</div>";
	$("#north").prepend(strhtml);
}

function searchList(searchName,type){
	  gridPramsObj = new Object();
	  setGridDefaultParam(gridPramsObj);

	  //设置选择的样式
	  if(searchName == "field0012"){
		  if(type != ''){
			  $("#warning").removeClass("bg_hover");
		  }else{
			  $("#warning").addClass("bg_hover");
		  }
		  for ( var i = 0; i < warningOptions.length; i++) {
			if(type == warningOptions[i].id){
				$("#warning_"+warningOptions[i].id).addClass("bg_hover");
			}else{
				$("#warning_"+warningOptions[i].id).removeClass("bg_hover");
			}
		  }
	  }else if(searchName == 'co_organizer'){
			  isCo_manager = true;
			  $("#assistAccout").addClass("bg_hover");
			  $("#mainAccout").removeClass("bg_hover");
			  if($("#all")){
				  $("#all").removeClass("bg_hover");
			  }
	  }else if(searchName == 'organizer'){
			  isCo_manager = false;
			  $("#mainAccout").addClass("bg_hover");
			  $("#assistAccout").removeClass("bg_hover");
			  if($("#all")){
				  $("#all").removeClass("bg_hover");
			  }
	 }else{
		 isCo_manager = false;
		 $("#all").addClass("bg_hover");
		 $("#mainAccout").removeClass("bg_hover");
		  $("#assistAccout").removeClass("bg_hover");
	 }
	  getSelfCondition(gridPramsObj);
	  $("#mytable").ajaxgridLoad(gridPramsObj);
}

function getSelfCondition(gridPramsObj,type){
	//获取预警
	  //列表出默认查询条件外，第二个以上的条件都用more_字段名称，需要单独拼接sql
	  var warningArr = $("li[id^='warning']");
	  for ( var i = 0; i < warningArr.length; i++) {
		  var classV = warningArr[i].className;
		if(classV != ""){
			var r = warningArr[i].id.split("_");
			if(r.length == 2){
			  gridPramsObj["more_field0012"] = r[1];
			}
			break;
		}
	  }

	  //获取责任的选择
	  if(supType == '80' || !type){
		  if($("#assistAccout").attr('class') && $("#assistAccout").attr('class') != ""){//协办
			  gridPramsObj["co_organizer"] = "true";
			  gridPramsObj["organizer"] = "false"
		  }else if($("#mainAccout").attr('class') && $("#mainAccout").attr('class') != ""){//责任
			  gridPramsObj["organizer"] = "true";
			  gridPramsObj["co_organizer"] = "false";
		  }
	  }
}
/**
 * 将列表显示字段重命名为要求的名称
 * @param searchField
 * @return
 */
function changeFieldName(searchField){
	//修改查询条件显示名称
	 if(searchField.id == "field0023"){//事项名称
		 if(supType == '0'){
			 searchField.text = "目标事项";
		 }else if(supType == '1'){
			 searchField.text = "议定事项";
		 }else{
			 searchField.text = "事项名称";
		 }
	 }else if(searchField.id == "field0004"){//要求完成时间
		 searchField.text = "完成时限";
	 }else if(searchField.id == "field0022"){//"D1事项分类"
		 searchField.text = "事项类别";
	 }else if(searchField.id == "field0001"){//"D1责任单位部门"
		 searchField.text = "责任单位";
	 }else if(searchField.id == "field0093"){//"D1来件原文"
		 searchField.text = "文件标题";
	 }else if(searchField.id == "field0096"){//D1分管领导
		 searchField.text = "分管领导";
    }else if(searchField.id == "field0095"){//D1督办承办人
   	 	searchField.text = "督办人";
    }else if(searchField.id == "field0088"){//D1批示领导
   	 	searchField.text = "批示领导";
    }
}

/**
 * 关注事项处理事件
 */
function attention(obj,thisObj){
	if(!isExist(obj)){
		return false;
	}
	if($(thisObj).val()=="关注"){
		//关注
		$.ajax({
		    url : _ctxPath + '/supervision/supervisionController.do?method=saveSubTables&timestamp=' + (new Date()).getTime(),
		    //data : {"field0081":"-2812436868810060734","tableName":"attention","field0083":"2017-05-22 09:35:00","masterDataId":"4689527368612503136"},
		    data : {"tableName":"attention","masterDataId":obj},
		    type:"post",
		    success : function(data){
		    	var success=eval('('+data+')').success;
				if(success=='true'){
					dbInfor("关注成功");
					$(thisObj).val("取消关注");
					$(thisObj).css("width","66px");
					refreshFormDataPage();
				}
		    }
		});
	}else{
	//取消关注
		$.ajax({
			url : _ctxPath + '/supervision/supervisionController.do?method=delAttention&timestamp=' + (new Date()).getTime(),
			//data : {"field0081":"-2812436868810060734","tableName":"attention","field0083":"2017-05-22 09:35:00","masterDataId":"4689527368612503136"},
			data : {"tableName":"attention","masterDataId":obj,"type":"del"},
			type:"post",
			success : function(data){
		    	var success=eval('('+data+')').success;
				if(success=='true'){
					dbInfor("取消成功");
					$(thisObj).val("关注");
					$(thisObj).css("width","40px");
					refreshFormDataPage();
				}
	    	}
		});
	}
	//alert("关注处理事项");
}
/**
 * 批示处理事项
 * @return
 */
/*xl 6-29修改批示弹出框高度*/
function comments(obj){
	if(!isExist(obj)){
		return false;
	}
	//alert("批示处理事项");
	window.commentsWin = getA8Top().$.dialog({
		id:'commentsSup',
	    title:'<font class=\'dialog_title\'>批示</font>',
	    transParams:{'parentWin':window, "popWinName":"commentsWin","popCallbackFn":subCallBack},
	    url:  _ctxPath+"/supervision/supervisionController.do?method=enterSubTableEditPage&tableName=comments&masterDataId="+obj+"&subWin=commentsWin",
	    targetWindow:getA8Top(),
	    width:"520",
	    height:"260"
	});
}
/**
 * 分解处理事件
 * @return
 */
function breakSup(id,date,tempSupType){
	if(!isExist(id)){
		return false;
	}
	/*window.breakSupWin = getA8Top().$.dialog({
		id:'breakSup',
	    title:'事项分解',
	    transParams:{'parentWin':window, "popWinName":"breakSupWin",'pageRefresh':false,"popCallbackFn":window.breakCallback},
	    url:  _ctxPath+"/supervision/supervisionController.do?method=enterBreakPage&tableName=break&supType="+tempSupType+"&masterDataId="+id+"&completeDate="+date,
	    targetWindow:getA8Top(),
	    width:"650",
	    height:"420"
	});*/
	var url =_ctxPath+"/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&viewId=0&formTemplateId=0&formId=0&moduleType=37&isBreak=true&parentId="+id+"&isSupervise=true&supType="+supType;
	openCtpWindowDb({"url":url});
}
/**
 * 催办处理事件
 * @return
 */
/*xl 7-3 修改催办弹出框高度*/
function hasten(obj){
	if(!isExist(obj)){
		return false;
	}
	window.hastenSupWin = getA8Top().$.dialog({
		id:'hasten',
	    title:'<font class=\'dialog_title\'>催办</font>',
	    transParams:{'parentWin':window, "popWinName":"hastenSupWin","popCallbackFn":subCallBack},
	    url:  _ctxPath+"/supervision/supervisionController.do?method=enterHastenPage&tableName=hasten&masterDataId="+obj+"&subWin=hastenSupWin",
	    targetWindow:getA8Top(),
	    width:"500",
	    height:"220"
	});
}


/**
 * 双击显示分解事项页面
 * @return
 */
//防止连续点击
var openCount = 0;
function showBreak(id,e){
	if(id=='undefined' || id==''){
		return;
	}
	if(!isExist(id)){
		return false;
	}
	var obj=e.target||e.srcElement;
	if(obj && obj.className=="noClick"){
		return;
	}
	//点击分解事项时，checkbox选中、取消其他的
	$("#list input[type=checkbox]").each(function(){
		if($(this).val()==id && $(this).attr("isSon") == '1'){//isSon防止一级事项和展开事项是同一记录
			$(this).attr("checked","checked");
		}else{
			$(this).removeAttr("checked");
		}
	})


	openCount++;
	if(openCount>1){
		return;
	}
	setTimeout(function(){
		openCount = 0;
	},2000) ;
	//TODO 分解怎么查看
	var rCode=document.getElementById("rCode").value;
	var url=_ctxPath+"/supervision/supervisionController.do?method=formIndex&masterDataId="+id+"&isFullPage=true&moduleId="+id+"&moduleType="+_moduleType+"&contentType=20&viewState=2&rCode="+rCode+"&supType="+supType;
	openCtpWindowDb({"url":url});
}
function subCallBack(){
	setTimeout(function(){
		$(".xl_success_hidden").removeClass("xl_success");
		$(".xl_success_hidden").hide();
	},2000);
}

function isExist(id){
	var supManager = new supervisionManager();
	var data = supManager.getMasterDateById(id);
	 if(data == null){
		 dbAlert("事项已不存在！");
		 refreshFormDataPage();
        return false;
	 }
	 return true;
}

function openCtpWindowDb(D) {
    var O, T, R, M, L, J, Y, H, B;
    this.windowArgs = D;
    T = D.width || parseInt(screen.width) - 20;
    R = D.height || parseInt(screen.height) - 80;
    this.settings = {
        dialog_type: "open",
        resizable: "yes",
        scrollbars: "yes"
    };
    O = D.html;
    H = D.url;
    if (H.indexOf("seeyon") == 0) {
        H = _ctxPath + H
    }
    B = D.dialogType || this.settings.dialog_type;
    J = D.resizable || this.settings.resizable;
    Y = D.scrollbars || this.settings.scrollbars;
    var K = null;
    var W = (J == "yes") ? "no": "yes";
    var E = D.id;
    if (E == undefined) {
        E = H
    }
    //var U = getCtpTop()._windowsMap;
    var U=_windowsMap;
    if (U) {
        try {
            var Q = U.keys()
        } catch(X) {
            _windowsMap = new Properties();
            U = _windowsMap;
        }
        for (var S = 0; S < U.keys().size(); S++) {
            var P = U.keys().get(S);
            try {
                var C = U.get(P);
                var N = C.document;
                if (N) {
                    var Z = parseInt(N.body.clientHeight);
                    if (Z == 0) {
                        if ($.browser.msie) {
                            N.write("")
                        }
                        C.close();
                        C = null;
                        U.remove(P);
                        S--
                    }
                } else {
                    C = null;
                    U.remove(P);
                    S--
                }
            } catch(X) {
                C = null;
                U.remove(P);
                S--
            }
        }
        if (U.size() == 10) {
            alert($.i18n("window.max.length.js"));
            return
        }
        var V = U.get(E);
        if (V) {
            try {
                var G = V.location.href;
                var I = "";
                var A = G.indexOf("/seeyon/");
                if (A != -1) {
                    I = G.substring(A)
                }
                if (I == H) {
                    var N = V.document;
                    alert($.i18n("window.already.exit.js"));
                    V.focus();
                    return
                }
            } catch(X) {
                V = null;
                U.remove(E)
            }
        }
    }
    R -= 25;
    var F = window.open(H, "ctpPopup" + new Date().getTime(), "top=0,left=0,scrollbars=yes,dialog=yes,minimizable=yes,modal=open,width=" + T + ",height=" + R + ",resizable=yes");
    if (F == null) {
        return
    }
    F.focus();
    if (U) {
        U.putRef(E, F)
    }
    return F;
}
