/**
 * 消息
 */
function UC_MESSAGE(type, jid, name, userjid, username, content, atts, microtalk, isDelete, time,vcard) {
	this.type = type; //消息类型:1单人/2群组
	this.jid = jid; //用户jid或群jid
	this.name = name; //用户名称或群名称
	this.userjid = userjid; //发送者jid
	this.username = username; //发送者姓名
	this.content = content;
	this.atts = atts; //附件
	this.microtalk = microtalk; //语音
	this.isDelete = isDelete; //是否离职
	this.time = time;//发送时间
	this.vcard = vcard;//名片
}

/**
 * 附件消息
 */
function UC_ATTACHMENT(id, name, size) {
	this.id = id;
	this.name = name;
	this.size = size;
}

/**
 * 语音消息
 */
function UC_MICROTALK(id, name, size) {
	this.id = id;
	this.name = name;
	this.size = size;
}

function UC_VCRAD(options) {
	this.name = options.name;//名字
	this.mobliePhone = options.mobliePhone;//移动电话
	this.iphone = options.iphone;//iphone电话
	this.address = options.address;//住宅电话
	this.workPhone = options.workPhone;//工作电话
	this.hPhone = options.hPhone;//主要电话
	this.adPhone = options.adPhone;//住宅传真
	this.workF = options.workF;//工作传真
	this.otherF = options.otherF;//其他传真
	this.ppG = options.ppG;//传呼
	this.other = options.other;//其他
	this.addressMail = options.addressMail;//住宅（email）
	this.workMail = options.workMail;//工作（email）
	this.otherMail = options.otherMail;//其他（email）
}

/**
 * 聊天用户：绑定聊天窗口、消息
 */
function ChatUser(jid) {
	this.jid = jid;
	this.id = Math.floor(Math.random() * 100000000);
	this.name = '';
	this.chatmsgs = new ArrayList();
}

function getElFromArrByProp(arr, prop, str) {
	for ( var i = 0; i < arr.length; i++) {
		if (arr[i][prop] == str) {
			return arr[i];
		}
	}
	return null;
}

function getChatUserByJID(jid) {
	return getElFromArrByProp(this.chatusers, "jid", jid);
}

function ChatUserAdd(jid) {
	var user = new ChatUser(jid);
	this.chatusers = this.chatusers.concat(user);
	return user;
}

/**
 * 缓存聊天用户
 */
function Roster() {
	this.chatusers = new Array();
	this.addChatUser = ChatUserAdd;
	this.getChatUserByJID = getChatUserByJID;
	
	this.DisabledChatUser = new Properties();
	this.DeleteUser = new Properties();
	//添加缓存群组人数和群主jid的map，在聊天窗口显示群成员和群主标示用 youhb 2013年11月1日10:49:23
	this.groupMemberCountCache = new Properties();
	this.groupNickCache = new Properties();
}

/**
 * 打开交流中心
 */
function openExchangeCenter(){
    openWinUC("a8", "msg");
    $('.uc_container').hide();
    $('.uc_iframe').hide();
}

/**
 * 忽略全部
 */
function ignoreAll(){
    msgProperties.clear();
    $('#ucMsg_point').hide();
    getCtpTop().standardTitleFun();
    $('.uc_container').hide();
    $('.uc_iframe').hide();
}

/**
 * 查看全部
 */
function viewAll(){
	try{
		if (msgProperties.size() > 0) { 
			openWinIM("all", "all");
		    ignoreAll();
		}
	}catch(e){ 
		
	}
}

/**
 * 忽略
 */
function ignoreOne(key){
    msgProperties.remove(key);
    if ( msgProperties.size() <= 0 ) {
        $('#ucMsg_point').hide();
        getCtpTop().standardTitleFun();
    }
    $('.uc_container').hide();
    $('.uc_iframe').hide();
}

/**
 * 查看
 */
function viewOne(key, name, jid){
    openWinIM(name, jid);
    ignoreOne(key);
}