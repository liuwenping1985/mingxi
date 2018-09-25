// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["apply","modify","revoke","del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArgFuncPub").addAll(["applyUser","applyDept","applyAutoIdName","createDate","state"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "applyUser","applyDept","passengerNum","applyOrigin","useTime","applyDes","applyAutoId","createDate","state" ]).init("autoApply", {
        argFunc : "fnTabItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "autoApplyManager",
        "managerMethod" : "find"
    });
    pTemp.tab.load();
    pTemp.ajaxM = new autoApplyManager();
});

/**
 * 单击Tab查看
 */
function fnTabClk() {
  var rows = pTemp.tab.selectRows();
  urlMapping(rows,true);
}

/**
 * 编辑Tab
 */
function fnModify() {
  var rows = pTemp.tab.selectRows();
  if(rows.length == 0){
      $.alert($.i18n('office.auto.select.edit.js'));
      return;
  }else if(rows.length > 1){
      $.alert($.i18n('office.auto.select.edit.onlyone.js'));
      return;
  }
  pTemp.ajaxM.canModify(rows[0].id, {
    success : function(returnVal) {
      if (returnVal == false) {
        $.alert($.i18n('office.auto.modfiy.option.only.js'));
        return;
      }
      urlMapping(rows,false);
    }
  });
}
/**
 * 查看或者编辑的url设定 true 置灰 false 可编辑
 */
function urlMapping(rows,type){
  var url = "/office/autoUse.do?method=autoApplyIframe";
  if (!type) {
  	url += "&operate=modfiy";
  }else{
  	url += "&operate=view";
  }
  var id = rows[0].id;
  url += "&applyId=" + id + "&state=" + rows[0].state +"&workItemId="+ rows[0].workItemId+"&fnTabClk="+type+"&v="+rows[0].v;
  fnAutoOpenWindow({"url":url,"title":$.i18n('office.app.auto.use.apply.bill.js'),hasBtn:false,width:800,height:520});
}

/**
 * 弹出界面取消按钮
 */
function fnCancel(){
}

/**
 * 刷新页面
 * 
 * @param areaId，刷新部分的id
 */
function fnPageReload() {
  pTemp.tab.load();
}

/**
 * tBar新增
 */
function fnApply() {
  var url = "/office/autoUse.do?method=autoApplyIframe&applyId=0&operate=new&fnTabClk=false";
  if(pTemp.jval!=''){
  	url += "&v=" + $.parseJSON(pTemp.jval).v;
  }
  fnAutoOpenWindow({"url":url,"title":$.i18n('office.app.auto.use.apply.new.js'),hasBtn:false,width:800,height:520});
}

/**
 * tBar删除
 */
function fnDel() {
    var rowIds = pTemp.tab.selectRowIds();
    
    if(rowIds.length == 0){
        $.alert($.i18n('office.select.del.recored.js'));
        return;
    }
    //ajax调用后台
    //需要增加校验当前申请单状态
    $.confirm({
        'msg' : $.i18n('office.auto.really.delete.js'),
        ok_fn : function() {
            pTemp.ajaxM.deleteByIds(rowIds, {
                success : function(returnVal) {
                  if(returnVal){
                    var size = returnVal.split(",")[0];
                    var name = returnVal.split(",")[1];
                    var msg = $.i18n("office.auto.delete.option.only.js",name);
                    if(size != "1" && size != "0"){
                      msg = msg +"("+$.i18n('office.auto.manager.moreone.js')+")";
                    }
                    msg = msg+$.i18n('office.auto.delfail.js');
                    $.messageBox({
                      'title':$.i18n('office.system.title.js'),
                      'type': 0,
                      'msg': msg,
                      'imgType': 2,
                      ok_fn: function () { fnPageReload();}
                  });
                  }else{
                    $.messageBox({
                      'title':$.i18n('office.system.title.js'),
                      'type': 0,
                      'msg': $.i18n('office.auto.delsuccess.js'),
                      'imgType': 0,
                      ok_fn: function () { fnPageReload();}
                  });
                  }
                  
                }
            });
        }
    });
}

/**
 * tBar撤销
 */
function fnRevoke() {
  var rowIds = pTemp.tab.selectRowIds();
  if(rowIds.length == 0){
      $.alert($.i18n('office.auto.select.revoke.js'));
      return;
  }else if(rowIds.length > 1){
      $.alert($.i18n('office.auto.select.revoke.onlyone.js'));
      return;
  }
  //ajax调用后台
  
  //判断是否可撤销
  pTemp.ajaxM.canRevoke(rowIds[0], {
    success : function(returnVal) {
      if (returnVal == false) {
        $.alert($.i18n('office.auto.revoke.option.only.js'));
        return;
      }
    //撤销流程
      var dialog = $.dialog({
          url: _ctxPath + "/office/officeTemplate.do?method=showOfficeWorkflowRepeal",
          width:450,
          height:240,
          title:$.i18n('common.repeal.workflow.label'),//撤销流程
          targetWindow:getCtpTop(),
          buttons : [ {
              text : $.i18n('collaboration.button.ok.label'),//确定
              isEmphasize:true, 
              handler : function() {
                var returnValue = dialog.getReturnValue();
                if (!returnValue){
                    return ;
                }
                var tempMap = new Object();
                tempMap["repealComment"] = returnValue;
                tempMap["id"] = rowIds[0];
                  pTemp.ajaxM.revokeByIds(tempMap, {
                    success : function(returnVal) {
                      if(returnVal == "true"){
                        $.messageBox({
                          'title':$.i18n('office.system.title.js'),
                          'type': 0,
                          'msg': $.i18n('office.revoke.success.js'),
                          'imgType': 0
                        });
                      }else{
                        $.infor($.i18n('office.revoke.fail.js'));
                      }
                      dialog.close();
                      fnPageReload();
                    }
                });
              }
            }, {
              text : $.i18n('collaboration.button.cancel.label'),//取消
              handler : function() {
                  releaseWorkflowByAction(rowIds[0].processId, $.ctx.CurrentUser.id, 12);
                  dialog.close();
              }
            } ],
            closeParam:{
              show:true,
              handler:function(){
                  releaseWorkflowByAction(rowIds[0].processId, $.ctx.CurrentUser.id, 12);
              }
            }
        });
    }
  });

}

/**
 * 查询
 */
function fnSBarQuery(cnd){
  cnd.isQuery = "true";
  pTemp.tab.load(cnd);
}