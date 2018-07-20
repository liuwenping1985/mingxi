var rssURL = "${path}/rss/rssController.do";
var oRssProgress = null;// 进度条
var fnProgressTimer = null;// 定时器函数
var rssAjaxManager = null;
var iCurrtProgres = 0;

var _isMousedown=false;
var _nMouseX=0;
var _nCurtTime=0;
var _nMousemoveDistance=0;
var _curtPage=1;

var fnTimeout = null;
var layoutShow = true;
var _isManageMySubscription=false;

var _showOrHideTime=500;

var isShow = false;

var toolBar=null;
var tout = null;

$().ready(function() {
    //隐藏左边
    if(getA8Top()){
        if(getA8Top().hideLeftNavigation){
            getA8Top().hideLeftNavigation();
        }
    }
    rssAjaxManager = new rssFontPageManager();
    $("#rssTree").tree({
        onClick : treeClick,
        idKey : "id",
        pIdKey : "pid",
        nameKey : "name",
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
    });
    toolBar = $("#toolbar").toolbar({
    	  isPager : false,
        toolbar : [ {
            id : "toolbar_refresh",
            name : "${ctp:i18n('common.toolbar.refresh.label')}",
            className : "ico16 refresh_16",
            click : toolbarRefresh
        }, {
            id : "toolbar_subscribeDoc",
            name : "${ctp:i18n('rss.subsmanage.label')}",
            className : "ico16 subscribe_doc_16",
            click : toolbarManageMySubscription
        }, {
            id : "toolbar_allCollapse",
            name : "${ctp:i18n('rss.all.collapse.label')}",
            className : "ico16 batch_16",
            click : allCollapse
        } , {
            id : "toolbar_allExpand",
            name : "${ctp:i18n('rss.all.expand.label')}",
            className : "ico16 filing_16",
            click : allExpand
        } ]
    });
    toolBar.hideBtn("toolbar_allCollapse");
    // 加载频道信息,翻页的操作也会调用；
    goPage(_curtPage);
    //$("#div_center_content_for_rss").mousedown(fnMousedown).mouseup(fnMouseup).mousemove(fnMousemove);
    
});



function fnMousemove(event){
 if(_isMousedown){
     _nMousemoveDistance=event.pageX-_nMouseX;
 }
}

function fnMouseup(){
    // 设置一个定时器,在某个时间内,划过一定长度才能定义为翻页
    var nCurtTime=new Date().getTime();
    if(nCurtTime-_nCurtTime<220&&Math.abs(_nMousemoveDistance)>130){
        if(_nMousemoveDistance>0){
            goPage(--_curtPage);
        }else{
            goPage(++_curtPage);
        }
    }
    _isMousedown=false;
}

function fnMousedown(event){
    if(event.which===1){// 鼠标左键按下
        _nCurtTime=new Date().getTime();
        _isMousedown=true;
        _nMouseX=event.pageX;
    }
}
// 全部展开
function allCollapse(){
    isShow = true ;
    var iNum = $("td a[id^=href_expand_]").length;
    var iOldTime=_showOrHideTime;
    _showOrHideTime=0;
    $("td a[id^=href_expand_]").each(function(index){
        if($(this).html()==="[${ctp:i18n('rss.expand.label')}]"){
            $(this).click();
        }
        if(iNum===(index+1)){
            _showOrHideTime=iOldTime;
        }
    });
    toolBar.hideBtn("toolbar_allCollapse");
    toolBar.showBtn("toolbar_allExpand");
}
// 全部折叠
function allExpand(){
    isShow = false;
    var iNum = $("td a[id^=href_expand_]").length;
    var iOldTime = _showOrHideTime;
    _showOrHideTime = 0;
    
    $("td a[id^=href_expand_]").each(function(index){
        if($(this).html()==="[${ctp:i18n('rss.collapse.label')}]"){
            $(this).click();
        }
        if(iNum===(index+1)){
            _showOrHideTime=iOldTime;
        }
    });
    toolBar.hideBtn("toolbar_allExpand");
    toolBar.showBtn("toolbar_allCollapse");
}

function fnFilter(node) {
    return true;
}
/**
 * 未订阅显示消息提示框
 */
function confirmNoSubscribe() {
    var treeObj = $("#rssTree").treeObj();
    var nodes = treeObj.getNodesByFilter(fnFilter);
    if (typeof(_no_Subscribe)!=='undefined'&&_no_Subscribe===true) {
        var title = "${ctp:i18n('rss.sure.to.sub')}";
        if(nodes.length > 1){//仅有根节点，没有订阅;
            title = "${ctp:i18n('rss.sure.to.go.sub')}";
        }
        
        var confirm = $.confirm({
            'msg': title,
            ok_fn: function () {  
                toolbarManageMySubscription();
                confirm.close(); 
            },
            cancel_fn:function(){}
        });
    }
}

function toolbarRefresh() {
    if(_isManageMySubscription){
        toolbarManageMySubscription();
    }else{
        var treeObj=$("#rssTree").treeObj();
        var node= treeObj.getNodeByParam("id", "0");
        treeClick(node, node, node);
    }
}

function toolbarTree() {
    if (layoutShow) {
        $("#westSp_layout .spiretBarHidden2").click();
        layoutShow = false;
    } else {
        $("#westSp_layout .spiretBarHidden").click();
        layoutShow = true;
    }
}

// 加载订阅页面
function toolbarManageMySubscription() {
    _isManageMySubscription=true;
    var url = rssURL + "?method=manageMySubscriptions";

    fnTimeout = setTimeout(showProgress, 1000);
    var param=new Object();
    AjaxDataLoader.load(url, param, function(str) {
        $("#div_center_content_for_rss").html(str);
        addEventCss4RssSubscription();
        if (oRssProgress !== null) {
            oRssProgress.setProgress(100);
            oRssProgress.close();
            clearInterval(fnProgressTimer);
        }
        clearTimeout(fnTimeout);
    });
    
    toolBar.hideBtn("toolbar_allCollapse");
    toolBar.hideBtn("toolbar_allExpand");
}

function addEventForContent() {
    // 展开折叠效果
    $("td a[id^=href_expand_]").each(function(index) {
        $(this).html("[${ctp:i18n('rss.collapse.label')}]");
        $(this).toggle(hiddenDescribse, showDescribse);
    });
    // 选择某条信息
    $("td a[id^=href_title_]").click(openByTile);
    // 读标记事件
    $("td a[id^=href_img_redflag_]").each(function(index) {
        var isReadFlag = $(this).attr("isReadFlag");
        if (isReadFlag === "false") {
            $(this).click(readedFlagTrueForHand);
        } else {
            var id = $(this).attr("sid");
            readedFlagTrue(id);
        }
    });
}
// 标记已读
function readedFlagTrue(id) {
    var shtml = "<img src=\""+_ctxPath+"/apps_res/rss/images/redflag.gif\" width='8' height='12' border='0'/>";
    $("#div_img_redflag_" + id).html(shtml);
    $("#href_img_redflag_" + id).remove();
}
function readedFlagTrueForHand() {
    var id = $(this).attr("sid");
    var channelId = $(this).attr("channelId");
    // 标记已读
    readedFlagTrue(id);
    // 修改后台状态
    updateReadFlagTrue(id, channelId);
}

function updateReadFlagTrue(itemId, channelId) {
    var params = new Object();
    params["itemId"] = itemId;
    params["channelId"] = channelId;
    rssAjaxManager.insertReadFlag(params, {
        success : function() {
        }
    });
}
// 1.点击标题，表示已经阅读过,修改后台状态,并标为红旗
function openByTile() {
    var id = $(this).attr("sid");
    var channelItemId = $(this).attr("channelItemId");
    var channelId = $(this).attr("channelId");
    var itemLink = $(this).attr("itemLink");
    // 标记已读
    readedFlagTrue(id);
    // 修改后台状态
    updateReadFlagTrue(id, channelId);
    // 隐藏标题
    hiddenOnTitle(id);
    var dialog = $.dialog({
        title : $(this).text(),
        url : itemLink,
        width : $(window).width(),
        height : $(window).height(),
        targetWindow : parent.window.top
    });
}
// 树点击事件
function treeClick(e, treeId, node) {
    _isManageMySubscription=false;
    if (node.data.isParant === false) {// 叶节点
        var url = rssURL + "?method=listRssItemsByChannelId&channelId="
                + node.data.id;
        AjaxDataLoader.load(url, null, function(str) {
            $("#div_center_content_for_rss").html(str);
            addEventForContent();
            addEventCss4RssSubscription();
        });
    } else if (node.data.id === "0") {
        var url = rssURL + "?method=listRssItems";
        AjaxDataLoader.load(url, null, function(str) {
            $("#div_center_content_for_rss").html(str);
            addEventForContent();
        });
    }
    //全部折叠
    allCollapse();
}
/**
 * 展开事件
 */
function showDescribse() {
    var id = $(this).attr("sid");
    $(this).html("[${ctp:i18n('rss.collapse.label')}]");
    $("#p_describse_" + id).show(_showOrHideTime);
}

/**
 * 折叠事件
 */
function hiddenDescribse() {
    var id = $(this).attr("sid");
    $(this).html("[${ctp:i18n('rss.expand.label')}]");
    $("#p_describse_" + id).hide(_showOrHideTime);
}

function hiddenOnTitle(sid) {
    $("#href_expand_" + sid).html("[${ctp:i18n('rss.expand.label')}]");
    $("#p_describse_" + sid).hide(_showOrHideTime);
}



function goPage(pageNo) {
    var url = rssURL + "?method=listRssItems";
    if (pageNo !== -1) {
        url += "&pageNo=" + pageNo;
    }
    AjaxDataLoader.load(url, null, function(str) {
        $("#div_center_content_for_rss").html(str);
        addEventForContent();
        confirmNoSubscribe();
        
        if(isShow){
            allExpand();
            isShow = true;
        }else{
            allCollapse();
            isShow = false;
        }
        
        if('${param.isPerson}'==='true'){
            allExpand();
    	}
    });
}

function insertSubscribe() {
    var channelId = $(this).attr("channelId");
    var sid = $(this).attr("sid");
    var categoryId = $(this).attr("categoryId");
    var name = $(this).attr("channelName");

    var params = new Object();
    params["channelId"] = channelId;
    params["addOne"] = $(this).attr("addOne");
    rssAjaxManager.updateSubscribe(params, {
        success : function(returnVal) {
        }
    });
    var flag = false;
    if (params["addOne"] === "true") {
        flag = true;
    }
    // 修改订阅标记
    modifySubscribeFlag(flag, $(this));
    // 刷新频道树
    flushRssTree(sid, categoryId, name, flag);
    //由于树刷新太快 导致页面加载出错
    tout=setTimeout("fnFlushPage()",300);
}

function fnFlushPage(){
   //停止定时器
    if(tout){
        clearTimeout(tout);
        tout = null;
    }
    // 刷新右侧界面
    if(!_isManageMySubscription){
        var treeObj=$("#rssTree").treeObj();
        var node= treeObj.getNodeByParam("id", "0");
        treeClick(node, node, node);
    }
}

function flushRssTree(id, pid, name, addFlag) {
    var treeObj = $("#rssTree").treeObj();
    var treeNode = null;

    var data = new Object();
    data["id"] = id;
    data["pid"] = pid;
    data["name"] = name;
    data["isParant"] = false;
    
    if (addFlag) {
        treeNode =treeObj.getNodeByParam("id", pid); 
        // 找不到到父节点时，重新加载父节点
        if (treeNode === null) {
            treeNode = treeObj.getNodeByParam("id", '0'); 
            var params=new Object();
            params["categoryId"]=pid;
            rssAjaxManager.getCategoryById(params, {
                   success : function(returnVal) {
                       returnVal["pid"]='0';
                       returnVal["isParant"]="true";
                       var ddedf=  treeObj.getNodeByParam("id","0"); 
                         treeObj.addNodes(ddedf, returnVal);
                       treeNode=  treeObj.getNodeByParam("id",pid); 
                       treeObj.addNodes(treeNode, data);
                   }
               });
           // toolbarRefresh();
        }else{
            treeObj.addNodes(treeNode, data);
        } 
    } else {
        treeNode = treeObj.getNodeByParam("id", id); 
        treeObj.removeNode(treeNode);
        // 如果没有子节点，则清空当前节点
        var nParentNode = treeObj.getNodeByParam("id", pid); 
        var nChildnodes = treeObj.getNodesByFilter(filter,false,nParentNode);
        if(nChildnodes.length===0){
            treeObj.removeNode(nParentNode);
        }
        // 处理跟节点为空的情况，跟节点为空时，也要现实为一个文件夹？？
    }
}

function filter(node) {
    return !node.isParant;
}


function addEventCss4RssSubscription() {
    $("table td a[id^=tab_subscribe_channelId_]").each(function(index) {
        var flag = false;
        var channelId = $(this).attr("channelId");
        for ( var i = 0; i < _myChannels.length; i++) {
            var sChannelId = "" + _myChannels[i].id;
            if (channelId === sChannelId) {
                flag = true;
                break;
            }
        }
        modifySubscribeFlag(flag, $(this));
    });
    $("table td a[id^=tab_subscribe_channelId_]").click(insertSubscribe);
}

function modifySubscribeFlag(flag, curObj) {
    if (flag) {
        curObj.html("${ctp:i18n('rss.button.unsubscribe.label')}");
        curObj.attr("addOne", "false");
    } else {
        curObj.html("${ctp:i18n('rss.button.subscribe.label')}");
        curObj.attr("addOne", "true");
    }
}

function showProgress() {
    oRssProgress = new MxtProgressBar({
        text : "${ctp:i18n('rss.items.update')}",
        progress : 5
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