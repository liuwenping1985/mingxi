{
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:['{$serieName}']
    },
    calculable : true,
    xAxis : [
        {
            type : 'category',
            name: '{$xAxisName}',
            data : [{foreach from=$xAxisDataList item='xAxisData'}'{$xAxisData}',{/foreach}]
        }
    ],
    yAxis : [
        {
            type : 'value',
            name: '{$yAxisName}',
          	axisLabel : { 
          		formatter: '{literal}{{/literal}value{literal}}{/literal}天'}
        }
    ],
    series : [
        {
            name:'{$serieName}',
            type:'bar',
            data:[{foreach from=$serieDataList item='serieData'}{$serieData},{/foreach}],
            markPoint : {
                data : [
                    {
                    	type : 'max', name: '最大值'},
                    {
                    	type : 'min', name: '最小值'}
                ]
            },
            markLine : {
                data : [
                    {
                    	type : 'average', name: '平均值'
                    }
                ]
            }
        }
    ]
}