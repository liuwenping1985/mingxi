<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
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
<script type="text/javascript">
var accountId = "${accountId}";
$().ready(function() {
	var superdeptid="";
	var superdeptname="";
    var cnt;
    var msg = '${ctp:i18n("info.totally")}';
    var dManager = new departmentManager();
    $("#depform").hide();
    $("#button").hide();
    $("#welcome").show();
    function addform() {
    	$("#depform").clearform({clearHidden:true});
        $("#depform").enable();
        $("#depform").show();
    	$("#button").show();
    	$("#welcome").hide();
    	$("#lconti").show();
    	$("#conti").attr("checked",'checked'); 
    	$("input[name=enabled]:eq(0)").attr("checked",'checked');
        $("input[name=sortIdtype]:eq(0)").attr("checked",'checked');
        $("input[name=isCreateDeptSpace]:eq(1)").attr("checked",'checked');
        $("#superDepartment").comp({
        	value : superdeptid,
        	text : superdeptname
        	});
        //外部部门
        $("#isInternal").val("false");
        dManager.addOutDept(accountId,
        		{
                    success: function(rel) {
                    	 if(rel == null || rel == undefined){
	                    	 $("#sortId").val(1);
                    	 }else{
                    		 $("#sortId").val(rel["sortId"]);
                    	 }	
                    	 
                    }
        		}
        );

    }
    function clk(e, treeId, node) {
        var deptdetil = dManager.viewDept(node.id);
        $("#addForm").fillform(deptdetil);
        $("input[id=sortIdtype]:eq(0)").attr("checked",'checked'); 
        $("#depform").show();
        $("#welcome").hide();
        $("#button").hide();
        $("#depform").disable();
    }

    $("#toolbar").toolbar({
        borderTop:false,
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('label.create')}",
            className: "ico16",
            click: function() {
            	addform();
                mytable.grid.resizeGridUpDown('middle');
            }
        },
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",
            className: "ico16 editor_16",
            click: griddblclick
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
                    $.alert("${ctp:i18n('post.delete')}");
                    
                } else {
                    $.confirm({
                        'msg': "${ctp:i18n('org.member_form.choose.member.delete')}",
                        ok_fn: function() {
                            dManager.deleteDepts(v, {
                                success: function() {
                                    $("#mytable").ajaxgridLoad(o);
                                }
                            }

                            );
                        }
                    });
                };
            }
        }
        ]
    });
    
    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,
        dblclick:griddblclick,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('org.external.dept.form.name')}",
            sortable: true,
            name: 'name',
            width: '20%'
        },
        {
            display: "${ctp:i18n('org.external.dept.form.code')}",
            sortable: true,
            name: 'code',
            width: '20%'
        },
        {
            display: "${ctp:i18n('common.sort.label')}",
            sortable: true,
            name: 'sortId',
            sortType:'number',
            width: '18%'
        },
        {
            display: "${ctp:i18n('org.external.dept.form.super')}",
            sortable: true,
            name: 'superDepartment',
            width: '15%'
        },
        
        {
            display: "${ctp:i18n('common.state.label')}",
            sortable: true,
            codecfg: "codeId:'common.enabled'",
            name: 'enable',
            width: '15%'
        }],
        managerName: "departmentManager",
        managerMethod: "showDepList4Ext",       
        parentId:'center',
        vChangeParam: {
          overflow: "hidden",
          position: 'relative'
        },
        slideToggleBtn: true,
        vChange: true,
        callBackTotle:getCount
    });
    var o = new Object();
    o.accountId = accountId;
    $("#mytable").ajaxgridLoad(o);
    
    function gridclk(data, r, c) {
        mytable.grid.resizeGridUpDown('middle');
    	$("#welcome").hide();
    	$("#depform").disable();
    	$("#depform").show();  	
    	$("#button").hide();
    	var deptdetil = dManager.viewDept(data.id);
    	$("#addForm").fillform(deptdetil);
    	$("input[id=sortIdtype]:eq(0)").attr("checked",'checked'); 
    }
    function griddblclick(){
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
         	var deptdetil = dManager.viewDept(v[0]["id"]);
			$("#addForm").fillform(deptdetil);
			
         	$("#conti").removeAttr("checked");
         	$("#depform").enable();
         	$("#depform").show();
         	$("#button").show();
         	$("#lconti").hide();
         	$("#welcome").hide();
         	$("input[id=sortIdtype]:eq(0)").attr("checked",'checked'); 
         }
    }
    $("#btncancel").click(function() {
    	location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#addForm").validate())){
            return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();       
        dManager.createDept(accountId, $("#addForm").formobj(), {
            success: function(depBean) {
            	$("#mytable").ajaxgridLoad(o);
            	if($("#conti").attr("checked")=="checked"){
            		superdeptid=$("#superDepartment").val();
            		superdeptname=$("#superDepartment_txt").val();
                	addform();
                }else{   
                	$("#depform").hide();
                	$("#button").hide();
                	$("#welcome").show();
                }
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
            }
        });
    });
    function getCount(){
        cnt = mytable.p.total;
        $("#count").get(0).innerHTML = msg.format(cnt);
    }
});
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false" id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" >
			</table>
			<div id="grid_detail" class="relative">
					<div class="stadic_layout">
					<div class="stadic_layout_head stadic_head_height">
					</div>
					<div class="stadic_layout_body stadic_body_top_bottom">
						<div id="welcome">
							<div class="color_gray margin_l_20">
								<div class="clearfix">
									<h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("org.external.dept.basic.info")}</h2>
									<div class="font_size12 left margin_t_20 margin_l_10">
										<div class="margin_t_10 font_size14">
											<span id="count"></span>
										</div>
									</div>
								</div>
								<div class="line_height160 font_size14">
									${ctp:i18n('organization.detail_info_external')}
								</div>
							</div>
						</div>
						<div id="depform" class="form_area over_hidden">
							<%@ include file="Externaldeptform.jsp"%>
						</div>
					</div>
					<div class="stadic_layout_footer stadic_footer_height">
							<div id="button" align="center" class="page_color button_container stadic_footer_height border_t padding_t_5">
								<label class="margin_r_10 hand" for="radio1" id="lconti"> <input
									id="conti" class="radio_com" value="0" type="checkbox"
									checked="checked"> ${ctp:i18n('continuous.add')}
								</label> <a id="btnok" href="javascript:void(0)"
									class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
								&nbsp; <a id="btncancel" href="javascript:void(0)"
									class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
							</div>
					</div>
					
				</div>
			</div>
		</div>
</body>
</html>