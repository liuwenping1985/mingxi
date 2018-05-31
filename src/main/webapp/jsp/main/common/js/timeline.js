/**
 * @author macj
 */
function CtpTimeLine(options){
	if(options == undefined)options = {}
	this.id = options.id != undefined ? options.id : Math.floor(Math.random() * 100000000);
	this.timeStep = options.timeStep == undefined ? ['8:00','18:00'] : options.timeStep;
	this.timeLineHeight = options.timeLineHeight == undefined ? 457 : options.timeLineHeight;
	this.scaleArray = new Object();
	
	this.date = options.date;
	if(this.date == undefined){
		this.date = [];
		var _ymd = new Date();
		this.date[0] = _ymd.getFullYear();
		this.date[1] = _ymd.getMonth()+1;
		this.date[2] = _ymd.getDate();
	}
	
	
	this.MonthSub = ['','JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
	this.MonHead = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	
	
	this.action = options.action;
	this.searchClick = options.searchClick == undefined?function(){}:options.searchClick;
	this.editClick = options.editClick == undefined?function(){}:options.editClick;
	this.maxClick = options.maxClick == undefined?function(){}:options.maxClick;
	this.initTimeLine();
}
CtpTimeLine.prototype.initTimeLine = function(){
	if($('#timeline_close').size()>0)return;
	//关闭按钮 + 事件轴弹出框(iframe)
	$('body').prepend("<div class='timeline_close' id='timeline_close' style='top:"+35*_zoomParam+"px'></div><div id='timeline_box' class='timeline_box' style='top:"+50*_zoomParam+"px'></div><iframe src='' id='timeline_iframe' frameborder='0' class='timeline_iframe' style='top:"+50*_zoomParam+"px'></iframe>");
	//时间轴实例图标
	$('#timeline_box').append("<div class='mold_list'><ul><li><em class='mold_icon mold_plan'></em><span class='mold_text'>" + $.i18n("application_5_label") + "</span></li><li><em class='mold_icon mold_meeting'></em><span class='mold_text'>" + $.i18n("application_6_label") + "</span></li><li id='taskmodel'><em class='mold_icon mold_task'></em><span class='mold_text'>" + $.i18n("calendar.arrangeTime.task") + "</span></li><li><em class='mold_icon mold_event'></em><span class='mold_text'>" + $.i18n("calendar.arrangeTime.event") + "</span></li><li><em class='mold_icon mold_collaboration'></em><span class='mold_text'>" + $.i18n("calendar.arrangeTime.collaboration.timed") + "</span></li><li><em class='mold_icon mold_edoc'></em><span class='mold_text'>" + $.i18n("calendar.arrangeTime.doc.timed") + "</span></li></ul></div>");
	//OA-74831 
	//if(productVersion == 'A6' || productVersion == 'A6s'){
	//	$('#taskmodel').hide();
	//}
	//时间轴右侧编辑+时间视图
	$('#timeline_box').append("<div class='action_box'><span id='action_calender' class='action_calender'></span><span id='action_set' class='action_set'></span></div>");
	//时间轴住区域
	$('#timeline_box').append("<div class='timeline_main_box'><div id='current_day' class='current_day'></div><div id='timeline_main' class='timeline_main'><div class='timeline_main_bg'></div></div></div>");
	
	
	this.timeline_box = $('#timeline_box');
	this.time_line_main = $('#timeline_main');
	//时间轴高度
	var _ch = $('body').height() - $('.layout_header').height();
	if(_ch<657){
		this.timeline_box.height(_ch-10);
		$('#timeline_iframe').height(_ch-10);
	}else if(_ch>657){
		this.timeline_box.height(657);
		$('#timeline_iframe').height(657);
	}
	/*this.timeline_box.scroll(function() {
	  $(".mold_list").css('top',$(this).scrollTop()+20);
	  $(".action_box").css('top',$(this).scrollTop()+20);
	});*/
	
	//关闭事件
	$('#timeline_close').click(function(){
		$(".timeline_box").hide();
		$(".timeline_iframe").hide();
		$( "#dragSkin" ).show();
		$(this).hide();
	});
	//点击进入时间视图
	$('#action_calender').click(this.maxClick);
	//点击编辑
	$('#action_set').click(this.editClick);
	
	if (isShowEdoc == true || isShowEdoc == "true") {
		$(".mold_plan").parents("li").hide();
		$(".mold_task").parents("li").hide();
		$(".mold_event").parents("li").hide();
		$(".mold_edoc").parents("li").hide();
	}
	
	this.resetInit();
}
CtpTimeLine.prototype.resetInit = function(){
	this.year = this.date[0];
	this.month = this.date[1];
	if(this.month.length == 2 && this.month.indexOf("0") == 0){
	  this.month = this.month.substr(1);
	}
	this.day = this.date[2];
	
	//时间设置<div class='time_line_set'></div>
	this.time_line_date_set = $("<div id='"+this.id+"_time_line_date_set' class='hidden time_line_set'></div>");
	
	this.time_line_date_set_mouth = $("<select class='left' id='"+this.id+"_time_line_date_set_mouth'></select>");
	this.time_line_date_set_day = $("<select class='left' id='"+this.id+"_time_line_date_set_day'></select>");
	//$.i18n('common.button.ok.label')
	this.time_line_date_set_ok = $("<a class='tooltip_close font_size12 right margin_r_10 margin_t_5 hand color_blue'>" + $.i18n("calendar_ok") + "</a>");
	//$.i18n('common.button.cancel.label')
	this.time_line_date_set_cancel = $("<a class='tooltip_close font_size12 right margin_t_5 hand color_blue'>" + $.i18n("common.button.cancel.label") + "</a>");
	
	this.time_line_date_set.append(this.time_line_date_set_mouth);
	//$.i18n('calendar_month')
	this.time_line_date_set.append("<span class='left font_size12' style='margin-top:2px;margin-right:10px;'>"+$.i18n("calendar_month")+"</span>");
	this.time_line_date_set.append(this.time_line_date_set_day);
	//$.i18n('calendar_day')
	this.time_line_date_set.append("<span class='left font_size12 ' style='margin-top:2px;margin-right:2px;'>"+$.i18n("calendar_day")+"</span>");
	this.time_line_date_set.append(this.time_line_date_set_cancel);
	this.time_line_date_set.append(this.time_line_date_set_ok);
	this.timeline_box.append(this.time_line_date_set);
	
	//时间设置事件
	var self = this;
	for (var g=1; g<13; g++) {
		this.time_line_date_set_mouth.append($("<option "+(g==this.date[1]?"selected":'')+">"+g+"</option>"));
	};
	this.changeDate(parseInt(this.year,10),parseInt(this.month,10));
	this.time_line_date_set_mouth.change(function(){
		self.changeDate(parseInt(self.date[0],10),parseInt($(this).val(),10));
	})
	this.time_line_date_set_ok.click(this.searchClick);
	this.time_line_date_set_cancel.click(function(){
		self.time_line_date_set.hide();
	});
	
	
	//当前日期
	$('#current_day').html("<span class='current_day_num'>"+this.date[2]+"</span><span class='current_mon_num'>"+this.MonthSub[this.month]+"</span>");
	this.time_line_date_set_mouth.val(this.month);
	this.changeDate(parseInt(this.year,10),parseInt(this.month,10));
	
	
	//初始化时间刻度
	this.timeStepInt = parseInt(this.timeStep[1],10)-parseInt(this.timeStep[0],10);
	this.subTime = 45;
	if(parseInt(this.timeStep[1],10)-parseInt(this.timeStep[0],10)<10){
		this.subTime = this.timeLineHeight/this.timeStepInt;
	}
	for (var i=0; i<(this.timeStepInt+1); i++) {
		//整点刻度
		var time_hour_scale = $("<div id='"+(parseInt(this.timeStep[0],10)+i)+"_icon' class='time_none'></div>");
			time_hour_scale.css({
			top:i*this.subTime
		});
		this.time_line_main.append(time_hour_scale);
		//整点时间
		var time_hour = $("<div class='time_hour absolute clearfix'><div class='time_hour_number_00'>:00</div><div class='time_hour_number'>"+(parseInt(this.timeStep[0],10)+i)+"</div></div>");
			time_hour.css({
				top:(i*this.subTime+15)
			});
		this.time_line_main.append(time_hour);
		this.scaleArray[parseInt(this.timeStep[0],10)+i] = i*this.subTime;
	}
	
	
	$('#current_day').unbind().toggle(function(){
		self.time_line_date_set.show();
	},function(){
		self.time_line_date_set.hide();
	});
}
CtpTimeLine.prototype.initData = function(){
	if(this.items && this.items.length>0){
		for (var i=0; i<this.items.length; i++) {
			var _item = this.items[i];
			var _type = _item.type;
			var _dateTime = parseInt(_item.dateTime,10);
			var _childItems = _item.childItems;
			
			if(_dateTime<parseInt(this.timeStep[0],10) || _dateTime>parseInt(this.timeStep[1],10)){
				continue;
			}
			
			var _contentIcon = $("<span class='time_one'></span>");
			_contentIcon.css({
				top:this.scaleArray[_dateTime]
			});
			if(_type == 'mix'){
				_contentIcon = $("<span class='time_more'></span>");
				_contentIcon.css({
					top:this.scaleArray[_dateTime]-2
				});
			}
			
			this.time_line_main.append(_contentIcon);
			//$('#'+_dateTime+'_icon').remove();
			
			
			
			var _contentDiv = "<div  class='time_content_container'>";
			for(var j = 0;j<_childItems.length;j++){
				var temp= _childItems[j];
				if(temp.account == null || !temp.account){
				  temp.account = "";
				}
				var arrowStr = "<div class='left_l_arrow'>◆</div><div class='left_r_arrow'>◆</div>";
				if(i%2 != 0) arrowStr = "<div class='right_r_arrow'>◆</div><div class='right_l_arrow'>◆</div>";
				_contentDiv+="<div onclick="+this.action+"('"+temp.id+"','"+(temp.type == undefined?_type:temp.type)+"') class='time_dialog_container margin_5 clearfix "+(j==0?'arrowStr':'hidden time_dialog_container_hidden')+"'>"+(j==0?arrowStr:'')+"<ul><li class='type_li'><span class='type_icon type_"+temp.type+"'></span></li>";
				_contentDiv+="<li class='type_content_li'><div class='type_content_li_div'>"+temp.subject+"</div>";
				_contentDiv+="<div class='clearfix'><span class='left time_account'>"+temp.account+"</span><span class='right time_time_date'>"+temp.dateTime+"</span></div>";
				_contentDiv+="</li></ul></div>";
			}
			if(_childItems.length>1){
				_contentDiv+="<div class='time_content_more'><span id='number_span'>还有"+(_childItems.length-1)+"条</span><span id='number_show' class=' hidden'>" + $.i18n("calendar.arrangeTime.collapse") + "</span></div>"
			}
			_contentDiv+="</div>"
			var _contDiv = $(_contentDiv);
			_contentIcon.append(_contDiv);
			if(i%2 == 0){
				_contDiv.css({
					left:36
				});
			}else{
				_contDiv.css({
					right:34
				});
			}
			
			$('.time_content_more').toggle(function(){
				$(this).parent().find('.time_dialog_container_hidden').show();
				$(this).find('#number_show').show();
				$(this).find('#number_span').hide();
				$(this).parents(".time_more").css('z-index', 100 + $(".time_dialog_container_hidden:visible").size() * 1);
			},function(){
				$(this).parents(".time_more").css('z-index','');
				$(this).parent().find('.time_dialog_container_hidden').hide();
				$(this).find('#number_show').hide();
				$(this).find('#number_span').show();
			});
			
			$('.time_more').unbind().click(function(){
				$(this).find('.time_content_more').click();
			});
		}
	}
}
CtpTimeLine.prototype.timeShow = function(){
	var self = this;
	$(".timeline_box").slideDown(function(){
		if ($.browser.msie) {
            if ($.browser.version == '6.0') {
				self.timeline_box.css('overflow-y','auto');
			}
		}
	});
	$(".timeline_iframe").slideDown(function(){
		$('#timeline_close').show();
	});
}
CtpTimeLine.prototype.clearLine = function(){
	$('.time_one').remove();
	$('.time_none').remove();
	$('.time_more').remove();
	$('.time_hour').remove();
	$('#current_day').empty();
	$('#'+this.id+'_time_line_date_set').remove();
}
CtpTimeLine.prototype.reset = function(options){
	this.timeStep = options.timeStep == undefined ? this.timeStep:options.timeStep;
	this.date = options.date == undefined ? this.date:options.date;
	this.autoHeight = options.autoHeight == undefined ? this.autoHeight:options.autoHeight;
	this.editClick = options.editClick == undefined ? this.editClick:options.editClick;
	this.maxClick = options.maxClick == undefined ? this.maxClick:options.maxClick;
	this.items = options.items == undefined ? this.items:options.items;
	this.scaleArray = new Object();
	this.clearLine();
	this.resetInit();
	this.initData();
}
CtpTimeLine.prototype.getSetDate = function(){
	var _year = this.date[0];
	var _mounth = $('#'+this.id+'_time_line_date_set_mouth').val();
	var _day = $('#'+this.id+'_time_line_date_set_day').val();
	
	var _ftime = this.timeStep[0];
	var _ttime = this.timeStep[1];
	return {'year':_year,'mounth':_mounth,'day':_day,'fromTime':_ftime,'toTime':_ttime};
}
CtpTimeLine.prototype.getDataObj = function(id){
	var _items = this.items;
	var _obj = null;
	if(_items && _items.length>0){
		for (var i=0; i<_items.length; i++) {
			var _item = _items[i];
			var _chield = _item.childItems;
			if(_chield && _chield.length>0){
				for (var j=0; j<_chield.length; j++) {
					var _ch = _chield[j];
					var _chId = _ch.id;
					if(_chId && _chId==id){
						_obj = _ch;
						break;
					}
				}
			}
		}
	}
	return _obj;
}
CtpTimeLine.prototype.setTimeLineDate = function(dateObj){
	this.year = parseInt(dateObj.year,10);
	this.mounth = parseInt(dateObj.mounth,10);
	this.day = parseInt(dateObj.day,10);
	if(this.mounth == undefined){
		this.mounth = dateObj.date.getMonth()+1;
	}
	if(this.day == undefined){
		this.day = dateObj.date.getDate();
	}
	$('#'+this.id+'_date').empty().html(this.mounth+"-"+this.day);
	
	$('#'+this.id+'_time_line_date_set_mouth').empty();
	for (var g=1; g<13; g++) {
		$('#'+this.id+'_time_line_date_set_mouth').append($("<option "+(g==this.mounth?"selected":'')+">"+g+"</option>"));
	};
	this.changeDate(parseInt(this.year,10),parseInt(this.mounth,10));
}
CtpTimeLine.prototype.changeDate = function(year,mounth){
    var n = this.MonHead[mounth - 1];
    if (mounth == 2 && this.IsPinYear(year)) {
        n++;
	}
    this.writeDay(n)
}
CtpTimeLine.prototype.writeDay = function(n){
	var str = "";
	for (var i = 1; i < (n + 1); i++){
	   str += "<option "+(i==parseInt(this.day,10)?'selected':'')+" value='" + i + "'> " + i + "</option>";
	} 
	$('#'+this.id+'_time_line_date_set_day').replaceWith("<select class='left "+this.id+"_time_line_date_set_day' id='"+this.id+"_time_line_date_set_day'>"+str+"</select>");
}
CtpTimeLine.prototype.IsPinYear = function(year){
	return (0 == year % 4 && (year % 100 != 0 || year % 400 == 0))
}
