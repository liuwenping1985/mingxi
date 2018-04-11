<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
<style>
	.choiceRow{
		max-height:270px;
		height: 100%;
		overflow-x: hidden;
		overflow-x: auto;
		padding: 5px 0;
	}
	.choiceCol{
		position: relative;
		width: 25%;
		float: left;
		font-size: 14px;
		height: 20px;
		padding: 5px 0;
		color: #333333;
	}
	.choiceCol label{
		padding-left: 5px;
	}
	#inputDiv {
		padding: 5px 0px;
	}
	#inputDiv > input {
		height: 30px;
		width: 210px;
		font-size: 14px;
		padding-left: 10px;
	}
	.choiceBtn {
		display: inline-block;
		width: 131px;
		height: 30px;
		line-height: 30px;
		border-radius: 100px;
		background-color: #1f85ec;
		text-align: center;
		font-size: 14px;
		color: #fff;
		cursor: pointer;
	}
	.content .line:not(:first-child){
		cursor: move;
	}
</style>
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
        <div class="before">${ctp:i18n('weixin.system.menu.portalManagement')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.portalNavigationSettings')}</span>
    </div>
    <div id="bottomNavSet">
    	<div class="setContent">
    		<div class="navDetail">
    			<div class="navFirst" id="navFirst">
    				<div class="location">
    					<div class="name">
    						<span>${ctp:i18n('weixin.navigation.pos1')}${ctp:i18n('weixin.navigation.posfix')}</span>
							<input id="pos1" type="hidden" value="[]">
    					</div>
    					<div class="operation">
                            <i class="iconfont icon-delete" style="margin-right: 20px;">&#xe624;</i>
    						<i class="iconfont icon-compile">&#xe83f;</i>
    					</div>
    					<div style="clear: both;;"></div>
    				</div>
    				<div class="content">
    				</div>
    			</div>
    			<div class="navSecond" id="navSecond"  style="display: none">
    				<div class="location">
    					<div class="name">
    						<span>${ctp:i18n('weixin.navigation.pos2')}${ctp:i18n('weixin.navigation.posfix')}</span>
							<input id="pos2" type="hidden" value="[]">
						</div>
    					<div class="operation">
                            <i class="iconfont icon-delete" style="margin-right: 20px;">&#xe624;</i>
    						<i class="iconfont icon-compile">&#xe83f;</i>
    					</div>
    					<div style="clear: both;;"></div>
    				</div>
    				<div class="content">
    				</div>
    			</div>
    			<div class="navThird" id="navThird" style="display: none">
    				<div class="location">
    					<div class="name">
    						<span>${ctp:i18n('weixin.navigation.pos3')}${ctp:i18n('weixin.navigation.posfix')}</span>
							<input id="pos3" type="hidden" value="[]">
						</div>
    					<div class="operation">
                            <i class="iconfont icon-delete" style="margin-right: 20px;">&#xe624;</i>
    						<i class="iconfont icon-compile">&#xe83f;</i>
    					</div>
    					<div style="clear: both;;"></div>
    				</div>
    				<div class="content">
    				</div>
    			</div>
    		</div>
    		<div class="navAdd">
				<div class="addBtn" id="addBtn"><font style="font-size: 26px">+</font><span style="position: relative;top: -3px">${ctp:i18n("weixin.navigation.addMenu")}</span></div>
    		</div>
    		<div class="navSend">
				<div style="padding-bottom: 20px">
					<label for="CorpId" style="height: 30px;line-height: 30px"><font color="red">*</font>${ctp:i18n("weixin.workbench.corpId2")}:</label>
					<input type="text" name="CorpId" id="CorpId" placeholder="请输入CorpID" style="float: right;height: 30px;width: 400px;">
				</div>
    			<div class="nBtn" id="submitBtn">
    				<span>${ctp:i18n('weixin.navigation.submit')}</span>
    			</div>
    			<div class="nContent">
    				<span>${ctp:i18n('weixin.navigation.aftersave')}</span>
    			</div>
    		</div>
    	</div>
		<div class="setOverview">
			<div class="tNav">
				<span>${ctp:i18n('weixin.navigation.preview')}</span>
			</div>
			<div class="tDetail">
				<div class="qWechatDetail choose">
					<img src="${path}/apps_res/weixin/img/qWechat.png" style="width:100%;"/>
					<div class="imgContent">
						<span>${ctp:i18n('weixin.navigation.fake')}</span>
					</div>
				</div>
				<div class="cWechatDetail">
					<img src="${path}/apps_res/weixin/img/cWechat.png" style="width:100%;"/>
					<div class="imgContent">
						<span>${ctp:i18n('weixin.navigation.fake')}</span>
					</div>
				</div>
			</div>
			<div class="tOperate">
				<div class="qWechatOperate choose">
					<div class="op1" id="menu1">
						<div class="name">
							<i class="iconfont icon-menu" style="font-size: 12px;">&#xe600;</i>
							<span>    </span>
						</div>
					</div>
					<div class="op2" id="menu2">
						<div class="name">
							<i class="iconfont icon-menu" style="font-size: 12px;">&#xe600;</i>
							<span>    </span>
						</div>
					</div>
					<div class="op3" id="menu3">
						<div class="name">
							<i class="iconfont icon-menu" style="font-size: 12px;">&#xe600;</i>
							<span>    </span>
						</div>
					</div>
					<div style="clear: both;"></div>
				</div>
			</div>
			<div>
				<font style="color: red; font-size: 12px;">*${ctp:i18n("weixin.navigation.overviewdesc")}</font>
			</div>
		</div>
		<div style="clear: both;"></div>
    </div>
	<div id="dialogDiv" style="margin-top: 10px;padding: 13px;display: none;border: 1px solid #e6e7e9;">
		<div id="inputDiv">
			<label for="showInput" style="padding-right: 10px;font-size: 14px">${ctp:i18n('weixin.navigation.menuname')}：</label>
			<input type="text" id="showInput" disabled maxlength="4">
		</div>
		<div id="allChoiceDiv">
			<div class="choiceRow">
			</div>
		</div>
		<div class="btnDiv" style="margin: auto;width: 320px">
			<div class="choiceBtn" style="margin-right: 50px">
				<span>${ctp:i18n('weixin.navigation.btn1')}</span>
			</div>
			<div class="choiceBtn">
				<span>${ctp:i18n('weixin.navigation.btn2')}</span>
			</div>
		</div>
		<div style="padding-top: 10px;">
			<font style="color: #999999; font-size: 12px;">*${ctp:i18n("weixin.navigation.sortdesc")}</font>
		</div>
	</div>
</body>
<script type="text/javascript" src="${path}/apps_res/weixin/js/jquery-ui-sortable.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	var allChoice = '${allChoiceList}';
	var cipChoice = '[]';
	var initData = '${allNavigations}';
	var userId = '${userId}';
	var isV6 = '${isV6}';
    var ajax_weixinSetManager = new weixinSetManager();
    var ajax_portalConfigManager = new portalConfigManager();
    $("#bottomNavSet").css({"height": $("body").height() - 55 + "px"});
    $(document).ready(function(){
        /* 载入设置 */
        (function () {
            loadData();
        })();

        /* 布局选项点击事件 */
        (function(){
            $("#submitBtn").click(function () {
                var corpId = $.trim($("#CorpId").val());
                if(corpId === ""){
                    $.alert($.i18n("weixin.navigation.corpid"));
                    return false;
				}
				var data = {
				    "pos1" : [],
				    "pos2" : [],
				    "pos3" : [],
					"corpId" : corpId
				};
				var pos1 = JSON.parse($("#pos1").val());
				var pos2 = JSON.parse($("#pos2").val());
				var pos3 = JSON.parse($("#pos3").val());
				if(pos1.length>0){
				    data.pos1 = pos1;
				}
				if(pos2.length>0){
				    data.pos2 = pos2;
				}
				if(pos3.length>0){
				    data.pos3 = pos3;
				}
				if(pos1.length===0 && pos1.length===0 && pos1.length===0){
				    $.alert($.i18n("weixin.navigation.nomenu"));
				    return false;
                }
                ajax_weixinSetManager.saveNavigationConfig(data, {
                    success: function (rv) {
                        if (rv === "noConfig") {
                            $.alert($.i18n('weixin.navigation.noconfig'));
                        }else if(rv === "noAccount"){
                            $.alert($.i18n('weixin.navigation.noaccount'));
                        }else {
                            var msg = $.i18n('weixin.set.success');
                            var img = 0;
                            $.messageBox({
                                'type': 100,
                                'imgType':img,
                                'msg': msg,
                                buttons: [{
                                    id:'btn1',
                                    text: $.i18n("weixin.navigation.btn1"),
                                    handler: function () {
//                                        location.reload();
                                    }
                                }]
                            });
						}
                    },
                    error: function (rv) {
                        $.alert("出错");
                    }
                });
            });
        })();

        /* 三个位置编辑事件 */
        (function(){
            $(".navFirst .operation .icon-compile,.navSecond .operation .icon-compile,.navThird .operation .icon-compile").click(function () {//编缉按钮
                var pos = $(this).parent().parent().find("div.name input").attr("id");
                var checked = $(this).parent().parent().find("div.name input").val();
                var title = $(this).parent().parent().find("div.name span").text();
                var choiceDiv = $("#dialogDiv");
                if(choiceDiv.is(':visible')){
					$.alert($.i18n("weixin.navigation.alertsave"));
				}else{
                    $("#showInput").prop("disabled",true).val("");
                    choiceDiv.appendTo($(this).parent().parent().parent());
                    loadSmallData(pos,checked);
                    choiceDiv.show(200);
                    $(".content").sortable("disable");
                }
            });
            $(".navFirst .operation .icon-delete,.navSecond .operation .icon-delete,.navThird .operation .icon-delete").click(function () {//删除按钮
                var choiceDiv = $("#dialogDiv");
                if(choiceDiv.is(':visible')){
                    $.alert($.i18n("weixin.navigation.alertsave"));
				}else{
                    var checkedInput = $(this).parent().parent().find("div.name input");
                    var pos = $(this).parent().parent().find("div.name input").attr("id");
                    var domId = "";
                    var menuId = "";
                    if(pos === "pos1"){
                        domId = "navFirst";
                        menuId = "menu1";
					}
                    if(pos === "pos2"){
                        domId = "navSecond";
                        c = "menu2";
                    }
                    if(pos === "pos3"){
                        domId = "navThird";
                        menuId = "menu3";
                    }
                    var confirm = $.confirm({
                        'msg': $.i18n("weixin.navigation.delconfirm"),
                        //绑定自定义事件
                        ok_fn: function () {
                            checkedInput.val("[]");
                            initSmallLeft([],domId);
                            if(domId==="navFirst"){
                                choiceDiv.find(":checkbox[data-pos='pos1']").removeAttr("data-pos").prop("checked",false).parent().show();
                                levelUp(2);
                                levelUp(3);
                            }
                            if(domId === "navSecond"){
                                choiceDiv.find(":checkbox[data-pos='pos2']").removeAttr("data-pos").prop("checked",false).parent().show();
                                levelUp(3);
                            }
                            if(domId === "navThird"){
                                choiceDiv.find(":checkbox[data-pos='pos3']").removeAttr("data-pos").prop("checked",false).parent().show();
                            }
                            hideEmpty();
                            refreshRight();
                        },
                        cancel_fn:function(){}
                    });
				}
            });
        })();

        (function(){
            $("#dialogDiv .btnDiv .choiceBtn:eq(0)").click(function () {//dialog确定按钮
                var choiceDiv = $("#dialogDiv");
                var pos = choiceDiv.parent().find(".location .name input").attr("id");
                var menuName = $.trim($("#showInput").val());
                if((!$("#showInput").prop("disabled"))&&menuName === ""){
                    $.alert($.i18n("weixin.navigation.menuempty"));
                    return false;
				}
                var data = getSmallData();
//                initSmallLeft(data);
                saveDataByPos(pos,data);
                choiceDiv.hide(100);
                choiceDiv.find(":checkbox:checked").parent().hide();
                choiceDiv.find(":checkbox:not(:checked)").parent().show();
                $(".content").sortable("enable");
                setTimeout(function () {
                    if($("#pos1").val() == "[]"){
                        levelUp(2);
                    }
                    if($("#pos2").val() == "[]"){
                        levelUp(3);
                    }
                    refreshRight();
                    hideEmpty();
                },150);
            });
            $("#dialogDiv .btnDiv .choiceBtn:eq(1)").click(function () {//dialog取消按钮
                var choiceDiv = $("#dialogDiv");
                var pos = choiceDiv.parent().find(".location .name input").attr("id");
                var data = loadDataByPos(pos);
                initSmallLeft(data);

                choiceDiv.hide(100);

                $("#dialogDiv :checkbox:checked[data-pos='"+ pos +"']").prop("checked",false).removeAttr("data-pos").parent().show();
                $.each(data,function (key,obj) {
                    if(obj.menuId !== "menu"){
                        $("#" + obj.menuId).prop("checked",true).attr("data-pos",pos).parent().hide();
                    }
                });
                choiceDiv.find(":checkbox:checked").parent().hide();
                choiceDiv.find(":checkbox:not(:checked)").parent().show();
                $(".content").sortable("enable");
                setTimeout(function () {
                    if($("#pos1").val() == "[]"){
                        levelUp(2);
                    }
                    if($("#pos2").val() == "[]"){
                        levelUp(3);
                    }
                    refreshRight();
                    hideEmpty();
                },150);
            });
        })();

		(function () {
			$("#addBtn").click(function () {
			    var first = $("div.navFirst:eq(0)");
			    var second = $("div.navSecond:eq(0)");
			    var third = $("div.navThird:eq(0)");
				if(!second.is(":visible")){
				    if(first.find(".location .name input").val()==="[]"){
                        $.alert($.i18n("weixin.navigation.pos1alert"));
                    }else{
                        second.show();
                    }
					return true;
				}
                if(!third.is(":visible")){
                    if(second.find(".location .name input").val()==="[]"){
                        $.alert($.i18n("weixin.navigation.pos2alert"));
                    }else{
                        third.show();
                    }
                    return true;
                }else{
                    $.alert($.i18n("weixin.navigation.poslimit"));
				}
            });
        })();

		(function () {
            $(".content").sortable({
                items: "div:not(:first)",
                appendTo:"parent",
                axis: "y",
                update : function(event, ui) {
                    var list = $(event.target).find(".line");
                    var array = new Array();
                    for(var i = 0;i<list.length;i++) {
                        var row = $(list[i]).find(">span");
                        array.push({
                            menuName: row.text(),
                            menuId: row.attr("data-id")
                        })
                    }
                    $(event.target).prev().find("input").val(JSON.stringify(array));
                    refreshRight();
                },
            }).disableSelection();
        })();
    });

    function initDialog() {
        var _choiceTpl = $("<div class=\"choiceCol\">" +
            "<input id=\"\" type=\"checkbox\" name=\"choice\">" +
            "<label for=\"\"></label>" +
            "</div>");
        var choiceListObj = $.parseJSON(allChoice);
        $(".choiceRow").html("");
        for(var i = 0 ; i<choiceListObj.length ; i++){
            var choice = choiceListObj[i];
            var tempDom = _choiceTpl.clone();
            tempDom.prop("heresy",choice.heresy);
            tempDom.find("input").attr("id","choice_"+choice.id);
            tempDom.find("label").attr("for","choice_"+choice.id).text(choice.name);
            $(".choiceRow").append(tempDom);
            tempDom.find("input").click(function () {
                var pos = $("#dialogDiv").parent().find(".location .name input").attr("id");
                var name = $(this).next("label").text();
                var id = $(this).attr("id");
                var isChecked = $(this).is(":checked");
                if(isChecked){
                    var checkedLength = $(this).parents(".choiceRow").find(":checkbox:visible:checked").length
                    if(checkedLength>5){
                        $.alert($.i18n("weixin.navigation.alertfive"));
                        return false;
					}
                    $(this).attr("data-pos",pos);
//					var data = {
//						menuId : id,
//						menuName : name
//					};
//                  appendSmallLeft(data);
                    var leftList = $("#dialogDiv").prev().find("> div");
                    if(leftList.length === 1){
                        $("#showInput").prop("disabled" , false).val($.i18n("weixin.navigation.unnamed"));
                    }
                    initSmallLeft(getSmallData());
                }else{
                    $(this).removeAttr("data-pos");
                    removeSmallLeftByDataId(id);
				}
//                var finalData = getSmallData();
				refreshRight();
            });
            $('#showInput').bind('input propertychange', function() {
                 var text = $(this).val();
                $("#dialogDiv").prev().find("> div:has(span[data-id='menu']) span").text(text);
				var menuInput;
                var leftDivId = $("#dialogDiv").parent().attr("id");
                if(leftDivId === "navFirst"){
                    menuInput = $("#menu1 .name span");
                }
                if(leftDivId === "navSecond"){
                    menuInput = $("#menu2  .name span");
                }
                if(leftDivId === "navThird"){
                    menuInput = $("#menu3  .name span");
                }
                menuInput.text(text);
            });
        }
    }

    /**
	 * 载入数据
     */
    function loadData() {
		var data = JSON.parse(initData);
		var pos1 = data.pos1;
		var pos2 = data.pos2;
		var pos3 = data.pos3;
		$("#pos1").val(JSON.stringify(pos1));
		$("#pos2").val(JSON.stringify(pos2));
		$("#pos3").val(JSON.stringify(pos3));
        initSmallLeft(pos1,"navFirst");
        initSmallLeft(pos2,"navSecond");
        initSmallLeft(pos3,"navThird");

        if(JSON.stringify(pos2) !== "[]"){
            $("#navSecond").show();
		}
        if(JSON.stringify(pos3) !== "[]"){
            $("#navThird").show();
		}

        refreshRight();
        if(isV6 === "false"){
            loadCIP();
        }
        initDialog();

        $.each(pos1,function(key,obj){
            if(obj.menuId !== "menu"){
                $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos1").parent().hide();
			}
        });
        $.each(pos2,function(key,obj){
            if(obj.menuId !== "menu"){
                $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos2").parent().hide();
            }

        });
        $.each(pos3,function(key,obj){
            if(obj.menuId !== "menu"){
                $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos3").parent().hide();
            }

        });
    }

    function loadSmallData(pos,data){
        var choiceDiv = $("#dialogDiv");
        var checked = JSON.parse(data);
        if(checked.length>0 && checked[0].menuId === "menu"){
            $("#showInput").prop("disabled",false).val(checked[0].menuName);
		}
        choiceDiv.find(":checkbox[data-pos='"+pos+"']").parent().show();

	}

	function getSmallData() {
        var menuName = $("#showInput").val();
        var data = new Array();
        var checkedList = $(".choiceRow :checkbox:visible:checked");
        if(checkedList.length === 0){
//
        }else if(checkedList.length === 1){
//            data.menuName = $(checkedList[0]).next().text();
//            data.menuId = $(checkedList[0]).attr("id");
            data.push({
                menuName : $(checkedList[0]).next().text(),
                menuId : $(checkedList[0]).attr("id"),
                menuUrl : $(checkedList[0]).attr("data-url")
			})
        }else if(checkedList.length >1){
//            data.menuName = menuName;
//            data.menuId = "menu";
            data.push({
                menuName : menuName,
                menuId : "menu",
                menuUrl : ""

            });
            var secondList = new Array();
            for(var i = 0 ;i<checkedList.length; i++){
                var temp = {
                    menuName : $(checkedList[i]).next().text(),
                    menuId : $(checkedList[i]).attr("id"),
                    menuUrl : $(checkedList[i]).attr("data-url")
                };
                data.push(temp);
            }
        }
        return data;
    }
    /**
	 * 左侧位置下更新
     */
    function initSmallLeft(data,domId){
        var _bigTpl = $("<div class=\"line\"><span></span></div>");
		var targetDiv;
        if(domId){
			targetDiv = $("#"+domId + ">.content");
        }else {
            targetDiv = $("#dialogDiv").prev();
        }
        targetDiv.html("");

        for(var i = 0;i < data.length ; i++){
            var bigId = data[i].menuId;
            var bigName = data[i].menuName;

            var bigDom = _bigTpl.clone();
            bigDom.find("span").text(bigName).attr("data-id",bigId).end().appendTo(targetDiv);
		}
	}
	function appendSmallLeft(data) {
        var _bigTpl = $("<div class=\"line\"><span></span></div>");
        var id = data.menuId;
        var name = data.menuName;
        var list = $("#dialogDiv").prev().find("> div");
        if(list.length === 1){
            var preMenu = _bigTpl.clone();
            preMenu.find("span").text($.i18n("weixin.navigation.unnamed")).attr("data-id","menu");
            $("#dialogDiv").prev().prepend(preMenu);
            $("#showInput").prop("disabled" , false);
		}
		var bigDom = _bigTpl.clone();
		bigDom.find("span").text(name).attr("data-id",id).end().appendTo($("#dialogDiv").prev());

        $("#showInput").val($("#dialogDiv").prev().find("> div:has(span[data-id='menu'])").text());
    }
    function removeSmallLeftByDataId(dataId) {
		$("#dialogDiv").prev().find("div:has(span[data-id='"+dataId+"'])").remove();
        var list = $("#dialogDiv").prev().find("> div:has(span[data-id!='menu'])");
        if(list.length === 1){
            $(list[0]).prev().remove();
            $("#showInput").prop("disabled" , true).val("");

        }
		$("#showInput").val($("#dialogDiv").prev().find("> div:has(span[data-id='menu'])").text());
    }

    function saveDataByPos(pos, data){
        if(data.length === 0){
            $("#"+pos).val("[]")
        }else{
            $("#"+pos).val(JSON.stringify(data));
        }
	}
    function loadDataByPos(pos){
        var target = $("#"+pos);
        var data = [];
        if(target.length > 0){
            data = JSON.parse(target.val());
		}
        return data;
	}

    /**
	 * 左侧完全安定才可掉用右侧预览
     */
	function refreshRight(){
        $("#menu1,#menu2,#menu3").hide();

        var pos1Data = $("#pos1").val();
        var pos2Data = $("#pos2").val();
        var pos3Data = $("#pos3").val();

        if($("#dialogDiv").is(":visible")){
            var tempData = JSON.stringify(getSmallData());
            var leftDivId = $("#dialogDiv").parent().attr("id");
            if(leftDivId === "navFirst"){
                pos1Data = tempData;
            }
            if(leftDivId === "navSecond"){
                pos2Data = tempData;
            }
            if(leftDivId === "navThird"){
                pos3Data = tempData;
            }
		}

        var mode = 0;
		if(pos1Data !== "[]"){
		    var pos1Json = JSON.parse(pos1Data);
            _initSmallRight(pos1Json,"menu1");
		    mode++;
		}else{
            _clearSmallRight("menu1");
		}
		if(pos2Data !== "[]"){
            var pos2Json = JSON.parse(pos2Data);
            _initSmallRight(pos2Json,"menu2");
            mode++;
		}else{
            _clearSmallRight("menu2");
        }
		if(pos3Data !== "[]"){
            var pos3Json = JSON.parse(pos3Data);
            _initSmallRight(pos3Json,"menu3");
            mode++;
		}else{
            _clearSmallRight("menu3");
        }
		_changMode(mode);

		function _changMode(mode) {
			if(mode === 0){
			    $("#menu1,#menu2,#menu3").hide();
			}
            if(mode === 1){
                $("#menu2,#menu3").hide();
                $("#menu1").css({"width":"100%"}).find(".more").css({"left":"115px"}).end().show();
            }
            if(mode=== 2){
                $("#menu3").hide();
                $("#menu1").css({"width":"50%"}).find(".more").css({"left":"32px"}).end().show();
                $("#menu2").css({"width":"49%","border":"0"}).find(".more").css({"left":"32px"}).end().show();

			}
            if(mode=== 3){
                $("#menu1,#menu2,#menu3").css({"width":"33%","border":""}).find(".more").css({"left":""}).end().show();
			}
        }

        /**
         * 右侧预览图更新
         * 菜单 top 基准 -65  每多一个-35 公式 -65 +（-35*(n-1)）
         */
        function _initSmallRight(data,domId){
            var _menuTpl = $("<div class=\"more\">" +
                "<b class=\"bottom\">" +
                "<i class=\"bottom-arrow1\"></i>" +
                "<i class=\"bottom-arrow2\"></i>" +
                "</b>" +
                "</div>");
            var _bigTpl = $("<div class=\"item\"><span></span></div>");

            var targetDiv = $("#"+domId);

            targetDiv.find("div.more").remove();
            targetDiv.find("div.name").find("i").hide().end().find("span").text("");
            if(data.length === 0){

            }else if(data.length === 1){
                targetDiv.find("div.name span").text(data[0].menuName);
            }else{
                var menu = _menuTpl.clone();
                for(var i = 0;i < data.length ; i++){
                    if(i === 0){
                        targetDiv.find("div.name span").text(data[i].menuName);
                        targetDiv.find("div.name i").show();
                    }else{
                        var tempMenuRow = _bigTpl.clone();
                        tempMenuRow.find("span").text(data[i].menuName);
                        menu.append(tempMenuRow);
                    }
                }
                menu.css("top", -65 +(-35*(data.length-1)));
                targetDiv.append(menu);
            }
        }
        function _clearSmallRight(domId) {
            var targetDiv = $("#"+domId);
            targetDiv.find("div.more").remove();
            targetDiv.find("div.name").find("i").hide().end().find("span").text("");
        }
	}

    /**
	 * 塔达林升格仪式，后继有人占位时，将后位升格至前位
     * @param type 待升格的位置
     */
	function levelUp(type) {
        var choiceDiv = $("#dialogDiv");

        var data = "[]";
	    if(type === 2 && $("#navSecond").is(":visible")){
	        data = $("#pos2").val();
	        $("#pos1").val(data);
            choiceDiv.find(":checkbox[data-pos='pos1']").removeAttr("data-pos").prop("checked",false).parent().show();
            choiceDiv.find(":checkbox[data-pos='pos2']").attr("data-pos","pos1").parent().hide();

            $("#pos2").val("[]");
            initSmallLeft(JSON.parse(data),"navFirst");
            initSmallLeft([],"navSecond");
        }
        if(type === 3 && $("#navThird").is(":visible")){
            data = $("#pos3").val();
            $("#pos2").val(data);
            choiceDiv.find(":checkbox[data-pos='pos2']").removeAttr("data-pos").prop("checked",false).parent().show();
            choiceDiv.find(":checkbox[data-pos='pos3']").attr("data-pos","pos2").parent().hide();

            $("#pos3").val("[]");
            initSmallLeft(JSON.parse(data),"navSecond");
            initSmallLeft([],"navThird");
        }
    }

    function hideEmpty(){
        if($("#pos2").val()==="[]"){
            $("#navSecond").hide();
        }
        if($("#pos3").val()==="[]"){
            $("#navThird").hide();
        }
	}
	
	function loadCIP() {
		var _domTpl = $("<div class=\"choiceCol\" style=\"display: block;\">" +
						"	<input name=\"choice\" id=\"\" type=\"checkbox\">" +
						"	<label for=\"choice_1\"></label>" +
						"</div>");
		//TODO 一个ajax取CIP数据
        ajax_portalConfigManager.getThirdpartyPortal4Wechat({
            success: function (rv) {
                for(var i = 0;i<rv.length;i++){
                    var dom = rv[i];
					var url = dom.entry;
					var registerName = dom.appName;
					var iconH5 = dom.iconUrl;
					if(iconH5 == "" || typeof iconH5 == "undefined"){
					    iconH5 = _ctxPath + "/apps_res/weixin/img/workbenchIcon/third.png";
					}
					var registerId = dom.appId;
					var domHtml = _domTpl.clone();
                    domHtml.find("label").text(registerName).attr("for","choice_" + registerId).end()
						.find("input").attr("id","choice_" + registerId).attr("data-url",url).click(function () {
                        var pos = $("#dialogDiv").parent().find(".location .name input").attr("id");
                        var name = $(this).next("label").text();
                        var id = $(this).attr("id");
                        var isChecked = $(this).is(":checked");
                        if(isChecked){
                            var checkedLength = $(this).parents(".choiceRow").find(":checkbox:visible:checked").length
                            if(checkedLength>5){
                                $.alert($.i18n("weixin.navigation.alertfive"));
                                return false;
                            }
                            $(this).attr("data-pos",pos);
                            var leftList = $("#dialogDiv").prev().find("> div");
                            if(leftList.length === 1){
                                $("#showInput").prop("disabled" , false).val($.i18n("weixin.navigation.unnamed"));
                            }
                            initSmallLeft(getSmallData());
                        }else{
                            $(this).removeAttr("data-pos");
                            removeSmallLeftByDataId(id);
                        }
                        refreshRight();
                    });;
                    $("#allChoiceDiv .choiceRow").append(domHtml);
				}

                var data = JSON.parse(initData);
                var pos1 = data.pos1;
                var pos2 = data.pos2;
                var pos3 = data.pos3;
                $.each(pos1,function(key,obj){
                    if(obj.menuId !== "menu"){
                        $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos1").parent().hide();
                    }
                });
                $.each(pos2,function(key,obj){
                    if(obj.menuId !== "menu"){
                        $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos2").parent().hide();
                    }

                });
                $.each(pos3,function(key,obj){
                    if(obj.menuId !== "menu"){
                        $("#" + obj.menuId).prop("checked",true).attr("data-pos","pos3").parent().hide();
                    }

                });
            },
            error: function (rv) {
                $.alert("loadCIP数据出错");
            }
        });
    }
</script>
</html>