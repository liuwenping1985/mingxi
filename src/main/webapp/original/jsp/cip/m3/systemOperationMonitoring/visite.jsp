<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
	<link rel="stylesheet" href="/seeyon/apps_res/m3/css/visite.css">
    <title></title>
    <script src="/seeyon/apps_res/m3/js/echarts.js"></script>
</head>
<body class="h100b">
	<div class="numTop">
		<ul class="numTop-ul">
			<li>
				<div class="numTop_top">
					<p>
						<em></em>
						<span></span>
					</p>
				</div>
				<div class="numTop_bottom">
					<ul>
						<li class="numTop_bottom_li1">${ctp:i18n('MobileStatistic.som.index.ranking')}</li>
						<li class="numTop_bottom_li2"></li>
						<li class="numTop_bottom_li3">${ctp:i18n('MobileStatistic.som.index.numberOfVisits')} </li>
					</ul>
				</div>
			</li>
			<li class="num_bottom_left_bottom" id="table_bar1"></li>
			<div class="lineChart3" id="chart3_1"></div>
		</ul>
	</div>
</body>
<script>
	
	var http = location.href.split("//")[0];
    var href = location.href.split("//")[1].split("/")[0];
	//应用访问排行图表数据

  	function ajax(type,url,async,cache,dataType,fun){
      $.ajax({
        type:type,
        url:url,
        async:async,
        cache:cache,
        dataType:dataType,
        success:fun,
        error:function(res){
          alert("${ctp:i18n('MobileStatistic.som.index.dataException')}");
        }
      });
    }
    function chart(id,option){
      // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById(id));

        // 指定图表的配置项和数据
        var option = option;

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    }
  	function bar1_today_success(data){
  		$("#chart3_1").html("");
      var yAxis_data = [];
      var series_data = [];
      var option = {
        grid:{
          show:false,
          left:80
        },
        //设置坐标轴
          xAxis : {
            type : 'value',
            show : false,
            min : 0,
            max : 0,
            axisLine:{
              show:false
            },
            splitLine:{
              show:false
            },
            axisTick:{
              show:false
            }
        },
          yAxis : {
            type : 'category',
            show : false,
            min : "dataMin",
            boundaryGap : 'false',
            splitLine:{
              show:false
            },
            axisLine:{
              show:false
            },
            position:'left',
            axisTick:{
              show:false
            },
            data : yAxis_data
        },
          //设置数据
          series : [
            {
              type:"bar",
              label:{
                normal:{
                  show:true,
                  position:'insideBottomRight',
                  textStyle:{
                    color:'#fff',
                    fontSize:16,
                    fontWeight:'bold'
                  }
                },
                emphasis: {
                  textStyle:{
                    color:'#fff',
                    fontSize:16,
                    fontWeight:'bold'
                  }
                }
              },
              itemStyle: {
                normal: {
                  color:'#5793f3'
                },
                emphasis: {
                  color:'#d24a61'
                }
              },
              barMinHeight:50,
              barMaxWidth:18,
              data:series_data
            }
          ]
      };

      if(data.data.length){
        var arr = data.data;
        for(var i=0,tr="";i<arr.length;i++){
          tr=tr+"<tr><td class='bar1_td1'>"+(i+1)+"</td><td class='bar1_td2'>"+arr[i].appName+"</td><td class='bar1_td3'></td>";
        }
        var html = $("#table_bar1")[0].innerHTML = "<table class='bar1_table'><tbody>"+tr+"</tbody></table>";
        option.xAxis.max = data.data[0].count;
        for(var i=arr.length;i>=0;i--){
          for(var key in arr[i]){
            if(key=='appName'){
              yAxis_data.push(arr[i][key]);
            }else if(key=='count'){
              series_data.push(arr[i][key]);
            }
          }
        }
        $(".lineChart3").height($(".bar1_table").height() + 115 + 'px');
        chart('chart3_1',option);
      }else{
        $("#table_bar1").css({
          'padding-top':'30px',
          'text-align':'center',
        }).html("${ctp:i18n('MobileStatistic.som.index.noData')}");
      }
  	}
  	function bar2_today_success(data){
  		$("#chart3_1").html("");
      var yAxis_data = [];
      var series_data = [];
      var option = {
        grid:{
          show:false,
          left:80
        },
        //设置坐标轴
        xAxis : {
          type : 'value',
          show : false,
          min : 0,
          max : 0,
          axisLine:{
            show:false
          },
          splitLine:{
            show:false
          },
          axisTick:{
            show:false
          }
        },
        yAxis : {
          type : 'category',
          show : false,
          boundaryGap : 'false',
          splitLine:{
            show:false
          },
          axisLine:{
            show:false
          },
          position:'left',
          axisTick:{
            show:false
          },
          data : yAxis_data
        },
        //设置数据
        series : [
          {
            type:"bar",
            label:{
              normal:{
                show:true,
                position:'insideBottomRight',
                textStyle:{
                  color:'#fff',
                  fontSize:16,
                  fontWeight:'bold'
                }
              },
              emphasis: {
                textStyle:{
                  color:'#fff',
                  fontSize:16,
                  fontWeight:'bold'
                }
              }
            },
            itemStyle: {
              normal: {
                  color:'#5793f3'
              },
              emphasis: {
                  color:'#d24a61'
              }
            },
            barMaxWidth:18,
            data:series_data
          }
        ]
      };
      if(data.data.length){
        var arr = data.data;
        for(var i=0,tr="";i<arr.length;i++){
          tr=tr+"<tr><td class='bar1_td1'>"+(i+1)+"</td><td class='bar1_td2'>"+arr[i].departmentName+"</td><td class='bar1_td3'></td>";
        }
        var html = $("#table_bar1")[0].innerHTML = "<table class='bar1_table'><tbody>"+tr+"</tbody></table>";
        option.xAxis.max = data.data[0].count;
        for(var i=arr.length;i>=0;i--){
          for(var key in arr[i]){
            if(key=='departmentName'){
              yAxis_data.push(arr[i][key]);
            }else if(key=='count'){
              series_data.push(arr[i][key]);
            }
          }
        }
        $(".lineChart3").height($(".bar1_table").height() + 115 + 'px');
        chart('chart3_1',option);
      }else{
        $("#table_bar1").css({
          'padding-top':'30px',
          'text-align':'center',
        }).html("${ctp:i18n('MobileStatistic.som.index.noData')}");
      }
  	}

    var type = ${type};
  	if(type == 1){
  		ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/appClick/-1?dateType=${n}&fromClientType=${fromClientType}",false,true,"json",bar1_today_success);
      $(".numTop_bottom_li2").html("${ctp:i18n('MobileStatistic.som.index.application')}");
      $(".numTop_top p span").html("${ctp:i18n('MobileStatistic.som.index.applicationAccessRanking')}");
  	}else{
  		ajax('get',http+"//"+href+"/seeyon/rest/m3/statistics/departActive/-1?dateType=${n}&fromClientType=${fromClientType}",false,true,"json",bar2_today_success);
      
      ajax("get",http+"//"+href+"/seeyon/rest/m3/statistics/isGroup",true,true,"json",function(res){
        var isGroup = res.data.isGroup;

        if(isGroup == "true"){
          $(".numTop_bottom_li2").html("${ctp:i18n('MobileStatistic.som.index.company')}");
          $(".numTop_top").find("span").html("${ctp:i18n('MobileStatistic.som.index.companiesActiveRanking')}");
        }else{
          $(".numTop_bottom_li2").html("${ctp:i18n('MobileStatistic.som.index.department')}");
          $(".numTop_top").find("span").html("${ctp:i18n('MobileStatistic.som.index.departmentActiveRanking')}");
        }
      });
      
  	}
  	
</script>
</html>