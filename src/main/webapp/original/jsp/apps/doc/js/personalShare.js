var cPageData = new Object();
$().ready(function(){
    cPageData._path = "${path}/";
    cPageData.ajaxPageManager = new knowledgePageManager();
    cPageData.cssDisBtn = "common_button_disable";
    cPageData.cssDisHref = "disabled_color";
    cPageData.createFlag = -1;
    cPageData.treeClicked = false;
    cPageData.textNames = ["<${ctp:i18n('doc.input.introduced')}>","<${ctp:i18n('doc.input.document.keywords')}>" ];
    // 文档树
    var docTreeSetting = {
        onClick : fnTreeClick,
        idKey : "id",
        pIdKey : "pid",
        nameKey : "name",
        titleKey : "sortName",
        view : {
            showIcon : false,
            showLine : false,
            selectedMulti : false
        },
        edit : {
            enable : true,
            showRenameBtn : false
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
                n.isParent = true;
            }
        }
    };
    // 输入文档的提示信息
    $("#frDesc,#keyWords").focus(fnInputFocus).blur(fnInputBlur);
    $("#frDesc,#keyWords").focus().blur();
    // 加载文档树
    $("#divDocTree").tree(docTreeSetting);
    $("#aFileUploadId").addClass(cPageData.cssDisBtn);
    $("#aNewFile").addClass(cPageData.cssDisBtn);
    $("#aNewDoc").addClass(cPageData.cssDisHref);
    $("#shareDivId").click(fnRadioToggle);
    $(":input[id=versionEnabled]").attr("disabled", "disabled");
    $("#versionEnabledFont").addClass("color_gray");
    // 取消或者返回
    $("#btnCancelId,#hrefGoBackId").click(fnCancelOrGoBack);
    // 确定，确定返回文档中心
    $("#btnSubmit").click(fnSubmit);
    // 共享设置按钮是否开启
    $("#shareDivId :input").attr("disabled", "disabled");
    $("#shareDivId label").addClass("disabled_color");
    //调节样式
    fnMainReSize();
    $(window).resize(function(){
        fnMainReSize();
    });
    //选中第一个节点
    fnTreeSelected();
});

/**
 * 树选中第一个节点
 */
function fnTreeSelected(){
    var docTree=$("#divDocTree").treeObj();
    var nodes = docTree.getNodes();
    var nodesArray=docTree.transformToArray(nodes); 
    if (nodesArray.length>1) {
        docTree.selectNode(nodesArray[1]);
        docTree.expandNode(nodesArray[1],true,false);
        fnTreeClick(null, null, nodesArray[1]);
    }
}
/**
 * 调节高度
 */
function fnMainReSize(){
  var iTotalHeight = $(parent.main).height();
  var iDivFoot =  $("#divFootId").height();
  $("#divPageId").height(iTotalHeight-iDivFoot);
}
/**
 * 按钮的开启与disable
 */
function fnTransformBtn() {
    var flag = false;
    var oFileUpload = $("#aFileUploadId");
    var oAnewFile = $("#aNewFile");
    var oAnewDoc = $("#aNewDoc");

    // 联动，新建文档夹 与 上传文档，新建文档
    if (!flag) {
        oAnewFile.addClass(cPageData.cssDisBtn);
        oAnewFile.unbind("click");
    } else {
        if (oAnewFile.hasClass(cPageData.cssDisBtn)) {
            oAnewFile.removeClass(cPageData.cssDisBtn);
            oAnewFile.click(fnNewDocFolder);
        }
    }

    if (!flag) {// 允许上传
        oFileUpload.addClass(cPageData.cssDisBtn);
        oFileUpload.unbind("click");
    } else {
        if (oFileUpload.hasClass(cPageData.cssDisBtn)) {
            oFileUpload.removeClass(cPageData.cssDisBtn);
            oFileUpload.click(fnFileUpload);
        }
    }
    // 新建文档
    if (!flag) {
        oAnewDoc.addClass(cPageData.cssDisHref);
        oAnewDoc.unbind("click");
        oAnewDoc.attr("disable", "disable");
    } else {
        if (oAnewDoc.hasClass(cPageData.cssDisHref)) {// 新建文件
            oAnewDoc.removeClass(cPageData.cssDisHref);
            oAnewDoc.attr("disable", "enable");
            // 新建菜单
            initMenu(ndata.createHtml, ndata.createOffice);
        }
    }
}
/**
 * 删除文档Confirm
 */
function fnDelDocmentConfirm() {
    var msg= "${ctp:i18n('doc.sure.want.giveup.document')}";
    if(cPageData.treeClicked){
        msg="${ctp:i18n('doc.sure.give.up.document.save')}";
    }
    cPageData.treeClicked = false;
    var confirm = $.confirm({
        'msg' : msg,
        ok_fn : fnDelDocment
    });
}
/**
 * 删除文档
 */
function fnDelDocment() {
    var url = cPageData._path + "doc.do?method=delete";
    var param = $("#divDocTree").treeObj().getSelectedNodes()[0].data;
    var params=new Object();
    cloneAll(param,params);
    params.id = $("#hrefRmoveDocId").attr("docId");
    params.docLibType = param.libType;
    // 调用后台，删除文档
    AjaxDataLoader.load(url, params, function(str) {
    });
    // 修改页面文档样式
    $("#newDocumentIconId").removeClass("ico16 txt_16 xls_16 word_16 wps_16 xls2_16");
    $("#newDocumentNameId").text("").attr("titile", "");
    $("#hrefRmoveDocId").attr("docId", "").removeClass("ico16 affix_del_16")
            .unbind("click");
    // 修改标记位
    cPageData.createFlag = -1;
    // 刷新界面的按钮状态
    fnTreeClick(null, null, null);
}

/**
 * 创建文档关闭时，回调函数
 */
function fnCloseCreateDocDialog(param) {
    var returnVal = $.parseJSON(param);
    var oBodyTypeStyles = {
        "10" : "html_16",//HTML
        "41" : "office41_16",//OfficeExcel
        "42" : "xls_16",//OfficeWord
        "43" : "wps_16",//wpsWord
        "44" : "xls2_16"//wpsExcel
    };
    var css = oBodyTypeStyles[cPageData.bodyType];
    var id = returnVal.id;
    var frName = returnVal.frName;

    $("#newDocumentIconId").removeClass("ico16 html_16 xls_16 doc_16")
            .addClass("ico16 " + css);
    $("#newDocumentNameId").text(revertHtmlEnc(frName).getLimitLength(30)).attr("title", revertHtmlEnc(frName));
    $("#hrefRmoveDocId").attr("docId", id).click(fnDelDocmentConfirm).addClass(
            "ico16 affix_del_16");
    $("#domainsSub2 :hidden[id=id]").val(id);
    $("#domainsSub2 :hidden[id=vForBorrowS]").val(returnVal.vForBorrowS);
    fnTransformBtn();
    cPageData.createFlag = 1;
    //记录穿件文档时，选择树节点的id
    var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0];
    cPageData.selectTreeId=selectNode.data.id;
    
    cPageData.cdocDialog.close();
    fnToggleDivDisplay();
}

function revertHtmlEnc(s){
    if (!s){
        return s;
    }  
    var str = s.replace(/&amp;/gi, '&');
    str = str.replace(/&lt;/gi, '<');
    str = str.replace(/&gt;/gi, '>');
    str = str.replace(/&quot;/gi, '\"');
    str = str.replace(/&nbsp;/gi, ' ');
    str = str.replace(/&#039;/gi, '\'');
    str = str.replace(/<br( )?(\/)?>/gi, '\n');
    return str;
};

/**
 * 创建文档
 */
function fnCreateDocument(param) {
	cPageData.treeClk = false;
    //空间大小检查
    var spaceSize = getLeftSpaceByType(0, $.ctx.CurrentUser.id);
	if(spaceSize < 10*1024 && spaceSize > 500){
		$.confirm({msg:"${ctp:i18n('doc.personal.storage.not.enough.alert')}",ok_fn:function(){
			createDoc(param);
		}});
	}else if(spaceSize <= 500){
		$.alert("${ctp:i18n('doc.personal.storage.not.enough')}");
		return;
	}else{
		createDoc(param);
	}
}

function createDoc(param){
	var bodyTypeId = param.id;
	cPageData.bodyType = bodyTypeId;
	var param = new Object();
	var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0];
	// 创建文档时，选中的树节点
	cPageData.selectNode = selectNode;
	var cUrl = cPageData._path
			+ "doc.do?method=theNewAddDoc&isDialog=true&personalShare=true&"
			+ fnGetCreateDocParams(bodyTypeId, selectNode);
	var bodyType = fnTransIntoBodyType(bodyTypeId);
	cPageData.cdocDialog = $.dialog({
		id : 'createDocumentDialogId',
		url : cUrl,
		title : "${ctp:i18n('common.toolbar.new.label')}" + bodyType
				+ "${ctp:i18n('doc.contenttype.wenjian')}",
		top : 10,
		width : $(getCtpTop()).width() - 20,
		height : $(getCtpTop()).height() - 50,
		targetWindow : getCtpTop()
	});
}

/**
 * 转换成文档格式类型名称
 * 
 * @param bodyTypeId
 *            文档类型Id
 * @returns {String} 文档类型名称
 */
function fnTransIntoBodyType(bodyTypeId) {
	switch (bodyTypeId) {
	case 10:
		return 'HTML';
	case 41:
		return 'OfficeWord';
	case 42:
		return 'OfficeExcel';
	case 43:
		return 'WpsWord';
	case 44:
		return 'WpsExcel';
	default:
		return 'unknown';
	}
}
function fnGetCreateDocParams(bodyType, selectNode) {
	var docMimeType = 22;
    if(bodyType == 41){
    	docMimeType = 23;
    }else if(bodyType == 42){
    	docMimeType = 24;
    }else if(bodyType == 43){
    	docMimeType = 25;
    }else if(bodyType == 44){
        docMimeType = 26;
    }else if(bodyType == 45){
        docMimeType = 103;
    }
    var cData = selectNode.data;
    var returnParams = "personalShare=true&parentId=" + selectNode.id + "&frType="
            + cData.frType + "&docLibId=" + cData.docLibId + "&docLibType="
            + cData.libType + "&bodyType=" + bodyType + "&docMimeType=" + docMimeType + "&"
            + "&parentCommentEnabled=" + cData.commentEnabled + "&parentRecommendEnable=" + cData.recommendEnable
            + "&parentVersionEnabled=" + cData.versionEnabled + "&parentPath="
            + cData.logicalPath + "&from=docShare" + "&all=" + cData.potent.all
            + "&edit=" + cData.potent.edit + "&add=" + cData.potent.create
            + "&readonly=" + cData.potent.readOnly + "&browse="
            + cData.potent.read + "&list=" + cData.potent.list;
    return returnParams;
}

function fnRadioToggle() {
	
    if ($("#shareDivId input[id=share]").attr("checked") === "checked") {// 公开
        $("#setPotentId").removeClass("display_none");
        if (cPageData.borrowSettingFlag) {
            fnDelBorrow();
        }
    } else {
        $("#setPotentId").addClass("display_none");
    }

    if ($("#shareDivId input[id=secrecy]").attr("checked") === "checked") {// 私秘
        if (cPageData.borrowSettingFlag) {
            fnDelBorrow();
        }
    }

    var oHref = $("#shareDivId a[id=hrefSettingId]");
    if ($("#shareDivId [id=custom]").attr("checked") === "checked") {// 设置
        oHref.removeClass(cPageData.cssDisBtn);
        oHref.unbind("click");
    } else {
        oHref.addClass(cPageData.cssDisBtn);
        oHref.unbind("click");
    }
    
    setTimeout(function(){
    	if($("#shareDivId input[id=custom]").is(":checked")) {// 设置
    		$("#hrefSettingId").unbind("click");
    		$("#hrefSettingId").bind("click",fnBorrowSetting);
      }else{
      	$("#hrefSettingId").unbind("click");
      }
    },200);
}

function fnDelBorrow() {
    if (cPageData.borrowSettingFlag) {
        var id = $("#domainsSub2 :hidden[id=id]").val();
        var param = $("#divDocTree").treeObj().getSelectedNodes()[0].data;
        var url = cPageData._path
                + "doc.do?method=docLabeldSave&isFolder=false&ucfBorrow=true&docResId="
                + id + "&docLibType=" + param.libType + "&borrowDocResId=" + id
                + "&docLibType="

        param.id = $("#hrefRmoveDocId").attr("docId");
        param.docLibType = param.libType;
        // 调用后台，删除订阅
        AjaxDataLoader.load(url, param, function(str) {
        });
        cPageData.borrowSettingFlag = false;
    }
}

/**
 * 设置按钮函数
 */
function fnBorrowSetting() {
    if (cPageData.createFlag === -1) {
        $.alert("${ctp:i18n('doc.create.doc.upload')}");
        $("#shareDivId input[id=share]").attr("checked","checked");
        fnRadioToggle();
        return;
    }
    
    var node = $("#divDocTree").treeObj().getSelectedNodes()[0];
    var cData = node.data;
    if(!cData.potent.all){
        $.alert("${ctp:i18n('doc.personal.share.no.potent.title')}");
        return;
    }
    cPageData.settingBtn = true;// 设置过
    getA8Top().LibPropWin = $.dialog({
        id : 'borrowSettingDialog',
        url : cPageData._path + "doc.do?method=docPropertyIframe"
                + buildSettingParam(),
        width : 500,
        height : 513,
        title : "${ctp:i18n('doc.document.borrowing')}",
        targetWindow : getA8Top(),
        transParams : {'parentWin':window}
    });
}

/**
 * 构造借阅设置的参数
 */
function buildSettingParam() {
    var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0];
    var cData = selectNode.data;
    var id = $("#domainsSub2 :hidden[id=id]").val();
    var vForBorrowS = $("#domainsSub2 :hidden[id=vForBorrowS]").val()

    var isPersonalLib = false;
    if (cData.libType == '1') {
        isPersonalLib = true;
    }
    var propEditValue = false;
    if (cData.potent.edit || cData.potent.all) {
        propEditValue = true;
    }
    // &frType=21 一定是文档
    var params = "&isFolder=false&frType=21&isP=false&isB=true&isM=false&isC=false&all="
            + cData.potent.all
            + "&edit="
            + cData.potent.edit
            + "&add="
            + cData.potent.create
            + "&readonly="
            + cData.potent.readOnly
            + "&browse="
            + cData.potent.read
            + "&list="
            + cData.potent.list
            + "&allAcl="
            + cData.potent.all
            + "&docLibType="
            + cData.libType
            + "&resId="
            + selectNode.id
            + "&docResId="
            + id
            + "&isPersonalLib="
            + isPersonalLib
            + "&isShareAndBorrowRoot=false&propEditValue="
            + propEditValue
            + "&isPersonalShare=true&v=" + vForBorrowS;
    return params;
}

/**
 * 文件上传完成后回调函数
 */
function fnFileUploadCallBack(fileid, repet) {
    var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0];
    // 创建文档时，选中的树节点,做记录
    cPageData.selectNode = selectNode;

    var param = selectNode.data;
    var docResourceId = param.id;
    var docLibId = param.docLibId;
    var docLibType = param.libType;
    var parentCommentEnabled = param.commentEnabled;
    var parentVersionEnabled = param.versionEnabled;
    var parentRecommendEnable = param.parentRecommendEnable;
    $(":hidden [id=nodeId]").val(selectNode.id);
    $(":hidden [id=docResourceId]").val(docResourceId);
    $(":hidden [id=docLibId]").val(docLibId);
    $(":hidden [id=docLibType]").val(docLibType);
    $(":hidden [id=parentCommentEnabled]").val(parentCommentEnabled);
    $(":hidden [id=parentVersionEnabled]").val(parentVersionEnabled);
    $(":hidden [id=parentRecommendEnable]").val(parentRecommendEnable);
    $(":hidden [id=all]").val(param.potent.all);
    $(":hidden [id=edit]").val(param.potent.edit);
    $(":hidden [id=create]").val(param.potent.create);
    $(":hidden [id=readonly]").val(param.potent.readOnly);
    $(":hidden [id=read]").val(param.potent.read);
    $(":hidden [id=list]").val(param.potent.list);
    
    // 禁用创建文档按钮
    fnTransformBtn();
    // 修改标记位
    cPageData.createFlag = 0;
    //记录创建文档时，选择树节点的id
    cPageData.selectTreeId=param.id;
    // 附件上传后的删除按钮，触发这个事件
    // var fnDelClick = $("#attachmentArea span[class$=del_16]").click();
    $("#attachmentArea span[class$=del_16]").removeAttr('onclick').unbind(
            'click');
    //保存上传附件id
    var sDelFileId = $("#domainsSub div[id^=attachmentDiv_]").attr(
    "id").substring("attachmentDiv_".length);
    cPageData.sDelFileId = sDelFileId;
    // 取消默认回调
    $("#attachmentArea span[class$=del_16]").click(
            function() {// 注册回调函数
                var confirm = $.confirm({
                    'msg' : "${ctp:i18n('doc.sure.want.delete.document')}",
                    ok_fn : function() {
                        fnDelAttachment();
                        // 回复标记
                        cPageData.createFlag = -1;
                        fnTreeClick(null, null, null);
                    },
                    cancel_fn : function() {
                        // 返回树上次选中状态
                        $("#divDocTree").treeObj().selectNode(
                                cPageData.selectNode, false);
                    }
                });
            });
    // 保存文件
    $("#domainTop").jsonSubmit(
    {
        action : cPageData._path
                + "doc/knowledgeController.do?method=docUpload",
        domains : [ "domainsSub", "domainsSub2" ],
        debug : false,
        callback : function(oReturn) {
            var oData = $.parseJSON(oReturn);
            if (oData.data != "null") {
                var sId = $.parseJSON(oData.data).id;
                $("#domainsSub2 :hidden[id=id]").val(sId);
                $("#domainsSub2 :hidden[id=vForBorrowS]").val($.parseJSON(oData.data).vForBorrowS);
            } else {
                $.alert(oData.msg);
                var sDelFileId = $("#domainsSub div[id^=attachmentDiv_]").attr("id").substring("attachmentDiv_".length);
                deleteAttachment(sDelFileId, false);
                // 删除附件
                cPageData.createFlag = -1;
                fnTreeClick(null, null, null);
            }
            fnToggleDivDisplay();
        }
    });
   
}
/**
 * 切换附件，文档显示样式
 */
function fnToggleDivDisplay(){
    //修改显示附件
    if(cPageData.createFlag===0){//附件
        $("#attachmentDivNone").removeClass("display_none");
        $("#docDivNone").addClass("display_none");
    }else if(cPageData.createFlag===1){//文档
        $("#docDivNone").removeClass("display_none");
        $("#attachmentDivNone").addClass("display_none");
    }
}

function fnDelAttachment() {
    var sDelFileId = cPageData.sDelFileId;
    var sDocId = $("#domainsSub2 :hidden[id=id]").val();
    deleteAttachment(sDelFileId, false);
    var data = {
        "docId" : sDocId
    };
    // 后台删除附件+新建doc对象
    cPageData.ajaxPageManager.deleteDocumentById(data, {
        success : function(rval) {
        }
    });
}

/**
 * 文件上传
 */
function fnFileUpload() {
	  cPageData.treeClk = false;	
    insertAttachment();
}

/**
 * 取消或者返回
 */
function fnCancelOrGoBack() {
    cPageData.treeClicked = false;
    var oMain = getCtpTop().document.getElementById("main");
    if (cPageData.createFlag !== -1) {
        // 提示，确定放弃当前操作
        $.confirm({
            'msg' : "${ctp:i18n('doc.sure.want.giveup.document')}",
            ok_fn : function() {
                // 删除借阅
                fnDelBorrow();
                if (cPageData.createFlag === 0) {
                    // 删除附件
                    fnDelAttachment();
                } else if (cPageData.createFlag === 1) {
                    // 删除上传文档
                    fnDelDocment();
                }
                oMain.src=cPageData._path+"doc/knowledgeController.do?method=personalKnowledgeCenterIndex"
            }
        });
    }else{
        if(!$.ctx.resources.contains('F04_showKnowledgeNavigation')){
            oMain.src=cPageData._path+"doc/knowledgeController.do?method=toKnowledgeSquare&_resourceCode=F04_knowledgeSquareFrame&tab=1";   
        }else{
            oMain.src=cPageData._path+"doc/knowledgeController.do?method=personalKnowledgeCenterIndex"
        }
    } 
}
/**
 * 确定Dailog
 */
function fnSubmitDailog(docId){
    var aButtons=[{
        id:'btn0',
        text: "${ctp:i18n('doc.personal.share.go.on')}",
        handler: function () {
            window.location.reload(true);
        }
    }];
    if ($.ctx.resources.contains('F04_docIndex')) {
        aButtons[aButtons.length] = {
            id : 'btn1',
            text : "${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}",
            handler : function() {
                random.close();
                window.location = cPageData._path
                        + "doc.do?method=docHomepageIndex&docResId=" + docId;
            }
        }
    }
    if($.ctx.resources.contains('F04_knowledgeSquareFrame')){
        aButtons[aButtons.length]={
                id:'btn2',
                text: "${ctp:i18n('doc.jsp.knowledge.go.knowledge.square')}",
                handler: function () {
                    random.close();
                    var oMain = getCtpTop().document.getElementById("main");
                    oMain.src=cPageData._path+"doc/knowledgeController.do?method=toKnowledgeSquare&_resourceCode=F04_knowledgeSquareFrame&tab=1";
                }
            };
    }
    var random = $.messageBox({
        type:100,
        imgType:0,
        title:"${ctp:i18n('doc.system.message')}",
        msg: "${ctp:i18n('doc.personal.share.success')}",
        close_fn : fnCancelOrGoBack,
        buttons:aButtons
    });
    return;
}

/**
 * 提交或者提交返回到文档中心
 */
function fnSubmit() {
    //关闭提交按钮，防止重复提交
    $("#btnSubmit").addClass("common_button_disable").unbind("click");
    cPageData.proce = $.progressBar(); 
    var btnId = $(this).attr("id");
    var selectNodes = $("#divDocTree").treeObj().getSelectedNodes();
    if (selectNodes.length === 0||cPageData.createFlag === -1) {
        cPageData.proce.close();
        $("#btnSubmit").removeClass("common_button_disable").click(fnSubmit);
        $.alert("${ctp:i18n('doc.create.doc.upload')}");
        return;
    }
    var nodeData = selectNodes[0].data;
    var docId = nodeData.id;
    $("#domainsSub2 :hidden[id=docLibType]").val(nodeData.libType);  
    $("#domainsSub2 :hidden[id=docLibId]").val(nodeData.docLibId);
    if (!fnValidateInput()) {
        cPageData.proce.close();
        $("#btnSubmit").removeClass("common_button_disable").click(fnSubmit);
        return;
    }
    //提交之前验证是否设置借阅
    var newDocId = $("#domainsSub2 :hidden[id=id]").val();
    var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0].data;
    var docLibType = selectNode.libType;
    if ($("#shareDivId input[id=custom]").attr("checked") === "checked" && parseInt(docLibType) == 1) {
    	cPageData.ajaxPageManager.isSetAcl({docId:newDocId}, {
            success : function(rval) {
            	if(rval===true||rval==='true'){
            		var confirm = $.confirm({
            		    'msg': "${ctp:i18n('doc.please.setting.jieyue')}",
            		    ok_fn: function () { 
            		    	updateDoc(docId);
            		    },
            			cancel_fn:function(){
            				$("#btnSubmit").removeClass("common_button_disable").click(fnSubmit);
            				cPageData.proce.close();
            				fnBorrowSetting();
            			}
            		});
            	}else{
            		updateDoc(docId);
            	}
            }
        });
    }else{
    	updateDoc(docId);
    }
}

function updateDoc(docId){
	// 提交返回
    $("#updateDocAreaId").jsonSubmit({
        action : cPageData._path
                + "doc/knowledgeController.do?method=updateDocResource",
        debug : false,
        callback : function(oReturn) {
            cPageData.proce.close();
            cPageData.createFlag = -1;
            // 提交后，状态改变
            var oData = $.parseJSON(oReturn);
            if (oData.data != "null") {
                var data = $.parseJSON(oData.data);
                fnSubmitDailog(docId);
                cPageData.proce.close();
            } else {// 错误消息
                $.alert(oData.msg);
                cPageData.proce.close();
            }
        }
    });
}

/**
 * 验证文档输入
 */
function fnValidateInput() {
    var oFrDesc = $("#frDesc");
    var oKeyWords = $("#keyWords");

    var sFrDesc = oFrDesc.val().trim();
    var sKeyWords = oKeyWords.val().trim();

    if (sFrDesc === cPageData.textNames[0]) {
        oFrDesc.val("");
    }

    if (sKeyWords === cPageData.textNames[1]) {
        oKeyWords.val("");
    }

    var id = $("#domainsSub2 :hidden[id=id]").val();
    if (id === "") {
        $.alert("${ctp:i18n('doc.create.doc.upload')}");
        return false;
    }

    var isRight = $("#updateDocAreaId").validate({
        validate : true
    });
    
    return isRight;
}

/**
 * 新建文档夹
 */
function fnNewDocFolder() {
    cPageData.folderDialog = $.dialog({
                id : 'newDocFolderDialog',
                url : cPageData._path
                        + "doc/knowledgeController.do?method=link&path=newDocFolderEdit",
                width : $(window).width() * 0.3,
                height : $(window).height() * 0.2,
                title : "${ctp:i18n('doc.jsp.createf.title')}",
                targetWindow : window.top,
                buttons : [ {
                    id : 'btnok',
                    isEmphasize:true,
                    text : "${ctp:i18n('metadata.manager.ok')}",
                    handler : function() {
                        fnNewDocFolderBtn();
                    }
                }, {
                    text : "${ctp:i18n('systemswitch.cancel.lable')}",
                    handler : function() {
                        cPageData.folderDialog.close();
                    }
                } ]
            });
}

/**
 * 创建文档夹确认
 */
function fnNewDocFolderBtn() {
    var sdata = cPageData.folderDialog.getReturnValue();
    cPageData.folderDialog.disabledBtn('submitBtnId');
    if (sdata !== null) {
        var data = $.parseJSON(sdata.replace(/\\/g, ''));
        var treeObj = $("#divDocTree").treeObj();
        var nodes = treeObj.getSelectedNodes();
        var nodeData = nodes[0].data;
        data.parentId = nodeData.pid;
        data.docLibId = nodeData.docLibId;
        data.docLibType = nodeData.libType;

        var childNode = new Object();
        cloneAll(nodes[0].data, childNode);
        childNode.name = data.title;
        // 调用后台，新建文档夹
        var selectNode = $("#divDocTree").treeObj().getSelectedNodes()[0];
        var cUrl = cPageData._path
                + "doc.do?method=createFolderByPersonal&parentId="
                + selectNode.id + "&title=" + encodeURI(encodeURI( data.title )) + "&"
                + fnGetCreateDocParams(null, selectNode);
        AjaxDataLoader.load(cUrl, null, function(rVal) {
            var oRet = $.parseJSON(rVal);
            if (oRet.data === "null") {
                $.alert(oRet.msg);
                cPageData.folderDialog.enabledBtn('submitBtnId');
            } else {
                var oDoc=$.parseJSON(oRet.data);
                childNode.id = oDoc.id;
                childNode.logicalPath = oDoc.logicalPath;
                childNode.docLibId = oDoc.docLibId;
                childNode.pid = oDoc.pid;
                treeObj.addNodes(nodes[0], childNode);
                var createNode = treeObj.getNodeByParam("id", childNode.id);
                treeObj.selectNode(createNode, false);
                $.infor("${ctp:i18n('doc.new.docf.success')}");
                cPageData.folderDialog.close();
            }
        });
    } else {
        cPageData.folderDialog.enabledBtn('submitBtnId');
    }
}

function fnTreeClick(e, treeId, node) {
    if (node == null) {
        node = $("#divDocTree").treeObj().getSelectedNodes()[0];
    }

    var oFileUpload = $("#aFileUploadId");
    var oAnewFile = $("#aNewFile");
    var oAnewDoc = $("#aNewDoc");
    var oVersionEnabled = $(":input[id=versionEnabled]");
    var oVersionEnabledFont = $("#versionEnabledFont");
    var ndata = node.data;
    if(cPageData.createFlag !=-1){
        if(cPageData.selectTreeId===ndata.id){
           return;
        }
        $.confirm({
            'msg' : "${ctp:i18n('doc.sure.give.up.document.save')}",
            ok_fn : function() {
                if(cPageData.createFlag === 1){// 文档
                    fnDelDocment();
                }else if(cPageData.createFlag === 0){// 附件
                    fnDelAttachment();
                    cPageData.createFlag = -1;
                }
                // 删除创建文档
                fnTreeClick(null, null, null);
            },
            cancel_fn : function() {
                // 返回树上次选中状态
                $("#divDocTree").treeObj().selectNode(cPageData.selectNode,
                        false);
            }
        });
    }
    
    if (cPageData.createFlag != -1) {
        return;
    }
    // 联动，新建文档夹 与 上传文档，新建文档
    if (!ndata.createFolder) {
        oAnewFile.addClass(cPageData.cssDisBtn);
        oAnewFile.unbind("click");
    } else {
        if (oAnewFile.hasClass(cPageData.cssDisBtn)) {
            oAnewFile.removeClass(cPageData.cssDisBtn);
            oAnewFile.click(fnNewDocFolder);
        }
    }

    if (!ndata.upload) {// 允许上传
        oFileUpload.addClass(cPageData.cssDisBtn);
        oFileUpload.unbind("click");
    } else {
        if (oFileUpload.hasClass(cPageData.cssDisBtn)) {
            oFileUpload.removeClass(cPageData.cssDisBtn);
            oFileUpload.click(fnFileUpload);
        }
    }
    // 新建文档
    if (ndata.createHtml || ndata.createOffice) {
        if (oAnewDoc.hasClass(cPageData.cssDisHref)) {// 新建文件
            oAnewDoc.removeClass(cPageData.cssDisHref);
            oAnewDoc.attr("disable", "enable");
        }
        // 新建菜单
        initMenu(ndata.createHtml, ndata.createOffice);
    } else {
        oAnewDoc.addClass(cPageData.cssDisHref);
        oAnewDoc.unbind("click");
        oAnewDoc.attr("disable", "disable");
    }
    
    // 是否进行版本管理，是否可以进行权限设置
    if (parseInt(ndata.libType) === 1) {
        oVersionEnabled.attr("disabled", "disabled").removeAttr('checked');
        oVersionEnabledFont.addClass("color_gray");
        $("#shareDivId :input").removeAttr("disabled");
        $("#shareDivId label").removeClass("disabled_color");
    } else {
        oVersionEnabled.removeAttr("disabled");
        oVersionEnabledFont.removeClass("color_gray");
        $("#shareDivId :input").removeAttr("disabled");
        $("#shareDivId label").removeClass("disabled_color");
    }
    
    cPageData.treeClk = true;
    //分享设置
    if(ndata.libType !=1){//如果不是个人库，那么将禁用公开到广场和私密，并且
        $("#shareLabelId,#secrecyLabelId").addClass("disabled_color");
        $("#secrecy,#share").attr("disabled",true);
        $("#custom").attr("checked","checked");
    }else{
        $("#shareLabelId,#secrecyLabelId").removeClass("disabled_color");
        $("#secrecy,#share").attr("disabled",false);
        $("#share").attr("checked","checked");
    }
    //触发Raido相应的事件
    fnRadioToggle();
    //评论评分设置
    if(ndata.commentEnabled){
        $("#commentEnabled").attr("checked",true);
    }else{
        $("#commentEnabled").attr("checked",false);
    }
    
    //推荐的设置
    if(ndata.recommendEnable){
        $("#recommend").attr("checked",true);
    }else{
        $("#recommend").attr("checked",false);
    }
    
    //版本管理
    if(ndata.versionEnabled){
        $("#versionEnabled").attr("checked",true);
    }else{
        $("#versionEnabled").attr("checked",false);
    }
}

/**
 * 初始化菜单
 */
function initMenu(isCreateHtml, isCteateOffice) {
    var pw = new Object();
    var isCreateMenu = v3x.isOfficeSupport() && "${v3x:isOfficeOcxEnable()}" === 'true';
    if (isCreateMenu) {// 必须要有该插件
        try{
            var ocxObj = new ActiveXObject("HandWrite.HandWriteCtrl");
            pw.installDoc = ocxObj.WebApplication(".doc");
            pw.installXls = ocxObj.WebApplication(".xls");
            pw.installWps = ocxObj.WebApplication(".wps");
            pw.installEt = ocxObj.WebApplication(".et");
        }catch(e){
            pw.installDoc=false;
            pw.installXls=false;
            pw.installWps=false;
            pw.installEt=false;
        }
        
        if(!v3x.isMSIE){
					pw.installDoc=true;
					pw.installXls=true;
					pw.installWps=true;
					pw.installEt=true;
				}
    }

    var datas = [];
    var index = 0;
    if (isCreateHtml) {
        datas[index++] = {
            "id" : 10, //HTML
            "className" : "html_16",
            "name" : "Html${ctp:i18n('doc.contenttype.wenjian')}",
            "handle" : fnCreateDocument
        };
    }

    if (pw.installDoc && isCteateOffice) {
        datas[index++] = {
            "id" : 41, //OfficeWord
            "className" : "office41_16",
            "name" : "</span>Word${ctp:i18n('doc.create.doc.type')}",
            "handle" : fnCreateDocument
        };
    }

    if (pw.installXls && isCteateOffice) {
        datas[index++] = {
            "id" : 42, //OfficeExcel
            "className" : "xls_16",
            "name" : "</span>Excel${ctp:i18n('doc.create.doc.excel')}",
            "handle" : fnCreateDocument
        };
    }
    //wps
    if (pw.installWps && isCteateOffice) {
        datas[index++] = {
            "id" : 43, //wpsWord
            "className" : "wps_16",
            "name" : "</span>Wps${ctp:i18n('doc.create.doc.type')}",
            "handle" : fnCreateDocument
        };
    }
    
    if (pw.installEt && isCteateOffice) {
        datas[index++] = {
            "id" : 44, //wpsExcel
            "className" : "xls2_16",
            "name" : "</span>Wps${ctp:i18n('doc.create.doc.excel')}",
            "handle" : fnCreateDocument
        };
    }
    
    
    $("#aNewDoc").menuSimple({
        event : "mouseenter",
        data : datas
    });
}

function fnGetInputIndex(_this) {
    var index = 0;
    if (_this.attr("id") === "frDesc") {
        index = 0;
    } else if (_this.attr("id") === "keyWords") {
        index = 1;
    }
    return index;
}

function fnInputFocus() {
    if ($(this).val() === cPageData.textNames[fnGetInputIndex($(this))]) {
        $(this).val("");
    }
    $(this).removeClass("color_gray");
}

function fnInputBlur() {
    if ($(this).val().trim() === "") {
        $(this).val(cPageData.textNames[fnGetInputIndex($(this))]);
        $(this).addClass("color_gray");
    }
}

/*
 * 把fromObj对象复制到toObj
 */
function cloneAll(fromObj, toObj) {
    for ( var i in fromObj) {
        if (typeof (fromObj[i]) === "object") {
            toObj[i] = {};
            cloneAll(fromObj[i], toObj[i]);
            continue;
        }
        toObj[i] = fromObj[i];
    }
}

/**
 * 将对象的name:value值，封装到get请求参数中
 */
function transformParam(obj) {
    var params = "";
    var bFlag = false;
    for ( var i in obj) {
        if (bFlag) {
            params += "&";
        }
        params += i + "=" + obj[i];
        bFlag = true;
    }
    return params;
}
