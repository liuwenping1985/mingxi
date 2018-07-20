<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
var userValidMsg = $.i18n('doc.alert.user.inexistence');
var cPageData = new Object();
$(function() {
    cPageData._path = "${path}/";
    cPageData.ajaxPageManager = new knowledgePageManager();
    cPageData.proce = $.progressBar();  
    $('#ajaxgridbar').ajaxgridbar({
        managerName : 'knowledgePageManager',
        managerMethod : 'findPersonalBorrow',
        callback : function(fpi) {
            cPageData.pageCacheData = fpi.data;
            $("#dataTotalId").text(fpi.total);// 修改总数
            fnBuildPageContent();
            cPageData.proce.close();
        }
    }); 
    fnLoadData();
    if(getCtpTop()){
        if(getCtpTop().hideLeftNavigation){
            getCtpTop().hideLeftNavigation();
        }
    }
});

/**
 * 增加借阅内容样式，和人员卡片事件
 */
function fnAddStylePersonCardEvent() {
    $(".qingqiu").mouseenter(function() {
        $(this).find(".qingqiu_item").show();
    }).mouseleave(function() {
        $(this).find(".qingqiu_item").hide();
    });

    // 人员卡片,性能问题，屏蔽
    /*$(".personCard").each(function(index) {
        if (index < cPageData.pageCacheData.length) {
            var iIndex = $(this).attr("iIndex");
            if(parseInt(iIndex)> -1){
                iIndex = parseInt(iIndex);
            }else{
                iIndex = index;
            }
            
            var oData = cPageData.pageCacheData[iIndex];
            if(oData.borrowUserValid!=null&&oData.borrowUserValid){
                $(this).PeopleCardMini({
                    memberId : oData.borrowUserId
                });
            }else{
                $(this).attr("title",userValidMsg)
            }
        }
    });*/
}

/**
 * 构建页面数据
 */
function fnBuildPageContent() {
    var aPageData = cPageData.pageCacheData;
    // alert($.toJSON(pageData));
    var oUlContent = $("#ulContentId").html("");// 追加内容的对象
    var oTempleteDivHtml = $("#templeteDivId").html();
    var oTempleteDiv = $("#templeteDivId");// 模版对象
    var oLogicPathTemp = $("#logicalPathTemp");
    var oPerson = $("#person");// 人员对象
    var $borrowUserName=$("#borrowUserName");
    // 需要赋index属性的对象
    var aHrefIds = [ $("#hrefAgreeBorrowId"), $("#hrefRefuseBorrowId"),
            $("#hrefIgnoreBorrowId"), $("#hrefDelBorrowId"),
            $borrowUserName, $("#frName"), $("#person"),$("#borrowUserImg") ];
    // 存放需要填充数据的jquery对象
    var $aFillObj = new Object();
    var aFillNames = new Object();// 对象属性名集合
    if (aPageData.length > 0) {
        var oPage = aPageData[0];
        var aNames = fnGetObjNameArray(oPage);
        for ( var int = 0; int < aNames.length; int++) {
            var $o = $("#" + aNames[int]);
            if ($o.length != 0) {
                $aFillObj[aNames[int]] = $o;
                aFillNames[aNames[int]];
            }
        }
    }

    var sHtml = "";
    var attach ="<span class='ico16 affix_16'></span>";
    // 填充
    for ( var int = 0; int < aPageData.length; int++) {
        var oPage = aPageData[int];
        var isDelClickEvent=false;
        var clickEvent="";
        // 每个对象存放index对象在数组中的相对位置
        for ( var name in $aFillObj) {
            var sValue = oPage[name];
            var $oFill = $aFillObj[name];
            if (sValue === null) {
                sValue = "";
            }
            // 文档逻辑路径
            if (name === "logicalPathNames") {
                $oFill.html(oPage["pathString"]);
            } else if (name === "styleId") {
                // 只能追加
                var defclass = $oFill.attr("defclass");
                var fileStyle = "fileType2_" + sValue;
                $oFill.text("").removeClass().addClass(defclass).addClass(fileStyle);
            } else if (name === "avgScore") {
                var mimeType = oPage['mimeTypeId'];
                if((mimeType > 20&&mimeType < 27)||(mimeType > 100&&mimeType < 122)){
                    var style = fnGetAvgScoreStyle(sValue);
                    var defclass = $oFill.attr("defclass");
                    // 只能追加
                    $oFill.text("").attr("title", "${ctp:i18n('doc.knowledge.doc.score')}："+sValue+" ${ctp:i18n('doc.createtime.minutes')}").removeClass().addClass(
                            style).addClass(defclass);  
                }
                
            }else if(name ==="borrowUserImg"){
                if(oPage["borrowUserValid"]==null||!oPage["borrowUserValid"]){
                    isDelClickEvent=true;
                    clickEvent = $oFill.attr("onclick");
                    $oFill.attr("title", userValidMsg).addClass("common_disable").removeAttr("onclick");
                }
                $oFill.attr("src", sValue);
                $oFill.attr("id", "borrowUserImg"+ int );
                $oFill.attr("iIndex", int);
            } else {
                //处理名称太长的问题
                var shortName=sValue==null?"":sValue;
                if(shortName.length > 45){
                    shortName = shortName.substring(0,45)+"...";
                }
                $oFill.attr("title", sValue).text(shortName);
                if(name === "borrowUserName"){
                    //离职人员处理
                    if(oPage["borrowUserValid"]==null||!oPage["borrowUserValid"]){
                        //1.移除click事件  2.增加样式disabled_color  3.修改title
                        isDelClickEvent=true;
                        clickEvent = $oFill.attr("onclick");
                        $oFill.attr("title", userValidMsg).addClass("disabled_color").removeAttr("onclick");
                    }
                }
                
                if(name === 'frName' && oPage['hasAttachments']){
                    $oFill.html(shortName+attach);
                }
            }
        }
        // 给动作按钮增加属性
        for ( var i3 = 0; i3 < aHrefIds.length; i3++) {
            aHrefIds[i3].attr("orderIndex", int);
        }
        // 克隆填充好的对象
        var ohtml = oTempleteDiv.html();
        //将移除的事件，最加上去
        if(isDelClickEvent){
            $borrowUserName.attr("onclick",clickEvent);
        }
        sHtml += ohtml;
    }
    // 追加到内容区域
    oUlContent.html(sHtml);
    fnAddStylePersonCardEvent();
    $("#templeteDivId").html(oTempleteDivHtml);
}

/**
 * 将对应的数值，装换成对应的样式 3.2==3_5，向上舍入
 */
function fnGetAvgScoreStyle(value) {
    var prefix = "stars";    
    if(value == null || isNaN(value)||value > 5 || value < 0) {
        return prefix + 0;
    }
    
    var avg = parseFloat(value);
    var level = 0;
    var intPart = parseInt(avg);
    var floatPart = avg - intPart;
    
    if(floatPart < 0.25) {
        level = intPart;
    } else if(floatPart < 0.75) {
        level = intPart + 0.5;
    } else {
        level = intPart + 1;
    }
    return prefix + level.toString().replace('.','_');
}
/**
 * 返回对象名称的数组
 */
function fnGetObjNameArray(obj) {
    var aNames = [];
    var index = 0;
    for ( var name in obj) {
        aNames[index++] = name;
    }
    return aNames;
}

/**
 * 人员卡片
 */
function fnPersonCard(_this) {
    var data = fnGetThisPointData(_this);
    $.PeopleCard({
        memberId : data.borrowUserId
    });
}
/**
 * 打开文档
 */
function fnOpenDoc(_this) {
    var oData = fnGetThisPointData(_this);
    var id = oData.docId;
//    var userId = ${CurrentUser.id};
    fnOpenKnowledge(id);
}

/**
 * 转到文档中心指定的目录
 */
function fnToDocPath(_this) {
    var id = $(_this).attr("id");
    var frType = $(_this).attr("frType");
    var cUrl = cPageData._path + "doc.do?method=docHomepageIndex&docResId="
            + id;
    $.dialog({
        id : 'createfnOpenDocId',
        url : cUrl,
        title : "",
        width : $(window).width(),
        height : $(window).height()
    });
}

/**
 * 返回当前位置的数据
 */
function fnGetThisPointData(_this) {
    var index = $(_this).attr("orderIndex");
    var oData = cPageData.pageCacheData[index];
    return oData;
}

/**
 * 删除借阅
 */
function fnDelBorrow(_this) {
    var confirm = $.confirm({
        'msg' : "${ctp:i18n('doc.sure.delete.lending.request')}",
        ok_fn : function() {
            var oData = fnGetThisPointData(_this);
            // 调用后台，更新标记
            var param = new Object();
            param.brrowId = oData.brrowId;// 借阅id
            param.status = 4;
            param.onlyUpdateStatus = "true";
            param.userId = $.ctx.CurrentUser.id;
            param.docId= oData.docId;
            cPageData.ajaxPageManager.updateStatus(param, {
                success : function(returnVal) {
                    fnDelThisFreshPage();
                }
            });
        }
    });
}
/**
 * 忽略借阅
 */
function fnIgnoreBorrow(_this) {
    var confirm = $.confirm({
        'msg' : "${ctp:i18n('doc.sure.ignore.lending.request')}",
        ok_fn : function() {
            fnIgnoreBorrowOk(_this);
        }
    });
}

function fnIgnoreBorrowOk(_this){
    var oData = fnGetThisPointData(_this);
    // 调用后台，更新标记
    var param = new Object();
    param.brrowId = oData.brrowId;// 借阅id
    param.status = 3;
    param.userId = $.ctx.CurrentUser.id;
    param.docId= oData.docId;
    param.onlyUpdateStatus = "true";
    cPageData.ajaxPageManager.updateStatus(param, {
        success : function(returnVal) {
            // 重新加载数据
            fnDelThisFreshPage();
        }
    });
}
/**
 * 拒绝借阅
 */
function fnRefuseBorrow(_this) {
    var oData = fnGetThisPointData(_this);
    var dialog = $.dialog({
                id : 'RefuseBorrowDialog',
                url : cPageData._path + "doc/knowledgeController.do?method=link&path=borrowMsgEdit&isAgree=false",
                width : 400,
                height : 120,
                title : "${ctp:i18n('doc.refused.to.borrowing')}",
                targetWindow:getCtpTop(),
                buttons : [ {
                    id : 'submitBtnId',
                    text : "${ctp:i18n('metadata.manager.ok')}",
                    handler : function() {
                        fnRefuseBorrowBtn(dialog, oData, _this);
                    }
                }, {
                    text : "${ctp:i18n('systemswitch.cancel.lable')}",
                    handler : function() {
                        dialog.close();
                    }
                } ]
            });
}

function fnRefuseBorrowBtn(dialog, oData, _this) {
    var sdata = dialog.getReturnValue();
    dialog.disabledBtn('submitBtnId');
    if (sdata !== null) {
        var data = $.parseJSON(sdata);
        data.brrowId = oData.brrowId;// 借阅id
        data.userId = $.ctx.CurrentUser.id;
        data.docId= oData.docId;
        cPageData.ajaxPageManager.updateStatus(data, {
            success : function(returnVal) {
            	if(returnVal==1){
                $.error('${ctp:i18n('doc.broow.handle.no.potent')}');
            	}else if(returnVal==2){
                var confirm = $.confirm({
                    'msg': '${ctp:i18n('doc.broow.handle.doc.notExits')}',
                    ok_fn: function () { 
                        //忽略当前请求消息
                        fnIgnoreBorrowOk(_this);
                    },
                    cancel_fn:function(){
                    }
                });
            }
            //刷新页面
            fnDelThisFreshPage();
            dialog.close();
            dialog.enabledBtn('submitBtnId');
         }
        });
    } else {
        dialog.enabledBtn('submitBtnId');
    }
}
/**
 * 同意借阅
 */
function fnAgreeBorrow(_this) {
    var oData = fnGetThisPointData(_this);
    var dialog = $
            .dialog({
                id : 'AgreeBorrowDialog',
                url : cPageData._path
                        + "doc/knowledgeController.do?method=link&path=borrowMsgEdit&isAgree=true",
                width : 400,
                height : 190,
                title : "${ctp:i18n('doc.agreed.to.borrowing')}",
                targetWindow:getCtpTop(),
                buttons : [ {
                    id : 'submitBtnId',
                    text : "${ctp:i18n('guestbook.leaveword.ok')}",
                    handler : function() {
                        fnAgreeBorrowBtn(dialog, oData, _this);
                    }
                }, {
                    text : "${ctp:i18n('systemswitch.cancel.lable')}",
                    handler : function() {
                        dialog.close();
                    }
                } ]
            });
}

function fnAgreeBorrowBtn(dialog, oData, _this) {
    var sdata = dialog.getReturnValue();
    dialog.disabledBtn('submitBtnId');
    if (sdata !== null) {
        var data = $.parseJSON(sdata.replace(/\\/g, ''));
        data.brrowId = oData.brrowId;// 借阅id
        data.docId= oData.docId;
        cPageData.ajaxPageManager.updateStatus(data, {
            success : function(returnVal) {
                if(returnVal==1){
                    $.error('${ctp:i18n('doc.broow.handle.no.potent')}');
                }else if(returnVal==2){
                    var confirm = $.confirm({
                        'msg': '${ctp:i18n('doc.broow.handle.doc.notExits')}',
                        ok_fn: function () { 
                            //忽略当前请求消息
                            fnIgnoreBorrowOk(_this);
                        },
                        cancel_fn:function(){
                        }
                    });
                }
                //刷新页面
                fnDelThisFreshPage();
                dialog.enabledBtn("submitBtnId");
                dialog.close();
            }
        });
    } else {
        dialog.enabledBtn('submitBtnId');
    }
}

/**
 * 删除当前数据，刷新页面
 */
function fnDelThisFreshPage() {
//   window.location.reload();
	fnLoadData();
}
/**
 * 载入数据
 */
function fnLoadData(){
    var oParam = {"userId" : $.ctx.CurrentUser.id};
    $('#ajaxgridbar').ajaxgridbarLoad(oParam);
}

/**
 * 删除数组中对应位置的元素
 */
function fnDelInArray(array, index) {
    if (array != null && index > -1 && index < array.length) {// 合法性判断
        return array.splice(index, 1);
    }
    return array;
}
