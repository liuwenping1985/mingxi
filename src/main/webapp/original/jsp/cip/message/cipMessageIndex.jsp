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
<script type="text/javascript" src="${path}/ajax.do?managerName=messageOrPendingConfigManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=portalConfigManager"></script>
<script type="text/javascript">
$().ready(function() {
    var messageManager = new messageOrPendingConfigManager();
    var pcManager = new portalConfigManager();
    var msg = '${ctp:i18n("info.totally")}';
    $("#thirdMessageform").hide();
    $("#button").hide();
    $("#timeInterval_area").hide();
    
    $("#getMode").change( function() {
   	 var modeValue = $("#getMode  option:selected").val();
   	 if(null != modeValue && "" != modeValue){
   		 if(modeValue == "1"){//第三方读取
   			$("#timeInterval_area").show();
 			var timeInterval = $("#timeInterval  option:selected").val();
       		if(timeInterval == "" || typeof timeInterval == 'undefined'){
        		$("#timeInterval option[value=3]").attr("selected", true);
        	}
   		 }else if(modeValue == "0"){
   			 $("#timeInterval_area").hide();
   		 }
   	 }
   });
    
    function addform(){
        $("#thirdMessageform").clearform({clearHidden:false});
        $("#id").val("");
        $("#thirdMessageform").enable();
        $("#thirdMessageform").show();
        $("#accessMethodName").attr("disabled",true);
        $("#button").show();
        $("#south").show();
        $("#registerId").attr("disabled",false);
        initSelect();
        initTimeSelect();
        $("#lconti").show();
        $("#conti").attr("checked",'checked'); 
        $("input[name=enabled]:eq(0)").attr("checked",'checked'); 
        $("#timeInterval_area").hide();
        mytable.grid.resizeGridUpDown('middle');
    }
    
    function initTimeSelect(){
   		 var timeInterval = document.getElementById("timeInterval");
   		$("#timeInterval").empty();
   		$("#timeInterval").prepend("<option value=''>${ctp:i18n('cip.select.choose')}</option>");
   		for(var i=1;i<=30;i++){
   			var text = ""+i+"${ctp:i18n('cip.servcie.time_interval.minute')}";
   			var item = createOption(i,text);
   			timeInterval.add(item);
   		}
  	 }
    
    function initSelect(v) {
   	  var riList = messageManager.getCanSelectRegisterInfo("0");
   	  var registerId = document.getElementById("registerId");
   	  $("#registerId").empty();
   	  $("#registerId").prepend("<option value=''>${ctp:i18n('cip.select.choose')}</option>");
   	  if(null != riList){
   		  for(var i=0;i<riList.length;i++){
       		  var obj = riList[i];
       		  var item = createOption(obj.id, obj.appName);
       		  registerId.add(item);
             }
   	 	 }
  	 }
    
    function clickSelected(v) {
    	  var riList = pcManager.getRegisterInfoById(v);
    	  var registerId = document.getElementById("registerId");
  		  var item = createOption(riList.id, riList.appName);
  		  registerId.add(item);
  		  item.selected=true;
    }
    
    function createOption(value, text) {
		var option = document.createElement("option");
		option.value = value;
		option.text = text;
		
		return option;
	}
    var toolbarPlugin = new Array();
    <c:if test="${ctp:hasPlugin('applink')}">
    toolbarPlugin.push({
        id: "add",
        name: "${ctp:i18n('common.toolbar.new.label')}",
        className: "ico16",
        click: function() {
            addform();
        }
    });
    </c:if>
    toolbarPlugin.push({
        id: "modify",
        name: "${ctp:i18n('common.button.modify.label')}",
        className: "ico16 editor_16",
        click: griddbclick
    });
    
    <c:if test="${ctp:hasPlugin('applink')}">
    toolbarPlugin.push( {
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
                $.alert("${ctp:i18n('cip.portal.delete')}");
            } else {
                $.confirm({
                    'msg': "${ctp:i18n('cip.message.delete.ok')}",
                    ok_fn: function() {
                        messageManager.deleteMP(v, {
                            success: function() {
                                $("#mytable").ajaxgridLoad({info_type: '0'});
                                $("#thirdMessageform").hide();
                                $("#button").hide();
                            }
                        });
                    }
                });
            };
        }
    });
    </c:if>
    $("#toolbar").toolbar({
        toolbar:toolbarPlugin
    });
    
    
  

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,
        isHaveIframe:true,
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
            display: "${ctp:i18n('cip.register.appcode')}",
            sortable: true,
            name: 'appcode',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.register.appname')}",
            sortable: true,
            name: 'registerName',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.servcie.url')}",
            sortable: true,
            name: 'serviceUrl',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.service.register.access')}",
            sortable: true,
            name: 'accessMethod',
            width: '20%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
        },
        {
            display: "${ctp:i18n('cip.service.enabled')}",
            sortable: true,
            name: 'isEnable',
            width: '15%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'"
        }],
        managerName: "messageOrPendingConfigManager",
        managerMethod: "showThirdMPList",
        parentId:'center',
        params: {
        	info_type: '0',
          },
        vChangeParam: {
            overflow: 'hidden',
            position: 'relative'
        },
        slideToggleBtn: true,
        vChange: true
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad({info_type: '0'});

    function gridclk(data, r, c) {
        $("#thirdMessageform").disable();
        $("#thirdMessageform").show();
        $("#button").hide();
        initTimeSelect();
        var thirdPenidngDetail = messageManager.viewMPInfo(data.id);
        clickSelected(thirdPenidngDetail.registerId);
        if(thirdPenidngDetail.getMode=="1"){
        	$("#timeInterval_area").show();
        	var timeInterval = $("#timeInterval  option:selected").val();
        	if(timeInterval == "" || typeof timeInterval == 'undefined'){
        		$("#timeInterval option[value=3]").attr("selected", true);
        	}
        }else if(thirdPenidngDetail.getMode=="0"){
        	$("#timeInterval_area").hide();
        }
        $("#addForm").fillform(thirdPenidngDetail);
        $("#accessMethodName").val(thirdPenidngDetail.accessMethod);
        mytable.grid.resizeGridUpDown('middle');
    }
    function griddbclick() {
    //$("#thirdMessageform").enable();
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('cip.chosce.modify')}");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('cip.selected.one.record')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            initTimeSelect();
            var mpostdetil = messageManager.viewMPInfo(v[0]["id"]);
            $("#thirdMessageform").clearform({clearHidden:true});
            clickSelected(mpostdetil.registerId);
            $("#addForm").fillform(mpostdetil);
            if(mpostdetil.getMode=="1"){
            	$("#timeInterval_area").show();
            	var timeInterval = $("#timeInterval  option:selected").val();
            	if(timeInterval == "" || typeof timeInterval == 'undefined'){
            		$("#timeInterval option[value=3]").attr("selected", true);
            	}
            }else if(mpostdetil.getMode=="0"){
            	$("#timeInterval_area").hide();
            }
            $("#conti").removeAttr("checked");;
            $("#thirdMessageform").enable();
            $("#registerId").attr("disabled",true);
            $("#thirdMessageform").show();
            $("#accessMethod").attr("disabled",true);
            $("#button").show();
            $("#lconti").hide();
            $("#accessMethodName").val(mpostdetil.accessMethod);
            $("#accessMethodName").attr("disabled",true);
        }
    }
    
   var searchobj = $.searchCondition({
        top:7,
        right:10,
        searchHandler: function(){
            var ssss = searchobj.g.getReturnValue();
			ssss.info_type="0";
            $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
            id: 'search_name',
            name: 'search_name',
            type: 'input',
            text: "${ctp:i18n('cip.register.appname')}",
            value: 'registerName'
        }, 
        {
            id: 'accessMethod',
            name: 'accessMethod',
            type: 'select',
            text: "${ctp:i18n('cip.service.register.access')}",
            value: 'accessMethod',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"			
        },
        {
            id: 'search_enable',
            name: 'search_enable',
            type: 'select',
            text: "${ctp:i18n('cip.service.enabled')}",
            value: 'isEnable',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'"
            
        }]
    });
    
    
    
    $("#registerId").change(function () {  
        var registerId = $("#registerId  option:selected").val();  
        if(null != registerId && "" != registerId){
        	var mpostdetil = pcManager.getRegisterInfoById(registerId);
            $("#accessMethodName").val(mpostdetil.accessMethodName);
        }
    }); 
    
    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#thirdMessageform").validate())){
          return;
        }
        if(null == $("#registerId").val() || "" == $("#registerId").val()){
        	$.alert("${ctp:i18n('cip.register.appname.choose.alert')}");
    		return;
        }
       
        if(null == $("#getMode").val() || "" == $("#getMode").val()){
        	$.alert("${ctp:i18n('cip.register.message.getmode.alert')}");
    		return;
        }
        if(null == $("#isEnable").val() || "" == $("#isEnable").val()){
        	$.alert("${ctp:i18n('cip.register.enable.choose.alert')}");
    		return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        messageManager.createOrUpdateThirdMP($("#addForm").formobj(), {
            success: function(levelBean) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad({info_type: '0'});
                if($("#conti").attr("checked")=="checked"){
                    addform();
                }else{   
                    $("#thirdMessageform").hide();
                    $("#button").hide();
                }
            }
        });
    });
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'cip_message'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">
     	<div id="searchDiv"></div>
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height"></div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="thirdMessageform" class="form_area">
                        <%@include file="cipMessageForm.jsp"%>
                    </div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                            <label for="conti" class="margin_r_10 hand" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
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