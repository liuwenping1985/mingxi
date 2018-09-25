// js开始处理
$(function() {
    pTemp.categoryDiv = $("#categoryDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new autoCategoryManager();
    pTemp.isModfiy = false;
    fnPageInIt();
    fnSetCss();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
    pTemp.ok.click(fnOK);
    pTemp.cancel.click(fnCancel);
}


/**
 * 刷新载入
 * 
 * @param areaId，刷新页面部分的id
 */
function fnPageReload(p) {
    var mode = p.mode, row = p.row;
    pTemp.mode = p.mode;
    if (mode == 'add' || mode == 'modify') {
        //按钮显示与隐藏
        pTemp.btnDiv.show();
        pTemp.categoryDiv.enable();
    } else {
        //按钮显示与隐藏
        pTemp.btnDiv.hide();
        pTemp.categoryDiv.disable();
    }
    
    if (mode === 'add') {
    	pTemp.isModfiy = false;
        pTemp.categoryDiv.clearform();
        $("input:hidden").each(function(){
            $(this).val("");
        });
        //选人组件清空
        $("#range")[0].value = "";
    }else{
        pTemp.categoryDiv.fillform(row);
        if(row){
            //选人组件回填
            $("#range").comp({value : row.rangeScope,
                text : row.range,minSize : 0
            }); 
        }
    }
    if(mode == 'modify'){
    	pTemp.isModfiy = true;
    }
    $("#categoryDiv").resetValidate();
    // $(".editTitle").text(i18n.docPorperty + " " + i18n[mode]);
}

/**
 * 页面样式控制
 */
function fnSetCss() {
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.categoryDiv.disable();
  }
}

/**
 * 新建
 */
function fnNew(category) {
    pTemp.ajaxM.save(category, {
        success : function(returnVal) {
            $.infor($.i18n('office.auto.savesuccess.js'));
            // 可以修改一下提交方式
            parent.pTemp.tab.load();
            parent.pTemp.tab.reSize('d');
            // 关闭遮罩
            endProcePub();
        },
        error : function(rval) {
          endProcePub();
        }
    });
}


/**
 * 确定
 */
function fnOK() {
	$("#categoryDiv").resetValidate();
    openProcePub();
    var isAgree = $("#categoryDiv").validate();
    if (!isAgree) {// js校验
        endProcePub();
        return;
    }
    var category = pTemp.categoryDiv.formobj();
    pTemp.ajaxM.isUniqName(category, {
        success : function(returnVal) {
            if (returnVal == false) {
                $.alert($.i18n('office.auto.category.name.exist.js'));
                endProcePub();
                return;
            }
            fnNew(category);
        }
    });
}

/**
 * 取消
 */
function fnCancel() {
	if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.sure.giveup.operate.js'),
		    ok_fn: function () { parent.pTemp.tab.reSize("d"); },
			cancel_fn:function(){return;}
		});
	}else{
		parent.pTemp.tab.reSize("d");
	}
}
