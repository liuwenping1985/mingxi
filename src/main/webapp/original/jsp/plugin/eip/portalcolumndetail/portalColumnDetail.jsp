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
	jsonGateway : ajaxUrl + "eipPortalColumnDetailManager",
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
var mManager = null;
$().ready(function() {
    var total = '${ctp:i18n("info.totally")}';
    mManager=new ColumnManager(); 
    //表单id
    $("#_ColumnForm").hide();    
    $("#button").hide();
    //初始禁止填写项
    var b = false;
	init(b);
    //新建
    function addform(){
        $("#_ColumnForm").clearform({clearHidden:true});
        $("#_ColumnForm").enable();
        $("#_ColumnForm").show();
        $("#welcome").hide();
        $("#button").show();
       
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
                //判断可以删除的数据
                for(var i=0; i<v.length;i++){
                	if(!v[i].backUpValue0 || v[i].backUpValue0 =='' || checkMember(v[i].columnDetailTitle)){
	                	 $.alert("此内容为内置数据不可删除！");
	                	 return;
	                }
                }
                
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
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnId',
            hide: true,
            align: 'center',
            width: '10%'
        },
        {
            /*栏目名称*///${ctp:i18n('voucher.plugin.cfg.accountname.label')}
            display: "栏目名称",
            sortable: true,
            name: 'columnName',
            align: 'center',
            width: '10%',
		    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" 
        },
        {
            /*内容标题*///${ctp:i18n('voucher.plugin.cfg.unit.label')}
            display: "内容标题",
            sortable: true,
            name: 'columnDetailTitle',
            align: 'center',
            width: '20%',
		    codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnDetailEnum'" 
        },
        {
            /*内容URL*/
            display: "内容URL",
            sortable: true,
            name: 'columnDetailUrl',
            align: 'center',
            width: '30%',
        },
        	/*更多设置 */
        {
            display: "更多设置 ",
            sortable: true,
            name: 'moreSetup',
            align: 'center',
            width: '30%'          
        }
        ],
        managerName: "eipPortalColumnDetailManager",
        managerMethod: "findYPageColumns",
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
        	/*栏目名称 */
          id: 'search_columnId',
          name: 'search_columnId',
          type: 'select',
          text: "栏目名称",
          value: 'columnId',
          codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalUserColumnEnum'"
        }/* ,{
        	//内容标题
          id: 'search_columnDetailTitle',
          name: 'search_columnDetailTitle',
          type: 'input',
          text: "内容标题",
          value: 'columnDetailTitle'
        } */
        ]
        
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
        mytable.grid.resizeGridUpDown('middle');
    }
    
    // 双击修改
    function griddbclick() {//不允许修改
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
        	//判断可以修改的数据
            var columnDetailTitle = $("#columnDetailTitle").val();
            if(!v[0].backUpValue0 || v[0].backUpValue0 =='' || checkMember(columnDetailTitle)){
                $.alert("此内容为内置数据不可修改！");
                $("#_ColumnForm").disable();
		        $("#_ColumnForm").show();
		        $("#button").hide();
		        $("#welcome").hide();
		        $("#addForm").fillform(mpostdetil);
		        mytable.grid.resizeGridUpDown('middle');
                return;
            }
            init(b);
            $("#_ColumnForm").enable();
            $("#_ColumnForm").show();
            $("#button").show();
            $("#welcome").hide();
        }
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
        var postdetil = mManager.getColumnById($("#id").val());
        
        if($("#columnName") == ''){
        	$.alert("请选择栏目！");
        	return;
        }else{
        	$("#columnId").val($("#columnName").val());
        }
        
        //URL判断 http://或https://开头，或配置内部链接/seeyon开头
        var url = $("#columnDetailUrl").val();
        if(url){
        	if(checkURL(url)||url.indexOf('/seeyon')>-1){
        		
        	}else{
        		$.alert("输入地址（URL地址-http://或https://开头，或配置内部链接/seeyon开头）不合法,请重新输入！！");
        		return ;
        	}
        }
        
        //判断可以修改的数据
        var columnDetailTitle = $("#columnDetailTitle").val();
        if(checkMember(columnDetailTitle)){
            $.alert("内容标题不可以为纯数字格式！");
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
    
   //栏目选择
    /* $("#columnName").click(function(){
        var dialog = $.dialog({
            url:"${path}/eipPortalColumnController.do?method=mainBox&num=0",
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
                           $("#columnId").val(rv.columnCode);
                           
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
    }); */
    
    function getCount(){
        $("#count")[0].innerHTML = total.format(mytable.p.total);
    }
});
function init(b){
	//设置初始form表单情况
    
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
/**
 * 数值验证
 * @param obj
 * @returns {Boolean}
 */
function checkMember(obj){
    if(/^[0-9]*$/.test(obj)){
        return true;
    }
    return false;
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
                                      		内容设置 
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14" >
                                <br>【业务规范】
								      <br>1、选择某一栏目，为该栏目设置预设值
          
								<br>【数据规范】
							          <br>1、栏目名称，选择某一栏目,数据来源栏目设置中的固有栏目
							          <br>2、内容标题，栏目内容在该门户的显示名称，必填
							          <br>3、内容URL，栏目内容在该门户的链接，必填
							          <br>4、更多设置，备用“更多”关联的链接，可选
                                
                                </div>
                            </div>
                     </div>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="_ColumnForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="portalColumnDetailForm.jsp"%></div>
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