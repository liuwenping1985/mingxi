<%--
 $Author: gaohang $
 $Rev: 15333 $
 $Date:: 2013-03-05 16:44:05#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=resourceManager"></script>
<script type="text/javascript">
  var resourceNameString = "${ctp:i18n('privilege.resource.name.label')}";
  var navurlString = "${ctp:i18n('privilege.resource.navurl.label')}";
  var typeString = "${ctp:i18n('privilege.resource.devresourcetype.label')}";
  var iscontrol = "${ctp:i18n('privilege.resource.iscontrol.label')}";
  var newString = "${ctp:i18n('privilege.resource.new.label')}";
  var editString = "${ctp:i18n('privilege.resource.edit.label')}";
  var deleteString = "${ctp:i18n('privilege.resource.delete.label')}";
  //
  $(function() {
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
    }
    var cmd = $afg.cmd;
    // 选择入口资源、归属资源和主资源时只能单选
    if(cmd === "pageRes" || cmd === "mainRes"){
      // 列表
      $(".mytable").ajaxgrid({
        click : clk,
        render : rend,
        dblclick : dblclk,
        colModel : [
          { display : 'id',
            name : 'id',
            width : '20',
            sortable : false,
            align : 'center',
            type : 'radio'
          },
          { display : resourceNameString,
            name : 'resourceName',
            width : '180'
          },
          { display : navurlString,
            name : 'navurl',
            width : '180'
          },
          { display : "${ctp:i18n('privilege.resource.code.label')}",
            name : 'resourceCode',
            width : '180'
//             codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceTypeEnums'"
          }, 
          { display : iscontrol,
            name : 'control',
            width : '180',
            codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.BooleanEnums'"
          } 
        ],
        width : 770,
        height : 270,
        managerName : "resourceManager",
        managerMethod : "findResources"
      });
    } else if(cmd === "naviRes"){
      // 列表
      $(".mytable").ajaxgrid({
        click : clk,
        render : rend,
        dblclick : dblclk,
        colModel : [
          { display : 'id',
            name : 'id',
            width : '40',
            sortable : false,
            align : 'center',
            type : 'checkbox'
          },
          { display : resourceNameString,
            name : 'resourceName',
            width : '180'
          },
          { display : navurlString,
            name : 'navurl',
            width : '180'
          },
          { display : "${ctp:i18n('privilege.resource.code.label')}",
            name : 'resourceCode',
            width : '180'
//             codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceTypeEnums'"
          },
          { display : iscontrol,
            name : 'control',
            width : '180',
            codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.BooleanEnums'"
          } 
        ],
        width : 770,
        height : 270,
        managerName : "resourceManager",
        managerMethod : "findResources"
      });
    } else if(cmd === "shortcutRes"){
      // 列表
      $(".mytable").ajaxgrid({
        click : clk,
        render : rend,
        dblclick : dblclk,
        colModel : [
          { display : 'id',
            name : 'id',
            width : '40',
            sortable : false,
            align : 'center',
            type : 'checkbox'
          },
          { display : resourceNameString,
            name : 'resourceName',
            width : '180'
          },
          { display : navurlString,
            name : 'navurl',
            width : '180'
          },
          { display : "${ctp:i18n('privilege.resource.code.label')}",
            name : 'resourceCode',
            width : '180'
//             codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceTypeEnums'"
          },
          { display : iscontrol,
            name : 'control',
            width : '180',
            codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.BooleanEnums'"
          } 
        ],
        width : 770,
        height : 270,
        managerName : "resourceManager",
        managerMethod : "findShortcutResources"
      });
    }
    // 设置初始焦点防止IE下出现无法输入查询条件的情况
    $(".search_input").focus();
    
    function rend(txt, data, r, c) {
      return txt;
    }
    
    function clk(data, r, c) {
      // $("#txt").val("clk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
    }
    
    function dblclk(data, r, c) {
      updateResource(data.id);
    }
    
    // 手动加载表格数据
    loadTable();
    
    //
    var searchobj = $.searchCondition({
      top:2,
      right:10,
      searchHandler: function(){
        var result = searchobj.g.getReturnValue();
        if(result){
          loadTable(result.condition, result.value);
        }else{
          loadTable();
        }
      },
      conditions: [
        { id: 'resourceName',
          name: 'resourceName',
          type: 'input',
          text: resourceNameString,
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
          text: iscontrol,
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
          text: "${ctp:i18n('privilege.resource.code.label')}",
          value: 'resourceCode'
        }
      ]
    });
  });
  
  function loadTable(condition, value){
    // 手动加载表格数据
    var o1 = new Object();
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
    }
    var cmd = $afg.cmd;
    o1.ext4 = "${appResCategory}";
    // 选择入口资源
    if(cmd === "pageRes"){
      o1.ext1 = 0;
    // 选择导航资源
    }else if(cmd === "naviRes"){
      o1.ext1 = 1;
    // 选择主资源
    }else if(cmd === "mainRes"){
      o1.ext4 = 1;
    // 选择快捷资源
    }else if(cmd === "shortcutRes"){
      o1.productVersion = "${productVersion}";
      o1.ext4 = 2;
    }
    if(condition){
      eval("o1." + condition + " = '" + value + "';");
      o1.refreshCurPage = true;
    }
    $("#mytable1").ajaxgridLoad(o1);
    delete o1.refreshCurPage;
  }

  //
  function OK() {
    var frmobj = $("#mytable1").formobj();
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
    }
    var cmd = $afg.cmd;
    if(cmd === "naviRes" || cmd === "shortcutRes"){
      var frmobj = $(".mytable").formobj({
        gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
        }
      });
    }
    return frmobj;
  }
</script>
