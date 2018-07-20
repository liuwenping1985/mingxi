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
	src="${path}/ajax.do?managerName=formDataMapperManager"></script>
<script type="text/javascript">
$().ready(function() {
	var total = '${ctp:i18n("info.totally")}';
	var fManager=new formDataMapperManager();
    function addform(){
    	/* $("#memberMapperForm").clearform({clearHidden:true});
    	$("#memberMapperForm").enable();
    	$("#memberMapperForm").show(); */
        mytable.grid.resizeGridUpDown('middle');
    }
    $("#toolbar").toolbar({
        toolbar: [{
            id: "add",
            name: "${ctp:i18n('common.toolbar.new.label')}",
            className: "ico16",
            click: function() {
            	var dialog = getA8Top().$.dialog({
            		url:"${path}/voucher/documnentationMapperController.do?method=addFormDataMapper",
        			    width: 1000,
        			    height: 600,
        			    title: "${ctp:i18n('voucher.formmapper.newcreate')}",//新建单据映射
        			    buttons: [{
        			        text: "${ctp:i18n('common.button.ok.label')}", //确定
        			        handler: function () {
        			           var rv = dialog.getReturnValue();
        			           if(rv!=false){
        			        	   dialog.close();
        			        	   fManager.saveFormDataMapper(rv,{
        			        		   success: function() {
                                           $("#mytable").ajaxgridLoad(o);
                                       }
        			        	   });
        			           }
        			        }
        			    }, {
        			        text: "${ctp:i18n('common.button.cancel.label')}", //取消
        			        handler: function () {
        			            dialog.close();
        			        }
        			    }]
            	});
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
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                        	var fManager = new formDataMapperManager();
                        	fManager.deleteFormDataMappers(v, {
                                success: function() {
                                	$("#mytable").ajaxgridLoad(o);
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
        	/*表单名称*/
            display: "${ctp:i18n('voucher.plugin.cfg.formName')}",
            sortable: true,
            name: 'formName',
            width: '35%'
        },
        {
        	/*表单所属人*/
            display: "${ctp:i18n('voucher.plugin.cfg.formOwner')}",
            sortable: true,
            name: 'formOwner',
            width: '10%'
        },
        {
        	/*表单所属单位*/
            display: "${ctp:i18n('voucher.plugin.cfg.formUnit')}",
            sortable: true,
            name: 'formUnit',
            width: '30%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.cfg.updatetime.label')}",
            sortable: true,
            name: 'updateTime',
            width: '20%'          
        }
        ],
        width: "auto",
        managerName: "formDataMapperManager",
        managerMethod: "showFormDataMappers",
        slideToggleBtn: true,
        parentId:'center',
        vChange: true,
        callBackTotle:getCount
    });
  //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
          ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'search_formName',
          name: 'search_formName',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formName')}",
          value: 'formName'
        },{
          id: 'search_formOwner',
          name: 'search_formOwner',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formOwner')}",
          value: 'formOwner'
        },{
          id: 'search_formUnit',
          name: 'search_formUnit',
          type: 'input',
          text: "${ctp:i18n('voucher.plugin.cfg.formUnit')}",
          value: 'formUnit'
        },{
          id: 'search_updateTime',
          name: 'search_updateTime',
          type: 'datemulti',
          text: "${ctp:i18n('voucher.plugin.cfg.updatetime.label')}",
          value: 'updateTime',
          ifFormat:'%Y-%m-%d',
          dateTime: false
        }]
        
      }); 
    function gridclk(data, r, c) {
    	/* $("#memberMapperForm").disable();
    	$("#memberMapperForm").show();
    	$("#button").hide();    	
    	var postdetil = mManager.viewMemberMapper(data.id);
    	$("#addForm").fillform(postdetil);
    	mytable.grid.resizeGridUpDown('middle'); */
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
        }else if(fManager.isFormDelete(v[0]["id"])){
        	$.alert("${ctp:i18n('voucher.formmapper.formdel')}");
        }else{
        	//alert(v[0]["id"]);
            //mytable.grid.resizeGridUpDown('middle');
            var dialog = getA8Top().$.dialog({
        		url:"${path}/voucher/documnentationMapperController.do?method=updateFormDataMapper&id="+v[0]["id"],
    			    width: 1000,
    			    height: 600,
    			    title: "${ctp:i18n('voucher.formmapper.modify')}",//修改单据映射
    			    buttons: [{
    			        text: "${ctp:i18n('common.button.ok.label')}", //确定
    			        handler: function () {
    			           var rv = dialog.getReturnValue();
    			           if(rv!=false){
    			        	   dialog.close();
    			        	   fManager.saveFormDataMapper(rv,{
    			        		   success: function() {
                                       $("#mytable").ajaxgridLoad(o);
                                   }
    			        	   });
    			           }
    			        }
    			    }, {
    			        text: "${ctp:i18n('common.button.cancel.label')}", //取消
    			        handler: function () {
    			            dialog.close();
    			        }
    			    }]
        	});
        }
    }
    
    function getCount(){
    	$("#count")[0].innerHTML = total.format(mytable.p.total);
  	}
});

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_voucher_documnentationMapper'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                	<div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                    	${ctp:i18n("voucher.plugin.cfg.documnentationmapper")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                	${ctp:i18n("voucher.table_detail")}
                                </div>
                            </div>
                     </div>              
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>