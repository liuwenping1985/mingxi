/**任务树唯一的公共变量*/
var taskTreeListObject = new Object();
taskTreeListObject.pageSize = 20;

/**
 * 初始化任务树页面
 */
function initTreeListPage(){
	//获取第一页树列表并创建树
	createRootTreeList_pageOne();
	//绑定树列表事件
	init_projectTask_tree_list_binding();
}

function createRootTreeList_pageOne(){
	var param = getTreeListParam();
	taskTreeListObject.ajaxManager = new taskTreeListAjaxManager();
	taskTreeListObject.ajaxManager.findRootTask({page:1,size:taskTreeListObject.pageSize,needTotal:true},param,{
		success:function(_treeData){
			// 保存根节点数总条数
			taskTreeListObject.total = _treeData.total;
			//如果为空则显示空提示
			if(taskTreeListObject.total == 0){
				$("#zsTreeList").html("<div class=\"have_a_rest_area\">"+$.i18n("taskmanage.condition.no.content")+"</div>");
				return;
			}
			//记录未完成数量
			taskTreeListObject.ufcount = _treeData.ufcount;
			//记录已完成数量
			taskTreeListObject.fcount = _treeData.fcount;
			// 创建任务树
			newZsTree(_treeData);
			// 创建滚动组件
			newTreeListScroller();
    	}
	});
}

function newZsTree(_treeData){
	taskTreeListObject.zsTree = new zsTree({
                targetId: "zsTreeList",
                data:_treeData.data,
                onlyText: false,
                computeWidth: true,
                asynAddData: function(pId){//点击父节点展现子节点数据
                    taskTreeListObject.ajaxManager.findChildTask({},{taskId:pId,isChild:"true"},{
                    	success:function(_childTreeData){
                    		taskTreeListObject.zsTree.addData(_childTreeData.data);
                    	}
                    });
                    return true;
                },
                onAddCallback:function(data){
                    for (var i = 0; i < data.length; i++) {
                        var row_obj = $("#"+ data[i].id + " .nodeTextArea:eq(0)");
                        var row_width = row_obj.width();
                        row_obj.find(".projectName:eq(0)").width(row_width - 681);
                    };
                    //加载完成后绑定穿透到项目空间的事件
                    bindProjectNameEvent();
					bindStatusBtnEvent();
                }
    });//end of taskTreeListObject.zsTree = new zsTree({
}

/**
 * 设置树列表
 */
function newTreeListScroller(){
	taskTreeListObject.scrollPage = $("#zsTreeList").scrollPage({
		pageSize : taskTreeListObject.pageSize,
		scrollContent : ".stadic_layout_body",
        callbackFun:function(){//每次回填数据后调整下布局
        	scrollerTreeListData();
        }
	});
	$("#zsTreeList").ajaxSrollLoad({
		total:taskTreeListObject.total,
		notClear:true,
		currentPage : 2
	});
}

/**
 *滚动后，显示下一页任务树结果
 * */
function scrollerTreeListData() {
	var scrollPage = taskTreeListObject.scrollPage;
	var page = scrollPage.cfg.currentPage;
	var size = scrollPage.cfg.pageSize;
	var param = getTreeListParam();
	param.ufcount = taskTreeListObject.ufcount;
	param.fcount = taskTreeListObject.fcount;
	taskTreeListObject.ajaxManager.findRootTask({page:page,size:size,needTotal:false},param,{
		success:function(_treeData){
    		taskTreeListObject.zsTree.addData(_treeData.data);
    		taskTreeListObject.scrollPage.scroll.closeLoading();
    	}
	});
}

/**
 * 获取任务树列表查询
 */
function getTreeListParam(){
	//获取查询相关参数
	var param = parent.setInitTaskParams();
	var listType = parent.getListType();
	//获取操作类型-我的？告知？分派？他人？
	if (typeof listType != "undefined" && listType.length > 0) {
		param.listType = listType;
	}
	//TODO 容错处理：如果进入过一次他人之后，参数条件就会一直是他人的，暂时容错，后续寻找根源修改
	if(param.listType != "Manage" && param.isOtherUser == 1){
		param.isOtherUser = 0;
		param.userId = "";
	}
	param.listShowType = 1;
	return param;
}