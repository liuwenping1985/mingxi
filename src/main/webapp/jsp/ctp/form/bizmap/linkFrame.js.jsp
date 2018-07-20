<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript">
  $().ready(function() {
    var categoryArray = new Array();
    <c:forEach items="${categoryList}" var="item">
    categoryArray.push({
      text : "${ctp:toHTML(item.name)}",
      value : "${item.id}"
    });
    </c:forEach>

    if (categoryArray.length == 0) {
      categoryArray.push({
        text : "",
        value : ""
      });
    }

    var subjectText = "${bizMapLinkType.id}" == "formMap" ? "${ctp:i18n('form.bizmap.name.label')}" : "${ctp:i18n('formsection.config.template.name')}";
    var searchObj = $.searchCondition({
      top : 5,
      left : 10,
      searchHandler : function() {
        var rv = searchObj.g.getReturnValue();
        if (rv) {
          linkSearch($("#searchType").val(), rv.condition, rv.value);
        }
      },
      conditions : [ {
        id : "subject",
        name : "subject",
        type : "input",
        text : subjectText,
        value : "subject"
      }, {
        id : "category",
        name : "category",
        type : "select",
        text : "${ctp:i18n('formsection.config.template.category')}",
        value : "categoryId",
        items : categoryArray
      } ]
    });
    
    if ("${bizMapLinkType.id}" == "formMap") {
      searchObj.g.hideItem("category");
    }
    
    $("#view").click(function(){
      if ($("#_linkType").length > 0) {
        var linkType = $("#_linkType").val();
        var sourceType = $("#_sourceType").val();
        if (linkType == "formBaseInfo" || linkType == "formManageInfo") {
          if (sourceType == "-1" || sourceType == "0") {
            $("#domain2").empty();
          }
        }
      }
    });

    if ("${bizMapLinkType.supportedSearchType}" == "1") {
      $("#admin").click();
    }

    if ("${bizMapLinkType.supportedSearchType}" == "2") {
      $("#user").click();
    }
    
    if (parent.backLinkType) {
      if (parent.backLinkType != "doc" && parent.backLinkType != "pubInfo") {
        if (parent.backLinkShowType == "0") {
          $("#view").click();
        } else {
          $("#list").click();
        }
        selectToRightDiv();
      }
    }
  });

  function linkSearch(searchType, condition, value) {
    $("#searchType").val(searchType);
    $("#condition").val(condition);
    $("#textfield").val(value);
    $("#searchForm").jsonSubmit({
      targetWindow : $("#tree_iframe")[0].contentWindow
    });
  }

  function selectToRight() {
    var oSelected = $("#tree_iframe")[0].contentWindow.getSelectedNode();
    if (oSelected != null) {
      if ("${ctp:escapeJavascript(param.linkType)}" == "formMap" && oSelected.data.sourceType == "-1") {
          return;
      }
      if ("${ctp:escapeJavascript(param.linkType)}" == "formBaseInfo" || "${ctp:escapeJavascript(param.linkType)}" == "formManageInfo") {
          if (oSelected.data.sourceType == "-1" || oSelected.data.sourceType == "0") {
              $("#list").click();
          }
      }
      parent.backLinkType = "${ctp:escapeJavascript(param.linkType)}";
      parent.backLinkShowType = $("input:radio[name='linkShowType']:checked").val();
      if (!parent.backLinkShowType) {
        parent.backLinkShowType = "";
      }
      parent.backName = oSelected.data.name.escapeHTML();
      parent.backSourceType = oSelected.data.sourceType;
      parent.backSourceValue = oSelected.data.sourceValue;
      if (!parent.backSourceValue) {
        parent.backSourceValue = "";
      }
      parent.backFormAppmainId = oSelected.data.formAppmainId;
      if (!parent.backFormAppmainId) {
        parent.backFormAppmainId = "";
      }
      selectToRightDiv();
    }
  }
  
  function selectToRightDiv() {
    var oDiv = new StringBuffer();
    var icon = "text_type_template_16";
    if (parent.backSourceType == "-1" || parent.backSourceType == "0") {
      icon = "folder_16";
    }
    oDiv.append('<div onclick="selectTrObj(this);" ondblclick="removeToLeft();" class="hand font_size12">');
    oDiv.append('   <div style="line-height: 30px; margin-left: 10px;"><span class="ico16 ' + icon + '"></span><span class="margin_l_5">' + parent.backName + '</span></div>');
    oDiv.append('   <input type="hidden" id="_linkType" value="' + parent.backLinkType + '" />');
    oDiv.append('   <input type="hidden" id="_linkShowType" value="' + parent.backLinkShowType + '" />');
    oDiv.append('   <input type="hidden" id="_sourceType" value="' + parent.backSourceType + '" />');
    oDiv.append('   <input type="hidden" id="_sourceValue" value="' + parent.backSourceValue + '" />');
    oDiv.append('   <input type="hidden" id="_formAppmainId" value="' + parent.backFormAppmainId + '" />');
    oDiv.append('</div>');
    $("#domain2").html(oDiv.toString());
  }

  function selectTrObj(trObj) {
    $(trObj).css("background", "highlight");
    $(trObj).css("color", "highlighttext");
  }

  function removeToLeft() {
    $("#domain2").empty();
  }
</script>
