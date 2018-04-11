<%@page import="com.seeyon.ctp.organization.OrgConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
	.stadic_body_top_bottom{
                top: 0px;
            }
</style>
<title>${ctp:i18n('cip.intenet.set.init')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipSynSchemeManager,registerManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var schemeManager = new cipSynSchemeManager();
	$("#schemeInitForm").hide();
    $("#button").hide();
    var schemes = schemeManager.getAllSchemeList();
    var html = "";
    var schemeEle = document.getElementById('schemeId');
    for(i=0; i<schemes.length; i++){
    	schemeEle.add(createOption(schemes[i].id,schemes[i].name,schemes[i].extAttr1));
    }
	$("#entityTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick : clk,
	    asyncParam : {
	      },
	    managerName: "cipSynSchemeManager",
	    managerMethod: "showEntityTree",	    
	    nodeHandler: function(n) {
	    	if(n.data.id=='<%=OrgConstants.GROUPID%>'){
	    		n.open = true;
	    	}else{
	    		n.open = false;
	    	}
	    }
	  });
	$("#entityTree").treeObj().reAsyncChildNodes(null, "refresh");
	function clk(e, treeId, node) {
		//加载列表
	    var o = new Object();
		o.entityid=node.data.id;
		$("#nodeid").val(node.data.id);
	    $("#mytable").ajaxgridLoad(o);
	    mytable.grid.resizeGridUpDown('down');
	}
	//列表显示
    var mytable = $("#mytable").ajaxgrid({
    	click: gridclk,       
        dblclick:griddbclick,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.init.sync')}",
            sortable: true,
            name: 'schemeName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.init.sys')}",
            sortable: true,
            name: 'entityName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.init.thirdsys')}",
            sortable: true,
            name: 'thirdOrgname',
            width: '25%'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.init.third')}",
            sortable: true,
            name: 'thirdSystem',
            width: '15%'
        }],
        width: "auto",
        managerName: "cipSynSchemeManager",
        managerMethod: "showSchemeInits",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true        
    });
  //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('down');
	
    $("#toolbar").toolbar({
        toolbar: [{id: "add",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",click: function() {addform();}},
        		  {id: "modify",name: "${ctp:i18n('common.button.modify.label')}",className: "ico16 editor_16",click: griddbclick},
        		  {id: "delete",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",
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
			                        'msg': "${ctp:i18n('cip.org.sync.record.delete.ok')}",
			                        ok_fn: function() {
			                             schemeManager.deleteSchemeInits(v, {
			                                 success: function() {
			                                     $("#mytable").ajaxgridLoad(o);
			                                     $("#button").hide();
			                                     $("#schemeInitForm").hide();
			                                 }
			                             });
			                        }
			                    });
			                };
			            }
        		}]
    });
	
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
          text: "${ctp:i18n('cip.scheme.param.init.sync')}",
          value: 'schemeName',
          maxLength:100
        },
      {
        id: 'search_entity',
        name: 'search_entity',
        text: "${ctp:i18n('cip.scheme.param.init.sys')}",
        type: 'selectPeople',
        comp:"type:'selectPeople',mode:'open',panels:'Account,Department',selectType:'Account,Department',maxSize:'1',returnValueNeedType:false",
        value: 'entityId'
      },
      {
          id: 'search_third',
          name: 'search_third',
          type: 'input',
          text: "${ctp:i18n('cip.scheme.param.init.thirdsys')}",
          value: 'thirdOrgname',
          maxLength:255
      }]
    });
  
    function addform(){
        $("#schemeInitForm").clearform({clearHidden:true});
        $("#schemeInitForm").enable();
        $("#schemeInitForm").show();
        $("#button").show();
        $("input[name='scope']").attr("checked","checked");
        showRegisterSystemInfo();
        if($("#nodeid").val()!=''){
        	var entityInfo = schemeManager.getEntityInfo($("#nodeid").val());
        	$("#entityId").comp({
                value: entityInfo.id,
                text: entityInfo.name
              });
        }
        $("#defOwner").val("${ctp:i18n('cip.scheme.param.init.under')}");
        $("#increortotal").val(1);
        $("#defOwner").attr("disabled","disabled");
        $("#filter_config").unbind("click").bind("click",filterClick);
        mytable.grid.resizeGridUpDown('middle');
    }
    
    function gridclk(data, r, c) {
    	var schemedetil = schemeManager.viewSchemeInit(data.id);
        $("#schemeInitForm").disable();
        $("#schemeInitForm").show();
        $("#button").hide();
        $("#schemeInitForm").clearform({clearHidden:true});
        $("#addForm").fillform(schemedetil);
        var scope;
		if(schemedetil != null){
			scope = $.parseJSON(schemedetil.scope);
		}
		if(scope != null){
			if(scope.department==1){
				$("#department").attr("checked","checked");
			}
			if(scope.people==1){
				$("#people").attr("checked","checked");
			}
			if(scope.post==1){
				$("#post").attr("checked","checked");
			}
			if(scope.level==1){
				$("#level").attr("checked","checked");
			}
			if(schemedetil.isFilter==1){
				$("#isFilter").attr("checked","checked");
			}
			if(schemedetil.increortotal){
				$("#increortotal").val(1);
			}else{
				$("#increortotal").val(0);
			}
			$("#entityId").comp({
                value: schemedetil.entityId,
                text: schemedetil.entityName
              });
		}else{
			$("#increortotal").val(0);
		}
        
        showRegisterSystemInfo();
       
        $("#filter_config").unbind("click");
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
            var schemedetil = schemeManager.viewSchemeInit(v[0]["id"]);
            mytable.grid.resizeGridUpDown('middle');
            //var r=schemeManager.isReference(v);           
            $("#schemeInitForm").clearform({clearHidden:true});
            $("#addForm").fillform(schemedetil);
			var scope;
			if(schemedetil != null){
				scope = $.parseJSON(schemedetil.scope);
				$("#entityId_2").val(schemedetil.entityId);
			}
            if(scope != null){
				if(scope.department==1){
					$("#department").attr("checked","checked");
				}
				if(scope.people==1){
					$("#people").attr("checked","checked");
				}
				if(scope.post==1){
					$("#post").attr("checked","checked");
				}
				if(scope.level==1){
					$("#level").attr("checked","checked");
				}
				if(schemedetil.isFilter==1){
					$("#isFilter").attr("checked","checked");
				}
				if(schemedetil.increortotal){
					$("#increortotal").val(1);
				}else{
					$("#increortotal").val(0);
				}
				$("#entityId").comp({
					value: schemedetil.entityId,
					text: schemedetil.entityName
				  });
			}else{
				$("#increortotal").val(0);
			}
          
            showRegisterSystemInfo();
            $("#schemeInitForm").enable();
            $("#schemeInitForm").show();
            $("#button").show();
            $("#defOwner").attr("disabled","disabled");
            $("#filter_config").unbind("click").bind("click",filterClick);
            $("#schemeInitForm").resetValidate();
        }
    }
    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#schemeInitForm").validate())){ 
          return;
        }
        if($("#thirdOrgid").val()==''){
    		$.alert("${ctp:i18n('cip.scheme.param.init.thirdorg')}");
    		return;
    	}
        if($("#people").attr("checked")=="checked" && $("#department").attr("checked")==undefined){
        	$.alert("${ctp:i18n('cip.scheme.param.init.peoplecheck')}");
        	return;
        }
        if($("#people").attr("checked")==undefined && $("#department").attr("checked")==undefined && $("#post").attr("checked")==undefined && $("#level").attr("checked")==undefined){
        	$.alert("${ctp:i18n('cip.scheme.param.init.synchronization')}");
        	return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        schemeManager.saveSchemeInit($("#schemeInitForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                location.reload();                
            }
        }); 
    });
    $("#schemeId").change(function(){
    	$("#thirdOrgname").val("");
    	$("#thirdOrgid").val("");
    	showRegisterSystemInfo();
    });
    $("#thirdOrgname").click(function(){
    	$("#schemeInitForm").resetValidate();
        var schemeId=$("#schemeId").val();
        var entityId = $("#entityId").val();
        if(schemeId=="" || schemeId==null || entityId==""){
            $.alert("${ctp:i18n('cip.scheme.param.init.thirdorg2')}");
            return;
        }
        var dialog = getCtpTop().$.dialog({
                url:"${path}/cip/org/synOrgController.do?method=showErpUnitTree&schemeId="+encodeURIComponent(schemeId)+"&entityId="+encodeURIComponent(entityId)+"&id="+$("#id").val(),
                width: 400,
                height: 500,
                title: "${ctp:i18n('cip.scheme.param.init.thirdorg3')}",//选择财务系统部门
                buttons: [{
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    isEmphasize: true,
                    handler: function () {
                       var rv = dialog.getReturnValue();                       
                       if(rv!=false&&rv!=null){
                        $("#thirdOrgid").val(rv.thirdOrgid);
                        $("#thirdOrgname").val(rv.thirdOrgname);
                        $("#extAttr1").val(rv.thirdType);
                        dialog.close();
                       }else if(rv==null){
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
});

function filterClick(){
	var thirdOrgid=$("#thirdOrgid").val();
    if(thirdOrgid==""){
        $.alert("${ctp:i18n('cip.scheme.param.init.thirdorg')}");
        return;
    }
    var schemeInitId = $("#id").val();
    var filterJson = $("#filterJson").val();
    if(filterJson!=''){
    	schemeInitId ='';
    }
    var schemeId=$("#schemeId").val();
    var thirdType = $("#extAttr1").val();
    var dialog = getCtpTop().$.dialog({
        url:"${path}/cip/org/synOrgController.do?method=filterConfig&schemeId="+encodeURIComponent(schemeId)+"&thirdOrgid="+encodeURIComponent(thirdOrgid)+"&thirdType="+encodeURIComponent(thirdType)+"&schemeInitId="+schemeInitId,
        width: 900,
        height: 400,
        id:'filterConfig',
        title: "${ctp:i18n('cip.scheme.param.init.syncconfig')}",//同步过滤设置
        transParams:{filterJson:filterJson},
        buttons: [{
            text: "${ctp:i18n('common.button.ok.label')}", //确定
            isEmphasize: true,
            handler: function () {
               var rv = dialog.getReturnValue();  
               $("#filterJson").val(JSON.stringify(rv));
               dialog.close();
            }
        }, {
            text: "${ctp:i18n('common.button.cancel.label')}", //取消
            handler: function () {
                dialog.close();
            }
        }]
	});
}
//选部门信息处理
function entityCallBack(ret) {
	$("#schemeInitForm").resetValidate();
    if(ret.value!=$("#entityId_2").val()){
        $("#thirdOrgname").val("");
        $("#thirdOrgid").val("");
    }
    $("#entityId_2").val(ret.value)
}
function showRegisterSystemInfo(){
	var selectedVal = $("#schemeId option:selected").attr("registerInfo");
	if(selectedVal==undefined){
		//$.alert("对应注册系统已经被删除，请检查");
		return;
	}
    var rm = new registerManager();
    var vo = rm.getRegisterInstance(selectedVal);
    if(vo!=null){
    $("#thirdSystem").val(vo.productCode+vo.versionNO+"_"+decodeURIComponent(vo.addr));
    }
    $("#thirdSystem").attr("disabled","disabled");
}
function createOption(value, text,registerInfo){
	var option = document.createElement("option");
	option.value = value;
	option.text = text;
	option.setAttribute("registerInfo",registerInfo);
	return option;
}
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <!-- <div class="stadic_layout_head stadic_head_height">
                </div> -->
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="schemeInitForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="schemeInitForm.jsp"%></div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height" style="margin-bottom: 4px;">
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

    <%-- 左侧树组件 --%>
        <div class="layout_west" layout="width:260" style="border-left: none;width:30%;">
	    <div id="entityTree"></div>
	    <input type="hidden" id="nodeid" name="nodeid" />
	</div>
</div>    
</body>
</html>
