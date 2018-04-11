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
<script type="text/javascript" src="${path}/ajax.do?managerName=cipSynSchemeManager,registerManager"></script>
<script type="text/javascript">
function enumImageCallBk(filemsg){
	if(filemsg.instance!=null && filemsg.instance.length>0){
		var fileId = filemsg.instance[0].fileUrl;
		var fileName = filemsg.instance[0].filename;
		if(fileName.length > 25){
			$.alert("${ctp:i18n('cip.scheme.param.config.namelen')}");
			return
		}else{
			$("#tab2").attr("title",fileName);
			if(fileName.length >20){
				$("#tab2").html(""+fileName.substring(0,19)+"...<input type='hidden'  id="+fileId+" value="+fileName+">");
			}else{
				$("#tab2").html(""+fileName+"<input type='hidden'  id="+fileId+" value="+fileName+">");
			}
			$("#viewid").val(fileId);
			$("#extAttr2").val(fileName);
			var sync = new cipSynSchemeManager();
			sync.copyFile(fileId,fileId);
		}
	}
}

$().ready(function() {
	var schemeManager = new cipSynSchemeManager();
    $("#schemeForm").hide();
    $("#button").hide();
    function addform(){
        $("#schemeForm").clearform({clearHidden:true});
        $("#schemeForm").enable();
        $("#schemeForm").show();
        $(".synMode").val("1");
		$("#name").attr("disabled",false);
		$("#systemCode").attr("disabled",false);
		checkRadio(1);
		$("#dbpwd").val("");
		$("#dbpwd1").val("");
        $("#interfaceSetting").val("${ctp:i18n('cip.scheme.param.config.isonf')}");
        $("#interface_tr").hide();
        $(".interface").attr("disabled","disabled");
        $("#direction").val(1);
    	$("#driverMode").val(1);
        $("#button").show();
		loadView();
		aftShowView();
		$("#closeId").val("1");
		$("#view tr").find("td:eq(2)").find("input[type=checkbox]").attr("disabled","disabled");
		if($("#hrbl").val() == "true"){
		}else{
			$("#view tr").find("td:eq(4)").attr("disabled","disabled");
		}
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
                             schemeManager.deleteSchemes(v, {
                                 success: function() {
                                     $("#mytable").ajaxgridLoad(o);
                                     $("#button").hide();
                                     $("#schemeForm").hide();
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
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.config.name')}",
            sortable: true,
            name: 'name',
            width: '30%'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.config.product')}",
            sortable: true,
            name: 'productCode',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.scheme.param.config.sync')}",
            sortable: true,
            name: 'direction',
            width: '20%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynDirectionEnum',query:'true'"
        },
        {
            display: "${ctp:i18n('cip.scheme.param.config.synctype')}",
            sortable: true,
            name: 'synMode',
            width: '15%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynModeEnum',query:'true'"
        }
        ],
        managerName: "cipSynSchemeManager",
        managerMethod: "showSchemes",
        parentId:'center'     
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('down');
    function gridclk(data, r, c) {
        $("#schemeForm").disable();
        $("#schemeForm").show();
        $("#button").hide();
        $("#welcome").hide();
        $("#schemeForm").clearform({clearHidden:true});
        var schemedetil = schemeManager.viewScheme(data.id);
        $("#addForm").fillform(schemedetil);
        if(schemedetil.direction==true){
        	$("#direction").val(1);
        }
        if(schemedetil.driverMode==true){
        	$("#driverMode").val(1);
        }
        $("#interface_tr").hide();
        //显示注册系统信息
        showRegisterSystemInfo(schemedetil.extAttr1);
		loadView();
		aftShowView();
		//checkRadio(0);
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
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('cip.scheme.param.config.name')}",
          value: 'name',
          maxLength:100
        },
      {
        id: 'search_product',
        name: 'search_product',
        type: 'input',
        text: "${ctp:i18n('cip.scheme.param.config.product')}",
        value: 'productCode',
        maxLength:255
      },
      {
        id: 'search_direction',
        name: 'search_direction',
        type: 'select',
        text: "${ctp:i18n('cip.scheme.param.config.sync')}",
        value: 'direction',
        codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynDirectionEnum'"
      },
      {
          id: 'search_syn',
          name: 'search_syn',
          type: 'select',
          text: "${ctp:i18n('cip.scheme.param.config.synctype')}",
          value: 'synMode',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.organization.enums.SynModeEnum'"
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
            var schemedetil = schemeManager.viewScheme(v[0]["id"]);
            
            $("#schemeForm").clearform({clearHidden:true});
            $("#addForm").fillform(schemedetil);
            $("#schemeForm").enable();
            var isReference=schemeManager.isReference(v[0]["id"]);
            if(isReference==true){
            	$("#systemCode").attr("disabled","disabled");
            	$("#name").attr("disabled","disabled");
            }
            if(schemedetil.direction==true){
            	$("#direction").val(1);
            }
            if(schemedetil.driverMode==true){
            	$("#driverMode").val(1);
            }
            showRegisterSystemInfo(schemedetil.extAttr1);
            $("#schemeForm").show();
            $("#button").show();
            $("#interface_tr").hide();
            $(".interface").attr("disabled","disabled");
            $("#schemeForm").resetValidate();
			loadView();
			aftShowView();
			checkRadio($("#synMode").val());
			$("#view tr").find("td:eq(2)").find("input[type=checkbox]").attr("disabled","disabled");
			if($("#hrbl").val() == "true"){
			}else{
				$("#view tr").find("td:eq(4)").attr("disabled","disabled");
			}
		}
		$(".product").attr("disabled","disabled");
	}
    

    $("#btncancel").click(function() {
        location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#schemeForm").validate())){ 
          return;
        }
		$("#closeId").val("0");
		save();
		
    });
    $("#systemCode").click(function(){
    	$("#schemeForm").resetValidate();
    	var dialog = getCtpTop().$.dialog({
            url:"${path}/cip/base/instance.do?method=showInstances",
            width: 800,
            height: 400,
            title: "选择注册系统",//选择注册系统
            buttons: [{
                text: "${ctp:i18n('common.button.ok.label')}", //确定
                isEmphasize: true,
                handler: function () {
                   var rv = dialog.getReturnValue();                       
                   if(rv!=false&&rv!=null){
                	   //{"sysId":v[0].id,"systemCode":v[0].systemCode,"productCode":v[0].productCode,"productVersion":v[0].productVersion};
                        $("#extAttr1").val(rv.sysId);
                        $("#systemCode").val(rv.systemCode);
                        $("#productCode").val(rv.productCode);
                        $("#productVersion").val(rv.productVersion);
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
	
	//保存方法
	function save(){
		goXmlString();//扩展信息生成xml文件
		var rep = $("#rep").val();//获取重复标识
		if( rep == "1"){
			var pv = $("#dbpwd1").val();//获取显示密码值
			$("#dbpwd").val(pv);
			if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
			schemeManager.saveScheme($("#schemeForm").formobj(), {
				success: function(rel) {
					try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
					$("#mytable").ajaxgridLoad(o);
					location.reload();                
				}
			}); 
		}else{
			$.alert("${ctp:i18n('cip.scheme.param.name.rep')}")
		}
	}
	function showRegisterSystemInfo(sysId){
		var rm = new registerManager();
	    var registerSysVO = rm.getRegisterInstance(sysId);
	    $("#extAttr1").val(sysId);
	    if(registerSysVO!=null){
	    $("#systemCode").val(registerSysVO.appCode);
	    $("#productCode").val(registerSysVO.productCode);
	    $("#productVersion").val(registerSysVO.versionNO);
	    }
	}
});

	
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
	<input type="hidden" name="closeId" id="closeId" value="0" />
	<input type="hidden" name="hrbl" id="hrbl" value="${hrbl}" />
	<input type="hidden" name="rep" id="rep" value="1" />
    <div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
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
                    <div id="schemeForm" class="form_area" style="overflow-y:hidden">
						<input type="hidden" id="schemeFormVal">
                        <%@include file="schemeForm.jsp"%></div>
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
<script type="text/javascript">
	//返回xml格式信息
	function goXmlString(){
		var trl = $("#view tr").length;
		var stringbuffer = new StringBuffer();
		stringbuffer.append("[");
		var ary=new Array(); 
		for(var i = 1 ; i < trl; i++){
			var trid = $("#view tr:eq("+i+")") ;
			var t1 = trid.find("td:eq(0)").html();
			var t2 = trid.find("td:eq(1)").html();
			var t = trid.find("td:eq(2)").find("input[type=checkbox]").is(':checked') ;
			var t3 ;
			if(trid.find("td:eq(2)").find("input[type=checkbox]").is(':checked') == true){
				t3 = 0 ;
			}else{
				t3 = 1;
			}
			var t4 ;
			if(trid.find("td:eq(3)").find("select option").is(':selected') == true){
				t4 = trid.find("td:eq(3)").find("select option:selected").val() ;
			}else{
				t4 = "";
			}
			var t5 ;
			if(trid.find("td:eq(4)").find("input[type=checkbox]").is(':checked') == true){
				t5 = 0 ;
			}else{
				t5 = 1;
			}
			//拼接数据
			stringbuffer.append("{\"en\":");
	        stringbuffer.append("\""+t1+"\",");
	        stringbuffer.append("\"cn\":");
	        stringbuffer.append("\""+t2+"\",");
	        stringbuffer.append("\"extend\":");
	        stringbuffer.append("\""+t3+"\",");
	        stringbuffer.append("\"addr\":");
	        stringbuffer.append("\""+t4+"\",");
	        stringbuffer.append("\"hr\":");
	        stringbuffer.append("\""+t5+"\"}");
	        if(i!=trl){
	        	stringbuffer.append(",");
	        }
			ary[i] = t4;
		}
		stringbuffer.append("]");
	    var json = eval('(' +stringbuffer.toString()+ ')'); 
	    var jsonString = JSON.stringify(json);
		checkData(ary);
		$("#personnInforConfig").val(jsonString);
	}
	
	function checkData(ary){
		var nary=ary.sort(); 
		for(var i=0;i<ary.length-1;i++){ 
			if(nary[i] == null || nary[i] == ""){
			}else{
				if (nary[i]==nary[i+1] ){ 
					$("#rep").val("2");
				} 
			}
		}
	}
	//扩展信息change绑定事件  选择下拉时，重复标识置为1
	function changeRp(){
		$("#rep").val("1");
	}
</script>
</html>