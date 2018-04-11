<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_neigou_ssomanage'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="loginLimitForm" class="form_area" style="overflow-y:hidden;">
                         <%@include file="ssoLoginLimitForm.jsp"%></div>
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
<script type="text/javascript" src="${path}/ajax.do?managerName=neigouSSOManager"></script>
<script type="text/javascript">
$().ready(function() {

	var ssoManager = new neigouSSOManager();
   
    var toolbar = $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",
            className: "ico16",
            click: function() {
            	   $("#loginLimitForm").clearform({clearHidden:true});
                	$("#loginLimitForm").enable();
                	$("#loginLimitForm").show();
                	$("#tr_time").hide();
                	$("#welcome").hide();
                    $("#button").show();
                    $("#loginNotLimit").attr("checked","checked");
                    $("#workDay").attr("checked","checked");
                    $("#anytime").attr("checked","checked");
                    $(".hourOption").find("option[value='00']").attr("selected",true);
                    $(".mOption").find("option[value='00']").attr("selected",true);
                    
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
                	$.alert("${ctp:i18n('level.delete')}");
                } else {
                    $.confirm({
                        'msg': "${ctp:i18n('common.isdelete.label')}",
                        ok_fn: function() {
                        	ssoManager.deleteLoginLimitInfo(v, {
                                success: function() {
                                	$("#mytable").ajaxgridLoad(o);
                                	$("#loginLimitForm").hide();
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
        	/*姓名*/
            display: "${ctp:i18n('neigou.plugin.band.omname')}",
            sortable: true,
            name: "name",
            width: '15%',
        },
        {
        	/*登录名*/
            display: "${ctp:i18n('org.member_form.loginName.label')}",
            sortable: true,
            name: 'loginName',
            width: '15%'
        },
        {
        	/*所属部门*/
            display: "${ctp:i18n('neigou.plugin.band.ouname')}",
            sortable: true,
            name: 'deptName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('neigou.sso.manage.timedisplay')}",
            sortable: true,
            name: 'limitDisplay',
            width: '25%'
        }
        ],
        managerName: "neigouSSOManager",
        managerMethod: "findLoginLimtList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    
    var searchobj = $.searchCondition({
        top: 7,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('neigou.plugin.band.omname')}",
          value: 'orgMember'
        },{
          id: 'search_department',
          name: 'search_department',
          type: 'input',
          text: "${ctp:i18n('neigou.plugin.band.ouname')}",
          value: 'department'
        }]
        
      });
    function voLimit(vo){
      	if(vo.limit){
    		$("#loginLimit").attr("checked","checked");
    		$("#tr_time").show();
    		if(vo.workDay=="-1"){
    			$("#workDay").removeAttr("checked");
    		}else{
    			$("#workDay").attr("checked","checked");
    			var fromto=vo.workDay.split("-");
    			var fromtime = fromto[0].split(":");
    			var totime = fromto[1].split(":");
    			$("#start_h").val(fromtime[0]);
    			$("#start_m").val(fromtime[1]);
    			$("#to_h").val(totime[0]);
    			$("#to_m").val(totime[1]);
    		}
    		if(vo.restDay=="-1"){
    			$("#restDay").removeAttr("checked");
    		}else{
    			$("#restDay").attr("checked","checked");
    			if(vo.restDay=="1"){
        			$("#anytime").attr("checked","checked");
        			$("#bucketed").removeAttr("checked");
        		}else{
        			$("#tr_bucketed").show();
        			$("#anytime").removeAttr("checked");
        			$("#bucketed").attr("checked","checked");
        			var fromto=vo.restDay.split("-");
        			var fromtime = fromto[0].split(":");
        			var totime = fromto[1].split(":");
        			$("#start_h_2").val(fromtime[0]);
        			$("#start_m_2").val(fromtime[1]);
        			$("#to_h_2").val(totime[0]);
        			$("#to_m_2").val(totime[1]);
        		}
    		}
    		
    	}else{
    		$("#loginNotLimit").attr("checked","checked");
    		$("#tr_time").hide();
            $("#workDay").attr("checked","checked");
            $("#anytime").attr("checked","checked");
            $(".hourOption").find("option[value='00']").attr("selected",true);
            $(".mOption").find("option[value='00']").attr("selected",true);
    	}
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
            var vo = ssoManager.queryLoginLimitVO(v[0]["id"]);
            $("#loginLimitForm").enable();
        	$("#addForm").fillform(vo);
        	$("#loginLimitForm").show();
        	$("#button").show();
        	voLimit(vo);
        }
    }

    function gridclk(data, r, c) {
    	$("#loginLimitForm").disable();
    	$("#loginLimitForm").show();
    	$("#button").hide();
    	$("#welcome").hide();
    	var vo = ssoManager.queryLoginLimitVO(data.id);
    	$("#addForm").fillform(vo);
    	voLimit(vo);
    	mytable.grid.resizeGridUpDown('middle');
    }
    
	if("${isEnableByCorp}"=="true"){
		$("#mytable").hide();
	    toolbar.disabled("add");
    	toolbar.disabled("modify");
    	toolbar.disabled("delete");
    	$("body").disable();
    	$("#mytable").disable();
    	
    	$.alert("${ctp:i18n('neigou.sso.manage.notcorp')}");
     }
		
	$("#loginLimitForm").hide();  
    bindChoosePersonEvent();
    var select = $(".hourOption");
    var options = new StringBuffer();
    for(var i=0; i<24; i++){
    	var dv=i;
        if(i<10){
        	dv="0"+dv;
    	}
       options.append("<option value='"+dv+"'>"+dv+"${ctp:i18n('neigou.sso.manage.hour')}</option>");
    }
    select.html(options.toString());
	$("#bucketed").click(function(){
		$("#tr_bucketed").show();
		$("#weekend").attr("checked","checked");
	});
	$("#loginLimit").click(function(){
			$("#tr_time").show();
	});
	$("#loginNotLimit").click(function(){
		$("#tr_time").hide();
	
});
	$("#btncancel").click(function() {
    	location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#loginLimitForm").validate())){		
          return;
        }
        if($("#loginLimit").attr("checked")=="checked"){
        if($("#workDay").attr("checked")!="checked" && $("#restDay").attr("checked")!="checked" ){
        	$.alert("${ctp:i18n('neigou.sso.manage.selectperiod')}");
        	return;
        }
        	if($("#workDay").attr("checked")=="checked" && ($("#start_h").val()+$("#start_m").val()) == ($("#to_h").val()+$("#to_m").val())){
        		$.alert("${ctp:i18n('neigou.sso.manage.notsame.time')}");
        		return;
        	}
        	if($("#restDay").attr("checked")=="checked" && $("#bucketed").attr("checked")=="checked" && ($("#start_h_2").val()+$("#start_m_2").val()) == ($("#to_h_2").val()+$("#to_m_2").val())){
        		$.alert("${ctp:i18n('neigou.sso.manage.notsame.time')}");
        		return;
        	}
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        var workDay = "-1";
        var restDay = "-1";
        if($("#workDay").attr("checked")=="checked"){
        	workDay = $("#start_h").val()+":"+$("#start_m").val()+"-"+$("#to_h").val()+":"+$("#to_m").val();
        }
        
        if($("#restDay").attr("checked")=="checked"){
        	if($("#anytime").attr("checked")=="checked"){
        		restDay = "1";
        	}else{
        		restDay = $("#start_h_2").val()+":"+$("#start_m_2").val()+"-"+$("#to_h_2").val()+":"+$("#to_m_2").val();
        	}
        }
        var limit = "false";
        if($("#loginLimit").attr("checked")=="checked"){
        	limit ="true";
        }
        var formObjJson = {"id":$("#id").val(),"limit":limit,"entityId":$("#entityId").val(),"workDay":workDay,"restDay":restDay,"entityIds":$("#entityIds").val()};
        ssoManager.saveLoginLimitInfo(formObjJson, {
            success: function(rel) {
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				location.reload();                
            },
            error:function(returnVal){
              getCtpTop().endProc();
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });        				                                                               
    });	
});

function bindChoosePersonEvent() {
	var choosePersonCtr = $("#name");
	choosePersonCtr.unbind("click").bind("click",function() {
		$.selectPeople({
		      type: 'selectPeople',
		      panels: 'Department,Post,Level,Outworker',
		      selectType: 'Member,Department,Post,Level',
		      minSize:0,
		      maxSize:100,
		      showConcurrentMember:true,
		      onlyLoginAccount: true,
		      returnValueNeedType: true,
		      unallowedSelectEmptyGroup: true,
		      //excludeElements: excludeMembers.ids,
		      text : $("#name").val(),
		      params: {value:$("#entityId").val()},
		      callback: function(ret) {
		    	 choosePersonCtr.val(ret.text);
		    	 //if(ret.value.indexOf(",") == -1&&ret.value.indexOf("Member")>-1){
		    		// $("#entityId").val(ret.value.split('|')[1]);
		    	 //}else{
		    		 $("#entityIds").val(ret.value);
		    	 //}
		      }
	    });
	});
}
</script>
</html>