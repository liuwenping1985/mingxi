<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">

    var msg = '${ctp:i18n("info.totally")}';
    var showType = '${showType}';
    var mytable;
    
    var searchCondition = "";
    var searchValue = "";
    
    
    
    var allModules = ${modules};
    var allLocales = ${allLocales};
    
    var i18nModules = [];
    for(var key in allModules){
        i18nModules.push({
            "text" : allModules[key],
            "value" : key
        });
    }

    $().ready(function() {
        
        var colModels = [];
        colModels.push({
            display : 'id',
            name : 'id',
            width : '5%',
            sortable : false,
            align : 'center',
            type : 'checkbox',
        });
        colModels.push({
            display : "Key",
            name : 'key',
            sortable : true,
            width : '15%'
        });
        for(var key in allLocales){
            
            colModels.push({
                display : allLocales[key] + "(" + key + ")",
                name : key,
                sortable : true,
                width : '20%'
            });
        }
        colModels.push({
            display : "${ctp:i18n('i18nresource.level.info')}",//"加载等级",
            name : 'levelTypeName',
            sortable : true,
            width : '5%'
        });
        colModels.push({
            display : "${ctp:i18n('common.resource.body.type.label')}",//"分类",
            name : 'moduleName',
            sortable : true,
            width : '10%'
        });
        
              mytable = $("#mytable").ajaxgrid({
                  //click : clk,
                  colModel : colModels,
                  render : renderClumn,
                  customize : false,
                  width : 'auto',
                  parentId : "layoutCenter",
                  managerName : "i18nresourceManager",
                  managerMethod : "findALLResource",
                  vChangeParam : {
                      overflow : "auto"
                  },
                  slideToggleBtn : true,
                  showTableToggleBtn : true,
                  vChange : true,
                  resizable : true,
                  slideToggleBtn : "bool"
              });
              
              //showType
              var toolbars = [ {
                  id : "modify",
                  name : "${ctp:i18n('label.modify')}",
                  className : "ico16 editor_16",
                  click : function() {
                      modifyres();
                  }
              }/* , {
                  id : "delete",
                  name : "重置",
                  className : "ico16 empty_16",
                  click : function() {
                      deleteResouce();
                  }
              } */, {
                  id : "import",
                  name : "${ctp:i18n('application.95.label')}",
                  className : "ico16 import_16",
                  click : function() {
                      importFile();
                  }
              }, {
                  id : "export",
                  name : "${ctp:i18n('common.export.label')}", <%--导出--%>
                  className : "ico16 export_16",
                  click : function() {
                      exportFile();
                  }
              }, {
                  id : "help",
                  name : "${ctp:i18n('seeyon.top.help.alt')}", <%--帮助--%>
                  className : "ico16 help_16",
                  click : function() {
                      help();
                  }
              } ];
              
              if(showType == "M3"){
                  toolbars.push({
                      id : "updateM3",
                      name : "${ctp:i18n('common.updatem3i18n.label')}", <%-- 跟新M3 --%>
                      className : "ico16 editor_16",
                      click : function() {
                          updateM3I18n();
                      }
                  });
              }
              
              // 工具栏
              var toolbar = $("#toolbar").toolbar({
                  toolbar : toolbars
              });
              
              //搜素栏查询
              var searchobj;
              var ver = "${ctp:getSystemProperty('org.isGroupVer')}";
              searchobj = $.searchCondition({
                  top : 7,
                  right : 10,
                  searchHandler : function() {
                      var result = searchobj.g.getReturnValue();
                      if (result) {
                          loadTable1(result.condition, result.value);
                      }
                  },
                  conditions : [ {
                      id : 'leveltype',
                      name : 'leveltype',
                      type : 'select',
                      text : "${ctp:i18n('i18nresource.level.info')}",
                      value : 'leveltype',
                      items : [ {
                          text : "${ctp:i18n('i18nresource.custom.info')}", // 优先级 0
                          value : 'custom'
                      }, {
                          text : "${ctp:i18n('common.i18n.product.label')}", <%--产品--%> // 优先级 1    
                          value : 'product'
                      }, {
                          text : "${ctp:i18n('i18nresource.label.catg.common')}",//"公共", // 优先级 2
                          value : 'common'
                      }, {
                          text : "${ctp:i18n('i18nresource.label.catg.plugin')}",//"插件", // 优先级 3
                          value : 'plugin'
                      }, {
                          text : "${ctp:i18n('i18nresource.label.catg.default')}",//"默认", // 优先级 4
                          value : 'default'
                      } ]
                  }, {
                      id : 'keyinfo',
                      name : 'keyinfo',
                      type : 'input',
                      text : "${ctp:i18n('common.i18n.key.name')}", <%--国际化资源Key名--%> 
                      value : 'keyinfo'
                  }, {
                      id : 'valueinfo',
                      name : 'valueinfo',
                      type : 'input',
                      text : "${ctp:i18n('common.i18n.value')}",  <%--国际化资源值--%>
                      value : 'valueinfo'
                  }, {
                      id : 'module',
                      name : 'module',
                      type : 'select',
                      text : "${ctp:i18n('common.resource.body.type.label')}", <%--分类--%>
                      value : 'module',
                      items : i18nModules
                  } ]
              });
              
              //加载数据
              reloadtab();
              
              $("#ok_1").click(function() {
                  ok();
              });
              $("#cancel").click(function() {
                  $("#searchHTML").addClass("hidden");
                  mytable.grid.resizeGridUpDown('down');
              });
          });

    function renderClumn(text, row, rowIndex, colIndex, col){
        
        //国际化语言
        if(allLocales[col.name]){
            var locales = row.infos;
            for(var i = 0; i < locales.length; i++){
                if(locales[i]["locale"] == col.name){
                    text = locales[i]["value"];
                }
            }
        }
        
        return text
    }

    //导入资源
    function importFile() {
        insertAttachmentPoi("i18nzip");
    }
    //导出资源
    function exportFile() {
        /* var boxs = $(".mytable").formobj({
            gridFilter : function(data, row) {
                return $("input:checked", row)[0];
            }
        });
        if (boxs.length === 0) {
            $.alert("${ctp:i18n('i18nresource.checkpro.info')}");
            return;
        }
        var index = 0;
        for (var i = 0; i < boxs.length; i++) {
            var levelType = boxs[i].levelType;
            if (levelType == "default") {
                index++;
                break;
            }
        }
        if (index > 0) {
            $.alert("对不起您没有权限，只能导出自定义资源");
        } else {
            var arrayKey = new Array();
            for (var i = 0; i < boxs.length; i++) {
                var key = boxs[i].key;
                arrayKey.push(key);
            }
             */
             
            //导出
            
            $("#exportIframe").attr("src", _ctxPath + "/i18NResource.do?method=exportFile&searchCondition="+searchCondition+"&searchValue="+ encodeURIComponent(searchValue) +"&showType=" + showType + "&_rand=" + (new Date().getTime()));
        /* } */
    }
    
    
    /** 更新M3 **/
    function updateM3I18n(){
        
        var i18nManager = new i18nresourceManager();
        i18nManager.updateM3ZipFile({
            success : function(ret){
               if(ret && ret.success == "true"){
                   $.alert("${ctp:i18n('i18nresource.alert.updateM3Success')}");
               }else{
                   $.alert("update fail!");
               }
            },
            error : function(ret){
                $.alert("An error occurred, update fail!");
            }
        });
    }
    
    //删除资源
    function deleteResouce() {
        var boxs = $(".mytable").formobj({
            gridFilter : function(data, row) {
                return $("input:checked", row)[0];
            }
        });
        
        if (boxs.length === 0) {
            $.alert("${ctp:i18n('i18nresource.checkpro.info')}");
            return;
        }
        var index = 0;
        for (var i = 0; i < boxs.length; i++) {
            var levelType = boxs[i].levelType;
            if (levelType == "default") {
                index++;
                break;
            }
        }
        if (index > 0) {
            $.alert("只能重置自定义资源");
        } else {
            var arrayKey = new Array();
            for (var i = 0; i < boxs.length; i++) {
                var key = boxs[i].key;
                arrayKey.push(key);
            }
            
            $.confirm({
                'msg': "确定要重置选中的国际化资源？",
                "ok_fn": function(){
                    $.ajax({
                        url : _ctxPath + '/i18NResource.do?method=resetResource',
                        type : 'post',
                        traditional : true,
                        data : {
                            "arrayKey" : arrayKey
                        },
                        success : function(result) {
                            if (result != 0) {
                                reloadtab();
                            } else {
                                $.alert("${ctp:i18n('usersystem.restUser.loginName.repeat')}");
                            }
                        }
                    })
                }
            });
        }
    }
    
    //修改
    function modifyres() {
        var boxs = $(".mytable").formobj({
            gridFilter : function(data, row) {
                return $("input:checked", row)[0];
            }
        });
        if (boxs.length === 0) {
            $.alert("${ctp:i18n('i18nresource.checkpro.info')}");
            return;
        } else if (boxs.length > 1) {
            $.alert("${ctp:i18n('i18nresource.editorpro.info')}");
            return;
        }
        var key = boxs[0].key;
        var uniqueKey = boxs[0].uniqueKey || "";
        var levelType = boxs[0].levelType;
        var levelTypeName = boxs[0].levelTypeName;
        
        $("#key").val(key);
        $("#uniqueKey").val(uniqueKey);
        $("#levelType").val(levelTypeName);
        
        for(var key in allLocales){
            var locales = boxs[0].infos;
            
            $("#locale_" + key).val("");
            $("#locale_path_" + key).val("");
            
            for(var i = 0; i < locales.length; i++){
                if(locales[i]["locale"] == key){
                    $("#locale_" + key).val(locales[i]["value"]);
                    $("#locale_path_" + key).val(locales[i]["filePath"]);
                }
            }
        }
        
        $("#searchHTML").removeClass("hidden");
        
        mytable.grid.resizeGridUpDown('middle');
    }
    
    function ok() {
        var key = $("#key").val();
        var uniqueKey = $("#uniqueKey").val();
        var postData = {"key" : uniqueKey};
        for(var key in allLocales){
            postData[key] = $("#locale_" + key).val();
        }
        $.ajax({
            url : _ctxPath + '/i18NResource.do?method=saveResourceModify',
            type : 'post',
            data : postData,
            success : function(result) {
                if (result != 0) {
                    reloadtab();
                    $("#searchHTML").addClass("hidden");
                    mytable.grid.resizeGridUpDown('down');
                } else {
                    $.alert("${ctp:i18n('usersystem.restUser.loginName.repeat')}");
                    $("#searchHTML").addClass("hidden");
                    mytable.grid.resizeGridUpDown('down');
                }
            }
        });
    }
    
    //帮助
    function help() {
        
        //var msg = "1、作用: 国际化资源管理可以修改各页面上显示的文字，包括中文、英文、繁体。"
        //msg += "<br/>2、修改范围包括预置空间的显示名称、菜单名称、按钮名称、页面提示文字等。可修改的内容包括预置空间的显示名称、菜单名称、按钮名称、页面提示文字等。"
        var msg = "${ctp:i18n('i18nresource.label.help1')}";
        msg += "<br/>${ctp:i18n('i18nresource.label.help2')}";
        $.alert(msg);
    }
    
    //加载列表
    function reloadtab() {
        var o = new Object();
        o.showType = showType;
        $("#mytable").ajaxgridLoad(o);
    }
    
    //加载列表
   
    function loadTable1(condition, value) {
        
        var o = new Object();
        o.condition = condition;
        o.value = value;
        o.showType = showType;
        
        searchCondition = condition;
        searchValue = value;
        
        $("#mytable").ajaxgridLoad(o);
    }

    function i18ncallBk(filemsg) {
        if (filemsg.instance != null && filemsg.instance.length > 0) {
            var fileId = filemsg.instance[0].fileUrl;
            var fileName = filemsg.instance[0].filename;
            $.ajax({
                url : _ctxPath + '/i18NResource.do?method=importFile',
                type : 'post',
                data : {
                    "fileId" : fileId,
                    "showType" : showType
                },
                success : function(result) {
                    if (result == 0) {
                        //$.alert("导入成功,请重启服务生效！");
                        $.alert("${ctp:i18n('i18nresource.alert.inportSucess1')}");
                    } else if (result == 1) {
                        //$.alert("导入成功！");
                        $.alert("${ctp:i18n('i18nresource.alert.inportSucess2')}");
                        $("#mytable").ajaxgridLoad();
                    } else {
                        //$.alert("导入出错！请确认导入的文件是否符合导入规范");
                        $.alert("${ctp:i18n('i18nresource.alert.inportError2')}");
                    }
                },
                error : function() {
                    //$.alert("与服务器交互出错了！");
                    $.alert("${ctp:i18n('i18nresource.alert.inportError1')}");
                }
            });
        }
    }
</script>
