/**
 * @author macj
 */
var iq;
var fromid;
var toid;
var toname;
var con ;
var fromName;
var tager;
var isIndex = false;
var indexFor = false;
var tigger ;
var fromName ='';
var isclose = false;
var isclean = false;
var isonupload = true;
var uchost = '';
var scollTarget;
function UploadChat(options){
	isclose = options.isclose ? options.isclose : false;
    this.id = options.id ? options.id : Math.floor(Math.random() * 100000000);
    this.toid = options.toid;
    this.fromid = options.fromid;
    this.iq = options.iq;
    this.con = options.con;
    this.toname = options.toname;
    isIndex = options.isIndex;
    fromName = options.fromName;
    tigger = options.tigger;
    indexFor = options.indexFor;
    this.fromName = options.fromName;
    this.tager = options.tager;
    this.scollTarget = options.scollTarget;
    scollTarget = this.scollTarget;
    tager = this.tager;
    fromName =   this.fromName;
    con = this.con;
    iqps = this.iq;
    fromid = this.fromid;
    toname = this.toname;
    toid = this.toid;
    this.width = options.width ? options.width : 330 ;
    this.height = options.height ? options.height : 140;
    this.borderSize = 1;//边框尺寸(像素)
    this.target =  options.target;//必须参数
	this.fixObj =  options.fixObj;//必须参数
	
	if(this.target == null || this.fixObj == null){return;}
    this.left = options.left==undefined ?  200:options.left;
	this.top = options.top==undefined ?  200:options.top;
	
	this.isUp = options.isUp==undefined ?  false:options.isUp;
	
	this.clickFn  = options.clickFn;
	if(this.clickFn == undefined){
		this.clickFn = function(){}
	}
    
    this.init();
    fileMemberList = new Array();	
}
UploadChat.prototype.init = function(){
    //判断是否存在.存在就先移处
    if (typeof($("#" + this.id)[0]) != "undefined") {
        $("#" + this.id).remove();
    }
	var fixObj = document.getElementById(this.fixObj);

	//+fixObj.clientHeight+10
	this.left = fixObj.getBoundingClientRect().left + 15;
	
    var htmlStr = "";
    htmlStr += "<div id='" + this.id + "' class='dialog_box absolute' style='left:" + this.left+ "px;top:"+this.top+"px'>";
    //阴影   style='left:700px;top:220px'
    htmlStr += "<div id='" + this.id + "_shadow' class='dialog_shadow absolute' style='width:" + (this.width + this.borderSize * 2) + "px;height:" + (this.height + this.borderSize * 2) + "px;'>&nbsp;</div>"
	    //main
	    htmlStr += "<div id='" + this.id + "_main' class='dialog_main absolute' style='width:" + this.width + "px'>";
		    //header
		    htmlStr += "<div id='" + this.id + "_main_head' class='clearfix'>";
		    htmlStr += "</div>";
			//header
			//body
		    htmlStr += "<div id='" + this.id + "_main_body' class='dialog_main_body left' style='width:" + this.width + "px;height:" + this.height + "px'>";
			    //iframe 遮罩层
			    htmlStr += "<div id='" + this.id + "_main_iframe' class='dialog_main_iframe absolute' style='top:" + this.headerHeight + "px;width:" + this.width + "px;height:" + this.height + "px;display:none;'>&nbsp;</div>";
			    //iframe 容器
			    htmlStr += "<div id='" + this.id + "_main_content' class='dialog_main_content absolute'>";
					htmlStr+="<div id='" + this.id + "_main_iframe_div' class='dialog_main_content_html padding_5 margin_5' style='margin-top:0px;width:"+(this.width-22)+"px;height:"+(this.height-22)+"px;'>";
			        htmlStr+="</div>";
				htmlStr += "</div>";
				
		    htmlStr += "</div>";
		    //body
	    htmlStr += "</div>";
	    //main
    htmlStr += "</div>";
    $("body").prepend(htmlStr);
	
	var self = this;
	$("<span id='ids_close' name='dialog_close' class='dialog_close right' title='" + $.i18n('uc.close.js') + "'></span>").css('margin-top','0px').click(function(){
		//判断，如果当前正在传输文件的时候点击关闭按钮，用变量标示放弃正在传输的文件
		if(!isonupload){
			isclean = true;
		}
		if(tigger){
			if (tigger.html().indexOf('jid') <= 0) {
				 if (fileMemberList.length <= 0 ) {
						tigger.html('');
						tigger.hide();
				 }
			}
		}
		filePathList = new Array();
		fileSize = 0;
		self.close();
	}).appendTo($("#"+this.id+"_main_head"));
	//循环增加样式表情
	
	
	var strHtml = "";
	var uploadstr = '<br/><marquee style="border:1px solid #000000" direction="right" width="295" scrollamount="5" scrolldelay="10" bgcolor="#ECF2FF">';
			uploadstr +='<table cellspacing="1" cellpadding="0">';
			uploadstr +='<tr height=20>';
			uploadstr +='<td bgcolor=#3399FF width=8></td>';
			uploadstr +='<td></td>';
			uploadstr +='<td bgcolor=#3399FF width=8></td>';
			uploadstr +='<td></td>';
			uploadstr +='<td bgcolor=#3399FF width=8></td>';
			uploadstr +='<td></td>';
			uploadstr +='<td bgcolor=#3399FF width=8></td>';
			uploadstr +='<td></td>';
			uploadstr +='</tr></table>';
			uploadstr +='</marquee>';
			strHtml+="<div class='file_box'>";
			strHtml+=" <div class='file_unload clearfix'><form id='fileform' >";
			strHtml+=" <a class='common_button common_button_icon file_click hand' id ='uploada'><em class='ico16 affix_16'></em>"+$.i18n('uc.tab.upload.js');
			strHtml+="	<input style='border: 1px solid rgb(255, 0, 0);' type='file' value='' name= 'img' id ='img' onchange= 'showChange()' class='myFole'>";
			strHtml+=" </a>";
			strHtml+=" </form></div>";
			strHtml+="<ul class='file_select padding_10 border_all clearFlow' style='height:50px;margin:5px 0px;overflow:auto' id ='mytop'>";
			strHtml+="</ul>";
			strHtml+="<ul class='file_select padding_10 border_all clearFlow hidden' style='height:50px;margin:5px 0px;overflow:auto' id ='mytop3'>";
			strHtml+=uploadstr;
			strHtml+="</ul>";
	strHtml+="</div>";
	if(!indexFor){
		strHtml+="<div class='clearfix align_right'><a id='checkon' class='common_button common_button_emphasize margin_r_10'  onclick='sendFileMessage()'>"+$.i18n('uc.button.ok.js')+"</a><a class='common_button common_button_emphasize'  onclick='closeBu()'>"+$.i18n('uc.button.cancel.js')+"</a></div>";
	}else{
		strHtml+="<div class='clearfix align_right'><a class='common_button common_button_emphasize'  onclick='closeBu()'>"+$.i18n('uc.button.cancel.js')+"</a></div>";
	}
	$("#"+this.id+"_main_iframe_div").append(strHtml);
	//$("#"+this.id+"_main_iframe_div").append("<div id='myFile' class='myf'><font color='red'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请选择您要上传的文件!(大小限制50M)</font><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<div id='showFils' class = 'file_unload clearfix'> <a class='common_button common_button_icon file_click' href='javascript:void(0)''><em class='ico16 affix_16'></em>  <input style='border: 1px solid rgb(255, 0, 0);' type='file'  id='img'  class='myFole' name='img'  onchange= 'showChange()'  value=''>上传附件  </a></div><div class='hidden' id='showIms' ><img src='../image/gundong.gif'/></div><div id='ufile'></div><br/><br/><hr/>"+str+"<a class='common_button common_button_emphasize' href='javascript:void(0)' onclick='sendFileMessage()'>确定</a>&nbsp;&nbsp<a class='common_button common_button_emphasize' href='javascript:void(0)' onclick='closeBu()'>取消</a></div> ");

}
function showChange(){
	uploadCheck();
}
function closeBu(){
	if(!isonupload){
		isclean = true;
	}
	filePathList = new Array();
	fileSize = 0;
	fidList = new Array();
	if(indexFor){
		if(tigger.html().indexOf('jid') <= 0){
			tigger.html('');
			tigger.hide();
			$(".common_send .common_send_textarea").keyup();
			$(".pageChatArea .pageChatArea_textarea").keyup();
		}
	}
	$('#ids_close').click();
}
function getFileSize(mqfile){
    
     return mqfile.files[0].size;
}
function getFileName(path){
	var pos1 = path.lastIndexOf('/');
	var pos2 = path.lastIndexOf('\\');
	var pos  = Math.max(pos1, pos2)
if( pos<0 )
	return path;
else
	return path.substring(pos+1);
}
var fileName ='';
var filesize ='';
var hash ='';
var date ='';
var fileSize = 0;
var filePathList = new Array();
function uploadCheck  (){
	if(tigger){
		if(tigger.html().indexOf('jid') > 0){
			$.alert($.i18n('uc.tab.uploadMax.js'));
			return ;
		}
	}
	if(fileSize > 0){
		$.alert($.i18n('uc.tab.uploadMax.js'));
		return ;
	}
	var mqfile = document.getElementById("img");
	var size = 0;
	try{
		size =  getFileSize(mqfile);
	}catch(e){
		try{
			var fso = new ActiveXObject('Scripting.FileSystemObject');
	        var file = fso.GetFile(mqfile.value);
	        size = file.Size;
	        if(parseInt(size) == 0){
	    		size = 1024;
	    	}
		}catch(e){
			//屏蔽掉提示，防止因为ie浏览器安全级别过高抛异常
			//$.alert($.i18n('uc.title.fileuploadError.js'))
		}
	}
	for(var k = 0 ; k < filePathList.length; k++){
		if(filePathList[k] == mqfile.value){
			alert($.i18n('uc.tab.uploadonto.js'));
			return ;
		}
	}
	filePathList[filePathList.length] = mqfile.value;
	var name = getFileName(mqfile.value);
	var uuid = uuidUtils();
	fileName = name ;
	filesize = size;
	hash = uuid;
	if ("-1" != iqps.fileSize && "" != iqps.fileSize) { 
		if(size>=(parseInt(iqps.fileSize,10)*1024*1024)){
			$.alert($.i18n('uc.tab.filesizeMax.js',iqps.fileSize));
			return ;
		}
	}
	var fsize = parseInt(size/1024);
	if (fsize <= 0){
		fsize = 1;
	}
	date = new Date();
	var iqs = iqps.newJSJaCIQ();
    var uids = fromid;
    iqs.setFrom(uids);
    iqs.setIQ('filetrans.localhost', 'get', 'filetrans_2');
	var query1 = iqs.setQuery('filetrans');
	query1.setAttribute('type' ,'get_upload_url');
	query1.setAttribute('to' ,'test_1@localhost');
	query1.appendChild(iqs.buildNode('name', '', name));
	query1.appendChild(iqs.buildNode('size', '',fsize));
	query1.appendChild(iqs.buildNode('hash', '',uuid));
	query1.appendChild(iqs.buildNode('date', '',date.format("yyyy/MM/dd HH:mm:ss")));
	con.send(iqs, updateFilePath);
	uchost = con.uchost;
	$('#uploada').hide();
	$('#checkon').hide();
	$('#mytop').hide();
	$('#mytop3').show();
}
function uuidUtils (){
	function s4(){
		return ((1+Math.random()*0x1000000)|0).toString(16).substr(1);
	}
	return s4()+"" +s4()+""+s4()+""+s4();
}
//新上传插件回调函数,参数中type代表是状态 1为成功，2是进度，-1网络失败，-2文件读写失败 -3 url参数错误
function ucUploadCallBack (type,data) {
	//如果状态不为2代表成功或者失败，需要清空文件框，停止滚动条
	if (type != '2') {
			var fiform = document.getElementById('fileform');
			fiform.reset();
		  	isonupload = true;
            if(isclean){
            	 isclean = false;
            	 return;
            }
            $('#checkon').show();
            $('#uploada').show();
            $('#mytop').show();
            $('#mytop3').hide();
	}
	//如果为1表示成功，执行成功之后处理的函数
	if (type == '1') {
		UploadOk();
	} else if(type == '2'){

	} else if (type == '-1') {
		$.alert($.i18n('uc.title.network.js'));
	} else if (type == '-3') {
		$.alert($.i18n('uc.title.urlerror.js'));
	} else {
		$.alert($.i18n('uc.title.filereaderror.js'));
	}
}

var fileid = '';
function updateFilePath(iq){
	  if (!iq || iq.getType() == 'eror') {
		  
	  }else{
		  var updateFilePathStr = iq.getNode().getElementsByTagName('uploadurl')[0].firstChild.data;
		  var id = iq.getNode().getElementsByTagName('id')[0].firstChild.data;
		  fileid = id;
		  var path = updateFilePathStr+id;
		  $('#showIms').show();
		  $('#showFils').hide();
		  //获取上传插件
		  var uc_upload = document.getElementById('UC_UPLOAD');
		  var mqfile = document.getElementById("img");
		  //如果是ie执行插件上传，如果是其他浏览器的话执行报错之后 ，调用原有的上传插件
		  var newpath = replaceUrl(uchost,path);
		  try {
		  	uc_upload.SetCallBackFun(fromid,ucUploadCallBack);
		  	uc_upload.SetUploadParam(fromid,id,newpath,mqfile.value);
		  }catch (e){
	  		ajaxFileUpload(newpath);
		  }
	  }
}
var fidList  = new Array();
var fileMemberList = new Array();
var memberName ='';
function ajaxFileUpload(path)
{
   isonupload = false;
   $.ajaxFileUpload
      (
        {
             url:path, //你处理上传文件的服务端
             secureuri:false,
             fileElementId:'img',
             dataType: 'json',
             success: function ( data, status )
                   {
            	 	isonupload = true;
            	 	if(isclean){
            	 		isclean = false;
            	 		return;
            	 	}
            	 	$('#checkon').show();
            	 	$('#uploada').show();
            	 	$('#mytop').show();
            	 	$('#mytop3').hide();
	            	 if(status=='success'){
	            		 fileSize++;
	            		 var fileItem = {
	            				 fid: fileid,
	            				fname: fileName
	    		          }
	            		 fileMemberList[fileMemberList.length] = fileItem;
	            		 if(indexFor){
	            			
	            			
	            		 }
	            			var items = {
	            					fid: fileid,
	            					fname: fileName,
	            					fsize: filesize,
	    							hash: hash,
	    							date: date
	    		               	}
	            		 	fidList[fidList.length] = items;
	            			var stri = '';
	            			if(fileName.length >= 5){
	            				stri = '...';
	            			}
	            			if(!indexFor){
	            				var qqq=	$('<li><span class="common_send_people_box" id=ss_InBox" jid="' + fileid + '" title="' + fileName + '" fname="' + fileName + '">' + fileName.substr(0,4)+ stri + '<em class="ico16 affix_del_16"></em></span></li>');
		            			qqq.find('em').click(function(){
		            				var newFidList = fidList;
		            				var newFpathList = filePathList;
		            				filePathList = new Array();
		            				fidList = new Array();
		            				var fileNameLists = fileMemberList;
		            				fileMemberList = new Array();
		            				var u = 0;
		            				for(var y = 0 ; y < fileNameLists.length ; y ++){
		            					if(fileNameLists[y].fid != $(this).parent()[0].getAttribute('jid')){
		            						fileMemberList[u] = fileNameLists[y];
		            						u ++;
		            					}
		            				}
		            				var x = 0;
		            				for(var i = 0 ; i < newFidList.length; i++ ){
		            					if(newFidList[i].fid != $(this).parent()[0].getAttribute('jid')){
		            						fidList[x] = newFidList[i];
		            						x++;
		            					}
		            				}
		            				var k = 0;
		            				for(var j = 0 ; j < newFpathList.length ; j ++){
		            					if(newFpathList[j].indexOf($(this).parent()[0].getAttribute('fname'))<0){
		            						filePathList[k] = newFpathList[j];
		            						k++;
		            					}
		            				}
		            				fileSize =  fileSize -1;
		            				$(this).parent().parent().remove();
		            			});
		            			qqq.appendTo( $('#mytop'));
	            			}else{
	            				sendFileMessage();
	            			}
	            		 	memberName = iq.curUserName;
	            		 	  $('#showIms').hide();
	            			  $('#showFils').show();
	            	 }else{
	            		 	$('#showIms').hide();
	            		 	$('#showFils').show();
	            		 	$.alert($.i18n('uc.tab.filesuploadfield.js'));
	            	 }
                   }
                }
          )

        return false;
  } 
function subMessage(item,body,obj,isclean){
	if(fidList.length > 0 || body.replace(/\s+/g,"").length > 0 ){
		if(body.trim() != '\n'){
			var aMessage = obj.newJSJaCMessage();
			var jid = item.jid;
			if(jid.indexOf('@group')>=0){
				aMessage.setType('groupchat');
			}else{
				aMessage.setType('chat');
			}
			aMessage.setFrom(obj.jid);
			aMessage.setTo(jid);
			aMessage.setBody(body);
			aMessage.setName(obj.curUserName);
			aMessage.appendNode(aMessage.buildNode('toname',item.name));
			if(indexFor){
				if(fidList.length > 0){
					aMessage.setType('filetrans');
					for(var i = 0 ; i < fidList.length; i++){
						var filetrans =  aMessage.buildNode('filetrans',{ 'xmlns':'filetrans'});
						filetrans.appendChild(aMessage.buildNode('id',fidList[i].fid));
						filetrans.appendChild(aMessage.buildNode('name',fidList[i].fname));
						var fsize = parseInt(fidList[i].fsize/1024);
						if (fsize <= 0){
							fsize = 1;
						}
						filetrans.appendChild(aMessage.buildNode('size',fsize));
						filetrans.appendChild(aMessage.buildNode('hash',fidList[i].hash));
						filetrans.appendChild(aMessage.buildNode('date',fidList[i].date));
						filetrans.appendChild(aMessage.buildNode('desc',''));
						aMessage.appendNode(filetrans);
					}
					
				}
			}
			
			obj. con.send(aMessage);
			isFoat = true;
		}
	}
	if(indexFor){
		if (isclean) {
			
		} else {
			$('#ids_close').click();
		}
	}
	
}
UploadChat.prototype.close = function() {
	$('#' + this.id).remove();
}
function downMicTalkPath(fid,fname,size,tager,cons,obj){
	
	
		var iqs = obj.newJSJaCIQ();
		iqs.setFrom(obj.parent.jid);
		iqs.setIQ('localhost', 'get', 'microtalk_1');
		var query1 = iqs.setQuery('microtalk');
		query1.setAttribute('type' ,'get_download_url');
		query1.appendChild(iqs.buildNode('id', '', fid));
		cons.send(iqs, playMic,tager);
}
function playMic(iq,tager){
	if (iq.getType() == 'error') {
		var code = iq.getNode().getElementsByTagName('error')[0].getAttribute('code');
		if (code == '404') {
			$.alert($.i18n('uc.title.resourcesnotexist.js'));
		} else if (code == '801') {
			$.alert($.i18n('uc.title.fileextended.js'));
		} else {
			$.alert($.i18n('uc.title.fileaccess.js'));
		}
	} else {
		var url = iq.getNode().getElementsByTagName('downloadurl')[0].firstChild.data;
		var ischeck = checkPlugins('QuickTime','');
		if (ischeck) {
		var str = "<embed id='MM_controlSound1' src='"+url+".amr' loop=false autostart=true mastersound hidden=true width=10 height=10 type='video/quicktime'></embed>";
			document.getElementById(tager).innerHTML = str;
		} else {
			var quickUrl ="<a onclick=\"javaScript:window.open('http://www.apple.com/quicktime')\">quicktime</a>";
			var confirm = $.confirm({
    			'msg': $.i18n('uc.title.notquicktime.js',quickUrl),
    			ok_fn: function () {
    				downloadFileStyle(url + ".amr");
    			},
				cancel_fn:function(){
					confirm.close();
				}
			});
		}
	}
}

function downFilePath(fid,fname,cons,obj,type){
	var iqs = obj.newJSJaCIQ();
    iqs.setFrom(obj.parent.jid);
    iqs.setIQ('filetrans.localhost', 'get');
	var query1 = iqs.setQuery('filetrans');
	if (type == 'image') {
		query1.setAttribute('type' ,'get_picture_download_url');
	} else {
		query1.setAttribute('type' ,'get_download_url');
	}
	query1.appendChild(iqs.buildNode('id', '', fid));
	uchost = cons.uchost;
	cons.send(iqs, downFileYe,fname);
}
function downFileYe(iq,fname){
	if (iq.getType() == 'error') {
		var code = iq.getNode().getElementsByTagName('error')[0].getAttribute('code');
		if (code == '404') {
			$.alert($.i18n('uc.title.resourcesnotexist.js'));
		} else if (code == '801') {
			$.alert($.i18n('uc.title.fileextended.js'));
		} else {
			$.alert($.i18n('uc.title.fileaccess.js'));
		}
	} else {
		var urls = '';
		var url = iq.getNode().getElementsByTagName('downloadurl')[0].firstChild.data;
		url = url +"&"+encodeURI(encodeURI(fname));
		urls = url;
		urls = replaceUrl(uchost,urls);
		downloadFileStyle(urls);
	}
}
function sendFileMessage(){
	if(!indexFor){
		if(fidList.length > 0){
			 var aMessage = iqps.newJSJaCMessage();
			  aMessage.setType('filetrans');
			  aMessage.setFrom(fromid);
			  aMessage.setTo(toid);
			  aMessage.setBody('');
			  aMessage.setName(fromName);
			  aMessage.appendNode(aMessage.buildNode('toname',toname));
			for(var i = 0 ; i < fidList.length; i++){
				var filetrans =  aMessage.buildNode('filetrans',{ 'xmlns':'filetrans'});
				filetrans.appendChild(aMessage.buildNode('id',fidList[i].fid));
				filetrans.appendChild(aMessage.buildNode('name',fidList[i].fname));
				var fsize = parseInt(fidList[i].fsize/1024);
				if (fsize <= 0){
					fsize = 1;
				}
				filetrans.appendChild(aMessage.buildNode('size',fsize));
				filetrans.appendChild(aMessage.buildNode('hash',fidList[i].hash));
				filetrans.appendChild(aMessage.buildNode('date',fidList[i].date));
				filetrans.appendChild(aMessage.buildNode('desc',''));
				aMessage.appendNode(filetrans);
			}
			con.send(aMessage);
			fidList = new Array();
			filePathList = new Array();
			$('#ids_close').click();
			//提示信息
			var htmlStr ="";
			for(var u = 0 ; u < fileMemberList.length; u++){
				//修改消息区域自适应 youhb 2013年11月25日16:25:46
			    htmlStr += "<tr class='ucChat_right'>";
			    htmlStr += "<td colspan='2'></td>";
			    htmlStr += "<td colspan='2'>";
			    htmlStr += "<span class='right'><span class='ucChat_arrow'><span></span></span><span class='ucChat_close hidden'><span class='ico16 for_close_16'></span></span></span>";
			    htmlStr += "<div class='ucChat_content'>";
			    htmlStr += "<span class='color_gray2'>" + $.i18n('uc.titleMy.js') + "&nbsp;</span><span class='font_size12 color_gray2'>今天:" + parseDateTime() + "</span><br/>";
			    htmlStr += "<p class='margin_l_5' style='word-wrap: break-word;'><span class='font_size12'><span class=\""+querySpanClass(fileMemberList[u].fname)+"\" style='cursor: default;'></span>"+fileMemberList[u].fname+" "+$.i18n('uc.message.Filessentsuccessfully.js')+"</span></p></div></td>";
			    htmlStr += "<td align='right' valign='top'>";
			    htmlStr += "<img class='ucChat_pic' src='" + connWin.curUserPhoto + "'/>";
			    htmlStr += "</td></tr>";
			    htmlStr += "<tr class='ucChat_gap'><td colspan='5'></td></tr>";
			}
		 	tager.append(htmlStr);
	        try {
	            var scrollTop = scollTarget[0].scrollHeight - scollTarget.height();
	            if (scrollTop > 50) {
	            	scollTarget.scrollTop(scrollTop);
	            }
	        } 
	        catch (e) {
	        }
		}else{
			$.alert($.i18n('uc.tab.selectFile.js'));
		}
	}else{
		var flength = 0;
		if (fidList.length > 0){
			flength = 1;
		}
		for(var i = 0 ; i < flength ; i++){
			var fname = fidList[i].fname;
			if(fname.length > 10){
				fname = fidList[i].fname.substr(0,10)+"...";
			}
			var selectFile = $('<span style="line-height:15px;" class="common_send_people_box" id=ss_InBox" fdate="' + fidList[i].date + '" fhash="' + fidList[i].hash + '" fsize="' + fidList[i].fsize+ '" jid="' + fidList[i].fid + '" fname= "' + fidList[i].fname + '" title= "' + fidList[i].fname + '" ><span class ="'+querySpanClass(fidList[i].fname)+'"></span>' + fname + '<em class="ico16 affix_del_16"></em></span>');
				selectFile.find('em').click(function(){
//				 	var newFidList = fidList;
//				 	var newFpathList = filePathList;
// 				filePathList = new Array();
// 				fidList = new Array();
// 				var x = 0;
// 				for(var i = 0 ; i < newFidList.length; i++ ){
// 					if(newFidList[i].fid != $(this).parent()[0].getAttribute('jid')){
// 						fidList[x] = newFidList[i];
// 						x++;
// 					}
// 				}
// 				var k = 0;
// 				for(var j = 0 ; j < newFpathList.length ; j ++){
// 					if(newFpathList[j].indexOf($(this).parent()[0].getAttribute('fname'))<0){
// 						filePathList[k] = newFpathList[j];
// 						k++;
// 					}
// 				}
// 				fileSize =  fileSize -1;
 				$(this).parent().remove();
 				if(filePathList.length <= 0){
					 if (tigger[0].id == "sendFile"){
						 $(".pageChatArea .pageChatArea_textarea").keyup();
					 } else {
						 $(".common_send .common_send_textarea").keyup();
					 }
				}
			 });
		     //重置上传
			 fileSize = 0;
			 filePathList = new Array();
			 selectFile.appendTo(tigger);
			 fidList = new Array();
			 //在扁平化交流的时候默认只选择文件发送按钮也会亮，这里判断目标是否是扁平化交流
			 if (tigger[0].id == "sendFile") {
				 $(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
			 }
			 if($('#common_send_people').html().indexOf('source') > 0){
				 $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
			 }
		}
		
		$('#ids_close').click();
	}
}
var spanSpanClassMap = new Properties();
spanSpanClassMap.put('.avi','ico16 music_16');
spanSpanClassMap.put('.mp4','ico16 music_16');
spanSpanClassMap.put('.rmvb','ico16 music_16');
spanSpanClassMap.put('.mp3','ico16 music_16');
spanSpanClassMap.put('.flv','ico16 music_16');
spanSpanClassMap.put('.awr','ico16 music_16');
spanSpanClassMap.put('.wav','ico16 music_16');
spanSpanClassMap.put('.wav','ico16 music_16');
spanSpanClassMap.put('.pdf','ico16 pdf_16');
spanSpanClassMap.put('.ppt','ico16 ppt_16');
spanSpanClassMap.put('.pptx','ico16 ppt_16');
spanSpanClassMap.put('.doc','ico16 wps_16');
spanSpanClassMap.put('.docx','ico16 wps_16');
spanSpanClassMap.put('.xlsx','ico16 export_excel_16');
spanSpanClassMap.put('.xls','ico16 export_excel_16');
spanSpanClassMap.put('.txt','ico16 txt_16');
spanSpanClassMap.put('.jpg','ico16 images_16');
spanSpanClassMap.put('.bmp','ico16 images_16');
spanSpanClassMap.put('.gif','ico16 images_16');
spanSpanClassMap.put('.png','ico16 images_16');
spanSpanClassMap.put('.exe','ico16 exe_16');
spanSpanClassMap.put('.rar','ico16 rar_16');
spanSpanClassMap.put('.zip','ico16 rar_16');
spanSpanClassMap.put('.other','ico16 file_16');
function querySpanClass(fieName){
	var strs = fieName.split('.');
	var neStr = "."+strs[strs.length-1];
	var spancClass = spanSpanClassMap.get(neStr);
	if(!spancClass){
		spancClass = spanSpanClassMap.get('.other');
	}
	return spancClass;
} 
function isclosefile(){
	if(isclose){
		$('#ids_close').click();
	}
}
function clearFilePath(){
	if(isclose){
		if(indexFor){
			if(tigger.html().indexOf('jid') < 0){
				filePathList = new Array();
				fileSize = 0;
				fidList = new Array();
			}
		}else{
			filePathList = new Array();
			fileSize = 0;
			fidList = new Array();
		}
	}
}
function clearList(){
	filePathList = new Array();
	fileSize = 0;
	fidList = new Array();
}

/**
 * 检测制定插件
 * @param pluginsName 插件名称
 * @param activexObjectName 插件对象的id，如不知道明确id可以为''方法会自动获取
 * @returns {Boolean}
 */
function checkPlugins(pluginsName, activexObjectName) {
    // 通常ActiveXObject的对象名称是两个插件名称的组合
    if (activexObjectName == '') activexObjectName = pluginsName + "." + pluginsName;
	try {
		//ie浏览器判断指定插件
        var axobj = new ActiveXObject(activexObjectName);
        //获取插件对象判断是否存在
		if (axobj) {
			return true;
		} else {
			return false
		};
     } catch (e) {
		//非ie浏览器,使用navigator获取插件
        if (navigator.plugins && navigator.plugins.length) {  
		    for (x=0; x<navigator.plugins.length;x++) { //循环本地插件
		    	if (navigator.plugins[x].name.indexOf(pluginsName) >= 0) {//判断本地是否含有指定插件
					 return true;
				}
		    }
			return false;
	    }
		return false;
    }
}

function showFilesHTML(tiger) {
	for(var i = 0 ; i < fileMemberList.length ; i++){
			var fname = fileMemberList[i].fname;
			if(fname.length > 10){
				fname = fileMemberList[i].fname.substr(0,10)+"...";
			}
			var selectFile = $('<span style="line-height:15px;" class="common_send_people_box" id=ss_InBox" jid="' + fileMemberList[i].fid + '" fname= "' + fileMemberList[i].fname + '" title= "' + fileMemberList[i].fname + '" ><span class ="'+querySpanClass(fileMemberList[i].fname)+'"></span>' + fname + '<em class="ico16 affix_del_16"></em></span>');
				selectFile.find('em').click(function(){
				 	var newFidList = fidList;
				 	var newFpathList = filePathList;
 				filePathList = new Array();
 				fidList = new Array();
 				var x = 0;
 				for(var i = 0 ; i < newFidList.length; i++ ){
 					if(newFidList[i].fid != $(this).parent()[0].getAttribute('jid')){
 						fidList[x] = newFidList[i];
 						x++;
 					}
 				}
 				var k = 0;
 				for(var j = 0 ; j < newFpathList.length ; j ++){
 					if(newFpathList[j].indexOf($(this).parent()[0].getAttribute('fname'))<0){
 						filePathList[k] = newFpathList[j];
 						k++;
 					}
 				}
 				fileSize =  fileSize -1;
 				$(this).parent().remove();
 				if(filePathList.length <= 0){
					 if (tigger[0].id == "sendFile"){
						 $(".pageChatArea .pageChatArea_textarea").keyup();
					 } else {
						 $(".common_send .common_send_textarea").keyup();
					 }
				}
			 });
			 selectFile.appendTo(tigger);
			 //在扁平化交流的时候默认只选择文件发送按钮也会亮，这里判断目标是否是扁平化交流
			 if (tigger[0].id == "sendFile") {
				 $(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
			 }
			 if($('#common_send_people').html().indexOf('source') > 0){
				 $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
			 }
		}
}



function UploadOk (){
	 fileSize++;
	 var fileItem = {
	 	fid: fileid,
	 	fname: fileName
	 }
	 fileMemberList[fileMemberList.length] = fileItem;
	 var items = {
	     fid: fileid,
	     fname: fileName,
	     fsize: filesize,
	     hash: hash,
	     date: date
	 }
	 fidList[fidList.length] = items;
	 var stri = '';
	 if (fileName.length >= 5) {
	    stri = '...';
	 }
	 if (!indexFor) {
	    var qqq=	$('<li><span class="common_send_people_box" id=ss_InBox" jid="' + fileid + '" title="' + fileName + '" fname="' + fileName + '">' + fileName.substr(0,4)+ stri + '<em class="ico16 affix_del_16"></em></span></li>');
		qqq.find('em').click(function(){
		    var newFidList = fidList;
		    var newFpathList = filePathList;
		    filePathList = new Array();
		    fidList = new Array();
		    var fileNameLists = fileMemberList;
		    fileMemberList = new Array();
		    var u = 0;
		    for (var y = 0 ; y < fileNameLists.length ; y ++) {
		    	if (fileNameLists[y].fid != $(this).parent()[0].getAttribute('jid')) {
		         	fileMemberList[u] = fileNameLists[y];
		            u ++;
		        }
		    }
		    var x = 0;
		    for (var i = 0 ; i < newFidList.length; i++ ) {
		        if (newFidList[i].fid != $(this).parent()[0].getAttribute('jid')) {
		            fidList[x] = newFidList[i];
		            x++;
		        }
		    }
		    var k = 0;
		    for (var j = 0 ; j < newFpathList.length ; j ++) {
		        if (newFpathList[j].indexOf($(this).parent()[0].getAttribute('fname'))<0) {
		            filePathList[k] = newFpathList[j];
		            k++;
		        }
		    }
		    fileSize =  fileSize -1;
		    $(this).parent().parent().remove();
		    //使用插件上传的时候如果已经选择了一个文件，再次选择的时候弹出提示，但是file的value没有置空，或者选择相同的文件的时候也会有此问题，
		    //所以在删除文件的时候不管file有没有置空，都要手动置空
		    var fiform = document.getElementById('fileform');
			fiform.reset();
		});
		qqq.appendTo( $('#mytop'));
	} else {
	    sendFileMessage();
	}
	$('#showIms').hide();
	$('#showFils').show();
}

function replaceUrl(uchost,url) {
	if (url.indexOf(':') > -1) {
		url = url.substring(url.indexOf(':') + 1);
		if (url.indexOf(':') > -1) {
			url = url.substring(url.indexOf(':'));
		}
		
	}
	url = uchost + url;
	return url;
}

function downloadFileStyle (urls) {
	if (v3x.isMSIE8 || v3x.isMSIE7 || v3x.isMSIE6) {
		document.getElementById('downloadFileFrame').src = urls;
	} else {
		document.getElementById('downloadFileFrom').action = urls;
		document.getElementById('downloadFileFrom').submit();
	}
}

var imgType = new Properties(); //允许上传的图片后缀名
imgType.put('jpeg',true);
imgType.put('png',true);
imgType.put('gif',true);
imgType.put('bmp',true);
imgType.put('jpg',true);

/**
 * 图片文件上传change事件，主要获取url 判断图片格式等！
 * youhb
 * 2014年3月17日14:19:17 
 */

function fnImgChanage (obj) {
	var fileName = $(obj.element).val();
	if (fileName == '') {
		return ;
	}
	//获取图片后缀名
	var strtype=fileName.substring(fileName.length-3,fileName.length);
	strtype=strtype.toLowerCase();
	//检测图片后缀名是否在发送范围内
	if (imgType.get(strtype)) {
		date = new Date();
	    var uids = obj.connWin.jid;
	    var iqs = obj.connWin.newJSJaCIQ();
	    iqs.setFrom(uids);
	    iqs.setIQ('filetrans.localhost', 'get');
		var query1 = iqs.setQuery('filetrans');
		query1.setAttribute('type' ,'get_picture_upload_url');
		query1.setAttribute('to' ,'test_1@localhost');
		query1.appendChild(iqs.buildNode('name', '', fileName));
		query1.appendChild(iqs.buildNode('size', '','123'));
		query1.appendChild(iqs.buildNode('hash', '',obj.connWin.jid));
		query1.appendChild(iqs.buildNode('date', '',date));
		obj.fileName = fileName;
		obj.connWin.con.send(iqs, updateImgPath,obj);
	} else {
		$.alert($.i18n('uc.image.title.not.js'));
		var fiform = document.getElementById('imageFrom');
		fiform.reset();
		endProcs();
	}
}

/**
 * 请求上传路径返回处理
 * youhb
 * 2014年3月17日15:08:06 
 * @param iq
 * @param obj
 */
function updateImgPath (iq,obj) {
	var ucHost = obj.connWin.con.uchost;
	var fromId = obj.connWin.jid;
	var element = obj.element;
	var tagger = obj.tagger;
	if (iq != null && iq.getType() != 'error') {
		  var updateFilePathStr = iq.getNode().getElementsByTagName('uploadurl')[0].firstChild.data;
		  var id = iq.getNode().getElementsByTagName('id')[0].firstChild.data;
		  fileid = id;
		  obj.fileId = fileid;
		  var path = updateFilePathStr+id;
		  var option = {
				  'ucHost':ucHost,
				  'filPath':path,
				  'fromId':fromId,
				  'elementId':element.id,
				  'type':'img',
				  'fileId':id
				  
		  }
		  var newpath = replaceUrl(ucHost,path);
		  var imgOption = {
			  'filePath':newpath,
			  'elementId':element.id,
			  'tagger':tagger,
			  'fileName':obj.fileName,
			  'fileId':obj.fileId,
			  'connWin':obj.connWin
		  }
		  ajaxImgUpload(imgOption);
	} else {
		$.alert('图片上传出现错误!');
	}
}

/**
 * 发送图片，处理方式不一样因此区隔与发送文件
 * youhb
 * 2014年3月17日14:19:23 
 * @param path
 */
function ajaxImgUpload(option) {
	   $.ajaxFileUpload
	      (
	        {
	             url:option.filePath, //你处理上传文件的服务端
	             secureuri:false,
	             fileElementId:option.elementId,
	             dataType: 'json',
	             timeout:30000,
	             success: function ( data, status )
	                   {
	            	 	appendImg(option);
	                   },
	             error: function (data, status) 
			           {
			            $.alert('网络异常');
			           }
	        }
	      );
}

function appendImg (option) {
	var iqs = option.connWin.newJSJaCIQ();
	iqs.setFrom(window.parent.connWin.jid);
	iqs.setIQ('filetrans.localhost', 'get', 'filetrans_3');
	var query1 = iqs.setQuery('filetrans');
	query1.setAttribute('type' ,'get_picture_download_url');
	query1.appendChild(iqs.buildNode('id', '', option.fileId+'_1'));
	option.connWin.con.send(iqs, appenImgCollBack,option);
}
function appenImgCollBack(iq,option) {
	endProcs();
	if (iq && iq.getType() != 'error') {
		var url = iq.getNode().getElementsByTagName('downloadurl')[0].firstChild.data;
		option.tagger.dialogtextarea.append('<img src="'+url+'" fileid="'+option.fileId+'" fname="'+option.fileName+'" class="maxHeight_150"/>');
	} else {
		$.alert('获取缩略图路径错误！');
	}
}
