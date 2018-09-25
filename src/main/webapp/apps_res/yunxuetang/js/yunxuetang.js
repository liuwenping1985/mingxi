var yxtToolbar;
$(function() {
  yxtToolbar = createYXTToolBar();
  createYXTTree();
  createYXTTable();

  if (_apiKey != "true") {
    yxtToolbar.disabled("synAll");
    yxtToolbar.disabled("synSelected");
    yxtToolbar.disabled("showApiKey");
  } else {
    yxtToolbar.disabled("getApiKey");
    yxtToolbar.disabled("enterApiKey");
  }

  $("#btn_ok").click(function() {
    var confirm = $.messageBox({
      'type': 3,
      'msg': $.i18n('yunxuetang.saveConfigType.message.js'),
      yes_fn: function () { saveSynConfig("yes"); },
      no_fn:function(){saveSynConfig("no"); }
    });
  });
});

function createYXTToolBar() {
  return $("#toolbar").toolbar({
    "toolbar" : [ {
      id : "synAll",
      name : $.i18n('yunxuetang.toolbar.button.0.js'),
      className : "ico16",
      click : function() {
        var message = $.i18n('yunxuetang.msg.3.js');
        var confirm = $.confirm({
          "msg" : message,
          ok_fn : function() {
            getCtpTop().startProc($.i18n('yunxuetang.syn.start.js'));
            synAll("cleanBeforeSyn");
          },
          cancel_fn : function() {
          }
        });
      }
    }, {
      id : "synSelected",
      name : $.i18n('yunxuetang.toolbar.button.1.js'),
      className : "ico16",
      click : function(e) {
        checkFirstTime();
      }
    }, {
      id : "getApiKey",
      name : $.i18n('yunxuetang.toolbar.button.2.js'),
      className : "ico16",
      click : function(e) {
        getApiKey();
      }
    }, {
      id : "enterApiKey",
      name : $.i18n('yunxuetang.toolbar.button.3.js'),
      className : "ico16",
      click : function(e) {
        showApiKey('edit');
      }
    }, {
      id : "showApiKey",
      name : $.i18n('yunxuetang.toolbar.button.4.js'),
      className : "ico16",
      click : function(e) {
        showApiKey('view');
      }
    } ]
  });
}

function createYXTTree() {
  $("#yxtTree").tree({
    onClick : yxtTreeClick,
    idKey : "id",
    pIdKey : "parentId",
    nameKey : "name",
    managerName : "yxtSynManager",
    managerMethod : "showAccountTree",
    nodeHandler : function(n) {
      if (n.data.parentId == "0") {
        n.open = true;
      } else {
        n.open = false;
      }
    }
  });
  $("#yxtTree").treeObj().reAsyncChildNodes(null, "refresh", false);
}

function createYXTTable() {
  $("#yxtTable").ajaxgrid({
    managerName : "yxtSynManager",
    managerMethod : "showTable",
    usepager : false,
    slideToggleBtn : false,
    customize : false,
    resizable : false,
    render : yxtRend,
    onSuccess : function() {
      $("#yxtTable input[type='checkbox']").each(function() {
        if ($("#span" + $(this).val()).attr("value") == "1") {
          $(this).attr("checked", true);
        }
      });
    },
    height : 400,
    colModel : [ {
      display : 'id',
      name : 'id',
      width : '5%',
      align : 'center',
      type : 'checkbox'
    }, {
      display : $.i18n('yunxuetang.table.th.0.js'),
      name : 'name',
      width : '50%',
    }, {
      display : $.i18n('yunxuetang.table.th.1.js'),
      name : 'type',
      width : '15%'
    }, {
      display : $.i18n('yunxuetang.table.th.2.js'),
      name : 'synConfig',
      width : '15%'
    }, {
      display : $.i18n('yunxuetang.table.th.3.js'),
      name : 'synState',
      width : '10%'
    } ]
  });
}

function synAll(synType) {
  var data = {
    synType : synType
  };
  ajax_yxtSynManager.synAll(data, {
    success : function(rv) {
      if (rv == "0") {
        $.infor($.i18n('yunxuetang.syn.return.0.js'));
        var nodes = $("#yxtTree").treeObj().getSelectedNodes();
        if (nodes.length > 0) {
          yxtTreeClick(null, null, nodes[0]);
        }
      } else {
        if ("-2" == rv) {
          $.alert($.i18n('yunxuetang.syn.return.1.js'));
        } else if ("-3") {
          $.alert($.i18n("yunxuetang.syn.return.2.js"));
        } else {
          $.alert($.i18n('yunxuetang.syn.return.3.js'));
        }
      }
      getCtpTop().endProc();
    },
    error : function(data) {
      $.error($.i18n('yunxuetang.syn.return.3.js'));
      getCtpTop().endProc();
    }
  });
}

function synSelected(synType) {
  var data = {
    synType : synType
  };
  getCtpTop().startProc();
  ajax_yxtSynManager.synSelected(data, {
    success : function(rv) {
      if (rv == "0") {
        $.infor($.i18n('yunxuetang.syn.return.0.js'));
        var nodes = $("#yxtTree").treeObj().getSelectedNodes();
        if (nodes.length > 0) {
          yxtTreeClick(null, null, nodes[0]);
        }
      } else {
        if ("-2" == rv) {
          $.alert($.i18n('yunxuetang.syn.return.1.js'));
        } else if ("-3") {
          $.alert($.i18n('yunxuetang.syn.return.2.js'));
        } else {
          $.alert($.i18n('yunxuetang.syn.return.3.js'));
        }
      }
      getCtpTop().endProc();
    },
    error : function(data) {
      $.error($.i18n('yunxuetang.syn.return.3.js'));
      getCtpTop().endProc();
    }
  });
}

function getApiKey() {
  if (_apiKey == "true") {
    $.confirm({
      "msg" : $.i18n('yunxuetang.msg.0.js'),
      ok_fn : function() {
        getApiKeyDialog();
      },
      cancel_fn : function() {
      }
    });
  } else {
    getApiKeyDialog();
  }
}

function getApiKeyDialog() {
  var yxtDialog = $.dialog({
    url : _path + '/yunxuetang/yxtSyn.do?method=getApiKey',
    title : $.i18n('yunxuetang.dialog.title.1.js'),
    width : 450,
    height : 220,
    buttons : [ {
      text : $.i18n('common.button.ok.label'),
      id : "ok",
      isEmphasize : true,
      handler : function() {
        var re = yxtDialog.getReturnValue();
        if (re) {
          saveApiKey(re.yxtOrgName, re.yxtDomainName, re.yxtMobile);
          yxtDialog.close();
        }
      }
    }, {
      text : $.i18n('common.button.cancel.label'),
      id : "cancel",
      handler : function() {
        yxtDialog.close();
      }
    } ]
  });
}

function saveApiKey(yxtOrgName, yxtDomainName, yxtMobile) {
  var data = {
    yxtOrgName : yxtOrgName,
    yxtDomainName : yxtDomainName,
    yxtMobile : yxtMobile
  };

  ajax_yxtSynManager.saveApiKey(data, {
    success : function(rv) {
      rv = $.parseJSON(rv);
      if (rv.code == "0") {
        yxtToolbar.enabled("synAll");
        yxtToolbar.enabled("synSelected");
        yxtToolbar.enabled("showApiKey");
        yxtToolbar.disabled("getApiKey");
        yxtToolbar.disabled("enterApiKey");
        _apiKey = "true";
        var ak = rv.apikey;
        var sn = rv.signature;
        var dn = rv.domainName;
        showApiKey("view");
        // $.infor($.i18n('yunxuetang.syn.return.8.js')+"<br>"+$.i18n('yunxuetang.getApiKey.form.1.js')+dn
        // + "<br>"+$.i18n('yunxuetang.showApiKey.signature.js') +
        // sn+"<br>"+$.i18n('yunxuetang.showApiKey.apikey.js') + ak);
      } else {
        // 这里显示不成功的信息
        $.alert(rv.message);
      }

    },
    error : function(data) {
      $.error($.i18n("yunxuetang.syn.return.7.js"));
    }
  });
}
var yxtDialog;
function showApiKey(type) {
  var title = (type == 'edit' ? $.i18n('yunxuetang.dialog.title.2.js') : $
      .i18n('yunxuetang.dialog.title.3.js'));
  if (type == 'reg') {
    title = $.i18n('yunxuetang.syn.return.8.js');
    type = 'view';
  }
  yxtDialog = $.dialog({
    url : _path + '/yunxuetang/yxtSyn.do?method=showApiKey&type=' + type,
    title : title,
    width : 450,
    height : 220,
    buttons : [ {
      text : $.i18n('common.button.ok.label'),
      id : "ok",
      isEmphasize : true,
      handler : function() {
        if (type == 'edit') {
          var re = yxtDialog.getReturnValue();
          insertApikey(re.yxtOrgName, re.apikey, re.signature);
        }
      }
    }, {
      text : $.i18n('common.button.cancel.label'),
      id : "cancel",
      handler : function() {
        yxtDialog.close();
      }
    } ]
  });
}

function yxtTreeClick(e, treeId, node) {
  if (_apiKey == "true") {
    $("#btnDiv").show();
  }

  var o = new Object();
  if (node.data.parentId == "0") {
    o.id = "-1";
    $("#selectType").val("account");
  } else {
    o.id = node.data.id;
    $("#selectType").val("dept");
  }
  $("#selectId").val(o.id);
  $("#yxtTable").ajaxgridLoad(o);
}

function yxtRend(txt, row, rowIndex, colIndex, col) {
  if (col.name == "type") {
    return $.i18n("yunxuetang.syn.type." + txt + ".js");
  }
  if (col.name == "synConfig") {
    return "<span id='span" + row.id + "' value='" + txt + "'>"
        + $.i18n("yunxuetang.syn.config." + txt + ".js") + "</span>";
  }
  if (col.name == "synState") {
    return $.i18n("yunxuetang.syn.state." + txt + ".js");
  }
  return txt;
}

function saveSynConfig(isAll) {
  var selectType = $("#selectType").val();
  var selectId = $("#selectId").val();

  var checkedIds = "";
  $("#yxtTable input[type='checkbox']").each(function() {
    if ($(this).attr("checked")) {
      checkedIds += $(this).val() + ",";
    }
  });

  var data = {
    selectType : selectType,
    selectId : selectId,
    checkedIds : checkedIds,
    isAll : isAll
  };

  ajax_yxtSynManager.saveSynConfig(data, {
    success : function(rv) {
      $.infor($.i18n('yunxuetang.syn.return.4.js'));
      var nodes = $("#yxtTree").treeObj().getSelectedNodes();
      if (nodes.length > 0) {
        yxtTreeClick(null, null, nodes[0]);
      }
    },
    error : function(data) {
      $.error($.i18n('yunxuetang.syn.return.5.js'));
    }
  });
}
function insertApikey(orgDomain, apikey, signature) {
  getCtpTop().startProc();
  var data = {
    orgDomain : orgDomain,
    apikey : apikey,
    signature : signature
  };

  ajax_yxtSynManager.checkApikey(data, {
    success : function(rv) {
      rv = $.parseJSON(rv);
      if (rv.code == "0") {
        $.infor($.i18n('yunxuetang.syn.return.4.js'));
        yxtToolbar.enabled("synAll");
        yxtToolbar.enabled("synSelected");
        yxtToolbar.enabled("showApiKey");
        yxtToolbar.disabled("getApiKey");
        yxtToolbar.disabled("enterApiKey");
        _apiKey = "true";
        yxtDialog.close();
      } else if (rv.code == "-1") {
        $.alert($.i18n('yunxuetang.syn.return.6.js'));
      } else {
        $.alert(rv.message);
      }
      getCtpTop().endProc();
    },
    error : function(data) {
      $.error($.i18n('yunxuetang.syn.return.5.js'));
      getCtpTop().endProc();
    }
  });
}
//判定是否第一次同步
function checkFirstTime() {
  ajax_yxtSynManager.checkUsed(null, {
    success : function(rv) {
      rv = $.parseJSON(rv);
      if (rv.code == "0") {
        synSelected("cleanBeforeSyn");
      } else{
        var yxtDialog = $.dialog({
          url : _path + '/yunxuetang/yxtSyn.do?method=getSynType',
          title : $.i18n('yunxuetang.dialog.title.0.js'),
          width : 450,
          height : 120,
          buttons : [ {
            text : $.i18n('common.button.ok.label'),
            id : "ok",
            isEmphasize : true,
            handler : function() {
              var re = yxtDialog.getReturnValue();
              var message;
              if (re.type == "cleanBeforeSyn") {
                message = $.i18n("yunxuetang.msg.1.js");
              } else {
                message = $.i18n("yunxuetang.msg.2.js");
              }
              if (re) {
                var confirm = $.confirm({
                  "msg" : message,
                  ok_fn : function() {
                    getCtpTop().startProc($.i18n('yunxuetang.syn.start.js'));
                    synSelected(re.type);
                  },
                  cancel_fn : function() {
                  }
                });
                yxtDialog.close();
              }
            }
          }, {
            text : $.i18n('common.button.cancel.label'),
            id : "cancel",
            handler : function() {
              yxtDialog.close();
            }
          } ]
        });
      }
    },
    error : function(data) {
    }
  });
}