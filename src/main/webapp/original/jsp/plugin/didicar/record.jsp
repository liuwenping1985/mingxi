<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=didicarManager"></script>
<html:link renderURL='/genericController.do?ViewPage=plugin/didicar/comQuery' var="genericController" />
<script type="text/javascript">

var searchobj;
var singleS;
$().ready(function() {
    
    if("${error}"!=null && "${error}"!=""){
        $.alert("${error}");
    }
    $("#toolbar").toolbar({
        toolbar: [{
            id: "export",
            name: "${ctp:i18n('didicar.plugin.record.export')}",
            className: "ico16 import_16",
            click:downLoadData
        }]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,       
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        colModel: [
        {
            /*乘车人*/
            display: "${ctp:i18n('didicar.plugin.record.passenger')}",
            sortable: true,
            name: 'name',
            width: '6%'
        },
        {
            /*所属部门*/
            display: "${ctp:i18n('didicar.plugin.record.deptName')}",
            sortable: true,
            name: 'deptName',
            width: '10%'
        },
        {
            /*手机号*/
            display: "${ctp:i18n('didicar.plugin.record.mobile')}",
            sortable: true,
            name: 'mobile',
            width: '8%'
        },
        {
            /*叫车时间*/
            display: "${ctp:i18n('didicar.plugin.record.boardingTime')}",
            sortable: true,
            name: 'boardingTime',
            width: '12%'
        },
        {
            /*出发地*/
            display: "${ctp:i18n('didicar.plugin.record.departure')}",
            sortable: true,
            name: 'startAddress',
            width: '17%'
        },
        {
            /*目的地*/
            display: "${ctp:i18n('didicar.plugin.record.destination')}",
            sortable: true,
            name: 'endAddress',
            width: '17%'
        },
        {
            /*金额*/
            display: "${ctp:i18n('didicar.plugin.record.money')}",
            sortable: true,
            name: 'totalPrice',
            width: '5%'
        },
        {
            /*车辆用途*/
            display: "${ctp:i18n('didicar.plugin.order.from')}",
            sortable: true,
            name: 'orderFrom',
            width: '10%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.didicar.util.OrderFrom'"
        },
        {
            /*状态*/
            display: "${ctp:i18n('didicar.plugin.record.status')}",
            sortable: true,
            name: 'status',
            width: '8%'
        },
        {
            /*实时预约*/
            display: "${ctp:i18n('didicar.plugin.record.calltype')}",
            sortable: true,
            name: 'type',
            width: '5%'
        }
        ],
        width: "auto",
        managerName: "didicarManager",
        managerMethod: "getCarRecordList",
        parentId:'center'
    });
    //加载列表
    var o = new Object();
    o.role="${role}";
    singleS=o;
    $("#mytable").ajaxgridLoad(o);
     searchobj = $.searchCondition({
        top: 7,
        right: 35,
        searchHandler: function() {
          o = searchobj.g.getReturnValue();
          /* if(ssss!=null && typeof(ssss.value)=="string"){
              var reg = new RegExp("[%&]","i");  // 创建正则表达式对象。
              var  r = ssss.value.match(reg);
              if(r!=null){
                  $.alert("${ctp:i18n('didicar.plugin.record.notsupport.error')}");
                  return;
              }
          } */
          o.role="${role}";
          singleS=o;
          $("#mytable").ajaxgridLoad(o);
        },
        conditions: [
          {
          id: 'search_name',
          name: 'search_name',
          type: 'input',
          text: "${ctp:i18n('didicar.plugin.record.passenger')}",
          value: 'userName'
          },
          {
          id: 'search_dept',
          name: 'search_dept',
          type: 'input',
          text: "${ctp:i18n('didicar.plugin.record.deptName')}",
          value: 'deptName'
          },
          {
          id: 'search_phone',
          name: 'search_phone',
          type: 'input',
          text: "${ctp:i18n('didicar.plugin.record.mobile')}",
          value: 'phone'
          },
          {
          id: 'search_rule',
          name: 'search_rule',
          type: 'select',
          text: "${ctp:i18n('didicar.plugin.record.rule')}",
          value: 'rule',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.didicar.util.RuleEmun'"
          },
          {
          id: 'search_boardingTime',
          name: 'search_boardingTime',
          type: 'datemulti',
          text: "${ctp:i18n('didicar.plugin.record.boardingTime')}",
          value: 'createTime',
          ifFormat:'%Y-%m-%d',
          dateTime: false
          },
          {
            id: 'carUse',
            name: 'carUse',
            type: 'select',
            text: "${ctp:i18n('didicar.plugin.order.from')}",
            value: 'orderFrom',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.didicar.util.OrderFrom'"
            },
            {
              id: 'searchMemo',
              name: 'searchMemo',
              type: 'select',
              text: "${ctp:i18n('didicar.plugin.order.memo')}",
              value: 'carReason',
              codecfg: "codeType:'java',codeId:'com.seeyon.apps.didicar.util.OrderMemo'"
              }
        ]
        
      });
     
     if(${param.orderFrom eq 'PC'}){
     var timeD = setTimeout(function(){
        var data = new Object();
       data.orderid="${param.orderidPC}";
       mytable.grid.resizeGridUpDown('up');
       gridclk(data,'','');
       return;
    },300);
    }
    function gridclk(data, r, c) {
        $('#carDetail').attr("src","didicarOrderController.do?method=orderDetail&orderId="+data.orderid+"&fromRequest="+r+"&from="+"${role}");
    }
        function downLoadData(){
        var sss = searchobj.g.getReturnValue();
        
        if(sss!=null){
            $("#delIframe").prop("src","${path}/didicarController.do?page="+$("#mytable")[0].p.page+"&size="+$("#mytable")[0].p.rp+"&method=downLoadData&value="+encodeURIComponent(JSON.stringify(singleS)));
        }
    }
});
    function griddbclick() {
    }

    function openQueryViews(){
        var _url = "${path}" +"/genericController.do?ViewPage=plugin/didicar/comQuery";
        var queryDialog = $.dialog({
        url:  _url,
        width: 400,
        height: 250,
        title: "${ctp:i18n('didicar.plugin.advancedquery.title')}",
        id:'queryDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
                queryDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            handler: function () {
            
               o = queryDialog.getReturnValue();
             
               o.role="${role}"; 
               var obj=searchobj.g.getReturnValue();
               var value=obj["value"];
               var condition=obj["condition"];
               o[condition] = obj["value"];
               var mytable = $("#mytable");
                singleS=o;
                if(mytable.length>0){
                    //console.log("高级查询前条件输出"+o);
                    mytable.ajaxgridLoad(o);
                }
              queryDialog.close();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.close.label"),
            handler: function () {
                queryDialog.close();
            }
        }]
    });
    }
</script>

</head>
<body> 
 
<div id='layout' class="comp" comp="type:'layout'">
 
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F21_didi_record_${param.from}'"></div>
    <div class="layout_north f0f0f0" layout="height:40,sprit:false,border:false">  
    <table width="100%" border="0" cellpadding="0">
                <tr>
                    <td><div id="toolbar"></div></td>
                    <td width="100" align="right" valign="center" class="f0f0f0">
                         <a class="font_size14" onclick="javascript:openQueryViews()">${ctp:i18n("collaboration.advanced.lable") }</a>
                    </td>
                </tr>
             </table>
   </div>
 
    <div  class="layout_center over_hidden" id="center">
        <table id="mytable" class="flexme3" ></table>
        <div id="grid_detail" class="h100b">
             <iframe id="carDetail" name='carDetail' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
        </div>
    </div>
    <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>