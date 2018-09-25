  function OK() {
    var timeLineType = new Array();
    $("[name = timeLineType]:checkbox").each(function() {
        if ($(this).is(":checked")) {
          timeLineType.push($(this).attr("value"));
        }
    });
    timeLineType = timeLineType.join(",");
    var url = "calEvent.do?method=saveTimeLine";
    if (timeLineType != null && timeLineType.length != 0 && timeLineType != "") {
        url = url + "&timeLineType=" + timeLineType;
    } else {
        $.alert($.i18n('calendar.editTimeLine.time.source'));
        return false;
    }
    $("#calEventPeriodicalRelation").attr("action", url);
    if (parseInt($("#beginTime").val()) > parseInt($("#endTime").val())) {
        $.alert($.i18n('calendar.editTimeLine.time.error'));
        return false;
    } else if (parseInt($("#endTime").val()) - parseInt($("#beginTime").val()) > 10 || parseInt($("#endTime").val()) - parseInt($("#beginTime").val()) < 1) {
        $.alert($.i18n('calendar.editTimeLine.time.arrange'));
        return false;
    } else {
        $("#calEventPeriodicalRelation").jsonSubmit({ callback : function() {
            parentWindowData.searchFunc(parentWindowData.timeLineObjResetParam);
            parentWindowData.diaClose();
          }
        });
    }
  }
  
  function loadData() {
      for ( var i = 0; i < eventType.length; i++) {
          var curCheckBox = document.getElementById("Checkbox" + eventType[i]);
          if (curCheckBox != null) {
            curCheckBox.checked = "checked";
          }
      }
  }
  
  function selectCheckBox(obj) {
    var checkBoxObj = $("#" + obj);
    if(checkBoxObj.attr("checked") == true || checkBoxObj.attr("checked") == "checked") {
      checkBoxObj.removeAttr("checked");
    } else {
      checkBoxObj.attr("checked","true");
    }
  }