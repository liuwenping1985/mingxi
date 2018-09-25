document.documentElement.onkeydown = function(evt) {
      if (window.event.keyCode == 8)//屏蔽退格键
      {
        var type = window.event.srcElement.type;//获取触发事件的对象类型
        var reflag = window.event.srcElement.readOnly;//获取触发事件的对象是否只读
        var disflag = window.event.srcElement.disabled;//获取触发事件的对象是否可用
        if (type == "text" || type == "textarea")//触发该事件的对象是文本框或者文本域
        {
          if (reflag || disflag)//只读或者不可用
          {
            window.event.returnValue = false;//阻止浏览器默认动作的执行
          }
        } else {
          window.event.returnValue = false;//阻止浏览器默认动作的执行
        }
      }
    }
	function choice(conditionObject) {
		var options = conditionObject.options;
		for ( var i = 0; i < options.length; i++) {
			var d = document.getElementById("periodical" + options[i].value);
			if (d) {
				d.style.display = "none";
			}
		}
		if (!document.getElementById("periodical" + conditionObject.value)) {
			disableCheck();
			return;
		} else {
			document.getElementById("periodical" + conditionObject.value).style.display = "block";
			$(".calendar_icon").css("display", "inline-block"); //修改：默认隐藏日期按钮
			// $("#beginTime").removeAttr("readonly");
		    // $("#endTime").removeAttr("readonly");
		}
	}

	function disableCheck() {
		$(".calendar_icon").css("display", "none"); //修改：默认隐藏日期按钮
		// $("#beginTime").attr("readonly", "readonly");
		//$("#endTime").attr("readonly", "readonly");
	}

	function OK(isupdate) {
		var vali = $("#createCalEventState").validate();
		if (vali) {
			var o = new Object();
			var a = $(".workType");
			for ( var i = 0; i < a.length; i++) {
				if (a[i].checked) {
					o.workType = a[i].value;
				}
			}
			o.realEstimateTime = $("#realEstimateTime").val();
			o.periodicalType = $("#periodical").val();
			if ($("#periodical").val() != 0) {
				if (o.periodicalType == 1) {
					o.dayDate = $("#day").val();
				} else if (o.periodicalType == 2) {
					a = $(".dayWeek");
					o.weeks = "";
					for ( var i = 0; i < a.length; i++) {
						if (a[i].checked) {
							o.weeks = o.weeks + a[i].value + ",";
						}
					}
					o.weeks = o.weeks.substring(0, o.weeks.length - 1);

				} else if (o.periodicalType == 3) {
					a = $(".month");
					for ( var i = 0; i < a.length; i++) {
						if (a[i].checked) {
							var month = a[i].value;
							o.swithMonth = month;
							if (month == 1) {
								o.dayDate = $("#curDayDate").val();
							} else if (month == 2) {
								o.week = $("#cInfoPerInfoWeek").val();
								o.dayWeek = $("#cInfoPerInfoDayWeek").val();
							}
						}
					}

				} else if (o.periodicalType == 4) {
					a = $(".year");
					for ( var i = 0; i < a.length; i++) {
						if (a[i].checked) {
							var year = a[i].value;
							o.swithYear = year;
							o.month = $("#cInfoPerInfoMonth").val();
							if (year == 1) {
								o.dayDate = $("#curDayDate").val();
							} else if (year == 2) {
								o.week = $("#cInfoPerInfoWeek").val();
								o.dayWeek = $("#cInfoPerInfoDayWeek").val();
							}
						}
					}
				}
			}
			o.beginTime = $("#beginTime").val();
			o.endTime = $("#endTime").val();
			if ($("#periodical").val() == 0 && $("#isNew").val() == '2') {
				$.alert($.i18n('calendar.event.create.tip6'));
				return false;
			}
			if ($("#periodical").val() != 0 && $("#isNew").val() != '1') { //如果用户没有选择周期性时间，则不做周期性时间相关判断
				if (o.periodicalType == 2 && (o.weeks == null || o.weeks == "")) {
					$.alert($.i18n('calendar.event.create.tip8'));
					return false;
				}
				if (o.beginTime < $("#beginDateFirst").val()) {
					$.alert($.i18n('calendar.event.state.beginDate.compare'));
					return false;
				}
				if (o.endTime != 1 && o.beginTime > o.endTime) {
					$.alert($.i18n('calendar.event.create.state.beginTimeEnd'));
					return false;
				} else {
					if ($("#endDate").val() != $("#beginDate").val()
							&& ($("#periodical").val() == 1 || $("#periodical")
									.val() == 2)) {
						$.alert($.i18n('calendar.event.priorityType.kuaRi'));
						return false;
					}
					var ajaxTestBean = new calEventManager();
					var info = ajaxTestBean.toSureIsRightDate(o);
					if (info != null && info != "") {
						$.alert(info);
						return false;
					} else {
						return o;
					}
				}

			} else {
				return o;
			}
		} else {
			return false;
		}
	}
	function loadData(week, optionSel) {
		for ( var i = 0; i < week.length; i++) {
			$("#Checkbox" + week[i]).attr("checked", true);
		}
		if (optionSel == 0
				|| $("#cInfoPerInfoType").val() == '0'
				|| $("#isNew").val() == '1') {
			disableCheck();
		}
	}	