<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-11-22 10:55:18#$:
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<script type="text/javascript" src="${path}/ajax.do?managerName=drawChartManager"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChart.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChartHTML5.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/seeyon.ui.chart.js"></script>

<script type="text/javascript">
<!--
/**
 * 执行Flash图表的打印预览操作
 * @chartObjs 图表对象数组(new SeeyonChart()[])
 */
function printFlashChart2IMG(chartObjS){
  	if ( $.browser.msie ){
   		if($.browser.version<8){//对不起，当前您的浏览器版本过低无法支持图表的打印与转发，请升级至IE8及以上版本
   			$.alert("${ctp:i18n('report.chart.ie7.info')}");
   			return;
   		}
   	}
  var contentBody = "";
  if(chartObjS != null && chartObjS.length>0){
    var png = null;
    for(var i=0;i<chartObjS.length;i++){
      try{//防护：如果图表未加载完全是不会生成PNG的
        png = chartObjS[i].chart.getPNG();
      }catch(e){
        png = null;
        continue;
      }
      if(png != null){
        contentBody+="<img src='data:image/png;base64,"+png+"'>";
      }
     }
  }
  
  var printContentBody = "";
  var cssList = new ArrayList();
  var pl = new ArrayList();
  var contentBodyFrag = "" ;
  contentBodyFrag = new PrintFragment(printContentBody, contentBody);
  pl.add(contentBodyFrag);
  
  cssList.add("/seeyon/common/skin/default/skin.css");
  
  printList(pl,cssList);
}
//-->
</script>
