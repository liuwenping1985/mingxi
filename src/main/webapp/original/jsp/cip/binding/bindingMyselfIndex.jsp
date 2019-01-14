<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=thirdpartyUserMapperCfgManager"></script>

<script type="text/javascript">

$().ready(function() {
	var tum = new thirdpartyUserMapperCfgManager();
	function initSelect(v){
        var rs = document.getElementById("registerId");
        $("#registerId").empty();
        <c:forEach items="${registerList}" var="data">
          var item = createOption("${data.id}", "${data.appName}");
           rs.add(item);
            if("${data.id}"==v){
            	item.selected=true;
            }
		</c:forEach>
	}
	function createOption(value, text) {
		var option = document.createElement("option");
		option.value = value;
		option.text = text;
		
		return option;
	}
    function gridclk(data, r, c) {
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        mytable.grid.resizeGridUpDown('middle');
      	$("#addForm").clearform({clearHidden:true});
      	 var detail=  tum.getThirdUserMapperVO(v[0].memberId,v[0].registerId);
        $("#addForm").fillform(detail);
      	$("#thirdPassword").val(detail.thirdPassword);
      	initSelect(v[0].registerId);
      	$("#bindingType option:first").attr('selected',true);
        $("#userBindingForm").show();
        $("#addForm").disable();
    	  $("#button").hide();
      	  $("#welcome").hide();
    }
    function griddbclick() {
        var v = $("#mytable").formobj({
          gridFilter : function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1||v.length > 1) {
          $.alert("${ctp:i18n('common.choose.one.record.label')}");
          return;
      }
        mytable.grid.resizeGridUpDown('middle');
      	$("#addForm").clearform({clearHidden:true});
      	 var detail=  tum.getThirdUserMapperVO(v[0].memberId,v[0].registerId);
        $("#addForm").fillform(detail);
        $("#thirdPassword").val(detail.thirdPassword);
    	initSelect(v[0].registerId);
    	$("#bindingType option:first").attr('selected',true);
        $("#userBindingForm").show();
        $("#userBindingForm").enable();
    	$("#button").show();
      }
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",
            className: "ico16",
            click: function() {
                mytable.grid.resizeGridUpDown('middle');
            	$("#id").val("-1");
            	initSelect();
                $("#addForm").enable();
            	$("#button").show();
            }
        },
        {
            id: "modify",
            name: "${ctp:i18n('common.button.modify.label')}",
            className: "ico16 editor_16",
            click: function() {
            	griddbclick();
            }
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
                        'msg': "${ctp:i18n('common.isdelete.label')}",
                        ok_fn: function() {
                        	 tum.deleteThirdpartyUserMapper(v, {
                                 success: function() {
                                     $("#mytable").ajaxgridLoad(o);
                                     mytable.grid.resizeGridUpDown('down');
                                 }
                             });
                        }
                    });
                };
            }
        }
        ]
    });
	
	
    var mytable = $("#mytable").ajaxgrid({  
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        colModel: [
                   {
                	 display:"id",
                     name: 'mapperId',
                     width: '5%',
                     sortable: true,
                     type: 'checkbox'
                   }, 
                   {
                       display: "${ctp:i18n('cip.register.appname')}",
                       sortable: true,
                       name: 'appName',
                       width: '35%'
                   },
                   {
                     display: "${ctp:i18n('cip.manager.binding.thirdaccount')}",
                     name: 'thirdLoginName',
                     width: '35%',
                     sortable: true
                   },
                   {
                       display: "${ctp:i18n('cip.binding.opertation.type')}",
                       name: 'bindingType',
                       width: '25%',
                       sortable: true,
                       codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.BindingEnum'"
                     },
                   {
                       display : "",
                       name : 'registerId',
                       width : '10%',
                       hide : true
                   },
                   {
                       display : "",
                       name : 'memberId',
                       width : '10%',
                       hide : true
                   }
                   ],
        width: "auto",
        managerName: "thirdpartyUserMapperCfgManager",
        managerMethod: "listMyselftMapper",
        parentId:'center',
        click: gridclk,
        dblclick:griddbclick
    });
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    
    $("#thirdPassword").focus(function(){
    	if($("#thirdPassword").val().indexOf("/1.0/")!=-1){
    		$("#thirdPassword").val("");
    	}
    });
    
    $("#btnok").click(function() {
        if(!($("#addForm").validate())){		
          return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        try{
        	  tum.saveUserMapper($("#addForm").formobj(), {
                 success: function(rel) {
     				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
     				location.reload();                
                 },
                 error:function(returnVal){
                   try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                   var sVal=$.parseJSON(returnVal.responseText);
                   $.alert(sVal.message);
               }
             });
         }catch(e){
        	 alert(e);
         };
        
        				                                                               
    });
	 $("#btncancel").click(function() {
		  location.reload();
	 });

	
});


</script>

</head>
<body> 
 
<div id='layout' class="comp" comp="type:'layout'">
 
    <div class="comp" comp="type:'breadcrumb',code:'T02_showLevelframe'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">  
      <div id="toolbar"></div>
   </div>
 
    <div  class="layout_center over_hidden" id="center">
        <table id="mytable" class="flexme3" ></table>
      <div id="grid_detail" style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="userBindingForm" class="form_area" style="overflow-y:hidden;">
                    <%@include file="myselfBindingForm.jsp"%></div>
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
    <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>