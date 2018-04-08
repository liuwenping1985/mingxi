{
	tooltip : {
        trigger: 'axis',
        showDelay : 0,
        formatter : function (params) {
           return params.name + ' :<br/>'
           		   + '超期结束流程数：' + params.value[1] + '次<br/>'
                   + '超期平均处理时长：' + format(params.value[0], {$workTimeOfDay} );
        },  
        axisPointer:{
            show: true,
            type : 'cross',
            lineStyle: {
                type : 'dashed',
                width : 1
            }
        }
    },
    xAxis: [
        {
            name: '{$xAxisName}',
            type: 'value',
            scale: true,
            axisLabel: {
                formatter: function (value){
                	return format(value, {$workTimeOfDay} );}
            }
        }
    ],
    yAxis: [
        {
            name: '{$yAxisName}',
            type: 'value',
            scale: true,
            axisLabel: {
                formatter: '{literal}{{/literal}value{literal}}{/literal}'
            }
        }
    ],
    series: [
        {
            type: 'scatter',
            data: [{foreach from=$dataList item='data'} {
            	"name":"{$data[0]}","value":[{$data[1]},{$data[2]}]},{/foreach}],
            itemStyle: {
                normal : { 
                	label : { 
                		show: true, position: 'right', formatter : '{literal}{{/literal}b{literal}}{/literal}'} }
            },
            markPoint: {
                data: [
                    {
                    	type: 'max',name: '最大值'},
                    {
                    	type: 'min',name: '最小值'}
                ]
            },
            markLine: {
            	tooltip : {
                   	trigger: 'axis',
                	formatter: function (params) {
                      	return params.name +":"+ format(params.value, {$workTimeOfDay} );
                    }
                },
        		itemStyle: {
        			normal: {
        				label: {
        					show: true, formatter: function(p) {
        						return p.name  + format(p.value, {$workTimeOfDay} );}}},
        			emphasis: {
        				label: {
        					show: true, formatter: function(p) {
        						return p.name + format(p.value, {$workTimeOfDay} );}}}
        		},
                data: [
                    [
                        {
                        	name: '平均超期时长',value: '{$avgValue}',xAxis: {$avgValue},yAxis: 0},
                        {
                        	name: '',xAxis: {$avgValue},yAxis: 1000}
                    ]
                ]
            }
        }
    ]
}