<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${ctp:i18n('project.body.warning.label') }</title>
</head>
<body>
	<div id="layout" class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:31,maxHeight:31,minHeight:31,border:false,sprit:false">
        	<div id="tabs2_head" class="common_tabs clearfix" style="background: none; margin:0 15px; ">
        		<ul class="left">
        			<%--所有项目 --%>
					<li class="current"><a class=no_b_border href="javascript:void(0)"><span>${ctp:i18n('project.grid.select.all.project')}</span></a></li>
					<%--标星项目 --%>
					<li><a class=no_b_border href="javascript:void(0)"><span>${ctp:i18n('project.grid.select.mark.project')}</span></a></li>
        		</ul>
        	</div>
        </div>
        <div class="layout_center" layout="border:false">
        	<div style="height: 40px;"></div>
        	<div id="center" layout="border:false" style="overflow: hidden;">
     			<table class="flexme3" id="table"></table>
     		</div>
        </div>
	</div>
</body>
<script type="text/javascript">
$(function(){
	var params = window.parentDialogObj["projectSelectDialog"].getTransParams();
	$("#center").height($(".layout_center").height() - 40);
	//初始化搜索框
	searchobj = $.searchCondition({
		top: 38,
		right: 15,
		conditions: [{
			id: 'projectName',
			name : 'projectName',
			type: 'input',
			text: '${ctp:i18n("project.body.projectName.label")}',
			value: 'projectName'
		},{
			id: 'projectNumber',
			name: 'projectNumber',
			type: 'input',
			text: '${ctp:i18n("project.body.projectNum.label")}',
			value: 'projectNumber'
		},{
			id: 'projectType',
			name: 'projectType',
			type: 'select',
			text: '${ctp:i18n("project.body.type.label")}',
			value: 'projectType',
			items: ${ptList}
		}, {
			id: 'projectManager',
			name : 'projectManager',
			type: 'input',
			text: '${ctp:i18n("project.body.responsible.label")}',
			value: 'projectManager'
		}, {
			id: 'projectRole',
			name: 'projectRole',
			type: 'select',
			text: '${ctp:i18n("project.body.role.label")}',
			value: 'projectRole',
			items: (function(projectRole){
				var rs = projectRole.split(',');
				var items = [];
				for (var i = 0; i < rs.length; i ++) {
					var r = rs[i];
					if (r == '0') {//负责人
						items.push({value: 0, text: '${ctp:i18n("project.body.responsible.label")}'});
					} else if (r == '1') {//领导
						items.push({value: 1, text: '${ctp:i18n("project.body.manger.label")}'});
					} else if (r == '2') {//项目成员
						items.push({value: 2, text: '${ctp:i18n("project.body.member.label")}'});
					} else if (r == '3') {//相关人员
						items.push({value: 3, text: '${ctp:i18n("project.body.related.label")}'});
					} else if (r == '4') {//发起人
						//items.push({value: 4, text: '${ctp:i18n("project.info.select.publisher.label")}'});
					} else if (r == '5') {
						items.push({value: 5, text: '${ctp:i18n("project.body.assistant.label")}'});
					}
				}
				return items;
			})(params.projectRole)
		}],
		searchHandler: function(){
			ajaxLoad(searchobj.g.getReturnValue());
		}
	});
	//初始化列表
	$("#table").ajaxgrid({
        colModel: [{//项目ID
                name: 'id',
                width: '5%',
                align: 'center',
                type: 'radio',
                isToggleHideShow: true
            }, {//项目名称
                display: $.i18n('project.body.projectName.label'),
                name: 'projectName',
                sortable: true,
                width: '32%'
            },{//项目编号
                display: $.i18n('project.body.projectNum.label'),
                name: 'projectNumber',
                sortable: true,
                width: '10%'
            },{//项目类型
                display: $.i18n('project.body.type.label'),
                name: 'projectTypeName',
                sortable: true,
                width: '10%'
            },{//项目负责人
                display: $.i18n('project.body.responsible.label'),
                name: 'mananger',
                sortable: true,
                width: '26%'
            },{//项目状态
                display: $.i18n('project.body.state.label'),
                name: 'projectState',
                sortable:true,
                width: '13%'
            },{//项目阶段ID
                name: 'currentPhaseId',
                hide: true,
                isToggleHideShow: false
            }],
        resizable: false,
        showTableToggleBtn: true,
        parentId: "center",
        callBackTotle: function(){
        	$("input[type='radio'][value='"+params.projectId+"']").attr("checked","true");
        },
        resizeable:false,
        managerName : "projectQueryManager",
        managerMethod : "findProjectSummaryList"
	});
	ajaxLoad({});
	//绑定事件
	$("#tabs2_head").find("li").off("click").on("click", function(e){
		var $this = $(this);
		if ($this.hasClass("current")) {
			return;
		}
		$this.addClass("current").siblings("li").removeClass("current");
		searchobj.g.clearCondition();
		ajaxLoad({});
	})
	//加载列表
	function ajaxLoad(conditions) {
		var o = {
			projectState: params.projectState,
			projectRole: params.projectRole,
			isMark: $("#tabs2_head").find(".current").index() == 1 ? true: false,
			memberId: $.ctx.CurrentUser.id, //暂时保留
			page: 1 //每次都切换回第一页
		};
		if(conditions.condition && conditions.value){
			o[conditions.condition] = conditions.value;
		}
		$("#table").ajaxgridLoad(o);
	}
});

function OK() {
	var selected = $("#table").formobj({
		gridFilter : function(data, row) {
			return $(":radio", row).is(":checked");
		}
	});
	if (selected.length  == 0) {
		return false;
	}
	var p = selected[0];
	return {projectId: p.id, projectName: p.projectName, projectPhaseId: p.currentPhaseId};
}
</script>
</html>