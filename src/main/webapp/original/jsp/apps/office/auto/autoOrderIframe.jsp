<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.auto.autoStcInfo.xzcl.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
useDate = new Object();
useDate.applyOuttime = "";
useDate.applyBacktime = "";
var searchobj; 
/**
 * 刷新并清空查询条件
 */
 
 function fnRefresh(_this){
   fnTabToggle(_this);
   if(searchobj){
    searchobj.g.clearCondition();
   }
}
/**
 * 用车时间联动
 */
  function renewAuto() {
    if ($(".current")[0].id == 'list') {
      var o = $("#listAuto")[0].contentWindow.getParam();
    }
    if ($(".current")[0].id == 'image') {
      var o = $("#imageAuto")[0].contentWindow.getParam();
    }
    o.beginDate = $("#beginDate").val();
    o.endDate = $("#endDate").val();
    if (o.beginDate === "" && o.endDate === "") {
      $.alert($.i18n('office.auto.use.time.not.null.js'));
      $("#beginDate").val(useDate.applyOuttime);   //如果现在用户选着的时间不合法，就将上一次的时间赋值过来。
   	  $("#endDate").val(useDate.applyBacktime);
      return;
    }
    if (o.beginDate === "") {
      $("#beginDate").val(useDate.applyOuttime);
      $.alert($.i18n('office.auto.use.start.time.not.null.js'));
      return;
    }

    if(o.endDate != ""){
   		if (o.beginDate >= o.endDate) {
    		$.alert($.i18n('office.auto.use.end.time.error.js'));
    		$("#beginDate").val(useDate.applyOuttime);
    		$("#endDate").val("");
    		return;
    	}
    }
  
    useDate.applyOuttime = o.beginDate;
    useDate.applyBacktime = o.endDate;

    if ($(".current")[0].id == 'list') {
      $("#listAuto")[0].contentWindow.fnPageReload(o);
    }
    if ($(".current")[0].id == 'image') {
      $("#imageAuto")[0].contentWindow.fnPageReload(o);
    }
  }

  function OK() {
	var endDate = $("#endDate").val();
	if(endDate == ""){
		return "nullEndDate";
	}
    var oldApplyOuttime = "${param.applyOuttime}";
    var oldApplyBacktime = "${param.applyBacktime}";

    if ($(".current")[0].id == 'image') {
      v = $("#imageAuto")[0].contentWindow.OKList();
      if (useDate.applyOuttime !== "" && useDate.applyBacktime !== "" && v) {
        v.applyOuttime = useDate.applyOuttime;
        v.applyBacktime = useDate.applyBacktime;
        v.oldApplyOuttime = oldApplyOuttime;
        v.oldApplyBacktime = oldApplyBacktime;
      }
      return v;
    } else if ($(".current")[0].id == 'list') {
      v = $("#listAuto")[0].contentWindow.OKList();
      if (useDate.applyOuttime !== "" && useDate.applyBacktime !== "" && v) {
        v.applyOuttime = useDate.applyOuttime;
        v.applyBacktime = useDate.applyBacktime;
        v.oldApplyOuttime = oldApplyOuttime;
        v.oldApplyBacktime = oldApplyBacktime;
      }
      return v;
    }
  }

  $(document).ready(function() {
    $("#beginDate").val("${param.applyOuttime}");
    $("#endDate").val("${param.applyBacktime}");
    //OA-54423 先记录一次时间
    useDate.applyOuttime = $("#beginDate").val();
    useDate.applyBacktime = $("#endDate").val();
    searchobj = $.searchCondition({
      right : 17,
      top:5,
      searchHandler : function() {
        if ($(".current")[0].id == 'list') {
          var o = $("#listAuto")[0].contentWindow.getParam();
        }
        if ($(".current")[0].id == 'image') {
          var o = $("#imageAuto")[0].contentWindow.getParam();
        }
        var choose = $('#' + searchobj.p.id).find("option:selected").val();
        if (choose === 'autoNum') {
          o.autoNum = $('#autoNum').val();
        } else if (choose === 'autoBrand') {
          o.autoBrand = $('#autoBrand').val();
        } else if (choose === 'autoPernum') {
          o.autoPernum = $('#autoPernum').val();
          if (isNaN(o.autoPernum)) {
            $.alert($.i18n('office.auto.input.check.number.js'));
            return;
          }
        }

        o.beginDate = $("#beginDate").val();
        o.endDate = $("#endDate").val();
        if (o.beginDate === "" && o.endDate === "") {
          $.alert($.i18n('office.auto.use.time.not.null.js'));
          return;
        }
        if (o.beginDate === "") {
          $.alert($.i18n('office.auto.use.start.time.not.null.js'));
          return;
        }
//         if (o.endDate === "") {
//           $.alert($.i18n('office.auto.use.end.time.not.null.js'));
//           return;
//         }
//         if (o.beginDate >= o.endDate) {
//           $.alert($.i18n('office.auto.use.end.time.error.js'));
//           return;
//         }

        useDate.applyOuttime = o.beginDate;
        useDate.applyBacktime = o.endDate;

        var val = searchobj.g.getReturnValue();
        if (val !== null) {
          if ($(".current")[0].id == 'list') {
            $("#listAuto")[0].contentWindow.fnPageReload(o);
          }
          if ($(".current")[0].id == 'image') {
            $("#imageAuto")[0].contentWindow.fnPageReload(o);
          }
        }
      },
      conditions : [ {
        id : 'autoNum',
        name : 'autoNum',
        type : 'input',
        text : '${ctp:i18n('office.auto.autoStcInfo.cph.js')}',
        value : 'autoNum'
      }, {
        id : 'autoBrand',
        name : 'autoBrand',
        type : 'input',
        text : '${ctp:i18n('office.asset.apply.assetBrand.js')}',
        value : 'autoBrand'
      }, {
        id : 'autoPernum',
        name : 'autoPernum',
        type : 'input',
        text : '${ctp:i18n('office.auto.sitsum.js')}',
        value : 'autoPernum'
      } ]
    });
  });
</script>
<style type="text/css">
    .bodyColor {
        background-color: #f8f8f8;
    }
    .frameColor {
        background-color: #ffffff;
    }
    .margin_r_30 {
        margin-right: 30px;
    }
    .stadic_head_height{
        height:35px;
    }
    .stadic_body_top_bottom{
        bottom: 0px;
        top: 35px;
    }
</style>
</head>
<body class="h100b over_hidden bodyColor">
<div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height" style="overflow: hidden;">
    <div class="margin_5">
      <ul style="margin-left: 20px;">
        <li>
         <div class="margin_l_5 clearfix align_left font_size12 left margin_r_30" ><label for="text">${ctp:i18n('office.autoapply.udate.js')}:</label>
           <input id="beginDate" class="comp font_size12 validate" style="width:160px" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:renewAuto,isClear:true,clearBlank:false" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly/>
              <span class="margin_r_5 margin_t_5">-</span> 
           <input id="endDate" class="comp validate font_size12" style="width:160px" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:renewAuto,isClear:true,clearBlank:false" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly/>
         </div>
         <div id="searchDiv"></div>
        </li>
      </ul>
    </div>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom" style="overflow: hidden;" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul style="margin-left: 20px;">
          <li class="current" id ="image" ><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnRefresh(this);" tgt="imageAuto"><span>${ctp:i18n('office.stock.card.view.js')}</span> </a></li>
          <li id ="list" ><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnRefresh(this);" tgt="listAuto"><span>${ctp:i18n('office.stock.list.view.js')}</span> </a></li>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <iframe id="imageAuto" class="calendar_show_iframe frameColor" border="0" src="" frameBorder="0" width="100%"></iframe>
        <iframe id="listAuto" class="calendar_show_iframe frameColor" name ="listAuto" border="0" frameBorder="0" width="100%" src=""></iframe>
        <script>
            var _applyUserId = '${param.applyUserId}';
            var src1 = "${path}/office/autoUse.do?method=autoOrderImage&applyUserId="+ encodeURI(_applyUserId) +"&applyOuttime=${param.applyOuttime}&applyBacktime=${param.applyBacktime}&isAdmin=${param.isAdmin}";
            var src2 = "${path}/office/autoUse.do?method=autoOrderList&applyUserId="+ encodeURI(_applyUserId) +"&applyOuttime=${param.applyOuttime}&applyBacktime=${param.applyBacktime}&isAdmin=${param.isAdmin}";
            document.getElementById("imageAuto").setAttribute("src",src1);
            document.getElementById("listAuto").setAttribute("src",src2);
        </script>
      </div>
    </div>
    </div>
</div>
</body>
</html>