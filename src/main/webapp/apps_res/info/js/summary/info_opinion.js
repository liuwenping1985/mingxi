//遍历页面中span中属性xd:binding，放到js的hashtable中，便于以后读取
var opinionSpans=null;


function initSpans() { 
  var i,key;  
  var spanObjs=document.getElementsByTagName("span");
  opinionSpans=new Properties();
  for(i=0;i<spanObjs.length;i++)
  {   
    key=spanObjs[i].getAttribute("xd:binding");
    if(key!=null)
    {   
      //记录处理意见录入框的初始化大小，确定手写签批对话框大小;
      spanObjs[i].initWidth=spanObjs[i].style.width;
      spanObjs[i].initHeight=spanObjs[i].style.height;
      opinionSpans.put(key,spanObjs[i]);      
    }
  } 
}

function extendData(name, value){
  this.name = name;
  this.value = value;
}
var extendArray = new Array();

function removeOpinionBorder(opinionElements) {
	if(opinionSpans == null) { initSpans(); }
	for(i=0; i<opinionElements.length; i++) {
		spanObj = opinionSpans.get("my:"+opinionElements[i], null);
		if(spanObj != null) {
			$(spanObj).removeClass("xdTextBox");
			$(spanObj).addClass("opinion_noborder");
		}
	}
}

/*显示公文处理意见*/
function dispOpinions(opinions,senderOpinion) {
	try {
		if(opinionSpans == null) { initSpans(); }
		var i;
		var otherOpinion = "";
		var spanObj;
		var isboundSender = false;
		/** 显示意见 **/
		for(i=0;i<opinions.length;i++) {
			if(opinions[i][0] =="shangbao") { isboundSender = true; }
			spanObj = opinionSpans.get("my:"+opinions[i][0], null);
			opinions[i][1] = changeFontsize(opinions[i][1], spanObj);
			if(spanObj==null||spanObj==undefined) {
				if(otherOpinion!=""){otherOpinion+="<br>";}
				otherOpinion+=opinions[i][1];
		    } else {
		    	  spanObj.innerHTML=opinions[i][1];
			      spanObj.style.height="auto"||"100%";
			      spanObj.style.border="0px";
			      spanObj.contentEditable="false";
			      spanObj.style.whiteSpace = "normal";
			      //spanObj.style.overflowY ="auto";
			      extendArray[extendArray.length] = new extendData("my:"+opinions[i][0], spanObj.innerText);
		    }
		}
		/** 其它意见框 **/
		spanObj=opinionSpans.get("my:otherOpinion", null);
		if(otherOpinion!="" && spanObj == null) {
			//OA-33421  test01在公文督办中查看公文，发起人附言和处理意见没做区分，应在意见前面显示处理意见  
			document.getElementById("dealOpinionTitleDiv").style.display = '';
			//spanObj = document.getElementById("displayOtherOpinions");
			spanObj = $("#displayOtherOpinions");
			if(spanObj!=null) {
				spanObj.html(otherOpinion);
		        //spanObj.innerHTML=otherOpinion;
		        //spanObj.css("style", "display:block; width:100%; height:100%; border:0px; float:left;");
				spanObj.css("display", "block");
				spanObj.css("height", "100%");
				spanObj.css("width", "100%");
				spanObj.css("visibility", "visible");
				spanObj.css("float", "left");
				spanObj.css("align", "left");
				spanObj.css("text-align", "left");
		        //spanObj.style.cssText = "display:block; width:100%; height:100%; border:0px; float:left;";
		        //alert(spanObj.css("display"));
		        
		        /*spanObj.style.visibility="visible";
		        spanObj.style.height="100%";
		        spanObj.style.whiteSpace = "normal";
		        spanObj.contentEditable="false";
		        spanObj.style.border="0px";
		        spanObj.stylel.cssFloat = "left";*/
			}
		}
		
		/** 发起人意见 **/
		spanObj=opinionSpans.get("my:shangbao",null);
		if(spanObj!=null && senderOpinion!=null && senderOpinion!="") {
			//spanObj.innerHTML=senderOpinion;
			//spanObj.style.height="100%";
			//spanObj.style.whiteSpace = "normal";
			//公文单上面有意见显示位置时，隐藏公文单下面的意见
			spanObj=document.getElementById("displaySenderOpinoinDiv");
			if(spanObj!=null && isboundSender ){spanObj.innerHTML="";}
		}
		if(senderOpinion=="") {//没有发起意见,或者发起意见意见绑定到其它显示位置;
			spanObj=document.getElementById("displaySenderOpinoinDiv");
			if(spanObj!=null){spanObj.innerHTML="";}
		}
	}catch(e){}
	
}

/*
 * 处理处理意见和处理人字体大小一致
 */
function changeFontsize(opinion,spanObj){
  try{
    
    if(spanObj!=null&&spanObj!=undefined){
      if(spanObj.style.fontSize!=null&&spanObj.style.fontSize!="")
      {
        opinion = opinion.replace(new RegExp("<span",'gm'),"<span style='font-Size:"+spanObj.style.fontSize+";'");
      }
    }
    return opinion;
  }catch(e){}
}

function initNoteOpinionClick() {
	$("#uploadAttachmentSpan").click(function() {
		insertAttachmentPoi('NoteAtt');
	});
	$("#subbtton").click(function() {
		psSubmit();
	});
}

/**
 * 增加附言-提交，只刷新dialog中的页面。
 */
function psSubmit() {
	var nc = $("#noteContent");
	if(nc.val().trim().length ==0){
		$.alert($.i18n('collaboration.common.default.fuyanNotNull'));
		nc.focus();
		return;
	}
	var jsonSubmitCallBack = function() {
		var domains = [];
		domains.push("noteOpinion");
		domains.push("noteAttFileDomain");
		saveAttachmentPart("noteAttFileDomain");
        setTimeout(function() {
        	$("#noteForm").attr("action",  _path + "/info/infoDetail.do?method=saveNoteOpinion");
        	$("#noteForm").jsonSubmit({
                domains : domains,
                debug : true,
                callback: function(data) {
                	if(data=="success") {
                		closeInfoDealPage();
                	}
	           	}
            });
		}, 300);
    }
    jsonSubmitCallBack();
}

function noteSubmit() {
	var nc = $("#noteContent");
	if(nc.val().trim().length ==0){
		$.alert($.i18n('collaboration.common.default.fuyanNotNull'));
		nc.focus();
		return;
	}
	var jsonSubmitCallBack = function() {
		var domains = [];
		domains.push("noteOpinion");
		domains.push("noteAttFileDomain");
		saveAttachmentPart("noteAttFileDomain");
        setTimeout(function() {
        	$("#noteForm").attr("action",  _path + "/info/infoDetail.do?method=saveNoteOpinion");
        	$("#noteForm").jsonSubmit({
                domains : domains,
                debug : true,
                callback: function(data) {
                	if(data=="success") {
                		closeInfoDealPage();
                	}
	           	}
            });
		}, 300);
    }
    jsonSubmitCallBack();
}


function addReplySenderOpinion() {	
	initHtmlReplyOpinion = document.getElementById("noteOpinion").innerHTML;
	document.getElementById("noteOpinion").style.display = "block";
	var theForm = document.getElementsByName("noteForm")[0];
	theForm.noteContent.focus();
}

function cancelComment() {
	document.getElementById('noteContent').value='';
	document.getElementById('noteOpinion').style.display='none';
	deleteAllAttachment(0);
}
