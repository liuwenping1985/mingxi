<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
		<div class="before">${ctp:i18n("weixin.system.menu.portalManagement")}</div><span class="gap">/</span><span class="current">${ctp:i18n("weixin.system.menu.portalWorkbenchDingDing")}</span>
	</div>
	<div id="workbenchScroll">
		<div class="set">
			<div class="setContent" style="font-size: 14px;color: #000;">
				<span>${ctp:i18n("weixin.workbench.setinfo")}：</span>
			</div>
			<div class="setContent" style="margin-top: 17px;">
				<span>${ctp:i18n("weixin.workbench.setinfo1")}</span>
			</div>
		</div>
		<div id="wechatWorkbench">
			<div class="wQrocess">
				<div class="secondStep" style="width:222px;">
					<div class="blocks">
						<div style="position: absolute;right: -11px;top: 10px;">
							<div class="leftTag">
								<div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
									<img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
								</div>
							</div>
						</div>
						<div class="block">
							<span>${ctp:i18n("weixin.workbench.input")}</span>
						</div>
					</div>
				</div>
				<div class="secondStep">
					<div class="blocks">
						<div style="position: absolute;right: -16px;top: 10px;">
							<div class="leftTag">
								<div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
									<img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
								</div>
							</div>
						</div>
						<div class="block">
							<span>${ctp:i18n("weixin.workbench.copyurl")}</span>
						</div>
					</div>
				</div>
				<div class="firstStep">
					<div class="blocks">
						<div class="block">
							<span style="display: inline-block;margin-top: 15px;">${ctp:i18n("weixin.workbench.login1")}</span>
							<div class="blockBtn" style="cursor: pointer" onclick="window.open('https://oa.dingtalk.com/#/login'); ">
								<span >${ctp:i18n("weixin.workbench.login")}</span>
							</div>
						</div>
						<div class="leftTag">
							<div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
								<img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
							</div>
						</div>
						<div class="block1">
							<span style="display: inline-block;margin-top: 15px;">${ctp:i18n("weixin.workbench.getid")}</span><br>
							<span style="display: inline-block;margin-top: 5px;">${ctp:i18n("weixin.workbench.getidtext2")}</span>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="content">
						<span>${ctp:i18n("weixin.workbench.login3")}</span>
					</div>
				</div>

				<div style="clear: both;"></div>
			</div>
			<div class="cropID">
				<div class="cropIDName">
					<span style="color:#d0021b;">*</span>
					<span>${ctp:i18n("weixin.workbench.corpId1")}:</span>
				</div>
				<div class="cropIDInput">
					<input type="text" id="corpId" name="corpId"/>
				</div>
				<div class="cropIDBtn" onclick="createUrl()">
					<span>${ctp:i18n("weixin.workbench.create")}</span>
				</div>
			</div>
			<div class="copyContent">
				<div class="title">
					<span>${ctp:i18n("weixin.workbench.list")}:</span>
				</div>
				<div class="fastO">
					<div class="name">
						<span>${ctp:i18n("weixin.function.lable1")}:</span>
					</div>
					<div class="fBlock">
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/allLeading.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.affiar")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_1" name="choice_1" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/infoGateway.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.portalindex")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_2" name="choice_2" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/allApps.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.allapp")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_3" name="choice_3" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/newCollaboration.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.newcol")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_11" name="choice_11" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/newFormPlate.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.newform")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_12" name="choice_12" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/newTask.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.newtask")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_13" name="choice_13" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/newMeeting.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.newmeeting")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_14" name="choice_14" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div style="clear: both;"></div>
					</div>
				</div>
				<div class="standardO">
					<div class="name">
						<span>${ctp:i18n("weixin.function.lable2")}:</span>
					</div>
					<div class="sBlock">
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/collaboration.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.col")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_21" name="choice_21" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/meeting.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.meeting")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_101" name="choice_101" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/edoc.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.edoc")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_102" name="choice_102" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/bulletin.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.bul")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_103" name="choice_103" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/news.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.news")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_104" name="choice_104" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/bbs.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.bbs")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_105" name="choice_105" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/inquery.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.survey")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_106" name="choice_106" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/show.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.bigshow")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_107" name="choice_107" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/registration.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.checkin")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_108" name="choice_108" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/myCollection.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.myfav")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_109" name="choice_109" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/salary.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.salary")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_110" name="choice_110" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/doc.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.doc")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_111" name="choice_111" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/schedual.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.timeline")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_112" name="choice_112" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/task.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.worktask")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_113" name="choice_113" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/queryStatistics.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.query")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_114" name="choice_114" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/behavior.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.performance")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_116" name="choice_116" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div class="item">
							<div class="cIcon">
								<img src="${path}/apps_res/weixin/img/workbenchIcon/addressbook.png">
								<div class="download">
									<span class="iconfont icon-download">&#xe619;</span>
								</div>
							</div>
							<div class="cContent">
								<div class="name">
									<span>${ctp:i18n("weixin.function.addressbook")}:</span>
								</div>
								<div class="content">
									<input type="text" id="choice_117" name="choice_117" readonly="">
								</div>
							</div>
							<div class="cBtn">
								<span>${ctp:i18n("weixin.workbench.copy")}</span>
							</div>
						</div>
						<div style="clear: both;"></div>
					</div>
				</div>
				<div id="cipO" class="cipO">
					<div class="name">
						<span>${ctp:i18n("weixin.function.cip")}:</span>
					</div>
					<div class="cBlock">
					</div>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
	</div>
	<script src="${path}/apps_res/weixin/js/iconfont.js"></script>
</body>
<script type="text/javascript">
    var ajax_weixinSetManager = new weixinSetManager();
    var ajax_portalConfigManager = new portalConfigManager();
    var isV6 = '${isV6}';
    if ( !Array.prototype.forEach ) {
        Array.prototype.forEach = function forEach( callback, thisArg ) {
            var T, k;
            if ( this == null ) {
                throw new TypeError( "this is null or not defined" );
            }
            var O = Object(this);
            var len = O.length >>> 0;
            if ( typeof callback !== "function" ) {
                throw new TypeError( callback + " is not a function" );
            }
            if ( arguments.length > 1 ) {
                T = thisArg;
            }
            k = 0;
            while( k < len ) {
                var kValue;
                if ( k in O ) {
                    kValue = O[ k ];
                    callback.call( T, kValue, k, O );
                }
                k++;
            }
        };
    }
    if(isV6 === "false"){
        loadCIP();
    }else{
        $("#cipO").hide();
	}
    if(navigator.userAgent.indexOf('MSIE 8') != -1){
		$("#chooseIcon").html('<i class="iconfont" style="font-size: 26px;">&#xe601;</i>');
	}else{
		$("#chooseIcon").html('<svg class="svgIcon" aria-hidden="true">'+
			'<use xlink:href="#icon-dingding"></use>'+
			'</svg>');
	}
	$("#workbenchScroll").css({"height": $("body").height() - 48 +"px","overflow":"auto"});


	function createUrl() {
        var corpId = $.trim($("#corpId").val());
        if(corpId === ""){
            $.alert($.i18n("weixin.navigation.corpid"));
            return false;
        }

        var cipList = new Array();
        var cipRows = $("#cipO input");
        for(var i = 0;i<cipRows.length;i++){
           var row = $(cipRows[i]);
           cipList.push({
			   id:row.attr("id"),
			   url:row.attr("data-url")
		   })
		}
        var data = {
            corpId :corpId,
            type: "dingding",
            cip: cipList
        };
        ajax_weixinSetManager.getAppUrl(data, {
            success: function (rv) {
                var rvJson = JSON.parse(rv);
                if (rvJson.msg === "noConfig") {
                    $.alert($.i18n('weixin.navigation.noconfig'));
                }else if(rvJson.msg === "noAccount") {
                    $.alert($.i18n('weixin.navigation.noaccount'));
                }else {
                    var list = rvJson.data;
                    if(list){
                        list.forEach(function (elm,key) {
                            var dom = $("#"+elm.id);
                            if(dom.length>0){
                                dom.val(elm.url);
                            }
                        });
                    }
                }
            },
            error: function (rv) {
                $.alert("出错");
            }
        });

    }

    function loadCIP() {
        var _domTpl = $("<div class=\"item\">" +
            			"	<div class=\"cIcon\">" +
            			"		<img src=\"\">" +
            			"		<div class=\"download\">" +
            			"			<span class=\"iconfont icon-download\">&#xe619;</span>" +
            			"		</div>" +
            			"	</div>" +
            			"	<div class=\"cContent\">" +
            			"		<div class=\"name\">" +
            			"			<span>:</span>" +
            			"		</div>" +
            			"		<div class=\"content\">" +
            			"			<input type=\"text\" id=\"\" name=\"\" readonly=\"\">" +
            			"		</div>" +
            			"	</div>" +
            			"	<div class=\"cBtn\">" +
            			"		<span></span>" +
            			"	</div>" +
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
                    domHtml.find(".cIcon img").attr("src",iconH5).end()
						.find(".cContent .name span").text(registerName + ":").end()
						.find("input").attr("id","choice_"+registerId).attr("name","choice_"+registerId).attr("data-url",url).end()
						.find(".cBtn span").text($.i18n("weixin.workbench.copy"));
                    $("#cipO .cBlock").append(domHtml);
                }

                $(".cBtn").on("click",function(){
                    var Url2=$(this).prev().find("input");
                    Url2[0].select(); // 选择对象
                    document.execCommand("Copy"); // 执行浏览器复制命令
                    $.alert($.i18n("weixin.workbench.copydone"));
                });
                $("div.download").on("click",function(){
                    var url = $(this).prev().attr("src");
                    //IE
                    var oPop = window.open(url,"","width=1, height=1, top=5000, left=5000");
                    oPop.src = url;
                    for(; oPop.document.readyState !== "complete"; ) {
                        if (oPop.document.readyState === "complete") {
                            break;
                        }
                    }
                    oPop.document.execCommand("SaveAs");
                    oPop.close();
                });
                $(".cIcon").hover(
                    function () {
                        $(this).find(".download").show(100);
                    },
                    function () {
                        $(this).find(".download").hide(100);
                    }
                );
            },
            error: function (rv) {
                $.alert("出错");
            }
        });
    }
</script>
</html>