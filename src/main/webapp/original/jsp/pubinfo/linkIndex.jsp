<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<style>
.stadic_right {
  float: right;
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: 100;
}

.stadic_right .stadic_content {
  margin-left: 310px;
  height: 100%;
}

.stadic_left {
  float: left;
  width: 310px;
  height: 100%;
  position: absolute;
  z-index: 300;
}

.stadic_head_height {
  height: 35px;
}

.stadic_body_top_bottom {
  bottom: 0px;
  top: 35px;
}
</style>
<script type="text/javascript">
  var treeParams = {
    idKey : "id",
    pIdKey : "categoryId",
    nameKey : "name",
    onClick : treeClk,
    managerName : "pubInfoManager",
    managerMethod : "getPubTrees",
    asyncParam : {},
    onAsyncSuccess : treeSuccess,
    nodeHandler : function(n) {
      if (n.data.sourceType == -1) {
        n.open = true;
      }
    }
  };

  var mytable;

  $().ready(function() {
    mytable = $("#mytable").ajaxgrid({
      parentId : "mydiv",
      colModel : [ {
        display : "id",
        name : "id",
        width : "5%",
        sortable : false,
        align : "center",
        type : "radio"
      }, {
        display : "${ctp:i18n('bul.type.name.title')}",
        name : "name",
        width : "90%"
      }, {
        display : "showType",
        name : "showType",
        hide : true
      }, {
        display : "sourceType",
        name : "sourceType",
        hide : true
      }, {
        display : "formAppmainId",
        name : "formAppmainId",
        hide : true
      } ],
      managerName : "pubInfoManager",
      managerMethod : "getPubInfos",
      showToggleBtn : false,
      onSuccess : function() {
        var node = $("#linkTree").treeObj().getSelectedNodes()[0];
        if (node && node.data.sourceType != "-1") {
            $("#mytable input[type='radio']").each(function() {
              if (node.data.sourceValue == parent.backFormAppmainId && $(this).val() == parent.backSourceValue) {
                $(this).attr("checked", true);
              }
            });
        }
      }
    });

    tableLoad();
    treeLoad();

    $("#typeSearch").click(function() {
      var dataVal = $("#typeTxt").val();
      treeParams.asyncParam.conditionValue = escapeStringToHTML(dataVal);
      treeLoad();
    });

    $("#dataSearch").click(function() {
      var dataVal = $("#dataTxt").val();
      var node = $("#linkTree").treeObj().getSelectedNodes()[0];
      if (node && node.data.sourceType != "-1") {
        tableLoad(node.data.sourceType, node.data.sourceValue, dataVal);
      }
    });
  });

  function treeLoad() {
    $("#linkTree").empty();
    $("#linkTree").tree(treeParams);
    $("#linkTree").treeObj().reAsyncChildNodes(null, "refresh");
  }

  function treeSuccess() {
    if (treeParams.asyncParam.conditionValue) {
      $("#linkTree").treeObj().expandAll(true);
    }
    if (parent.backLinkType == "pubInfo") {
      var nodes = $("#linkTree").treeObj().getNodesByParam("id", parent.backFormAppmainId);
      for (var i = 0; i < nodes.length; i++) {
          if (nodes[i].data.sourceType == "0" || nodes[i].data.sourceType == parent.backSourceType) {
              $("#linkTree").treeObj().selectNode(nodes[i]);
              tableLoad(nodes[i].data.sourceType, nodes[i].data.sourceValue);
          }
      }
    }
  }

  function treeClk(e, treeId, node) {
    if (node.data.sourceType != "-1") {
      tableLoad(node.data.sourceType, node.data.sourceValue);
    }
  }

  function tableLoad(sourceType, sourceValue, conditionValue) {
    var o = new Object();
    if (sourceType != null) {
      o.sourceType = sourceType;
    }
    if (sourceValue != null) {
      o.sourceValue = sourceValue;
    }
    if (conditionValue != null) {
      o.conditionValue = conditionValue;
    }
    $("#mytable").ajaxgridLoad(o);
  }

  function getSelectedData() {
    var s = mytable.grid.getSelectRows();
    if (s.length > 0) {
      $("#_linkType").val("pubInfo");
      $("#_linkShowType").val(s[0].showType);
      $("#_sourceType").val(s[0].sourceType);
      $("#_sourceValue").val(s[0].id);
      $("#_formAppmainId").val(s[0].formAppmainId);
    }
  }
</script>
</head>
<body class="h100b over_hidden">
    <input type="hidden" id="_linkType" />
    <input type="hidden" id="_linkShowType" />
    <input type="hidden" id="_sourceType" />
    <input type="hidden" id="_sourceValue" />
    <input type="hidden" id="_formAppmainId" />
    <div class="stadic_layout">
        <div class="stadic_right">
            <div class="stadic_content">
                <div class="stadic_layout">
                    <div class="stadic_layout_head stadic_head_height">
                        <ul class="common_search right" style="padding-top: 5px; margin-right: 5px;">
                            <li class="common_search_input"><input id="dataTxt" class="search_input" type="text"></li>
                            <li><a id="dataSearch" class="common_button common_button_gray search_buttonHand" href="javascript:void(0)"><em></em></a></li>
                        </ul>
                    </div>
                    <div id="mydiv" class="stadic_layout_body stadic_body_top_bottom">
                        <table id="mytable" style="display: none"></table>
                    </div>
                </div>
            </div>
        </div>
        <div class="stadic_left border_r">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                    <ul class="common_search" style="padding-top: 5px; margin-left: 5px;">
                        <li class="common_search_input"><input id="typeTxt" class="search_input" type="text"></li>
                        <li><a id="typeSearch" class="common_button common_button_gray search_buttonHand" href="javascript:void(0)"><em></em></a></li>
                    </ul>
                </div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="linkTree"></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>