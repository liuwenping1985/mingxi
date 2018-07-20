<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="./listCol_js.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=voucherManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
	var total = '${ctp:i18n("info.totally")}';
	var pManager = new voucherManager();
	var toolbar = $("#toolbar").toolbar({
	    toolbar: [{
	      id: "generate",
	      name: '${ctp:i18n("voucher.plugin.make.label")}',
	      className: "ico16",
	      click: generate
	    },{
            id: "delete",
            name: "${ctp:i18n('common.button.delete.label')}",
            className: "ico16 del_16",
            click: function() {
            	var v = $("#mytable").formobj({
                    gridFilter : function(data, row) {
                      return $("input:checkbox", row)[0].checked;
                    }
                  });
                if (v.length < 1) {
                	$.alert("${ctp:i18n('level.delete')}");
                } else {
                    $.confirm({
                        'msg': "${ctp:i18n('voucher.plugin.cfg.sure.delete')}",
                        ok_fn: function() {
                        	var vManager = new voucherManager();;
                        	vManager.updateVoucherState(v, {
                                success: function() {
                                	$.infor("${ctp:i18n('voucher.plugin.generate.delete.success')}");
                                	$("#mytable").ajaxgridLoad(o1);
                                    $("#welcome").show();
                                }
                            });
                        }
                    });
                };
            }
        }]
	  });
    //列表
    var grid = $("#mytable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'summaryId',
            width: '10%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display: '${ctp:i18n("common.subject.label")}',//标题
            name: 'subject',
            sortname : 'summary.subject',
            sortable : true,
            width: '35%'
        }
        ,
        {
            display: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
            name: 'startMemberName',
            sortname : 'affair.senderId',
            sortable : true,
            width: '15%'
        }
        , 
        {
            display: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
            name: 'createDate',
            sortname : 'summary.createDate',
            sortable : true,
            width: '20%'
        },
        {
            display: '${ctp:i18n("common.date.donedate.label")}',//处理时间
            name: 'updateDate',
            sortname : 'affair.updateDate',
            sortable : true,
            width: '20%'
        }
        ],
        width: "auto",
        managerName: "voucherManager",
        managerMethod: "showBindCollaborationList",
        parentId:'center',
        slideToggleBtn: true,
        callBackTotle:getCount,
        vChange: true   
    });
    //加载表格
    var o1 = new Object();
    o1.isDone = $("#isDone").val();
    $("#mytable").ajaxgridLoad(o1);
    mytable.grid.resizeGridUpDown('middle');
    var searchobj = $.searchCondition({
    top: 1,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      if(ssss!=null){
    	  ssss.isDone = $("#isDone").val();
          $("#mytable").ajaxgridLoad(ssss);
      }
    },
    conditions: [{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: '${ctp:i18n("common.subject.label")}',
      value: 'subject'
    } ,{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: '${ctp:i18n("cannel.display.column.sendUser.label")}',
      value: 'startMemberName'
    },{
      id: 'search_createDate',
      name: 'search_createDate',
      type: 'datemulti',
      text: "${ctp:i18n('common.date.sendtime.label')}",
      value: 'createDate',
      ifFormat:'%Y-%m-%d',
      dateTime: false
    },{
      id: 'search_updateTime',
      name: 'search_updateTime',
      type: 'datemulti',
      text: "${ctp:i18n('common.date.donedate.label')}",
      value: 'updateDate',
      ifFormat:'%Y-%m-%d',
      dateTime: false
    }]
  });
    function getCount(){
    	$("#count")[0].innerHTML = total.format(mytable.p.total);
  	}
});
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_10104_voucherGenerateIndex'"></div>
        <div class="layout_north" layout="height:30,sprit:false,border:false">
        	<div id="toolbar"></div>
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div id="grid_detail" class="relative" style="overflow-y:hidden">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height">
                	<div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">
                                    	${ctp:i18n("voucher.plugin.make")}
                                    </h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                	${ctp:i18n("voucher.vou_detail")}
                                </div>
                            </div>
                     </div>              
                </div>
            </div>
        </div>
            <input type="hidden" id="isDone" name="isDone" value="${isDone}"/>
    </div>
    <form hidden="hidden" id="downLoad" action="${path}/voucher/voucherController.do?method=downLoad"  method="post">
    	<input type="hidden" id="result" name="result" value="">
	</form>
</body>
</html>