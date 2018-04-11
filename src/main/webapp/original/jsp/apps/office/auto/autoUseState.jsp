<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.auto.car.use.amount.js')}</title>
<head>
<style type="text/css" media="screen">
html,body {
  margin: 0px;
  padding: 0px;
  height: 100%;
  width: 100%;
}
.dhx_cal_event_line{
  cursor: default;
}
</style>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/dhtmlxscheduler-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/<%=locale%>-debug.js"></script>
<script type="text/javascript">
  var curType = "week";//视图类型
  var calevents = eval(<c:out value="${calevents}" default="null" escapeXml="false"/>);//显示数据
  
  //刷新页面
  function refreshPage() {
    var year = $("#year").val();
    var month = $("#month").val();
    var day = $("#day").val();
    var curDate = new Date(year, month, day);
    dateChange(curType, curDate);
  }
  
  //切换日期
  function dateChange(type, nextDate) {
    //alert("切换日期：" + nextDate);
    var url = _ctxPath + "/office/autoUse.do?method=autoUseState";
    try {
      var temp = nextDate.split('-');
      nextDate = new Date(temp[0], (temp[1] - 1), temp[2]);
    } catch (e) {
      
    }
    var selectedDate = nextDate.format("yyyy-MM-dd");
    url = url + "&selectedDate=" + selectedDate + "&autoId="+"${autoId}";
    
    setTimeout(function() {
      window.location.href = url;
    }, 0);
  }
  
  //页面初始化
  function init() {
    var year = $("#year").val();
    var month = $("#month").val();
    var day = $("#day").val();
  
    scheduler.config.multi_day = true;// 日视图、周视图允许显示全天、跨天日程
    scheduler.config.xml_date = "%Y-%m-%d %H:%i";// 数据时间格式
    scheduler.config.dblclick_create = false;// 禁止双击创建
    scheduler.config.drag_create = false;// 禁止拖拽创建
    scheduler.config.drag_resize = false;// 日视图、周视图禁拖拽改变时间
    scheduler.config.drag_move = false;// 月视图禁止拖拽改变时间
    scheduler.config.hour_size_px = 84;// 时间高度
    scheduler.config.scroll_hour = 9;// 定位初始时间
    scheduler.config.prevClick = dateChange;
    scheduler.config.nextClick = dateChange;
    scheduler.maxLength = 3;// 全天、跨天日程显示多少条
    scheduler.xy.nav_height = 40;// 导航高度
    scheduler.xy.bar_height = 30;// 全天、跨天日程之前的间隔
    scheduler.attachEvent("onClick", function(id) {
      return false;
    });
    scheduler.attachEvent("onDblClick", function() {
      return false;
    });
    scheduler.config.xml_date = "%Y-%m-%d %H:%i";
    scheduler.init('scheduler_here', new Date(year, month, day), curType);// 初始化显示当天日期+周视图
    
    //解析车辆占用情况
    var datas = new Array();
    if (calevents != null && calevents.length > 0) {
      for ( var i = 0; i < calevents.length; i++) {
        var calevent = calevents[i];
        var data = new Object();
        data.id = calevent.id;
        data.start_date = calevent.beginDate;
        data.end_date = calevent.endDate;
        if(calevent.hasAcl==true){
          if(calevent.applyUser == "-1"){
            data.text = calevent.applyDes;
          }else{
            data.text = calevent.applyUser+"${ctp:i18n('office.stock.useCar.aimAdd.js')}"+calevent.applyDes;
          }
        }else{
          data.text ="";
        }
        data.type = "auto"+calevent.type;
        datas[i] = data;
      }
    }
    scheduler.parse(datas, "json");
  }
</script>
</head>
<body onload="init();" class="bg_color_gray">
  <input type="hidden" id="year" name="year" value="${year}">
  <input type="hidden" id="month" name="month" value="${month}">
  <input type="hidden" id="day" name="day" value="${day}">
  <div class="stadic_layout bg_color_gray" style="font-size: 0;">
    <div id="scheduler_here" class="dhx_cal_container" style="width: 100%; height: 100%;">
      <div class="dhx_cal_navline">
        <div style="position: absolute; top: 2px; left: 50px; margin-top: 15px;">
          <div class="dhx_cal_prev_button" id="dhx_cal_prev_button">&nbsp;</div>
          <div class="dhx_cal_date" id="dhx_cal_date"></div>
          <div class="dhx_cal_next_button" id="dhx_cal_next_button">&nbsp;</div>
        </div>
        <div style="position: absolute; top: 2px; right: 50px; margin-top: 15px;">
          <div style="background-color: #FFFFFF; width:35px; height: 15px; float:left;border:1px #000 solid">
          </div>
          <span class="padding_r_10 padding_l_5 left">${ctp:i18n('office.asset.query.state.free.js')}</span>
          <div style="background-color: #01FF18; width:35px; height: 15px; float:left;border:1px #000 solid">
          </div>
          <span class="padding_r_10 padding_l_5 left">${ctp:i18n('office.autouse.state2.js')}</span>
          <div style="background-color: #6C6C6C; width:35px; height: 15px; float:left;border:1px #000 solid">
          </div>
          <span class="padding_r_10 padding_l_5 left">${ctp:i18n('office.auto.all.state.js')}</span>
        </div>
      </div>
      <div class="dhx_cal_header"></div>
      <div class="dhx_cal_data"></div>
    </div>
  </div>
</body>
</html>