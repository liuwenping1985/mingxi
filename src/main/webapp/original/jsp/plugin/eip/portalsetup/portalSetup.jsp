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
var _managerName = "eipPortalSetupManager";
var ColumnManager = RJS.extend({
	jsonGateway : ajaxUrl + _managerName,
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
	checkEmpower : function() {
		return this.c(arguments, "checkEmpower");
	}
});
var AppColumnManager = RJS.extend({
	jsonGateway : ajaxUrl + "eipPortalAppManager",
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
        
        $("#portalCode").attr("readonly",false);
		$("#portalCode").attr("style","background:#FFFFFF");
       
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
                }else if(v.length > 1){
                	 $.alert("${ctp:i18n('once.selected.one.record')}");
                } else {
                	var ids = "";
                	for(var i in v){
                		if(v[i]){
                			ids += v[i].id+",";
                		}
                	}
                	var objParam = new Object();
				    objParam = $.parseJSON("{'portalCode':'" + v[0].portalCode +"'}");
				    var appColumnManager = new AppColumnManager();
				    var postdetil = appColumnManager.checkColumn(objParam);
				    if(postdetil>0){
				    	$.alert("门户已被引用！无法删除！");
				    	return;
				    }else{
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
	                 }
                };
            }
        },
        {
            id: "preview",
            name: "预览",
            className: "ico16 preview_16",
            click: previewlick
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
            /*门户编码*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "门户编码",
            sortable: true,
            name: 'portalCode',
            width: '10%'
        },
        {
            /*门户名称*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "门户名称",
            sortable: true,
            name: 'portalName',
            width: '15%'
        },
        {
            /*门户模板*/
            display: "门户模板",
            sortable: true,
            name: 'templateId',
            hide: true,
            width: '10%'          
        },
        	/*门户模板 */
        {
            display: "门户模板 ",
            sortable: true,
            name: 'templateCode',
            width: '15%'          
        },
        {
        	/*授权id值，多值已逗号分隔存储*/
            display: "授权",
            sortable: true,
            name: 'empowerIds',
            hide: true,
            width: '10%'          
        },
        {
        	/*授权*/
            display: "授权",
            sortable: true,
            name: 'empowerIds_txt',
            width: '25%'          
        },
        {
        	/*是否启用*/
            display: "状态",
            sortable: true,
            name: 'isEnable',
            width: '10%',
            align : 'center',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'"     
        }
        ],
        managerName: _managerName,
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
        	/*门户编码*/
          id: 'search_portalCode',
          name: 'search_portalCode',
          type: 'input',
          text: "门户编码",
          value: 'portalCode'
        },{
        	/*门户名称*/
          id: 'search_portalName',
          name: 'search_portalName',
          type: 'input',
          text: "门户名称",
          value: 'portalName'
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
            $("#empowerIds").comp({
                value: mpostdetil.empowerIds,
                text: mpostdetil.empowerIds_txt
              });
            $("#empowerIds").val(mpostdetil.empowerIds);
            
            $("#portalCode").attr("readonly",true);
			$("#portalCode").attr("style","background:#F8F8F8");
            
            //$("#memberCode,#erpPersonCode,#deptName,#erpDeptName,#unitName,#erpUnitName").disable();
            $("#_ColumnForm").enable();
            $("#_ColumnForm").show();
            $("#button").show();
            $("#welcome").hide();
        }
    }
    
    //预览
    function previewlick() {
       //alert("previewlick");
       //zyPortalController.do?method=zyPortalMain
       var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        var width = document.body.clientWidth - 50;
 		var height = document.body.clientHeight - 50;
        if (v.length < 1) {
            $.alert("请选择您要预览的数据！");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
        	var dialog = getA8Top().$.dialog({
	            url:"${path}/zyPortalController.do?method=zyPortalViewMain&id="+v[0].id,
	                width: width,
	                height: height,
	                title: "门户预览",//选择门户模板
	                buttons: [ {
	                    text: "${ctp:i18n('common.button.cancel.label')}", //取消
	                    handler: function () {
	                        dialog.close();
	                    }
	                }]
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
        if($("#templateCode").val()=="" || $("#isEnable").val()==""){
            $.alert("请选择！门户模板和状态!");
            return;
        }
        
        //门户code检查
        var id = $("#id").val();
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
        }
        //验证templateCode
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          
        // 去除模板不能重复引用
        /* var id = $("#id").val();
	    var objParam = new Object();
	    objParam = $.parseJSON("{'templateCode':'" + $("#templateCode").val() +"'}");
	    var postdetil = mManager.checkColumn(objParam);
        if(id){
	        if(postdetil > 0 && v[0].templateCode!=$("#templateCode").val()){
	        $.alert("请重新选择门户模板！编号已存在！");
	        return;
	    }
        }else {
        	if(postdetil > 0){
		        $.alert("请重新选择门户模板！编号已存在！");
		        return;
		    }
        } */
        
        //验证权限
        /* objParam = $.parseJSON("{'id':'" + id + "','empowerIds':'" + $("#empowerIds").val() +"','empowerIds_txt':'" + $("#empowerIds_txt").val() +"'}");
	    postdetil = mManager.checkEmpower(objParam);
	    if(postdetil != ''){
		    $.alert("您可能重复授权！"+postdetil);
		    return;
		} */
		
		//权限设置验证
		var empowerIds = $("#empowerIds").val();
		if(!empowerIds || empowerIds==''){
			$.alert("请对门户授权！");
		    return;
		}
        
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        mManager.updateColumn($("#addForm").formobj(), {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                searchHandlerMy();
                addform();
                $.alert("保存成功！");
                //if(rel=='${ctp:i18n("nc.org.user.editsuccess")}'||rel=='${ctp:i18n("nc.user.mapper.success")}'){
                //location.reload();                
            }
        });                                                                                    
    });
    
    //弹出窗口
    $("#templateCode").click(function(){
        /* if($("#accountId").val()==""){
            $.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
            return;
        } */
        var ids = $("#templateId").val();
        var dialog = getA8Top().$.dialog({
            url:"${path}/eipPortalTemplateController.do?method=mainBox&isEnable=0&ids="+ids,
                width: 800,
                height: 500,
                title: "选择门户模板",//选择门户模板
                buttons: [{
                    text: "${ctp:i18n('common.button.ok.label')}", //确定
                    handler: function () {
                       var rv = dialog.getReturnValue();
                       if(rv!=false){
                           $("#templateId").val(rv.id);
                           $("#templateCode").val(rv.templateCode);
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
    
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});

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
                                        	门户设置 
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14" >
						                                【业务规范】
							       <br>1、一个企业信息门户由绑定的门户模板提供前端展现样式和布局，由与其关联的栏目内容设置提供门户信息内容
							       <br>2、同一个模板不允许被多个企业信息门户绑定
							       <br>3、只有已启用的信息门户可使用
							       <br>4、只有被授权的用户可以进入企业信息门户
								<br>【数据规范】
						          <br>1、门户编码，手工输入，必填
						          <br>2、门户名称，手工输入，必填
						          <br>3、门户模板，下拉选择，只有已启用的模板可选择，必填
						          <br>4、授权：点击进入授权设置，可授权单位、部门、组、岗位、职务和内外部人员，见右下侧图示。必填
						          <br>5、状态：启用/停用，默认启用
								<br>【检验规则】
						           <br>1、已被引用的门户，不能删除，仅可更改授权范围和状态
            
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="_ColumnForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="portalSetupForm.jsp"%></div>
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