{
    tooltip : {
        trigger: 'axis'
    },
    legend: {
        data:[
            '{$serieName1}','{$serieName2}'
        ]
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
            axisLabel:{
            	formatter:'{literal}{{/literal}value{literal}}{/literal}'}
        }
    ],
    series : [
        {
            name:'{$serieName1}',
            type:'bar',
            data:[{foreach from=$serieDataList1 item='serieData1'}{$serieData1},{/foreach}]
        },
        {
            name:'{$serieName2}',
            type:'bar',
            data:[{foreach from=$serieDataList2 item='serieData2'}{$serieData2},{/foreach}]
        }
    ]
}