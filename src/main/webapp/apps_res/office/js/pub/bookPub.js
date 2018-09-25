/**
 * @param opt{type:[manager,driver],value:}
 * @returns {text:,id:}
 */
function fnSelectPeoplePub(opt){
  var width = 300;
  var _title = '图书管理员';
  if(opt.type==="BookMember"){
    _title = '图书管理员';
  } 
  if (opt.width) {
    width = opt.width;
  }
  var dialog = $.dialog({
    id : "bookMember",
    url :_path+"/office/bookSet.do?method=bookSelectPeople",
    width : width,
    height : 300,
    targetWindow : getCtpTop(),
    transParams : {type:opt.type,value:opt.value},  //传给子页面
    title : _title,
    buttons : [
        {id : "sure",text : $.i18n('calendar.sure'),
        	isEmphasize:true,
          handler : function() {
            if (typeof (fnSelectPeople) !== 'undefined') {
              fnSelectPeople({dialog : dialog,okParam : dialog.getReturnValue(),type:opt.type}); //dialog对象、弹出框页面返回值、操作类型：manager、driver
            }
          }
        },
        {id : "cancel",text : $.i18n('calendar.cancel'),
          handler : function() {dialog.close();}
        }]
  });
}

/**
 * 回填图片
 */
function showImage() {
	var bookType = $('#bookType').val();
	var atts = pTemp.ajaxM.getAttachment($("#bookImage").val());
	if(typeof(atts.id) != 'undefined' && atts.id != -1){
		var fileUrl = atts.fileUrl;
		var createDate = atts.createdate;
		var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
		var path = _ctxServer;
		var url = " ";
		url = url + path + url1;
		var imgStr = "<img src='" + url + "' width='150' height='180'>";
		$("#imageDiv").get(0).innerHTML = imgStr;
		$("#bookImage").val(fileUrl);//如果修改车辆信息时，没有重新上传图片，根据fileUrl，则不删除附件信息。
	}else{
		initImage(bookType);
	}
}

/**
 * 初始化默认图片
 */
function initImage(bookType) {
	  var src = "/seeyon/apps_res/office/images/book.jpg";
	  if (bookType != '0') {
		  src = "/seeyon/apps_res/office/images/book1.png";
	  }
	  var imgStr = "<img src='" + src + "' width='150' height='180'/>";
	  $("#imageDiv").get(0).innerHTML = imgStr;
}

//兼容IE 6下新增，修改 空白页面
function ferIframe(editIframe){
    var userAgent = navigator.userAgent; 
    var isOpera = userAgent.indexOf("Opera") > -1;
    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera ;
    if(isIE){
      var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
      reIE.test(userAgent);
      var fIEVersion = parseFloat(RegExp["$1"]);
      var IE6 = fIEVersion == 6.0 ;
      if(IE6){
        window.frames[editIframe].location = frames[editIframe].location.href;
      }
    }
}