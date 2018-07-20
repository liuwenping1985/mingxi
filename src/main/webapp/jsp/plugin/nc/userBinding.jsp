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
	src="${path}/ajax.do?managerName=ncUserMapperManager"></script>
<script type="text/javascript">
$().ready(function() {
	var ncManager=new ncUserMapperManager();	
    $("#postform").hide();    
    $("#button").hide();
    function addform(){
    	$("#postform").clearform({clearHidden:true});
        $("#postform").enable();
        $("#postform").show();
        $("#button").show();                        
        $("#grid_detail").css("overflowY","hidden");
        mytable.grid.resizeGridUpDown('middle');
    }
    
    function flushSpace(){
      getCtpTop().refreshNavigation();
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
                        'msg': "${ctp:i18n('ntp.user.mapper.sure.delete')}",
                        ok_fn: function() {
                        	ncManager.deleteUserMapper(v, {
                                success: function() {
                                	$("#mytable").ajaxgridLoad(o);
                                	$("#postform").hide();
                                    $("#button").hide();                                    
                                }
                            });
                        }
                    });
                };
            }
        }/* ,
        {
          id: "flush",
          name: "${ctp:i18n('ntp.user.mapper.spaceflush')}",
          className: "ico16 batch_16",
          click: function(){flushSpace();}
      } */
        ]
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
            display: "${ctp:i18n('ntp.user.account')}",
            sortable: true,
            name: 'name',
            width: '20%'
        },
        {
            display: "${ctp:i18n('ntp.user.mapper.provider')}",
            sortable: true,
            name: 'account',
            width: '25%'
        },
        {
            display: "${ctp:i18n('ntp.user.mapper.bindingType')}",
            sortable: true,
            name: 'type',
            width: '25%'
        },
        {
            display: "${ctp:i18n('ntp.user.mapper.description')}",
            sortable: true,
            name: 'description',
            width: '25%'          
        }
        ],
        managerName: "ncUserMapperManager",
        managerMethod: "showUserMapperList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    function gridclk(data, r, c) {
    	$("#postform").disable();
    	$("#postform").show();
    	$("#button").hide();    	
    	var postdetil = ncManager.viewUserMapper(data.id);
    	$("#addForm").fillform(postdetil);
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
            var mpostdetil = ncManager.viewUserMapper(v[0]["id"]);
            $("#postform").clearform({clearHidden:true});
        	$("#addForm").fillform(mpostdetil);        	
        	$("#postform").enable();
        	$("#postform").show();
        	$("#button").show();
        	$("#grid_detail").css("overflowY","hidden");
        }
    }
    
    $("#btncancel").click(function() {
    	location.reload();
    });
    $("#btnok").click(function() {	
        if(!($("#postform").validate())){		
          return;
        }
        if($("#account").val()===''||$("#account").val()===null){
            $.alert("${ctp:i18n('ntp.user.mapper.ncapp.notAllowedNull')}");
            return;
        }
        if($("#type").val()===''||$("#type").val()===null){
          $.alert("${ctp:i18n('ntp.user.mapper.bingdType.notAllowedNull')}");
          return;
      }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();		
        
		ncManager.saveUserMapper($("#addForm").formobj(), {
            success: function(rel) {
                alert(rel);
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
				if(rel=='${ctp:i18n("ntp.org.user.editsuccess")}'||rel=='${ctp:i18n("ntp.user.mapper.success")}'){
				location.reload();                
				}                                
                
            }
        });        				                                                               
    });
        
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T02_showLevelframe'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height"></div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="postform" class="form_area" style="overflow-y:hidden">
                        <%@include file="userform.jsp"%></div>
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