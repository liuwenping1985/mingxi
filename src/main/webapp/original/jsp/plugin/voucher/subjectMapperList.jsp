<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
  .stadic_head_height{
    height:0px;
  }
  .stadic_body_top_bottom{
    bottom: 37px;
    top: 0px;
  }
  .stadic_footer_height{
    height:37px;
  }
</style>
<script type="text/javascript"
  src="${path}/ajax.do?managerName=subjectMapperManager,accountCfgManager,baseVoucherManager"></script>
<script type="text/javascript">
$().ready(function() {
  var total = '${ctp:i18n("info.totally")}';
  var subMapper=new subjectMapperManager(); 
  var baseVoucher = new baseVoucherManager();
    $("#subMapperForm").hide();
    $("#button").hide();
    function addform(){
      var cfgManager=new accountCfgManager();
        var accountBean = cfgManager.getDefaultAccountCfg();
      $("#subMapperForm").clearform({clearHidden:true});      
        $("#subMapperForm").enable();
        handleDisable();
        $("#subMapperForm").show();
        $("#welcome").hide();
        $("#button").show();
        if(accountBean!=null){
          $("#accountId").val(accountBean.id);
          checkSupportBook();
          $("#accountName").val(accountBean.name);
          $("#bookName").val(accountBean.bookName);
          $("#bookCode").val(accountBean.bookCode);
          $("#erpUnitName").val(accountBean.extAttr1);
        }
        mytable.grid.resizeGridUpDown('middle');
    }
    //工具栏按钮
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",//新增
            className: "ico16",
            click: function() {
              addform();
            }
        },
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",//修改
            className: "ico16 editor_16",
            click: griddbclick
        },
        {
            id: "delete",
            name: "${ctp:i18n('common.button.delete.label')}",//删除
            className: "ico16 del_16",
            click: function() {
              var v = $("#mytable").formobj({
                    gridFilter : function(data, row) {
                      return $("input:checkbox", row)[0].checked;
                    }
                  });
                if (v.length < 1) {
                  $.alert("${ctp:i18n('level.delete')}");
                } else {
                    $.confirm({
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                          
                          subMapper.deleteSubjectMapper(v, {
                                    success: function() {
                                      $("#mytable").ajaxgridLoad(o);
                                      $("#postform").hide();
                                        $("#button").hide();
                                        $("#welcome").show();
                                        $("#subMapperForm").hide();
                                    }
                                });
                                                  
                        }
                    });
                };
            }
        },{
          id: "excel3", 
          name: "${ctp:i18n('voucher.plugin.cfg.subject.excel.import')}", 
          className: "ico16 import_16", 
          subMenu: [
                      {id: "down3", name: "${ctp:i18n('form.formlist.downinfopath')}", className: "download_16", click: downTemplate},
                      {id: "import3", name: "${ctp:i18n('application.95.label')}", className: "ico16 import_16", click: importSubjectMapper}
                  ]
         }]
    });
  //列表显示
    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,       
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },       
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.a8fexType')}",
            sortable: true,
            name: 'enumName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.account')}",
            sortable: true,
            name: 'accountName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.book')}",
            sortable: true,
            name: 'bookName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.subname')}",
            sortable: true,
            name: 'subjectName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.subcode')}",
            sortable: true,
            name: 'subjectCode',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.subject.debit')}",
            sortable: true,
            name: 'directions',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDate')}",
            sortable: true,
            name: 'updateTime',
            width: '15%'          
        }
        ],
        managerName: "subjectMapperManager",
        managerMethod: "showSubjectMapperList",
        parentId:'center',
        slideToggleBtn: true,
        callBackTotle:getCount,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    //单击
    function gridclk(data, r, c) {
      $("#subMapperForm").disable();
      $("#subMapperForm").show();
      $("#button").hide();
      $("#welcome").hide();
      $("#subMapperForm").clearform({clearHidden:true});
      var subMapperdetil = subMapper.viewSubjectMapper(data.id);
      $("#addForm").fillform(subMapperdetil);
      checkSupportBook();
      mytable.grid.resizeGridUpDown('middle');
    }
  //搜索框
    var searchobj = $.searchCondition({
      top: 7,
      right: 10,
      searchHandler: function() {
        s = searchobj.g.getReturnValue();
        $("#mytable").ajaxgridLoad(s);
      },
      conditions: [{
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.subject.a8fexType')}",
          value: 'costType',
          maxLength:40
        },           
       {
          id: 'search_type',
          name: 'search_type',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.subject.account')}",
          value: 'accountName',
          maxLength:100
        },      
      {
        id: 'search_url',
        name: 'search_url',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.subject.book')}",
        value: 'book',
        maxLength:100
      },
      {
        id: 'search_subname',
          name: 'search_subname',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.subject.subname')}",
          value: 'subname',
          maxLength:100
      },
      {
        id: 'search_subcode',
          name: 'search_subcode',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.subject.subcode')}",
          value: 'subcode',
          maxLength:100
       },       
        {//方向
            id: 'search_debit',
            name: 'search_debit',
            type: 'select',
            text: "${ctp:i18n('voucher.plugin.cfg.subject.debit')}",
            value: 'debit',
            items: [{
                text: "${ctp:i18n('voucher.plugin.cfg.subject.debit.one')}",
                value: '1'
            }, {
                text: "${ctp:i18n('voucher.plugin.cfg.subject.debit.two')}",
                value: '0'
            }]
        },
        {//更新时间查询
          id: 'search_update',
            name: 'search_update',
            type: 'datemulti',
            text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDate')}",
            value: 'updateTime',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
    //双击
    function griddbclick() {
      var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }else if(v.length > 1){
          $.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var subMapperdetil = subMapper.viewSubjectMapper(v[0]["id"]);
            $("#subMapperForm").clearform({clearHidden:true});
          $("#addForm").fillform(subMapperdetil);
          checkSupportBook();
          $("#subMapperForm").enable();
          handleDisable();
          $("#subMapperForm").show();
          $("#button").show();
          $("#welcome").hide();
        }
    }
    //点击取消重新加载页面
  $("#btncancel").click(function() {
      location.reload();
    });        
    //点击确定保存
    $("#btnok").click(function() {
        if(!($("#subMapperForm").validate())){  
          return;
        }
        var flag = true;
        if($("#id").val()!=""){
          var detail = subMapper.viewSubjectMapper($("#id").val());
          var f = detail.bookCode==$("#bookCode").val() || (detail.bookCode==null&&$("#bookCode").val()=="");
          if(detail.accountId==$("#accountId").val()&&detail.enumId==$("#enumId").val()&& f){
            flag = false;
          }
        }
        if(flag){
          var bool = subMapper.checkSubjectMapper({"enumId":$("#enumId").val(),"accountId":$("#accountId").val(),"bookCode":$("#bookCode").val()});
            if(bool==true){
              $.alert("选择的枚举在指定账套和账簿下，已作映射，不能再作映射！");
              return;
            }
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();           
        subMapper.saveSubjectMapper($("#subMapperForm").formobj(), {
            success: function(rel) {
        try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
        if(rel=='yes'){
        location.reload();
        }                                
                
            }
        });                                                                              
    });
    
    //选择第三方账簿页面
    $("#bookName").click(function(){
      var id=$("#accountId").val();
      if(id==""){
        $.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
        return;
      }
      var dialog = $.dialog({
          url:"${path}/voucher/subjectMapperController.do?method=showBookList&accountId="+encodeURIComponent(id),
          width: 800,
          height: 450,
          title: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.selectBook')}",//选择财务系统部门
          buttons: [{
              text: "${ctp:i18n('common.button.ok.label')}",//确定
              handler: function () {
                var rv = dialog.getReturnValue();
                if(rv!=false){
                  var bookName = rv.name;
                  var bookCode = rv.code;
                  var entityName = rv.entityName;                                                   
                        if(bookName!=$("#bookName").val()){
                          $("#bookName").val(bookName);
                          $("#bookCode").val(bookCode);
                          $("#erpUnitName").val(entityName);
                      $("#subjectId").val("");
                            $("#subjectName").val("");
                          $("#subjectCode").val("");
                          $("#directions").val("");
                          $("#direction").val("");
                        }                         
                     }else{
                          return;
                     }
                     dialog.close();
              }
          }, {
              text: "${ctp:i18n('common.button.cancel.label')}", //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
    });
  //选择第三方科目页面
    $("#subjectName").click(function(){
      var id=$("#accountId").val();
      var code=$("#bookCode").val();
      if(id==""){
        $.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
        return;
      }
      if(!baseVoucher.isSupportDataBase({"accountId":$("#accountId").val()})){
          $.alert("该凭证类型暂不支持科目映射！");
          return;
      }
      if(code==""&&checkSupportBook()){
        $.alert("${ctp:i18n('voucher.plugin.cfg.subject.selectSub.bookSelect')}");
        return;
      }
      var dialog = $.dialog({
          url:"${path}/voucher/subjectMapperController.do?method=showSubjectList&accountId="+encodeURIComponent(id)+"&bookCode="+encodeURIComponent(code),
          width: 800,
          height: 450,
          title: "${ctp:i18n('voucher.plugin.cfg.subject.selectSub')}",//选择财务系统科目
          buttons: [{
              text: "${ctp:i18n('common.button.ok.label')}", //确定
              handler: function () {
                var rv = dialog.getReturnValue();
                if(rv!=false){
                  var id = rv.id;
                  var subName = rv.subName;
                  var subCode = rv.subCode;
                  var directions = rv.direction;
                  if(directions=="${ctp:i18n('voucher.plugin.cfg.subject.debit.one')}"){
                    direction=1;
                  }else{
                    direction=0;
                  }
                  $("#subjectId").val(id);
                          $("#subjectName").val(subName);
                        $("#subjectCode").val(subCode);
                        $("#directions").val(directions);
                        $("#direction").val(direction);
                     }else{
                          return;
                     }
                     dialog.close();
              }
          }, {
              text: "${ctp:i18n('common.button.cancel.label')}", //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
    });
    
    //选择账套页面
    $("#accountName").click(function(){
      var dialog = $.dialog({
        url:"${path}/voucher/accountCfgController.do?method=showAccountList",
          width: 800,
          height: 500,
          title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
          buttons: [{
              isEmphasize:true,
              text: "${ctp:i18n('common.button.ok.label')}", //确定
              handler: function () {
                 var rv = dialog.getReturnValue();
                 if(rv!=false){
                   if($("#accountName").val()!=rv.accountName){
                     $("#subjectId").val("");
                           $("#subjectName").val("");
                           $("#subjectCode").val("");
                           $("#directions").val("");
                           $("#direction").val("");
                   }
                   $("#accountName").val(rv.accountName);
                   $("#accountId").val(rv.accountId);
                   checkSupportBook();
                   $("#bookName").val(rv.bookName);
                   $("#bookCode").val(rv.bookCode);
                   $("#erpUnitName").val(rv.entityName);
                   dialog.close();
                 }
              }
          }, {
              text: "${ctp:i18n('common.button.cancel.label')}", //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
    });
    //选择OA费用类型
    $("#enumName").click(function(){
      var dialog = getA8Top().$.dialog({
          url:"${path}/voucher/subjectMapperController.do?method=enumIframe",
            width: 900,
            height: 500,
            title: "${ctp:i18n('voucher.plugin.cfg.subject.selectoacost')}",//选择枚举--费用类型
            buttons: [{
                isEmphasize:true,
                text: "${ctp:i18n('common.button.ok.label')}", //确定
                handler: function () {
                   var rv = dialog.getReturnValue();
                   if(rv!=false){
                     $("#enumId").val(rv.enumId);
                     var enumPath = subMapper.getEnumPath(rv.enumId);
                     $("#enumName").val(rv.enumName);
                     $("#enumPath").val(enumPath);
                     dialog.close();
                   }
                }
            }, {
                text: "${ctp:i18n('common.button.cancel.label')}", //取消
                handler: function () {
                    dialog.close();
                }
            }]
        });
      
    });
    function getCount(){
      $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});
/*
 * 检查所选账套是否支持账簿
 */
function checkSupportBook(){
  var accountId = $("#accountId").val();
  if(accountId==""){
    return;
  }
  var manager = new baseVoucherManager();
  var bool = manager.isSupportBook(accountId);
  if(bool==true){
    $(".book").show();
  }else{
    $(".book").hide();
  }
  return bool;
}
function downTemplate(){
  $("#delIframe").prop("src","${path}/voucher/voucherController.do?method=downTemplate&type=subject");
}
function importSubjectMapper(){
  insertAttachment();
}
function importCallBk(file){
  var subMapper=new subjectMapperManager();
  subMapper.importExcel(file,{
    success : function(data){
      var dialog = getA8Top().$.dialog({
          url:"${path}/voucher/subjectMapperController.do?method=showImportLogList&data="+data,
            width: 600,
            height: 300,
            title: "导入Excel",//导入Excel
            buttons: [{
                text: "${ctp:i18n('common.button.ok.label')}", //确定
                handler: function () {
                  dialog.close();
                  var o = new Object();
              $("#mytable").ajaxgridLoad(o);
                }
            },{
                text: "${ctp:i18n('voucher.plugin.generate.export')}", //导出
                handler: function () {
                  var rv = dialog.getReturnValue();
                  var o = new Object();
              $("#mytable").ajaxgridLoad(o);
              var html = "<form target='DownLogIframe' hidden='hidden' id='downLoad' action='${path}/voucher/voucherController.do?method=downLoadLogs'  method='post'>"+
              "<input type='hidden' id='fileId' name='fileId' value='"+rv+"'></form>";
            var Iframehtml="<iframe name='DownLogIframe' style='display:none;'></iframe>";
            var iframe=$(Iframehtml);
              var form = $(html);
            iframe.appendTo("body");
              form.appendTo("body");
              form.submit();
              
                }
            }]
          });
    }
  });
}
function handleDisable(){
  $("#bookCode").disable();
  $("#erpUnitName").disable();
  $("#subjectCode").disable();
  $("#directions").disable();
  $("#enumPath").disable();
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_subjectMapper'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                  <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                      ${ctp:i18n("voucher.plugin.cfg.subject")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                  ${ctp:i18n("voucher.sub_detail")}
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="subMapperForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="subjectMapperForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="comp" style="display: none;" comp="type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,quantity:1,extensions:'xls,xlsx',maxSize:1024*1024*10,callMethod:'importCallBk',takeOver:false">
    </div>
  <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>