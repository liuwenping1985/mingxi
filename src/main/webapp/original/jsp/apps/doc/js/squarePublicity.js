<%@ page contentType="text/html; charset=UTF-8" %>
var jsURL = _ctxPath+"/doc.do";
// 全局页面缓存
var knowledgeManagerAjax = new knowledgeManager();
var knowledgePageManagerAjax = new knowledgePageManager();
var cPageData = new Object();
$(document).ready(function (){
	// 配置查询控件
	var oQueryBar= getDocQueryBar();
	oQueryBar.init("searchDiv");
	oQueryBar.queryFunc=fnQueryFunc;
	
	// 页面初始加载
	// 最热，最新，评论对应的排序名称
    cPageData.fieldNames=["accessCount desc,commentCount desc,lastUpdate desc","openSquareTime desc,createTime desc","commentCount desc,accessCount desc,lastUpdate desc"];
    cPageData.fieldIndex=0;
	cPageData.pageNum=1;
	cPageData.isGetMore = false;
	cPageData.isSpanDocTotalInIt = true;
	
	if("${param.tab}"==='1'){
	    // 更改样式
	    fnChangeCSS(1);
	    // 刷新页面
	    cPageData.fieldIndex=1;
	    
	}
	fnPageDataLoad();
});

/**
 * 查询函数回调
 */
function fnQueryFunc(param){
    cPageData.condition=param.condition;
    cPageData.value=param.value;
    cPageData.pageNum=1;
    cPageData.isGetMore=false;
	fnPageDataLoad();
}

/**
 * 页面加载数据
 */
function fnPageDataLoad(isReload){
    //页面加载
    cPageData.proce = $.progressBar(); 
    var page = cPageData.pageNum;
    var condition = cPageData.condition;
    var value = cPageData.value;
    var sortField = cPageData.fieldNames[cPageData.fieldIndex];
	var sUrl = _ctxPath + "/doc/knowledgeController.do?method=toKnowledgeRanklist";
	var isGetMore = cPageData.isGetMore;
	var param={"page":page,"sortField":sortField,"sortIndex":cPageData.fieldIndex,"isReload":isReload};
	if(value!=null&& value!=""){
	    cPageData.isQuery = true;
	    param.condition=condition;
	    param.value=value;
	}
	$("#divDocContent").jsonSubmit({
        action : sUrl,
        paramObj:param,
        callback : function(oReturn) {
        	if(isGetMore && !isReload){//追加
        		 $("#divDocContent").append(oReturn);
        	}else{
        		$("#divDocContent").html(oReturn);
        	}
        	var pages=$("#divHiddenPage:last").text();
        	// 隐藏查看更多
        	var pages = parseInt(pages);
          if(pages <= cPageData.pageNum||pages===0){
              $("#divLookUpId").addClass("display_none");
          }else{
              $("#divLookUpId").removeClass("display_none")
          }
          fnInitMenu();
          // 初始化，广场总数
          if(cPageData.isSpanDocTotalInIt){
              cPageData.isSpanDocTotalInIt = false;// 仅初始化一次
              $("#spanDocTotal:last").text($("#divHiddenTotal:last").text());
              //知识容量统计刷新
              knowlegeStatistics();
          }
          
          if(cPageData.isQuery){
              var queryAlert ="${ctp:i18n('doc.knowledge.query.blank.alert')}!";
              $("#queryEmptyAlert").text(queryAlert);
          }
          
          cPageData.isQuery = false;
          cPageData.proce.close();
          //修改页面高度
          fnModifyPageHeight();
        }
    });
}

//修改页面高度
function fnModifyPageHeight(){
    var nFrameHeight=$(window).height()-38;// 顶与底的空白
    var nSelfOffsetTop=$("#divDocContent").offset().top;// 自己的偏移量
    var nHeight=nFrameHeight-nSelfOffsetTop;
    $("#divDocContent").css("height",'');
    if($("#divDocContent").height() <= nHeight+5){
      $("#divDocContent").height(nHeight+5);
    }else{
      $("#divDocContent").css("height",'');
    }
}



/**
 * 使用弹出式菜单进行操作时，进行锁（包括应用锁和并发锁）状态校验
 */
function checkDocLock(docId, isFolder) {
	var msg_status = getLockMsgAndStatus(docId);
    if(msg_status && msg_status[0] != LOCK_MSG_NONE && msg_status[1] != LockStatus_None) {
        // 如果是应用锁定或文档已被删除，需刷新列表显示
        if(msg_status[1] == LockStatus_DocInvalid || msg_status[1] == LockStatus_AppLock) {
            if(msg_status[1] == LockStatus_DocInvalid) {
                if(isFolder == 'true') {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.sourceDoc.deleted")}');
                } else {
                    $.alert('${ctp:i18n("doc.jsp.knowledge.sourceDoc.deleted")}');
                }
            } else {
                $.alert(msg_status[0]);
            }
            cPageData.pageNum=1;
            cPageData.isGetMore=false;
            fnPageDataLoad();
        } else {
            // 隐藏弹出菜单之后弹出提示信息
            $.alert(msg_status[0]);
        }
        return false;
    }
    return true;
}

/**
 * 切换最热，最新，评论
 */
function fnSwith(_this) {
	var oHref=$(_this);
    var sIndex = oHref.attr("index");
    // 更改样式
    fnChangeCSS(sIndex);
    // 刷新页面
    cPageData.fieldIndex=sIndex;
    cPageData.pageNum=1;
    cPageData.isGetMore=false;
    fnPageDataLoad();
}

/**
 * 更改超链接样式
 */
function fnChangeCSS(num) {
    var sBtnCss="page_color color_black";
    $("span[id^=spanBtn]").removeClass(sBtnCss);
    $("#spanBtn"+num).addClass(sBtnCss);
}

/**
 * 点击文章标题
 */
function fnToArticle(docId,currentUserId) {
	fnOpenKnowledge(docId);
}

/**
 * 文档推荐
 */
function fnCommend(docId, recommendEnable) {
	doc_recommend(docId, recommendEnable);	
}

/**
 * 查看更多
 */
function fnGetMore(_this) {
	cPageData.pageNum+=1;
	cPageData.isGetMore=true;
	fnPageDataLoad();
}

/**
 * 发送到常用文档
 */
function fnSendToCommonDoc(docId) {
    var param = new Object();
    param.docId = docId;
    knowledgeManagerAjax.sendToCommonDoc(param, {success:
        function(result){
            if(result) {
            	$.alert("${ctp:i18n('doc.knowledge.send.common')}");
            }
        }
    });
}

/**
 * 发送到个人学习文档
 */
function fnSendToMyStudy(docId) {
	selectPeopleFun_perLearnPop();
}

/**
 * 发送到指定位置
 */
function fnSendToSpecificLocation(docId, parentId, docLibId) {
	selectDestFolder(docId, parentId, docLibId, "1", "link");
}

/**
 * 文档移动
 */
function fnMoveDoc(docId, parentId, docLibId) {
	selectDestFolder(docId, parentId, docLibId, "1", "move");
}

/**
 * 文档删除
 */
function fnDeleteDoc(docId) {
	 var confirm = $.confirm({
	        'msg': "${ctp:i18n('doc.knowledge.mylib.delete')}",
	        ok_fn: function () {
	            if (checkDocLock(docId, false) == false) {
	                return;
	            }
	            var param = new Object();
	            param.docId = docId;
	            knowledgeManagerAjax.deleteDoc(param, {success :
	                function(result){
	                    if (result == 0) {
	                        // $.infor("${ctp:i18n('doc.knowledge.mylib.success')}");
	                    } else if (result == 1) {
	                        $.alert("${ctp:i18n('doc.knowledge.mylib.lock')}");
	                    } else {
	                        $.alert("${ctp:i18n('doc.knowledge.mylib.delete.error')}");
	                    }
	                    cPageData.pageNum=1;
	                    cPageData.isGetMore=false;
	                    fnPageDataLoad();
	                }
	            });
	        },
	        cancel_fn:function(){
	        }
	    });
}
/**
 * 文档重命名
 */
function fnRenameDoc(docId) {
    var renameUrl = _ctxPath+"/doc.do?method=reName&rowid="+ docId;
    // rename(renameUrl, "false", docId)
    var isFolder = false;
    if(checkDocLock(docId, isFolder) == false) {
        return;
    }
    
    if(v3x.getBrowserFlag('openWindow') == false){
    winRename = v3x.openDialog({
        id : "rename",
        title : "rename",
        url : renameUrl,
        width : 380,
        height : 200,
        type : 'panel',
        buttons : [{
            id:'btn1',
            text: v3x.getMessage("collaborationLang.submit"),
            handler: function(){
                var returnValues = winRename.getReturnValue();
    
            }
        }, {
            id:'btn2',
            text: v3x.getMessage("collaborationLang.cancel"),
            handler: function(){
                winRename.close();
            }
        }]
    
    });
    } else {
    var returnvalue = v3x.openWindow({
        url : renameUrl,
        width : "380",
        height : "200",
        resizable : "yes"
    });
    if(returnvalue) {
        var docResId = returnvalue[0];
        var newName = returnvalue[1];
        cPageData.pageNum=1;
        cPageData.isGetMore=false;
        fnPageDataLoad();
        if (isFolder == "true") {       
            var obj = parent.treeFrame;
            if (obj.webFXTreeHandler.getIdByBusinessId(docResId) != undefined) {            
                obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(docResId)].setText(newName);
            }
        }
    }
    }
}

/**
 * 文档借阅
 */
function fnBorrowDoc(docId) {
	var borrowUrl = _ctxPath+"/doc.do?method=docPropertyIframe&isP=false&isB=true&isM=false&isC=false&docLibType=1&isShareAndBorrowRoot=false&all=true&edit=true&add=true&readonly=true&browse=true&list=true&isFolder=false&isPersonalLib=true&propEditValue=true&allAcl=true&docResId="+docId;
    v3xOpenWindow(borrowUrl,v3x.getMessage('DocLang.doc_jsp_properties_title'));
}

/**
 * 文档属性
 */
function fnViewProperty(docId,docLibType,docLibId,frType,isPig,vForDocPropertyIframe) {
	var propertyUrl = _ctxPath+"/doc.do?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false&parentCommentEnabled=&flag=&isShareAndBorrowRoot=true&all=false&edit=false&add=false&readonly=true&browse=true&list=false&isFolder=false&isPersonalLib=true&propEditValue=false&allAcl=false&docResId="+docId+"&docLibType="+docLibType+"&docLibId="+docLibId+"&frType="+frType+"&resId="+docId
	+"&isPig="+isPig+"&v="+vForDocPropertyIframe;
    v3xOpenWindow(propertyUrl,v3x.getMessage("DocLang.doc_jsp_properties_title"));
}

/*
 * 取消公开
 */
function fnCancelPublic(docId) {
    knowledgePageManagerAjax.updateCancelPublic(docId,{success:
        function(result){
            if(result) {
             $.infor($.i18n('doc.alert.cancel.public.success'));   
            }else{
             $.infor($.i18n('doc.alert.cancel.public.failure'));   
            }
            fnPageDataLoad();
            cPageData.isSpanDocTotalInIt = true;
        }
    });       
}

/**
 * 初始化设置按钮
 */
function fnInitMenu(){
    //小块设置单机事件
    var FBM_setting_mouseOut = true;//判断
    $(".file_box_area .FBM_setting").click(function () {
        //判断超出游览器下方显示区域，调整位置
        var _bodyHeight = $(window.document).height();
        $(this).parents(".file_box_area").find(".file_box_menu_list").show();
        var _fbml_lvl1 = $(this).parents(".file_box_area").find(".file_box_menu_list .lvl1");
        if ($(this).offset().top + _fbml_lvl1.height() + $(this).height() > _bodyHeight) {
            var _top = _fbml_lvl1.height();
            _fbml_lvl1.css({ top: "-" + _top + "px" });
        } else {
            _fbml_lvl1.css({ top: "" });
        }
    }).mouseleave(function () {
        setTimeout(function () {
            if (FBM_setting_mouseOut) {
                $(".file_box_area .file_box_menu_list").hide();
            }
        }, 100);
    });
    $(".file_box_area .file_box_menu_list").mouseenter(function(){
        FBM_setting_mouseOut = false;
    }).mouseleave(function () {
        FBM_setting_mouseOut = true;
        $(this).hide();
    });
      //小块菜单控制
      $(".file_box_area .lvl1 > li[class!='line']").each(function () {
          var item = $(this).find(".lvl2");
          $(this).mouseenter(function () {
              $(this).addClass("current");
              $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
              item.show();
          }).mouseleave(function () {
              $(this).removeClass("current");
              $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
              item.hide();
          });
          $(this).find(".lvl2 li").mouseenter(function () {
              $(this).addClass("current");
          }).mouseleave(function () {
              $(this).removeClass("current");
          });
      });
}

/**
 * 人员卡片
 */
function fnPersonCard(_this) {
    var oThis = $(_this);
    var userId = oThis.attr("userId");
    $.PeopleCard({
        memberId : userId
    });
}