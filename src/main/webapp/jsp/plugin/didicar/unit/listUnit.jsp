<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
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
	.relative{
		overflow-y:hidden;
	}
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=didicarUnitManager"></script>
<script type="text/javascript">
	var type = "${from}"||"dept"; 
	var selectUnitType = "";//选单位部门控件按类型
	var showUnitTitleName = "";//国际化部门单位显示标题头
	if(type == "group"){
		selectUnitType = "Account";
		showUnitTitleName = "${ctp:i18n('org.account_form.name.label')}";
	}else {
		selectUnitType = "Department";
		showUnitTitleName = "${ctp:i18n('org.dept_form.name.label')}";
	}
	var o = {"type":type};
	
	$(document).ready(function (){
	    $("#button").hide();
	    
		var toolbar = $("#toolbar").toolbar({
	        toolbar: [{
	            id: "add",
	            name: "${ctp:i18n('common.toolbar.new.label')}",
	            className: "ico16",
	            click: function() {
	        	    $("#button").show();
	        	    $("#optiontr").hide();
	                $("#unitForm").enable();
	    	    	$("#unitName").enable();
	        	    mfillform({});
	        	    mytable.grid.resizeGridUpDown('middle');
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
	        	     	$.alert("${ctp:i18n('didicar.plugin.unit.choose.only')}");
	        	    } else if (v.length > 1) {
	        	      	$.alert("${ctp:i18n('didicar.plugin.unit.choose.only')}");
	        	    } else {
	                    $.confirm({	
	                        'msg': "${ctp:i18n('common.isdelete.label')}",
	                        ok_fn: function() {
	                        	var ddUnitManager = new didicarUnitManager();
	                        	ddUnitManager.deleteUnits(v[0], {
	                                success: function(data) {
	                                	$("#mytable").ajaxgridLoad(o);
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
	            name: 'id',
	            width: '5%',
	            sortable: false,
	            align: 'center',
	            type: 'checkbox'
	        },
	        {
	        	/*部门(单位)名*/
	            display: showUnitTitleName,
	            sortable: true,
	            name: 'name',
	            width: '20%'
	        },
	        {
	        	/*剩余金额*/
	            display: "${ctp:i18n('didicar.plugin.unit.availableamount')}",
	            sortable: true,
	            name: 'availableAmount',
	            width: '20%'
	        },
	        {
	        	/*已分配总金额*/
	            display: "${ctp:i18n('didicar.plugin.unit.aggregateamount')}",
	            sortable: true,
	            name: 'aggregateAmount',
	            width: '20%'
	        },
	        {
	        	/*管理员*/
	            display: "${ctp:i18n('didicar.plugin.unit.admin')}",
	            sortable: true,
	            name: 'adminNames',
	            width: '18%'
	        },
	        {
	        	/*创建时间*/
	            display: "${ctp:i18n('didicar.plugin.unit.createtime')}",
	            sortable: true,
	            name: 'createTime',
	            width: '15%'
	        }
	        ],
	        managerName: "didicarUnitManager",
	        managerMethod: "showList",
	        parentId:'center',        
	        slideToggleBtn: true,
	        vChange: true       
	    });
	    
	    function griddbclick(){
            $("#unitForm").enable();
	    	$("#unitName").disable();
	    	var v = $("#mytable").formobj({
            	gridFilter : function(data, row) {
             		return $("input:checkbox", row)[0].checked;
            	}
          	});
	    	
	    	if (v.length < 1) {
    	     	$.alert("${ctp:i18n('didicar.plugin.unit.choose.only')}");
    	    } else if (v.length > 1) {
    	      	$.alert("${ctp:i18n('didicar.plugin.unit.choose.only')}");
    	    } else {
    	        $("#button").show();
    	        $("#optiontr").show();
    	        mfillform(v[0]);
    	    	mytable.grid.resizeGridUpDown('middle');
    	    }
	    }
	    
	    function gridclk(data, r, c) {
	    	$("#unitForm").disable();
	        $("#button").hide();
    	    $("#optiontr").hide();
	        mfillform(data);	    	
	        $("#money").val(data.availableAmount||"");
	    	mytable.grid.resizeGridUpDown('middle');
	    }
	    
	    function mfillform(obj){
        	$("#unitForm").clearform({clearHidden:true});
        	$("#recharge").attr("checked","checked");
	    	$("#id").val(selectUnitType+"|"+obj.id);
	    	$("#unitName").val(obj.name||"");
	    }
	    
	    /**
	    * 绑定授权选人事件
	    */
	    function bindChooseUnitEvent() {
	    	var chooseUnitCtr = $("#unitName");
	    	chooseUnitCtr.unbind("click").bind("click",function() {
	    		$.selectPeople({
	    		      type: 'selectPeople',
	    		      panels: selectUnitType,
	    		      selectType: selectUnitType,
	    		      //onlyCurrentDepartment:true,
	    		      onlyLoginAccount:true,
	    		      hiddenRootAccount:true,
	    		      maxSize:1,
	    		      text : $("#unitName").val(),
	    		      params: {value:$("#id").val()},
	    		      callback: function(ret) {
	    		    	 if(ret.text == "集团"){
		    		     	$.alert("${ctp:i18n('didicar.plugin.unit.choose.unable')}");
		    		     	return;
		    		     }
	    		    	 chooseUnitCtr.val(ret.text);
	    		    	 $("#id").val(ret.value);
	    		      }
	    	    });
	    	});
	    }
	    bindChooseUnitEvent();
	    
	    $("#btnok").click(function() {
	    	if($("#addForm").validate()){
	    		var subData = {
	    			type:type,
					option:$("input[name=option]:checked ").val(),
					unitId:$("#id").val(),
					money:$("#money").val(),
					isCreate:$("#optiontr").is(":hidden")//true:新增,false:分配额度
	    		}
	    		var ddUnitManager = new didicarUnitManager();
	    		ddUnitManager.createOrUpdateUnit(subData, {
	                success: function(data) {
    	    			location.reload();
	                }
	            });    
	    	}
	    });
	    $("#btncancel").click(function() {
    	    $("#button").hide();
        	$("#unitForm").clearform({clearHidden:true});
        	$("#recharge").attr("checked","checked");
            mytable.grid.resizeGridUpDown('down');
	    });

	    var errmsg = "${errmsg}";
	    toDisable(errmsg,toolbar);
	});

	function toDisable(errmsg,toolbar){
		if(errmsg!=""){
	    	o.regist = "unregist";//查询列表不显示数据
		    //加载列表
		    $("#mytable").ajaxgridLoad(o);
		    toolbar.disabled("add");
	    	toolbar.disabled("modify");
	    	toolbar.disabled("delete");
	    	$("body").disable();
	    	$("#mytable").disable();
	    	$.alert(errmsg);
	    }else{
		    //加载列表
		    $("#mytable").ajaxgridLoad(o);
	    }
	}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_didi_use_money_${param.from}'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center"> 
    	<table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
    	<div id="grid_detail" style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="unitForm" class="form_area" style="overflow-y:hidden;">
                    	<%@include file="unitForm.jsp"%></div>
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