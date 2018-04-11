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
    src="${path}/ajax.do?managerName=accountCfgManager,baseVoucherManager"></script>
<script type="text/javascript">
$().ready(function() {
    var total = '${ctp:i18n("info.totally")}';
    var accountCfg=new accountCfgManager();
    var baseVoucher= new baseVoucherManager();
    $("#welcome").show();
    $("#accountCfgForm").hide();
    $("#button").hide();
    function saveAccountForm(){
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();               
      accountCfg.saveAccountCfg($("#accountCfgForm").formobj(), {
          success: function(rel) {                
              try{getCtpTop().endProc();}catch(e){};
              $("#mytable").ajaxgridLoad(o);
              if(rel=='yes'){
              location.reload();
              }                                
              
          }
      });
    }
    function confirmSave(id){
      var r=accountCfg.getDefaultAccountCfg();
      if(r!=null&&r.id!=id){
          $.messageBox({
                   'type' : 1,
                   'imgType':2,
                    'msg' : "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDefaultAccount')}",
                    ok_fn : function() {
                      saveAccountForm();
                    }});
      }else{
        saveAccountForm();
      }
    }
    function addform(){
        $("#accountCfgForm").clearform({clearHidden:true});
        $("#dbPassword").val("");
        $("#accountCfgForm").enable();
        $("#accountCfgForm").show();
        $("#welcome").hide();
        $("#button").show();
        $("#type").get(0).selectedIndex=0;
        var bool = baseVoucher.isSupportBookWithType({"type":$("#type").val()});
        if(bool==false){
            $("#bookTr").hide();
        }else{
            $("#bookTr").show();
            if($("#isSupportBooks")[0].checked==true){
                $("#bookName1").show();
                $("#bookName2").show();
            }else{
                $("#bookName1").hide();
                $("#bookName2").hide();
            }
        }
        dealWithStyle();
        mytable.grid.resizeGridUpDown('middle');
    }
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",
            className: "ico16",
            click: function() {
                addform();
            }
        },
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",
            className: "ico16 editor_16",
            click: griddbclick
        },
        {
            id: "delete",
            name: "${ctp:i18n('common.button.delete.label')}",
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
                        'msg': "${ctp:i18n('voucher.plugin.cfg.accountCfg.sure.delete')}",
                        ok_fn: function() {
                            var r=accountCfg.isReference(v);                        
                            if(r!=null){
                                $.alert(r.name+"${ctp:i18n('voucher.plugin.cfg.accountCfg.deleteUsed')}");
                            }else{
                                accountCfg.deleteAccountCfg(v, {
                                    success: function() {
                                        $("#mytable").ajaxgridLoad(o);
                                        $("#postform").hide();
                                        $("#button").hide();
                                        $("#welcome").show();
                                        $("#accountCfgForm").hide();
                                    }
                                });
                            }                           
                        }
                    });
                };
            }
        }]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,
        callBackTotle:getCount,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.type')}",
            sortable: true,
            name: 'type',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
            sortable: true,
            name: 'name',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.url')}",
            sortable: true,
            name: 'address',
            width: '20%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}",
            sortable: true,
            name: 'code',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.exSystemCode')}",
            sortable: true,
            name: 'extCode',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.currencyCode')}",
            sortable: true,
            name: 'currencyCode',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDate')}",
            sortable: true,
            name: 'updateTime',
            width: '15%'          
        }
        ],
        managerName: "accountCfgManager",
        managerMethod: "showAccountCfgList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
      }
    function gridclk(data, r, c) {
        $("#accountCfgForm").disable();
        $("#accountCfgForm").show();
        $("#button").hide();
        $("#welcome").hide();
        $("#accountCfgForm").clearform({clearHidden:true});
        var accountdetil = accountCfg.viewAccountCfg(data.id);
        $("#addForm").fillform(accountdetil);
        if(accountdetil.isDefault=='true'){
            $("#isDefault").attr("checked", true);
        }else{
            $("#isDefault").attr("checked", false);
        }
        var bool = baseVoucher.isSupportBookWithType({"type":$("#type").val()});
        if(bool==false){
            $("#bookTr").hide();
        }else{
            $("#bookTr").show();
            if(accountdetil.isSupportBooks=='true'){
                $("#isSupportBooks").attr("checked", true);
				if($("#type").val() == "SAP"){//sap时，默认账簿不显示
					$("#bookName1").hide();
					$("#bookName2").hide();
				}else{
					$("#bookName1").show();
					$("#bookName2").show();
				}
            }else{
                $("#isSupportBooks").attr("checked", false);
                $("#bookName1").hide();
                $("#bookName2").hide();
            }
        }
        dealWithStyle();
        $("#dbPassword").val(accountdetil.dbPassword);
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
          id: 'search_type',
          name: 'search_type',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.type')}",
          value: 'type',
          maxLength:100
        },
      {
        id: 'search_name',
        name: 'search_name',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
        value: 'name',
        maxLength:40
      },
      {
        id: 'search_url',
        name: 'search_url',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.url')}",
        value: 'address',
        maxLength:100
      },
      {
          id: 'search_code',
          name: 'search_code',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}",
          value: 'code',
          maxLength:100
      },
      {
          id: 'search_excode',
          name: 'search_excode',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.exSystemCode')}",
          value: 'extCode',
          maxLength:100
       },
       {
          id: 'search_cucode',
           name: 'search_cucode',
           type: 'input',
           text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.currencyCode')}",
           value: 'currencyCode',
           maxLength:100
        },
        {//更新时间查询
            id: 'search_update',
            name: 'search_update',
            type: 'datemulti',
            text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDate')}",
            value: 'update',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
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
            var accountdetil = accountCfg.viewAccountCfg(v[0]["id"]);
            var r=accountCfg.isReference(v);           
            $("#accountCfgForm").clearform({clearHidden:true});
            $("#addForm").fillform(accountdetil);
            $("#accountCfgForm").enable();
            var bool = baseVoucher.isSupportBookWithType({"type":$("#type").val()});
            if(bool==false){
                $("#bookTr").hide();
            }else{
                $("#bookTr").show();
                if(accountdetil.isSupportBooks=='true'){
                    $("#isSupportBooks").attr("checked", true);
                    $("#isSupportBooks").val(true);
					if($("#type").val() == "SAP"){//sap时，默认账簿不显示
						$("#bookName1").hide();
						$("#bookName2").hide();
					}else{
						$("#bookName1").show();
					    $("#bookName2").show();
					}
                }else{
                    $("#isSupportBooks").attr("checked", false);
                    $("#bookName1").hide();
                    $("#bookName2").hide();
                }
            }
            if(r!=null){
                $("#type").disable();
                $("#dbType").disable();
                $("#dbUrl").disable();
            }
            if(accountdetil.isDefault=='true'){
                $("#isDefault").attr("checked", true);
                $("#isDefault").val(true);
            }else{
                $("#isDefault").attr("checked", false);
            }
            $("#dbPassword").val(accountdetil.dbPassword);
            
            $("#accountCfgForm").show();
            dealWithStyle();
            $("#button").show();
            $("#welcome").hide();
            $("#accountCfgForm").resetValidate();
        }
    }
     $("#isDefault").click(function(){
        if($("#isDefault")[0].checked==true){
            $("#isDefault").val(true);          
        }
        if($("#isDefault")[0].checked==false){
            $("#isDefault").val(false);
        }
    });
     $("#isSupportBooks").click(function(){
        if($("#isSupportBooks")[0].checked==true){
            $("#isSupportBooks").val(true);
        }
        if($("#isSupportBooks")[0].checked==false){
            $("#isSupportBooks").val(false);
        }
        if($("#isSupportBooks")[0].checked==true){
            $("#bookName1").show();
            $("#bookName2").show();
        }else{
            $("#bookName1").hide();
            $("#bookName2").hide();
            $("#bookName").val("");
            $("#bookCode").val("");
            $("#extAttr1").val("");
        }
     });
    

    $("#btncancel").click(function() {
        location.reload();
    });
    function checkDBType(driver,url){
      if ('oracle.jdbc.driver.OracleDriver' === driver) {
        if (url.indexOf('oracle') === -1) {
          $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.mismatching')}");
          return true;
        }
      } else {
        if (url.indexOf('oracle') !== -1) {
          $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.mismatching')}");
          return true;
        }
      }
      return false;
    }
    function checkDBInfo(){
        return accountCfg.checkDBInfo({"id":$("#id").val(),"dbType":$("#dbType").val(),"dbUrl":$("#dbUrl").val(),"dbUser":$("#dbUser").val(),"dbPassword":$("#dbPassword").val()});
    }
    $("#bookName").click(function() {
        var DBOK = checkDBInfo();
        if("1"==DBOK){
            var id=$("#id").val();
            var driver=$("#dbType").val();
            var url=$("#dbUrl").val();
            var user=$("#dbUser").val();
            var pwd=$("#dbPassword").val();
            var dialog = $.dialog({
                url:"${path}/voucher/accountCfgController.do?method=selectDefaultBook&id="+encodeURIComponent(id)+"&driver="+encodeURIComponent(driver)+"&url="+encodeURIComponent(url)+"&user="+encodeURIComponent(user)+"&pwd="+encodeURIComponent(pwd)+"&type="+$("#type").val(),
                width: 800,
                height: 450,
                title: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.selectBook')}",
                buttons: [{
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                        if(rv!=false){
                            var bookName = rv.name;
                            var bookCode = rv.code;
                            var entityName=rv.entityName;
                            $("#bookName").val(bookName);
                            $("#bookCode").val(bookCode);
                            $("#extAttr1").val(entityName);
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
        }else{
            $.error("${ctp:i18n('voucher.plugin.cfg.accountCfg.dbcheck')}");
        }       
    });
    $("#type").change(function(){
        var type = $("#type").val();
        if(type!=""&&type!=null){
            $("#isDefault").attr("checked",false);
            $("#isSupportBooks").attr("checked",false);
            $("#bookName").val("");
            $("#bookCode").val("");
            $("#bookName1").hide();
            $("#bookName2").hide();
            var bool = baseVoucher.isSupportBookWithType({"type":type});
            if(bool==false){
                $("#bookTr").hide();
            }else{
                $("#bookTr").show();
				if(type == "SAP"){//判断添加SAP动作
					$("#isDefault").attr("checked",true);
					$("#isDefault").val(true);
					$("#isSupportBooks").attr("checked",true);
					$("#isSupportBooks").val(true);
					$("#isSupportBooks").attr("disabled","disabled");
				}else{
					$("#isDefault").val(false);
					$("#isSupportBooks").val(false);
					$("#isSupportBooks").attr("disabled",false);
				}
            }
            dealWithStyle();
        }
    });
    $("#dbType").change(function() {
        var v=$("#dbType").val();
        if("net.sourceforge.jtds.jdbc.Driver"==v){
            $("#dbUrl").val("jdbc:jtds:sqlserver://[ip]:1433/[datebase]");
        }else if("oracle.jdbc.driver.OracleDriver"==v){
            $("#dbUrl").val("jdbc:oracle:thin:@[ip]:1521:[SID]");
        }
        $("#bookName").val("");
        $("#bookCode").val("");
        $("#extAttr1").val("");
    });
    $("#dbUser,#dbPassword,#dbUrl").change(function() {
        $("#bookName").val("");
        $("#bookCode").val("");
        $("#extAttr1").val("");
    });
    
    $("#btnok").click(function() {
        if(!($("#accountCfgForm").validate())){ 
          return;
        }
        var id=$("#id").val();
        var nameDup=accountCfg.checkName($("#name").val());
        if(nameDup!=null&&id!=nameDup.id){
            $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.nameDuplicate')}");
            return;
        }
        var accountDup=accountCfg.checkAccount($("#type").val(),$("#address").val(),$("#code").val());
        if(accountDup!=null&&id!=accountDup.id){
            $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.typeCodeDuplicate')}");
            return;
        }
        var isSupportDataBase = baseVoucher.isSupportDataBase({"type":$("#type").val()});
        if(isSupportDataBase){
        	var driver=$("#dbType").val();      
            var url=$("#dbUrl").val();
            if(checkDBType(driver,url)){
              return;
            }
            var DbOK = checkDBInfo();
            if("1"!=DbOK){
                $.error("${ctp:i18n('voucher.plugin.cfg.accountCfg.dbcheck')}");
                return;
              }
        }
        if($("#isDefault")[0].checked==true){           
          confirmSave(id);
        }else{
          saveAccountForm();
        }
                                                                                       
    });
    
    function dealWithStyle(){
    	var isSupportDataBase = baseVoucher.isSupportDataBase({"type":$("#type").val()});
	 	if(isSupportDataBase==true){
	 		$(".databaseTr").show();
	 	}else{
	 		$(".databaseTr").hide();
	 	}
    }
});

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_accountCfg'"></div>
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
                                        ${ctp:i18n("voucher.plugin.cfg.accountCfg")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                    ${ctp:i18n("voucher.account_detail")}
                                </div>
                            </div>
                     </div>           
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="accountCfgForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="accountCfgForm.jsp"%></div>
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
</div>
</body>
</html>