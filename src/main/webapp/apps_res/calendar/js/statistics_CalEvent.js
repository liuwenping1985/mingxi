  $(function(){
  		//OA-80629第一次进入日程事件-统计页面，重要紧急显示无数据，但是穿透有数据
  		toStatistics();
  })
  function toStatistics() {
    var vali = $("#statistics").validate();
    if (vali) {
      if ($("#beginDate").val() > $("#endDate").val()) {
        $.alert($.i18n('calendar.event.create.state.beginTimeEnd'));
        return;
      }
      var ajaxTestBean = new calEventManager();
      var frmobj = $("#statistics").formobj();
      var calEvent2 = ajaxTestBean.getStatistics(frmobj);
      document.getElementById("statisticContent").innerHTML = "";
      for ( var i = 0; i < calEvent2[0].length; i++) {
        document.getElementById("statisticContent").innerHTML = document
            .getElementById("statisticContent").innerHTML
            + "<a href='javascript:showDate("
            + calEvent2[3][i]
            + ");'>"
            + calEvent2[0][i]
            + "</a><p class='padding_l_10 padding_tb_10' style='height: 20px;'>"
            + calEvent2[1][i] + "</p>";

      }

      var indexNames = calEvent2[0];
      var simpleDataList = new Array(calEvent2[2]);

      new SeeyonChart({
        htmlId : "tttt",
        animation : true,
        chartType : 7,
        is3d : true,
        border : false,
        legend : "{%Icon}{%Name}{enabled:False} {%YPercentOfTotal}%",
        indexNames : indexNames,
        dataList : simpleDataList
      });

      if ($("#statisticsType").val() == 2) {
        $("#sjlx").removeClass("hidden");
      } else {
        $("#sjlx").addClass("hidden");
      }
    }
  }
  function showDate(id) {
    var frmobj = $("#statistics").formobj();
    frmobj.testSearch = id;
    $.dialog({
      url : _ctxPath
          + '/calendar/calEvent.do?method=listShowCalEventByStatis&id='
          + $.toJSON(frmobj),
      width : 700,
      height : 500,
      minParam : {
        'show' : false
      },
      maxParam : {
        'show' : false
      },
      targetWindow : getCtpTop(),
      title : $.i18n('calendar.event.create.reply.search.all')
    });
  }