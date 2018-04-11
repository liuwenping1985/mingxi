<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

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
<script type="text/javascript" src="${path}/ajax.do?managerName=multiCallManager"></script>
<script type="text/javascript">
$().ready(function() {
	var callManager = new multiCallManager();
    $("#configForm").hide();
    $("#button").hide();
    if(!${ctp:isGroupVer()}){
    	$("#type option:first").remove();
    }
    function addform(){
        $("#configForm").clearform({clearHidden:true});
        $("#configForm").enable();
        $("#configForm").show();
        $("#button").show();
        $("#type option:first").prop("selected","selected");
        $("#state option:first").prop("selected","selected");
        changeCompanyTr();
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
                        'msg': "${ctp:i18n('cip.org.sync.record.delete.ok')}",
                        ok_fn: function() {
                        	callManager.deleteConfigs(v, {
                                 success: function() {
                                     $("#mytable").ajaxgridLoad(o);
                                     $("#button").hide();
                                     $("#configForm").hide();
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
        /* vChange: true,
        isHaveIframe:true,
        slideToggleBtn:true, */
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('multicall.plugin.config.company.name')}",
            sortable: true,
            name: 'companyName',
            width: '30%'
        },
        {
            display: "${ctp:i18n('multicall.plugin.config.company.code')}",
            sortable: true,
            name: 'companyCode',
            width: '20%'
        },
        {
            display: "${ctp:i18n('multicall.plugin.config.systemaccount')}",
            sortable: true,
            name: 'systemAccount',
            width: '20%',
        },
        {
            display: "${ctp:i18n('multicall.plugin.config.state')}",
            sortable: true,
            name: 'state',
            width: '15%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.multicall.util.ConfigStateEnum',query:'true'"
        }
        ],
        managerName: "multiCallManager",
        managerMethod: "showConfigs",
        parentId:'center',
        slideToggleBtn: true,
        vChange: true      
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('down');
    function gridclk(data, r, c) {
        $("#configForm").disable();
        $("#configForm").show();
        $("#button").hide();
        $("#configForm").clearform({clearHidden:true});
        var configdetil = callManager.viewConfig(data.id);
        $("#addForm").fillform(configdetil);
        changeCompanyTr();
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
            id: 'search_entity',
            name: 'search_entity',
            text: "${ctp:i18n('multicall.plugin.config.company.name')}",
            type: 'selectPeople',
            comp:"type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',returnValueNeedType:false",
            value: 'companyName'
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
            var calldetil = callManager.viewConfig(v[0]["id"]);
            
            $("#configForm").clearform({clearHidden:true});
            $("#addForm").fillform(calldetil);
            $("#configForm").enable();
            $("#configForm").show();
            $("#type").attr("disabled","disabled");
            $("#companyName").attr("disabled","disabled");
            changeCompanyTr();
            $("#button").show();
            $("#configForm").resetValidate();
		}
	}
    

    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#configForm").validate())){ 
          return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
		callManager.saveConfig($("#configForm").formobj(), {
			success: function(rel) {
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				$("#mytable").ajaxgridLoad(o);
				location.reload();                
			}
		}); 
		
    });
    
    $("#type").change(function(){
    	changeCompanyTr();
    });
    $("#companyName").click(function(){
    	$.selectPeople({
	        type:'selectPeople',
	        panels:'Account',
	        selectType:'Account',
	        text:$.i18n('common.default.selectPeople.value'),
	        returnValueNeedType: false,
	        maxSize:'1',
	        showMe:true,
	        targetWindow:getCtpTop(),
	        callback : function(res){
        		$("#companyName").val(res.text);
        		$("#orgAccountId").val(res.value);
        		var detail = callManager.getAccountById(res.value);
        		$("#companyCode").val(detail.code);
	        }
	    });
    });
	
});
function changeCompanyTr(){
	if($("#type").val()=='group'){
    	$(".companyTr").hide();
    }else{
    	$(".companyTr").show();
    	$("#companyCode").attr("disabled","disabled");
    	if(!${ctp:isGroupVer()}){
    		$("#companyName").val("${ctp:getAccount(v3x:currentUser().loginAccount).name}");
    		$("#orgAccountId").val("${ctp:getAccount(v3x:currentUser().loginAccount).id}");
    		$("#companyCode").val("${ctp:getAccount(v3x:currentUser().loginAccount).code}");
    		$("#companyName").attr("disabled","disabled");
    	}
    }
	$("#systemAccount").attr("disabled","disabled");
}

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="configForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="configForm.jsp"%></div>
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