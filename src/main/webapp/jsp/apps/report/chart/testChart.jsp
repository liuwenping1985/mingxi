<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma"   content="no-cache">
<title>图表组件</title>
<script type="text/javascript">
$(function(){
  
  //-------------------图1
  var indexNames = new Array("唐轫","罗俊林","张伟","何涛","陶俊权","龙涛","季洪利","范贤颖","杨凤","何万里","肖霖");
  var simpleDataList = new Array(new Array("100","222","88","150","122","388","166","202","50","166","90"));
  var dataColorList = new Array(new Array("#000000","#0000FF","","","","#FF7F50","","","","","#FFF0F5"));
  var chart1 = new SeeyonChart({
    htmlId:"chart1",
    width : 500,
    height: 300,
    dataList: simpleDataList,
    indexNames : indexNames,
    dataColorList : dataColorList,
    yLabels : {
      format : "{%Value}{numDecimals:0}分" //将值格式化
    },
    debugge : true,
    toolTip : "true",
    xRotate : "315",
    event : [
             {name:"pointClick",func:onPointClick},
             {name:"pointMouseOver",func:onPointMouseOver}
             ]
  });
  
  //-----------------图2
  var seriesNames = new Array("一月","二月","三月");
  var crossDataList = new Array();
  crossDataList.push(new Array("100","212","88","110","122","188","166","202","50","102","90"));//一月的一组数据
  crossDataList.push(new Array("60","122","188","150","102","338","256","211","45","122","150"));//二月的一组数据
  crossDataList.push(new Array("220","255","388","50","142","228","111","82","118","232","250"));//三月的一组数据
  var seriesTypes = new Array(ChartType.column_cylinder,ChartType.line_vertical,ChartType.marker_vertical);
  var chart2 = new SeeyonChart({
    htmlId:"chart2",
    width : 500,
    height: 300,
    border : false,
    animation : true,
    legend : "true",   //显示图例
    xZoom : 5,      //滚动条
    lines : [
             {value:"{%AxisAverage}",color:"Yellow",fontFormat:"平均值",fontColor:"Yellow"},
             {value:"{%AxisMin}",color:"Blue",fontFormat:"最小值",fontColor:"Blue"},
             {displayUnderData:false,dashed:true,starValue:"{%AxisMax}",endValue:"0",color:"Red",fontFormat:"燃烧线",fontColor:"Red"}
             ],
    seriesTypes : seriesTypes,
    seriesNames : seriesNames,
    indexNames : indexNames,
    dataList : crossDataList,
    extraYaxisNameList : ["","a","a"],
    extraYaxisNodeList : [{
      name : "a",
      yLabels : {
        format : "{%Value}{numDecimals:0}%"
      }
    }
    ],
    debugge : false
  });
  
  var seriesTypes_ = new Array(ChartType.column,ChartType.column,ChartType.line_vertical);
  var chart3 = new SeeyonChart({
    htmlId:"chart3",
    width : 500,
    height: 300,
    chartType : ChartType.column_cylinder,  //圆筒形
    is3d : true,
    border : false,
    xRotate : true,
    yScale : {
      mode : Scalemode.stacked //多图堆叠
    },
    seriesTypes : seriesTypes_,
    seriesNames : seriesNames,
    indexNames : indexNames,
    dataList : crossDataList,
    debugge : false
  });
  
  var indexNames_ = new Array("未完成","完成","紧急","不紧及");
  var simpleDataList_ = new Array();
  simpleDataList_.push(new Array("100","200","150","80"));
  simpleDataList_.push(new Array("200","220","160","10"));
  var simpleDataList_id = new Array();
  simpleDataList_id.push(new Array("1","2","3","4"));
  simpleDataList_id.push(new Array("5","6","7","8"));
  var seriestNames_ = new Array("唐轫","罗俊林");
  var extraYaxisNameList_ = new Array("","luojl");
  var chart4 = new SeeyonChart({
    title : "双轴",
    htmlId:"chart4",
    width : 500,
    height: 300,
    seriesNames : seriestNames_,
    indexNames : indexNames_,
    dataList : simpleDataList_,
    dataIdList :simpleDataList_id,
    extraYaxisNameList : extraYaxisNameList_,
    extraYaxisNodeList : [{
      name : "luojl",
      yLabels : {
        format : "{%Value}%"
      }
    }],
    event : [
             {name:"pointClick",func:function(e){
               alert("ID="+e.data.ID);
             }}
             ],
    debugge:false
  });
  
  
  var chart5 = new SeeyonChart({
      title : "温度盘",
      border : false,
      htmlId : "chart5",
      chartType : ChartType.gauges_circular,
      width : 600,
      height : 500,
      circulars : [ {
        pointers : [ {value : "-5",animation:true} ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}℃", //格式化刻度值
          scale : {minimum:"-150",maximum:"100"},
          colorRanges : [{start : "0",end : "60",color : "Yellow"},{start : "60",end : "100",color : "Red"}]
        },
        labels:[{
          background : true,
          halign : "Center",
          valign : "Bottom",
          fontSize : "15",
          x : "50",    //这里的x比例是根据当前图表大小而定
          y : "70",   //这里的y比例是根据当前图表大小而定
          format : "当前温度:-5℃"  //不支持表达式
        }]
      } ],
      debugge : false
    });

    var chart6 = new SeeyonChart({
      title : "刻度盘",
      border : true,
      htmlId : "chart6",
      chartType : ChartType.gauges_circular,
      width : 600,
      height : 500,
      circulars : [//支持多个刻度盘，通过x、y定位图位置，通过width和height定位图大小，数字都是百分比
      {
        x : "0",
        y : "0",
        width : "33",
        height : "50",
        pointers : [ {
          value : "50"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
          colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        },
        labels:[{
          halign : "Center",
          valign : "Bottom",
          fontSize : "15",
          x : "50", 
          y : "100",
          background : false,
          format : "项目1"
        }]
      }, {
        x : "33.3",
        y : "0",
        width : "33",
        height : "50",
        pointers : [ {
          value : "80"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
            colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        },
        labels:[{
          halign : "Center",
          valign : "Bottom",
          fontSize : "15",
          x : "50", 
          y : "100",
          background : false,
          format : "项目2"
        }]
      }, {
        x : "66.6",
        y : "0",
        width : "33",
        height : "50",
        pointers : [ {
          value : "90"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
          colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        }
      }, {
        x : "0",
        y : "50",
        width : "33",
        height : "50",
        pointers : [ {
          value : "60"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
          colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        }
      }, {
        x : "33.3",
        y : "50",
        width : "33",
        height : "50",
        pointers : [ {
          value : "20"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
          colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        },
        labels:[{
          halign : "Center",
          valign : "Bottom",
          fontSize : "15",
          x : "50",
          y : "100",
          background : false,
          format : "项目3"
        }]
      }, {
        x : "66.6",
        y : "50",
        width : "33",
        height : "50",
        pointers : [ {
          value : "70"
        } ],//具体值
        axis : {
          yLabels : "{%Value}{numDecimals:0}%",
          colorRanges : [{start : "0",end : "60",color : "Green"},{start : "60",end : "80",color : "Yellow"},{start : "80",end : "100",color : "Red"}]  
        }
      } ],
      debugge : false
    });

    //--------------事件区
    $("#chart1Btn").click(function() {
      renderChart(chart1);
    });

    $("#chart2Btn").click(function() {
      renderChart(chart2);
    });

    $("#saveAsBtn").click(function() {
      chart1.saveAsImage();
    });

    $("#printBtn").click(function() {
      chart1.printChart();
    });

    function onPointClick(e) {
      alert("单击事件，e.data.Name=" + e.data.Name + "  e.data.YValue="
          + e.data.YValue);
    }

    function onPointMouseOver(e) {

    }

    function renderChart(chartObj) {
      chartObj.params.title = $("#title").val();
      chartObj.params.xTitle = $("#xTitle").val();
      chartObj.params.yTitle = $("#yTitle").val();
      chartObj.params.subtitle = $("#subtitle").val();
      chartObj.params.footer = $("#footer").val();
      chartObj.params.is3d = $("#is3d").val();
      chartObj.params.chartType = $("#chartType").val();
      chartObj.params.animation = $("#animation").val();
      chartObj.params.toolTip = $("#toolTip").val();
      chartObj.params.insideLabel = $("#insideLabel").val();
      chartObj.params.outsideLabel = $("#outsideLabel").val();
      chartObj.params.xRotate = $("#xRotate").val();
      chartObj.params.xZoom = $("#xZoom").val();
      chartObj.params.legend = $("#legend").val();
      chartObj.params.explodeOnClick = $("#explodeOnClick").val();

      chartObj.width = $("#width").val();
      chartObj.height = $("#height").val();

      var model = $("input:radio:checked").val();
      if (model == "2") {
        chartObj.params.seriesNames = seriesNames;
        chartObj.params.dataList = crossDataList;
      } else if (model == "4") {
        chartObj.params.seriesNames = null;
        chartObj.params.indexNames = null;
        chartObj.params.dataList = null;
      }

      //刷新图表
      chartObj.refreshChart();
    }
    ;

  });
</script>
</head>
<body>
<table>
<tr align="right">
    <td>标题(title)<input type="text" id="title"/></td>
    <td>X轴标题(xTitle)<input type="text" id="xTitle"/></td>
    <td>Y轴标题(yTitle)<input type="text" id="yTitle"/></td>
    <td>图类型(chartType)<select id="chartType" name="chartType" class="codecfg"
    codecfg="codeType:'java',codeId:'com.seeyon.ctp.report.chart.enums.ChartTypeEnum',defaultValue:1">
    </select></td>
    
</tr>
<tr align="right">
    <td>副标题(subtitle)<input type="text" id="subtitle"/></td>
    <td>脚注(footer)<input type="text" id="footer"/></td>
    <td>内嵌文字(insideLabel)<input type="text" id="insideLabel" value=""></input></td>
    <td>外显文字(outsideLabel)<input type="text" id="outsideLabel" value=""></input></td>
    
</tr>
<tr align="right">
    <td>X轴文字竖直显示(xRotate)<select id="xRotate">
    <option value="false">否</option>
    <option value="true">是</option>
    </select></td>
    <td>X轴滚动条(xZoom)<input id="xZoom" value="0"></input></td>
    <td>
            宽度(width)<input id="width" value="500"/>
    </td>
    <td>
            高度(height)<input id="height" value="300"/>
    </td>
</tr>
<tr align="right">
    <td>点击展开(explodeOnClick)<select id="explodeOnClick">
    <option value="true">是</option>
    <option value="false">否</option>
    </select></td>
    <td>动画(animation)<select id="animation">
    <option value="false">否</option>
    <option value="true">是</option>
    </select></td>
    <td>
    3D显示(is3d)<select id="is3d">
    <option value="false">否</option>
    <option value="true">是</option>
    </select>
    </td>
    <td>冒泡提示(toolTip)<input type="text" id="toolTip"></input></td>
</tr>
<tr align="right">
    <td>图例(legend)<input id="legend" value=""></input></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
<tr align="right">
    <td>普通图形<input name="radioChart" type="radio" value="1"/></td>
    <td>交叉图形<input name="radioChart" type="radio" value="2"/></td>
    <td class="hidden">交叉复杂图形<input name="radioChart" type="radio" value="3"/></td>
    <td>无数据图形<input name="radioChart" type="radio" value="4"/></td>
    <td></td>
</tr>
</table>

<hr/>
<input type="button" id="chart1Btn" value="确定"/>
<input type="button" id="saveAsBtn" value="保存图片"/>
<input type="button" id="printBtn" value="打印">
<font color="red">详细文档请鼠标往下滚动</font>
<table>
    <tr>
        <td><div id="chart1"></div></td>
        <td><div id="chart2"></div></td>
    </tr>
    <tr>
        <td><div id="chart3"></div></td>
        <td><div id="chart4"></div></td>
    </tr>
    <tr>
        <td><div id="chart5"></div></td>
        <td><div id="chart6"></div></td>
    </tr>
</table>

<hr/>
<h4>功能介绍</h4>
<pre>
CTP图表组件使用第三方图表组件anyChart为内核，是一款基于Flash/JavaScript的图表控件。使用本组件可创建跨浏览器和跨平台的交互式图表和仪表。本图表可以用于仪表盘的创建、报表、数据分析、统计学，金融等领域。
支持图类型：柱状、条形、折线、曲线、饼图、圆环、面积图和雷达图、仪表盘/温度计等。支持3D、动画效果、图例说明、tooltip冒泡提示、图标题/副标题/脚注/x轴标题/y轴标题、滚动条、文字水平/竖直、双轴（多轴）显示。
</pre>

<hr/>
<h4>环境搭建</h4>
<pre>
1-1拷贝ctp_pub以下目录到自己小组的开发环境中：
/WebContent/common/report"
/WebContent/WEB-INF/jsp/apps/report

1-2在使用图表的JSP中引入图表组件必备文件，建议直接引入chart_common.jsp，里面包含了所有图表组件的依赖文件：
&lt;%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%&gt;

1-3确保在项目lib目录中包含了seeyon_ctp_report.jar文件
</pre>
<font color="red">注意事项：不推荐将chart_common.jsp放入各模块的common.jsp下，因为chart_common.jsp引入的js文件较大，一定程度上影响没有使用图表的模块的加载速度!</font>
<hr/>
<h4>创建对象 展示图表</h4>
<pre>
&lt;script type="text/javascript"&gt;
①创建一个最简单的图表（默认柱状图），indexNames是X轴的值，simpleDataList是Y轴的值
$(function(){
var indexNames = new Array("唐轫","罗俊林","张伟","何涛","陶俊权","龙涛","季洪利","范贤颖","杨凤");
var simpleDataList = new Array(new Array("100","222","88","150","122","388","166","202","50"));
var chartObj = new SeeyonChart({
        htmlId:"chart1",
        width : 500,
        height: 300,
        indexNames : indexNames,
        dataList : simpleDataList
});
&lt;script&gt;
&lt;div id="chart1"&gt;&lt;/div&gt;

②如果一个图希望展示多个序列（series），可以参照下面的代码：
下面的代码表示每个成员一月、二月、三月分别的值
var seriesNames = new Array("一月","二月","三月");
var indexNames = new Array("唐轫","罗俊林","张伟","何涛","陶俊权","龙涛","季洪利","范贤颖","杨凤");
var crossDataList = new Array();
crossDataList.push(new Array("100","212","88","110","122","188","166","202","50"));//一月的一组数据
crossDataList.push(new Array("60","122","188","150","102","338","256","211","45"));//二月的一组数据
crossDataList.push(new Array("220","255","388","50","142","228","111","82","118"));//三月的一组数据
var chartObj = new SeeyonChart({
        htmlId:"chart1",
        width : "50%",
        height: "50%",
        is3d : true,
        title : "员工月份报销图",
        toolTip : "true",
        chartType : ChartType.line_vertical,
        seriesNames : seriesNames,
        dataList : simpleDataList,
        indexNames : indexNames
});

③接上面的图，如果希望每个series是不同的图（即混合图），可以这样做：
var seriesTypes = new Array(ChartType.column,ChartType.line_vertical,ChartType.spline_vertical);
var chartObj = new SeeyonChart({
        htmlId:"chart1",
        width : 400,
        height: 300,
        seriesTypes : seriesTypes,
        seriesNames : seriesNames,
        dataList : simpleDataList,
        indexNames : indexNames
});

④图表组件是根据XML来决定图表展示的，所以如果已经准备好符合该组件的XML数据，也可以这样做：
var xmlData = ...;
var chartObj = new SeeyonChart({
        htmlId:"chart1",
        width : 500,
        height: 300,
        xmlData : xmlData
});

⑤对象化参数，在Java中定义了一个与SeeyonChart对应的图表容器对象:com.seeyon.ctp.report.chart.bo.AnyChart,也就是说可以在后台定义好Anychart对象，再传到前台并以参数的形式放到SeeyonChart中，依然可以显示图形
下面是在定义一个javascript对象作为参数传入图表组件的方法:
var indexNames = new Array("唐轫","罗俊林","张伟","何涛","陶俊权","龙涛","季洪利","范贤颖","杨凤");
var simpleDataList = new Array(new Array("100","222","88","150","122","388","166","202","50"));
<font color="red">var chartJson = new Object();</font>
chartJson.indexNames = indexNames; 
chartJson.dataList=simpleDataList;
chartJson.animation=true;
var chart1 = new SeeyonChart({
    htmlId:"chart1",
    width : 500,
    height: 300,
    <font color="red">chartJson:chartJson,</font>
    debugge : true,
    event : [
             {name:"pointClick",func:onPointClick},
             {name:"pointMouseOver",func:onPointMouseOver}
             ]
});

下面是在Java后台准备好数据传入前端的方法：
============后台==============
AnyChart chart = new AnyChart(); chart.setXXX.....
ModelAndView.add("chartJson",JSONUtil.toJSONString(chart));
============前端=============
var chart1 = new SeeyonChart({
    htmlId:"chart1",
    width : 500,
    height: 300, 
    <font color="red">chartJson:eval(EL{chartJson}),</font>
});

下面是在Java后台准备好数据传入前端的方法：
============后台==============
AnyChart chart = new AnyChart(); chart.setXXX.....
ModelAndView.add("xml",anyChartManager.getXML(chart));
============前端=============
var chart1 = new SeeyonChart({
    htmlId:"chart1",
    width : 500,
    height: 300, 
    <font color="red">xmlData:"EL{xml}"</font>
});

⑥以参数的形式请求指定URL出图：上面每一个配置就是一个参数，只要访问这个URL就能看到你需要的图形
<pre>
String[] indexNamesStr = taskDataList.get(0).split(",");
String[] dataListStr = taskDataList.get(1).split(",");
List<String> dataList=new ArrayList<String>();
List<String> indexNames=new ArrayList<String>();
for(int i=0;i<dataListStr.length;i++){
indexNames.add(indexNamesStr[i]);
dataList.add(dataListStr[i]);
}
List<List<String>> dateList2 = new ArrayList<List<String>>();
dateList2.add(dataList);
String baseUrl=AppContext.getRawRequest().getContextPath();
String event =  "[{name:'pointClick',func:onPointClick}]";
String url = baseUrl+"/report/reportChart.do?method=showChart&dataList="+URLEncoder.encode(JSONUtil.toJSONString(dateList2),"UTF-8")
             +"&indexNames="+URLEncoder.encode(JSONUtil.toJSONString(indexNames),"UTF-8")+"&chartType="+type
             +"&legend=points_true&height="+chartHeight+"px&width="+chartWidth+"px&event="+event
             +"&includeFile="+URLEncoder.encode("/WEB-INF/jsp/apps/taskmanage/taskStatisticsViewEvent4Portal.js.jsp?startTime="+DateUtil.format(startTime)
             +"&endTime="+DateUtil.format(endTime)+"&singleBoardId="+singleBoardId,"UTF-8");
</pre>

⑦仪表盘配置
因为仪表盘依赖的数据与上面常规图不同，所以仪表盘的配置也与他们不同

</pre>
<hr>
<br/>
<h4>参数说明</h4>
<table class="only_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
    <tr>
        <th>初始属性</th>
        <th>修改属性</th>
        <th>数据类型</th>
        <th>说明</th>
    </tr>
    <tr>
        <td><font color="red">*</font>htmlId</td>
        <td>htmlId</td>
        <td>string</td>
        <td>图表显示的容器id，比如希望将图表显示在div id='div1'中则设置为div1</td>
    </tr>
    <tr>
        <td>width</td>
        <td>width</td>
        <td>string</td>
        <td>图表宽度，支持px和%百分比为单位，默认100%</td>
    </tr>
    <tr>
        <td>height</td>
        <td>height</td>
        <td>string</td>
        <td>图表高度，支持px和%百分比为单位，默认100%</td>
    </tr>
    <tr>
        <td><font color="red">*</font>indexNames</td>
        <td>params.seriesNames</td>
        <td>array</td>
        <td>必填，X轴的值集合</td>
    </tr>
    <tr>
        <td><font color="red">*</font>dataList</td>
        <td>params.dataList</td>
        <td>array[array]</td>
        <td>必填，Y轴的值集合</td>
    </tr>
    <tr>
        <td>seriesNames</td>
        <td>params.seriesNames</td>
        <td>array</td>
        <td>序列数</td>
    </tr>
    <tr>
        <td>seriesTypes</td>
        <td>params.seriesTypes</td>
        <td>array</td>
        <td>每个序列对应的图类型</td>
    </tr>
    <tr>
        <td>title</td>
        <td>params.title</td>
        <td>string</td>
        <td>标题</td>
    </tr>
    <tr>
        <td>xTitle</td>
        <td>params.xTitle</td>
        <td>string</td>
        <td>X轴标题</td>
    </tr>
    <tr>
        <td>yTitle</td>
        <td>params.yTitle</td>
        <td>string</td>
        <td>Y轴标题</td>
    </tr>
    <tr>
        <td>subtitle</td>
        <td>params.subtitle</td>
        <td>string</td>
        <td>副标题</td>
    </tr>
    <tr>
        <td>footer</td>
        <td>params.footer</td>
        <td>string</td>
        <td>脚注说明</td>
    </tr>
    <tr>
        <td>is3d</td>
        <td>params.is3d</td>
        <td>boolean</td>
        <td>是否启用3d</td>
    </tr>
    <tr>
        <td>chartType</td>
        <td>params.chartType</td>
        <td>int</td>
        
        <td>ChartType.**常量，图类型，详见下方<a href="#chartType">图表类型</a>说明</td>
    </tr>
    <tr>
        <td>animation</td>
        <td>params.animation</td>
        <td>boolean</td>
        <td>是否启用动画效果</td>
    </tr>
    <tr>
        <td>toolTip</td>
        <td>params.toolTip</td>
        <td>string</td>
        <td>冒泡提示，启用默认的冒泡提示则输入"true"，自定义样式请使用<a href="#keyWords">参数说明</a>的配置</td>
    </tr>
    <tr>
        <td>insideLabel</td>
        <td>params.insideLabel</td>
        <td>string</td>
        <td>图内文字提示，启用默认的图内提示则输入"true"，自定义样式请使用<a href="#keyWords">参数说明</a>的配置</td>
    </tr>
    <tr>
        <td>insideLabel</td>
        <td>params.insideLabel</td>
        <td>string</td>
        <td>图内文字提示，启用默认的图内提示则输入"true"，自定义样式请使用<a href="#keyWords">参数说明</a>的配置</td>
    </tr>
    <tr>
        <td>outsideLabel</td>
        <td>params.outsideLabel</td>
        <td>string</td>
        <td>图外文字提示，启用默认的图外提示则输入"true"，自定义样式请使用<a href="#keyWords">参数说明</a>的配置</td>
    </tr>
    <tr>
        <td>xRotate</td>
        <td>params.xRotate</td>
        <td>String(旧版本是boolean，不冲突)</td>
        <td>x轴指标文字旋转角度（竖直则为90或者true）</td>
    </tr>
    <tr>
        <td>xZoom</td>
        <td>params.xZoom</td>
        <td>int</td>
        <td>滚动条显示，输入多少值则当滚动页面显示多少指标信息</td>
    </tr>
    <tr>
        <td>legend</td>
        <td>params.legend</td>
        <td>string</td>
        <td>图例说明，支持4种常量"true"、"true_Bottom"、"points_true"、"points_true_Bottom"，也可使用<a href="#keyWords">参数说明</a>的配置</td>
    </tr>
    
    <tr>
        <td>border</td>
        <td>params.border</td>
        <td>boolean</td>
        <td>是否显示图表边框</td>
    </tr>
    <tr>
        <td>explodeOnClick</td>
        <td>params.explodeOnClick</td>
        <td>boolean</td>
        <td>点击图形是否展开，适用于圆饼图</td>
    </tr>
    <tr>
        <td>debugge</td>
        <td>debugge</td>
        <td>boolean</td>
        <td>是否在控制台打印生成的图XML</td>
    </tr>
    <tr>
        <td>event</td>
        <td>event</td>
        <td>array</td>
        <td>定义事件类型集合</td>
    </tr>
</table>
<hr/>
<h4>扩展函数</h4>
<pre>
调用说明：
var chart = new SeeyonChart({xxx:...,xx:...});
chart.函数()
</pre>

<table class="only_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
    <tr>
        <th>函数</th>
        <th>参数</th>
        <th>功能说明</th>
    </tr>
    <tr>
        <td>refreshChart()</td>
        <td></td>
        <td>重新渲染图表</td>
    </tr>
    <tr>
        <td>printChart()</td>
        <td></td>
        <td>打印图表</td>
    </tr>
    <tr>
        <td>saveAsImage()</td>
        <td></td>
        <td>图表另存为图片</td>
    </tr>
</table>
<hr/>

<a name="chartType"></a>
    <h4>图表类型</h4>
    <pre>
ChartType.column = 1;//柱状
ChartType.bar = 2;//条状
ChartType.line_vertical = 3;//折线-竖直
ChartType.line_horizontal = 4;//折线-水平
ChartType.spline_vertical = 5;//曲线-竖直
ChartType.spline_horizontal = 6;//曲线-水平
ChartType.pie = 7;//饼状
ChartType.doughnut = 8;//圆环
ChartType.area_vertical = 9;//面积图-竖直
ChartType.area_horizontal = 10;//面积图-水平
ChartType.radar = 11; //雷达图
ChartType.marker_vertical = 12;   //标记图（气泡图）-竖直
ChartType.marker_horizontal = 13; //标记图（气泡图）-水平
ChartType.column_cylinder = 14;   //圆筒-柱状
ChartType.bar_cylinder = 15;      //圆筒-条状

ChartType.gauges_circular = 101;  //圆形仪表图
</pre>

<hr/>
<a name="keyWords"></a>
<h4>参数说明（不断补充）</h4>
<table class="only_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
    <tr>
        <th>分类</th>
        <th>参数</th>
        <th>说明</th>
    </tr>
    <tr>
        <td>{%Value}</td>
        <td>Y轴的值</td>
    </tr>
    <tr>
        <td>{%YValue}</td>
        <td>{%Value}=={%YValue} Y轴的值</td>
    </tr>
    <tr>
        <td>{%YPercentOfCategory}</td>
        <td>该节点在同名的point的百分比比例</td>
    </tr>
    <tr>
        <td>{%YPercentOfSeries}</td>
        <td>该节点在当前series中占用的百分比比例</td>
    </tr>
    <tr>
        <td>{%YPercentOfTotal}</td>
        <td>该节点在所有series中占用的百分比比例</td>
    </tr>
    <tr>
        <td>{%Name}</td>
        <td>X轴的值</td>
    </tr>
    <tr>
        <td>{%Index}</td>
        <td>当前位置</td>
    </tr>
    <tr>
        <td>{%Icon}</td>
        <td>当前维度图标</td>
    </tr>
    <tr>
        <td>{numDecimals:*}</td>
        <td>*为数值，用在{%Value}后面，用于控制值显示的小数点位数</td>
    </tr>
</table>
<hr/>
<h4>图表事件</h4>
<pre>
定义图表对象时定一个event属性，这是一个数组对象，每个对象包含两个值name和func，前者是事件类型，后者是事件方法。
以下代码定义了两个事件
var chart1 = new SeeyonChart({
    htmlId:"chart1",
    ...
    event : [
        {name:"pointClick",func:onPointClick},
        {name:"pointMouseOver",func:onPointMouseOver}
    ]
});
function onPointClick(e){
    alert("单击事件，e.data.Name="+e.data.Name+"  e.data.YValue="+e.data.YValue);
}

function onPointMouseOver(e){
     
}
</pre>
<a href="http://www.anychart.com/products/anychart/docs/users-guide/index.html?JavaScriptEvents.html">>>点此查看更多事件</a>
<hr/>
<h4>改变图表配置</h4>
<pre>
    图表选人完成后，可能需要动态修改某些配置，那么则使用下面的方法
    chartObj.params.title = $("#title").val();
    chartObj.params.xTitle = $("#xTitle").val();
    chartObj.params.yTitle = $("#yTitle").val();
    chartObj.params.subtitle = $("#subtitle").val();
    chartObj.params.footer = $("#footer").val();
    chartObj.params.is3d = $("#is3d").val();
    chartObj.params.chartType = $("#chartType").val();
    chartObj.params.animation = $("#animation").val();
    chartObj.params.toolTip = $("#toolTip").val();
    chartObj.params.insideLabel = $("#insideLabel").val();
    chartObj.params.outsideLabel = $("#outsideLabel").val();
    chartObj.params.xRotate = $("#xRotate").val();
    chartObj.params.xZoom =  $("#xZoom").val();
    chartObj.params.legend = $("#legend").val();
    
    chartObj.width = $("#width").val();
    chartObj.heigth = $("#heigth").val();
    chartObj.debugge = true; //false 
    
    var seriesNames = new Array("一月","二月","三月");
    var crossDataList = new Array();
    crossDataList.push(new Array("100","212","88","110","122","188","166","202","50"));//一月的一组数据
    crossDataList.push(new Array("60","122","188","150","102","338","256","211","45"));//二月的一组数据
    crossDataList.push(new Array("220","255","388","50","142","228","111","82","118"));//三月的一组数据
    var model = $("input:radio:checked").val();
    if(model == "2"){
      chartObj.params.seriesNames = seriesNames;
      chartObj.dataList = crossDataList;
    }
    
    //刷新图表
    chartObj.refreshChart();
</pre>
<hr/>

</body>
</html>