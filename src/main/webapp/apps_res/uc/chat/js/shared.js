//开始进度条
var commonProgressbar = null;
function startProc(title, autoStop){
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
        
        //如果有异常，20秒自动结束
        if (!autoStop) {
        	setTimeout("endProc()", 20000);
        }
    } catch (e) {}
}

// 结束进度条
function endProc(){
    try {
        if (commonProgressbar) {
        	commonProgressbar.close();
        }
        commonProgressbar = null;
    } catch (e) {}
}

function getArgs(){
  passedArgs=new Array();
  search = self.location.href;
  search = search.split('?');
  if(search.length>1){
    argList = search[1];
    argList = argList.split('&');
    for(var i=0; i<argList.length; i++){
      newArg = argList[i];
      newArg = argList[i].split('=');
      passedArgs[decodeURIComponent(newArg[0])] = decodeURIComponent(newArg[1]);
    }
  }
  return passedArgs;
}

function cutResource(aJID) { // removes resource from a given jid
  if (typeof(aJID) == 'undefined' || !aJID)
    return;
  var retval = aJID;
  if (retval.indexOf("/") != -1)
    retval = retval.substring(0,retval.indexOf("/"));
  return retval;
}

function msgEscape(msg) {
  if (typeof(msg) == 'undefined' || !msg || msg == '')
    return;

  msg = msg.replace(/%/g,"%25"); // must be done first

  msg = msg.replace(/\n/g,"%0A");
  msg = msg.replace(/\r/g,"%0D");
  msg = msg.replace(/ /g,"%20");
  msg = msg.replace(/\"/g,"%22");
  msg = msg.replace(/#/g,"%23");
  msg = msg.replace(/\$/g,"%24");
  msg = msg.replace(/&/g,"%26");
  msg = msg.replace(/\(/g,"%28");
  msg = msg.replace(/\)/g,"%29");
  msg = msg.replace(/\+/g,"%2B");
  msg = msg.replace(/,/g,"%2C");
  msg = msg.replace(/\//g,"%2F");
  msg = msg.replace(/\:/g,"%3A");
  msg = msg.replace(/\;/g,"%3B");
  msg = msg.replace(/</g,"%3C");
  msg = msg.replace(/=/g,"%3D");
  msg = msg.replace(/>/g,"%3E");
  msg = msg.replace(/@/g,"%40");

  return msg;
}

// fucking IE is too stupid for window names
function makeWindowName(wName) {
  wName = wName.replace(/@/,"at");
  wName = wName.replace(/\./g,"dot");
  wName = wName.replace(/\//g,"slash");
  wName = wName.replace(/&/g,"amp");
  wName = wName.replace(/\'/g,"tick");
  wName = wName.replace(/=/g,"equals");
  wName = wName.replace(/#/g,"pound");
  wName = wName.replace(/:/g,"colon");	
  wName = wName.replace(/%/g,"percent");
  wName = wName.replace(/-/g,"dash");
  wName = wName.replace(/ /g,"blank");
  wName = wName.replace(/\*/g,"asterix");
  return wName;
}

function htmlEnc(str) {
  if (!str)
    return '';

  str = str.replace(/&/g,"&amp;");
  str = str.replace(/</g,"&lt;");
  str = str.replace(/>/g,"&gt;");
  str = str.replace(/\"/g,"&quot;");
  return str;
}

function msgFormat(msg) { // replaces emoticons and urls in a message
  if (!msg)
    return null;

  msg = htmlEnc(msg);

  if (typeof(emoticons) != 'undefined') {
    for (var i in emoticons) {
			if (!emoticons.hasOwnProperty(i))
				continue;
      var iq = i.replace(/\\/g, '');
      var emo = new Image();
      emo.src = emoticonpath+emoticons[i];
      if (emo.width > 0 && emo.height > 0)
	msg = msg.replace(eval("/\(\\s\|\^\)"+i+"\(\\s|\$\)/g"),"$1<img src=\""+emo.src+"\" width='"+emo.width+"' height='"+emo.height+"' alt=\""+iq+"\" title=\""+iq+"\">$2");
      else
	msg = msg.replace(eval("/\(\\s\|\^\)"+i+"\(\\s|\$\)/g"),"$1<img src=\""+emo.src+"\" alt=\""+iq+"\" title=\""+iq+"\">$2");
    }
  }
	
  // replace http://<url>
  msg = msg.replace(/(\s|^)(https?:\/\/\S+)/gi,"$1<a href=\"$2\" target=\"_blank\">$2</a>");
  
  // replace ftp://<url>
  msg = msg.replace(/(\s|^)(ftp:\/\/\S+)/gi,"$1<a href=\"$2\" target=\"_blank\">$2</a>");
  
  // replace mail-links
  msg = msg.replace(/(\s|^)(\w+\@\S+\.\S+)/g,"$1<a href=\"mailto:$2\">$2</a>");
  
  // replace *<pattern>*
  msg = msg.replace(/(\s|^)\*([^\*\r\n]+)\*/g,"$1<b>\$2\</b>");
  
  // replace _bla_
  msg = msg.replace(/(\s|^)\_([^\*\r\n]+)\_/g,"$1<u>$2</u>");

  msg = msg.replace(/\n/g,"<br>");

  return msg;
}

/*
 * isValidJID checks whether jid is valid
 */
var prohibited = ['"',' ','&','\'','/',':','<','>','@']; // invalid chars
function isValidJID(jid) {
  var nodeprep = jid.substring(0,jid.lastIndexOf('@')); // node name (string
														// before the @)

  for (var i=0; i<prohibited.length; i++) {
    if (nodeprep.indexOf(prohibited[i]) != -1) {
      alert("Invalid JID\n'"+prohibited[i]+"' not allowed in JID.\nChoose another one!");
      return false;
    }
  }
  return true;
}

/*
 * jab2date converts from jabber timestamps to javascript date objects
 */
function jab2date(ts) {
  var date = new Date(Date.UTC(ts.substr(0,4),ts.substr(5,2)-1,ts.substr(8,2),ts.substr(11,2),ts.substr(14,2),ts.substr(17,2)));
  if (ts.substr(ts.length-6,1) != 'Z') { // there's an offset
    var offset = new Date();
    offset.setTime(0);
    offset.setUTCHours(ts.substr(ts.length-5,2));
    offset.setUTCMinutes(ts.substr(ts.length-2,2));
    if (ts.substr(ts.length-6,1) == '+')
      date.setTime(date.getTime() - offset.getTime());
		else if (ts.substr(ts.length-6,1) == '-')
		  date.setTime(date.getTime() + offset.getTime());
  }
  return date;
}

/*
 * hrTime - human readable Time takes a timestamp in the form of
 * 2004-08-13T12:07:04±02:00 as argument and converts it to some sort of humane
 * readable format
 */
function hrTime(ts) {
    var messageYear = ts.substr(0,ts.indexOf('T')).split('-')[0];
    var messagemounth = ts.substr(0,ts.indexOf('T')).split('-')[1];
    var messageDate = ts.substr(0,ts.indexOf('T')).split('-')[2];
    if(messageDate.substr(0,1) == '0'){
    	messageDate = messageDate.substr(1);
    }
    var year = new Date().getFullYear();
    var mounth = new Date().getMonthEnd().split('-')[1];
    var date = new Date().getDate();
    if(year == messageYear ){
    	var ts1 = ts.substr(0,ts.indexOf('.'));
    	if(date == messageDate && mounth == messagemounth){
    		return  $.i18n('uc.title.today.js')+ ts1.substr(ts.indexOf('T')+1);
    	}else if (parseInt(date)-1 == parseInt(messageDate) && mounth == messagemounth){
    		return  $.i18n('uc.title.Yesterday.js')+ ts1.substr(ts.indexOf('T')+1);
    	}else{
    		return messagemounth + $.i18n('uc.title.Month.js') + messageDate + $.i18n('uc.title.Day.js') + ts1.substr(ts.indexOf('T')+1);
    	}
    }else{
    	return jab2date(ts).toLocaleString();
    }	
}

/*
 * jabberDate somewhat opposit to hrTime (see above) expects a javascript Date
 * object as parameter and returns a jabber date string conforming to JEP-0082
 */
function jabberDate(date) {
  if (!date.getUTCFullYear)
    return;
  
  var jDate = date.getUTCFullYear() + "-";
  jDate += (((date.getUTCMonth()+1) < 10)? "0" : "") + (date.getUTCMonth()+1) + "-";
  jDate += ((date.getUTCDate() < 10)? "0" : "") + date.getUTCDate() + "T";
  
  jDate += ((date.getUTCHours()<10)? "0" : "") + date.getUTCHours() + ":";
  jDate += ((date.getUTCMinutes()<10)? "0" : "") + date.getUTCMinutes() + ":";
  jDate += ((date.getUTCSeconds()<10)? "0" : "") + date.getUTCSeconds() + "Z";
  
  return jDate;
}

function parseDateTime(date) {
    if (!date) {
        date = new Date();
    }

	var str = (date.getHours() < 10) ? "0" + date.getHours() : date.getHours();
	str += ":";
	str += (date.getMinutes() < 10) ? "0" + date.getMinutes() : date.getMinutes();
	str += ":";
	str += (date.getSeconds() < 10) ? "0" + date.getSeconds() : date.getSeconds();
    
    return str;
}

var face_texts = new Array("[5_1]", "[5_2]", "[5_3]", "[5_4]", "[5_5]", "[5_6]", "[5_7]", "[5_8]",
               "[5_9]", "[5_10]", "[5_11]", "[5_12]", "[5_13]", "[5_14]", "[5_15]", "[5_16]",
               "[5_17]", "[5_18]", "[5_19]", "[5_20]", "[5_21]", "[5_22]", "[5_23]", "[5_24]",
               "[5_25]", "[5_26]", "[5_27]", "[5_28]", "[5_29]", "[5_30]", "[5_31]", "[5_32]");

var face_titles = new Array("微笑","呲牙","坏笑","偷笑","可爱","调皮","爱心","鼓掌",
               "疑问","晕","再见","抓狂","难过","流汗","流泪","得意",
               "发怒","嘘","惊恐","鸭梨","赞","奖状","握手","胜利",
               "祈祷","强","蛋糕","礼物","OK","饭","咖啡","玫瑰");
                           
var face_texts_replace = new Array(/\[5_1\]/g, /\[5_2\]/g, /\[5_3\]/g, /\[5_4\]/g, /\[5_5\]/g, /\[5_6\]/g, /\[5_7\]/g, /\[5_8\]/g,
                   /\[5_9\]/g, /\[5_10\]/g, /\[5_11\]/g, /\[5_12\]/g, /\[5_13\]/g, /\[5_14\]/g, /\[5_15\]/g, /\[5_16\]/g,
                   /\[5_17\]/g, /\[5_18\]/g, /\[5_19\]/g, /\[5_20\]/g, /\[5_21\]/g, /\[5_22\]/g, /\[5_23\]/g, /\[5_24\]/g,
                   /\[5_25\]/g, /\[5_26\]/g, /\[5_27\]/g, /\[5_28\]/g, /\[5_29\]/g, /\[5_30\]/g, /\[5_31\]/g, /\[5_32\]/g,
                   /\[wx\]/g, /\[cy\]/g, /\[dx\]/g, /\[tl\]/g, /\[huaix\]/g, 
								   /\[hx\]/g, /\[xa\]/g, /\[wq\]/g, /\[dk\]/g, /\[sx\]/g, 
								   /\[sq\]/g, /\[han\]/g, /\[zk\]/g, /\[jy\]/g, /\[yw\]/g, 
								   /\[gz\]/g, /\[bb\]/g, /\[jb\]/g, /\[yl\]/g, /\[ws\]/g, 
								   /\[hao\]/g, /\[fd\]/g, /\[dg\]/g, /\[jz\]/g, /\[zan\]/g);

/** **************************************标题闪烁*************************************** */
var ucIntervalTitle = null;
var ucStandardTitle = null;
var ucMovementTitle = null;

var ucStep = 0;
function flash_uc_title(){
	ucStep ++;
	if (ucStep == 3) {ucStep = 1;}
	if (ucStep == 1) {document.title = ucMovementTitle;}
	if (ucStep == 2) {document.title = ucStandardTitle;}
}

function startUCActionTitle(standard, movement){
	ucStandardTitle = standard;
	ucMovementTitle = movement;
	if (!ucIntervalTitle) {
		ucIntervalTitle = window.setInterval("flash_uc_title()", 1000);
	}
}

function endUCActionTitle() {
	if (!ucStandardTitle) {
		ucStandardTitle = document.title;
	}
	
	document.title = ucStandardTitle;
	
	if (ucIntervalTitle != null) {
		window.clearInterval(ucIntervalTitle);
		document.title = ucStandardTitle;
		ucIntervalTitle = null;
	}
}
/** **************************************标题闪烁*************************************** */