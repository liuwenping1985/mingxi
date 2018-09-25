function createPanel(options){// 创建获取html对象
    var panelFrame = $("#miniCrad");
    
    var isSelf = cutResource(_CurrentUser_jid) == options.jid;
    var name = options.data.name;
    var photo = options.data.photo;
    if (isSelf) {
        name = _CurrentUser.name;
        photo = _CurrentUser.photo;
    }
    var mood = options.data.mood.escapeHTML();
    var mobile = options.data.mobile == "null" ? "" : options.data.mobile;
    var telephone = options.data.telephone == "null" ? "" : options.data.telephone;
    var email = options.data.email == "null" ? "" : options.data.email;
    
    var content = "<div class='left' style='width:90px;height:139px;margin-top:10px;'><div class='align_center'><span class='people_img relative display_inline-block over_hidden margin_t_5'>" +
    "<img id='memberimg' class='radius' src='" + photo + "' width='72' height='72'><div class='absolute current_state'></div></span></div>" +
    "<div class='align_center font_bold font_size14' title='" + name + "'>" + name.getLimitLength(20,'...') + "</div>" + "</div>" +
    "<form name='peoplecardminiform' id='peoplecardminiform' method='post'><div class='adapt_w font_size12 form_area people_msg' style='_width:240px;'><table cellpadding='0' cellspacing='0' width='100%' class='padding_5 margin_l_10'>" +
    "<tr><td width='100%' colspan='2' class='font_bold' style='font-size:14px;'><label id='org'/><div title='" + options.data.org + "'>" + options.data.org.getLimitLength(32, '...') + "</div></td></tr>" + 
    "<tr><th nowrap='nowrap'>"+$.i18n('uc.message.phone.js')+"：</th><td width='100%'><label id='mobile'/><div title='" + mobile + "'>" + mobile.getLimitLength(32, '...') + "</div></td></tr>" +
    "<tr><th nowrap='nowrap'>"+$.i18n('uc.message.Mobile.js')+"：</th><td><label id='telephone'/><div title='" + telephone + "'>" + telephone.getLimitLength(32, '...') + "</div></td></tr>" +
    "<tr><th nowrap='nowrap'>"+$.i18n('uc.message.email.js')+"：</th><td><label id='email'/><div title='" + email + "'>" + email.getLimitLength(32, '...') + "</div></td></tr>" +
    "<tr><th nowrap='nowrap' valign='top'>"+$.i18n('uc.message.Signature.js')+"：</th><td class='padding_t_5 padding_r_10 word_break_all'><label id='mood'/><div title='" + mood + "'>" + mood.getLimitLength(32, '...') + "<div></td></tr>" + 
    "</table></div></form>";
    
    content += "<ul class='font_size12 align_center card_operate ul_bg clear'>";
    if (!isSelf) {
        content += "<li class='margin_t_5 left'><a class='img-button img-button-change' href='javascript:void(0)' onclick='parent.window.opener.openWinIM(\"" + name + "\", \"" + options.jid + "\")'><em class='ico16 send_msg_16'></em>" + $.i18n('uc.title.sendsms.js') + "</a></li>";
    }
    try {
	    if (isFromA8 && $.ctx.resources.contains("F01_newColl")) {
	        content += "<li class='margin_t_5 left'><a class='img-button img-button-change' href='javascript:void(0)' onclick='sendCollFromUC(\"" + options.data.memberid + "\")'><em class='ico16 send_seeyon_16'></em>" + $.i18n('uc.title.sendcoll.js') + "</a></li>";
	    }
    } catch (e) {
    }
    try {
	    if (isFromA8 && $.ctx.resources.contains("F12_mailcreate") && !$.ctx._emailNotShow) { //$.ctx._emailNotShow变量值取自common_footer.jsp中第113行
	        content += "<li class='margin_t_5 left'><a class='img-button img-button-change' href='javascript:void(0)' onclick='sendMailFromUC(\"" + options.data.email + "\")'><em class='ico16 send_smsg_16'></em>" + $.i18n('uc.title.sendemail.js') + "</a></li>";
	    }
    } catch (e) {
    }
    content += "</ul>";
    
    if (panelFrame.length == 0) {// 如果没有panel,则新建panel;     
        var panel = "<div class='cardmini h100b hidden' id='miniCrad'></div>";
        panelFrame = $(panel);
        panelFrame.append($(content));
        $("body").append(panelFrame);
    }
    else {
        panelFrame.html($(content));
    }
    
    var cardMini = new MxtDialog({
        id: 'dialog_cardMini',
        width: 366,
        height: 184,
        type: 'panel',
        htmlId: "miniCrad",
        top:$("#"+options.id).offset().top + 42,
        left:$("#"+options.id).offset().left + 42,
        shadow: false,
        panelParam: {
            'show': false,
            'margins': false,
            "inside": false
        }
    });
    
    $("#dialog_cardMini").mouseenter(function(){
        pCardMini_type = true;
    }).mouseleave(function(){
        pCardMini_type = false;
        cardMini.close();
    });
    return cardMini;// 返回panel
}

var pCardMini_type = false;//鼠标悬浮在人员卡片上？
function PeopleCardMini(options, obj){
    this.obj = obj;
    var options = $.extend(options, {
        id: obj[0].id
    }, {
        jid: obj.attr("jid")
    });
    var cardMini = createPanel(options);
    this.obj.unbind().bind({
        mouseleave: function(){
            setTimeout(function(){
                if (!pCardMini_type) {
                    cardMini.close();
                }
            }, 100);
        }
    });
}

function sendCollFromUC(id){
    connWin.focus();
    appToColl("peopleCard", id);
    connWin.startActionTitle();
    window.setTimeout("connWin.standardTitleFun()", 5000);
}

function sendMailFromUC(mail){
    connWin.focus();
    sendMail(mail);
    connWin.startActionTitle();
    window.setTimeout("connWin.standardTitleFun()", 5000);
}

//调用人员卡片的方法，之前在main.jsp,im.jsp也需要调用顾迁移youhb
var showPeopleCard_type=false;
function showPeopleCard(obj){
	showPeopleCard_type=true;
	setTimeout(function(){
		if(showPeopleCard_type){
			if ($(obj).attr("jid").indexOf('@group') >= 0) {
				return;
			}
			
			var iq = parent.window.opener.newJSJaCIQ();
			iq.setIQ(null, 'get');
			var query = iq.setQuery('jabber:iq:seeyon:office-auto');
			var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:info:query'});
			var staff = iq.buildNode('staff', {'dataType': 'json'});
			staff.appendChild(iq.buildNode('jid', {'deptid': ''}, $(obj).attr("jid")));
			organization.appendChild(staff);
			query.appendChild(organization);
			connWin.con.send(iq, getPeopleCard, obj);
		}
	},100);
}

function getPeopleCard(iq, obj) {
    var member = initOrgMembers(iq.getNode().getElementsByTagName('staff')).get(0);
    if(member.memberid == '' && member.name == ''){
    	return;
    }
    //如果不是精灵登陆的话就判断下手机号的权限
    if (isFromA8) {
    	$.ajax({
		    type: "POST" , 
		    data: {"memberId" : member.memberid},
		    url : connWin._ctpPath+"/uc/chat.do?method=checkPhone",
		    timeout : 10000,
		    success : function (jessn){
		    	if (jessn == '0') {
		    		member.telephone = "******";
		    		getPeopleCardInfo(member, obj);
		    	} else {
		    		getPeopleCardInfo(member, obj);
		    	}
		    }
		});
    } else {
    	getPeopleCardInfo(member, obj);
    }
}

function getPeopleCardInfo (member, obj) {
	var options = {
	    data: {
	    	memberid:member.memberid,
	        photo: member.photo,
	        name: member.name,
	        org: member.deptname + "-" + member.postname,
	        mobile: member.mobile,
	        telephone: member.telephone,
	        email: member.email,
	        mood: member.mood
	   }
	};
	if(showPeopleCard_type){
	   new PeopleCardMini(options, $(obj));
	}
}
