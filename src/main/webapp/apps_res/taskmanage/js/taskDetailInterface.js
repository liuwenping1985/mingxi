var taskDetailDialog;
function openTaskDetailPage(taskId){
	var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&taskId="+taskId;
	var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+taskId;
	var taskDetailTreeManager_=new taskDetailTreeManager();
	var existTask=taskDetailTreeManager_.checkTaskExist(taskId);
	//是否存在任务
	if(!existTask){
		$.messageBox({
		    'type': 100,
		    'msg': "<span class='msgbox_img_2 margin_r_5 left'></span>"+$.i18n("taskmanage.task_deleted"),
		    close_fn:function(){
		    	if (typeof refreshTaskList != "undefined") {
					refreshTaskList();
				}
		    },
		    buttons:[{
			    id:'btn1',
			        text: "确定",
			        handler: function () {
						if (typeof refreshTaskList != "undefined") {
							refreshTaskList();
						}
			        }
			}]
	    })
		return;
	}
	//是否存在树
	var exitTree=taskDetailTreeManager_.checkTaskTree(taskId);
	var treeUrl="";
	var hideTree=true;
	treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+taskId;
	if(exitTree){
		hideTree=false;
	}
	getA8Top().up=window;
	taskDetailDialog=new projectTaskDetailDialog(
	    	{
		    	'url1':detailUrl,
		    	'url2':contentUrl,
		    	'url3':treeUrl,
		    	"animate":true,
		    	"offsetRight":0,
		    	'showMask': false,
		    	"hideBtnC":hideTree
	    	}
	    );
 }
