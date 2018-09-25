/**
 * 所有的知识打开都使用此方法
 * @param docId 知识Id
 * @param entrance 入口参数 参考EntranceTypeEnum.java
 * @param baseDocId 如果入口为关联文档，则必须传此参数。此参数为关联文档所插入的知识的Id。可为空。
 * @param showBorrowApply 若没有打开权限，是否发起借阅。默认可借阅。可为空。
 * @param showDelete 若文件不存在，是否删除当前记录。默认不删除。可为空。
 * @param showOpenWindow 是否使用openwindow模式打开。默认不适用。可为空。
 * @param dialogId 弹出框口的Id值。可为空。
 * @returns
 */
function fnOpenKnowledge(docId, entrance,baseDocId,showBorrowApply,showDelete,showOpenWindow,dialogId) {
    //OA-66320,屏蔽文档借阅功能
    var ctxMenu = (getA8Top().$&&getA8Top().$.ctx) ? getA8Top().$.ctx.menu : null;
    if(typeof(showBorrowApply) === 'undefined' || showBorrowApply == null) {
        showBorrowApply = true;
        if(typeof(ctxMenu) != 'undefined' && ctxMenu!= null){
            var flag = true;
            for(var i=0;i<ctxMenu.length;i++){
                var ctxMenuItems = ctxMenu[i].items;
                for(var j=0;j<ctxMenuItems.length;j++){
                    if(ctxMenuItems[j].resourceCode === 'F04_showKnowledgeNavigation'){
                        flag = false;
                        break;
                    }
                }
            }
            if(flag){
                showBorrowApply = false;
            }
        }
    }
    
    if(v3x.baseURL === '') {
        v3x.baseURL = _ctxPath;
    }
    // openWindow的打开方式 duanyl
    var dialogType = "modal";
    // 从关联文档打开，不会显示申请借阅(先阶段，在关联文档打开也不会出现打不开的状况)
    if(entrance === 8 || entrance === '8' || typeof($) === 'undefined') {
        showBorrowApply = false;
    }
    
    if(entrance === 8 || entrance === '8'){
        //showDelete  在关联文档中表示是否是链接
        var isLink = showDelete ;
        if(baseDocId === 'true' && isLink==='false' ){
            fnAlert(fnI18n('doc.prompt.noright'));
            return ;
        }
        baseDocId = null;
    }
    // 修改在文档中心发送之后打开没有权限的问题，新增一个方法 getValidInfo2
    //var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager", "getValidInfo", false);
    var requestCaller = new XMLHttpRequestCaller(this, "docHierarchyManager", "getValidInfo2", false);
    requestCaller.addParameter(1, "Long", docId);
    if(typeof(entrance) === 'undefined' || entrance === null) {
        entrance = 6;
    }
    requestCaller.addParameter(2,"Integer",entrance);
    if(typeof(baseDocId) === 'undefined' || baseDocId === null) {
        baseDocId = null;
    }
    requestCaller.addParameter(3,"Long",null);
    requestCaller.addParameter(4,"Long",baseDocId);
    ret = requestCaller.serviceRequest();
    var isExist = ret.charAt(0);
    // 现在为了统一，在任何位置都不提示删除
    showDelete = false;
    if(isExist === '4') {
        fnAlert(fnI18n('doc.prompt.docLib.disabled'));
        return;
    } else if(isExist !== '0') {
        if(showDelete && typeof(delF) !== 'undefined') {
            fnConfirm(fnI18n('doc.prompt.inexistence.delete'),function (){
                delF(docId, "self", false);
            });
            return;
        } else {
            fnAlert(fnI18n('doc.prompt.inexistence'));
            return;
        } 
    }
    // 0:代表有权限，1：代表没有打开权限，2代表没有资源，3代表仅仅有学习区的权限,4代表密级程度不够
    var hasOP = ret.charAt(1);
    if(hasOP === 4 || hasOP === '4'){
        fnAlert(fnI18n('doc.prompt.lowsecretlevel'));
        return;
    }
    if((hasOP === 1 || hasOP ==='1') && (entrance == '11'||entrance == 11)){
        fnConfirm(fnI18n('doc.prompt.noright.sendlearningcancel.borrow'),function (){
            fnAddDocBorrowApply(docId,null);
        });
        return;
    }
    
    if(hasOP === '2'||hasOP === 2) {
        fnAlert(fnI18n('doc.prompt.noright'));
        return;
    }
    
    if(hasOP !== '0' && hasOP!=='3') {
        if(showBorrowApply && typeof(fnAddDocBorrowApply) !== 'undefined') {
            fnConfirm(fnI18n('doc.prompt.noright.borrow'),function (){
                fnAddDocBorrowApply(docId,null);
            });
            return;
        } else {
            fnAlert(fnI18n('doc.prompt.noright'));
            return;
        }
    }
    
    //文档库打开
    if((entrance === 5 || entrance === '5') && (hasOP == '3'||hasOP === 3)){//文档中心打开，仅仅学习区有权限
        fnAlert(fnI18n('doc.prompt.noright'));
        return;
    }
    
    // 如果是公共信息(包括公文)，都用OpenWindow模式打开 duanyl
    var isPublicInfo = ret.charAt(2);
    if(isPublicInfo === '0') {
        showOpenWindow = true;
        dialogType = "open";
    }
    var url ;
    if(typeof(_ctxPath) !== 'undefined'){
        url = _ctxPath+ret.substring(3);
    }else{
        url = v3x.baseURL+ret.substring(3);
    }
    
    if((entrance === 6 || entrance === '6' )&& typeof(ownerId) !== 'undefined'){
        url = url + "&ownerId=" + ownerId ;
    }
    
    if (getA8Top().location.href.indexOf('a8genius.do') > -1) {
      showOpenWindow = true;
    }
    
    if(showOpenWindow && getA8Top().$ && getA8Top().$.dialog) {
        getA8Top().OpenWindows = getA8Top().$.dialog({
            title:fnI18n('doc.knowledge.browse'),
            transParams:{'parentWin':window},
            url: url,
            top:20,
            width:screen.width - 100,
            height:screen.height - 200,
            isDrag:false
        });
    } else {
        if(dialogId === null || typeof(dialogId) === 'undefined') {
            dialogId = 'docOpenDialogOnlyId';
        }
        fnSelectOpenMode(dialogId,url,fnI18n('doc.knowledge.browse'));
    }      
}

/**
 * 获取用户剩余空间大小单位B
 * @param type 0文档中心，1.邮件，2博客
 * @param userId
 */
function getLeftSpaceByType(type,userId) {
    try {
        var reqCaller = new XMLHttpRequestCaller(this, "docSpaceManager", "getLeftSpaceByType", false);
        reqCaller.addParameter(1, "int", type);
        reqCaller.addParameter(2, "long", userId);
        var spaceSize = reqCaller.serviceRequest();
        return  spaceSize;
    }catch (ex1) {
        return -1;
    }
}

/**
 * 国际化方法
 * @param key 国际化key值
 * @returns
 */
function fnI18n(key) {
    var reg = new RegExp('\\.','g');
    oldKey = key.replace(reg,'_');
    oldKey = "DocLang." + oldKey;
    if(typeof($) !== 'undefined'){
        if($.i18n) {
            return $.i18n(key);
        } else {
            return v3x.getMessage(oldKey);
        }
    } else {
        return v3x.getMessage(oldKey);
    }
}




function fnAlert(word) {
    if(typeof($) !== 'undefined'){
        if($.alert) {
            $.alert(word);
        } else {
            alert(word);
        }
    } else {
        alert(word);
    }
}
function fnConfirm(word,fnOk) {
    if(typeof($) !== 'undefined'){
        if($.confirm) {
            $.confirm({'type': 1,
                'msg': word, 
                 ok_fn: function () { 
                    return fnOk();
                 }}
            );
        } else {
            if(confirm(word)) {
                return fnOk();
            } else {
                return;
            }
        }
    } else {
        if(confirm(word)) {
            return fnOk();
        } else {
            return;
        }
    }
}

/**
 * 是否存在有文档权限的用户
 * @param docResourceId
 * @returns
 */
//function hasPotentUsers(docResourceId) {
//  var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "getPotentModelUsers", false);
//    requestCaller.addParameter(1, "long", docResourceId);
//    requestCaller.addParameter(2,"boolean",false);
//    var strInclude = requestCaller.serviceRequest();
//  if(strInclude != null) {
//      return true;
//  }
//  return false;
//}

/**
 * 申请借阅
 * @param docResourceId 文档id
 * @param borrowUserId 借阅人
 * @param createUserId 文档创建人
 */
function fnAddDocBorrowApply(docResourceId,borrowUserId,createUserId) {
    //检测所有人是否有效
    var requestCaller2 = new XMLHttpRequestCaller(this, "knowledgePageManager", "getPotentModelUsers", false);
    requestCaller2.addParameter(1, "long", docResourceId);
    requestCaller2.addParameter(2, "boolean", false);
    var data2 = requestCaller2.serviceRequest();
    //返回字符串，非json对象
    if(data2 == null || data2.length <= 2){
        $.alert($.i18n("doc.member.delete.alert.js"));
        return ;
    }
    
    var dialog = $.dialog({
        id: 'html',
        url: _ctxPath+"/doc/knowledgeController.do?method=applyBorrow&docId="+docResourceId,
        title: $.i18n('doc.jsp.knowledge.borrow.apply'),
        width : 352,
        height : 120,
        overflow : 'hidden',
        buttons: [ 
           {
                text: $.i18n('common.button.ok.label'),
                isEmphasize:true,
                handler: function () {
                    var data = $.parseJSON(dialog.getReturnValue());
                    if(data==false)
                        return ;
//                    var loginAccount = $.ctx.CurrentUser.loginAccount;
                    var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "applyDocBorrow", false);
                    requestCaller.addParameter(1, "Long", borrowUserId);
                    requestCaller.addParameter(2, "Long", docResourceId);
                    requestCaller.addParameter(3, "String", data.spc1);
                    requestCaller.addParameter(4, "String", data.borrowMsg);
                    var data = requestCaller.serviceRequest();
                    if(data === null) {
                        $.alert($.i18n('doc.jsp.knowledge.borrow.apply.failed'));
                    } else {
                        $.infor($.i18n('doc.jsp.knowledge.borrow.apply.success'));
                    }
                    dialog.close();
                } 
             } , {
                text: $.i18n('common.button.cancel.label'),
                handler: function () {
                    dialog.close();
                }
           }]
     });
}
/**
 * 弹出框口的选择，如果引入了common.jsp则可使用$.dialog生成，否则MxtWindow
 * @param id 弹出框口的id
 * @param url 
 * @param isDrag 是否能拖动
 * @param targetWindow 弹出位置
 * @param title 框口标题
 * @returns
 */
function fnSelectOpenMode(id,url,title,isDrag,targetWindow) {
    fnSelectOpenModes(id,url,title,isDrag,targetWindow,0,0)
    
}

function fnSelectOpenModes(id,url,title,isDrag,targetWindow,widths,heights) {
    if(isDrag === null || typeof(isDrag) === 'undefined') {
        isDrag = false;
    }
    //由于应用要求变更频繁,现在targetWindow参数已经失去意义,直接默认为getA8Top,现在需要考虑兼容性问题
    if (widths == 0 ||  heights == 0) {
        targetWindow = getA8Top();
        var topWindow = targetWindow.document.documentElement;
        var docWinWidth = topWindow.clientWidth - 20,docWinHeight = topWindow.clientHeight - 20;
        
        if(docWinWidth<=0||docWinHeight<=0){
            docWinWidth = document.body.clientWidth-20, docWinHeight = document.body.clientHeight-20;
        }
        widths = docWinWidth;
        heights = docWinHeight;
    }
    
    var windowParam = {
            id : id,
            url : url,
            width: widths,
            height: heights,
            isDrag : isDrag,
            targetWindow :targetWindow,
            title : title,
            model : false,
            closeParam: {handler : fnIsRefresh}
    };
    
    if(typeof($) !== 'undefined' && $.dialog) {
        windowParam.top = 10;
        //新控件高度没有计算标题,减去dialog标题行高度
        windowParam.height -= 30;
        windowParam.checkMax = false;
        windowParam.closeParam.show = true;
        dialog = $.dialog(windowParam);
    } else {
        dialog =  new MxtWindow(windowParam);
    }
    
    targetWindow._dialog = dialog;
    return dialog;
}

/**
 * 提供连接的打开方法
 * @param _url
 * @param forDataList 快发版 为了不引起其他bug，针对综合查询的公共信息修正的方法
 * @param appNum  综合查询的类型，与forDataList绑定使用
 */
function openKnowledgeByURL(_url,appNum,forDataList) {
    openKnowledgeByURLByIsearch(_url, appNum, forDataList, false);
}

/**
 * 提供连接的打开方法
 * @param _url
 * @param forDataList 快发版 为了不引起其他bug，针对综合查询的公共信息修正的方法
 * @param appNum  综合查询的类型，与forDataList绑定使用
 * @param isPigeonholedFlag  是否归档
 */
function openKnowledgeByURLByIsearch(_url,appNum,forDataList,isPigeonholedFlag) {
    var openFrom = fnGetParam(_url,'openFrom');
    var dialogId = 'docOpenDialogOnlyId';
    var entrance = null;
    var baseObjectId = fnGetParam(_url,'baseObjectId');
    if(openFrom === 'glwd' || baseObjectId != null || openFrom === 'glwd' ) {
        entrance = 8;
        dialogId = 'openFromGlwd';  
    }
    if(openFrom === 'docLearning' || baseObjectId != null){
        entrance = 11;
    }
    var docResId = fnGetParam(_url,'docResId');
    if(docResId !== null) {
        var isBorrowOrShare = fnGetParam(_url,'isBorrowOrShare');
        if(isBorrowOrShare||isBorrowOrShare=='true'){
            entrance = 2;
        }
        fnOpenKnowledge(docResId, entrance,baseObjectId,null,null,null,dialogId);
    } else {
        if(forDataList === 'dataList' && appNum !== '1' && appNum !== '6') {
                openDataDetail(_url,appNum);        
        } else {
            var heights = 0;
            var widths = 0;
            var title =fnI18n('doc.knowledge.browse');
            if (isPigeonholedFlag) {
                if (appNum == '1') {
                    //协同
                    title = fnI18n('doc_isearch_openTitle1');
                } else if (appNum == '5') {
                    //计划
                    title = fnI18n('doc_isearch_openTitle5');
                } else if (appNum == '6') {
                    //会议
                    title = fnI18n('doc_isearch_openTitle6');
                } else if (appNum == '7') {
                    //公告
                    title = fnI18n('doc_isearch_openTitle7');
                } else if (appNum == '8') {
                    //新闻
                    title = fnI18n('doc_isearch_openTitle8');
                } else if (appNum == '9') {
                    //讨论
                    title = fnI18n('doc_isearch_openTitle9');
                } else if (appNum == '10') {
                    //调查
                    title = fnI18n('doc_isearch_openTitle10');
                } else if  (appNum == '11') {
                    //日程事件
                    title = fnI18n('doc_isearch_openTitle11');
                    heights = 550;
                    widths = 700;
                } else {
                    title = fnI18n('doc.knowledge.browse');
                }
            }
            var targerWindow = getA8Top();
            fnSelectOpenModes(dialogId,_url,title,null,targerWindow,widths,heights);
        }               
    }
}
/**
 * 从一个连接中获取所需参数
 * @param _url 连接的字符串
 * @param param 所需的参数
 * @returns
 */
function fnGetParam(_url,param) {
    var _paramLength = param.length;
    var _startOrg = _url.lastIndexOf(param);
    if(_startOrg === -1) {
        return null;
    }
    var _start = _url.lastIndexOf(param)+_paramLength+1;
    var length = 0;
    while(_url.charAt(_start+length) != '&' && (_start+length)<=_url.length) {
        length++;
    }
    return _url.substring(_start,_start+length);
}
/**
 *  首页中引用的打开方法
 * @param docResourceId
 * @param currentUserId
 * @param createUserId
 * @param entranceType
 * @returns
 */
function openFileWithPermission(docResourceId,currentUserId,createUserId,entranceType) {
    fnOpenKnowledge(docResourceId,entranceType);
}
/**
 * 关闭推荐的对话框
 * @returns
 */
function fnCloseRecommendDialog() {
    var _dialog = null;
    if(!getA8Top().frames['main']){
        _dialog = getA8Top()._dialog;
        getA8Top()._dialog = null;
    }else{
        _dialog = getA8Top().frames['main']._dialog;
        getA8Top().frames['main']._dialog = null;
    }
    //刷新知识查看
  if(getA8Top().docOpenDialogOnlyId_main_iframe && getA8Top().docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse){
        getA8Top().docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse();
  }
  _dialog.close();
}

function fnIsRefresh() {
    fnRefresh();
}

function fnRefresh(openFrom) {
    if(getA8Top().frames['main']) {
        if(getA8Top().frames['main'].frames&&getA8Top().frames['main'].frames['rightFrame']) {
            // 刷新文档中心
            try{
                if(getA8Top().frames['main'].frames['rightFrame'].document.getElementById("dataIFrame").style.display === "none") {
                    getA8Top().frames['main'].frames['rightFrame'].location.reload();
                } else {
                    getA8Top().frames['main'].frames['rightFrame'].frames['dataIFrame'].location.reload();
                }
            }catch(e){
                fnCloseDialog();
            }
        } else {
        if(getA8Top().frames['main'].fnReload){// 刷新个人知识中心
            getA8Top().frames['main'].fnReload();
        }else if(getA8Top().frames['main'].fnPageDataLoad){// 刷新知识广场
            getA8Top().frames['main'].fnPageDataLoad(true);
        }else if(getA8Top().frames['main'].frames['body'] && getA8Top().frames['main'].frames['body'].refreshTaskPortlet){// 刷新项目文档
            getA8Top().frames['main'].frames['body'].refreshTaskPortlet('projectDocSetion');
        }else if(getA8Top().frames['main'].frames['body'] && getA8Top().frames['main'].frames['body'].fnRefreshDocMoreProjectInfo){ // 刷新项目文档更多页面
            getA8Top().frames['main'].frames['body'].fnRefreshDocMoreProjectInfo();
        }else if(getA8Top().frames['main'].fnRefreshDocLearningMore){    // 刷新学习区
            try{
                fnCloseDialog();
                getA8Top().frames['main'].fnRefreshDocLearningMore();
            }catch(e){}
        }else{
            //仅仅是文档编辑界面的时候，才刷新
            if(getA8Top().frames['main'].location.href&&getA8Top().frames['main'].location.href.indexOf("psml")!=-1 && openFrom=="docEdit")
            getA8Top().frames['main'].location.reload(true);
        }
        }
    }
    // 防护
    fnCloseDialog();
}

function fnCloseDialog() {
    var _dialog = getA8Top()._dialog;
    getA8Top()._dialog = null;
    if(_dialog) {
        _dialog.close(); 
    }       
}