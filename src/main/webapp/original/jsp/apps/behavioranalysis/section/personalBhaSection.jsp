<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>个人行为绩效栏目</title>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<style>
		.parent_div{position: relative;}
 		.child_div{position: absolute;background: none;top: 5px;left: 5px;}
		.child_div span{font-size: 12px;}
		.child_div .rank_span{color: #fb9464;font-size: 14px;}
		.child_div .no_data{font-size: 14px;}
	</style>
</head>

<body class="h100b  bg_color_none">
	<div class="w100b h100b parent_div" >
		<c:if test="${hasData == 1}">
			<div class="child_div">
				<span>本部门排名：<span class="rank_span">${vo.deptRanking}/${vo.deptTotal}</span></span><br>
				<span>本单位排名：<span class="rank_span">${vo.accountRanking}/${vo.accountTotal}</span></span>
			</div>
		</c:if>
		<c:if test="${hasData == 0}">
			<div class="w100b align_center child_div hidden">
				<span class="no_data">暂无行为绩效报告，待下月为你生成！</span><br>
			</div>
		</c:if>
		<div class="h100b over_hidden" id="echart"></div>
	</div>

	<script src="${path}/common/report/chart/echarts3/echarts.section.min.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		if(${hasData} == 0){
			var h = $(".parent_div").height();
			$(".child_div").css("margin-top",(h/2-20)+"px").show();
		}else{
			var category = $.parseJSON('${category}');
			var values = $.parseJSON('${values}');
			
			//初始化雷达图
			var myChart = echarts.init(document.getElementById('echart'));
			// 过渡---------------------
			myChart.showLoading({
				text : '正在努力的读取数据中...' //loading话术
			});
			var w = $("#echart").width();
			var h =  $("#echart").height();
			//高度需要减去上面文字高度，宽度需要留出文字显示的地方所以都减去了一定的高度
			var _radius = Math.min((w - 120)<40?40:(w - 120), (h - 100)<40?40:(h - 100)) / 2;
			var _fontSize = parseInt(_radius*(0.5+(values.length - 3)*0.1));
			
			var options = {
				animation:false,
				color : [ '#3e6cc3' ],
				title : {
					x : 'center',
					y : 'bottom',
					itemGap : -22
				},
				tooltip : {
					trigger : 'axis',
					textStyle:{fontSize:12},
					formatter: function(params) {
			        	return params[0].indicator + '：' + params[0].value;
			        }
				},
				polar : [ {
					splitLine : {
						show : false
					},
					splitArea : {
						show : true,
						areaStyle: {
	                        color: "#9bc6fe",
	                        type: "default"
	                    }
					},
					axisLine : {
						show : true,
						lineStyle:{
							color:'#fff'
						}
					},
					splitNumber : 1,
					indicator : category,
					name : {
						formatter : '{value}',
						textStyle:{
					        color:"#111"
					    },
					},
					center :['50%', '55%'],
					radius : _radius
				} ],
				series : [ {
					type : 'radar',
					symbol : 'circle',
					symbolSize : 3,
					itemStyle : {
						normal : {
							areaStyle : {
								color : '#3e6cc3',
								type : 'default'
							}
						}
					},
					data : [ {
						value : values,
						name : ''
					} ]
				}, {
					type : 'pie',
					center :['50%', '55%'],
					data : [ {
						value : ${vo.totalScore}
					//TODO:积分
					} ],
					itemStyle : {
						normal : {
							color : 'rgba(0,0,0,0)',
							label : {
								show : true,
								position : 'center',
								formatter : "{c}",
								textStyle : {
									color : '#FEFEFE',
									fontSize : _fontSize
								}
							},
							labelLine : {
								show : false
							}
						},
						emphasis : {
							color : 'rgba(0,0,0,0)',
							label : {
								show : true,
								position : 'center',
								formatter : "{c}",
								textStyle : {
									color : '#FEFEFE',
									fontSize : _fontSize
								}
							},
							labelLine : {
								show : false
							}
						}
					}
				} ]
			};
			myChart.hideLoading();
			myChart.setOption(options);
			myChart.on('click', function(param){
				getCtpTop().openCtpWindow({'url':'${path}/behavioranalysis.do?method=personalindex&rptYear=${wfParam.rptYear}&rptMonth=${wfParam.rptMonth}'});
			});
		}
		
	</script>
</body>
</html>
