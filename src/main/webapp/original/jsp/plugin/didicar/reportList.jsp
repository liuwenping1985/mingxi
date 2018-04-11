<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<script language="JavaScript" src="${path }/common/js/FusionCharts.js"></script>
<script language="JavaScript" src="${path }/common/js/ichart.1.2.min.js"></script>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=reportManager"></script>
<script type="text/javascript">
$().ready(function() {
  
  function printTable() {
    alert($("#mytablediv").html());
  };
  $("#tableResult").click(function () {
    $(this).parent().addClass('current').siblings().removeClass('current');
    $("#mytablediv").show();
    $("#chartResultShow").hide();
  });
 $("#chartResult").click(function () {
   //$("#resultComp").css('height','10%');
   $("#mytablediv").hide();
   $("#chartResultShow").show();
   //$("#chartResultShow").css('height','90%');
   $(this).parent().addClass('current').siblings().removeClass('current');
   alert($("#mytable")[0].p.size);
   //var chart = new FusionCharts("${pageContext.request.contextPath}/Charts/FCF_Pie3D.swf", "ChartId", "500", "500");
   //chart.setDataURL("${pageContext.request.contextPath}/Data/Pie3D.xml");         
  // chart.render("chartResultShow");
   var data = [
               {name : 'IE',value : 35.75,color:'#bc6666'},
               {name : 'Chrome',value : 29.84,color:'#cbab4f'},
               {name : 'Firefox',value : 24.88,color:'#76a871'},
               {name : 'Safari',value : 6.77,color:'#9f7961'},
               {name : 'Opera',value : 2.02,color:'#2ba5a4'},
               {name : 'Other',value : 0.73,color:'#6f83a5'}
           ];
   
   new iChart.Column3D({
       render : 'chartResultShow',
       data: data,
       title : '柱状图',
       width : 800,
       height : 400,
       align:'left',
       offsetx:50,
       legend : {
           enable : true
       },
       sub_option:{
           label:{
               color:'#111111'
           }
       },
       coordinate:{
           width:600,
           scale:[{
                position:'left',   
                start_scale:0,
                end_scale:40,
                scale_space:8,
                listeners:{
                   parseText:function(t,x,y){
                       return {text:t+"%"}
                   }
               }
           }]
       }
   }).draw();
  });
  

    $("#toolbar").toolbar({
        toolbar: [{
            id: "export",
            name: "${ctp:i18n('didicar.plugin.record.export')}",
            className: "ico16 export_excel_16",
            click:downLoadData
        },
        {
          id: "print",
          name: "打印",
          className: "ico16 print_16",
          click:printTable
      }
        
        ]
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,       
        dblclick:griddbclick,       
        colModel: [
        {
            /*金额*/
            display: "${ctp:i18n('didicar.plugin.record.money')}",
            sortable: true,
            name: 'totalPrice',
            width: '6%'
        },
        {
            /*用车方式*/
            display: "${ctp:i18n('didicar.plugin.information.mode')}",
            sortable: true,
            name: 'rule',
            width: '6%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.didicar.util.RuleEmun',query:'true'"
        },
        {
            /*专车车型*/
            display: "${ctp:i18n('didicar.plugin.record.type')}",
            sortable: true,
            name: 'memberId',
            width: '6%',
        }
        ],
        width: "auto",
        managerName: "reportManager",
        managerMethod: "getCarReportList",
        parentId:'resultComp',
        slideToggleBtn: true,
        resizable:false
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    function gridclk(data, r, c) {
    }
    function griddbclick() {
    }
    function downLoadData(){
        var sss = searchobj.g.getReturnValue();
        if(sss!=null){
            $("#delIframe").prop("src","${path}/didicarController.do?page="+$("#mytable")[0].p.page+"&size="+$("#mytable")[0].p.rp+"&method=downLoadData&condition="+sss.condition+"&value="+encodeURIComponent(sss.value));
        }
    }
});

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_didi_record'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">        
         <div id="toolbar"></div>
    </div>
   
    
        <div class="stadic_layout_body stadic_body_top_bottom" id="reportResult">
                <div id="tabs" name="tabs" class="stadic_layout" style="position:absolute;width:100%">
                    <div id="tabs_head" class="common_tabs clearfix stadic_layout_head stadic_head_height" style="20px;">
                        <ul class="" id="ul_tab">
                            <li class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe" id="tableResult">
                                <span>${ctp:i18n('performanceReport.queryMain.result.tableResult')}</span></a>
                            </li>
                            <li><a hidefocus="true" href="javascript:void(0)" tgt="tab2_iframe" id="chartResult">
                                <span>${ctp:i18n('performanceReport.queryMain.result.chartResult')}</span></a>
                            </li>
                        </ul>
                        </div> 
                 </div>
                   <div id='resultComp' class='align_right stadic_layout_footer stadic_footer_height' style="position:absolute;width:100%;height:95%">
                         <div id="mytablediv" style="position:absolute;width:100%">
                         <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
                         </div>
                    <div id="chartResultShow" style="position:left;display:none;width:100%"></div>
                    </div>
                    
        </div>
    <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
</body>
</html>