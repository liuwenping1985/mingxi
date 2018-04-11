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
<script type="text/javascript"
		src="/seeyon/ajax.do?managerName=roleManager,orgManager,accountCfgManager"></script>
<script type="text/javascript">
/**
 * 根据字段id，获取字段信息并填充到字段内容区域 //TODO
 * 
 * @param columnId 字段Id
 */
 //定义manager
var ColumnManager = RJS.extend({
	jsonGateway : ajaxUrl + "eipPortalTemplateManager",
	updateColumn : function() {
		return this.c(arguments, "saveOrUpdateColumn");
	},
	createColumn : function() {
		return this.c(arguments, "createColumn");
	},
	deleteColumn : function() {
		return this.c(arguments, "deleteColumn");
	},
	getColumnLists : function() {
		return this.c(arguments, "getColumnLists");
	},
	getColumnToJSON : function() {
		return this.c(arguments, "getColumnToJSON");
	},
	getColumnById : function() {
		return this.c(arguments, "getColumnById");
	},
	checkColumn : function() {
		return this.c(arguments, "checkColumn");
	}
});
var SetupColumnManager = RJS.extend({
	jsonGateway : ajaxUrl + "eipPortalSetupManager",
	checkColumn : function() {
		return this.c(arguments, "checkColumn");
	}
});
var mManager = null;
$().ready(function() {
    var total = '${ctp:i18n("info.totally")}';
    mManager=new ColumnManager(); 
    //表单id
    $("#_ColumnForm").hide();    
    $("#button").hide();
    //新建
    function addform(){
        $("#_ColumnForm").clearform({clearHidden:true});
        $("#_ColumnForm").enable();
        $("#_ColumnForm").show();
        $("#welcome").hide();
        $("#button").show();
       
       	$("#templateCode").attr("readonly",false);
		$("#templateCode").attr("style","background:#FFFFFF");
       
        mytable.grid.resizeGridUpDown('middle');
    }
    //顶端功能条
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
                }else if (v.length > 1) {
                    $.alert("${ctp:i18n('once.selected.one.record')}");
                } else {
                	var ids = "";
                	var templateCodes = "";
                	for(var i in v){
                		if(v[i]){
                			ids += v[i].id+",";
                			templateCodes += v[i].templateCode+",";
                		}
                	}
                	var objParam = new Object();
				    objParam = $.parseJSON("{'templateCode':'" + v[0].templateCode +"'}");
				    var setupColumnManager = new SetupColumnManager();
				    var postdetil = setupColumnManager.checkColumn(objParam);
				    if(postdetil>0){
				    	$.alert("模板已被引用！无法删除！");
				    	return;
				    }else{
				    	$.confirm({
	                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
	                        ok_fn: function() {
	                            var mManager = new ColumnManager();
	                            mManager.deleteColumn(ids, {
	                                success: function() {
	                                	var b = false;
								        $.ajax({
										    url:"${path}/eipPortalTemplateController.do?method=deleteDir&templateCode="+v[0].templateCode,
										    data:'',  
										    type:"GET",
										    async:false, 
										    dataType :'text',   
										    success:function(result){
										    	if(result != 'true'){
										    		$.alert("模板文件目录删除失败！请手动清理");
										    		return;
										    	}else{
										    		$.alert("删除成功！");
										    	}
											}
										});
	                                    $("#mytable").ajaxgridLoad(o);
	                                    $("#_ColumnForm").hide();
	                                    $("#button").hide();
	                                    $("#welcome").show();
	                                }
	                            });
	                        }
	                    });
				    }
                };
            }
        },
        {
            id: "load",
            name: "载入",
            className: "ico16 import_16",
            click: loadclick
        },
        {
            id: "export",
            name: "导出",
            className: "ico16 export_16",
            click: exportclick
        },
        {
            id: "templateDetection",
            name: "模板检测",
            className: "ico16 statistics_16",
            click: templateDetectionclick
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
            /*模板编号*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "模板编号",
            sortable: true,
            name: 'templateCode',
            align: 'center',
            width: '10%'
        },
        {
            /*模板名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "模板名称",
            sortable: true,
            name: 'templateName',
            align: 'center',
            width: '10%'
        },
        {
            /*行业分类 枚举值*/
            display: "行业分类",
            sortable: true,
            name: 'industrySort',
            width: '10%',
			align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalTemplateIndustryEnum'"
        },
        {
            /*模板布局样式*/
            display: "模板布局样式",
            sortable: true,
            name: 'templateLayout',
            width: '10%'          
        },
        {
            /*模板Js*/
            display: "模板Js",
            sortable: true,
            name: 'templateJs',
            width: '10%'          
        },
        	/*模板样式 */
        {
            display: "模板样式 ",
            sortable: true,
            name: 'templateCss',
            width: '10%'          
        },
        {
        	/*模板图标*/
            display: "模板图标",
            sortable: true,
            name: 'templateIco',
            width: '10%'          
        }/* ,
        {
        	模板栏目id值，多值已逗号分隔存储
            display: "模板栏目",
            sortable: true,
            name: 'columnIds',
            align: 'center',
            hide: true,
            width: '10%'          
        } */,
        {
        	/*模板栏目id值，多值已逗号分隔存储*/
            display: "模板栏目",
            sortable: true,
            name: 'columnCodes',
            align: 'center',
            width: '10%'          
        },
        {
        	/*是否启用*/
            display: "状态",
            sortable: true,
            name: 'isEnable',
            width: '10%',
            align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"     
        },
        {
        	/*备注*/
            display: "备注",
            sortable: true,
            name: 'backUpValue',
            align: 'center',
            width: '10%'          
        }
        ],
        managerName: "eipPortalTemplateManager",
        managerMethod: "findPageColumns",
        parentId:'center',        
        slideToggleBtn: true,
        callBackTotle:getCount,
        vChange: true       
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 7,
        right: 10,
        searchHandler: function() {
        	searchHandlerMy();
        },
        conditions: [{
        	/*模板名称*/
          id: 'search_templateName',
          name: 'search_templateName',
          type: 'input',
          text: "模板名称",
          value: 'templateName'
        },{
        	/*模板编号*/
          id: 'search_templateCode',
          name: 'search_templateCode',
          type: 'input',
          text: "模板编号",
          value: 'templateCode'
        },{
        	/*行业分类 枚举值*/
          id: 'search_industrySort',
          name: 'search_industrySort',
          type: 'select',
          text: "行业分类",
          value: 'industrySort',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalTemplateIndustryEnum'"
        },{
        	/*是否启用*/
          id: 'search_isEnable',
          name: 'search_isEnable',
          type: 'select',
          text: "状态",
          value: 'isEnable',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"
        }]
        
      });
      //自定义查询事件
    function searchHandlerMy() {
          var returnValue = searchobj.g.getReturnValue();
          var objParam = new Object();
          if(returnValue != null && returnValue.value!="") {
              if (returnValue.condition.length > 0) {
               	objParam = $.parseJSON("{'"+ returnValue.condition + "':'" + returnValue.value.escapeJavascript() +"'}");
              }
          }
          $("#mytable").ajaxgridLoad(objParam);
    }
      //点击事件
    function gridclk(data, r, c) {
        $("#_ColumnForm").disable();
        $("#_ColumnForm").show();
        $("#button").hide();
        $("#welcome").hide();
        var postdetil = mManager.getColumnById(data.id);
        $("#addForm").fillform(postdetil);
        
        /* $("#orgMemberId").comp({
            value: postdetil.orgMemberId,
            text: postdetil.memberName
          }); *///选人组件赋值
        mytable.grid.resizeGridUpDown('middle');
    }
    
    // 双击修改
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
            var mpostdetil = mManager.getColumnById(v[0]["id"]);
            $("#_ColumnForm").clearform({clearHidden:true});
            $("#addForm").fillform(mpostdetil);
            
            $("#templateCode").attr("readonly",true);
			$("#templateCode").attr("style","background:#F8F8F8");
            /* $("#orgMemberId").comp({
                value: mpostdetil.orgMemberId,
                text: mpostdetil.memberName
              }); */
            //$("#memberCode,#erpPersonCode,#deptName,#erpDeptName,#unitName,#erpUnitName").disable();
            $("#_ColumnForm").enable();
            $("#_ColumnForm").show();
            $("#button").show();
            $("#welcome").hide();
        }
    }
    
    //载入
    function loadclick() {
       insertAttachmentPoi('5')
    }
    //导出
    function exportclick() {
    	var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("请选择您要导出的数据！");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
	       	//var b = ajaxUploadAddress('eipPortalTemplateController.do?method=exportPm&id='+v[0].id,'');
	       	var b = ajaxUploadAddress('eipPortalTemplateController.do?method=templateDetection&id='+v[0].id,'');
	       	b = $.parseJSON(b);
	       	if(b.b == 'true'){
		       	$.confirm({
		            	'msg': "您确定要导出此模板？",
			            ok_fn: function() {
			            	window.open('eipPortalTemplateController.do?method=exportPm&id='+v[0].id);
		        	}
		       });
	       	}else{
	       		$.alert("模板检测未通过！无法导出！"+b.msg);		
	       	}
			
        }
    }
    //模板检测
    function templateDetectionclick() {
       var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("请选择一条要检测的记录！");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
	       	var b = ajaxUploadAddress('eipPortalTemplateController.do?method=templateDetection&id='+v[0].id,'');
	       	b = $.parseJSON(b);
	       	if(b.b == 'true'){
	       		$.alert("模板检测通过！");		
	       	}else{
	       		
	       				$.confirm({
	                        'msg': "模板检测未通过！"+b.msg+" 是否尝试修复？",
	                        ok_fn: function() {
	                            url="${path}/eipPortalTemplateController.do?method=retrievalPm&isEnable=0&templateCode="+$("#templateCode").val()+"&id="+v[0].id;
                				var json = ajaxController(url, false);
                				if(json.b == true||json.b == "true"){
                					$.alert("模板修复成功！");
                				}else{
                					$.alert("模板修复失败！"+json.msg);
                				}
	                        }
	                    });
	                    //$.alert(b.msg);
				
	       	}
	       			
			//window.open('eipPortalTemplateController.do?method=exportPm&id='+v[0].id);
        }
    }
    
    
    $("#btncancel").click(function() {
    	$("#_ColumnForm").hide();    
    	$("#button").hide();
    	mytable.grid.resizeGridUpDown('down');
        $("#mytable").ajaxgridLoad(new Object());
    });
    $("#btnok").click(function() {  
        if(!($("#_ColumnForm").validate())){       
          return;
        }
        
        //分类选择判断
        if($("#industrySort").val()=="" || $("#isEnable").val()==""){
            $.alert("请选择！行业分类和状态值");
            return;
        }
        
        //模板code检查
        var id = $("#id").val();
	    var objParam = new Object();
	    objParam = $.parseJSON("{'templateCode':'" + $("#templateCode").val() +"'}");
	    var postdetil = mManager.checkColumn(objParam);
        if(!id){
	        if(postdetil > 0){
	        	$.alert("请重新输入！编号已存在！");
	            return;
	        }
        }else if(id){
        	if(postdetil > 1){
        		$.alert("请重新输入！编号已存在！");
	            return;
        	}
        }
        //上传文件 准备检查
        var b = false;
        $.ajax({
		    url:"${path}/eipPortalTemplateController.do?method=rename&templateCode="+$("#templateCode").val()+"&id="+id,
		    data:'',  
		    type:"GET",
		    async:false, 
		    dataType :'text',   
		    success:function(result){
		    	if(result != 'true'){
		    		$.alert("模板文件目录构建失败！");
		    		return;
		    	}
			}
		});
        
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        mManager.updateColumn($("#addForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                searchHandlerMy();
                addform();
                //$.alert("保存成功！");
                
                //模板备份
						$.confirm({
	                        'msg': "保存成功！是否备份模板？",
	                        ok_fn: function() {
	                            url="${path}/eipPortalTemplateController.do?method=retrievalPmB&isEnable=0&templateCode="+$("#templateCode").val()+"&id="+id;
                				var json = ajaxController(url, false);
                				if(json.b == true||json.b == "true"){
                					$.alert("模板备份成功！");
                				}else{
                					$.alert("模板备份失败！"+json.msg);
                				}
	                        }
	                    });
                //if(rel=='${ctp:i18n("nc.org.user.editsuccess")}'||rel=='${ctp:i18n("nc.user.mapper.success")}'){
                //location.reload();                
            }
        });                                                                                    
    });
    
    //选择模板栏目
    $("#columnCodes").click(function(){
    	var v = $("#columnCodes").val();
    	if(!v){
    		v = "";
    	}
        var dialog = $.dialog({
            url:"${path}/eipPortalColumnController.do?method=mainBox&num=1&columnCodes="+v,
                width: 800,
                height: 500,
                title: "选择模板栏目",//选择模板栏目
                buttons: [{
                    isEmphasize:true,
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           //提示必要选择项 栏目内容
					        var templateCode = rv.columnCodes;
					        if(!templateCode || templateCode=='' || templateCode.indexOf("pl_login")==-1 
					        	|| templateCode.indexOf("pl_bulletin")==-1 || templateCode.indexOf("pl_news")==-1){
					        	if(templateCode.indexOf("pl_login")==-1 ){
						        	templateCode+="pl_login,";
					        	}
					        	if(templateCode.indexOf("pl_bulletin")==-1 ){
						        	templateCode+="pl_bulletin,";
					        	}
					        	if(templateCode.indexOf("pl_news")==-1 ){
						        	templateCode+="pl_news,";
					        	}
					        	$.alert("新闻/公告/登录信息栏目为必选项！已自动选择！");
					        }
					       
                           $("#columnCodes").val(templateCode);
                           $("#columnIds").val(rv.ids);
                           
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
    //上传文件 模板布局样式
    $("#templateLayout").click(function(){
        insertAttachmentPoi('1');
    });
    //上传文件 模板Js
    $("#templateJs").click(function(){
        insertAttachmentPoi('4');
    });
    //上传文件 模板样式
    $("#templateCss").click(function(){
        insertAttachmentPoi('2');
    });
    //上传文件 模板图标
    $("#templateIco").click(function(){
        insertAttachmentPoi('3');
    });
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});

//文件上传 模板布局样式
function templateLayoutUploadCallback(obj) {
	var attList = obj.instance;
	var len = attList.length;
	for(var i = 0; i < len; i++) {
		var att = attList[i];
		var fileID = att.fileUrl;
		var myDate = new Date();
		var result=myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate();
		var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : result;
					
		var downloadUrl = "";//"${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		
		downloadUrl = ajaxUploadAddress('eipPortalTemplateController.do?method=layoutUpload&type=jsp,xml&number=01&fileId='+fileID+'&templateCode='+$("#templateCode").val(),'');	
		downloadUrl = $.parseJSON(downloadUrl);
		if(downloadUrl.b == true || downloadUrl.b == 'true'){
			$("#templateLayout").val(downloadUrl.fileName);
		}else{
			$.alert(downloadUrl.msg);
			return;
		}
	}
}

//文件上传 模板Js
function templateJsUploadCallback(obj) {
	var attList = obj.instance;
	var len = attList.length;
	for(var i = 0; i < len; i++) {
		var att = attList[i];
		var fileID = att.fileUrl;
		var myDate = new Date();
		var result=myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate();
		var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : result;
					
		var downloadUrl = "";//"${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		
		downloadUrl = ajaxUploadAddress('eipPortalTemplateController.do?method=layoutUpload&type=js&number=01&fileId='+fileID+'&templateCode='+$("#templateCode").val(),'');	
		downloadUrl = $.parseJSON(downloadUrl);
		if(downloadUrl.b == true || downloadUrl.b == 'true'){
			$("#templateJs").val(downloadUrl.fileName);
		}else{
			$.alert(downloadUrl.msg);
			return;
		}
	}
}

//文件上传 模板图标
function templateCssUploadCallback(obj) {
	var attList = obj.instance;
	var len = attList.length;
	for(var i = 0; i < len; i++) {
		var att = attList[i];
		var fileID = att.fileUrl;
		var myDate = new Date();
		var result=myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate();
		var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : result;
					
		var downloadUrl = "";//"${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		
		downloadUrl = ajaxUploadAddress('eipPortalTemplateController.do?method=layoutUpload&type=css&number=01&fileId='+fileID+'&templateCode='+$("#templateCode").val(),'');
		downloadUrl = $.parseJSON(downloadUrl);
		if(downloadUrl.b == true || downloadUrl.b == 'true'){
			$("#templateCss").val(downloadUrl.fileName);
		}else{
			$.alert(downloadUrl.msg);
			return;
		}
	}
}

//文件上传 模板布局样式
function templateIcoUploadCallback(obj) {
	var attList = obj.instance;
	var len = attList.length;
	for(var i = 0; i < len; i++) {
		var att = attList[i];
		var fileID = att.fileUrl;
		var myDate = new Date();
		var result=myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate();
		var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : result;
					
		var downloadUrl = "";//"${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		
		downloadUrl = ajaxUploadAddress('eipPortalTemplateController.do?method=layoutUpload&type=png,jpg&number=01&fileId='+fileID+'&templateCode='+$("#templateCode").val(),'');				
		downloadUrl = $.parseJSON(downloadUrl);
		if(downloadUrl.b == true || downloadUrl.b == 'true'){
			$("#templateIco").val(downloadUrl.fileName);
		}else{
			$.alert(downloadUrl.msg);
			return;
		}
	}
}

//文件上传 载入
function loadUploadCallback(obj) {
	var attList = obj.instance;
	var len = attList.length;
	for(var i = 0; i < len; i++) {
		var att = attList[i];
		var fileID = att.fileUrl;
		
		var b = ajaxUploadAddress('eipPortalTemplateController.do?method=loadUpload&type=img&number=01&fileId='+fileID,'');				
		b = $.parseJSON(b);
		if(b.b == 'true'){
			var o = new Object();
	    	$("#mytable").ajaxgridLoad(o);
	    	//模板备份
	    				$.confirm({
	                        'msg': "载入成功！是否备份模板？",
	                        ok_fn: function() {
	                            url="${path}/eipPortalTemplateController.do?method=retrievalPmB&isEnable=0&templateCode="+b.templateCode;
                				var json = ajaxController(url, false);
                				if(json.b == true||json.b == "true"){
                					$.alert("模板备份成功！");
                				}else{
                					$.alert("模板备份失败！"+json.msg);
                				}
	                        }
	                    });
		}else{
			$.alert(b.msg);
		}
	}
}
//文件上传
function ajaxUploadAddress(url,data){
//var url = "zyPortalController.do?method=getLoginOthSystemUrl";
	var value = '';
	$.ajax({
	    url:url,
	    data:data,  
	    type:"GET",
	    async:false, 
	    dataType :'text',   
	    success:function(result){
	    	//result = $.parseJSON(result);
	    	value = result;
		}
	});
	return value;
}
/* 请求controller b同步还是异步 */
function ajaxController(url, b) {
	var json = null;
	$.ajax({
		url : url,
		data : '',
		type : "POST",
		async : b,
		dataType : 'text',
		success : function(result) {
			if (result) {
				result = $.parseJSON(result);
			}
			json = result;
		}
	});
	return json;
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <!-- <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_memberMapper'"></div> -->
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:auto">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                    <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                        门户模板配置
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14" >
                                    需求描述：
            <br>1）门户模板为用户提供大协同网站式门户基础支持，每个门户模板对应一种固化的网站式门户样式（含栏目）
            <br>2）门户中的栏目内容跨越协同边界，支持多系统的内容和信息展示。为用户提供企业/机构的统一信息入口平台。
            <br>3）本期预置两个模板。一个具有多系统集成特征，一个只有1-3个系统集成特征
                                    
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="_ColumnForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="portalTemplateForm.jsp"%></div>
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