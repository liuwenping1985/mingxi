<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=resourceManager"></script>
<script type="text/javascript">
  //
  var nowtab = 1;
  $(function() {
	  $("#tab1").click(function(){
			 $(this).parent().addClass('current').siblings().removeClass('current');
			 nowtab = 1;
			 loadTable1();
		 }) ;
		 $("#tab2").click(function(){
			 $(this).parent().addClass('current').siblings().removeClass('current');
			 nowtab = 2;
			 loadTable2();
		 }) ;
    // 列表
    
      $("#mytable").ajaxgrid({
        render : rend,
        dblclick : dblclk,
        colModel : [
          { display : 'id',
            name : 'id',
            width : '5%',
            sortable : false,
            align : 'center',
            type : 'checkbox'
          },
          { display : "${ctp:i18n('privilege.resource.name.label')}",
            name : 'resourceName',
            sortable : true,
            width : '25%'
          },
          { display : "${ctp:i18n('privilege.resource.navurl.label')}",
            name : 'navurl',
            width : '40%'
          },
          { display : "${ctp:i18n('privilege.resource.code.label')}",
            name : 'resourceCode',
            sortable : true,
            width : '20%'
            //codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceTypeEnums'"
          }, 
          { display : "${ctp:i18n('privilege.resource.iscontrol.label')}",
            name : 'control',
            width : '8%',
            align : 'center',
            codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.BooleanEnums'"
          } 
        ],
        width : "auto",
        //parentId:"layoutCenter",
        height:$("#layoutCenter").height()-60,
        managerName : "resourceManager",
        managerMethod : "findResources"
      });
    
    function rend(txt, data, r, c) {
      if (c === 1){
        return '<input id="resourceCategory'+data.id+'" type="hidden" value="'+data.resourceCategory+'">' + txt;
      } else{
        return txt;
      }
    }
    function dblclk(data, r, c) {
      updateResource(data.id);
    }
    // 手动加载表格数据
    if(nowtab==1){
    	
    	loadTable1();
    }else if(nowtab==2){
    	
    	loadTable2();
    }
    //
    var searchobj = $.searchCondition({
      top:2,
      right:10,
      searchHandler: function(){
        var result = searchobj.g.getReturnValue();
        if(result){
        	if(nowtab==1){
        		loadTable1(result.condition, result.value);
            }else if(nowtab==2){
            	loadTable2(result.condition, result.value);
            }	
        }else{
        	if(nowtab==1){
            	loadTable1();
            }else if(nowtab==2){
            	loadTable2();
            }
        }
      },
      conditions: [
        { id: 'resourceName',
          name: 'resourceName',
          type: 'input',
          text: "${ctp:i18n('privilege.resource.name.label')}",
          value: 'resourceName'
        }, 
        { id: 'navurl',
          name: 'navurl',
          type: 'input',
          text: "${ctp:i18n('privilege.resource.navurl.label')}",
          value: 'navurl'
//           items: [
//             { text: 'url',
//               value: '0'
//             }, 
//             { text: 'ajax',
//               value: '1'
//             }
//           ]
        }, 
        { id: 'control',
          name: 'control',
          type: 'select',
          text: "${ctp:i18n('privilege.resource.iscontrol.label')}",
          value: 'control',
          items: [
            { text: "${ctp:i18n('privilege.resource.true.label')}",
              value: 'true'
            }, 
            { text: "${ctp:i18n('privilege.resource.false.label')}",
              value: 'false'
            }
          ]
        },
        { id: 'resourceCode',
          name: 'resourceCode',
          type: 'input',
          text: "${ctp:i18n('privilege.resource.resourceCode.label')}",
          value: 'resourceCode'
        }
      ]
    });
    
    // 工具栏
    $("#toolbar").toolbar({
      // 搜索html id
      toolbar : [ {
        id : "create", 
        name : "${ctp:i18n('privilege.resource.new.label')}", 
        className : "ico16",
        click : function() { 
          newResource(); 
        }
      }, {
        id : "update", 
        name : "${ctp:i18n('privilege.resource.edit.label')}", 
        className : "ico16 editor_16",
        click : function() { 
          updateResource(); 
        }
      }, {
        id : "import", 
        name : "${ctp:i18n('privilege.resource.import.label')}", 
        className : "ico16 import_16",
        click : function() {
          var dialog = $.dialog({
            url : _ctxPath+'/privilege/resource.do?method=importResSubmit',
            width : 300, targetWindow:top,height : 100, title : "${ctp:i18n('privilege.resource.import.label')}",
            buttons : [ {
              text : "${ctp:i18n('privilege.resource.cancel.label')}",
              handler : function() {
                dialog.close();
                location.reload();
              }
            }]
          });
        }
      }]
    });
  });
  
  function loadTable(condition, value){
    // 手动加载表格数据
    var o1 = new Object();
    o1.resourceCategory = 2;
    if(condition)
      eval("o1." + condition + " = '" + value + "';");
    $("#mytable1").ajaxgridLoad(o1);
    var o2 = new Object();
    o2.resourceCategory = 0;
    if(value)
      eval("o2." + condition + " = '" + value + "';");
    $("#mytable2").ajaxgridLoad(o2);
  }
  function loadTable1(condition, value) {
	  
	    var o1 = new Object();
	    o1.resourceCategory = 2;
	    if (condition)
	      eval("o1." + condition + " = '" + value + "';");
	    $("#mytable").ajaxgridLoad(o1);
	    
	  }
  function loadTable2(condition, value) {
		    var o2 = new Object();
		    o2.resourceCategory = 0;
		    if (condition)
		      eval("o2." + condition + " = '" + value + "';");
		    $("#mytable").ajaxgridLoad(o2);
}

  // 删除资源
  function deleteRes(){
    var reses = new Array();
    var tesBS = new resourceManager();
    var boxs = $(".mytable input:checked:not(.togCol)");
    if(boxs.length === 0){
      $.messageBox({
        'title': "${ctp:i18n('privilege.resource.message.label')}", 
        'type' : 0, 
        'msg' : "${ctp:i18n('privilege.resource.notSelectDelRes.info')}"
      });
      return;
    }else{
      boxs.each(function (index, domEle) {
        if(!_isDevelop && $("#resourceCategory"+$(domEle).val()).val() == "2" 
          || $("#resourceCategory"+$(domEle).val()).val() == "3"){
          $.messageBox({
            'title': "${ctp:i18n('privilege.resource.message.label')}", 
            'type' : 0, 
            'msg' : "${ctp:i18n('privilege.resource.sysResNotDele.info')}"
          });
          reses = null;
          return;
        }else{reses.push($(domEle).val());}
      });
      if(reses != null){
        $.messageBox({
          'title': "${ctp:i18n('privilege.resource.message.label')}", 
          'type' : 1, 
          'msg' : "${ctp:i18n('privilege.resource.confirmDelete.info')}",
          ok_fn : function() {
            tesBS.deleteResource(reses, {
              success : function(){ 
            	  if(nowtab==1){
          	    	loadTable1();
          	    }else if(nowtab==2){
          	    	loadTable2();
          	    }
              }
            });
          }
        });
      }
    }
  }

  // 更新资源
  function updateResource(id){
    if(!id){
      var boxs = $(".mytable input:checked:not(.togCol)");
      if (boxs.length === 0){
      	
        $.alert("${ctp:i18n('privilege.resource.notSelectEditRes.info')}"); 
        return;
      }
      if (boxs.length > 1){
        $.alert("${ctp:i18n('privilege.resource.onlyOneSelect.info')}"); return;
      }
      var id = boxs[0].value;
      var isSystem = isSystemRes(id);
      if (!_isDevelop && isSystem){
        $.alert("${ctp:i18n('privilege.resource.sysResNotEdit.info')}"); return;
      }
    }
    // 系统资源只能查看不能修改
    if(!_isDevelop && isSystem){
      var dialog = $.dialog({
        url : _ctxPath+'/privilege/resource.do?method=edit&id='+id, 
        targetWindow:top,
        width : 550, 
        height : 500, 
        title : "${ctp:i18n('privilege.resource.lookup.label')}",
        buttons : [ {
          text : "${ctp:i18n('privilege.resource.close.label')}",
          handler : function() { dialog.close(); }
        }]
      }); return;
    }
    // 自定义资源
    var dialog = $.dialog({
      url : _ctxPath+'/privilege/resource.do?method=edit&id='+id,
      width : 550, 
      height : 520, 
      targetWindow:top,
      title : "${ctp:i18n('privilege.resource.edit.label')}",
      buttons : [ {
        text : "${ctp:i18n('privilege.resource.submit.label')}",
        handler : function() {
          var callerResponder = new CallerResponder();
          var resNew = new Object();
          var res = dialog.getReturnValue();
          if(res.valid){ return; }
          delete res.isEnterSource;
          resNew.id = res.id;
          resNew.resourceName = res.resourceName;
          resNew.resourceCode = res.resourceCode;
          resNew.resourceType = res.resourceType;
          resNew.moduleid=res.moduleid;
          resNew.show=res.show==="1" ? true : false;
          resNew.navurl = res.navurl;
          resNew.resourceCategory = res.resourceCategory;
          resNew.resourceOrder = res.resourceOrder;
          resNew.control = res.isControl==="1" ? true : false;
          // 资源类型
          resNew.ext1 = res.ext1;
          resNew.ext2 = res.belongtoId;
          // 应用资源类型
          resNew.ext4 = res.ext4;
          resNew.ext3 = res.mainResId;
          callerResponder.success = function(jsonObj) {
            if(jsonObj)
              $.alert(jsonObj);
            else{
              var callerResponder = new CallerResponder();
              callerResponder.success = function(jsonObj) {
                if(!jsonObj){ 
                  $.messageBox({
                    'title': "${ctp:i18n('privilege.resource.message.label')}", 
                    'type' : 0, 
                    'msg' : "${ctp:i18n('privilege.resource.updateFail.info')}"
                  });
                } else { 
                  dialog.close();
                  if(nowtab==1){
                    loadTable1();
                  }else if(nowtab==2){
                    loadTable2();
                  }
                }
              };
              var rm = new resourceManager();
              rm.update(resNew, callerResponder);
            }
          };
          var rm = new resourceManager();
          rm.checkResourceValidate(resNew, callerResponder);
        }
      }, {
        text : "${ctp:i18n('privilege.resource.cancel.label')}",
          handler : function() { dialog.close(); }
        }]
     });
  }

  // 新建资源
  function newResource(){
    if(typeof opendialogNew != "undefined"){
      reOpenDialog(opendialogNew);
      return;
    }
    var dialog = $.dialog({
        url : _ctxPath+'/privilege/resource.do?method=create',
        width : 550, 
        height : 520, 
        targetWindow: top,
        title : "${ctp:i18n('privilege.resource.new.label')}",
        buttons : [ {
          text : "${ctp:i18n('privilege.resource.submit.label')}",
          handler : function() {
            var callerResponder = new CallerResponder();
            callerResponder.success = function(jsonObj) {
              if(jsonObj[0] == -1){ 
                $.alert(jsonObj[1]); 
              } else { 
                dialog.close(); 
                if(nowtab==1){
        	    	loadTable1();
        	    }else if(nowtab==2){
        	    	loadTable2();
        	    }
              }
            };
            callerResponder.sendHandler = function(b, d, c) {
              if (confirm("${ctp:i18n('privilege.resource.confirmSubmit.info')}")) { 
                b.send(d, c); 
                }
            }
            var resNew = new Object();
            var res = dialog.getReturnValue();
            if(res.valid){ return; }
            delete res.id;
            delete res.isEnterSource;
            resNew.resourceName = res.resourceName;
            resNew.resourceCode = res.resourceCode;
            resNew.resourceType = res.resourceType;
            resNew.navurl = res.navurl;
            resNew.moduleid=res.moduleid;
            
            resNew.show=res.show==="1" ? true : false;
            resNew.resourceCategory = res.resourceCategory;
            resNew.resourceOrder = res.resourceOrder;
            resNew.control = res.isControl==="1" ? true : false;
            // 资源类型
            resNew.ext1 = res.ext1;
            // 归属资源
            resNew.ext2 = res.belongtoId;
            // 应用资源类型
            resNew.ext4 = res.ext4;
            resNew.ext3 = res.mainResId;
            var rm = new resourceManager();
            
            rm.create(resNew, callerResponder);
          }
        }, {
          text : "${ctp:i18n('privilege.resource.cancel.label')}",
          handler : function() { dialog.close(); }
        }]
    });
    opendialogNew = dialog;
  }
  
  // 消息提醒
  function showMessage(msg){
    $.messageBox({
      'title': "${ctp:i18n('privilege.resource.message.label')}", 
      'type' : 0, 
      'msg' : msg
    });
  }
  
  // 是否是系统资源
  function isSystemRes(id){
    return ($("#resourceCategory"+id).val() == "2" 
      || $("#resourceCategory"+id).val() == "3");
  }
  
  // 打开之前已经打开的dialog
  function reOpenDialog(opendialog){
    opendialog.getDialog(); 
    opendialog.autoMinfn(); 
    return;
  }  
</script>
