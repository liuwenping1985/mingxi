// 
//                                  _oo8oo_
//                                 o8888888o
//                                 88" . "88
//                                 (| -_- |)
//                                 0\  =  /0
//                               ___/'==='\___
//                             .' \\|     |// '.
//                            / \\|||  :  |||// \
//                           / _||||| -:- |||||_ \
//                          |   | \\\  -  /// |   |
//                          | \_|  ''\---/''  |_/ |
//                          \  .-\__  '-'  __/-.  /
//                        ___'. .'  /--.--\  '. .'___
//                     ."" '<  '.___\_<|>_/___.'  >' "".
//                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//                    \  \ `-.   \_ __\ /__ _/   .-` /  /
//                =====`-.____`.___ \_____/ ___.`____.-`=====
//                                  `=---=`
// 
// 
//               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                          佛祖保佑         永不宕机/永无bug

var opc;
$(function(){
    opc = new OtherPeopleCard();
	opc.initOtherPeopleData();
});

/*
 * 他人任务卡片
 */
function OtherPeopleCard(){}

/**
 * 初始化他人看板页面
 */
OtherPeopleCard.prototype.initOtherPeopleData = function(){
	var _this = this;
	this.initConditionEvent();
	
	this.otherPeopleObject = new Object();
	//首先对页面进行布局，同时取得一行显示多少人员卡片
	this.otherPeopleObject.layoutObject  = this.initOtherPeopleCardLayout();
	$(window).resize(_this.initOtherPeopleCardLayout);
	//创建瀑布流滚动对象
	this.otherPeopleObject.scrollPage = $("#otherPeopleUl").scrollPage({
		pageSize : this.otherPeopleObject.layoutObject.oneColShowNum * 5,
		changeParamFun : this.memoryPaging,
		scrollContent : ".stadic_layout_body",
		managerName: "taskAjaxManager",
        managerMethod: "getOtherPeopleTaskCard",
        callbackFun:function(){//每次回填数据后调整下布局
        	_this.initOtherPeopleCardLayout();
        }
	});
	
	this.conditionSearch();
}

/**
 * 所有人员放在js中，进行内存分页后转换成JSON传入后台统计
 */
OtherPeopleCard.prototype.memoryPaging = function(){
	var scrollPageObj = opc.otherPeopleObject.scrollPage;
	var currentPage = scrollPageObj.cfg.currentPage;
	var pageSize = scrollPageObj.cfg.pageSize;
	var beginIndex = (currentPage-1)*pageSize;
	var endIndex = beginIndex + pageSize;
	
	var memory = new Array();
	var currentMembers = opc.otherPeopleObject.currentMembers;
	for(beginIndex;beginIndex<endIndex;beginIndex++){
		if(currentMembers[beginIndex] != null){
			memory.push(currentMembers[beginIndex]);
		}else{
			break;
		}
	}
	scrollPageObj.cfg.params.marginLeftNum = opc.otherPeopleObject.layoutObject.marginLeftNum;
	scrollPageObj.cfg.params.memberJson = $.toJSON(memory);
}

//他人任务列表
OtherPeopleCard.prototype.initOtherPeopleCardLayout = function() {
	var layoutObject = new Object();
	var _area_w = $(".projectTask_taskOtherList").parent().width() - 20;
	var _item_w = 196;
	//一行显示卡片个数
	var _oneColShow_num = Math.floor(_area_w / (_item_w + 20));
	layoutObject.oneColShowNum = _oneColShow_num;
	var _marginLeft_num = Math.floor((_area_w - _item_w * _oneColShow_num) / (_oneColShow_num - 1));
	layoutObject.marginLeftNum = _marginLeft_num;
	$(".projectTask_taskOtherList").css({
		"width": _area_w + _marginLeft_num,
		"margin-left": -1 * _marginLeft_num
	});
	$(".projectTask_taskOtherList li").css("margin-left", _marginLeft_num);
	return layoutObject;
}

/**=====他人任务事件=====**/
/**
 * 绑定查询条件文本框事件
 */
OtherPeopleCard.prototype.initConditionEvent = function(){
	new inputChange($("#inputCondition"), $.i18n("taskmanage.otherPeopleTask.search.title"));
	//绑定查询按钮事件
	$("#aCondition").unbind("click").bind("click",this.conditionSearch);
	//回车键事件 keypress()回车被屏蔽了，只能用keyup
	$("#inputCondition").unbind("keyup").bind("keyup",function(e){
		if(e.keyCode == "13"){
			opc.conditionSearch();
		}
	});
	//绑定他人任务卡片点击事件
	$(".projectTask_taskOtherList li").live("click",function(){
		//alert($(this).attr("id"));
		var memberId = $(this).attr("id");
		window.location.href = _ctxPath + "/taskmanage/taskinfo.do?method=projectTaskList&pageType=task&listType=Manage&memberId=" + memberId;
	});
}

/**
 * 执行条件查询操作
 */
OtherPeopleCard.prototype.conditionSearch = function(){
	var inputCondition = "";
	if(!$("#inputCondition").hasClass("color_gray") && !$.isNull($("#inputCondition").val())){
		//如果文本框为"请输入姓名"则表示空输入
		inputCondition = $("#inputCondition").val();
	}
	var allMembers = $.parseJSON($("#otherMembersJSON").val());
	var currentMembers; //条件查询后剩余的他人任务
	if(!$.isNull(inputCondition)){
		currentMembers = new Array();
		for(var i=0;i<allMembers.length;i++){
			if(allMembers[i].userName.indexOf(inputCondition) >= 0){
				currentMembers.push(allMembers[i]);
			}
		}
	}else{
		currentMembers = allMembers;
		if(!$.isArray(currentMembers)){//如果JSON对象不是数组说明无数据，但无数据还是要保存一个空数组，方便后续使用
			currentMembers = [];
		}
	}
	//将他人任务结果缓存
	opc.otherPeopleObject.currentMembers = currentMembers;
	
	//清空条件区
	$("#otherPeopleUl").empty();
	
	//如果有他人数据则调用翻页组件
	var param = new Object();
	param.total = opc.otherPeopleObject.currentMembers.length;
	$("#otherPeopleUl").ajaxSrollLoad(param);
}