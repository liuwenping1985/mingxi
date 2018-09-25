// js开始处理
$(function() {
  pTemp.bookInfoDiv = $("#bookInfoDiv");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.imgUpload = $("#imgUpload");
  pTemp.imgCancel = $("#imgCancel");
  pTemp.ajaxM = new bookInfoManager();
  pTemp.isModfiy = false;
  fninitBookHouses();
  fnPageInIt();
});

function fnPageInIt() {
  fnInitCreate();
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.categoryDiv.disable();
  }
  pTemp.imgUpload.click(imageUpload);
  pTemp.imgCancel.click(initImage);
}

/**
 * 初始化默认图片
 */
function initImage() {
    var imgStr = "<img src='/seeyon/apps_res/office/images/book.jpg' width='150' height='180'/>";
    $("#imageDiv").get(0).innerHTML = imgStr;
    $("#bookImage").val("-99");
}

function fnOK() {
	var publishTime = $("#bookPublishTime").val();
	var _publishTime = publishTime.split("-"); 
	var d1 = new Date(_publishTime[0],_publishTime[1]-1,_publishTime[2]);
	var d2 = new Date();  
	if(d1>d2){
		alert($.i18n('office.bookinfo.date.check.js'));
		return;
	}
  openProcePub();
  $("#bookInfoDiv").resetValidate();
   var isAgree = pTemp.bookInfoDiv.validate();
   if (!isAgree) {// js校验
   endProcePub();
   return;
   }
  var bookInfo = pTemp.bookInfoDiv.formobj();
  pTemp.ajaxM.isUniqBookInfo(bookInfo, {
    success : function(returnVal) {
      if(returnVal){
        $.alert($.i18n('office.book.bookInfoEdit.czxttsbhqxg.js'));
        endProcePub();
        return;
      }
      if (bookInfo.id =='' || typeof (bookInfo.id) == 'undefined') {
        fnNew(bookInfo);
      } else {
        fnUpdate(bookInfo);
      }
    }
  });
}

function fnNew(bookInfo) {
  pTemp.ajaxM.save(bookInfo, {
    success : function() {
      $.infor($.i18n('office.book.bookInfoEdit.bccg.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.alert($.i18n('office.book.bookInfoEdit.bcsb.js'));
      endProcePub();
    }
  });
}
/*
 * 修改
 */
function fnUpdate(bookInfo) {
  pTemp.ajaxM.update(bookInfo, {
    success : function() {
      $.infor($.i18n('office.auto.savesuccess.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.alert($.i18n('office.auto.savefail.js'));
      endProcePub();
    }
  });
}
/**
 * 删除
 */
function fnDelete(rows) {
  var ids = new Array();;
  for(var i = 0; i < rows.length; i++){
    ids[i] = rows[i].id;
  }
  $.confirm({
    'msg' : $.i18n('office.auto.really.delete.js'),
    ok_fn : function() {
      pTemp.ajaxM.deleteByIds(ids, {
        success : function(returnVal) {
          if (returnVal == "true") {
            $.infor($.i18n('office.auto.delsuccess.js'));
          } else {
            $.alert(returnVal+$.i18n('office.book.bookInfoEdit.hysqjlbnsc.js'));
          }
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        },
        error : function() {
          $.alert($.i18n('office.auto.delfail.js'));
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        }
      });
    }      
  });
}

function fnInitCreate () {
	pTemp.isModfiy = false;
    pTemp.bookInfoDiv.clearform();
    //使用状态
    $("#bookState").val('0');
    initData();
    pTemp.bookInfoDiv.enable();
    pTemp.btnDiv.show();
    if (parent.pTemp.treeTempValue) {
		  $('#bookCategory').val(parent.pTemp.treeTempValue);
	} else {
		  $('#bookCategory').val(0);
	}
}

function fnShowDetail(type, row) {
  if (type == 'show') {
    pTemp.bookInfoDiv.fillform(row);	
    pTemp.bookInfoDiv.disable();
    showImage(row.bookType);
    pTemp.btnDiv.hide();
  }
  if (type == 'update') {
	pTemp.isModfiy = true;
    pTemp.bookInfoDiv.fillform(row);
    pTemp.bookInfoDiv.enable();
    showImage(row.bookType);
    pTemp.btnDiv.show();
    $("#bookNum").focus();
  }
}
function fnCancel() {
  if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.book.bookInfoEdit.qrfqdqcz.js'),
		    ok_fn: function () {
		    	pTemp.bookInfoDiv.clearform();
		    	parent.pTemp.tab.reSize("d");
		    	},
			cancel_fn:function(){return;}
		});
	}else{
		parent.pTemp.tab.reSize("d");
	}
}

/**
 * 上传图片
 */
function imageUpload() {
    dymcCreateFileUpload("dyncid", "13", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true,false,'5242880');
    insertAttachment();
}
/**
 * 上传图片回调函数
 * @param id
 */
function imageCallback(id) {
    //隐藏图片下面的垃圾回收站的图标
    $("#attachmentArea").hide();
    var fileUrl = id.get(0).fileUrl;
    var createDate = id.get(0).createDate || id.get(0).createdate;
    var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
    var path = _ctxServer;
    var url = " ";
    url = url + path + url1;
    var imgStr = "<img src='" + url + "' width='150' height='180'>";
    $("#imageDiv").get(0).innerHTML = imgStr; //页面显示图片
    $("#bookImage").val(fileUrl);//记录图片Url，以备修改时比较,不记录图片ID，是因为上传和回填是，生成ID不一致。
}

/**
 * 动态生成图书库
 */
function fninitBookHouses(){
  var bookHouses = pTemp.ajaxM.getAll('isBookAdmin');
  document.getElementById("houseId").innerHTML="";     //因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
  if(bookHouses!=null){
    for(var i = 0 ; i < bookHouses.length ; i ++) {
    	var text = bookHouses[i].text;
      $("#houseId").append("<option id='"+bookHouses[i].value+"' value='"+bookHouses[i].value+"' title='"+text+"'>"+text.getLimitLength(45,'...')+"</option>");
    }
  }else{
    $("#houseId").append("<option></option>");         //用品库默认为空
  }
}
/**
 * 回填图片
 */
function showImage(type) {
  if($("#bookImage").val() != 'null'){
    var atts = pTemp.ajaxM.getAttachment($("#bookImage").val());
  }
  if( atts && typeof(atts.id) != 'undefined' && atts.id != ''){
    var fileUrl = atts.fileUrl;
    var createDate = atts.createdate;
    var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
    var path = _ctxServer;
    var url = " ";
    url = url + path + url1;
    var imgStr = "<img src='" + url + "' width='150' height='180'>";
    $("#imageDiv").get(0).innerHTML = imgStr;
    $("#bookImage").val(fileUrl);//如果修图书信息时，没有重新上传图片，根据fileUrl，则不删除附件信息。
  }else{
    creatImgByType(type);
  }
}
//初始化数据，针对IE10，IE11下拉框不会自动填写第一条数据
 function initData(){
   if (ferIE10()) {
     $("select[id=bookType] option[value=0]").attr('selected','selected');
    if (document.getElementById('houseId').firstChild) {
      document.getElementById('houseId').firstChild.setAttribute('selected',
          'selected');
    }
    if (document.getElementById('bookCategory').firstChild) {
      document.getElementById('bookCategory').firstChild.setAttribute(
          'selected', 'selected');
    }
    if (document.getElementById('bookState').firstChild) {
      document.getElementById('bookState').firstChild.setAttribute('selected',
          'selected');
    }
  }
  initImage();
 }
 
 //验证是否为IE10/IE11
 function ferIE10(){
   var userAgent = navigator.userAgent; 
   var isOpera = userAgent.indexOf("Opera") > -1;
   var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera ;
   if(isIE){
     var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
     reIE.test(userAgent);
     var fIEVersion = parseFloat(RegExp["$1"]);
     var IE9 = fIEVersion == 9 ;
     var IE10 = fIEVersion == 10.0 ;
     var IE11 = fIEVersion == 11.0 ;
     if(IE9||IE10||IE11){
       return true;
     }else{
       return false;
     }
   }
   return false;
 }
 
 $('#bookType').live("change",function () {
	 creatImgByType($(this).val());
 })
 
 function creatImgByType (type) {
	 var src = "/seeyon/apps_res/office/images/book.jpg";
	 if (type != '0') {
		 src = "/seeyon/apps_res/office/images/book1.png";
	 }
	  var imgStr = "<img src='" + src + "' width='150' height='180'/>";
	  $("#imageDiv").get(0).innerHTML = imgStr;
 }
 