<%--
 $Author: ouyp $
 $Rev:  $
 $Date:: 2015-04-24 14:05:18#$:
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<!-- report.portal.commons setting -->
<c:set var="url_performanceReport_performanceTree" value="${path}/performanceReport/performanceReport.do?method=performanceTree"></c:set>
<c:set var="url_performanceReport_centerGrid" value="${path}/performanceReport/performanceReport.do?method=centerGrid"></c:set>
<c:set var="url_performanceReport_personRight" value="${path}/performanceReport/performanceReport.do?method=personRight"></c:set>
<c:set var="url_performanceReport_authSave" value="${path}/performanceReport/performanceReport.do?method=authSave"></c:set>
<c:set var="url_performanceReport_authEdit" value="${path}/performanceReport/performanceReport.do?method=authEdit"></c:set>
<script type="text/javascript">
    var url_performanceReport_authSave = "${url_performanceReport_authSave}";
    var url_performanceReport_performanceTree = "${url_performanceReport_performanceTree}";
    var url_performanceReport_centerGrid = "${url_performanceReport_centerGrid}";
</script>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showTable.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showChart.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showPortal.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
//栏目主题
var theme = {
	backgroundColor: '#fafafa',
	/* color: [
            '#1D8BD1','#F1683C','#2AD62A','#DBDC25',
            '#8FBC8B','#D2B48C'
        ], */
    // 提示框
    tooltip: {
        formatter: function(param) {
        	var fm;
        	switch(param.series.type) {
        		case 'scatter': 
        		{
        			fm = param.value[0] + '-' + param.seriesName + '-' + param.value[1];
        			break;
        		}
        		case 'line':
        		case 'bar':
        		default:
        		{
        			fm = param.name + '-' + param.seriesName + '-' + param.value;
        		}
        	}
        	return fm;
        },
        position: function(p) { return [p[0]-20, p[1]-30]; }
    },
    // 网格
    grid: {
        x: 80,
	    y: 50,
	    x2: 80,
	    y2: 30
    },
    //滚动条
    dataZoom: { height: 29 },
 	// 柱状图
    bar: {
        itemStyle: {
            normal: { label: { show: true, } },
            emphasis: { label: { show: true, } }
        }
    },
    //饼状图
    pie: {
		startAngle: 180,
		center: ['50%', '50%'],
    	radius: [0, '80%'], 
    	minAngle: 0,
    	selectedMode:'single',
    	clockWise: false,
    	itemStyle: {
    		normal: {
                label: {
                    show: true,
                    position: 'inside',
                    textStyle: {
    		        	fontFamily: 'Microsoft YaHei',
    		        	fontSize: 12,
    		            fontWeight: 'bold',
    		            color: '#414141'          // 主标题文字颜色
    		        },
                    formatter: function(seriesName) {
                    	return seriesName.value
                    }
                },
                labelLine : {
                    show : false
                }
            },
            emphasis: {
                label: {
                    show: true,
                    position: 'inside',
                    textStyle: {
    		        	fontFamily: 'Microsoft YaHei',
    		        	fontSize: 12,
    		            fontWeight: 'bold',
    		            color: '#414141'          // 主标题文字颜色
    		        },
                    formatter: function(seriesName) {
                    	return seriesName.value
                    }
                },
                labelLine : {
                    show : false
                }
            }
    	}
    },
    //仪表盘
    gauge: {
    	axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                width: 8
            }
        },
        axisTick: {            // 坐标轴小标记
            show: false,
        	splitNumber: 10,   // 每份split细分多少段
            length :12,        // 属性length控制线长
            lineStyle: {       // 属性lineStyle控制线条样式
                color: 'auto'
            }
        },
        axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
            textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                color: 'auto'
            }
        },
        splitLine: {           // 分隔线
            show: true,        // 默认显示，属性show控制显示与否
            length :30,         // 属性length控制线长
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: 'auto'
            }
        },
        pointer : {
            width : 5
        },
        title : {
            show : true,
            offsetCenter: [0, '-110%'],       // x, y，单位px
            textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                fontWeight: 'bolder',
                fontSize: 12
            }
        },
        detail : {
            formatter:'{value}%',
            textStyle: {
                fontSize : 14
            }
        },
        tooltip: {
            show: false
        }
    },	
};
</script>