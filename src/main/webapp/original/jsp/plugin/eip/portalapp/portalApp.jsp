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
	jsonGateway : ajaxUrl + "eipPortalAppManager",
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
	},
	empower : function() {
		return this.c(arguments, "empower");
	},
	isEnable : function() {
		return this.c(arguments, "isEnable");
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
       	
       	//默认值
       	$("#systemToken").val("EIP");
       	//图片清理
       	$("#iconDiv1").empty();
       	$("input:radio:first").attr('checked', 'checked');
       	
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
                } else {
                	var ids = "";
                	for(var i in v){
                		if(v[i]){
                			ids += v[i].id+",";
                		}
                	}
                    $.confirm({
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                            var mManager = new ColumnManager();
                            mManager.deleteColumn(ids, {
                                success: function() {
                                    $("#mytable").ajaxgridLoad(o);
                                    $("#_ColumnForm").hide();
                                    $("#button").hide();
                                    $("#welcome").show();
                                }
                            });
                        }
                    });
                };
            }
        },
        {
			id : "enable",
			name : '启用',
			className : "ico16 participate_16",
			click : function() {
				enableclick();
			}
		},{
			id : "notenable",
			name : '停用',
			className : "ico16 unparticipate_16",
			click : function() {
				notenableclick();
			}
		},{
			id : "empower",
			name : '授权',
			className : "ico16 authorize_16",
			click : function() {
				empowerclick();
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
       /*  {
            //门户id ${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "模板id",
            sortable: true,
            name: 'portalId',
            hide: true,
            width: '5%'
        }, */
        {
            /*门户编号*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "模板编号",
            sortable: true,
            name: 'portalCode',
            align: 'center',
            width: '10%'
        },
        /* {
            //栏目id ${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目id",
            sortable: true,
            name: 'columnCode',
            hide: true,
            width: '5%'
        }, */
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnName',
            align: 'center',
            width: '10%',
		    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" 
        },
        {
            /*应用名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "应用名称",
            sortable: true,
            name: 'appSystemName',
            align: 'center',
            width: '10%'
        },
        /* {
            //内容id ${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "内容id",
            sortable: true,
            name: 'columnDetailId',
            hide: true,
            width: '5%'
        }, */
        {
            /*内容名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "内容名称",
            sortable: true,
            name: 'columnDetailName',
            align: 'center',
            width: '10%'
        },
        {
            /*序号*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "序号",
            sortable: true,
            name: 'appSystemCode',
            align: 'center',
            width: '5%'
        },
        {
            /*系统标识*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "系统标识",
            sortable: true,
            name: 'systemToken',
            align: 'center',
            width: '5%'
        },
        {
        	/*是否启用*/
            display: "状态",
            sortable: true,
            name: 'isEnable',
            align: 'center',
            width: '10%',
            align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"     
        },
        {
            /*图标*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "图标",
            sortable: true,
            name: 'appIcon',
            align: 'center',
            width: '5%'
        },
        {
            /*图片*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "图片",
            sortable: true,
            name: 'systemImg',
            width: '5%'
        },
        {
            /*图片规格*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "图片规格",
            sortable: true,
            name: 'systemImgSpec',
            align: 'center',
            width: '5%'
        },
        /* {
        	// 授权id值，多值已逗号分隔存储
            display: "授权",
            sortable: true,
            name: 'empowerIds',
            align: 'center',
            hide: true,
            width: '10%'          
        }, */
        {
        	/*授权*/
            display: "授权",
            sortable: true,
            name: 'empowerIds_txt',
            align: 'center',
            width: '10%'        
        }/* ,
        {
        	//备用值
            display: "备用值",
            sortable: true,
            name: 'backUpValue',
            align: 'center',
            hide: true,
            width: '10%'        
        } */
        ],
        managerName: "eipPortalAppManager",
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
        searchHandler: searchHandlerMy,
        conditions: [{
        	/*应用名称*/
          id: 'search_appSystemName',
          name: 'search_appSystemName',
          type: 'input',
          text: "应用名称",
          value: 'appSystemName'
        },{
        	/*系统标识*/
          id: 'search_systemToken',
          name: 'search_systemToken',
          type: 'input',
          text: "系统标识",
          value: 'systemToken'
        },{
        	/*栏目名称*/
          id: 'search_columnCode',
          name: 'search_columnCode',
          type: 'select',
          text: "栏目名称",
          value: 'columnCode',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'"
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
        //初始化图标
        $("input:radio").each(function(index,domEle){
			if($(this).val()==postdetil.appIcon){
				$(this).prop("checked",true);
			}
		});
        //初始化图片数据
        var url = createImage(postdetil.systemImg);
		$("#iconDiv1").html(url);
		
		//初始化显示
		init(postdetil.columnCode);
		
		//初始化内容
		$("#columnDetailName").html(postdetil.columnDetailName);
		
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
            
            //选人控件初始值
            $("#empowerIds").comp({
                value: mpostdetil.empowerIds,
                text: mpostdetil.empowerIds_txt
              });
            
            //初始化图标
	        $("input:radio").each(function(index,domEle){
				if($(this).val()==mpostdetil.appIcon){
					$(this).prop("checked",true);
				}
			});
              
            //初始化图片数据
       	 	var url = createImage(mpostdetil.systemImg);
			$("#iconDiv1").html(url);
			
			//初始化systemImgSpec
			$("#systemImgSpec").attr("style","background:#F8F8F8");
			
			//初始化显示
			init(mpostdetil.columnCode);
			
            //$("#memberCode,#erpPersonCode,#deptName,#erpDeptName,#unitName,#erpUnitName").disable();
            $("#_ColumnForm").enable();
            $("#_ColumnForm").show();
            $("#button").show();
            $("#welcome").hide();
        }
    }
    
    //启用
    function enableclick() {
       	var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }/* else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        } */else{
        	var confirm = $.confirm({
	            'msg' : '启用板块！',
	            ok_fn : function() {
	            	var ids = '';
					for(var i=0; i<v.length ;i++){
						ids += v[i].id +',';
				    }
			       	
				   	//var postdetil = mManager.checkColumn(objParam);
		        	var isEnable = "0";
		        	var objParam = new Object();
				   	objParam = $.parseJSON("{'ids':'" + ids +"','isEnable':'"+isEnable+"'}");
				   	var eb = mManager.isEnable(objParam);
					if(eb !=true){
						$.alert("启用失败！");
						return;
					}else{
					    $.alert("启用成功！");
						$("#mytable").ajaxgridLoad(new Object());
					}
	            },
	            cancel_fn : function() {
	            }
	        });
        }
    }
    //停用
    function notenableclick() {
       var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }/* else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        } */else{
        	var confirm = $.confirm({
	            'msg' : '停用板块！',
	            ok_fn : function() {
	            	var ids = '';
					for(var i=0; i<v.length ;i++){
						ids += v[i].id +',';
				    }
			       	
				   	//var postdetil = mManager.checkColumn(objParam);
		        	var isEnable = "1";
		        	var objParam = new Object();
				   	objParam = $.parseJSON("{'ids':'" + ids +"','isEnable':'"+isEnable+"'}");
				   	var eb = mManager.isEnable(objParam);
					if(eb !=true){
						$.alert("停用失败！");
						return;
					}else{
					    $.alert("停用成功！");
						$("#mytable").ajaxgridLoad(new Object());
					}
	            },
	            cancel_fn : function() {
	            }
	        });
        }
    }
    //授权
    function empowerclick() {
       //alert("empowerclick");
       var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('post.chosce.modify')}");
        }/* else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        } */else{
        
            var ids = '';
			for(var i=0; i<v.length ;i++){
				ids += v[i].id +',';
		    }
	       	
		   	//var postdetil = mManager.checkColumn(objParam);
        	var empower = v[0].empowerIds;
			var empowerTxt = v[0].empowerIds_txt;
			var peoples = $.selectPeople({
				panels: 'Account,Department,Team,Post,Level,Outworker',
				selectType: 'Account,Department,Member,Team,Post,Level',//Account,Department,Team,Post,Level,
				hiddenPostOfDepartment:true,
				isNeedCheckLevelScope:false,
				showAllOuterDepartment:true,
				params : {
				       text : empowerTxt,
				       value : empower
				     },
				minSize:0,
				callback : function(ret) {
					var objParam = new Object();
		   			objParam = $.parseJSON("{'ids':'" + ids +"','empowerIds':'"+ret.value+"','empowerIds_txt':'"+ret.text+"'}");
		   			var eb = mManager.empower(objParam);
			        if(eb !=true){
				        $.alert("授权失败！");
				        return;
			        }else{
			        	$.alert("授权成功！");
				        var o = new Object();
    					$("#mytable").ajaxgridLoad(o);
			        }
				}
			});
        	
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
        if( $("#isEnable").val()==""){
            $.alert("请选择！状态值！");
            return;
        }
        
       
        
        //URL判断 http://或https://开头，或配置内部链接/seeyon开头
        var url = $("#columnDetailName").val();
        if(url){
        	if(checkURL(url)||url.indexOf('/seeyon')>-1||url=='#'|| $("#columnCode").val() == "pl_news" || $("#columnCode").val() == "pl_bulletin"
        	|| $("#columnCode").val() == "pl_logo" || $("#columnCode").val() == "pl_copyright" || $("#columnCode").val() == "pl_login"){
        		
        	}else{
        		$.alert("输入地址（内容地址-http://或https://开头，或配置内部链接/seeyon开头）不合法,请重新输入！！");
        		return ;
        	}
        }
        
        //模板code检查
        /* var id = $("#id").val();
	    var objParam = new Object();
	    objParam = $.parseJSON("{'portalCode':'" + $("#portalCode").val() +"'}");
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
        } */
        //序号检查 appSystemCode columnCode portalCode
        var id = $("#id").val();
	    var objParam = new Object();
	    objParam = $.parseJSON("{'portalCode':'" + $("#portalCode").val() +"','columnCode':'" + $("#columnCode").val() +"','appSystemCode':" + $("#appSystemCode").val() +"}");
	    var postdetil = mManager.checkColumn(objParam);
        if(!id){
	        if(postdetil > 0){
		        $.alert("请重新输入！序号已存在！");
		        return;
		    }
        }else if(id){
        	var v = $("#mytable").formobj({
	            gridFilter : function(data, row) {
	              return $("input:checkbox", row)[0].checked;
	            }
	          });
	        var appSystemCode = $("#appSystemCode").val();
	        if(v[0].appSystemCode != appSystemCode){
	        	if(postdetil > 0){
		        	$.alert("请重新输入！序号已存在！");
		            return;
		        }
	        }else{
	        	if(postdetil > 1){
		        	$.alert("请重新输入！序号已存在！");
		            return;
		        }
	        }
        }
        //新闻/公告 数据判断
        objParam = $.parseJSON("{'portalCode':'" + $("#portalCode").val() +"','columnCode':'" + $("#columnCode").val() +"'}");
	    postdetil = mManager.checkColumn(objParam);
        if(("pl_news" == $("#columnCode").val()||"pl_bulletin" == $("#columnCode").val())){
	        if(id && postdetil > 1){
	        	if(id && postdetil > 2 && "pl_bulletin" == $("#columnCode").val()){
				    $.alert("已经分配了公告数据！公告数据不能超过2条！请删除多余数据后选择修改！");
				    return;
		        }else if("pl_news" == $("#columnCode").val()){
				    $.alert("已经分配了新闻/公告数据！请选择修改！");
				    return;
		        }
	        }else if(!id && postdetil > 0 && "pl_news" == $("#columnCode").val()){
	        	$.alert("已经分配了新闻/公告数据！请选择修改！");
			    return;
	        }else if(!id && postdetil >= 2 && "pl_bulletin" == $("#columnCode").val()){
	        	$.alert("已经分配了新闻/公告数据！请选择修改！");
			    return;
	        }
		}
		
		//权限为空判断
		var empowerIds_txt = $("#empowerIds_txt").val();
		if(!empowerIds_txt || empowerIds_txt==''){
			$.alert("请对栏目内容授权！");
		    return;
		}
		
		//图片上传判断
		var systemImg = $("#systemImg").val();
		var columnCode = $("#columnCode").val()
		if((columnCode == "pl_Publicity" || columnCode == "pl_special" 
    		|| columnCode == "pl_logo" || columnCode == "pl_contactway")&&(!systemImg || systemImg=='')){
			$.alert("请上传对应格式大小的图片！！");
		    return;
		}
		
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        mManager.updateColumn($("#addForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                //$("#mytable").ajaxgridLoad(o);
                //if(rel=='${ctp:i18n("nc.org.user.editsuccess")}'||rel=='${ctp:i18n("nc.user.mapper.success")}'){
                //$("#mytable").ajaxgridLoad(new Object());
                searchHandlerMy();
                addform();
                $.alert("保存成功！");
            }
        });                                                                                    
    });
    
    //门户选择（门户信息）
    $("#portalCode").click(function(){
    	var ids = $("#portalId").val();
        var dialog = $.dialog({
            url:"${path}/eipPortalSetupController.do?method=mainBox&isEnable=0&ids="+ids,
                width: 800,
                height: 500,
                title: "选择门户",//选择门户
                buttons: [{
                    isEmphasize:true,
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           
                           $("#portalCode").val(rv.portalCode);
                           $("#portalId").val(rv.id);
                           
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
    
    //栏目选择
    $("#columnName").click(function(){
        var columnCodes = $("#columnCode").val();
        var dialog = $.dialog({
            url:"${path}/eipPortalColumnController.do?method=mainBox&num=0&columnCodes="+columnCodes,
                width: 800,
                height: 500,
                title: "选择模板栏目",//选择模板栏目
                buttons: [{
                    isEmphasize:true,
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           
                           $("#systemImgSpec").val(rv.systemImgSpec);
                           $("#columnName").val(rv.columnName);
                           $("#columnCode").val(rv.columnCode);
                           
                           $("#columnDetailName").val("");
                           $("#columnDetailId").val("");
                           //判断内容是否显示
                           var columnCode = rv.columnCode;
                           init(columnCode);
                           
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
    
    //内容选择
    $("#columnDetailName").click(function(){
    	var columnName = $("#columnName").val();
    	var columnCode = $("#columnCode").val();
    	if(!columnName){
    		$.alert("请先选择栏目！");
    		return;
    	}
    	//弹出选择 pl-appsystem pl-affair pl-launch pl-query pl-board pl-tool pl_news pl_bulletin
    	if(columnCode == "pl_appsystem" || columnCode == "pl_affair" || columnCode == "pl_launch" 
    		|| columnCode == "pl_query" || columnCode == "pl_board" || columnCode == "pl_tool" 
    		|| columnCode == "pl_news" || columnCode == "pl_bulletin" || columnCode == "pl_databoard"){
    		$("#columnDetailName").attr("readonly",true);
    		var url = "${path}/eipPortalColumnDetailController.do?method=mainBox&num=0&columnId="+columnCode; 
    		if(columnCode == "pl_appsystem"){
    			url = "${path}/eipPortalAppController.do?method=thirdportalBox";
    		}
    		var dialog = $.dialog({
            url: url,
                width: 800,
                height: 500,
                title: "选择内容信息",//选择模板栏目
                buttons: [{
                    isEmphasize:true,
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           if(columnCode == "pl_appsystem"){
				    		   	$("#columnDetailName").val(rv.pcPageUrl);
                           	   	$("#columnDetailId").val(rv.id);
				    	   }else{
				    	       	$("#columnDetailName").val(rv.columnDetailUrl);
                           	   	$("#columnDetailId").val(rv.id);
				    	   }
                           
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
    	}else if(columnCode == "pl_commonsite" || columnCode == "pl_Publicity" || columnCode == "pl_special" || columnCode == "pl_contactway" ) {//手动输入 pl-commonsite pl-Publicity pl-special
    		$("#columnDetailName").attr("readonly",false);
			//$("#columnDetailName").attr("style","background:#F8F8F8");
    	}
        
    });
    
    //上传图片
    $("#iconDiv1").click(function(){
        var b = $("#systemImg").attr("disabled"); 
    	if(!b){
        	insertAttachment();
    	}
    });
    
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
    
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
					
		var downloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		//var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='140' height='75'>";
					
		//var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=rar";
		$("#templateLayout").val(downloadUrl)
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
					
		var downloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		//var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='140' height='75'>";
					
		//var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=rar";
		$("#templateCss").val(downloadUrl)
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
					
		var downloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=jsp";
		//var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='140' height='75'>";
					
		//var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=rar";
		$("#templateIco").val(downloadUrl)
	}
}

//初始化
function init(columnCode){
						   //判断是否显示内容
						   if(/* columnCode == "pl_appsystem" || */ columnCode == "pl_logo" || columnCode == "pl_copyright"
    							|| columnCode == "pl_login" ){
					       	   	$("#columnDetailName").parents("tr").fadeOut("slow");
					       }else{
					       		$("#columnDetailName").parents("tr").fadeIn("slow");
					       		//$("#columnDetailName").val("");
					       }
					       //判断系统标识是否显示
					       if(columnCode == "pl_appsystem" || columnCode == "pl_copyright" || columnCode == "pl_login" 
    							|| columnCode == "pl_logo" || columnCode == "pl_contactway"|| columnCode == "pl_news" 
    							|| columnCode == "pl_launch"|| columnCode == "pl_databoard"|| columnCode == "pl_Publicity"){//pl_contactway pl_databoard pl_Publicity
					       		$("#systemToken").parents("tr").fadeOut("slow");
					       		$("#systemToken").val("");
					       }else{
					       	   	$("#systemToken").parents("tr").fadeIn("slow");
					       }
                           //判断图片上传是否显示
                           if(columnCode == "pl_Publicity" || columnCode == "pl_special" 
    							|| columnCode == "pl_logo" || columnCode == "pl_contactway"){
					       	   	$("#systemImg").parents("tr").fadeIn("slow");
					       }else{
					       		$("#systemImg").parents("tr").fadeOut("slow");
					       		$("#systemImg").val("");
					       }
					       //判断是否显示图标
					       if(columnCode == "pl_Publicity" || columnCode == "pl_copyright" || columnCode == "pl_login" 
    							|| columnCode == "pl_logo" || columnCode == "pl_contactway"|| columnCode == "pl_news" 
    							|| columnCode == "pl_commonsite" || columnCode == "pl_special" || columnCode == "pl_appsystem"
    							|| columnCode == "pl_bulletin" || columnCode == "pl_databoard"|| columnCode == "pl_databoard"){//pl_contactway
					       		$("#_appIcon").fadeOut("slow");
					       		$("#_appIcon").val("");
					       }else{
					       	   	$("#_appIcon").fadeIn("slow");
					       }
					       //判断ico图标显示
					       if(columnCode == "pl_affair"||columnCode == "pl_query"||columnCode == "pl_launch"){
					       		$("div[name=_pl_affairICO]").fadeIn("slow");
					       }else{
					       		$("div[name=_pl_affairICO]").fadeOut("slow");
					       }
					       if(columnCode == "pl_board"){
					       		$("div[name=_pl_boardICO]").fadeIn("slow");
					       }else{
					       		$("div[name=_pl_boardICO]").fadeOut("slow");
					       }
					       if(columnCode == "pl_tool"){
					       		$("div[name=_pl_toolICO]").fadeIn("slow");
					       }else{
					       		$("div[name=_pl_toolICO]").fadeOut("slow");
					       }
}

/**
 * 验证网址（http://|https://）
 * @param obj
 * @returns {Boolean}
 */
function checkURL(obj){
    if(/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/.test(obj)){
        return true;
    }
    return false;
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
                                      	 栏目内容管理
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14" >
                                	【业务规范】
        								<br>1、固化现有栏目
								        <br>2、可以为每个栏目设置1-n个栏目内容
								        <br>3、每个栏目内容只能对应一个门户模板，栏目内容的样式由门户模板确定。
								
								<br>【数据规范】
								         <br>1、门户。已启用的企业信息门户中选择，弹出选择，必填
								         <br>2、栏目。预置的现有栏目，下拉选择，必填
								         <br>3、名称。手工输入，说明该栏目内容的用途，必填
								         <br>4、内容。不同的栏目必填，其输入规范不同：
							                   <!--  <br>A）栏目=我的待办：弹出选择框，选择内容包括公文代办、协同待办、会议待办、调查待办、综合办公待办、所有第三方待办（按系统分类）
							                    <br>B）栏目=我的发起：弹出选择框，选择内容包括所有表单、新建会议、拟文、新建目标任务、新建调查。菜单+表单模板。
							                    <br>C）栏目=我的查询：弹出选择框，选择内容包括已办公文、已发公文、已办事项、已发事项、所有表单查询
							                    <br>D）栏目=数据看板：弹出选择狂，选择内容包括所有已集成的帆软报表，所有表单统计，所有行为绩效入口
							                    <br>F）栏目=综合管理：弹出选择框，选择内容包括协同日程、通讯录、我的邮件、文档管理、综合查询、便签、万年历等所有协同工具
							                    <br>G）栏目=行业网站/常用网站/宣传栏目/专题工作，手工输入。
							                    <br>H）栏目=应用系统/版权信息/登陆信息/公司标志，不显示  -->
										<br>5、序号。排序号，手工输入，同一模板/栏目下不允许重复，必填
										<br>6、是否启用。单选，必填，默认启用
										<br>7、系统标识。
										          <!-- <br>A）栏目=应用系统/版权信息/登陆信息/公司标志，不显示
										          <br>B）其余栏目，手工输入，必填 -->
										<br>8、图标，每个门户模板对应一组图标，单选，必填
										<br>9、应用图片上传。栏目内容对应的图片
										         <!--  <br>A）栏目=行业网站、常用网站、宣传栏目、专题工作、版权信息、公司标志，选择本地文件上传，可选
										          <br>B）其余栏目，不显示 -->
										<br>10、图片规格，由栏目自动带出
										<br>11、授权。对该内容进行单位、部门、岗位、职务、组、人员授权
										
								<br>【校验规则】
										<br>1、同一模板/栏目下，栏目内容名称和序号不允许重复
										<br>2、已授权内容与用户OA授权的交集才是门户最终可见内容
										
								<br>【启用/停用/授权】
										<br>支持多选同时启用/停用/授权
										<br>内容管理，内容注册。
                             
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="_ColumnForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="portalAppForm.jsp"%></div>
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