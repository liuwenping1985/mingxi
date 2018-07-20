var rssURL = "${path}/rss/rssController.do";
var rssAjaxManager = null;
var rssBackTreeSetting = null;
var _show_or_hide_time=300;
var _rssBackGrid=null;
var _categroyDialog=null;
var _isShowIntroduce=false;

var oRssProgress = null;// 进度条
var fnProgressTimer = null;// 定时器函数
var fnTimeout = null;
var iCurrtProgres = 0;
var isAddEvent=false;
var _category_channel_text_names=["<${ctp:i18n('rss.input.channel.name')}>","<${ctp:i18n('rss.input.channel.url')}>","<${ctp:i18n('rss.input.channel.ordernum')}>"];
var _categoryDailog=null;
$().ready(function() {
    rssAjaxManager = new rssFontPageManager();
    rssBackTreeSetting = {
        onClick : treeClick,
        dblClickExpand:false,
        idKey : "id",
        pIdKey : "pid",
        nameKey : "name",
        view: {
            showIcon: false,
            showLine: false,
            selectedMulti: false
        },
        edit: {
            enable: true,
            showRenameBtn: false
        },
        nodeHandler : function(n) {
            if (n.data.id == 0) {
                n.open = true;
            }
            if (n.data.isParant) {
                n.isParent = true;
                n.drag = false;
                n.drop = false;
            } else {
                n.isParent = false;
            }
        },
        render : function(name, data) {
            return name;
        }
    }
    $("#rssBackTree").tree(rssBackTreeSetting);
    $("#toolbar").toolbar({
    	  isPager : false,
        toolbar : [ {
            id : "toolbar_refresh",
            name : "${ctp:i18n('common.toolbar.new.label')}",
            className : "ico16",
            subMenu : [ {
                name : "${ctp:i18n('rss.category.label')}",
                click : toolBarNewCategory
            }, {
                name : "${ctp:i18n('rss.channel.label')}",
                click : toolBarNewChannel
            } ]
        }, {
            id : "toolbar_subscribeDoc",
            name : "${ctp:i18n('application.92.label')}",
            className : "ico16 editor_16",
            click : toolbarModify
        }, {
            id : "toolbar_tree",
            name : "${ctp:i18n('application.94.label')}",
            className : "ico16 del_16",
            click : toolbarDel
        }]
    });

    _rssBackGrid=   $("#rssBackGrid").ajaxgrid({
        colModel : [ {
            display : 'id',
            name : 'id',
            width : '4%',
            align : 'center',
            sortable : false,
            type : 'checkbox'
        }, {
            display : "${ctp:i18n('col.name')}",
            name : 'name',
            sortable : true,
            sortname:"chanel.name",
            width : '56%'
        }, {
            display : "${ctp:i18n('common.category.label')}",
            name : 'pName',
            sortable : true,
            sortname:"categroy.name",
            width : '20%'
        }, {
            display : "${ctp:i18n('common.date.create.label')}",
            name : 'createDate',
            sortable : true,
            sortname:"chanel.createDate",
            width : '20%'
        } , {            
            name : 'pid',
            isToggleHideShow: false,
            sortable : false,
            sortname:"chanel.pid",
            width : '0%',
            hide : true
        }],
        click : gridClick,
        dblclick: toolbarModify,
        onSuccess:showIntroduce,
        sortorder: "desc",
        sortname: "chanel.orderNum",
        managerName : "rssFontPageManager",
        managerMethod : "getCategoryChannelByCategory",
        isHaveIframe:true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true,
            subHeight: 100,
            changeTar:'div_edit_categoryChannel'
        },
        slideToggleBtn: true
    });
    // 载入全部类别频道数据
    $("#rssBackGrid").ajaxgridLoad();
    _rssBackGrid.grid.resizeGridUpDown('middle');
    // 给频道确定和取消按钮增加事件
    addEvent4Button();
    initCategoryChannelText();
    fillCategoryId4Select();
    //设置选中第一个节点
    var rssBackTree= $("#rssBackTree").treeObj();
    var nodes = rssBackTree.getNodes();
    if (nodes.length>0) {
        rssBackTree.selectNode(nodes[0]);
        treeClick(null,null,nodes[0]);
    }
});

function fnSubmitCategory() {
    var sdata=_categoryDailog.getReturnValue();
    _categoryDailog.disabledBtn('submitBtnId');
    if(sdata!==null){
        var data=$.parseJSON(sdata.replace(/\\/g,''));
        rssAjaxManager.insertCategory(data, {
            success : function(returnVal) {
                // 移动到第一个位置
                $.infor("${ctp:i18n('rss.new.category.success')}");
                var treeObj = $("#rssBackTree").treeObj();
                var childNode = new Object();
                childNode.id = returnVal.id;
                childNode.pid = "0";
                childNode.name = returnVal.name;
                childNode.isParant = "true";
                var pNode = treeObj.getNodes()[0];// 根节点
                treeObj.addNodes(pNode, childNode);
                _categoryDailog.close();
                _categoryDailog.enabledBtn('submitBtnId');
            },
            error :function(returnVal){
                var sVal=$.parseJSON(returnVal.responseText.replace(/\\/g,''));
                _categoryDailog.close();
                $.alert(sVal.message);
            }
        });
    }else{
        _categoryDailog.enabledBtn('submitBtnId');
    }
}
function toolBarNewCategory() {
    _categoryDailog = $.dialog({
        id: 'categoryDialog',
        url:rssURL+"?method=rssLink&path=rssCategoryEdit",
        width: 400,        
        height:120,
        title:"${ctp:i18n('rss.category.new.label')}",
        targetWindow :getCtpTop(),
        buttons: [{
            id:'submitBtnId',
            text: "${ctp:i18n('guestbook.leaveword.ok')}",
            isEmphasize:true,
            handler: fnSubmitCategory
        }, {
            text: "${ctp:i18n('rss.btn.cannel')}",
            handler: function () {
                _categoryDailog.close();
            }
        }]
    });
}

function toolBarNewChannel() {
    var treeObj = $("#rssBackTree").treeObj();
    var nodes=treeObj.getNodes();
    var nodeArrays=treeObj.transformToArray(nodes);
    // 只有根节点，选择新建频道
    if(nodeArrays[0].children===undefined||nodeArrays[0].children.length===0){
        $.alert("${ctp:i18n('rss.category.no')}");
        toolBarNewCategory();
        return;
    }
    _rssBackGrid.grid.resizeGridUpDown('middle');
    //_rssBackGrid.grid.resizeGrid(_gridHeight-_editChannelHeight);
    $("#div_edit_categoryChannel").show();
    $("#div_edit_introduce").hide();
    setInputAttr4Edit("div_edit_categoryChannel", true);
    $("#div_edit_categoryChannel :input[id=isAdd]").val("true");    
    $("#div_edit_categoryChannel").show(_show_or_hide_time).clearform();
    fillCategoryId4Select();
    initCategoryChannelText();
    // 选中相应类别
    nodes = treeObj.getSelectedNodes();
    if (typeof (nodes[0]) === "undefined") {
        return;
    }
    // 设置选中
    $("#div_edit_categoryChannel :input[id=categoryId]").val(nodes[0].id);
}
  
function toolbarModify() {
    _rssBackGrid.grid.resizeGridUpDown('middle');
    var nodes = $("#rssBackTree").treeObj().getSelectedNodes();
    // grid选择的数据
    var vals = _rssBackGrid.grid.getSelectRows();
    var isGridClick = vals.length>0;
    // 选择根节点
   if(vals.length === 0&&(nodes.length===0||nodes[0].id==="0")){
        $.alert("${ctp:i18n('rss.category.alter.not.select')}");
        return;
    }
    
    if(vals.length>1){
        $.alert("${ctp:i18n('rss.channel.alter.select.one')}");
        return;
    }
    var data=null;
    $("#div_edit_categoryChannel :input[id=isAdd]").val("false");
    // 设置显示状态的编辑为
    if(isGridClick){// 修改频道
        data=vals[0];
        $("#div_edit_categoryChannel").show();
        $("#div_edit_introduce").hide();
        setInputAttr4Edit("div_edit_categoryChannel", true);
        removeCategoryChannelClass();
        $("#div_edit_categoryChannel").show(_show_or_hide_time).fillform(data);
        var node=  $("#rssBackTree").treeObj().getNodeByParam("name",data.pName);
        $("#div_edit_categoryChannel :input[id=categoryId]").val(node.id);
    }else{// 修改类别
         data=nodes[0];
         _categroyDialog = $.dialog({
             id: 'categoryDialog',
             transParams:{
                 id : data.id,
                 name : data.name
               },
             url:rssURL+"?method=rssLink&path=rssCategoryEdit",
             width: 400,
             height:120,
             title:"${ctp:i18n('rss.newcategory.label')}",
             buttons: [{
                 id:'submitBtnId',
                 text: "${ctp:i18n('guestbook.leaveword.ok')}",
                 handler: fnModifyCategory
             }, {
                 text: "${ctp:i18n('rss.btn.cannel')}",
                     handler: function () {
                         _categroyDialog.close();
                     }
                 }]
             });
    }
}

function fnModifyCategory() {
    var sdata=_categroyDialog.getReturnValue();
    _categroyDialog.disabledBtn('submitBtnId');
    if(sdata!==null){
        var data=$.parseJSON(sdata.replace(/\\/g,''));
        rssAjaxManager.updateCategory(data, {
            success : function(returnObj) {
                _categroyDialog.close();
                var treeObj = $("#rssBackTree").treeObj();
                var childNode = new Object();
                childNode.id = returnObj.id;
                childNode.pid = "0";
                childNode.name = returnObj.name;
                childNode.isParant = "true";
                var pNode = treeObj.getNodes()[0];// 根节点
                
               var updateNode= treeObj.getNodeByParam("id",returnObj.id);
               updateNode.name=returnObj.name;
               treeObj.updateNode(updateNode);
               // 修改RRS类别成功
               $.infor("${ctp:i18n('rss.modify.category.success')}");
               // 刷新频道列表
               var param1=new Object();
               param1.data=returnObj;
               treeClick(null,null,param1);
            },
            error :function(returnVal){
                var sVal=$.parseJSON(returnVal.responseText.replace(/\\/g,''));
                _categroyDialog.close();
                $.alert(sVal.message);
            }
        });
    }else{
        _categroyDialog.enabledBtn('submitBtnId');
    }
}
   
function toolbarDel() {
    var nodes = $("#rssBackTree").treeObj().getSelectedNodes();
    // grid选择的数据
    var vals = _rssBackGrid.grid.getSelectRows();
    // 选择根节点
    if((nodes.length===0||nodes[0].id==="0")&&vals.length===0){
        $.alert("${ctp:i18n('rss.category.alter.not.select')}");
        return;
    }
     // 删除类别
    if (vals.length === 0) {
        var confirm = $.confirm({
            'msg': "${ctp:i18n('rss.category.alter.delete.confirm')}",
            ok_fn: function () {
                    for ( var i = 0; i < nodes.length; i++) {
                        var data = nodes[i].data;
                        var param = new Object();
                        param.id = data.id;
                        param.name = data.name;
                        rssAjaxManager.deleteCategory(param, {
                            success : function() {
                                $("#rssBackTree").treeObj().removeNode(nodes[0]);
                                $.infor("${ctp:i18n('system.phrase.delete')}");
                            }
                        });
                    }
            }
         });
    } else {
        var confirm = $.confirm({
            'msg': "${ctp:i18n('rss.channel.alter.delete.confirm')}",
            ok_fn: function () {
                    var param = new Array();
                    for ( var int = 0; int < vals.length; int++) {
                        param[int] = vals[int].id;
                    }
                    rssAjaxManager.deleteCategoryChannel(param, {
                        success : function() {
                            $("#rssBackGrid").ajaxgridLoad();
                            $("#div_edit_categoryChannel").hide();
                            $.infor("${ctp:i18n('system.phrase.delete')}");
                            $("#div_edit_introduce").show(_show_or_hide_time);
                            
                        }
                    });
            }
        });
    }
}

function treeClick(e, treeId, node) {
    var data = node.data;
    setInputAttr4Edit("div_edit_categoryChannel", false);
    $("#div_edit_category :input[id=isAdd]").val("false");
    var categoryId = node.data.id;
    var params = new Object();
    // 排除根节点
    if (categoryId !== "0") {
        $("#div_edit_categoryChannel").hide();
        $("#div_edit_category").hide();
        params["categoryId"] = categoryId;
        _isShowIntroduce=true;
        showIntroduce();
    } else {
        $("#div_edit_categoryChannel").hide();
        _isShowIntroduce=true;
    }
    $("#rssBackGrid").ajaxgridLoad(params);
    _rssBackGrid.grid.resizeGridUpDown('down');
}

function gridClick(data, r, c) {
    //_rssBackGrid.grid.resizeGrid(_gridHeight-_editChannelHeight);
    $("#div_edit_introduce").hide();
    $("#div_edit_categoryChannel :input[id=isAdd]").val("false");
    $("#div_edit_categoryChannel").show(_show_or_hide_time).fillform(data);
    
    setInputAttr4Edit("div_edit_categoryChannel", false);
    var node=  $("#rssBackTree").treeObj().getNodeByParam("id",data.pid);
    $("#div_edit_categoryChannel :input[id=categoryId]").val(node.id);
}



function submitCategoryChannel() {
    if(!categoryChannelTextValidate()){
        return;
    }
    var data = $("#div_edit_categoryChannel").formobj();
    
    if(data.orderNum===_category_channel_text_names[2]||data.orderNum.trim()===""){
        data.orderNum=undefined;
    }
    // 进度条
    fnTimeout = setTimeout(showProgress, 1000);
    // disable 确定与取消
    $("#href_categoryChannel_submit").attr("disabled",true);
    $("#href_categoryChannel_cancel").attr("disabled",true);
    
    if (data.isAdd === "true") {// 新增
        data.isAdd = undefined;
        rssAjaxManager.insertCategoryChannel(data, {
            success : function(returnVal) {
                // 可以修改一下提交方式
                $("#rssBackGrid").ajaxgridLoad();
                if (oRssProgress !== null) {
                    oRssProgress.setProgress(100);
                    oRssProgress.close();
                    clearInterval(fnProgressTimer);
                }
                clearTimeout(fnTimeout);
                // 新增RSS【频道】成功
                $.infor("${ctp:i18n('rss.new.channel.success.label')}");
                //toolBarNewChannel();
                $("#href_categoryChannel_submit").attr("disabled",false);
                $("#href_categoryChannel_cancel").attr("disabled",false);
                _rssBackGrid.grid.resizeGridUpDown('down');
            },
            error :function(returnVal){
                if (oRssProgress !== null) {
                    oRssProgress.setProgress(100);
                    oRssProgress.close();
                    clearInterval(fnProgressTimer);
                }
                clearTimeout(fnTimeout);
                var sVal=$.parseJSON(returnVal.responseText.replace(/\\/g,''));
                $.alert(sVal.message);
                $("#href_categoryChannel_submit").attr("disabled",false);
                $("#href_categoryChannel_cancel").attr("disabled",false);
            }
        });
    } else {
        data.isAdd = undefined;
        rssAjaxManager.updateCategoryChannel(data, {
            success : function(returnVal) {
                $("#rssBackGrid").ajaxgridLoad();
                if (oRssProgress !== null) {
                    oRssProgress.setProgress(100);
                    oRssProgress.close();
                    clearInterval(fnProgressTimer);
                }
                
                clearTimeout(fnTimeout);
                // 修改RSS【频道】成功
                $.infor("${ctp:i18n('rss.modify.channel.success')}");
                $("#href_categoryChannel_submit").attr("disabled",false);
                $("#href_categoryChannel_cancel").attr("disabled",false);
                _rssBackGrid.grid.resizeGridUpDown('down');
            },
            error :function(returnVal){
                clearTimeout(fnTimeout);
                if (oRssProgress !== null) {
                    oRssProgress.setProgress(100);
                    oRssProgress.close();
                    clearInterval(fnProgressTimer);
                }
                var sVal=$.parseJSON(returnVal.responseText.replace(/\\/g,''));
                $.alert(sVal.message);
                $("#href_categoryChannel_submit").attr("disabled",false);
                $("#href_categoryChannel_cancel").attr("disabled",false);
            }
        });
    }
}

function cancelCategoryChannel() {
    var vals = _rssBackGrid.grid.getSelectRows();
    var data = vals[0];
    $("#div_edit_categoryChannel").hide();
}

function showIntroduce(args){
    if(!_isShowIntroduce) return;   
    var dataTotal = (typeof(args)==="undefined")?0: $("#rssBackGrid").formobj().length;
    // 更新数据条数
    $("#span_TotalNumber").text(dataTotal);
    // 显示内容
    $("#div_edit_introduce").show(_show_or_hide_time);
   
}

function setInputAttr4Edit(divId, flag) {
    var isdisabled = !flag;
    $("#" + divId + " :input").attr("disabled", isdisabled);
    //$("#" + divId + " a").attr("disabled", isdisabled);
}

function fillCategoryId4Select() {
    var treeObj = $("#rssBackTree").treeObj();
    var nodes = treeObj.getNodes();
    // 获取树的数据
    var data = treeObj.transformToArray(nodes);
    // 重新加载
    $("#categoryId").html("");
    for ( var int = 0; int < data.length; int++) {
        var node = data[int];
        if (node.id !== "0") {// 不为根节点
            $("<option value='" + node.id + "'>" + node.name + "</option>")
                    .appendTo($("#categoryId"));
        }
    }
}

function addEvent4Button() {
    $("#href_categoryChannel_submit").click(submitCategoryChannel);
    $("#href_categoryChannel_cancel").click(cancelCategoryChannel);
}

function initCategoryChannelText(){
    $("#div_edit_categoryChannel :text").each(function(index){
        if(index<_category_channel_text_names.length){
            $(this).val(_category_channel_text_names[index]);
            $(this).addClass("color_gray");
            if(!isAddEvent){
                $(this).focus(categoryChannelTextFocus).blur(categoryChannelTextBlur);
                //注册回车键
                $(this).keydown(function(event){
                    if (event.keyCode==13) {
                        submitCategoryChannel();
                    }
                });
            }
        }
    });
    isAddEvent=true;
}

function removeCategoryChannelClass(){
    $("#div_edit_categoryChannel :text").each(function(index){
        $(this).removeClass("color_gray");
    });
}

function getChannelIndex(_this){
    var index=0;
    if(_this.attr("id")==="url"){
        index=1;
    }else if(_this.attr("id")==="orderNum"){
        index=2;
    }
    return index;
}

function categoryChannelTextFocus(){
    if($(this).val()===_category_channel_text_names[getChannelIndex($(this))]){
        $(this).val("");
    }
    $(this).removeClass("color_gray");
}

function categoryChannelTextBlur(){
    if($(this).val().trim()===""){
        $(this).val(_category_channel_text_names[getChannelIndex($(this))]);
        $(this).addClass("color_gray");
    }  
}

function categoryChannelInitText(){
    var index=0;
    if($(this).attr("id")==="url"){
        index=1;
    }else if($(this).attr("id")==="orderNum"){
        index=2;
    }
    
    if($(this).val().trim()===""){
        $(this).val(_category_channel_text_names[index]);
    }else if($(this).val().trim()!==_category_channel_text_names[index]){
        $(this).removeClass("color_gray");
    }  
}
   
function categoryChannelTextValidate(){
    var oCategoryChannelName=$("#div_edit_categoryChannel :text[id=name]");
    var oCategoryChannelUrl=$("#div_edit_categoryChannel :text[id=url]");
    var oCategoryChannelOrderNum=$("#div_edit_categoryChannel :text[id=orderNum]");
    
    var sCategoryChannelNameVal=oCategoryChannelName.val().trim();
    var sCategoryChannelUrlVal=oCategoryChannelUrl.val().trim();
    var sCategoryChannelOrderNumVal=oCategoryChannelOrderNum.val().trim();
    
    if(sCategoryChannelNameVal===_category_channel_text_names[0]){
        oCategoryChannelName.val("");
    }
    
    if(sCategoryChannelUrlVal===_category_channel_text_names[1]){
        oCategoryChannelUrl.val("");
    }

    if(sCategoryChannelOrderNumVal===_category_channel_text_names[2]){
        oCategoryChannelOrderNum.val("");
    }
    
    var isValidate = $("#div_edit_categoryChannel").validate({
        validate : true
    });
    
    return isValidate;
} 
   
function showProgress() {
    oRssProgress = new MxtProgressBar({
        text : "${ctp:i18n('rss.items.update')}",
        progress : 2
    });
    fnProgressTimer = setInterval(growProgress, 618);
}

function growProgress() { 
    var random = parseInt(30 * Math.random());
    if (iCurrtProgres === 0) {
        iCurrtProgres = oRssProgress.progress;
    }
    
    if (iCurrtProgres + random < 100) {
        iCurrtProgres += random;
        oRssProgress.setProgress(iCurrtProgres);
    }

    if (iCurrtProgres > 98) {
        clearInterval(fnProgressTimer);
    }
}