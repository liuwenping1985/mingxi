$(function () {
	var qsData = [
		{text: "新建协同", group: "菜单", handler: function(){ alert("新建协同") }},
		{text: "代办协同", group: "菜单", handler: function(){ alert("代办协同") }},
		{text: "新建工作计划", group: "菜单", handler: function(){ alert("新建工作计划") }},
		{text: "工作计划", group: "菜单", handler: function(){ alert("工作计划") }},
		{text: "新建会议", group: "菜单", handler: function(){ alert("新建会议") }},
		{text: "会议安排", group: "菜单", handler: function(){ alert("会议安排") }},
		{text: "马川江", group: "人", handler: function(){ alert("马川江") }},
		{text: "雷会计", group: "人", handler: function(){ alert("雷会计") }},
		{text: "陈奶奶", group: "人", handler: function(){ alert("陈奶奶") }},
		{text: "个人空间", group: "空间", handler: function(){ alert("个人空间") }},
		{text: "单位空间", group: "空间", handler: function(){ alert("单位空间") }},
		{text: "今天你挨踢啦吗？今天你挨踢啦吗？今天你挨踢啦吗？", group: "空间", handler: function(){ alert("今天你挨踢啦吗？") }}
	];
	//初始化快速搜索
	var qq = new spotlight({
		data: qsData
	});
})
/*** 组件 —— spotlight快速打开 ***/
function spotlight (argument) {
	var p = {
		id: "spotlight_" + Math.floor(Math.random() * 100000000),
		data: []
	};
	$.extend(p, argument);
	//转化拼音
	for (var i = 0; i < p.data.length; i++) {
		p.data[i].pinyin = ConvertPinyin(p.data[i].text);
	};
	this.init(p);
	return this;
}
spotlight.prototype.init = function (p){
	this.creatHtml(p);
}
spotlight.prototype.creatHtml = function(p) {
	var _this = this;
	var _html = "";
	_html += '<div id="'+ p.id +'" class="spotlight">';
		_html += '<div class="search_textbox clearfix">';
			_html += '<em class="ico24 left"></em>'
			_html += '<input type="text" />';
		_html += '</div>';
		_html += '<ul class="search_list">';
		_html += '</ul>';
	_html += '</div>';
	this.showMask();
	$("body").append(_html);

	var _data = p.data;
	$("#" + p.id + " .search_textbox input").focus().keyup(function (e) {
		if (!(e.keyCode >= 65 && e.keyCode <= 90 || e.keyCode == 46 || e.keyCode == 8 || e.keyCode == 32)) {
			return;
		};

		var val = $(this).val();
		//查询内容为空，不查询
		if (val == "") {
			$("#" + p.id).find(".search_list").empty();
			return;
		};
		//搜索内容转为拼音，以支持汉字、谐音字搜索
		val = ConvertPinyin(val);

		// console.log("searching:" + val)
		for (var i = 0; i < _data.length; i++) {
			console.log(_data[i].pinyin +"___"+ val +"___"+ _data[i].pinyin.indexOf(val))
			if (_data[i].pinyin.indexOf(val) != -1) {
				_data[i].show = true;
			} else {
				_data[i].show = false;
			}
		};
		// console.log("查找完毕，开始显示结果")
		_this.refreshData(_data, p);
	});
};
spotlight.prototype.refreshData = function(data, p) {
	var _this = this;
	var _html = "";
	var _data = data;
	var _listObj = $("#" + p.id + " .search_list");
	var _group = "";
	if (data == undefined) {
		_data = p.data;
	};
	var firstShow = true;
	
	$("#" + p.id).find(".search_list").empty();
	for (var i = 0; i < _data.length; i++) {
		var _current = "";
		if (_data[i].show != true) {
			continue;
		};
		if (firstShow == true) {
			_current = " current";
			firstShow = false;
		};

		if (_group == "" || _data[i].group != _group) {
			_group = _data[i].group;
			_html += '<li class="group">'+ _data[i].group +'</li>';
		};
		_html += '<li data-number="'+ i +'" class="'+ _current +'">'+ _data[i].text +'</li>';
	}
	_listObj.append(_html);


	var _spotlightObj = $("#" + p.id);
	var _listLiObj = _listObj.find("li:not('.group')");

	_listLiObj.unbind().mouseenter(function () {
		_listLiObj.removeClass("current");
		$(this).addClass("current");
	}).mouseleave(function () {
		_listLiObj.removeClass("current");
	}).click(function () {
		p.data[$(this).attr("data-number")].handler();
	});

	document.onkeydown = function(e) { 
		var _spotlightObj = $("#" + p.id);

		switch (e.keyCode){
			//方向键：上
			case 38:
				if ($("#" + p.id).find(".search_list .current").size() == 0) {
					$("#" + p.id).find(".search_list li:not('.group')").eq(0).addClass("current");
					break;
				};
				if ($("#" + p.id).find(".search_list li.current").index() == 1) {
					break;
				};
				$("#" + p.id).find(".search_list li.current").removeClass("current").prev().addClass("current");
				if ($("#" + p.id).find(".search_list li.current").hasClass("group")) {
					$("#" + p.id).find(".search_list li.current").removeClass("current").prev().addClass("current");
				};
				break;

			//方向键：下
			case 40:
				if ($("#" + p.id).find(".search_list .current").size() == 0) {
					$("#" + p.id).find(".search_list li:not('.group')").eq(0).addClass("current");
					break;
				};
				if ($("#" + p.id).find(".search_list li.current").next().size() == 0) {
					break;
				};
				$("#" + p.id).find(".search_list li.current").removeClass("current").next().addClass("current");
				if ($("#" + p.id).find(".search_list li.current").hasClass("group")) {
					$("#" + p.id).find(".search_list li.current").removeClass("current").next().addClass("current");
				};
				break;

			case 13:
				var n = $("#" + p.id).find(".search_list li.current").attr("data-number");
				if (n != undefined) {
					p.data[n].handler();
				};
				break;	
		}
	}
};
spotlight.prototype.showMask = function() {
	$("body").append('<div class="spotlight_mask"></div>');
};
spotlight.prototype.hideMask = function() {
	$(".spotlight_mask").remove();
};