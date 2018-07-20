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
	.relative{
		overflow-y:hidden;
	}
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=didicarManager"></script>
<script type="text/javascript">
$().ready(function() {
	var dManager=new didicarManager();	
    $("#informationForm").hide();    
    $("#button").hide();
    bindChoosePersonEvent();
    function addform(){
    	
    	$("#informationForm").enable();
    	initForm();
    	$("#informationForm").show();
    	$("#welcome").hide();
        $("#button").show();
        mytable.grid.resizeGridUpDown('middle');
    }
    var toolbar = $("#toolbar").toolbar({
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
                        'msg': "${ctp:i18n('common.isdelete.label')}",
                        ok_fn: function() {
                        	var dManager = new didicarManager();
                        	dManager.deleteAuthInformations(v, {
                                success: function() {
                                	$("#mytable").ajaxgridLoad(o);
                                	$("#informationForm").hide();
                                    $("#button").hide();
                                    bindChoosePersonEvent();
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
            display: "${ctp:i18n('didicar.plugin.information.name')}",
            sortable: true,
            name: 'name',
            width: '15%',
            isToggleHideShow:true
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
            display: "${ctp:i18n('didicar.plugin.information.depart')}",
            sortable: true,
            name: 'department',
            width: '25%'
        },
        {
        	/*使用时间*/
            display: "${ctp:i18n('didicar.plugin.information.period')}",
            sortable: true,
            name: 'useTime',
            width: '25%'
        },
        {
          display: "${ctp:i18n('didicar.plugin.auth.manager')}",
          sortable: true,
          name: 'managerName',
          width: '15%'
      }
        ],
        managerName: "didicarManager",
        managerMethod: "showAuthList",
        parentId:'center',        
        slideToggleBtn: true,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    o.role="${role}";
    $("#mytable").ajaxgridLoad(o);
    //mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          ssss.role="${role}";
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('didicar.plugin.information.name')}",
          value: 'name'
        },{
          id: 'search_department',
          name: 'search_department',
          type: 'input',
          text: "${ctp:i18n('didicar.plugin.information.depart')}",
          value: 'department'
        }]
        
      });
    
    var select = $(".hourOption");
    var options = "";
    for(var i=0; i<24; i++){
    	
    	if(i==0){
    		options += "<option value='0"+i+"' selected='selected'>0"+i+"${ctp:i18n('didicar.plugin.information.period.limi.hour')}</option>";
    	}else if(i<10){
    		options += "<option value='0"+i+"'>0"+i+"${ctp:i18n('didicar.plugin.information.period.limi.hour')}</option>";
    	}else{
    		options += "<option value='"+i+"'>"+i+"${ctp:i18n('didicar.plugin.information.period.limi.hour')}</option>";
    	}
    }
    select.html(options);
    if("${errmsg}"!=""){
    	$.alert("${errmsg}");
    	toolbar.disabled("add");
    	toolbar.disabled("modify");
    	toolbar.disabled("delete");
    	$("body").disable();
    }
    function gridclk(data, r, c) {
    	$("#informationForm").disable();
    	$("#informationForm").show();
    	$("#button").hide();
    	$("#welcome").hide();
    	var array = new Array();
    	array[0] = data.orgMemberId;
    	var postdetil = dManager.viewAuthInformation(array);
    	handleCheckbox(postdetil);
    	$("#addForm").fillform(postdetil);
    	$("#authorize").val(postdetil.memberId);
    	if(postdetil.period2=="1"){
    		$("#tr_time").show();
    	}
    	if(postdetil.bucketed=="1"){
    		$("#tr_bucketed").show();
    	}
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
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var array = new Array();
            for(var i=0; i<v.length; i++){
            	array[i] = v[i]["orgMemberId"];
            }
            var mpostdetil = dManager.viewAuthInformation(array);
            $("#informationForm").enable();
            if(v.length>1){
            	initForm();
            }else{
            	handleCheckbox(mpostdetil);
            	if(mpostdetil.mon_quota=='1'){
            		$("#limitmoney").removeAttr("disabled");
            	}
            }
        	$("#addForm").fillform(mpostdetil);
        	$("#authorize").val(mpostdetil.memberId);
        	$("#informationForm").show();
        	$("#button").show();
        	$("#grid_detail").css("overflowY","hidden");
        }
    }
    $("#mode1").click(function(){
		if($(this).attr("checked")=="checked"){
			$(".car_models").show();
		}else{
			$(".car_models").hide();
		}
	});
	$("#period2").click(function(){
		$("#tr_time").show();
	});
	$("#period1").click(function(){
		$("#tr_time").hide();
	});
	$("#bucketed").click(function(){
		$("#tr_bucketed").show();
		$("#weekend").attr("checked","checked");
	});
	$("#anytime").click(function(){
		$("#tr_bucketed").hide();
	});
	$("#no_quota").bind("click",quotaClick);
	$("#mon_quota").click(function(){
		$("#limitmoney").removeAttr("disabled");
	});
	$("#btncancel").click(function() {
    	location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#informationForm").validate())){		
          return;
        }
        if($("#weekday").attr("checked")!="checked" && $("#weekend").attr("checked")!="checked" ){
        	$.alert("${ctp:i18n('didicar.plugin.information.selectperiod')}");
        	return;
        }
        if($("#mode1").attr("checked")!="checked" && $("#mode2").attr("checked")!="checked" ){
        	$.alert("${ctp:i18n('didicar.plugin.information.selectmode')}");
        	return;
        }
        if($("#mode1").attr("checked")=="checked" && $("#models1").attr("checked")!="checked" && $("#models2").attr("checked")!="checked" && $("#models3").attr("checked")!="checked" && $("#models4").attr("checked")!="checked" ){
        	$.alert("${ctp:i18n('didicar.plugin.information.selectmodels')}");
        	return;
        }
        if($("#period2").attr("checked")=="checked"){
        	if($("#weekday").attr("checked")=="checked" && ($("#start_h").val()+$("#start_m").val()) == ($("#to_h").val()+$("#to_m").val())){
        		$.alert("${ctp:i18n('didicar.plugin.information.notsame.time')}");
        		return;
        	}
        	if($("#weekend").attr("checked")=="checked" && $("#bucketed").attr("checked")=="checked" && ($("#start_h_2").val()+$("#start_m_2").val()) == ($("#to_h_2").val()+$("#to_m_2").val())){
        		$.alert("${ctp:i18n('didicar.plugin.information.notsame.time')}");
        		return;
        	}
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        dManager.saveAuthInformation($("#addForm").formobj(), {
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

function quotaClick(){
	$("#limitmoney").val("");
	$("#limitmoney").attr("disabled","disabled");
}
function initForm(){
  $("#informationForm").clearform({clearHidden:true});
  $("#no_quota").attr("checked","checked");
  $("#limitmoney").val("");
  $("#limitmoney").disable();
  $("#period1").attr("checked","checked");
  $("#anytime").attr("checked","checked");
  $("#weekday").attr("checked","checked");
  $("#needMemo1").attr("checked","checked");
  $("#tr_time").hide();
  $("#tr_bucketed").hide();
  $("input[name='car_mode']").attr("checked","checked");
  $("input[name='models']").attr("checked","checked");
  $(".car_models").show();
  $(".hourOption").val("00");
  $(".mOption").val("00");
  $("#carRole").val("${role}");
}
function handleCheckbox(mpostdetil){
  
  $(".hourOption").val("00");
  $(".mOption").val("00");
  if(mpostdetil.needMemo){
      $("#needMemo1").attr("checked","checked");
  }else{
      $("#needMemo2").attr("checked","checked");
  }
	if(mpostdetil.no_quota=='0'){
		$("#no_quota").trigger("click");
	}
	if(mpostdetil.mode1==undefined){
		$("#mode1").removeAttr("checked");
		$(".car_models").hide();
	}else{
		$(".car_models").show();
		if(mpostdetil.models1==undefined){
			$("#models1").removeAttr("checked");
		}else{
			$("#models1").attr("checked","checked");
		}
		if(mpostdetil.models2==undefined){
			$("#models2").removeAttr("checked");
		}else{
			$("#models2").attr("checked","checked");
		}
		if(mpostdetil.models3==undefined){
			$("#models3").removeAttr("checked");
		}else{
			$("#models3").attr("checked","checked");
		}
		if(mpostdetil.models4==undefined){
			$("#models4").removeAttr("checked");
		}else{
			$("#models4").attr("checked","checked");
		}
	}
	if(mpostdetil.mode2==undefined){
		$("#mode2").removeAttr("checked");
	}
	if(mpostdetil.period1==undefined){
		$("#period2").attr("checked","checked");
		$("#tr_time").show();
		if(mpostdetil.weekday==undefined){
			$("#weekday").removeAttr("checked");
		}else{
			$("#weekday").attr("checked","checked");
		}
		if(mpostdetil.weekend==undefined){
			$("#weekend").removeAttr("checked");
		}else{
			$("#weekend").attr("checked","checked");
			if(mpostdetil.bucketed=="1"){
				$("#tr_bucketed").show();
			}else{
				$("#tr_bucketed").hide();
			}
		}
	}else{
		$("#weekend").removeAttr("checked");
		$("#anytime").attr("checked","checked");
		$("#anytime").trigger("click");
		$("#tr_time").hide();
	}
}
/**
* 绑定授权选人事件
*/
function bindChoosePersonEvent() {
	var choosePersonCtr = $("#memberName");
	var dManager=new didicarManager();
	var excludeMembers = dManager.getExcludeMembers();
	choosePersonCtr.unbind("click").bind("click",function() {
		$.selectPeople({
		      type: 'selectPeople',
		      panels: 'Department,Post,Level,Outworker',
		      selectType: 'Member,Department,Post,Level',
		      minSize:0,
		      maxSize:100,
		      showConcurrentMember:false,
		      onlyLoginAccount: true,
		      returnValueNeedType: true,
		      unallowedSelectEmptyGroup: true,
		      //excludeElements: excludeMembers.ids,
		      text : $("#memberName").val(),
		      params: {value:$("#authorize").val()},
		      callback: function(ret) {
		    	 choosePersonCtr.val(ret.text);
		    	 $("#authorize").val(ret.value);
		      }
	    });
	});
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_didi_member_${param.from}'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" style="overflow-y:hidden;position:relative;">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
                    <div id="informationForm" class="form_area" style="overflow-y:hidden;">
                        <%@include file="informationForm.jsp"%></div>
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