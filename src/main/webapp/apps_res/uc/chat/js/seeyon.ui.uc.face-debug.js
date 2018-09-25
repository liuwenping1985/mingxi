/**
 * @author macj
 */
var isClose = false;
var sendInputPox = null;
function MxtFace(options){
    this.id = options.id ? options.id : Math.floor(Math.random() * 100000000);
    this.width = options.width ? options.width : 304;
    this.height = options.height ? options.height : 163;
    this.borderSize = 1;//边框尺寸(像素)
    this.target =  options.target;//必须参数
	this.fixObj =  options.fixObj;//必须参数
	isClose = options.isClose == undefined ? false:options.isClose;
	sendInputPox = options.sendInputPox == undefined ? null:options.sendInputPox;
	if(this.target == null || this.fixObj == null){return;}
    this.left = options.left==undefined ?  200:options.left;
	this.top = options.top==undefined ?  200:options.top;
	
	this.isUp = options.isUp==undefined ?  false:options.isUp;
	
	this.clickFn  = options.clickFn;
	if(this.clickFn == undefined){
		this.clickFn = function(){}
	}
    
    this.init();
		
}
MxtFace.prototype.init = function(){
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
    htmlStr += "<div id='" + this.id + "_shadow' class='hidden dialog_shadow absolute' style='width:" + (this.width + this.borderSize * 2) + "px;height:" + (this.height + this.borderSize * 2) + "px;'>&nbsp;</div>"
	    //main
	    htmlStr += "<div id='" + this.id + "_main' class='dialog_main absolute' style='width:" + this.width + "px'>";
		    //header
		    htmlStr += "<div id='" + this.id + "_main_head' class='clearfix'>";
		    htmlStr += "</div>";
			//header
			//body
		    htmlStr += "<div id='" + this.id + "_main_body' class='dialog_main_body left' style='width:" + this.width + "px;height:" + (this.height - 5) + "px'>";
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
	$("<span id='imgid_close' class='dialog_close right' title='"+$.i18n('uc.close.js')+"'></span>").css('margin-top','0px').click(function(){
		self.close();
	}).appendTo($("#"+this.id+"_main_head"));
	//循环增加样式表情
	
	for (var i = 0; i < face_texts.length; i++) {
		var border = "border_r border_b";
		if (i < 8) {
			border += " border_t";
		}
		
		if (i % 8 == 0) {
			border += " border_l";
		}
		
		var html = "<div class='left " + border + " padding_5' style='width:24px;height:24px;'>&nbsp;</div>";
		
		if (face_texts[i] != "") {
			html = "<div class='left " + border + " padding_5' style='width:24px;height:24px;'><img title='" + face_titles[i] + "' id='" + this.id + "_img" + i + "' src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (i + 1) + ".gif' class='hand'/></div>";
		}
		
		$(html).appendTo($("#" + this.id + "_main_iframe_div"));
 		(function(g, id){
			$('#' + id + '_img' + g).click(function(){
				if ($('#' + self.target).html() == '<br>') {
					$('#' + self.target).html('');
				}
				if(sendInputPox != null && $('#' + self.target).html() != '' && sendInputPox.text == ''){
					sendInputPox.text = face_texts[g];
					sendInputPox = null;
				}else{
					$('#' + self.target)[0].focus();
					if (v3x.isChrome) { 
						document.execCommand("inserthtml", true, face_texts[g]);
					} else { 
						$('#' + self.target).append(face_texts[g]);
					}
				}
				$('#' + self.target)[0].focus();
				$('#' + self.id).remove();
			}).click(self.clickFn);
		})(i, this.id);
	}
}

MxtFace.prototype.close = function() {
	$('#' + this.id).remove();
}

function closeWin (){
	if (isClose) {
		$('#imgid_close').click();
	}
}