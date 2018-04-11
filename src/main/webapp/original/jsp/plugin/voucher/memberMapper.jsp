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
    src="${path}/ajax.do?managerName=memberMapperManager,accountCfgManager,baseVoucherManager"></script>
<script type="text/javascript">
$().ready(function() {
    var total = '${ctp:i18n("info.totally")}';
    var mManager=new memberMapperManager(); 
    var baseVoucher = new baseVoucherManager();
    $("#memberMapperForm").hide();    
    $("#button").hide();
    function addform(){
        $("#memberMapperForm").clearform({clearHidden:true});
        $("#orgMemberId").comp({
            value: "",
            text: ""
          });
        $("#memberMapperForm").enable();
        $("#memberMapperForm").show();
        $("#welcome").hide();
        $("#memberCode,#erpPersonCode,#deptName,#erpDeptName,#unitName,#erpUnitName").disable();
        $("#button").show();
        var cfgManager=new accountCfgManager();
        var accountBean = cfgManager.getDefaultAccountCfg();
        if(accountBean!=null){
            $("#accountId").val(accountBean.id);
            $("#accountName").val(accountBean.name);
           var excludeMembers = mManager.getExcludeMembers(accountBean.id);
           $("#orgMemberId").comp({
                excludeElements: excludeMembers.ids
              });
        }
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
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                            var mManager = new memberMapperManager();
                            mManager.deleteMemberMappers(v, {
                                success: function() {
                                    $("#mytable").ajaxgridLoad(o);
                                    $("#memberMapperForm").hide();
                                    $("#button").hide();
                                    $("#welcome").show();
                                }
                            });
                        }
                    });
                };
            }
        },
        {
            id: "auto",
            name: "${ctp:i18n('voucher.plugin.cfg.automatch')}",
            className: "ico16 import_16",
            click: importMemberByAuto
        }]
    });

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
            /*账套*/
            display: "${ctp:i18n('voucher.plugin.cfg.accountname.label')}",
            sortable: true,
            name: 'accountName',
            width: '10%'
        },
        {
            /*单位名称*/
            display: "${ctp:i18n('voucher.plugin.cfg.unit.label')}",
            sortable: true,
            name: 'unitName',
            width: '15%'
        },
        {
            /*部门名称*/
            display: "${ctp:i18n('voucher.plugin.cfg.dept.label')}",
            sortable: true,
            name: 'deptName',
            width: '15%'
        },
        {
            /*员工姓名*/
            display: "${ctp:i18n('voucher.plugin.cfg.staffname.label')}",
            sortable: true,
            name: 'memberName',
            width: '10%'          
        },
        /* 财务系统员工部门 */
        {
            display: "${ctp:i18n('voucher.plugin.cfg.erpdept.label')}",
            sortable: true,
            name: 'erpDeptName',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}",
            sortable: true,
            name: 'erpPersonName',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.updatetime.label')}",
            sortable: true,
            name: 'updateTime',
            width: '15%'          
        }
        ],
        managerName: "memberMapperManager",
        managerMethod: "showMemberMappers",
        parentId:'center',        
        slideToggleBtn: true,
        callBackTotle:getCount,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 7,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'search_accountName',
          name: 'search_accountName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.accountname.label')}",
          value: 'accountName'
        },{
          id: 'search_unitName',
          name: 'search_unitName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.unit.label')}",
          value: 'unitName'
        },{
          id: 'search_deptName',
          name: 'search_deptName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.dept.label')}",
          value: 'deptName'
        },{
          id: 'search_memberName',
          name: 'search_memberName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.staffname.label')}",
          value: 'memberName'
        },{
          id: 'search_erpDeptName',
          name: 'search_erpDeptName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.erpdept.label')}",
          value: 'erpDeptName'
        },{
          id: 'search_erpPersonName',
          name: 'search_erpPersonName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}",
          value: 'erpPersonName'
        },{
          id: 'search_updateTime',
          name: 'search_updateTime',
          type: 'datemulti',
          text: "${ctp:i18n('voucher.plugin.cfg.updatetime.label')}",
          value: 'updateTime',
          ifFormat:'%Y-%m-%d',
          dateTime: false
        }]
        
      });
    function gridclk(data, r, c) {
        $("#memberMapperForm").disable();
        $("#memberMapperForm").show();
        $("#button").hide();
        $("#welcome").hide();
        var postdetil = mManager.viewMemberMapper(data.id);
        $("#addForm").fillform(postdetil);
        $("#orgMemberId").comp({
            value: postdetil.orgMemberId,
            text: postdetil.memberName
          });
        mytable.grid.resizeGridUpDown('middle');
    }
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
            var mpostdetil = mManager.viewMemberMapper(v[0]["id"]);
            $("#memberMapperForm").clearform({clearHidden:true});
            $("#addForm").fillform(mpostdetil);
            $("#orgMemberId").comp({
                value: mpostdetil.orgMemberId,
                text: mpostdetil.memberName
              });
            $("#memberMapperForm").enable();
            $("#memberCode,#erpPersonCode,#deptName,#erpDeptName,#unitName,#erpUnitName").disable();
            $("#memberMapperForm").show();
           var excludeMembers = mManager.getExcludeMembers(mpostdetil.accountId);
           $("#orgMemberId").comp({
                excludeElements: excludeMembers.ids
              });
            $("#button").show();
            $("#welcome").hide();
        }
    }
    
    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {  
        if(!($("#memberMapperForm").validate())){       
          return;
        }
        var postdetil = mManager.getMemberInfo($("#orgMemberId").val());
        if($("#id").val()!=""){
            var mapper = mManager.viewMemberMapper($("#id").val());
            if(mapper.accountId!=$("#accountId").val()||mapper.orgMemberId!=$("#orgMemberId").val()){
                var flag = mManager.checkMemberMapper($("#accountId").val(),$("#orgMemberId").val());
                if(flag){
                    $.alert("${ctp:i18n('voucher.plugin.cfg.accountname.label')}"+$("#accountName").val()+"${ctp:i18n('voucher.plugin.cfg.xiamember.error')}  "+postdetil.memberName+"  ${ctp:i18n('voucher.plugin.cfg.mapped.error')}");
                    return;
                }
            }
        }else{
            var flag = mManager.checkMemberMapper($("#accountId").val(),$("#orgMemberId").val());
            if(flag){
                $.alert("${ctp:i18n('voucher.plugin.cfg.accountname.label')}"+$("#accountName").val()+"${ctp:i18n('voucher.plugin.cfg.xiamember.error')}  "+postdetil.memberName+"  ${ctp:i18n('voucher.plugin.cfg.mapped.error')}");
                return;
            }
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        mManager.saveMemberMapper($("#addForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                //if(rel=='${ctp:i18n("nc.org.user.editsuccess")}'||rel=='${ctp:i18n("nc.user.mapper.success")}'){
                location.reload();                
            }
        });                                                                                    
    });
    
    $("#erpPersonName").click(function(){
        if($("#accountId").val()==""){
            $.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
            return;
        }
        if(!baseVoucher.isSupportDataBase({"accountId":$("#accountId").val()})){
        	$.alert("该凭证类型暂不支持人员映射！");
            return;
        }
        var dialog = getA8Top().$.dialog({
            url:"${path}/voucher/memberMapperController.do?method=showErpPersonList&accountId="+$("#accountId").val(),
                width: 800,
                height: 500,
                title: "${ctp:i18n('voucher.plugin.cfg.chose.erpperson')}",//选择财务人员
                buttons: [{
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           $("#addForm").fillform(rv);
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
                           //$("#addForm").fillform(rv);
                           if($("#accountId").val()!=rv.accountId){
                               $("#erpPersonName").val("");
                               $("#erpPersonCode").val("");
                               $("#erpDeptName").val("");
                               $("#erpUnitName").val("");
                           }
                           $("#accountName").val(rv.accountName);
                           $("#accountId").val(rv.accountId);
                           mManager = new memberMapperManager();
                           var excludeMembers = mManager.getExcludeMembers(rv.accountId);
                           $("#orgMemberId").comp({
                                excludeElements: excludeMembers.ids
                              });
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
function memberCallBack(s){
    var mManager=new memberMapperManager(); 
    var postdetil = mManager.getMemberInfo(s.value);
    $("#addForm").fillform(postdetil);
    $("#orgMemberId").comp({text:postdetil.memberName});
}
function importMemberByAuto(){
    var dialog = getCtpTop().$.dialog({
        url:"${path}/voucher/memberMapperController.do?method=importMemberByAuto",
        width: 400,
        height: 200,
        title: "${ctp:i18n('voucher.plugin.cfg.automatch')}",
        buttons: [{
            text: "${ctp:i18n('common.button.ok.label')}", //确定
            isEmphasize:true,
            handler: function () {
               var rv = dialog.getReturnValue();
               if(rv!=false){
                   dialog.close();
                   var mManager=new memberMapperManager();
                   mManager.importMemberByAuto(rv,{
                       success : function(rel){
                           $.infor(rel);
                           //加载列表
                           var o = new Object();
                           $("#mytable").ajaxgridLoad(o);
                       }
                   });
               }
            }
        }, {
            text: "${ctp:i18n('common.button.cancel.label')}", //取消
            handler: function () {
                dialog.close();
            }
        }]
    });
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_memberMapper'"></div>
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
                                        ${ctp:i18n("voucher.plugin.cfg.membermapper")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                    ${ctp:i18n("voucher.member_detail")}
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="memberMapperForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="memberMapperForm.jsp"%></div>
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