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
	src="${path}/ajax.do?managerName=deptMapperManager,accountCfgManager"></script>
<script type="text/javascript">
$().ready(function() {
	var total = '${ctp:i18n("info.totally")}';
	var deptMapper=new deptMapperManager();
	$("#welcome").show();
    $("#deptMapperForm").hide();
    $("#button").hide();
    function addform(){
    	$("#deptMapperForm").clearform({clearHidden:true}); 
    	$("#orgDepartmentId").comp({
            value: "",
            text: ""
          });
        $("#deptMapperForm").enable();
        $("#welcome").hide();
        $("#deptMapperForm").show();
        $("#orgDepartmentCode,#erpDeptCode,#unitName,#erpUnitName").disable();
        $("#button").show();
        var cfgManager=new accountCfgManager();
        var accountBean = cfgManager.getDefaultAccountCfg();
        if(accountBean!=null){
        	$("#accountId").val(accountBean.id);
        	$("#accountName").val(accountBean.name);
        	var excludeDepts = deptMapper.getExcludeDepts(accountBean.id);
      	   	$("#orgDepartmentId").comp({
      	        excludeElements: excludeDepts.ids
      	    });
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
                        	
                        		deptMapper.deleteDeptMapper(v, {
                                    success: function() {
                                    	$("#mytable").ajaxgridLoad(o);
                                    	$("#postform").hide();
                                        $("#button").hide();
                                        $("#welcome").show();
                                        $("#deptMapperForm").hide();
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
            click: importDeptByAuto
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
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
            sortable: true,
            name: 'accountName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.deptmapper.oadocname')}",
            sortable: true,
            name: 'unitName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.deptmapper.oadeptName')}",
            sortable: true,
            name: 'deptName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdocname')}",
            sortable: true,
            name: 'erpUnitName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptname')}",
            sortable: true,
            name: 'erpDeptName',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptcode')}",
            sortable: true,
            name: 'erpDeptCode',
            width: '15%'          
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.accountCfg.updateDate')}",
            sortable: true,
            name: 'updateTime',
            width: '15%'          
        }
        ],
        managerName: "deptMapperManager",
        managerMethod: "showDeptMapperList",
        parentId:'center',
        callBackTotle:getCount,
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    //单击
    function gridclk(data, r, c) {
    	$("#deptMapperForm").disable();
    	$("#deptMapperForm").show();
    	$("#button").hide();
    	$("#welcome").hide();
    	$("#deptMapperForm").clearform({clearHidden:true});
    	var deptMapperdetil = deptMapper.viewDeptMapper(data.id);
    	$("#addForm").fillform(deptMapperdetil);
    	$("#orgDepartmentId").comp({
            value: deptMapperdetil.orgDepartmentId,
            text: deptMapperdetil.deptName
          });
    	mytable.grid.resizeGridUpDown('middle');
    }
  //搜索框
    var searchobj = $.searchCondition({
      top: 2,
      right: 10,
      searchHandler: function() {
        s = searchobj.g.getReturnValue();
        $("#mytable").ajaxgridLoad(s);       
      },
      conditions: [{
          id: 'search_type',
          name: 'search_type',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}",
          value: 'accountName',
          maxLength:100
        },
      {
        id: 'search_name',
        name: 'search_name',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.deptmapper.oadocname')}",
        value: 'unitName',
        maxLength:40
      },
      {
        id: 'search_url',
        name: 'search_url',
        type: 'input',
        text: "${ctp:i18n('voucher.plugin.cfg.deptmapper.oadeptName')}",
        value: 'deptName',
        maxLength:100
      },
      {
    	  id: 'search_code',
          name: 'search_code',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdocname')}",
          value: 'erpUnitName',
          maxLength:100
      },
      {
    	  id: 'search_excode',
          name: 'search_excode',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptname')}",
          value: 'erpDeptName',
          maxLength:100
       },
       {
     	  id: 'search_cucode',
           name: 'search_cucode',
           type: 'input',
           text: "${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptcode')}",
           value: 'erpDeptCode',
           maxLength:100
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
            var deptMapperdetil = deptMapper.viewDeptMapper(v[0]["id"]);
            $("#deptMapperForm").clearform({clearHidden:true});            
        	$("#addForm").fillform(deptMapperdetil);
        	$("#orgDepartmentId").comp({
                value: deptMapperdetil.orgDepartmentId,
                text: deptMapperdetil.deptName
              });
        	var excludeDepts = deptMapper.getExcludeDepts(deptMapperdetil.accountId);
     	   	$("#orgDepartmentId").comp({
     	        excludeElements: excludeDepts.ids
     	    });
        	$("#deptMapperForm").enable();
        	$("#deptMapperForm").show();       	
        	$("#orgDepartmentCode").attr("disabled", "disabled");
        	$("#erpDeptCode").attr("disabled", "disabled");
        	$("#unitName").attr("disabled", "disabled");
        	$("#erpUnitName").attr("disabled", "disabled");
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
        if(!($("#deptMapperForm").validate())){	
          return;
        }
        var accountId=$("#accountId").val();
        var deptId=$("#orgDepartmentId").val();
        var id=$("#id").val();
        var flag=deptMapper.checkDeptMapper(accountId,deptId);
        if(flag!=null&&flag.id!=id){
        	$.alert("${ctp:i18n('voucher.plugin.cfg.deptmapper.deptDup')}");
        	return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();		       
        deptMapper.saveDeptMapper($("#deptMapperForm").formobj(), {
            success: function(rel) {            	
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
				if(rel=='yes'){
				location.reload();
				}                                
                
            }
        });        				                                                               
    });
    
  //选择第三方部门页面
    $("#erpDeptName").click(function(){
    	var id=$("#accountId").val();
    	if(id==""){
    		$.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
    		return;
    	}
    	var dialog = getCtpTop().$.dialog({
    			url:"${path}/voucher/deptMapperController.do?method=showERPDeptTree&accountId="+encodeURIComponent(id),
			    width: 400,
			    height: 500,
			    title: "${ctp:i18n('voucher.plugin.cfg.deptmapper.selecterpdept')}",//选择财务系统部门
			    buttons: [{
			        text: "${ctp:i18n('common.button.ok.label')}", //确定
			        handler: function () {
			           var rv = dialog.getReturnValue();			           
			           if(rv!=false&&rv!=null){
			        	$("#erpDeptId").val(rv.erpDeptId);
			        	$("#erpDeptName").val(rv.erpDeptName);
			        	$("#erpDeptCode").val(rv.erpDeptCode);
			        	$("#erpUnitName").val(rv.erpDeptUnit);
			           	dialog.close();
			           }else if(rv==null){
			        	   dialog.close();
			           }else{
			        	   $.alert("${ctp:i18n('voucher.plugin.cfg.deptmapper.unitselect')}");
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
  	
  	
    //选择账套页面
    $("#accountName").click(function(){
    	var dialog = $.dialog({
    		url:"${path}/voucher/accountCfgController.do?method=showAccountList",
			    width: 800,
			    height: 500,
			    title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
			    buttons: [{
			        text: "${ctp:i18n('common.button.ok.label')}", //确定
			        handler: function () {
			           var rv = dialog.getReturnValue();
			           if(rv!=false){
			        		if($("#accountName").val()!=rv.accountName){
			        			$("#erpDeptId").val("");
					        	$("#erpDeptName").val("");
					        	$("#erpDeptCode").val("");
					        	$("#erpUnitName").val("");
			        		}
			        	   $("#accountName").val(rv.accountName);
			        	   $("#accountId").val(rv.accountId);
			        	   var excludeDepts = deptMapper.getExcludeDepts(rv.accountId);
			         	   	$("#orgDepartmentId").comp({
			         	        excludeElements: excludeDepts.ids
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
    function importDeptByAuto(){
    	var dialog = getCtpTop().$.dialog({
    		url:"${path}/voucher/deptMapperController.do?method=importDeptByAuto",
    	    width: 400,
    	    height: 200,
    	    title: "${ctp:i18n('voucher.plugin.cfg.automatch')}",
    	    buttons: [{
    	        text: "${ctp:i18n('common.button.ok.label')}", //确定
    	        handler: function () {
    	           var rv = dialog.getReturnValue();
    	           if(rv!=false){
    	        	   dialog.close();
    	        	   deptMapper.importDeptByAuto(rv,{
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
    function getCount(){
    	$("#count")[0].innerHTML = total.format(mytable.p.total);
  	}
});
//选部门信息处理
function deptCallBack(ret) {
    	var deptMapper=new deptMapperManager();
    	var dept=deptMapper.selectDept(ret.value);    	
    	$("#addForm").fillform(dept);
    	$("#orgDepartmentId").comp({
            value: dept.orgDepartmentId,
            text: dept.deptName
          });
      	mytable.grid.resizeGridUpDown('middle');
      }

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_deptMapper'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
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
                                    	${ctp:i18n("voucher.plugin.cfg.deptmapper")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                	${ctp:i18n("voucher.dept_detail")}
                                </div>
                            </div>
                     </div>           
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="deptMapperForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="deptMapperForm.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
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