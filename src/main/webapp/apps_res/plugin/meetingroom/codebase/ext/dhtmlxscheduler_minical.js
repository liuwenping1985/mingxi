scheduler.templates.calendar_month = scheduler.date.date_to_str("%F %Y");
scheduler.templates.calendar_scale_date = scheduler.date.date_to_str("%D");
scheduler.templates.calendar_date = scheduler.date.date_to_str("%d");
scheduler.renderCalendar = function (b, c) {
	var a = null, d = b.date || new Date;
	typeof d == "string" && (d = this.templates.api_date(d));
	if (c) {
		a = this._render_calendar(c.parentNode, d, b, c), scheduler.unmarkCalendar(a);
	} else {
		var e = b.container, f = b.position;
		typeof e == "string" && (e = document.getElementById(e));
		typeof f == "string" && (f = document.getElementById(f));
		if (f && typeof f.left == "undefined") {
			var n = getOffset(f), f = {top:n.top + f.offsetHeight, left:n.left};
		}
		e || (e = scheduler._get_def_cont(f));
		a = this._render_calendar(e, d, b);
		a.onclick = function (a) {
			var a = a || event, b = a.target || a.srcElement;
			if (b.className.indexOf("dhx_month_head") != -1) {
				var c = b.parentNode.className;
				if (c.indexOf("dhx_after") == -1 && c.indexOf("dhx_before") == -1) {
					var d = scheduler.templates.xml_date(this.getAttribute("date"));
					d.setDate(parseInt(b.innerHTML, 10));
					scheduler.unmarkCalendar(this);
					scheduler.markCalendar(this, d, "dhx_calendar_click");
					this._last_date = d;
					this.conf.handler && this.conf.handler.call(scheduler, d, this);
				}
			}
		};
	}
	for (var m = scheduler.date.month_start(d), k = scheduler.date.add(m, 1, "month"), p = this.getEvents(m, k), i = 0; i < p.length; i++) {
		var o = p[i], l = o.start_date;
		l.valueOf() < m.valueOf() && (l = m);
		for (l = scheduler.date.date_part(new Date(l.valueOf())); l < o.end_date; ) {
			//TODO dhx_year_event class样式没有发现有什么作用，暂时去掉 修复OA-37568
			if (this.markCalendar(a, l, ""), l = this.date.add(l, 1, "day"), l.valueOf() >= k.valueOf()) {
				break;
			}
		}
	}
	this._markCalendarCurrentDate(a);
	a.conf = b;
	return a;
};
scheduler._get_def_cont = function (b) {
	if (!this._def_count) {
		this._def_count = document.createElement("DIV"), this._def_count.style.cssText = "position:absolute;z-index:10100;width:251px; height:175px;", this._def_count.onclick = function (b) {
			(b || event).cancelBubble = !0;
		}, document.body.appendChild(this._def_count);
	}
	this._def_count.style.left = b.left + "px";
	this._def_count.style.top = b.top + "px";
	this._def_count._created = new Date;
	return this._def_count;
};
scheduler._locateCalendar = function (b, c) {
	var a = b.childNodes[2].childNodes[0];
	typeof c == "string" && (c = scheduler.templates.api_date(c));
	var d = b.week_start + c.getDate() - 1;
	return a.rows[Math.floor(d / 7)].cells[d % 7].firstChild;
};
scheduler.markCalendar = function (b, c, a) {
	var _childObj = this._locateCalendar(b, c);
	if(_childObj && _childObj.className){
	   _childObj.className += " " + a;
	}
};
scheduler.unmarkCalendar = function (b, c, a) {
	c = c || b._last_date;
	a = a || "dhx_calendar_click";
	if (c) {
		var d = this._locateCalendar(b, c);
		if(d && d.className){
		    d.className = (d.className || "").replace(RegExp(a, "g"));
		}
	}
};
scheduler._week_template = function (b) {
	for (var c = b || 250, a = 0, d = document.createElement("div"), e = this.date.week_start(new Date), f = 0; f < 7; f++) {
		this._cols[f] = Math.floor(c / (7 - f)), this._render_x_header(f, a, e, d), e = this.date.add(e, 1, "day"), c -= this._cols[f], a += this._cols[f];
	}
	//lijl注销,由于选择日期时错误
	//d.lastChild.className += " dhx_scale_bar_last";
	return d;
};
scheduler.updateCalendar = function (b, c) {
	b.conf.date = c;
	this.renderCalendar(b.conf, b);
};
scheduler._mini_cal_arrows = ["&nbsp", "&nbsp"];
scheduler._render_calendar = function (b, c, a, d) {
	var e = scheduler.templates, f = this._cols;
	this._cols = [];
	var n = this._mode;
	this._mode = "calendar";
	var m = this._colsS;
	this._colsS = {height:0};
	var k = new Date(this._min_date), p = new Date(this._max_date), i = new Date(scheduler._date), o = e.month_day;
	e.month_day = e.calendar_date;
	var c = this.date.month_start(c), l = this._week_template(b.offsetWidth - 1), g;
	d ? g = d : (g = document.createElement("DIV"), g.className = "dhx_cal_container dhx_mini_calendar");
	g.setAttribute("date", this.templates.xml_format(c));
	g.innerHTML = "<div class='dhx_year_month'></div><div class='dhx_year_week'>" + l.innerHTML + "</div><div class='dhx_year_body'></div>";
	g.childNodes[0].innerHTML = this.templates.calendar_month(c);
	if (a.navigation) {
		var h = document.createElement("DIV");
		h.className = "dhx_cal_prev_button";
		h.style.cssText = "left:1px;top:2px;position:absolute;";
		h.innerHTML = this._mini_cal_arrows[0];
		g.firstChild.appendChild(h);
		h.onclick = function () {
			scheduler.updateCalendar(g, scheduler.date.add(g._date, -1, "month"));
			scheduler._date.getMonth() == g._date.getMonth() && scheduler._date.getFullYear() == g._date.getFullYear() && scheduler._markCalendarCurrentDate(g);
		};
		h = document.createElement("DIV");
		h.className = "dhx_cal_next_button";
		h.style.cssText = "left:auto; right:1px;top:2px;position:absolute;";
		h.innerHTML = this._mini_cal_arrows[1];
		g.firstChild.appendChild(h);
		h.onclick = function () {
			scheduler.updateCalendar(g, scheduler.date.add(g._date, 1, "month"));
			scheduler._date.getMonth() == g._date.getMonth() && scheduler._date.getFullYear() == g._date.getFullYear() && scheduler._markCalendarCurrentDate(g);
		};
	}
	g._date = new Date(c);
	g.week_start = (c.getDay() - (this.config.start_on_monday ? 1 : 0) + 7) % 7;
	var u = this.date.week_start(c);
	this._reset_month_scale(g.childNodes[2], c, u);
	for (var j = g.childNodes[2].firstChild.rows, q = j.length; q < 6; q++) {
		var t = j[j.length - 1];
		j[0].parentNode.appendChild(t.cloneNode(!0));
		for (var r = parseInt(t.childNodes[t.childNodes.length - 1].childNodes[0].innerHTML), r = r < 10 ? r : 0, s = 0; s < j[q].childNodes.length; s++) {
			j[q].childNodes[s].className = "dhx_after", j[q].childNodes[s].childNodes[0].innerHTML = scheduler.date.to_fixed(++r);
		}
	}
	d || b.appendChild(g);
	//lijl注销,由于选择日期时错误
	//g.childNodes[1].style.height = g.childNodes[1].childNodes[0].offsetHeight - 1 + "px";
	this._cols = f;
	this._mode = n;
	this._colsS = m;
	this._min_date = k;
	this._max_date = p;
	scheduler._date = i;
	e.month_day = o;
	return g;
};
scheduler.destroyCalendar = function (b, c) {
	if (!b && this._def_count && this._def_count.firstChild && (c || (new Date).valueOf() - this._def_count._created.valueOf() > 500)) {
		b = this._def_count.firstChild;
	}
	if (b && (b.onclick = null, b.innerHTML = "", b.parentNode && b.parentNode.removeChild(b), this._def_count)) {
		this._def_count.style.top = "-1000px";
	}
};
scheduler.isCalendarVisible = function () {
	return this._def_count && parseInt(this._def_count.style.top, 10) > 0 ? this._def_count : !1;
};
scheduler.attachEvent("onTemplatesReady", function () {
	dhtmlxEvent(document.body, "click", function () {
		scheduler.destroyCalendar();
	});
});
scheduler.templates.calendar_time = scheduler.date.date_to_str("%d-%m-%Y");
scheduler.form_blocks.calendar_time = {render:function () {
	var b = "<input class='dhx_readonly' type='text' readonly='true'>", c = scheduler.config, a = this.date.date_part(new Date);
	c.first_hour && a.setHours(c.first_hour);
	b += " <select>";
	for (var d = 60 * c.first_hour; d < 60 * c.last_hour; d += this.config.time_step * 1) {
		var e = this.templates.time_picker(a);
		b += "<option value='" + d + "'>" + e + "</option>";
		a = this.date.add(a, this.config.time_step, "minute");
	}
	b += "</select>";
	var f = scheduler.config.full_day;
	return "<div style='height:30px;padding-top:0; font-size:inherit;' class='dhx_section_time'>" + b + "<span style='font-weight:normal; font-size:10pt;'> &nbsp;&ndash;&nbsp; </span>" + b + "</div>";
}, set_value:function (b, c, a) {
	function d(a, b, c) {
		n(a, b, c);
		a.value = scheduler.templates.calendar_time(b);
		a._date = scheduler.date.date_part(new Date(b));
	}
	var e = b.getElementsByTagName("input"), f = b.getElementsByTagName("select"), n = function (a, b, c) {
		a.onclick = function () {
			scheduler.destroyCalendar(null, !0);
			scheduler.renderCalendar({position:a, date:new Date(this._date), navigation:!0, handler:function (b) {
				a.value = scheduler.templates.calendar_time(b);
				a._date = new Date(b);
				scheduler.destroyCalendar();
				scheduler.config.event_duration && scheduler.config.auto_end_date && c == 0 && o();
			}});
		};
	};
	if (scheduler.config.full_day) {
		if (!b._full_day) {
			var m = "<label class='dhx_fullday'><input type='checkbox' name='full_day' value='true'> " + scheduler.locale.labels.full_day + "&nbsp;</label></input>";
			scheduler.config.wide_form || (m = b.previousSibling.innerHTML + m);
			b.previousSibling.innerHTML = m;
			b._full_day = !0;
		}
		var k = b.previousSibling.getElementsByTagName("input")[0], p = scheduler.date.time_part(a.start_date) == 0 && scheduler.date.time_part(a.end_date) == 0 && a.end_date.valueOf() - a.start_date.valueOf() < 172800000;
		k.checked = p;
		for (var i in f) {
			f[i].disabled = k.checked;
		}
		for (i = 0; i < e.length; i++) {
			e[i].disabled = k.checked;
		}
		k.onclick = function () {
			if (k.checked == !0) {
				var b = new Date(a.start_date), c = new Date(a.end_date);
				scheduler.date.date_part(b);
				c = scheduler.date.add(b, 1, "day");
			}
			var h = b || a.start_date, i = c || a.end_date;
			d(e[0], h);
			d(e[1], i);
			f[0].value = h.getHours() * 60 + h.getMinutes();
			f[1].value = i.getHours() * 60 + i.getMinutes();
			for (var j in f) {
				f[j].disabled = k.checked;
			}
			for (j = 0; j < e.length; j++) {
				e[j].disabled = k.checked;
			}
		};
	}
	if (scheduler.config.event_duration && scheduler.config.auto_end_date) {
		var o = function () {
			a.start_date = scheduler.date.add(e[0]._date, f[0].value, "minute");
			a.end_date.setTime(a.start_date.getTime() + scheduler.config.event_duration * 60000);
			e[1].value = scheduler.templates.calendar_time(a.end_date);
			e[1]._date = scheduler.date.date_part(new Date(a.end_date));
			f[1].value = a.end_date.getHours() * 60 + a.end_date.getMinutes();
		};
		f[0].onchange = o;
	}
	d(e[0], a.start_date, 0);
	d(e[1], a.end_date, 1);
	n = function () {
	};
	f[0].value = a.start_date.getHours() * 60 + a.start_date.getMinutes();
	f[1].value = a.end_date.getHours() * 60 + a.end_date.getMinutes();
}, get_value:function (b, c) {
	var a = b.getElementsByTagName("input"), d = b.getElementsByTagName("select");
	c.start_date = scheduler.date.add(a[0]._date, d[0].value, "minute");
	c.end_date = scheduler.date.add(a[1]._date, d[1].value, "minute");
	if (c.end_date <= c.start_date) {
		c.end_date = scheduler.date.add(c.start_date, scheduler.config.time_step, "minute");
	}
}, focus:function () {
}};
scheduler.linkCalendar = function (b, c) {
	var a = function () {
		var a = scheduler._date, e = new Date(a.valueOf());
		c && (e = c(e));
		e.setDate(1);
		scheduler.updateCalendar(b, e);
		return !0;
	};
	scheduler.attachEvent("onViewChange", a);
	scheduler.attachEvent("onXLE", a);
	scheduler.attachEvent("onEventAdded", a);
	scheduler.attachEvent("onEventChanged", a);
	scheduler.attachEvent("onAfterEventDelete", a);
	a();
};
scheduler._markCalendarCurrentDate = function (b) {
	var c = scheduler._date, a = scheduler._mode;
	if (b._date.getMonth() == c.getMonth() && b._date.getFullYear() == c.getFullYear()) {
		if (a == "day" || this._props && this._props[a]) {
			scheduler.markCalendar(b, c, "dhx_calendar_click");
		} else {
			if (a == "week") {
				for (var d = scheduler.date.week_start(new Date(c.valueOf())), e = 0; e < 7; e++) {
					var f = d.getMonth() + d.getYear() * 12 - c.getMonth() - c.getYear() * 12;
					f || scheduler.markCalendar(b, d, "dhx_calendar_click");
					d = scheduler.date.add(d, 1, "day");
				}
			}
		}
	}
};

