/**
 * 聊天窗口
 */
var groupNameByChat ='';
var isdelete = false;
var chatInputPox = null;
var keycodes = '';
var messageMap = new Properties();
var scrollHeightMap = new Properties();
var imgArray = new ArrayList();//存放已经选择的图片
var isDeleteTab = false;
function Mxtchat(options){
    this.width = 520;//总体宽度
    if (options == undefined) {
        options = {};
    }
    this.id = options.id != undefined ? options.id : Math.floor(Math.random() * 100000000);
    this.zIndex = 500;
    $('body').css("overflow","hidden");
    this.marginleft = 0;
    if ($('body').width() > this.width) {
        this.marginleft = ($('body').width() - this.width) / 2;
    }
    this.height = $('body').height();//总体高度
    // this.headHeight = 0;//uc中心 title区域 高度
    this.bodyHeight = this.height;//内容区高度
    this.dialogContentHeadHeight = 24;//左侧人员页签高度
    this.dialogBarHeight = 26;//左侧表情、图片bar 高度
    this.dialogTextArea = 64;//左侧发表信息区域高度
    this.dialogBottom = 46;//左侧发送按钮
    this.maxTab = 2; // 控制显示更多按钮显示的数量，如果打开的页签大于这个数量就显示显示更多（影藏）
    this.title = $.i18n('uc.title.js');
    this.numberText1 = $.i18n('uc.message.enter.check1.js');
    this.numberText2 = $.i18n('uc.message.enter.check2.js');
    this.closeTitle = $.i18n('uc.close.js');
    this.sendTitle = $.i18n('uc.message.send.js');
    this.minTitle = $.i18n('uc.tab.minimize.js');
    this.historyTitle = $.i18n('uc.message.record.js');
    this.groupTitle = $.i18n('uc.group.member.js');
    this.defaultLength = 300;
    this.online_msg = $.i18n('uc.message.onlinemessage.js');
    this.owner = $.i18n('uc.message.me.js');
    this.left = options.left != undefined ? options.left : 0;
    this.top = options.top != undefined ? options.top : 0;
    this.fixRight = options.fixRight != undefined ? options.fixRight : 100;
    this.fixBottom = options.fixBottom != undefined ? options.fixBottom : 10;
    this.moreArray = [];//more tab 
    this.currentTabId = null;
    this.tabItems = new ArrayList();
    this.isShowHistory = false;
    this.isGroup = false;
    this.initWindow();
    var self = this;
    $(window).resize(function(){
        self.resizeMxtchat();
    });
    this.dialogtextarea.focus();
    this.addHistoryTab();
    if (this.isShowHistory) {
        this.isShowHistory = false;//在resetTab先要将是否打开历史交流的标示重置，以确保页签的正常显示
        this.setLeftWidth(this.width);
        this.resetTab();
        this.hideHistory(true);
    }
}

/**
 * 初始化div
 */
Mxtchat.prototype.initWindow = function(){
    var htmlStr = "";
    htmlStr += "<div id='" + this.id + "_container 'class='border_all clearfix' style='position:static;'>";
    htmlStr += "<div id='" + this.id + "_content' class='page_color clearfix'>";
    htmlStr += "<div id='" + this.id + "_left' class='padding_l_10 padding_t_10 left clearfix'>";
    htmlStr += "<div id='" + this.id + "_dialogcontent' class='border_all clearfix'>";
    htmlStr += "<div id='" + this.id + "_dialogcontenthead' class='clearfix common_tabs clearfix'><ul id='" + this.id + "_dialogcontentheadul' class='left clearfix' style='padding-left:0px;'></ul></div>";
    htmlStr += "<div id='" + this.id + "_dialogcontentbody' class='clearfix' style='position: relative;'></div>";
    htmlStr += "</div>";
    htmlStr += "<div id='" + this.id + "_dialogbar' class='font_size14 clearfix'></div>";
    htmlStr += "<div id='" + this.id + "_dialogtextarea' contentEditable='true' class='border_all imgLength font_size12 divhref' onclick='clickInputPoxFunction()'></div>";
    htmlStr += "<div id='" + this.id + "_dialogbottom' class='font_size14 clearfix'></div>";
    htmlStr += "</div>";
    htmlStr += "<div id='" + this.id + "_right' class='hidden right  border_l clearfix' >";
    htmlStr += "<div id='" + this.id + "_righthead' class='padding_t_5 padding_b_5 clearfix'>";
    htmlStr += "</div>";
    htmlStr += "<div id='" + this.id + "_rightbody' class='margin_l_10 clearfix'>";
    htmlStr += "<div id='" + this.id + "_rightbodyhead' class='border_lr clearfix common_tabs'><ul id='" + this.id + "_rightbodyheadul' class='left' style='padding-left:0px;'></ul></div>";
    htmlStr += "<div id='" + this.id + "_rightbodybody' class='clearfix'>";
    htmlStr += "<div id='" + this.id + "_historytabbody' class='clearfix hidden'>";
    htmlStr += "<div id='" + this.id + "_historytabbodytop' class='border_all clearfix'></div>";
    htmlStr += "<div id='" + this.id + "_historytabbodybottom' class='clearfix'></div>";
    htmlStr += "</div>";
    htmlStr += "<div id='" + this.id + "_grouptabbody' class='border_all clearfix hidden'></div>";
    htmlStr += "</div>";
    htmlStr += "</div>";
    htmlStr += "</div>";
    htmlStr += "</div>";
    //htmlStr += "<iframe id='" + this.id + "_iframe'></iframe>";
    htmlStr += "</div>";
    $("body").prepend(htmlStr);
    
    this.container = $('#' + this.id + '_container');
    this.content = $('#' + this.id + '_content');
    this.head = $('#' + this.id + '_head');
    this.leftDiv = $('#' + this.id + '_left');
    this.rightDiv = $('#' + this.id + '_right');
    this.iframe = $('#' + this.id + '_iframe');
    
    this.dialogcontent = $('#' + this.id + '_dialogcontent');
    
    this.dialogcontenthead = $('#' + this.id + '_dialogcontenthead');
    this.dialogcontentheadul = $('#' + this.id + '_dialogcontentheadul');
    this.dialogcontentbody = $('#' + this.id + '_dialogcontentbody');
    
    this.dialogbar = $('#' + this.id + '_dialogbar');
    this.dialogtextarea = $('#' + this.id + '_dialogtextarea');
    this.dialogbottom = $('#' + this.id + '_dialogbottom');
    
    this.righthead = $('#' + this.id + '_righthead');
    this.rightbody = $('#' + this.id + '_rightbody');
    
    this.rightbodyhead = $('#' + this.id + '_rightbodyhead');
    this.rightbodyheadul = $('#' + this.id + '_rightbodyheadul');
    
    this.rightbodybody = $('#' + this.id + '_rightbodybody');
    this.grouptabbody = $('#' + this.id + '_grouptabbody');
    this.historytabbody = $('#' + this.id + '_historytabbody');
    
    this.historytabbodytop = $('#' + this.id + '_historytabbodytop');
    this.historytabbodybottom = $('#' + this.id + '_historytabbodybottom');
    
    this.rightbodybottom = $('#' + this.id + 'rightbodybottom');
    
    
    this.setLeftWidth(this.width);
    
    var self = this;
    $('<span id="'+ this.id + '_uc" class="right margin_t_5 margin_r_5 color_blue hand"><em class="ico16 arrow_2_r" style="vertical-align:top;"></em>'+$.i18n('uc.title.into.uc.title.js')+'</span>').click(function(){
        if (connWin) {
            connWin.openWinUC(isFromA8 ? "a8" : "genius", "msg");
        }
    }).appendTo(this.dialogcontenthead);
    $("<input style='border:0px;font-size:14px;' id='" + this.id + "_face' type='button' class='ico16 uc_face16 left margin_t_5 cursor-hand' value='" + $.i18n('uc.message.select.face.js') + "'/>").click(function(){
    	$('#' + self.id + '_dialogtextarea').focus();
    	//关闭已经打开的附件框 youhb 17:37:52
    	$('#ids_close').click();
        if ($('#' + self.id + '_facediv').length == 0) {
            new MxtFace({
                id: self.id + '_facediv',
                'clickFn': function(){
                    self.checkNumber();
                },
                'fixObj': self.id + '_face',
                'target': self.id + '_dialogtextarea',
                sendInputPox:chatInputPox,
                top: $('#' + self.id + '_face').offset().top - 195,
                left: 160,
                isUp: true
            });
        }
        else {
            $('#' + self.id + '_facediv').show();
        }
    }).appendTo(this.dialogbar);
    
    $("<a class='img-button cursor-hand left' style='padding-left:0;margin-top:2px;'><em class='ico16 affix_16 '></em>"+$.i18n('uc.message.select.attachment.js')+"</a>").click(function(){
        $('#imgid_close').click();
        if ($('#' + self.id + '_facediv').length == 0) {
            new UploadChat({
                id: self.id + '_facediv',
                fromid: connWin.jid,
                toid: self.getTab(self.currentTabId).jid,
                toname: self.getTab(self.currentTabId).name,
                iq: connWin,
                tager: $('#' + self.currentTabId + '_ul'),
                scollTarget : $('#' + self.id + '_dialogcontentbody'),
                con: connWin.con,
                isIndex: false,
                fromName: connWin.curUserName,
                'clickFn': function(){
                    self.checkNumber();
                },
                'fixObj': self.id + '_face',
                'target': self.id + '_dialogtextarea',
                top: $('#' + self.id + '_face').offset().top - 175,
                left: 200,
                isUp: true
            });
        }
        else {
            $('#' + self.id + '_facediv').show();
        }
    }).appendTo(this.dialogbar);
    $("<form id=imageFrom><a class='img-button cursor-hand left' style='padding-left:0;margin-top:2px;position:relative'><em class='ico16 insert_pic_16 '></em>"+$.i18n('uc.title.image.js')+"<input id='imgFile' name='imgFile' accept='image/*' style='opacity:0;position:absolute;top:0px;left:0px;width:48px;color:#fff;filter:alpha(opacity=0);' type='file' value='' ></a></form>").change(function () {
    	var imgEle = document.getElementById('imgFile');
    	fnImgChanageByImWindow(imgEle,self);
    }).appendTo(this.dialogbar);
    $("<a class='img-button cursor-hand left ' id='scrollTopClick' style='padding-left:0;margin-top:2px; display: none;'></a>").click(function(){
        if (scrollHeightMap.get(self.getTab(self.currentTabId).jid) != null && typeof(scrollHeightMap.get(self.getTab(self.currentTabId).jid)) != 'undefined') {
        	$("#" + self.id + "_dialogcontentbody").scrollTop(scrollHeightMap.get(self.getTab(self.currentTabId).jid));
        }
    }).appendTo(this.dialogbar);
    $("<a class='img-button cursor-hand left' style='padding-left:0px;margin-top:2px;'id='selectPeople'><em class='ico16 signature_16'></em>" + $.i18n('uc.group.create.js') + "</a>").click(function(){
    	//弹出选人界面先关闭已经打开的附件框和表情框 youhb 17:37:18
    	$('#imgid_close').click();
    	$('#ids_close').click();
    	selectPeopleMax();
    }).appendTo(this.dialogbar);
    $("<a class='img-button cursor-hand right' style='padding-right:0;margin-top:2px;'><em class='ico16 no_through_ico_16 '></em>" + $.i18n('uc.message.record.js') + "</a>").click(function(){
        if (connWin.roster.DisabledChatUser.get(self.getTab(self.currentTabId).jid)) {
        	var MessBox = $.messageBox({
        		'title' : $.i18n('uc.title.systemMessage.js'),
        	    'type': 0,
        	    'msg': $.i18n('uc.group.notinfo.js'),
        	    'ok_fn' : function () { self.closeChat();},
        		'close_fn' : function () { self.closeChat();}
        	});
        }
        else {
        	if (self.isShowHistory == true && $('#' + self.id + '_grouptab').hasClass('current')) {
        		self.historytaba.click();
        	} else {
        		self.showHistory('history');
        	}
        }
    }).appendTo(this.dialogbar);
    $("<a class='img-button cursor-hand right hidden' id='showMembers' style='padding-right:0;margin-top:2px;'><em class='ico16 roster_16 '></em>" + $.i18n('uc.group.member.js') + "</a>").click(function(){
        if(self.getTab(self.currentTabId).jid.indexOf('@group') > 0){
        	if (connWin.roster.DisabledChatUser.get(self.getTab(self.currentTabId).jid)) {
        		var MessBox = $.messageBox({
            		'title' : $.i18n('uc.title.systemMessage.js'),
            	    'type': 0,
            	    'msg': $.i18n('uc.group.notinfo.js'),
            	    'ok_fn' : function () { self.closeChat();},
            		'close_fn' : function () { self.closeChat();}
            	});
        	}
        	else {
        		if (self.isShowHistory == true && $('#' + self.id + '_historytab').hasClass('current')) {
        			self.grouptaba.click();
        		} else {
        			self.showHistory('group');
        		}
        	}
        }
    }).appendTo(this.dialogbar);
    
    $("<span class='left font_size12 margin_t_5 color_gray2'>" + this.numberText1 + "<span id='" + this.id + "_number' class='font_bold' style='color:#414141;'>" + this.defaultLength + "</span>" + this.numberText2 + "<br></span>").appendTo(this.dialogbottom);
    
	$("<a id='"+this.id+"_send' title='" + $.i18n('uc.title.entertitle.js') + "' class='common_button common_button_gray margin_t_10 right common_button_emphasize' style='cursor:pointer;'>"+this.sendTitle+"</a>").click(function(){
		self.sendMessage();
	}).appendTo(this.dialogbottom);
	
	$("<a id='"+this.id+"_close' class='common_button common_button_gray margin_t_10 margin_r_10 right' style='cursor:pointer;'>"+this.closeTitle+"</a>").click(function(){
		self.closeChat();
	}).appendTo(this.dialogbottom);
    
    $("<span class='left margin_l_12' id ='canderD' title='"+$.i18n('uc.message.selectDate.js')+"'><em class='ico16 month_16'></em><span class='margin_l_5 font_size12'><a>"+$.i18n('uc.message.find.js')+"</a></span></span>").click(function(){
    	var defaultStartDate = null;
    	var defaultEndDate = null;
    	var dateValue = $('#showSelectTimes').val();
    	var defaultStartDateStr = dateValue.split('--')[0];
    	var defaultEndDateStr = dateValue.split('--')[1];
    	if(defaultEndDateStr != null && defaultEndDateStr != ''){
    		defaultStartDate = parseDate(defaultStartDateStr);
    		defaultEndDate = parseDate(defaultEndDateStr);
    	}
        var calendarDialog = new MxtDialog({
            id: 'dialog_calendar',
            title: $.i18n('uc.tab.selectDate.js'),
            url: v3x.baseURL + "/apps_res/uc/calendar.jsp",
            width: 430,
            height: 250,
            htmlId: "calendar",
            targetId: "canderD",
            panelParam: {
                'show': false,
                'margins': false,
                "inside": false
            },
            transParams: {
            	'startDate': defaultStartDate,
            	'endDate':defaultEndDate,
            	'startTitle': $.i18n('uc.title.starttime.js'),
            	'endTitle':$.i18n('uc.title.endtime.js')
            },
            buttons: [{
                id: 'checkMember',
                text: $.i18n('uc.button.ok.js'),
                handler: function(){
                    var success = calendarDialog.getReturnValue();
                    var startTime = success.split('&')[0];
                    var end = success.split('&')[1];
                    var startyear = startTime.split('-')[0];
                    var startmounth = startTime.split('-')[1];
                    var startdate = startTime.split('-')[2];
                    var endyear = end.split('-')[0];
                    var endmounth = end.split('-')[1];
                    var enddate = end.split('-')[2];
                    var numStartdate = parseInt(startdate);
                    var numEnddate = parseInt(enddate);
                    if(numStartdate <= 0){
                    	numStartdate = parseInt(startdate.substr(1));
                    }
                    if(numEnddate <= 0){
                    	numEnddate = parseInt(enddate.substr(1));
                    }
                    if (startTime == '') {
                    	$.alert($.i18n('uc.tab.starttime.js'));
                        return;
                    }
                    else 
                        if (end == '') {
                        	$.alert($.i18n('uc.tab.endtime.js'));
                            return;
                        }
                        else 
                            if (parseInt(startyear) > parseInt(endyear)) {
                            	$.alert($.i18n('uc.start2end.js'));
                                return;
                            }
                            else 
                                if (parseInt(startyear) == parseInt(endyear) && parseInt(startmounth) == parseInt(endmounth) && numStartdate > numEnddate) {
                                	$.alert($.i18n('uc.start2end.js'));
                                    return;
                                }
                                else 
                                    if (parseInt(startyear) == parseInt(endyear) && parseInt(startmounth) > parseInt(endmounth)) {
                                    	$.alert($.i18n('uc.start2end.js'));
                                        return;
                                    }
                                    else {
                                        var showTime = startTime + "至" + end;
                                        $('#showSelectTimes').val(showTime);
                                        var mess = "T00:00:00.000000+08:00";
                                        var mes1 = "T23:59:59.999999+08:00";
                                        if (startTime != '') {
                                            startTime = startTime + mess;
                                        }
                                        if (end != '') {
                                            end = end + mes1;
                                        }
                                        getHisMessage(self.getTab(self.currentTabId).jid, startTime, end);
                                        calendarDialog.close();
                                    }
                }
            }, {
                id: 'calen',
                text: $.i18n('uc.button.cancel.js'),
                handler: function(){
                    calendarDialog.close();
                }
            }]
        });
        
    }).appendTo(this.righthead);
    $('<input type="text" id="showSelectTimes" class ="margin_l_5 "  readonly value=""/>').appendTo(this.righthead);
    $("<span id='closees' class='ico16 gray_close_16'></span>").click(function(){
        self.showHistory();
    }).appendTo(this.righthead);
    
    this.dialogtextarea.keydown(function(event){
        if (event.keyCode == 13) {
        	if (event.ctrlKey) {
        		if (v3x.isChrome) {
        			self.dialogtextarea.html("&nbsp;" +self.dialogtextarea.html() + "<div>&nbsp;</div>");
        		} else if (v3x.isMSIE) {
        			self.dialogtextarea.append("<br/>&nbsp;");
        		} else {
        			self.dialogtextarea.append("<br/>");
        		}
        		self.dialogtextarea.focus();
        	} else {
        		self.sendMessage();
        		return false;
        	}
        } 
    });
    
    this.dialogtextarea.keyup(function(event){
        $(this).find("img").each(function(){
        	if (!$(this).attr('fileid') || $(this).attr('fileid') == '') {
        		$(this).after($(this).attr("code")).remove();
        	}
        });
        //谷歌火狐不支持此方法
        try{
        	chatInputPox = document.selection.createRange();
        }catch(e){
        	chatInputPox = null;
        }
        if (event.keyCode == 86) {
            keycodes = $(this).text().length;
        }
        self.checkNumber();
    });
    
}
/*5.1废弃*/
Mxtchat.prototype.resizeMxtchat = function(){
	this.height = $('body').height();//总体高度
	this.bodyHeight = this.height;
	this.resetTab();
    this.setLeftWidthRes(this.width);
    return;
}
Mxtchat.prototype.setLeftWidthRes = function(height){
    this.leftDiv.css({
        'height': this.bodyHeight - 10
    });
    this.dialogcontent.css({
        'height': this.bodyHeight - this.dialogBarHeight - this.dialogTextArea - this.dialogBottom - 25,
        'background': '#fff'
    });
    this.dialogcontentbody.css({
        'height': this.bodyHeight - this.dialogBarHeight - this.dialogTextArea - this.dialogBottom - this.dialogContentHeadHeight - 25,
        'overflow': 'auto',
        'overflow-x': 'hidden'
    });
    
    this.dialogbar.css({
        'height': this.dialogBarHeight
    });
    
    
    this.dialogtextarea.css({
        'height': this.dialogTextArea,
        'background': '#fff',
        'overflow': 'auto',
        'padding': '5px',
        'word-wrap': 'break-word'
    });
    this.dialogbottom.css({
        'height': this.dialogBottom
    });
    
    this.container.css({
        'z-index': this.zIndex,
        'top': this.top,
        'left': this.left,
        'height': this.height
    });
    this.content.css({
        'top': '0px',
        'left': '0px',
        'z-index': 2,
        'height': this.height,
        'margin': "0 auto"
    });
    this.iframe.css({
        'top': '0px',
        'left': '0px',
        'z-index': 1,
        'height': this.height
    });
    
    this.rightDiv.css({
        'width': 275,
        'height': this.bodyHeight,
        'background': '#fafafa',
        'overflow': 'hidden'
    });
    
    this.righthead.css({
        'width': 276,
        'height':20
    });
    this.rightbody.css({
        'width': 251,
        'height': this.bodyHeight - 40,
        'background': '#ffffff'
    });
    
    // this.rightbodyhead.css({
    //     'width': 249,
    //     'height': 24
    // });
    
    this.rightbodybody.css({
        'height': this.bodyHeight - 100
    });
    
    
    this.grouptabbody.css({
        'height': this.bodyHeight - 66,
        'overflow': 'auto'
    });
    this.historytabbody.css({
        'height': this.bodyHeight - 60,
        'overflow': 'hidden'
    });
    
    this.historytabbodytop.css({
        'height': this.bodyHeight - 100,
        'overflow': 'auto'
    });
    this.historytabbodybottom.css({
        'height': 45,
        'background': '#fafafa',
        'overflow': 'hidden'
    });
    
}

Mxtchat.prototype.setLeftWidth = function(_width){
    this.leftDiv.css({
        'width': _width - 10,
        'height': this.bodyHeight - 10
    });
    
    this.dialogcontent.css({
        'width': _width - 22,
        'height': this.bodyHeight - this.dialogBarHeight - this.dialogTextArea - this.dialogBottom - 25,
        'background': '#fff'
    });
    //5.1废弃
    // this.dialogcontenthead.css({
    //     'width': _width - 22,
    //     'height': this.dialogContentHeadHeight,
    //     'overflow': 'hidden'
    // });
    
    
    
    this.dialogcontentbody.css({
        'width': _width - 22,
        'height': this.bodyHeight - this.dialogBarHeight - this.dialogTextArea - this.dialogBottom - this.dialogContentHeadHeight - 25,
        'overflow': 'auto',
        'overflow-x': 'hidden'
    });
    
    this.dialogbar.css({
        'width': _width - 20,
        'height': this.dialogBarHeight
    });
    this.dialogtextarea.css({
        'width': _width - 32,
        'height': this.dialogTextArea,
        'background': '#fff',
        'overflow': 'auto',
        'padding': '5px',
        'word-wrap': 'break-word'
    });
    this.dialogbottom.css({
        'width': _width - 20,
        'height': this.dialogBottom
    });
    
    this.container.css({
        'z-index': this.zIndex,
        'top': this.top,
        'left': this.left,
        'height': this.height
    });
    this.content.css({
        'top': '0px',
        'left': '0px',
        'z-index': 2,
        'width': this.width,
        'height': this.height,
        'margin': "0 auto"
    });
    this.iframe.css({
        'top': '0px',
        'left': '0px',
        'z-index': 1,
        'width': this.width,
        'height': this.height
    });
    
    this.rightDiv.css({
        'width': 275,
        'height': this.bodyHeight,
        'background': '#fafafa',
        'overflow': 'hidden'
    });
    
    this.righthead.css({
        'width': 276,
        'height':20
    });
    this.rightbody.css({
        'width': 251,
        'height': this.bodyHeight - 40,
        'background': '#ffffff'
    });
    
    // this.rightbodyhead.css({
    //     'width': 249,
    //     'height': 24
    // });
    
    this.rightbodybody.css({
        'width': 251,
        'height': this.bodyHeight - 100
    });
    
    
    this.grouptabbody.css({
        'width': 249,
        'height': this.bodyHeight - 66,
        'overflow': 'auto'
    });
    this.historytabbody.css({
        'width': 251,
        'height': this.bodyHeight - 60,
        'overflow': 'hidden'
    });
    
    this.historytabbodytop.css({
        'width': 249,
        'height': this.bodyHeight - 100,
        'overflow': 'auto'
    });
    this.historytabbodybottom.css({
        'width': 251,
        'height': 45,
        'background': '#fafafa',
        'overflow': 'hidden'
    });
    
    
    
    
    
    
}
Mxtchat.prototype.checkNumber = function(){
    var _html = this.dialogtextarea.text();
    var _face = $(".imgLength img").length;
    var newNumber = this.defaultLength - _html.length - _face;
    $('#' + this.id + '_number').html(newNumber);
}
/**
 * 设置是否显示UC中心
 */
Mxtchat.prototype.setUcCenter = function(){
    $('#' + this.id + '_uc').hide();
}

Mxtchat.prototype.setCurrentTab = function(id){
    $('#' + id).click();
}

Mxtchat.prototype.resetTab = function(){
    var self = this;
    var _length = $('#' + this.id + '_dialogcontentheadul li').length;
    if ($('#' + this.id + '_more').size() > 0) {
        _length = _length - 1;
    }
    var _chLength = _length - 4;
    //判断是否打开了历史记录窗口，如果打开了历史记录窗口的话只显示两个页签之后显示更多，否则显示6个页签
    var _moreArrayTemp = [];
    if (_chLength > 0) {
        for (var i = 0; i < _chLength; i++) {
            var _lastli = $('#' + this.id + '_more').prev();
            //防止出现空页签
            if (_lastli.length <= 0) {
                continue;
            }
            var _lastId = _lastli.attr('id');
            var _lastName = _lastli.text();
            if(self.isShowHistory){
            	_moreArrayTemp.push({
                    'id': _lastId,
                    'name': _lastName
                });
            }else{
            	_moreArrayTemp.unshift({
                    'id': _lastId,
                    'name': _lastName
                });
            }
            _lastli.remove();
        }
        _moreArrayTemp.reverse();
        //上边的循环将多余的页签放到了_moreArrayTemp集合中，判断如果_moreArrayTemp集合大于0的话表示应该显示更多页签
        if (_moreArrayTemp.length > 0) {
            $('#' + self.id + '_more').show();
        }
        for (var j = 0; j < this.moreArray.length; j++) {
        	if(self.isShowHistory){
        		_moreArrayTemp.push(this.moreArray[j]);
        	}else{
        		_moreArrayTemp.unshift(this.moreArray[j]);
        	}
        }
        this.moreArray = _moreArrayTemp;
        _moreArrayTemp = [];
        $('#' + this.id + '_morea').menuSimple({
            id: this.id + '_moreItems',
            maxHeight : 300,
            width: 150,
            offsetLeft: -115,
            offsetTop: -5,
            data: this.moreArray
        });
        
        for (var h = 0; h < this.moreArray.length; h++) {
            var item2 = this.moreArray[h];
            $('#' + item2.id).unbind();
            //匿名函数 闭包 内部函数
            (function(obj){
                $('#' + obj.id).click(function(){
                    self.resetChatTab(obj);
                });
            })(item2);
        };
        
            }
    else 
        if (_chLength < 0) {
            _moreArrayTemp = this.moreArray;
            for (var i = 0; i < this.moreArray.length; i++) {
                var item = this.moreArray[i];
                if (item) {
                    if (i < (-1 - _chLength)) {
                        $('#' + this.id + '_more').before("<li id='" + item.id + "' class='left'><a hidefocus='true' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:81px;' title='" + item.name + "'><span class='ico16 send_messages_16 margin_r_5'></span>" + item.name + "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class='ico16 for_close_16'></span></span></span></li>");
                        //匿名函数 闭包 内部函数
                        (function(obj, parself){
                            var _clo = $('#' + obj.id).find('.pageChatTabsClose');
                            $('#' + obj.id).click(function(){
                                if (!isDeleteTab) { 
                                    if (parself.currentTabId != null) {
                                    	scrollHeightMap.put(parself.getTab(parself.currentTabId).jid, $("#" + parself.id + "_dialogcontentbody")[0].scrollHeight);
                                        messageMap.put(parself.getTab(parself.currentTabId).jid, parself.dialogtextarea.html());
                                    }
                                } else {
                                    isDeleteTab = false;
                                }
                                parself.currentTabId = obj.id;
                                if(parself.getTab(parself.currentTabId).jid != _toID){
                                     if (parself.isShowHistory) {
                                    	 parself.isShowHistory = false; //影藏显示记录窗口的时候要先将标示置为false
                                         parself.setLeftWidth(parself.width);
                                         parself.resetTab();
                                         parself.hideHistory(true);
                                     }
                                }
                                if(parself.getTab(parself.currentTabId).jid.indexOf('@group') > 0){
                                	$('#showMembers').show();
                                }else{
                                	$('#showMembers').hide();
                                }
                                var jidNew = parself.getTab(parself.currentTabId).jid;
                                if (messageMap.get(jidNew) != null && typeof(messageMap.get(jidNew)) != 'undefined') {
                                    parself.dialogtextarea.html(messageMap.get(jidNew));
                                } else {
                                    parself.dialogtextarea.html('');
                                }
                                $('#' + obj.id).siblings().removeClass('current');
                                $('#' + obj.id).addClass('current');
                                $('.dialogcontentbody_content').hide();
                                $('#' + obj.id + '_body').show();
                                $('#scrollTopClick').click();
                                parself.dialogtextarea.focus();
                            }).mouseenter(function(){
                                _clo.show();
                            }).mouseleave(function(){
                                _clo.hide();
                            });
                            _clo.click(function(){
                            	parself.currentTabId = obj.id;
                                parself.closeChat();
                            });
                        })(item, self);
                        
                    }
                }
            }
            _moreArrayTemp = this.moreArray;
            //在影藏聊天记录的时候会重新计算页签，把更多下的页签更具显示的长度和页签数量将页签重置，重置时会将更多下的页签放入_moreArrayTemp，更具_moreArrayTemp长度判断是否显示更多
            if (_moreArrayTemp.length <= 0){
                $('#' + this.id + '_more').hide();  
            } else {
                $('#' + this.id + '_more').show();  
            }
            this.moreArray = _moreArrayTemp;
            $('#' + this.id + '_morea').menuSimple({
                id: this.id + '_moreItems',
                maxHeight : 300,
                width: 150,
                offsetLeft: -115,
                offsetTop: -5,
                data: this.moreArray
            });
            
            for (var h = 0; h < this.moreArray.length; h++) {
                var item2 = this.moreArray[h];
                $('#' + item2.id).unbind();
                //匿名函数 闭包 内部函数
                (function(obj){
                    $('#' + obj.id).click(function(){
                        self.resetChatTab(obj);
                    });
                })(item2);
            };
            
                    }
}


Mxtchat.prototype.addSingleTab = function(item){
    if(item.jid != _toID){
    	if (this.isShowHistory) {
            this.isShowHistory = false;//修改是否显示消息记录标示
            this.setLeftWidth(this.width);
            this.resetTab();
            this.hideHistory(true);
    	}
    }
    $('#ids_close').click();
    $('#imgid_close').click();
    clearList();
    if(connWin.roster.DeleteUser.get(item.jid)){
    	$('#'+this.id+'_send').hide();
    }else{
    	$('#'+this.id+'_send').show();
    }
    if(item.jid.indexOf('@group') > 0){
    	$('#showMembers').show();
    	//判断如果打开的是群聊天窗口就从缓存中取群人数，如果取不到就发起请求从服务器获取youhb 2013年11月1日10:51:49
    	var memberCount = connWin.roster.groupMemberCountCache.get(item.jid);
    	if (memberCount != null && typeof(memberCount) != 'undefined') {
    		$('#groupMemberCount').html("&nbsp;(" + memberCount + ")");
    		var groupNicks = connWin.roster.groupNickCache.get(item.jid);
    		if (groupNicks != null && typeof(groupNicks) != 'undefined') {
    			group_nike = groupNicks;
    		}
    	} else {
    		getGorupMember(item.jid);
    	}
    }else{
    	$('#showMembers').hide();
    }
    this.dialogtextarea.focus();
    if (item) {
        this.tabItems.add(item);
        var self = this;
        //add tab
        var _templi = $("<li id='" + item.id + "' class='display_block left'><a hidefocus='true' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:81px;' title='" + item.name + "'><span class='ico16 send_messages_16 margin_r_5'></span>" + item.name + "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose' ><span class='ico16 for_close_16'></span></span></span></li>");
        var _length = $('#' + this.id + '_dialogcontentheadul li').length;
        if (_length == 0) {
            $('#' + this.id + '_dialogcontentheadul').append(_templi);
        }
        else {
        	//判断当前打开的页签是是否等于显示更多的数量，如果等于就插入更多按钮，样式置为hidden
        	var length1 = this.moreArray.length <= 0 ? 4 : 3;
            if (this.moreArray.length <= 0) {
            	if($('#' + this.id + '_more').attr('style') == 'display: none;'){
            		_length = _length - $('#' + this.id + '_more').length;
            	}
            }
            if (_length == length1) {
            	if ($('#' + this.id + '_more').length <= 0) {
            		this.dialogcontentheadul.append("<li id='" + this.id + "_more' style='display:none' class='left'><a hidefocus='true' id='" + this.id + "_morea' class='cursor-hand' style='border:0px;border-right:1px #b6b6b6 solid;width:50px;padding:0;text-align:center;vertical-align:middle;'>更多<span class='ico16 arrow_1_b'></span></a></li>");
            	} 
            }
            //插入页签的时候始终不会打开历史记录窗口，所以这个地方判断如果插入的数量大于6的时候才将多余的放入更多中
            var length = this.moreArray.length <= 0 ? 3 : 2;
            if (_length > length) {
                var _lastli = $('#' + this.id + '_more').prev();
                var _lastId = _lastli.attr('id');
                var _lastName = _lastli.text();
                this.moreArray.unshift({
                    'id': _lastId,
                    'name': _lastName
                });
                _lastli.remove();
                if (this.moreArray.length == 1) {
                	var _lastli2 = $('#' + this.id + '_more').prev().prev();
                	 var _lastId2 = _lastli2.attr('id');
                     var _lastName2 = _lastli2.text();
                     this.moreArray.unshift({
                         'id': _lastId2,
                         'name': _lastName2
                     });
                     _lastli2.remove();
                }
                //在插入之后判断更多集合中的数量是否大于0，如果大于0 则要show更多按钮
                if (this.moreArray.length > 0) {
                    $('#' + this.id + '_more').show();
                }
            }
            $('#' + this.id + '_dialogcontentheadul li:first-child').before(_templi);
        }
        //add content 先隐藏所有内容div
        //修改消息区域自适应 youhb 2013年11月25日16:25:46
        var htmlStr = "";
        htmlStr += "<div id='" + item.id + "_body' class='dialogcontentbody_content hidden'>";
        htmlStr += "<table id='" + item.id + "_ul' class='ucChat_area' border='0' cellpadding='0' cellspacing='0' width='100%' style='table-layout:fixed;'>";
        htmlStr += '<tr class="ucChat_gap">';
        htmlStr += '<td width="60">&nbsp;</td>';
        htmlStr += '<td width="40">&nbsp;</td>';
        htmlStr += '<td>&nbsp;</td>';
        htmlStr += '<td width="40">&nbsp;</td>';
        htmlStr += '<td width="60">&nbsp;</td>';
        htmlStr += '</tr>';
        htmlStr +='</table>';
        htmlStr += "</div>";
        this.dialogcontentbody.append(htmlStr);
        
        //匿名函数 闭包 内部函数
        (function(obj, parself){
            var _clo = $('#' + obj.id).find('.pageChatTabsClose');
            $('#' + obj.id).click(function(){
                if (!isDeleteTab) {
                    if (parself.currentTabId != null) {
                        var jids = parself.getTab(parself.currentTabId).jid;
                        var html = parself.dialogtextarea.html();
                        messageMap.put(jids,html);
                        scrollHeightMap.put(jids,$("#" + parself.id + "_dialogcontentbody")[0].scrollHeight);
                    }
                } else {
                    isDeleteTab = false;
                }
                parself.currentTabId = obj.id;
                if(parself.getTab(parself.currentTabId).jid != _toID){
                	  if (parself.isShowHistory) {
                	       parself.isShowHistory = false;//更改是否显示聊天记录表示
                           parself.setLeftWidth(parself.width);
                           parself.resetTab();
                           parself.hideHistory(true);
                	  }
                }
                if(connWin.roster.DeleteUser.get(parself.getTab(parself.currentTabId).jid)){
                	$('#'+parself.id+'_send').hide();
                }else{
                	$('#'+parself.id+'_send').show();
                }
                $('#ids_close').click();
                $('#imgid_close').click();
                clearList();
                var jidNew = parself.getTab(parself.currentTabId).jid;
                if (messageMap.get(jidNew) != null && typeof(messageMap.get(jidNew)) != 'undefined') {
                    parself.dialogtextarea.html(messageMap.get(jidNew));
                } else {
                    parself.dialogtextarea.html('');
                }
                if (parself.getTab(parself.currentTabId).jid.indexOf('@group') > 0){
            		$('#showMembers').show();
            	}else{
            		$('#showMembers').hide();
            	}
                parself.dialogtextarea.focus();
                $('#' + obj.id).siblings().removeClass('current');
                $('#' + obj.id).addClass('current');
                $('.dialogcontentbody_content').hide();
                $('#' + obj.id + '_body').show();
                $('#scrollTopClick').click();
            }).mouseenter(function(){
                _clo.show();
            }).mouseleave(function(){
                _clo.hide();
            });
            _clo.click(function(){
                if (parself.currentTabId != null) {
                	scrollHeightMap.put(parself.getTab(parself.currentTabId).jid,$("#" + parself.id + "_dialogcontentbody")[0].scrollHeight);
                    messageMap.put(parself.getTab(parself.currentTabId).jid, parself.dialogtextarea.html());
                }
                isDeleteTab = true;
                if (obj.id != null ){
                    messageMap.put(parself.getTab(obj.id).jid,'');
                }
                if (parself.currentTabId == obj.id) {
                    if($('#' + obj.id).prev().length > 0){
                        $('#' + obj.id).prev().click();
                    }else{
                        $('#' + obj.id).next().click();
                    }
                }
                $('#' + obj.id).remove();
                $('#' + obj.id + '_body').remove();
                
                if (parself.moreArray.length != 0) {
                	isdelete = true;
                    parself.resetChatTab(parself.moreArray[0], false);
                    parself.dialogtextarea.focus();
                }
                if (parself.moreArray.length == 0) {
                    $('#' + parself.id + '_more').hide();//删除的时候如果删除的更多下边的页签数为0的时候由原来的remove改成hide
                    $(document).find('li').each(function(){
                    	for(var i = 0; i<parself.tabItems.size(); i++ ){
                    		var id = parself.tabItems.get(i).id;
                    		if($(this).attr('id') == id){
                    			$(this).click();
                    			return;
                    		}
                    	}
                    });
                }
                if(parself.tabItems.size() <= 1){
                	window.close();
                }else{
                	var newItem = parself.getTab(obj.id);
                	parself.tabItems.remove(newItem);
                }
                
                
                
                //parself.currentTabId = obj.id;
                //parself.closeChat();
            });
        })(item, self);
        
        $('#' + item.id).click();
        this.currentTabId = item.id;
        $('#' + this.id + '_morea').menuSimple({
            id: this.id + '_moreItems',
            maxHeight:300,
            width: 150,
            offsetLeft: -115,
            offsetTop: -5,
            data: this.moreArray
        });
        for (var h = 0; h < this.moreArray.length; h++) {
            var item = this.moreArray[h];
            //匿名函数 闭包 内部函数
            (function(obj){
                $('#' + obj.id).click(function(){
                    self.resetChatTab(obj);
                });
            })(item);
        };
        
        
            }
}

/**
 * 重置聊天页签
 */
Mxtchat.prototype.resetChatTab = function(item, isRemove){
    if (isRemove == undefined) 
        isRemove = true;
    var self = this;
    var _id = item.id;
    var _name = item.name;
    
    var arrayTemp = [];
    for (var i = 0; i < this.moreArray.length; i++) {
        var array = this.moreArray[i];
        if (array.id != _id) {
            arrayTemp.push(array);
        }
    };
    if (isRemove) {
        var _lastli = $('#' + this.id + '_more').prev();
        var _lastId = _lastli.attr('id');
        var _lastName = _lastli.text();
        arrayTemp.unshift({
            'id': _lastId,
            'name': _lastName
        });
        _lastli.remove();
    }
    if(!isdelete){
    	 var _firstli = $('#' + this.id + '_dialogcontentheadul li').first();
    	 _firstli.before("<li id='" + _id + "' class='display_block left'><a hidefocus='true' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:81px;' '" + _name + "'><span class='ico16 send_messages_16 margin_r_5'></span>" + _name + "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class='ico16 for_close_16'></span></span></span></li>");
    }else{
    	 var _firstli = $('#' + this.id + '_dialogcontentheadul li').last();
    	 if($('#' + this.id + '_dialogcontentheadul li').last().attr('id')==$('#' + this.id + '_more').attr('id')){
    		_firstli.before("<li id='" + _id + "' class='display_block left'><a hidefocus='true' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:81px;' '" + _name + "'><span class='ico16 send_messages_16 margin_r_5'></span>" + _name + "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class='ico16 for_close_16'></span></span></span></li>");
    	    if(this.moreArray.length == 1){
    	    	$('#' + this.id + '_more').hide();
    	    }
    	  }else{
    	    _firstli.after("<li id='" + _id + "' class='display_block left'><a hidefocus='true' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:81px;' '" + _name + "'><span class='ico16 send_messages_16 margin_r_5'></span>" + _name + "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class='ico16 for_close_16'></span></span></span></li>");
    	  }    
   }
   
    isdelete = false;
    this.moreArray = arrayTemp;
    $('#' + this.id + '_morea').menuSimple({
        id: this.id + '_moreItems',
        maxHeight:300,
        width: 150,
        offsetLeft: -115,
        offsetTop: -5,
        data: this.moreArray
    });
    for (var h = 0; h < this.moreArray.length; h++) {
        var item2 = this.moreArray[h];
        $('#' + item2.id).unbind();
        //匿名函数 闭包 内部函数
        (function(obj){
            $('#' + obj.id).click(function(){
                self.resetChatTab(obj);
            });
        })(item2);
    };
    
    var _clo = $('#' + _id).find('.pageChatTabsClose');
    $('#' + _id).click(function(){
        if (!isDeleteTab) { 
            if (self.currentTabId != null) {
            	scrollHeightMap.put(self.getTab(self.currentTabId).jid, $("#" + self.id + "_dialogcontentbody")[0].scrollHeight);
                messageMap.put(self.getTab(self.currentTabId).jid, self.dialogtextarea.html());
            }
        } else {
            isDeleteTab = false;
        }
        self.currentTabId = _id;
        if(self.getTab(self.currentTabId).jid != _toID){
        	if (self.isShowHistory) {
                self.isShowHistory = false;//修改是否显示消息记录表示
                self.setLeftWidth(self.width);
                self.resetTab();
                self.hideHistory(true);
        	}
        }
        $('#ids_close').click();
        $('#imgid_close').click();
        if(connWin.roster.DeleteUser.get(self.getTab(self.currentTabId).jid)){
        	$('#'+self.id+'_send').hide();
        }else{
        	$('#'+self.id+'_send').show();
        }
        var jidNew = self.getTab(self.currentTabId).jid;
        if (messageMap.get(jidNew) != null && typeof(messageMap.get(jidNew)) != 'undefined') {
            self.dialogtextarea.html(messageMap.get(jidNew));
        } else {
            self.dialogtextarea.html('');
        }
        clearList();
        if (self.getTab(self.currentTabId).jid.indexOf('@group') > 0) {
        	$('#showMembers').show();
        }else{
        	$('#showMembers').hide();
        }
        $(this).siblings().removeClass('current');
        $(this).addClass('current');
        $('.dialogcontentbody_content').hide();
        $('#' + _id + '_body').show();
        $('#scrollTopClick').click();
        self.dialogtextarea.focus();
    }).mouseenter(function(){
        _clo.show();
    }).mouseleave(function(){
        _clo.hide();
    });
    _clo.click(function(){
        isDeleteTab = true;
        if (self.currentTabId != null ) {
        	scrollHeightMap.put(self.getTab(self.currentTabId).jid,$("#" + self.id + "_dialogcontentbody")[0].scrollHeight);
            messageMap.put(self.getTab(self.currentTabId).jid,self.dialogtextarea.html());
        }
        if (_id != null) {
            messageMap.put(self.getTab(_id).jid,'');
        }
        if (self.currentTabId == _id) {
        	if($('#' + _id).prev().length > 0){
        		$('#' + _id).prev().click();
        	}else{
        		$('#' + _id).next().click();
        	}
        }
        $('#' + _id).remove();
        $('#' + _id + '_body').remove();
        //在删除的时候如果更多集合下的数量不为0的时候表示更多下还有页签，就将更多里边的第一个放到更多前边
        if (self.moreArray.length != 0) {
            isdelete = true;
            self.resetChatTab(self.moreArray[0], false);
        }
        //如果更多里边的集合数等于0的时候表示更多下没有页签，则激活第一个页签隐藏更多页签
        if (self.moreArray.length == 0) {
            $('#' + self.id + '_more').hide();
            $(document).find('li').each(function(){
            for(var i = 0; i<self.tabItems.size(); i++ ){
                var id = self.tabItems.get(i).id;
                if($(this).attr('id') == id){
                    $(this).click();
                    return;
                }
            }
             });
         }
         //删除掉当前的页数据
        var item = self.getTab(_id);
        self.tabItems.remove(item);
        if (item) {
        	//页签关闭的时候判断，先remove的，所以这个地方应该判断条件改成<1
            if (self.tabItems.size() < 1) {
                window.close();
            }
        }
    });
    
    if (isRemove) {
        $('#' + _id).click();
    }
    if (this.isShowHistory) {
    	this.isShowHistory = false;//修改是否显示历史记录标示
        this.setLeftWidth(this.width);
        this.resetTab();
        this.hideHistory(true);
    }
}

Mxtchat.prototype.getTab = function(id){
    for (var i = 0; i < this.tabItems.size(); i++) {
        var tab = this.tabItems.get(i);
        if (tab.id == id) {
            return tab;
        }
    }
}

/**
 * 显示聊天记录
 */
Mxtchat.prototype.showHistory = function(clickFous){
    if (!this.isShowHistory) {
        this.isShowHistory = true;
        this.content.width(800);
        window.resizeBy(280,0)
        this.resetTab();
        jid = this.getTab(this.currentTabId).jid;
        if (jid.indexOf('@group') >= 0) {
            this.isGroup = true;
            //在打开聊天记录窗口的时候判断是否是群，如果是就将缓存中的群成员数量重新显示到对应位置 youhb 2013年11月1日 10:56:39
            var count = connWin.roster.groupMemberCountCache.get(jid);
            if (count != null && typeof(count) != 'undefined') {
            	$('#groupMemberCount').html("&nbsp;(" + count + ")");
            }
            var groupnike = connWin.roster.groupNickCache.get(jid);
            if (groupnike != null &&  typeof(groupnike) != 'undefined') {
            	group_nike = groupnike;
            }
        }
        if (!this.isGroup) {
            this.grouptabbody.hide();
        }
        this.setGroup(clickFous);
        this.rightDiv.removeClass('hidden');
        this.isGroup = false;
        var showDate = new Date().getFullYear() + '-' + (new Date().getMonth() + 1) + '-' + new Date().getDate();
        $('#showSelectTimes').val('');
    }
    else {
        this.isShowHistory = false;//修改是否显示历史记录标示
        this.setLeftWidth(this.width);
        this.resetTab();
        this.hideHistory(true);
    }
    
}
/**
 * 设置群成员
 */
Mxtchat.prototype.setGroup = function(clickFous){
    if (this.isGroup) {
        $('#' + this.id + '_historytaba').css({
            'width': 112,
            'max-width': 112
        });
        
        $('#' + this.id + '_grouptab').css({
            'display': ''
        });
        if (clickFous == 'group') {
        	this.grouptaba.click();
        } else {
        	this.historytaba.click();
        }
    }
    else {
        $('#' + this.id + '_historytaba').css({
            'width': 233,
            'max-width': 233
        });
        $('#' + this.id + '_grouptab').css({
            'display': 'none'
        });
        this.historytaba.click();
    }
}
/**
 * 隐藏聊天记录
 */
Mxtchat.prototype.hideHistory = function(b){
    this.isShowHistory = false;
    this.rightDiv.addClass('hidden');
    if (b == true) {
        window.resizeBy(-280,0)
    };
}
/**
 * 设置聊天信息
 */
Mxtchat.prototype.setMessage = function(){

}
/**
 * 获取聊天信息
 */
Mxtchat.prototype.getMessage = function(){

}

/**
 * 发送消息
 */
var alertObj = true;
Mxtchat.prototype.sendMessage = function(){
    if (connWin.roster.DisabledChatUser.get(this.getTab(this.currentTabId).jid)) {
    	var self = this;
    	var MessBox = $.messageBox({
    		'title' : $.i18n('uc.title.systemMessage.js'),
    	    'type': 0,
    	    'imgType' :2,
    	    'msg': $.i18n('uc.group.notinfo.js'),
    	    'ok_fn' : function () { self.closeChat();},
    		'close_fn' : function () { self.closeChat();}
    	});
        $("#" + this.id + "_number").text(this.defaultLength);
        this.dialogtextarea.empty().focus();
        return;
    }
    var _oldHtml = this.dialogtextarea.html();
    var _text = $.trim(this.dialogtextarea.text());
    var _img = this.dialogtextarea.find('img');
    this.dialogtextarea.find('img').each(function () {
    	if ($(this).attr('fileid') && $(this).attr('fileid') != '') {
    		var item ={
    			'id':$(this).attr('fileid'),
    			'path':$(this).attr('fname'),
    			'src':$(this).attr('src')
    		}
    		imgArray.add(item);
    		$(this).remove();
    	}
    });
    if (_text.length == 0 && _img.size() == 0) {
        return;
    }
    //QQ复制图片会变成<div>
    this.dialogtextarea.html(this.dialogtextarea.html().replace(new RegExp('<!--StartFragment -->', 'g'), ''));
    this.dialogtextarea.html(this.dialogtextarea.html().replace(new RegExp('<div>', 'g'), '<br/>'));
    this.dialogtextarea.html(this.dialogtextarea.html().replace(new RegExp('</div>', 'g'), ''));
    this.dialogtextarea.html(this.dialogtextarea.html().replace(new RegExp('\n', 'g'), ''));
    
    while(true){
        if (this.dialogtextarea.html().indexOf('<br/>') == 0){
            this.dialogtextarea.html(this.dialogtextarea.html().subStr(5));
        } else {
            break;
        }
    }
    while(true){
        if (this.dialogtextarea.html().indexOf('<p/>') == 0){
            this.dialogtextarea.html(this.dialogtextarea.html().subStr(4));
        } else {
            break;
        }
    }
    
    this.dialogtextarea.find('br').each(function(){
    	$(this).replaceWith($(this).html() + '\n');
    });
    
    this.dialogtextarea.find("p").each(function(i){
        if ($.trim($(this).text()) == '') {
            $(this).remove();
        } else {
            $(this).replaceWith($(this).html() + '\n');
        }
    });
    
    this.dialogtextarea.find("div").each(function(i){
        if ($.trim($(this).text()) == '') {
            $(this).remove();
        } else {
            $(this).replaceWith($(this).html() + '\n');
        }
    });
    
    this.dialogtextarea.find('img').each(function(){
        $(this).after($(this).attr('code')).remove();
    });
    
    var _content = this.dialogtextarea.text();
    var _html = _content.escapeHTML();
    var textLength = 0;
    if (keycodes != null && keycodes != '') {
    	 if (_content.length < keycodes) {
             textLength = _content.length;
         } else {
             textLength = keycodes;
         }
         keycodes = '';
    } else {
        textLength = _content.length;
    }
    var reg=new RegExp("\n","g"); 
    var text = _content.replace(reg, '');
    if(text.length > 300){
    	if (!alertObj) {
    		return ;
    	}
    	alertObj = false;
        var random = $.messageBox({
            'type': 0,
            'msg': $.i18n('uc.titleText.js'),
            ok_fn: function () {
            	alertObj = true;
            },
            close_fn : function () {
            	alertObj = true;
            }
        });
    	this.dialogtextarea.html(_oldHtml);
    	return ;
    }
    if (sendImg($('#' + this.currentTabId + '_ul'),this.getTab(this.currentTabId).jid, this.getTab(this.currentTabId).name)) {
        if (_content == '' || _content.trim() == '\n' || _content.replace(/\s+/g,"").length <= 0) {
            try {
                var scrollTop = $("#" + this.id + "_dialogcontentbody")[0].scrollHeight - $("#" + this.id + "_dialogcontentbody").height();
                if (scrollTop > 50) {
                    $("#" + this.id + "_dialogcontentbody").scrollTop(scrollTop);
                }
            } 
            catch (e) {
            }
        	return;
        }
        var htmlStr = "";
        for (var j = 0; j < face_texts_replace.length; j++) {
            _html = _html.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' code='"+face_texts_replace[j].toString().substr(2,face_texts_replace[j].toString().length -6)+"]'/>");
        }
        //聊天内容url提取 youhb 2013年11月4日14:37:14
        _html = replaceRegUrl(_html);
        //修改消息区域自适应 youhb 2013年11月25日16:25:46
        htmlStr += "<tr class='ucChat_right'>";
        htmlStr += "<td colspan='2'></td>";
        htmlStr += "<td colspan='2'>";
        htmlStr += "<span class='right'><span class='ucChat_arrow'><span></span></span><span class='ucChat_close hidden'><span class='ico16 for_close_16'></span></span></span>";
        htmlStr += "<div class='ucChat_content'>";
        htmlStr += "<span class='color_gray2'>" + $.i18n('uc.titleMy.js') + "&nbsp;</span><span class='font_size12 color_gray2'>今天:" + parseDateTime() + "</span><br />";
        htmlStr += "<p class='margin_l_5' style='word-wrap: break-word;'>"+ _html +"</p></div></td>";
        htmlStr += "<td align='right' valign='top'>";
        htmlStr += "<img class='ucChat_pic' src='" + connWin.curUserPhoto + "'/>";
        htmlStr += "</td></tr>";
        htmlStr += "<tr class='ucChat_gap'><td colspan='5'></td></tr>";
        $('#' + this.currentTabId + '_ul').append(htmlStr);
        
        try {
            var scrollTop = $("#" + this.id + "_dialogcontentbody")[0].scrollHeight - $("#" + this.id + "_dialogcontentbody").height();
            if (scrollTop > 50) {
                $("#" + this.id + "_dialogcontentbody").scrollTop(scrollTop);
            }
        } 
        catch (e) {
        }
        
        $("#" + this.id + "_number").text(this.defaultLength);
        this.dialogtextarea.html("");
        this.dialogtextarea.focus();
        submitClicked(this.getTab(this.currentTabId).jid, this.getTab(this.currentTabId).name, _content);
    }
};

/**
 * 发送消息
 */
Mxtchat.prototype.closeChat = function(){
	isDeleteTab = true;
	var isClick = false;
    if ($('#' + this.id + '_dialogcontentheadul li').length == 1) {
        window.close();
        return;
    }
    
    var _id = this.currentTabId;
    var item = this.getTab(_id);
    if (item) {
        if (this.tabItems.size() <= 1) {
            window.close();
        } else {
            this.tabItems.remove(item);
        }
    }
    if ($('#' + _id).next().length > 0) {
    	if($('#' + _id).next().attr('id').indexOf('_more') >= 0){
    		$('#' + _id).prev().click();
    		isClick = true ;
    	}else{
    		$('#' + _id).next().click();
    		isClick = true ;
    	}
    }
    else 
        if ($('#' + _id).prev().length > 0) {
            $('#' + _id).prev().click();
            isClick = true ;
        }
    
    $('#' + _id).remove();
    $('#' + _id + '_body').remove();
	//删除的时候判断更多页签的显示并删除页签的数据
    if (this.moreArray.length != 0) {
        isdelete = true;
        this.resetChatTab(this.moreArray[0], false);
    }
    if (this.moreArray.length == 0) {
        $('#' + this.id + '_more').hide();
        if (!isClick) {
            $(document).find('li').each(function(){
                for(var i = 0; i<this.tabItems.size(); i++ ){
                    var id = this.tabItems.get(i).id;
                    if($(this).attr('id') == id){
                        $(this).click();
                        return;
                    }
                }
            });
        }
    }
};

/**
 * 添加聊天历史记录
 */
Mxtchat.prototype.addHistoryTab = function(){
	//添加groupMemberCount span 用于显示群组成员人数 youhb 2013年11月4日14:37:49
    this.rightbodyheadul.append("<li id='" + this.id + "_grouptab' style='display:none'><a hidefocus='true' id='" + this.id + "_grouptaba' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:105px;max-width:105px;text-align:center'>" + this.groupTitle + "<span id='groupMemberCount'></span></a></li>");
    this.rightbodyheadul.append("<li id='" + this.id + "_historytab'><a hidefocus='true' id='" + this.id + "_historytaba' class='cursor-hand' style='border-top:0px;border-left:0px;border-bottom:0px;width:117px;max-width:117px;text-align:center'>" + this.historyTitle + "</a></li>");
    
    this.grouptaba = $('#' + this.id + '_grouptaba');
    this.historytaba = $('#' + this.id + '_historytaba');
    
    var self = this;
    this.grouptaba.click(function(){
    	$('#showSelectTimes').hide();
    	$('#canderD').hide();
    	$('#closees').addClass('right margin_r_15 margin_t_5');
        self.grouptabbody.show();
        self.historytabbody.hide();
        //群主信息做了缓存，请求群成员的时候去掉不必要的请求信息，减少性能消耗  youhb 2013年11月4日14:40:26
        getGroupInfoMember(self.getTab(self.currentTabId).jid);
        self.isGroup = false;
        $('#' + self.id + '_grouptab').removeClass('current');
        $('#' + self.id + '_historytab').removeClass('current');
        $('#' + self.id + '_grouptab').addClass('current');
        
    });
    this.historytaba.click(function(){
    	$('#closees').removeClass('right margin_r_15 margin_t_5');
        $('#showSelectTimes').val('');
    	$('#showSelectTimes').show();
    	$('#canderD').show();
        getHisMessage(self.getTab(self.currentTabId).jid, '', '');
        self.grouptabbody.hide();
        self.historytabbody.show();
        $('#' + self.id + '_grouptab').removeClass('current');
        $('#' + self.id + '_historytab').removeClass('current');
        $('#' + self.id + '_historytab').addClass('current');
    });
    
}


function selectPeopleMax(){
    try {
        var dialog = new MxtDialog({
            id: 'UC_SelectPeople',
            title: $.i18n('uc.group.create.js'),
            url: v3x.baseURL + '/uc/chat.do?method=selectPeople&from=' + (isFromA8 ? 'a8' : 'genius'),
            width: 500,
            height: 450,
            targetWindow: getA8Top(),
            transParams: {
                showName: true
            },
            buttons: [{
                text: $.i18n('uc.button.ok.js'),
                handler: function(){
                    var result = dialog.getReturnValue();
                    if (result != null) {
                        var groupname = result.name;
                        var groupMemberList = new Array();
                        for (var i = 0; i < result.data.length; i++) {
                            var data = result.data[i];
                            groupMemberList[i] = data.source;
                        }
                        if (groupMemberList.length < 100) {
                        	 createChickPP(groupname, groupMemberList);
                             dialog.close();
                        } else {
                        	alert($.i18n('uc.group.membermax.js'));
                        }
                       
                    }
                }
            }, {
                text: $.i18n('uc.button.cancel.js'),
                handler: function(){
                    dialog.close();
                }
            }]
        });
    } 
    catch (e) {
    }
}

function cacheTeamMemberInfoByChat(iq){

}

function createChickPP(groupName, toMemberList){
    var iqsend = connWin.newJSJaCIQ();
    var uids = connWin.jid;
    iqsend.setFrom(uids);
    iqsend.setIQ('group.localhost', 'get', 'group1');
    var query1 = iqsend.setQuery('seeyon:group:create');
    var groupInfo = iqsend.buildNode('group_info');
    groupInfo.appendChild(iqsend.buildNode('group_name', '', groupName));
    groupInfo.appendChild(iqsend.buildNode('group_type', '', '4'));
    
    var members = iqsend.buildNode('group_members');
    members.appendChild(iqsend.buildNode('group_member', '', uids.replace('/jwchat', '')));
    var isIncludeMe = false;
    for (var j = 0; j < toMemberList.length; j++) {
        if (toMemberList[j] != uids) {
            members.appendChild(iqsend.buildNode('group_member', '', toMemberList[j]));
        }
        else {
            isIncludeMe = true;
        }
    }
    if (isIncludeMe) {
        groupInfo.appendChild(iqsend.buildNode('group_member_num', '', toMemberList.length));
    }
    else {
        groupInfo.appendChild(iqsend.buildNode('group_member_num', '', toMemberList.length + 1));
    }
    groupInfo.appendChild(members);
    query1.appendChild(groupInfo);
    connWin.con.send(iqsend, checkGrouplist);
}

function checkGrouplist(iq){
    if (!iq || iq.getType() != 'result') {
    	$.alert($.i18n('uc.group.Notcreate.js'));
    }
    else {
        var gid = iq.getNode().getElementsByTagName('group_info')[0].getAttribute('I');
        var gname = iq.getNode().getElementsByTagName('group_info')[0].getAttribute('NA');
        connWin.openWinIM(gname, gid);
    }
}
function clickInputPoxFunction(){
	try{
		//ie11谷歌火狐不支持此方法
		chatInputPox = document.selection.createRange();
	}catch(e){
		chatInputPox = null;
	}
}

//url替换youhb 2013年11月4日11:29:20
function replaceRegUrl(str){ 
	var reg = /((https|http|ftp|file|news):\/\/[-a-zA-Z0-9+\/%:,.;]+)/g;
	return str.replace(reg,function(m){return "<a href='javaScript:openUrl(\"" + m + "\")'>"+m+"</a>";}) 
}

function openUrl(url) {
    window.open(url,'_blank');
}

function fnImgChanageByImWindow(obj,_self) {
	var option = {
			'element':obj,
			'connWin':connWin,
			'tagger':_self
	}
	startProcs("");
	fnImgChanage(option);
}

function sendImg (tigger,tojid,toName) {
	var imageMap = new Properties();
	for (var i = 0 ; i < imgArray.size() ; i ++) {
		if (!imageMap.get(imgArray.get(i).id)) {
			var random = Math.floor(Math.random() * 100000000);
			queryShowImgPath(imgArray.get(i).id,random);
			var fname =  getFileName(imgArray.get(i).path);
			var _type = 'image';
			var htmlStr = "";
			var _html = "<img src='' id='"+random+"_img' fid='"+imgArray.get(i).id+"' fname='"+imgArray.get(i).path+"' class='maxHeight_300'  ondblclick='showImgFile(this)'/>";
			htmlStr += "<tr class='ucChat_right'>";
		    htmlStr += "<td colspan='2'></td>";
		    htmlStr += "<td colspan='2'>";
		    htmlStr += "<span class='right'><span class='ucChat_arrow'><span></span></span><span class='ucChat_close hidden'><span class='ico16 for_close_16'></span></span></span>";
		    htmlStr += "<div class='ucChat_content'>";
		    htmlStr += "<span class='color_gray2'>" + $.i18n('uc.titleMy.js') + "&nbsp;</span><span class='font_size12 color_gray2'>今天:" + parseDateTime() + "</span><br />";
		    htmlStr += "<p class='margin_l_5' style='word-wrap: break-word;'><table width='100%' height='100%''><tr><td align='center'>"+_html+"</td></tr><tr><td align='right'><a onclick='downLoadFile(\"" + imgArray.get(i).id + "\", \"" + fname + "\", \"" + _type + "\")'>"+$.i18n('uc.title.sava.js')+"</a></td></td></table></p></div></td>";
		    htmlStr += "<td align='right' valign='top'>";
		    htmlStr += "<img class='ucChat_pic' src='" + connWin.curUserPhoto + "'/>";
		    htmlStr += "</td></tr>";
		    htmlStr += "<tr class='ucChat_gap'><td colspan='5'></td></tr>";
		    tigger.append(htmlStr);
			var aMessage = connWin.newJSJaCMessage();
			aMessage.setFrom(connWin.jid);
			aMessage.setName(fromName);
			aMessage.setTo(tojid);
			aMessage.setType('image');
			aMessage.setName(connWin.curUserName);
			aMessage.appendNode(aMessage.buildNode('toname',toName));
			var fileName = getFileName(imgArray.get(i).path);
			var filetrans =  aMessage.buildNode('image',{ 'xmlns':'image'});
			filetrans.appendChild(aMessage.buildNode('id',imgArray.get(i).id));
			filetrans.appendChild(aMessage.buildNode('id_thumbnail',imgArray.get(i).id+"_1"));
			filetrans.appendChild(aMessage.buildNode('name',fileName));
			filetrans.appendChild(aMessage.buildNode('size',1024));
			filetrans.appendChild(aMessage.buildNode('hash',imgArray.get(i).id));
			filetrans.appendChild(aMessage.buildNode('date',new Date()));
			aMessage.appendNode(filetrans);
			connWin.con.send(aMessage);
			imageMap.put(imgArray.get(i).id,true);
		}
	}
	imgArray = new ArrayList();
	return true;
}

function showImgFile(obj) {
	var fileId = obj.getAttribute('fid');
	var fname = getFileName(obj.getAttribute('fname'));
	var dialog = $.dialog({
	    id: 'showImg',
	    url: v3x.baseURL + '/uc/chat.do?method=showImg&fileId='+fileId+'&fname='+fname,
	    top:10,
	    width: 500,
	    height: 450,
	    title: '图片查看'
	});
}




var commonProgressbar = null;
function startProcs(title){
    try {
        var options = {
            text: title
        };
        if (title == undefined) {
            options = {};
        }
        if (commonProgressbar != null) {
            commonProgressbar.start();
        } else {
            commonProgressbar = new MxtProgressBar(options);
        }
    } catch (e) {
    }
}
//结束进度条
function endProcs(){
    try {
        if (commonProgressbar) {
            commonProgressbar.close();
        }
        commonProgressbar = null;
    } catch (e) {
    }
}