// js开始处理
$(function() {
    // 列表table初始化
    pTemp.tab = officeTab().addAll([ "id", "autoNum", "autoType", "category", "autoBrand","autoModel", "autoPernum", "state", "OrderMsg" ])
    .init("autoOrderList", {
      argFunc : "fnOrderListItems",
      parentId : $('.layout_center').eq(0).attr('id'),
      resizable : false,// 明细页面的分隔条
      render: rend,
      onSuccess:changeRadio,
      "managerName" : "autoApplyManager",
      "managerMethod" : "findAutoByApplyIdAndTime"
    });
    
    var param =getParam();
    pTemp.tab.load(param);
    pTemp.ajaxM = new autoApplyManager();
});

function fnPageReload(param){
  if(param){
  }else{
    var param = getParam();
  }
  pTemp.tab.load(param);
}
/**
 * 渲染回调函数
 */
function changeRadio(){
  var rows = pTemp.tab.datas().rows;
  for(var i= 0 ; i< rows.length;i++){
    if(rows[i].state!=1 && rows[i].state!=2){
      pTemp.tab.disableRow(rows[i].id);
    }
  }
  
  /*
  $("#autoOrderList").find("td div").each(function(index){
  	if(index==2){
  		alert($(this).text());
  	}
  		var _text = $(this).text()==null ? "":$(this).text();
  		_text = "<span class='grid_black'>"+_text+"</span>";
  		$(this).html(_text);
  });
  */
  
}

function rend(txt,data, r, c) {
	var _text = txt==null?"":txt;
  if (c == 8){
  	_text = "<a href='javascript:void(0)' class='noClick' onclick='viewAuto(\""+data.id+"\",\""+data.autoNum+"\")' objState="+data.state+" objId="+data.id+">"+$.i18n('office.auto.occupancy.js')+"</a>";
  }
  return "<span class='grid_black'>"+_text+"</span>";
}

/**
 * 车辆占用情况查看
 */
function viewAuto(autoId,autoNum){
var url = "/office/autoUse.do?method=autoUseState&autoId="+autoId;
var dialog = $.dialog({
  id : "autoView",
  url :_path+ url,
  title : autoNum + $.i18n('office.auto.car.use.amount.js'),
  width : $(getCtpTop()).width()*0.8 ,height : $(getCtpTop()).height()*0.7,
  targetWindow : getCtpTop()
});
}

/**
 * 页面初始化
 */
function fnPageInIt() {
}

function OKList(){
  var rows = pTemp.tab.selectRows();
  if(rows.length == 0){
      $.alert($.i18n('office.please.select.car.js'));
  }else if(rows.length > 1){
      $.alert($.i18n('office.auto.select.car.only.one.js'));
  }else{
    var o = new Object();
    o.id = rows[0].id;
    o.autoNum = rows[0].autoNum;
    //此处不能改，应该返回更多的数据,如果修改，请通知muyx
    o.row =  rows[0];
    return o;
  }
}

/**
 * 页面样式控制
 */
function fnSetCss() {
}

/**
 * 车辆列表数据初始化
 */
function fnOrderListItems() {
  return {
    "id" : {
      display : 'id',
      name : 'id',
      width : '5%',
      sortable : false,
      align : 'center',
      type : 'radio'
    },
    "autoNum" : {
      display : $.i18n('office.auto.num.js'),
      name : 'autoNum',
      width : '20%',
      sortable : true,
      align : 'left'
    },
    "autoType" : {
      display : $.i18n('office.auto.type.js'),
      name : 'autoType',
      width : '12%',
      sortable : true,
      align : 'left',
      codecfg:"codeId:'office_auto_type'"
    },
    "category" : {
      display : $.i18n('office.auto.group.js'),
      name : 'category',
      width : '15%',
      sortable : true,
      align : 'left'
    },
    "autoBrand" : {
      display : $.i18n('office.auto.name.js'),
      name : 'autoBrand',
      width : '8%',
      sortable : true,
      align : 'left'
    },
    "autoModel" : {
      display : $.i18n('office.auto.model.js'),
      name : 'autoModel',
      width : '12%',
      sortable : true,
      align : 'left'
    },
    "autoPernum" : {
      display : $.i18n('office.auto.sitsum.js'),
      name : 'autoPernum',
      width : '7%',
      sortable : true,
      align : 'left'
    },
    "state" : {
      display : $.i18n('office.asset.query.state.js'),
      name : 'state',
      width : '10%',
      sortable : true,
      align : 'left',
      codecfg:"codeType:'java',codeId:'com.seeyon.apps.office.constants.AutoUseStateEnum'"
    },
    "OrderMsg" : {
      display : $.i18n('office.auto.car.use.amount.js'),
      name : 'OrderMsg',
      width : '8%',
      sortable : true,
      align : 'left'
    }
  };
  
}