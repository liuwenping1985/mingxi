<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
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
	src="${path}/ajax.do?managerName=levelManager"></script>
<script type="text/javascript">
$().ready(function() {
	var cnt;
	var msg = '${ctp:i18n("info.totally")}';
    var lManager = new levelManager();
    var isgroup = lManager.isGroup();
    var isgrouplevel = "${ctp:getSystemProperty('org.GroupLevel')}";
    var ishidegrouplevel = false;
    if(isgroup||isgrouplevel =="false"){
    	$("#groupLevelId_area").hide();
    	$("tr[class='cGroup']").hide();
    	ishidegrouplevel = true;
    }
    
    $("#postform").hide();
    $("#welcome").show();
    $("#button").hide();
    function addform(){
    	$("#postform").clearform({clearHidden:true});
        $("#postform").enable();
        $("#postform").show();
        $("#button").show();
        $("#welcome").hide();
        $("#south").show();
        $("#lconti").show();
        $("#conti").attr("checked",'checked'); 
        $("input[name=enabled]:eq(0)").attr("checked",'checked'); 
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
                        'msg': "${ctp:i18n('level.delete.ok')}",
                        ok_fn: function() {
                        	lManager.deleteLevel(v, {
                                success: function() {
                                	$("#mytable").ajaxgridLoad(o);
                                	$("#postform").hide();
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
            display: "${ctp:i18n('org.level_form.name.label')}",
            sortable: true,
            name: 'name',
            width: '25%'
        },
        {
            display: "${ctp:i18n('org.level_form.code.label')}",
            sortable: true,
            name: 'code',
            width: '20%'
        },
        {
            display: "${ctp:i18n('org.level_form.levelId.label')}",
            sortable: true,
            sortType:'number',
            name: 'levelId',
            width: '10%'
        },
        {
            display: "${ctp:i18n('org.level_form.groupLevelId.list.label')}",
            sortable: true,
            sortType:'number',
            name: 'groupLevelId',
            width: '10%',
            hide:ishidegrouplevel,
            isToggleHideShow:!isgroup
        },
        {
            display: "${ctp:i18n('common.state.label')}",
            sortable: true,
            codecfg: "codeId:'common.enabled'",
            name: 'enable',
            width: '10%'
        },
        
        {
            display: "${ctp:i18n('org.level_form.description.label')}",
            sortable: true,
            name: 'description',
            width: '18%'
        }
        ],
        managerName: "levelManager",
        managerMethod: "showLevelList",
        parentId:'center',
        vChangeParam: {
            overflow: 'hidden',
            position: 'relative'
        },
        slideToggleBtn: true,
        vChange: true,
        callBackTotle:getCount
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);

    function gridclk(data, r, c) {
    	$("#postform").disable();
    	$("#postform").show();
    	$("#button").hide();
    	$("#welcome").hide();
    	var postdetil = lManager.viewLevel(data.id);
    	$("#addForm").fillform(postdetil);
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
        }else if(v.length > 1){
        	$.alert("${ctp:i18n('once.selected.one.record')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var mpostdetil = lManager.viewLevel(v[0]["id"]);
            $("#postform").clearform({clearHidden:true});
        	$("#addForm").fillform(mpostdetil);
        	$("#conti").removeAttr("checked");;
        	$("#postform").enable();
        	$("#postform").show();
        	$("#button").show();
        	$("#lconti").hide();
        	$("#welcome").hide();
        }
    }
    
    $("#btncancel").click(function() {
    	location.reload();
    });
    $("#btnok").click(function() {
        if(!($("#postform").validate())){
          return;
        }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        lManager.saveLevel($("#addForm").formobj(), {
            success: function(levelBean) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                if($("#conti").attr("checked")=="checked"){
                    addform();
                }else{   
                    $("#postform").hide();
                    $("#button").hide();
                    $("#welcome").show();
                }
            }
        });
    });
    var searchobj = $.searchCondition({
		top:2,
		right:10,
        searchHandler: function(){
        	var ssss = searchobj.g.getReturnValue();
        	$("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
            id: 'search_name',
            name: 'search_name',
            type: 'input',
            text: "${ctp:i18n('level.select.duty.name')}",
            value: 'name'
        }, {
            id: 'search_enable',
            name: 'search_enable',
            type: 'select',
            text: "${ctp:i18n('level.select.state')}",
            value: 'enable',
            codecfg:"codeId:'common.enabled'"
            
        }]
    });
    function getCount(){
        cnt = mytable.p.total;
        $("#count").get(0).innerHTML = msg.format(cnt);
    }
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T02_showLevelframe'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">
        <div id="searchDiv"></div>
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height"></div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="welcome">
                        <div class="color_gray margin_l_20">
                            <div class="clearfix">
                                <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n('level.management')}</h2>
                                <div class="font_size12 left margin_t_20 margin_l_10">
                                    <div class="margin_t_10 font_size14">
                                        <span id="count"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="line_height160 font_size14">
                                <c:if test="${CurrentUser.groupAdmin==true}">${ctp:i18n('organization.detail_info_level_group')}</c:if>
                                <c:if test="${CurrentUser.groupAdmin==false}">${ctp:i18n('organization.detail_info_level')}</c:if>
                            </div>
                        </div>
                    </div>
                    <div id="postform" class="form_area">
                        <%@include file="levelform.jsp"%></div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                            <label for="conti" class="margin_r_10 hand" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
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