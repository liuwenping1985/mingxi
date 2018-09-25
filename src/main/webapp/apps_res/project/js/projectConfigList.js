    var dialog;
    var searchobj;
    var toolbar;
    var projectConfig = new projectConfigManager();
    var listDataObj;
    var showListType = 0;
    var isLoadChildTask = "";
    var childTaskList = new Array();
    var isContinuous = false;
    var phaseObj = null;
    /**
     * 初始化工具条
     */
    function initToolBar() {
        toolbar = $("#toolbar").toolbar({
            borderTop:false,
            toolbar : [ {
                id : "new",
                name : $.i18n('common.toolbar.new.label'),
                className : "ico16",
                click : newProject
            },{
                id : "update",
                name : $.i18n('common.toolbar.update.label'),
                className : "ico16 editor_16",
                click : editorProject
            }, {
                id : "delete",
                name : $.i18n('common.toolbar.delete.label'),
                className : "ico16 del_16",
                click : deleteProject
            },{
                id : "sort",
                name : $.i18n('common.toolbar.order.label'),
                className : "ico16 sort_16",
                click : sortProject
            },
          {
              id: "import_export",
              name: $.i18n('export.or.import'),
              className: "ico16 import_16",
              subMenu: [{
                  name: $.i18n('application.95.label'),
                  click: function() {
                	  
                	  $.confirm({
                          title: $.i18n('common.prompt'),
                          msg: $.i18n('project.import.prompt.message'),
                          //'msg': "<fmt:message key='project.import.message.prompt' bundle='${projectI18N}'/>",
                          ok_fn: function() {
                        	  dialog = $.dialog({
                                  width: 600,
                                  height: 300,
                                  isDrag: false,
                                  id: 'importdialog',
                                  url: _ctxPath + "/project/project.do?method=importExcel",
                                  title: $.i18n('application.95.label'),
                                  closeParam:{
                                      'show':true,
                                      handler:function(){
                                          filter = new Object();
                                          filter.enabled = true;
                                          isSearch = false;
                                          $("#projectConfigList").ajaxgridLoad(filter);
                                      }
                                  }
                              	
                              });
                          }
                	  });
                  }
              },{
                  name: $.i18n('org.template.excel.download'),
                  click: function() {
                	  exportIFrame.location.href = _ctxPath + "/project/project.do?method=downloadTemplate";
                  }
              },{
                  name: $.i18n('common.toolbar.exportExcel.label'),
                  click: function(){
                	  s = searchobj.g.getReturnValue();
                	  exportIFrame.location.href = _ctxPath + "/project/project.do?method=exportProjectToExcel&conditions="+encodeURI($.toJSON(s));
                  }
              }]
          }
        ]
        });
        
        if($("#canAdd").val() == "false"){
        	toolbar.hideBtn("new");
        }
    }
    /**
     * 初始化搜索框
     */
    function initSearchDiv() {
        searchobj = $.searchCondition({
        	top:2,
        	right:5,
            searchHandler: function(){
                var returnValue = searchobj.g.getReturnValue();
                if(returnValue != null){
                    var condition = returnValue.condition;
			        var value = returnValue.value;
			        var obj = new Object();
			        if("projectDate"==condition){
			        	obj["beginTime"]=value[0];
			        	obj["endTime"]=value[1];
			        }else{
			        	obj[condition]=value;
			        }
			        
			        $("#projectConfigList").ajaxgridLoad(obj);
                }
            },
            conditions: [{
                id: 'projectName',
                name: 'projectName',
                type: 'input',
                text: $.i18n('project.body.projectName.label'),
                value: 'projectName'
            }, {
                id: 'projectNumber',
                name: 'projectNumber',
                type: 'input',
                text: $.i18n('project.body.projectNum.label'),
                value: 'projectNumber'
            }, {
                id: 'projectManager',
                name: 'projectManager',
                type: 'input',
                text: $.i18n('project.body.responsible.label'),
                value: 'projectManager'
            }, {
                id: 'projectDate',
                name: 'projectDate',
                type: 'datemulti',
                text: $.i18n('project.body.search.projecttime'),
                value: 'projectDate',
                ifFormat:"%Y-%m-%d",
                dateTime: false
            }, {
                id: 'projectState',
                name: 'projectState',
                type: 'select',
                text: $.i18n('project.body.state.label'),
                value: 'projectState',
                items: [{
                    text: $.i18n('project.body.projectstate.0'),
                    value: '0'
                }, {
                    text: $.i18n('project.body.projectstate.2'),
                    value: '2'
                }]
            },  {
                id: 'projectRole',
                name: 'projectRole',
                type: 'select',
                text: $.i18n('project.body.search.myrole'),
                value: 'projectRole',
                items: [{
                    text: $.i18n('project.body.responsible.label'),
                    value: '0'
                }, {
                    text: $.i18n('project.body.assistant.label'),
                    value: '5'
                }, {
                    text: $.i18n('project.body.members.label'),
                    value: '2'
                }, {
                    text: $.i18n('project.body.manger.label'),
                    value: '1'
                }, {
                    text: $.i18n('project.body.related.label'),
                    value: '3'
                }]
            }]
        });
    }
    
    /**
     * 初始化任务里列表数据
     */
    function initData() {
        initListData();
    }
    
    /**
     * 初始化列表数据
     */
    function initListData() {
        listDataObj = $("#projectConfigList").ajaxgrid(
                        {
                            isHaveIframe:false,
                            colModel : [
                                    {
                                        display : 'id',
                                        name : 'id',
                                        width : '5%',
                                        align : 'center',
                                        type : 'checkbox'
                                    }, {
                                        display : $.i18n('project.body.projectName.label'),
                                        name : 'projectName',
                                        sortable : true,
                                        width : '30%'
                                    },  {
                                        display : $.i18n('project.body.projectNum.label'),
                                        name : 'projectNumber',
                                        sortable : true,
                                        width : '10%'
                                    }, {
                                        display : $.i18n('project.group.label'),
                                        name : 'projectTypeName',
                                        width : '14%',
                                        sortable : true
                                    }, {
                                        display : $.i18n('project.body.responsible.label'),
                                        name : 'mananger',
                                        sortable : true,
                                        width : '10%'
                                    }, {
                                        display : $.i18n('project.body.startdate.label'),
                                        name : 'beginDate',
                                        sortable : true,
                                        width : '10%'
                                    }, {
                                        display : $.i18n('project.body.enddate.label'),
                                        name : 'endDate',
                                        sortable : true,
                                        width : '10%'
                                    }, {
                                        display : $.i18n('project.body.state.label'),
                                        name : 'projectState',
                                        sortable : true,
                                        width : '9%',
                                    	codecfg : "codeType:'java',codeId:'com.seeyon.apps.project.enums.Project2StateEnums'"
                                    } ],
                            click : doubleClickEvent,
                            dblclick : doubleClickEvent,
                            vChange: false,
                            vChangeParam: {
                                overflow: "hidden",
                                autoResize:true
                            },
                            usepager : true,
                            showTableToggleBtn: false,
                            slideToggleBtn: false,
                            parentId: $('.layout_center').eq(0).attr('id'),
                            managerName : "projectConfigManager",
                            managerMethod : "getMyProjectList"
                        });
                        $("#projectConfigList").ajaxgridLoad();
    }
