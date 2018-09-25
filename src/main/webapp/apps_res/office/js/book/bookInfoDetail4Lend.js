// js开始处理
$(function() {
  pTemp.bookInfoDiv = $("#bookInfoDiv");
  
  pTemp.bookApplyDiv = $("#bookApply");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.imgUpload = $("#imgUpload");
  
  pTemp.ajaxM = new bookApplyManager();
  showImage();
  $("#recordDate0Div").disable();
  $("#recordDate1Div").disable();
  if($("#bookApplyStateFlag").val() == '10'){
	  $("#lendDateDiv").disable();
	  $("#lendDate").disable();
  }
});


function fnPageInIt() {
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  pTemp.imgUpload.click(imageUpload);
}

function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
}

function fnOK(flag) {
    pTemp.bookInfoDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.bookInfoDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    
    var lendDate = $("#lendDate").val();
	var d1 = fnParseDatePub(lendDate);
	var d2 = new Date();
//	if(flag=="lend" && d1.getTime() < d2.getTime()){
//		$.infor({
//    		'type': 0,
//    	    'msg': "开始日期必须大于等于当前日期！ ",
//    	    'imgType':2
//		});
//		return;
//	}
    
	var bookParam = new Object();
	bookParam.flag = flag;
	bookParam.applyId = $("#id").val();
	bookParam.auditFlag = "lend";
	bookParam.lendDate = $("#lendDate").val();
	bookParam.applyTotal = $("#applyTotal").val();
	if (flag == 'lend') {
		var applyTotal = $('#applyTotal').val();
		if (applyTotal != '' && parseInt(applyTotal) <=0) {
			$.alert($.i18n('office.book.bookInfoDetail4Lend.jyslbxdydy.js'));
			return ;
		}
		var recordDate1 = $('#recordDate1').val();
		var lendDate = $('#lendDate').val();
		if (!lendDate || lendDate == '') {
			if (recordDate1 != '' && fnDateParse(recordDate1).getTime() < new Date().getTime()) {
				$.alert($.i18n('office.book.bookInfoDetail4Lend.ycgjyqjqzxfqjysq.js'));
				return ;
			}
		} else {
			if (recordDate1 != '' && fnDateParse(recordDate1).getTime() < fnDateParse(lendDate).getTime()) {
				$.alert($.i18n('office.book.bookInfoDetail4Lend.ycgjyqjqzxfqjysq.js'));
				return ;
			}
		}
	}
	pTemp.ajaxM.auditBookApply(bookParam,{
		success : function(returnMap) {
			if (returnMap.flag) {
				var msg = returnMap.result;
				$.infor({
	        		'type': 0,
	        	    'msg': msg,
	        	    'imgType':0,
	        	    ok_fn: fnCloseAndRefresh
				});
			} else {
				var msg = returnMap.result;
				if (returnMap.isClose){
					$.infor({
		        		'type': 0,
		        	    'msg': msg,
		        	    'imgType':2
					});
				} else {
					$.infor({
		        		'type': 0,
		        	    'msg': msg,
		        	    'imgType':2,
		        	    ok_fn: fnCloseAndRefresh
					});
				}
			}
		},
		error : function(rval) {
			endProcePub();
			var msg = $.i18n('office.book.bookInfoDetail4Remand.czsb.js'),type = 'error';
			fnMsgBoxPub(msg,type,function(){
				fnReloadPagePub({page:"bookLend"});
					fnAutoCloseWindow();
				});
		}
	});

}

function fnCloseAndRefresh(){
	fnReloadPagePub({page:"bookLend"});
	fnAutoCloseWindow();
}
function fnNew(bookInfo) {
  pTemp.ajaxM.save(bookInfo, {
    success : function() {
      $.infor($.i18n('office.auto.savesuccess.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.infor($.i18n('office.auto.savefail.js'));
      endProcePub();
    }
  });
}
function fnShowDetail(type, row) {
  if (type == 'add') {
    pTemp.bookInfoDiv.clearform();
    pTemp.bookInfoDiv.enable();
  }
}
function fnCancel() {
  alert("fnCancel");
}

/**
 * 上传图片
 */
function imageUpload() {
    dymcCreateFileUpload("dyncid", "13", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true,false,'5120000');
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
    var imgStr = "<img src='" + url + "' width='292' height='185'>";
    $("#imageDiv").get(0).innerHTML = imgStr; //页面显示图片
    $("#bookImage").val(fileUrl);//记录图片Url，以备修改时比较,不记录图片ID，是因为上传和回填是，生成ID不一致。
}

/**
 * 动态生成图书库
 */
function fninitBookHouses(){
  var bookHouses = pTemp.ajaxM.getAll();
  document.getElementById("houseId").innerHTML="";     //因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
  if(bookHouses!=null){
    for(var i = 0 ; i < bookHouses.length ; i ++) {
      $("#houseId").append("<option id='"+bookHouses[i].value+"' value='"+bookHouses[i].value+"'>"+bookHouses[i].text+"</option>");
    }
  }else{
    $("#houseId").append("<option></option>");         //用品库默认为空
  }
  
}