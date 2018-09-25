var nodeId="";
/*
*初始化加载树
*/
function initTree(treeData){
	var tt2 = new zsTree({
        targetId: "onlyTree",
        data: treeData,
        nodeWidth: 360,
        onAddCallback:function(){
        	initTreeCss();
        },
        onNodeSelected: function(id){
        	refreshIframe(id);
        }
    });
  }
/*
*初始化任务树样式
*/
function initTreeCss(){
   nodeId=getCtpTop().$(".projectTask_detailDialog_a_iframe")[0].contentWindow.taskId;
   //默认当前查看的任务有底色效果
   $("#"+nodeId).find(".nodeTextArea").eq(0).addClass("node_selected");
   $(".nodeTextArea").css("font-size","14px");
}
/*
*刷新详情页和内容页
*/
function refreshIframe(taskId){
  var viewAuth=$("#"+taskId).find(":hidden").val();
  if(viewAuth=="false"){
  	$.messageBox({
		   'type': 100,
		   'msg': "<span class='msgbox_img_2 margin_r_5 left'></span>"+$.i18n("taskmanage.auth.no.label"),
		   close_fn:function(){
		    callbackNode();
		   },
		   buttons:[{
			   id:'btn1',
			       text: "确定",
			       handler: function () { 
			        callbackNode();
			   }
		}]
	   })
  	return;
  }
  nodeId=taskId;
  var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&taskId="+taskId;
  var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+taskId;
  projectTaskDetailDialog_reload(detailUrl,contentUrl);
}
/*
*回填选中有权限的树节点
*/
function callbackNode(){
  	$(".node_selected").removeClass("node_selected");
	$("#"+nodeId).find(".nodeTextArea").eq(0).addClass("node_selected");
}
/*
*关闭树页面
*/
function closeTreePage(){
	try{
		getA8Top().up.taskDetailDialog.closeIframeC();
	}catch(e){
		window.parent.top.$(".projectTask_detailDialogBtn_c").trigger("click");
	}
}