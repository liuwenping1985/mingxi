 (function($){

  jQuery.fn.isChildOf = function(b) {
    return (this.parents(b).length > 0);
  };
  //判断:当前元素是否是被筛选元素的子元素或者本身
  jQuery.fn.isChildAndSelfOf = function(b) {
    return (this.closest(b).length > 0);
  };


  
  $.TimeBox = function() {
    this.initialize.apply(this, arguments);
  };
  $.TimeBox.prototype = {
    initialize: function(options, onchange) {
      this.onchange = onchange || null;
      this.setOptions(options || {});
      this.binding();
    },
    setOptions: function(options) {
      var that = this;
      this.timeE = options.timeElement||null;
      this.boxE = options.boxElement||null;
      this.timeElement = document.getElementById(this.timeE)|| null;
      this.boxElement = document.getElementById(this.boxE)|| null;
      this.url        = options.url || '';
      this.currentClass = options.currentClass || null;
      this.eventType = options.eventType || 'onclick';
      this.defaultIndex = options.defaultIndex || 0;
      this.excludeAttr = options.excludeAttr || 'activeEvent'; // 事件触发时排除属性元素
      this.targetCache = null;
      this.currentIndex = null; // 当前的索引值

      this.timestamp = new Date().getTime();
      this.timesp = null;
      // 上一次更新的时间戳
      this.prevts = 0;//that.timestamp
      // 计算分钟间隔步长，默认是10分钟
      this.step = 600000;

      //只允许显示固定时间段
      this.duration = options.duration;
      if(this.duration){
        this.initDuration();
      };

      // 日期控件
      this.dayBox = new $.SelectBox({
          'tabElement': $(that.boxElement).children(".dayGroup").get(0),
          'currentClass': 'selected',
          'defaultIndex': that.defaultIndex 
        },
        function(obj, provObj, index) {
          var tag = obj.getAttribute('value');
          var startDay = obj.getAttribute("startday")?true:false;
          that.createHour(tag,startDay);
          // 如果时间控件组有内容，则默认选中第一项，否则清空分钟控件组的内容
          if (that.hourBox && that.hourBox.tabElement.innerHTML != ''&&!startDay) {
            that.hourBox.setSelected(0);
          }else if(startDay){

          }else if(that.minuteBox){
            that.minuteBox.tabElement.innerHTML = '';
          }
          $(that.boxElement).find(".realTime").removeClass('selected');
        }
      );
      // 小时控件
      this.hourBox = new $.SelectBox({
        'tabElement': $(that.boxElement).children(".hourGroup").get(0),
        'currentClass': 'selected',
        'defaultIndex': that.defaultIndex
      },
      function(obj, provObj, index) {
        var dayTarget = that.dayBox.tabElement.children[that.dayBox.currentIndex];
        var isToday = dayTarget.getAttribute('value');
        var tag = (index == 0 && isToday == '今天') ? true : false;
        var starthour = obj.getAttribute('starthour') ? true : false;
        that.createMinute(tag,starthour);
        if (that.minuteBox) {
          that.minuteBox.setSelected(0);
        }
      }
      );
      // 分钟控件
      this.minuteBox = new $.SelectBox({
        'tabElement': $(that.boxElement).children(".minuteGroup").get(0),
        'currentClass': 'selected',
        'defaultIndex': that.defaultIndex
      },
      function(obj, provObj, index) {
      }
      );
      // 初始化时间控件
      this.loadServerTime();
      if (this.onchange) {
          this.onchange(true);
      };
    },
    /*
      自定义时间段
    */
     initDuration:function(){
        this.startDuration = this.createTime(this.duration);
        this.endDuration = this.createTime(this.duration+7200);
     },    /*
      小时控件 传入时间限制 时定位 显示位置    
      */
      hourPosition:function(){
        // class="starthour";
        var positionEle =  $(this.boxElement).find(".hourGroup").find("a[starthour = 'true']");
        var heightH = positionEle.height();
        var positions = positionEle.position().top-heightH;
        $(this.boxElement).find('.hourGroup').scrollTop(positions);
        //positionEle.attr("starthour","");
      },
     /*
     生成年月日时分
      */
     createTime:function(timestamp){
        var now = new Date(timestamp*1000);
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        month = month < 10 ? '0' + month : month;
        var date = now.getDate();
        date = date < 10 ? '0' + date : date;
        var week = now.getDay();
        var hour = now.getHours();
        var minute = now.getMinutes();
        return {"year":year,"month":month,"date":date,"week":week,"hour":hour,"minute":minute}
     },
    /**
     * 创建天选择组
     */
    createDays: function() {
      var day = 86400 * 1000;
      var dayData = [], i = 0, tags = ['今天', '明天', '后天'],weeks=["星期日","星期一","星期二","星期三","星期四","星期五","星期六"];
      while (i < tags.length) {
        var now = new Date(this.timestamp + day * i);
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        month = month < 10 ? '0' + month : month;
        var date = now.getDate();
        date = date < 10 ? '0' + date : date;
        var week = now.getDay();
        week = weeks[week];

        var data = year + '/' + month + '/' + date;
        var datashow = year + '年' + month + '月' + date+'日';
          //dayData.push('<a href="javascript:void(0)" type="day" value="' + tags[i]  + '" datashow="' + datashow + '" data="' + data + '">'+'<span class="airday-text">' + tags[i] + '</span><span class="airday-day">- ' + datashow + ' -</span><span class="airday-week">'+week+'</span><span class="cor"></span>'+'</a>');
        if(this.startDuration&&(date<this.startDuration.date)||this.endDuration&&(date>this.endDuration.date)){
          dayData.push('<a href="javascript:void(0)" class="activeevent" activeEvent="true" type="day" value="' + tags[i]  + '" datashow="' + datashow + '" data="' + data + '">' + tags[i] + month + '-' + date + '</a>');
        }else if(this.startDuration&&(date == this.startDuration.date)){
          dayData.push('<a href="javascript:void(0)" class="selected" startday="true" type="day" value="' + tags[i]  + '" datashow="' + datashow + '" data="' + data + '">' + tags[i] + month + '-' + date + '</a>');
        }else{
          dayData.push('<a href="javascript:void(0)" type="day" value="' + tags[i]  + '" datashow="' + datashow + '" data="' + data + '">' + tags[i] + month + '-' + date + '</a>');
        }
        i++;
      }
      $(this.boxElement).find('.dayGroup').html(dayData.join(''));
    },
    /**
     * 创建小时选择组
     * @param  {String} tag  值为今天、明天或后天
     */
    createHour: function(tag,startDay) {
      var hourData = [], i = 0, todayHour = [];
      while (i < 24) {
        var value = i < 10 ? '0' + i : i;       
        var now = new Date(this.timestamp);
        var hour = now.getHours();
        var minute = now.getMinutes();
        if(this.startDuration && this.startDuration.hour<this.endDuration.hour){
          if(this.startDuration && (i<this.startDuration.hour)||this.endDuration && (i>this.endDuration.hour)){
              var item = '<a href="javascript:void(0)"  class="activeevent" activeEvent="true" type="hour" data="' + value + '">' + value + '时</a>';
          }else if(this.endDuration && (i==this.startDuration.hour)){
              var item = '<a href="javascript:void(0)" starthour="true"  type="hour" data="' + value + '">' + value + '时</a>';
          }else{
            var item = '<a href="javascript:void(0)" type="hour" data="' + value + '">' + value + '时</a>';
          }
        }else if(this.startDuration && this.startDuration.hour>this.endDuration.hour){
          if(startDay){
            if(this.startDuration && (i<this.startDuration.hour)){
                var item = '<a href="javascript:void(0)"  class="activeevent" activeEvent="true" type="hour" data="' + value + '">' + value + '时</a>';
            }else if(this.endDuration && (i==this.startDuration.hour)){
                var item = '<a href="javascript:void(0)" starthour="true"  type="hour" data="' + value + '">' + value + '时</a>';
            }else{
              var item = '<a href="javascript:void(0)" type="hour" data="' + value + '">' + value + '时</a>';
            }
          }else{
            if(this.endDuration && (i>this.endDuration.hour)){
              var item = '<a href="javascript:void(0)"  class="activeevent" activeEvent="true" type="hour" data="' + value + '">' + value + '时</a>';
            }else{
            var item = '<a href="javascript:void(0)" type="hour" data="' + value + '">' + value + '时</a>';
            }
          }
        }else{
            var item = '<a href="javascript:void(0)" type="hour" data="' + value + '">' + value + '时</a>';
        }
        hourData.push(item);
        if (hour < i || (hour == i && minute <= 20)) {
          todayHour.push(item);
        }

        i++;
      }

      if (tag == '今天') {
        $(this.boxElement).find('.hourGroup').html(todayHour.join(''));
      } else {
        $(this.boxElement).find('.hourGroup').html(hourData.join(''));
      }
      if(startDay){
        $(this.boxElement).find('.hourGroup').scrollTop(0);
        this.hourPosition();
      }else if(this.endDuration){
        $(this.boxElement).find('.hourGroup').scrollTop(0);
      }
    },
    /**
     * 创建分钟选择组
     * @param  {Boolean} param  是否是今天当天
     */
    createMinute: function(param,starthour) {
      var minuteData = [], i = 0, todayMinute = [];
      while (i < 6) {
        var tag = 10 * i, value = tag < 10 ? '0' + tag : tag;
        if(this.startDuration && (tag < this.startDuration.minute) && starthour){
            var item = '<a href="javascript:void(0)" class="activeevent" activeEvent="true" type="minute" data="' + value + '">' + value + '分</a>';
        }else{
            var item = '<a href="javascript:void(0)" type="minute" data="' + value + '">' + value + '分</a>';
        }
        minuteData.push(item);

        var now = new Date(this.timestamp);
        var minute = now.getMinutes();

        var newn = (minute + 30 >= 60) ? (minute + 30 - 60) : (minute + 30);

        if (newn <= 50 && newn <= tag) {
          todayMinute.push(item);
        }

        i++;
      }
      if (todayMinute.length <= 0) {
        todayMinute = minuteData;
      }

      if (param) {
        $(this.boxElement).find('.minuteGroup').html(todayMinute.join(''));
      } else {
        $(this.boxElement).find('.minuteGroup').html(minuteData.join(''));
      }

    },
    /**
     * 设置日期选择框的值
     * @param {Array} elements DOM数组，如果数组个数为一是实时用车，为三个是预约用车
     */
    setValue: function(elements) {
      if (elements.length < 1) {
        return;
      }
      var contents = [],datas = [];
      if(elements.length == 1){
        var value = $(elements[0]).html();
        contents.push(value);
      }else{
         for (var i = 0, len = elements.length; i < len; i++) {
           var value = $(elements[i]).html();
           var day = $(elements[i]).attr('value');
           var data = $(elements[i]).attr('data');
           var datashow = $(elements[i]).attr('datashow');
           datas.push(data);

           if (i == 0) {
             contents.push('<span class="userday">'+datashow+'<i class="normalFont">('+day+')</i></span>');
           }else if(i == 1){
             contents.push('<span class="usertime">' + data);
           }else{
             contents.push(":" + data + '</span>');
           }
         } 
      }
      contents.push('<span class="search-in arrow icon-drop"></span>');
      $(this.timeElement).html(contents.join(''));

      $('#day').val($(elements[0]).attr('value'));
      //window.api.set("day",$(elements[0]).attr('value'));
      if (elements.length == 1) {
        $('#time').val('999');
        //window.api.set("time",'999');
      } else if (elements.length == 3) {
        var date = $(elements[0]).attr('data') + ' ' + $(elements[1]).attr('data') + ':' + $(elements[2]).attr('data') + ':00';
        this.timesp = Math.floor((new Date(date).getTime()) / 1000);
        $('#time').val( this.timesp );
        departureTime=new Date(date);
        //window.api.set("time",this.timesp);
      }
    },
    /**
     * 加载服务器时间，并创建时间控件DOM结构
     */
    loadServerTime: function(){
      var that = this;
       that.timestamp = (new Date().getTime());
            var intPoint = (that.step - that.prevts % that.step) + that.prevts;
            var diffPoint =  that.timestamp - intPoint;
            //console.log('----------：', diffPoint, new Date(that.timestamp).getMinutes());
            // 如果当前的时间点，超时时间段步长节点，则需要更新时间
            if(that.prevts == 0 ||  diffPoint > 60000){
              that.createDays();
              ($(that.boxElement).find('.hourGroup'))&&($(that.boxElement).find('.hourGroup').html(''));
              ($(that.boxElement).find('.minuteGroup'))&&($(that.boxElement).find('.minuteGroup').html(''));
              ($(that.boxElement).find('.realTime'))&&($(that.boxElement).find('.realTime').addClass('selected'));
              that.prevts = that.timestamp;
            }
    },
    /**
     * 初始态，且绑定事件
     */
    binding: function() {
      var that = this;

      this.timeElement.onclick = function(e) {
        var timeElement = $(that.timeElement);
        var pos = timeElement.position();
        var height = timeElement.outerHeight();
        $(that.boxElement).css({
          top: pos.top + height - 1,
          left: pos.left
        });

        if( $(that.boxElement).is(":visible") ){
          $(that.boxElement).animate({height: 'hide'}, 200, function(){$(that.timeElement).parent(".info-input").removeClass("onfireyellow");});
          return false;
        }else{
          $(that.boxElement).animate({height: 'show'}, 200);
          $(this).parent(".info-input").addClass("onfireyellow");
        }

        that.loadServerTime();
        if(that.duration&&!$(that.boxElement).find(".hourGroup").find("a[starthour = 'true']").attr("isd")){
          window.setTimeout(function(){
             var dayTarget = $(that.boxElement).find('.dayGroup .selected');
             dayTarget.trigger("click");   
             var hourTarget = $(that.boxElement).find(".hourGroup").find("a[starthour = 'true']");
             hourTarget.trigger("click");
             $(that.boxElement).find(".hourGroup").find("a[starthour = 'true']").attr("isd","true");
          },300);
        }
      };

      // 点击文档空白处，隐藏
      $(document).on('click', function(e) {
        e = e || window.event;
        var target = e.target || e.srcElement;
        if (!$(target).isChildAndSelfOf("#" + that.timeE) && !$(target).isChildAndSelfOf("#"+ that.boxE)) {
          $(that.boxElement).animate({
            height: 'hide'
          }, 200, function(){$(that.timeElement).parent(".info-input").removeClass("onfireyellow");});
        }
      });


      // 绑定事件
      this.boxElement[this.eventType] = function(e) {
        e = e || window.event;
        var target = e.target || e.srcElement;

        if (that.boxElement == target) {
          return false;
        }

        // 过滤需要排除的元素，
        if (target.getAttribute(that.excludeAttr)) {
          return false;
        }

        if (target.nodeName != 'A') {
          return false;
        }

        var type = target.getAttribute('type');
        // 如果用户点击“现在用车”
        if(type == 'now') {
          var tag = target.getAttribute('value');
          $(that.boxElement).find(".realTime").addClass('selected')
          $(that.boxElement).animate({
            height: 'hide'
          }, 200, function(){$(that.timeElement).parent(".info-input").removeClass("onfireyellow");});
          that.setValue([target]);

          // 取消天、小时、分钟组的选择项
          if(that.dayBox && that.hourBox && that.minuteBox){
            that.dayBox.setSelected(-1);
            that.hourBox.setSelected(-1);
            that.minuteBox.setSelected(-1);

            that.hourBox.tabElement.innerHTML = '';
            that.minuteBox.tabElement.innerHTML = '';
          }

          if (that.onchange) {
            that.onchange(true, 999);
          }

        }
        // 如果用户点击“分钟”后自动收起 下拉框，如果出现异常情况未有处理方案
        else if (type == 'minute') {
          $(that.boxElement).animate({
            height: 'hide'
          }, 200, function(){$(that.timeElement).parent(".info-input").removeClass("onfireyellow");});
          var dayTarget = that.dayBox.tabElement.children[that.dayBox.currentIndex];
          var hourTarget = that.hourBox.tabElement.children[that.hourBox.currentIndex];
          var minuteTarget = that.minuteBox.tabElement.children[that.minuteBox.currentIndex];
          if (dayTarget && hourTarget && minuteTarget) {
            that.setValue([dayTarget, hourTarget, minuteTarget]);
            if (that.onchange) {
              that.onchange(false, this.timesp);
            }
          }
        }
        return false;
      };
    }
  };
})(jQuery);
