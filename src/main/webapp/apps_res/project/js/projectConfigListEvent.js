/**
 * 新建项目
 */
 function newProject(){
 	var dialog = $.dialog({
            id : 'newProjectWin',
            url : _ctxPath + '/project/project.do?method=createProject',
            bottomHTML : "<div class='common_checkbox_box margin_l_10 clearfix'><label class='hand' for='continueAdd'><input id='continueAdd' class='radio_com' name='continuous' value='0' type='checkbox'>"
    			+ $.i18n('taskmanage.add.continue') +"</label></div>",
            width : 556,
            height : 450,
            title : $.i18n('project.newproject') ,
            targetWindow : getCtpTop(),
            transParams:{	newProject:newOpenProject,
            				callBack:doReflashGrid,
            				action:'add'}, 
            closeParam:{
            	'show':true,
            	handler:function(){
            		doReflashGrid(dialog);
            	}
            },
            buttons : [ {
                text : $.i18n('common.button.ok.label'),
                id : 'ok',
	        	isEmphasize:true,
                handler : function() {
                    dialog.getReturnValue({'dialogObj':dialog});
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    dialog.close();
                    doReflashGrid(dialog);
                }
            } ]
        });
 }
 /**
  * 项目类型不存在时回调
  */
  function newOpenProject(dialog){
  	dialog.close();
  	newProject();
  }
  
 /**
 *	修改项目
 */
 function editorProject(){
	
 	var selectRows = listDataObj.grid.getSelectRows();
	if(selectRows.length==0){
		//没有选择项目
		$.alert($.i18n("project.grid.select.label"));
		return;
	}else if(selectRows.length > 1){
		$.alert($.i18n("project.please.choose.on.data"));
		return;
	}
 	if(! selectRows[0].canEditorDel){
		$.alert($.i18n("project.you.are.not.manager.or.builder"));
		return;
	}
	doubleClickEvent(selectRows[0],null ,null ,null);
 }
 
/**
 * 列表单击、双击事件
 */   
function doubleClickEvent(data, r, c,id){
	if(data.canEditorDel && 0 == data.projectIState){
		var url = _ctxPath + '/project/project.do?method=viewProject&type=update&projectId='+data.id;
		var action = 'update';
		var title = $.i18n('project.modifyproject');
		var callBack = doReflashGrid;
		openDialog(url ,title ,data ,action ,callBack);
	}else{
		var url = _ctxPath + '/project/project.do?method=viewProject&type=view&projectId='+data.id;
		var action = 'view';
		var title = $.i18n('project.project.view.label');
		var callBack = restarteProjectCallBack;
		openDialog(url ,title ,data ,action ,callBack);
	}
}

 function openDialog(url ,title ,data ,action ,callBack){
 	var btn;
 	var dialogName = "newProjectWin";
 	if("update" == action){
 		dialogName = "editProjectWin";
	 	btn = [ {
                text : $.i18n('common.button.ok.label'),
                id : 'ok',
	        	isEmphasize:true,
                handler : function() {
                    dialog.getReturnValue({'dialogObj' : dialog});
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    dialog.close();
                }
            } ];
    }else if("view" == action){
    	dialogName = "newProjectWin";
    	btn = [ {
                text : $.i18n('common.button.close.label'),
                handler : function() {
                    dialog.close();
                }
            } ];
    }
 	var dialog = $.dialog({
            id : dialogName,
            url : url,
            width : 556,
            height : 450,
            title : title ,
            targetWindow : getCtpTop(),
            transParams:{ selectData:data,
            			  action:action,
            			  callBack:callBack},
            buttons : btn
        });
 }
 //刷新grild列表
 function doReflashGrid(dialog){
 	dialog.close();
 	$("#projectConfigList").ajaxgridLoad();
 }
/**
 * 点击重启项目后回调
 */
function restarteProjectCallBack(data ,dialog){
	dialog.close();
  	doubleClickEvent(data,null,null,null);
}
 /**
 *刪除项目
 */
 function deleteProject(){
	var selectRows = listDataObj.grid.getSelectRows();
	if(selectRows.length==0){
		//没有选择项目
		$.alert($.i18n("project.grid.select.label"));
		return;
	}
	var selectIds="";
	var projectConfigManager_=new projectConfigManager();
	for(var i = 0 ; i < selectRows.length ; i++){
		//var isManagerFlag=projectConfigManager_.checkMemberAuth(selectRows[i].id,$.ctx.CurrentUser.id);
		if(selectRows[i].canEditorDel!=true){
			//不是项目负责人或者助理
			$.alert($.i18n("project.grid.select.auth.label"));
			return;
		}
		if(selectRows[i].projectIState==0||selectRows[i].projectIState==1){
			//判断项目状态
			alert($.i18n("project.grid.select.deleteState.label"));
			return;
		}
		selectIds+=selectRows[i].id+",";
	}
	var confirm = $.confirm({
            'msg' : $.i18n("project.grid.select.delete.label"),
            ok_fn : function() {
                projectConfigManager_.deleteProject(selectIds,$.ctx.CurrentUser, {
                    success : function(bool) {
                        if (bool != true) {
                            $.alert($.i18n("project.grid.select.delete.doc"));
                        }
                        $("#projectConfigList").ajaxgridLoad();
                    }
                });
            },
            cancel_fn : function() {
            }
        });
 }
 
 /**
 *关联项目排序
 */
 function sortProject(){
 	getA8Top().projectOrderDialog=$.dialog({
 		 id: 'url',
         url: _ctxPath + "/project/project.do?method=orderProject",
         width: 360,
         height: 350,
         title:$.i18n('project.toolbar.orderset.label'),
         checkMax:true,
         overflow:'hidden',
         transParams:{'parentWin':window},
         closeParam:{
         'show':true,
         autoClose:false,
         handler:function(){
        	 getA8Top().projectOrderDialog.close();
         }
     },
     buttons: [{
    	 id:'ok',
         text: $.i18n('common.button.ok.label'),
	     isEmphasize:true,
         handler: function () {
        	 getA8Top().projectOrderDialog.getReturnValue();
         }
      }, {
         text: $.i18n('common.button.cancel.label'),
         handler: function () {
        	 getA8Top().projectOrderDialog.close();
         }
         }]
     });
 }

  function projectOrderCallBack(){
    	document.location.reload();
  }