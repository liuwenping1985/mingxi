// js开始处理
$(function() {
  pTemp.bookApplyDiv = $("#bookApply");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.imgUpload = $("#imgUpload");
  
  pTemp.ajaxM = new bookApplyManager();
  
  showImage();
  $("#recordDate0Div").disable();
  $("#recordDate1Div").disable();
  $("#lendedDateDiv").disable();
  if($("#bookApplyStateFlag").val() == '30'){
	  $("#rebackDateDiv").disable();
	  $("#rebackDate").disable();
  }
  
});
function fnPageInIt() {
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  pTemp.imgUpload.click(imageUpload);
}

function fnOK(flag) {
	var bookParam = new Object();
	bookParam.flag = flag;
	bookParam.applyId = $("#id").val();
	bookParam.auditFlag = "remand";
	bookParam.rebackDate = $("#rebackDate").val();
	
	var rebackDate = $("#rebackDate").val();
	
	if(rebackDate==""){
		$.infor({
    		'type': 0,
    	    'msg': $.i18n('office.book.bookInfoDetail4Remand.ghrqbnwk.js'),
    	    'imgType':2
		});
		return;
	}
	var lended = $("#lendedDate").val();
	var d2 = fnParseDatePub(rebackDate);
	var d1 = fnParseDatePub(lended);
	if(d1.getTime() > d2.getTime()){
		$.infor({
    		'type': 0,
    	    'msg': $.i18n('office.book.bookInfoDetail4Remand.ghrqbxdydyjcrq.js'),
    	    'imgType':2
		});
		return;
	}
//	if(d2.getTime()>new Date().getTime()){
//		$.infor({
//    		'type': 0,
//    	    'msg': "归还日期必须小于等于当前时间！ ",
//    	    'imgType':2
//		});
//		return;
//	}
	
	
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
				$.infor({
	        		'type': 0,
	        	    'msg': msg,
	        	    'imgType':2,
	        	    ok_fn: fnCloseAndRefresh
				});
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
	fnReloadPagePub({page:"bookRemand"});
	fnAutoCloseWindow();
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