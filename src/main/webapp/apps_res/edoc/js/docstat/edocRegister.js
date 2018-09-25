/**
 * create by xuqiangwei
 *  公文收发文登记薄公共方法
 */


var _queryObject = [];//查询条件
var _queryType = "";//查询类型， 单个查询和组合查询
var compQueryParam = null;//组合查询结果
var _dataGrid = null;//Grid 对象
var _searchObj = null;//查询框对象
var curLastNorth = 100;//当前最大的north高度
var delta4Rec = 40;
var layout;

/**
 * 重置查询区域的布局
 */
function resetQueryCondition() {
    $('#statConditionForm input').each(function () {
        $(this).val('');
    });
    $('#statConditionForm select').each(function () {
        $(this)[0].selectedIndex = 0;
    });
}

/**
 * 初始化查询模式
 */
function initSearchMode(type) {
    $('#searchMode').on('click', function () {
        var mode = $(this).attr('mode');
        var newMode = 'advance';
        var newHi = 200;
        curLastNorth = 200;
        /* if(type=='rec'){
        newHi-=delta4Rec;
        curLastNorth-=delta4Rec;
        }*/
        var newModeName = '[' + $.i18n('govdoc.search.normalSearch') + ']';
        if ('advance' == mode) {
            newModeName = '[' + $.i18n('edoc.label.advancedSearch') + ']';
            newMode = 'normal';
            newHi = 100;
            curLastNorth = 100;
        }
        $(this).text(newModeName);
        $(this).attr('mode', newMode);
        $('#layout').layout().setNorth(newHi);
        resetQueryCondition();
        $('#statConditionForm table tr:not(:first-child)').toggleClass('hidden');
        var trNum = 6;
        if(type=='rec'){
            trNum = 5;
        }
        $('#statConditionForm table tr:nth-child(n+'+trNum+')').show();
        relayoutGrid(mode,type);
    });
}

function initQueryAndReset(type){
    // 查询统计
    $('#sendStatics').click(function(){
        var o = new Object();
        o.condition = 'compQuery';
        $('#statConditionForm input,#statConditionForm select').each(function(){
            var name = $(this).attr('name');
            if(name!=null){
                o[name]=$(this).val().trim();
                // 设置_queryObject
                if(name.indexOf('Time')==-1&&name.indexOf('Date')==-1){
                    var qObject = new Object();
                    qObject.type='';
                    qObject.condition=name;
                    qObject.value = $(this).val().trim();
                    _queryObject.push(qObject);
                }
            }

        });
        var startTimeStart = $('#startRangeTime').val().trim();
        var startTimeEnd = $('#endRangeTime').val().trim();
        if(!checkDateValid(startTimeStart,startTimeEnd)){
            return;
        }
        if(type=='rec'){
            // 来文日期
            o.recieveDate = startTimeStart+','+startTimeEnd;
        }else{
            // 拟文日期
            o.startTime = startTimeStart+','+startTimeEnd;
            // 签发日期
            var signingDateStart = $('#sendingDateStart').val().trim();
            var signingDateEnd = $('#sendingDateEnd').val().trim();
            if(!checkDateValid(signingDateStart,signingDateEnd)){
                return;
            }
            o.signingDate = signingDateStart+','+signingDateEnd;
            //分送日期
            var packStartTime = $('#packStartTime').val().trim();
            var packEndTime = $('#packEndTime').val().trim();
            if(!checkDateValid(packStartTime,packEndTime)){
                return;
            }
            o.packTimeCon = packStartTime+','+packEndTime;
            //是否签报
            o.isSignReport = isSignReport;
        }
        if(type=='rec'){
            $("#recRegisterDataTabel" ).ajaxgridLoad(o);
        }else{
            $("#sendRegisterDataTabel" ).ajaxgridLoad(o);
        }
        relayoutGrid();
    });

    // 重置
    $('#queryReset').click(function(){
        resetQueryCondition();
    });
}

/**
 * 检查日期是否合法，不合法则返回false
 * @param startTimeStart
 * @param startTimeEnd
 * @returns {boolean}
 */
function checkDateValid(startTimeStart,startTimeEnd){
    if(startTimeEnd!='' && startTimeStart!='' && startTimeStart>startTimeEnd){
        $.alert($.i18n('edoc.timevalidate'));//开始时间不能早于结束时间
        return false;
    }
    return true;
}

/**
 * 渲染
 * @param text
 * @param row
 * @param rowIndex
 * @param colIndex
 * @param col
 * @returns
 */
function render(text, row, rowIndex, colIndex, col) {
    
    if(text){
        if(col.dataType == "date" && col.name != "recTime"){//dataType是自己加的，标记数据类型
            text = text.substring(0, 10);
        }
    }
    
    if(col.name == 'subject' && (row.hasAttsFlag == true)){
        text += "<span class='ico16 affix_16'></span>";
    }
    
    return text
}

/**
 * 双击事件
 * @param row
 * @param colIndex
 * @param rowIndex
 */
function dbClickRow(row, colIndex, rowIndex){
    
}

/**
 * 显示和影藏列时修改colModel
 * @param cid
 * @param visible
 */
function _toggleCol(cid, visible){
    
    //这个事件传出的参数有问题
}

/**
 * 获取当前页面显示的列
 */
function _findShowColumn(){

    var showColumns = [];
    $("th", _dataGrid.grid.hDiv).each(function(){
        
        var hideFlag = true;
        var $this = $(this);
        if($this.is(":visible") == true){
            hideFlag = false;
        }else {
            hideFlag = true;
        }
        
        //改变columnmodel的值
        for(var i = 0; i < _dataGrid.p.colModel.length; i++){
            var model = _dataGrid.p.colModel[i];
            if($this.attr("colmode") == model["name"]){
                model["hide"] = hideFlag;
                if(!hideFlag){
                    showColumns.push(model);
                }
            }
        }
    });
    return showColumns;
}

//将显示列导出到数组中，用于导出
function _getCollModel(){
    var allColumns = [];
    for(var i = 0; i < _dataGrid.p.colModel.length; i++){
        var model = _dataGrid.p.colModel[i];
        allColumns.push(model);
    }
    return allColumns;
}

/**
 * 加载列表
 * @param params = {colModels:列数组，datatablId:数据表格ID, clickFn:单击时间事件方法, 
 * ajaxMethod:后台Ajax方法,customId:grid的个性化ID，}
 */
function _initGrid(params) {

    var colModels = params.colModels;
    var datatablId = params.datatablId;
    var clickFn = params.clickFn;
    var ajaxMethod = params.ajaxMethod;
    var customId = params.customId;
    
    var showCustomize = true;//是否加载用户个性化定义
    var _showToggleBtn = true;//选择列的按钮是否显示
    var disPlayColModels = [];
    var isSection = fromListType == "section";
    if(isSection){//栏目查看的情况不初始化工具栏
        customId = "";
        showCustomize = false;
        _showToggleBtn = false;
        
        var showColumnArray = showColumn.split(",");
        for(var i = 0; i < showColumnArray.length; i++){
            var tempColumnName = showColumnArray[i];
            for(var k = 0; k < colModels.length; k++){
                var tempModel = colModels[k];
                if(tempColumnName == tempModel["name"]){
                    tempModel["hide"] = false;
                    disPlayColModels.push(tempModel);
                }
            }
        }

        $.ctx._pageSize = dataNum4Section;
    }else{
        disPlayColModels = colModels;
        $.ctx._pageSize = 20;
    }
    _dataGrid = $("#" + datatablId).ajaxgrid({
        click : clickFn,
        dblclick : dbClickRow,//还没用
        onToggleCol:_toggleCol,
        render : render,
        isHaveIframe : false,
        colModel : disPlayColModels,
        usepager : isSection ? false : true,
        showTableToggleBtn : false,
        parentId : $('.layout_center').eq(0).attr('id'),
        vChange : false,
        vChangeParam : {
            overflow : "hidden",
            autoResize : true
        },
        managerName : "edocManager",
        managerMethod : ajaxMethod,
        slideToggleBtn : false,
        showToggleBtn : _showToggleBtn,
        resizable : false,
        customize : showCustomize,
        customId : customId,
        params:{isSignReport:"undefined" != typeof isSignReport&&isSignReport==="true"?"true":"false"}
    });
    
    
    //数据初始化加载
    var o = new Object();
    if(initCondition){//栏目查看的情况不初始化工具栏
        o.dataRight = dataRight;//查看数据的权限
        for(var key in initCondition){
            o[key] = initCondition[key];
        }
        o.isSignReport = "undefined" != typeof isSignReport&&isSignReport==="true"?"true":"false";
        $("#" + datatablId).ajaxgridLoad(o);
    }
}

/**
 * toolbar初始化
 * @param params = {toolbarId:HTML ID,listType:列表标识}
 */
function _initToolbar(params) {

    if(fromListType == "section"){//栏目查看的情况不初始化工具栏
        return;
    }
    var isSignReport = params.isSignReport;
    var toolbarId = params.toolbarId;
    var listType = params.listType;
    if(isSignReport == "true"){
    	$("#" + toolbarId).toolbar({
            isPager : false,
            toolbar : [ {
                id : "exportExcelMenu",
                name : $.i18n('common.toolbar.exportExcel.label'),// 导出Excel
                className : "ico16 export_excel_16",
                click : function() {
                    var type = toolbarId=='recRegist_toolbar'?'rec':'send';
                    var url = _ctxPath + '/edocController.do?method=registerExport2Excel&listType=' + listType+'&isSignReport='+isSignReport;
                    _doAjaxSubmitClomnAndQuery(url, function(data){
                        //回调函数...
                    },null,type);
                }
            }]
        });
    }else{
    	$("#" + toolbarId).toolbar({
            isPager : false,
            toolbar : [ {
                id : "exportExcelMenu",
                name : $.i18n('common.toolbar.exportExcel.label'),// 导出Excel
                className : "ico16 export_excel_16",
                click : function() {
                    var type = toolbarId=='recRegist_toolbar'?'rec':'send';
                    var url = _ctxPath + '/edocController.do?method=registerExport2Excel&listType=' + listType;
                    _doAjaxSubmitClomnAndQuery(url, function(data){
                        //回调函数...
                    },null,type);
                }
            }, {
                id : "pushToPortal",
                name : $.i18n('common.search.PushHome.label'),// 推送首页
                className : "ico16 sent_to_16",
                click : function() {
                    
                   var promptObj = doPrompt({
                        title : $.i18n('common.search.PushHome.label'),// 推送首页
                        callbackFn : function(value){
                            
                            if(value == ""){//提示名称为空
                                $.alert($.i18n("edoc.alert.fillPushName"));//请输入推送名称
                                return;
                            }
                            
                            if(value.length > 85){//标题最长85
                                $.alert($.i18n("edoc.alert.pushNameMaxSize", 85));//推送名称最大长度为85
                                return;
                            }
                            
                            promptObj.close();
                            
                            var url = _ctxPath + '/edocController.do?method=addEdocRegisterCondition&listType=' + listType;
                            var extendParams = {"pushConditionName":value };
                            var type = toolbarId=='recRegist_toolbar'?'rec':'send';
                            _doAjaxSubmitClomnAndQuery(url, function(data){
                                $.infor($.i18n('edoc.push.success'));//推送成功!
                            }, extendParams,type);
                        },
                        msg : $.i18n('edoc.confirm.regiester.push', registerName),//您确认推送以下内容至首页空间的发文登记薄栏目吗？
                        initValue : defalutPushName
                    });
                }
            } ]
        });
    }
}

/**
 * 获取当前的查询条件到_queryObject
 * @param type
 */
function getQueryObject(type) {
    _queryObject = [];
    _queryType = 'compQuery';
    $('#statConditionForm input,#statConditionForm select').each(function () {
        var name = $(this).attr('name');
        if (name != null) {
            if (name.indexOf('Time') == -1 && name.indexOf('Date') == -1) {
                var qObject = new Object();
                qObject.type = '';
                qObject.condition = name;
                qObject.value = $(this).val().trim();
                _queryObject.push(qObject);
            }
        }

    });
    // 补充设置_queryObject
    var qObject = new Object();
    // 拟文日期
    var startTimeStart = $('#startRangeTime').val().trim();
    var startTimeEnd = $('#endRangeTime').val().trim();
    if(type!='rec'){
        // 签发日期
        var signingDateStart = $('#sendingDateStart').val().trim();
        var signingDateEnd = $('#sendingDateEnd').val().trim();

        qObject.type = 'datemulti';
        qObject.condition = 'signingDate';
        qObject.value = [signingDateStart, signingDateEnd];
        _queryObject.push(qObject);
    }

    qObject = new Object();
    qObject.type = 'datemulti';
    if(type=='rec'){
        qObject.condition = 'recieveDate';
    }else{
        qObject.condition = 'startTime';
    }
    qObject.value = [startTimeStart, startTimeEnd];
    _queryObject.push(qObject);
}
/**
 * Ajax方式提交列和查询字段
 * @param url 提交地址
 * @param extendParam 扩展数据， 随queryDomain域提交，注意不要重名了
* @param callbackFn 回调函数
*/
function _doAjaxSubmitClomnAndQuery(url, callbackFn, extendParam,type){
   
   if(url){
       //
       getQueryObject(type);

       var $columnDomain = $("#columnDomain");
       var $queryDomain = $("#queryDomain");
       
       $columnDomain.html("");
       $queryDomain.html("");
       
       //截取枚举的正则
       var codecfgRegex = /codeId[ ]*?:[ ]*?(["'])([^ ]+?)[ ]*?\1/i;
       var showColumns = _getCollModel();
       for(var i = 0; i < showColumns.length; i++){
           
           var model = showColumns[i];
           
           //拼接列form
           $columnDomain.append('<input name="display" id="display" value="'+model["display"]+'" />');
           $columnDomain.append('<input name="name" id="name" value="'+model["name"]+'" />');
           //枚举配置ID
           var codeId = "";
           if(model["codecfg"]){
               var tempCodecfg = model["codecfg"];
               var ret = codecfgRegex.exec(tempCodecfg);
               if(ret){
                   codeId = ret[2];
               }
           }
           $columnDomain.append('<input name="codecfg" id="codecfg" value="'+codeId+'" />');
       }
       if(_queryObject){
           $queryDomain.append('<input name="condition" id="condition" value="'+_queryType+'" />');
           for(var i = 0; i < _queryObject.length; i++){
               //查询条件处理
               
               var tempCondition = _queryObject[i];
               
               var sItemType = tempCondition["type"];
               var sItemCondition = tempCondition["condition"];
               var sItemValue = tempCondition["value"];
               
               if("datemulti" == sItemType && sItemValue){//
                   sItemValue = sItemValue[0] + "," + sItemValue[1];
               }
               
               $queryDomain.append('<input name="'+sItemCondition+'" id="'+sItemCondition+'" value="'+escapeStringToHTML(sItemValue)+'" />');
           }
       }
       
       //扩展参数拼接
       if(extendParam){
           for(var key in extendParam){
               $queryDomain.append('<input name="'+key+'" id="'+key+'" value="'+escapeStringToHTML(extendParam[key])+'" />');
           }
       }

       //提交
       var domains = ["columnDomain", "queryDomain"];
       $("#dynamicForm").jsonSubmit({
           domains : domains,
           debug : false,
           action:url,
           callback: function(data) {
               
               if(typeof(callbackFn) == "function"){
                   callbackFn(data);
               }
               
               //清空数据
               $columnDomain.html("");
               $queryDomain.html("");
           }
       });
   }
}


/**
 * 初始化查询框
 * @param params={conditionsCol:查询列,datatablId:数据表格ID}
 */
function _initSearchObj(params) {
    
    if(fromListType == "section"){//栏目查看的情况不初始化搜索框
        return;
    }
    
    var topSearchSize = 2;
    if ($.browser.msie && $.browser.version == '6.0') {
        topSearchSize = 5;
    }
    
    var rightSearchSize = $("#combinedQuery").width() + 5 + 6;
    
    var conditionsCol = params.conditionsCol;
    var datatablId = params.datatablId;
    
    _searchObj = $.searchCondition({
        top : topSearchSize,
        right : rightSearchSize,
        onchange : function() {
            // TODO
        },
        searchHandler : function() {
            var sRet = _searchObj.g.getReturnValue();
            if(sRet){
                var sItemType = sRet["type"];
                var sItemCondition = sRet["condition"];
                var sItemValue = sRet["value"];
                
                if("datemulti" == sItemType && sItemValue){//
                    sItemValue = sItemValue[0] + "," + sItemValue[1];
                }
                
                _queryObject = [];
                _queryObject.push(sRet);
                
              //数据查询
              var o = new Object();
              o.condition = sItemCondition;
              _queryType = sItemCondition;
              o[sItemCondition] = sItemValue;
              $("#" + datatablId).ajaxgridLoad(o);
            }
        },
        conditions : conditionsCol
    });

    // 默认选中标题查询条件
    _searchObj.g.setCondition('subject', '');
    _queryType = 'subject';
}

/**
 * 单击事件
 * @param row
 * @param colIndex
 * @param rowIndex
 */
function showEdocDetail(row, colIndex, rowIndex){

    var affairId = row.affairId;
    var edocType = row.edocType;
    var edocId = row.id;
    var state = row.affairState;

    //OA-33399 应用检查：本单位下外部门人员封发完成的数据，发文登记簿时查询出来了，单击穿透查看，已办结的公文还有督办设置功能，自己本单位本部门已办结的公文没有督办设置功能
    //改为已办的链接
    var fromValue="Done";
    if(state=='2'){
        fromValue="sended";
    }
    var url = "from="+fromValue+"&affairId="+affairId+"&edocType="+edocType+"&edocId="+edocId+"&openEdocByForward=true&openFrom=sendRegisterResult";//从登记簿查询结果中穿透查看公文页面，不进行安全性检查，虽然是转发文的参数，为了不再增加多余的参数，就传这个了
    url = _ctxPath + "/edocController.do?method=detailIFrame&" + url;
    if(row.govdocType!=null && row.govdocType!=0){//不是老公文
        url = _ctxPath+"/collaboration/collaboration.do?method=summary&app=4&openFrom=edocStatics&summaryId="+edocId+"&affairId="+affairId;
    }
    v3x.openWindow({
        url: url,
        FullScrean: 'yes',
        dialogType: 'open',
        closePrevious : "no"
    });
}

/**
 * 弹出框, 这个方法可以的话可以升级成组件
 * @param config = {title:dialog的标题，callbackFn:点确认后回调方法，msg:input上的提示语句，initValue:初始化值}
 */
function doPrompt(config){

    var title = config.title || " ";
    var callbackFn = config.callbackFn;
    var msg = config.msg;
    var initValue = config.initValue;
    
    var promptPageParams = {
            initValue : initValue,
            msg : msg
    }
    
    var prompWin = $.dialog({
        
        url: _ctxPath + '/edocController.do?method=showPromptPage',
        width: 360,
        height: 148,
        title: title,//
        transParams : promptPageParams,
        targetWindow:getCtpTop(),
        closeParam:{
            'show':true,
            autoClose:false,
            handler:function(){
                prompWin.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            handler: function () {
                if(callbackFn){
                    var retValue = prompWin.getReturnValue();
                    callbackFn(retValue);
                }else{
                    prompWin.close();
                }
            }
         }, {
             id:"cancelButton",
             text: $.i18n("common.button.cancel.label"),
             handler: function () {
                 prompWin.close();
             }
        }]
    }); 
    
    return prompWin;
}

function _initPage(){
    layout = $('#layout').layout();
    
    if(fromListType == "section"){
        
        //栏目查看的情况不, 移除工具栏
        //var layout_t = $("#layout").layout()
        layout.setNorth(0);
        $('#northSp_layout').hide();
        $('#center').css('top','0px');
    }
}

/**
 * 重新调整grid的布局
 */
function relayoutGrid() {
    var cHi = $('#center').height();
    var tbHi = $('#sendRegist_toolbar').height();
    if(tbHi == null){
        tbHi = $('#recRegist_toolbar').height();
    }
    var hHi = $('.hDiv').height();
    var pHi = $('.pDiv').height();
    $('.flexigrid .bDiv').height(cHi - tbHi - hHi - pHi);
}
