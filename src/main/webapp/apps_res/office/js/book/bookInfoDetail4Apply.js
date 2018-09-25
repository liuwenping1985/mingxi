// js开始处理
$(function() {
  pTemp.bookInfoDiv = $("#bookInfoDiv");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.imgUpload = $("#imgUpload");
  pTemp.ajaxM = new bookApplyManager();
  showImage();
});

function fnPageInIt() {
  
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  pTemp.imgUpload.click(imageUpload);
}

function fnOK() {
  openProcePub();
  $("#bookInfoDiv").resetValidate();
  // var isAgree = pTemp.driverDiv.validate();
  // if (!isAgree) {// js校验
  // endProcePub();
  // return;
  // }
  var bookInfo = pTemp.bookInfoDiv.formobj();
  pTemp.ajaxM.isUniqBookInfo(bookInfo, {
    success : function(returnVal) {
      // if (!returnVal ) {// 系统人员已经重复
      // $.alert($.i18n('office.auto.alreadyexistschoose.js'));
      // endProcePub();
      // return;
      // }
      if (bookInfo.id && typeof (bookInfo.id) != 'undefined') {
        alert("fnUpdate");
      } else {
        fnNew(bookInfo);
      }
    }
  });
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