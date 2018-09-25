// js开始处理
$(function() {
  autoMan = new autoInfoManager();
//=====加载数据=========
  $('#ajaxgridbar').ajaxgridbar({
      managerName : 'autoApplyManager',
      managerMethod : 'findAutoByApplyIdAndTime',
      callback : function(fpi) {
          var ul = $('#display_image');
          ul.html("");
          var strHtml = new StringBuffer();
          //alert(fpi.data.length);
          for ( var i = 0, len = fpi.data.length; i < len; i++) {
              var o = fpi.data[i];
              var hrStr = "";
              stringAutoPernum="";
              if(o.autoPernum!=null){
                stringAutoPernum = o.autoPernum+"座 ";
              }
              switch(o.state)
              {
              case 1:
                o.statejs = $.i18n('office.autouse.state1.js');
                o.radioable = "";
                break;
              case 2:
                o.statejs = $.i18n('office.autouse.state2.js');
                o.radioable = "";
                break;
              case 3:
                o.statejs = $.i18n('office.autouse.state3.js');
                o.radioable = "disabled";
                break;
              case 4:
                o.statejs = $.i18n('office.autouse.state3.js');
                o.radioable = "disabled";
                break;
              default:
                o.statejs = $.i18n('office.autouse.state3.js');
                o.radioable = "disabled";
              }
              imgsrc = getImage(o.autoImage);
              var liStr = hrStr + "<li class='hand align_center'>" +
              		"<input name=\"option\" "+o.radioable+" class=\"radio_com\" id="+o.id+" type=\"radio\" value="+o.id+"><img width='292' style='vertical-align:middle' class='imageBorder' height='185' src=\""+imgsrc+"\" onclick=selectAuto(\""+o.id+"\")><p>"
                  +o.autoNum+" "+stringAutoPernum+o.statejs +" "+"<a href='javascript:void(0)' class='noClick' onclick='viewAuto(\""+o.id+"\")'>"+$.i18n('office.auto.car.use.amount.js')+"</a>"+"</p></li>";
              var imputhidden = "<input id='state"+o.id+"' type='hidden' value="+o.state+">"
              +"<input id='autoPernum"+o.id+"' type='hidden' value="+o.autoPernum+">"
              +"<input id='autoNum"+o.id+"' type='hidden' value=\""+o.autoNum+"\">"
              +"<input id='memberId"+o.id+"' type='hidden' value="+o.memberId+">"
              +"<input id='memberName"+o.id+"' type='hidden' value="+o.memberName+">"
              +"<input id='accountId"+o.id+"' type='hidden' value="+o.accountId+">"
              +"<input id='phoneNumber"+o.id+"' type='hidden' value="+o.phoneNumber+">";
              strHtml.append(liStr+imputhidden);
          }
          ul.html(strHtml.toString());
          $('#_afpPage').val(fpi.page);
          $('#_afpPages').val(fpi.pages);
          $('#_afpSize').val(fpi.size);
          $('#_afpTotal').val(fpi.total);
      }
  });
  var param =getParam();
  $('#ajaxgridbar').ajaxgridbarLoad(param);
});

/**
 * 获取imageUrl
 */
function getImage(autoId) {
  var imgStr ="/seeyon/apps_res/office/images/car.jpg";
  var atts = autoMan.getAttachment(autoId);
  if(typeof(atts.id) != 'undefined' && atts.id != -1){
    var fileUrl = atts.fileUrl;
    var createDate = atts.createdate;
    var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
    var path = _ctxServer;
    var url = " ";
    url = url + path + url1;
    imgStr = url;
  }
  return imgStr;
}

function selectAuto(id){
	if ($("#"+id).attr('disabled') != 'disabled') {
	  $("#"+id).attr("checked",'checked');
	}
}

function fnPageReload(o){
  if(o){
  }else{
    var o  = getParam();
  }
  $('#ajaxgridbar').ajaxgridbarLoad(o);
}

/**
 * 车辆占用情况查看
 */
function viewAuto(id){
var url = "/office/autoUse.do?method=autoUseState&autoId="+id;
var dialog = $.dialog({
  id : "autoView",
  url :_path+ url,
  title : $("#autoNum"+id).val()+$.i18n('office.auto.car.use.amount.js'),
  width : $(getCtpTop()).width()*0.8 ,height : $(getCtpTop()).height()*0.7,
  targetWindow : getCtpTop()
});
}

function OKList(){
  var id = $("input[type='radio']:checked").val();
  if(!id){
      $.alert($.i18n('office.please.select.car.js'));
  }else{
    var o = new Object();
    o.id = id;
    o.autoNum = $("#autoNum"+o.id).val();
    o.row ={"state":$("#state"+o.id).val(),"autoPernum":$("#autoPernum"+o.id).val(),"accountId":$("#accountId"+o.id).val(),
        "autoNum":$("#autoNum"+o.id).val(),"memberId":$("#memberId"+o.id).val(),
        "memberName":$("#memberName"+o.id).val()=="null"?"":$("#memberName"+o.id).val(),"phoneNumber":$("#phoneNumber"+o.id).val()=="null"?"":$("#phoneNumber"+o.id).val()}
    return o;
  }
}
