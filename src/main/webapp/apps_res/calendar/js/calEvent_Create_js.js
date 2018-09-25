var curType;
var curUserID = $("#currentUserId").val();
$(function() {
  var curTypeNum;
  curType = $("#type").val();
  if(curType=="day"){
    curTypeNum=0;
    $("#day_tab").css("color","");
  }
  if(curType=="week"){
    curTypeNum=1;
    $("#week_tab").css("color","");
  }
  if(curType=="month"){
    curTypeNum=2;
    $("#month_tab").css("color","");
  }
  $("#dhx_cal_common_tabs li").removeClass("current").eq(curTypeNum).addClass("current");
});

function refleshPage(){
	var year = $("#year").val();
	var month = $("#month").val();
	var day = $("#day").val();
    var curDate = new Date(year, month,day);
    dateChange(curType, curDate);
}

function init() {
  curType = $("#type").val();
  curNextDate = new Date();
  var year = $("#year").val();
  var month = $("#month").val();
  var day = $("#day").val();
  var arrangePage = $("#arrangePage").val();
  var source = $("#source").val();
  scheduler.url = arrangePage; //由于事件视图、时间安排、各个时间控件portal都调用了这个js，所以刷新的时候，需要知道刷新的到底是哪个页面
  scheduler.config.multi_day = true;//日视图、周视图允许显示全天、跨天日程
  scheduler.config.xml_date = "%Y-%m-%d %H:%i";//数据时间格式
  scheduler.config.dblclick_create = false;//禁止双击创建
  scheduler.config.drag_create = false;//禁止拖拽创建
  scheduler.config.drag_resize = false;//日视图、周视图禁拖拽改变时间
  scheduler.config.drag_move = false;//月视图禁止拖拽改变时间
  scheduler.config.hour_size_px = 84;//时间高度
  scheduler.config.scroll_hour = $("#iniHour").val();//定位初始时间
  scheduler.config.tabClick = dateChange;
  scheduler.config.prevClick = dateChange;
  scheduler.config.nextClick = dateChange;
    if (arrangePage=='arrangeMonthTime'){ //时间视图的月视图——点击会议、任务等单击事件
      if (source=='arrangeMonthTimeForView'){ //日程事件的点击事件查看详细信息--日程事件portal月视图
       scheduler.getId = function (id) { //单击事件，参数为事件id
    	    var calEvent = this.getEvent(id);
            showDate(calEvent,refleshPage);
        }
       scheduler.config.goToPage =function (date) { //点击具体某一天进行穿透
          var curTime = date.split(" ")[0]; // 当前的日期格式为 yyyy - MM-dd HH：mm 取【0】的意思是只取日期
           url = _ctxPath+"/calendar/calEvent.do?method=calEventIndex&calEventViewSetion=true&curDate="+curTime;
           setTimeout(function(){  
             window.parent.location.href = url;
          },0);  
        }
       }
     if(source!='arrangeMonthTimeForView'){ //时间视图portal月视图
       scheduler.getId = function (id) { //单击事件，参数为事件id
          var calEvent = this.getEvent(id);
          showDate(calEvent,refleshPage);
       }
       scheduler.config.goToPage =function (date) { //点击具体某一天进行穿透
          var curTime = date.split(" ")[0]; // 当前的日期格式为 yyyy - MM-dd HH：mm 取【0】的意思是只取日期
          url = _ctxPath+"/calendar/calEvent.do?method=arrangeTime&type=day&selectedDate="+curTime+"&curDay="+curTime;
          setTimeout(function(){  
             window.parent.location.href = url;
          },0);  
       }
       scheduler.maxLength = 3;//全天、跨天日程显示多少条
     }
     scheduler.isPortal = true;//是否在portal显示     
     scheduler.xy.nav_height = 20;//导航高度
     scheduler.dayEvent = [];
     $(".dhx_cal_prev_button,.dhx_cal_next_button,.dhx_cal_date").css("margin-top","0")
  }
  if(arrangePage=='arrangeWeeKTime' || $("#param_app").val()=='6'){
    var _body = $('body').width(); //这里的判断主要是时间安排portal的周视图窄栏处理
    if (_body < 700) {
      $('#scheduler_here').css( {
        width : "1260px"
      });
      $('html').css( {
        "overflow-x": 'auto',
        "overflow-y":"hidden"
      });
      $(".dhx_cal_navline").css({   
      "position":"fixed"
      })
      $(".stadic_body_top_bottom").css("top",0)
      $(".dhx_cal_prev_button,.dhx_cal_next_button,.dhx_cal_date").css("margin-top","0")

    }
    scheduler.maxLength = 3;//全天、跨天日程显示多少条
  }
  if (arrangePage=='arrangeTime'){
    scheduler.maxLength = 6;//全天、跨天日程显示多少条
    scheduler.xy.nav_height = 40;//导航高度
  }
  if(arrangePage=='calEventView'){
    scheduler.maxLength = 6;//全天、跨天日程显示多少条
    scheduler.xy.nav_height = 40;//导航高度
    if($("#tagetid").val()==""||$("#tagetid").val()==undefined){
    scheduler.config.clickMenu = [
                                  {
                                    name : $.i18n('calendar.event.view.add'),
                                    handle : function() {
                                      AddCalEvent(scheduler.config.currentDateTime);
                                      }
                                    }
                              ];
    }
  }
  if(arrangePage!='calEventView'){
    ///////////////////////////////屏蔽出我的会议日程视图 start
    if ($("#param_app").val()!='6'){ 
      if(arrangePage!='calEventView4RelateMember'){
      scheduler.config.clickMenu = getRightMenu();//单击是否有菜单
      }
    }
    ///////////////////////////////屏蔽出我的会议日程视图 end
  }
      
  scheduler.xy.bar_height = 30;//全天、跨天日程之前的间隔
  scheduler.attachEvent("onClick",function(id) {
	         var calEvent = this.getEvent(id);
             showDate(calEvent,refleshPage);
          });
  scheduler.attachEvent("onDblClick", function() {
    return false;
  });
  scheduler.config.xml_date = "%Y-%m-%d %H:%i";
  scheduler.init('scheduler_here', new Date(year, month,day), curType);//初始化显示当天日期+周视图
  //OA-80804领导视图- 事项展示区域- 时间线条完全没对齐
  $(".dhx_scale_hour").height("83px");
  $("#itemize").bind({
      mouseover: function () {
          $("#itemize_content").removeClass("hidden");
      },
      mouseout: function () {
          $("#itemize_content").addClass("hidden");
      }
  });
  var object = new Array();
  var calevent = null;
  if (calevents != null && calevents.length > 0) {
    for ( var i = 0; i < calevents.length; i++) {
      calevent = calevents[i].timeCalEvent;
      var cur = new Object();
      cur.id = calevent.id;
      cur.type = calevent.type;
      cur.states = calevent.states;
      cur.content = calevent.content; //加上了图标的字符串
      cur.text = calevent.content;
      if (cur.type == "event") {
        cur.shareType = calevent.shareType;
        cur.receiveMemberId = calevent.receiveMemberId;
        cur.createUserId = calevent.createUserId;
        if (calevent.states == 4) {
          cur.set_disable = 'true';
        }
      } else if (cur.type == "plan") {
        if (calevent.states == 3) {
          cur.set_disable = 'true';
        }
      } else if (cur.type == "task") {
        if (calevent.milestone == "1") { 
          var _tempStr = "right"; 
          if ($.browser.msie) { 
            if ($.browser.version == '6.0' || $.browser.version == '7.0') { 
              _tempStr= ""; 
            } 
          } 
          cur.ico = "milestone "+_tempStr; 
        } 
        if (calevent.states == "4") {
          cur.set_disable = 'true';
        }
      } else if (cur.type == "meeting") {
        if (calevent.states == 30 || calevent.states == 40 || calevent.states == -10) {
          cur.set_disable = 'true';
        }
        cur.canView = calevent.canView;
        ///////////////////////////////屏蔽出我的会议日程视图 start  
        if($("#param_app").val()=='6'){
          if(!calevent.canView) {
            calevent.content = '已有会议';
          }
        }
        cur.text = calevent.content;
        ///////////////////////////////屏蔽出我的会议日程视图 end  
      } else if (cur.type == "collaboration") {
        cur.ico = "work_time_set_16";
        if (calevent.states == "4") {
          cur.set_disable = 'true';
        }
      } else if (cur.type == "edoc") {
        cur.ico = "work_time_set_16";
        if (calevent.states == 4) {
          cur.set_disable = 'true';
        }
      }
      cur.start_date = calevent.beginDate;
      cur.end_date = calevent.endDate;
      object[i] = cur;
    }
  }
  scheduler.parse(object, "json");
  
  if ($("#param_app").val()=='6'){
    initPersonTab();
  }
  //OA-78385日程事件栏目穿透或更多页面，当前页面，名称没有显示      目前不清楚为啥IE多了一个class active
  try{ $("#dhx_cal_common_tabs>ul>li.current>a>div.active").removeClass("active");}catch(e){}
  if ($("#param_app").val()!='6') {
	  autoCenterCal();
  }
}
/**
 * 自动设置日期选择区域居中
 */
function autoCenterCal() {
	var calNavlineWidth = $("div .dhx_cal_navline").width();
	var diffWidth = 0;
	if ($("#cal_date_area").size() > 0) {
		var calDateAreaWidth = $("#cal_date_area").width();
		diffWidth = calNavlineWidth / 2 - calDateAreaWidth + 92;
		$("#cal_date_area").css("right", diffWidth+"px");
	}
	if ($("#cal_date_week_area").size() > 0) {
		var calDateAreaWidth = $("#cal_date_week_area").width();
		diffWidth = calNavlineWidth / 2 + 92;
		$("#cal_date_week_area").css("right", diffWidth+"px");
	}
}

function getRightMenu(){
    var arr = new Array();
    var object2 = new Object();
    object2.type = "line";
    if($.ctx.resources.contains('F09_meetingArrange')){
      var object1 = new Object();
      object1.name = $.i18n('calendar.arrangeTime.newmeeting');
      object1.handle = function(){newMeeting(scheduler.config.currentDateTime);};
      arr.push(object1);
      arr.push(object2);
    }
    if($.ctx.resources.contains('F02_planListHome')){
      var object1 = new Object();
      object1.name = $.i18n('calendar.arrangeTime.newplan');
      object1.handle = function(){newPlan(scheduler.config.currentDateTime);};
      arr.push(object1);
      arr.push(object2);
    }
    if($.ctx.resources.contains('F02_taskPage')){
      var object1 = new Object();
      object1.name = $.i18n('calendar.arrangeTime.newtask');
      object1.handle = function(){newTask(scheduler.config.currentDateTime);};
      arr.push(object1);
      arr.push(object2);
    }
    if($.ctx.resources.contains('F02_eventlist')){
      var object1 = new Object();
      object1.name = $.i18n('calendar.event.view.add');
      object1.handle = function(){AddCalEvent(scheduler.config.currentDateTime);};
      arr.push(object1);
    }
    return arr;
  }

function dateChange(type, nextDate) {
  curNextDate = nextDate;
      if($("#param_app").val()=='6'){
        dateChangeOfMeeting(type, nextDate);
      }
      else{
	if($("#tagetid").val()!=""&&$("#tagetid").val()!=undefined){
		scheduler.url = "calEventViewforLeader";
	}
          var url = _ctxPath + "/calendar/calEvent.do?method="+scheduler.url+"&tagetid="+$("#tagetid").val()+"&type="+ type;
          try {
            var temp=nextDate.split('-');
            nextDate = new Date(temp[0], (temp[1]-1), temp[2]);
          } catch (e) {}
          var selectedDate = nextDate.format("yyyy-MM-dd");
          url = url + "&selectedDate=" + selectedDate;
          if (type == "day") {
            curDay = nextDate.format("yyyy-MM-dd");
            url = url + "&curDay=" + curDay;
          } else if (type == "week") {
            var weekStart = getFirstDateOfWeek(nextDate).format("yyyy-MM-dd");
            var weekEnd = getLastDateOfWeek(nextDate).format("yyyy-MM-dd");
            url = url + "&weekStart=" + weekStart;
            url = url + "&weekEnd=" + weekEnd;
          } else if (type == "month") {
            var year = nextDate.format("yyyy");
            var month = nextDate.format("MM");
            var start = "01";
            var end = getLastDateOfMonth(nextDate.format("yyyy"), nextDate.format("MM"));
            var monthStart = year + "-" + month + "-" + start;
            var monthEnd = year + "-" + month + "-" + end;
            url = url + "&monthStart=" + monthStart;
            url = url + "&monthEnd=" + monthEnd;
            var source = $("#source").val();
            if(source == "timearrange"){
              url = url + "&source=timearrange";
            }else if(source == "arrangeMonthTimeForView"){
              url = url +"&source=arrangeMonthTimeForView";
            }
          }
          if(typeof (relateMemberID) != 'undefined'){
            url = url + "&relateMemberID="+relateMemberID;
          }
          setTimeout(function(){  
            window.location.href = url;
          },0);  
      }
}

