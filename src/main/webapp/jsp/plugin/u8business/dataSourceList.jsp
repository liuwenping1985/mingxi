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
	src="${path}/ajax.do?managerName=u8DataSourceManager"></script>
<script type="text/javascript">
$().ready(function() {
	var u8DataSource=new u8DataSourceManager();
	function addform(){
    	$("#myForm").clearform({clearHidden:true});
    	$("#db").val(1);
    	$("#dbType").val("net.sourceforge.jtds.jdbc.Driver");
    	$("#dbUrl").val("jdbc:jtds:sqlserver://[ip]:1433/[datebase]");
    	$("#dbPassword").val("");
        $("#myForm").enable();
        $("#myForm").show();
        $("#button").show();
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
                        'msg': "${ctp:i18n('u8business.datasource.delconfirm')}",
                        ok_fn: function() {                        	                    	                        	
                        	u8DataSource.deleteDataSource(v, {
                                    success: function() {
                                    	$("#mytable").ajaxgridLoad(o);
                                    	$("#myForm").hide();
                                        $("#button").hide();         
                                    }
                                });
                        	                      	
                        }
                    });
                };
            }
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
            display: "${ctp:i18n('u8business.datasource.accountcode')}",
            sortable: true,
            name: 'accountCode',
            width: '25%'
        },
        {
            display: "${ctp:i18n('u8business.datasource.url')}",
            sortable: true,
            name: 'dbUrl',
            width: '30%'
        },
        {
            display: "${ctp:i18n('u8business.datasource.user')}",
            sortable: true,
            name: 'dbUser',
            width: '20%'
        },
        {
            display: "${ctp:i18n('u8business.datasource.updatetime')}",
            sortable: true,
            name: 'updateTime',
            width: '20%'
        }
        ],
        managerName: "u8DataSourceManager",
        managerMethod: "showDataSourceList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    function gridclk(data, r, c) {
    	$("#myForm").disable();
    	$("#myForm").show();
    	$("#button").hide();
    	$("#myForm").clearform({clearHidden:true});
    	var detil = u8DataSource.viewDataSource(data.id);
    	$("#addForm").fillform(detil);
    	$("#db").val(1);
    	$("#dbPassword").val(detil.dbPassword);
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
        	$.alert("${ctp:i18n('u8business.datasource.mustone')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var detil = u8DataSource.viewDataSource(v[0]["id"]);         
            $("#myForm").clearform({clearHidden:true});
        	$("#addForm").fillform(detil);
        	$("#db").val(1);
        	$("#dbPassword").val(detil.dbPassword);
        	$("#myForm").enable();
        	$("#myForm").show();
            $("#button").show();
            $("#myForm").resetValidate();
        }
    }    
    $("#btncheak").click(function() {
    	if(!($("#dbType,#dbUrl,#dbUser,#dbPassword").validate())){
            return;
          }
    	var id=$("#id").val();
    	var drive=$("#dbType").val();
    	var url=$("#dbUrl").val();
    	var user=$("#dbUser").val();
    	var pwd=$("#dbPassword").val();
    	var r=u8DataSource.checkDBInfo(id,drive,url,user,pwd);
    	if(r=="1"){
    		$.infor("${ctp:i18n('u8business.datasource.dbcheck.ok')}");
    	}else{
    		$.error("${ctp:i18n('u8business.datasource.dbcheck.fail')}");
    	}
    });  
    $("#btnok").click(function() {
    	if(!($("#myForm").validate())){
            return;
          }
    	var id=$("#id").val();
    	var code=$("#accountCode").val();
    	var o=u8DataSource.checkAccountCode(code);
    	if(o!=null&&id!=o.id){
    		$.alert("${ctp:i18n('u8business.datasource.codedep')}");
    		return;
    	}else{
    		saveDataSource();
    	}    	
    });
    function saveDataSource(){
    	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();               
        u8DataSource.saveDataSource($("#myForm").formobj(), {
            success: function(rel) {
                try{getCtpTop().endProc();}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                if(rel=='yes'){
                location.reload();
                }              
            }
        });
    }
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_u8business_dateSourceCFG'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div id="myForm" class="stadic_layout" style="display: none;">
                <div class="stadic_layout_head stadic_head_height">                
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div class="form_area" style="overflow-y:hidden">
                        <%@include file="dataSourceForm.jsp"%>
                    </div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btncheak" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('u8business.datasource.btn.check')}</a>
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('u8business.datasource.btn.ok')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>