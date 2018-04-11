<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('report.common.crumbs.queryReport')}</title>
</head>
<body class="h100b overflow_auto bg_color_white" id="layout" style="overflow:auto; height: 100%; width:100%;">
           <table class="only_table" id="portalHidden" border="0" cellSpacing="0" cellPadding="0" width="100%">
                    <tr>
                        <td align="center" id="reportName" style="font-size:20px;">${reportName}</td>
                    </tr>
                    <tr>
                        <td align="right" >${ctp:i18n('report.reporting.stepone.grid.formName')}：${formName}</td><!-- 表单名称 -->
                    </tr>
            </table>
            <div id="context">
            <table border="0" cellSpacing="0" cellPadding="0" width="100%" id="ftable">
				<tr>
					<td id="showTd">
						<table class="flexme1"></table>
					</td>
				</tr>
             </table>
           </div>
</body>
<script type="text/javascript">
	$(document).ready(function(){
		initShowTable();
	});
	//预览
	function  initShowTable(){
		var jcTitle="";// 交叉项信息
        <c:if test="${reportCfg.reportHeadCfg.crossColumnCfg!=null}">
        	jcTitle="${reportCfg.reportHeadCfg.crossColumnCfg.title}";
        </c:if>
        
		var headtitle = new Array();//统计分组项
        var headFields = new Array();//分组项字段
        var i = 0;
	    <c:forEach var="head" items="${reportCfg.reportHeadCfg.noCrossColumns}" varStatus="status">
	    	headtitle[i] = "${head.title}";
	    	headFields[i] = "${head.tableCode}" +"."+ "${head.code}";
	    	i++
	    </c:forEach>
        var showDatas = new Array(); // 统计项数组
        var countDatas = new Array();//计算列交叉 数组
        i = 0;var j = 0;
        <c:forEach var="data" items="${reportCfg.showDataList}" varStatus="status">
        	<c:choose>
        		<c:when test="${data.isCrossType }">
        			countDatas[j++] =  "${data.title}";
        		</c:when>
        		<c:otherwise>
        			showDatas[i++] = "${data.title}";
        		</c:otherwise>
        	</c:choose>
	    </c:forEach>
	    
	    var sumDatas = new Array();//行汇总
	    var way = "";
	    var sumField = "";
	    i = 0;
        <c:forEach var="data" items="${reportCfg.sumDataList}" varStatus="status">
        	<c:if test="${data.sumType == 'row'}">
   				way = "${data.calcType}";
   				sumField = "${data.tableCode}" +"."+ "${data.code}";
     			<c:forEach var="column" items="${data.reportColumnList}" varStatus="status">
        			sumDatas[i++] = "${column.title}";
        		</c:forEach>
        	</c:if>
	    </c:forEach>
	    
	    var num = $.inArray(sumField,headFields);//找到汇总字段在统计分组项字段的位置
	    
	    $("#showTd").empty();
	    
	    var title1="";var title2="";//标题 两行标题
		var nullhtml="";//空行 
		var subtotalhtml="";//小计汇总
		var sumhtml="";//最后一行合计
		var nullTd = "<td>&nbsp</td>"; var zeroTd = "<td>0</td>";
		if(0 != headtitle.length){
			for(var i=0;i<headtitle.length;i++){//分组项
				if($.isNull(jcTitle)){//没有有交叉项
					title1 += "<th rowspan='1'>"+headtitle[i]+"</th>";
				}else{
					title1 += "<th rowspan='2'>"+headtitle[i]+"</th>";
				}
				nullhtml += nullTd;
				if(0 != sumDatas.length){
					var sumWay = "";
					var subtotalWay = "";
					if(way == "sum"){
						sumWay = "${ctp:i18n('report.reportDesign.total')}";
						subtotalWay = "${ctp:i18n('report.reportDesign.summarizing')}";
					}else if(way == "count"){
						sumWay = "${ctp:i18n('report.reportDesign.totalCount')}";
						subtotalWay = "${ctp:i18n('report.reportDesign.count')}";
					}else if(way == "avg"){
						sumWay = "${ctp:i18n('report.reportDesign.totalAvg')}";
						subtotalWay = "${ctp:i18n('report.reportDesign.avg')}";
					}else if(way == "max"){
						sumWay = "${ctp:i18n('report.reportDesign.totalMax')}";
						subtotalWay = "${ctp:i18n('report.reportDesign.max')}";
					}else if(way == "min"){
						sumWay = "${ctp:i18n('report.reportDesign.totalMin')}";
						subtotalWay = "${ctp:i18n('report.reportDesign.min')}";
					}
					if(i == num){
						subtotalhtml += "<td><label class='color_black font_bold' for='text'>"+headtitle[i]+"</label>&nbsp"+subtotalWay+"</td>";
						sumhtml += "<td>"+sumWay+"</td>";
					}else{
						subtotalhtml += nullTd;
						sumhtml += nullTd;
					}
				}
			}
		}
		if(0 != showDatas.length){
			if($.isNull(jcTitle)){//没有有交叉项
				for(var j=0;j<showDatas.length;j++){ //统计项
					title1+="<th rowspan='1'>"+showDatas[j]+"</th>";
					nullhtml += nullTd;
					if($.inArray(showDatas[j],sumDatas) != -1){
						subtotalhtml += zeroTd;
						sumhtml += zeroTd;
					}else{
						subtotalhtml += nullTd;
						sumhtml += nullTd;
					}
				}
			}else{
				for(var m=0;m<2;m++){
					title1+="<th colspan='"+showDatas.length+"'>"+jcTitle+(m+1)+"</th>";
					for(var j=0;j<showDatas.length;j++){ //统计项
						title2+="<th>"+showDatas[j]+"</th>";
						nullhtml += nullTd;
						if($.inArray(showDatas[j],sumDatas) != -1){
							subtotalhtml += zeroTd;
							sumhtml += zeroTd;
						}else{
							subtotalhtml += nullTd;
							sumhtml += nullTd;
						}
					}
				}
				for(var n=0;n<countDatas.length;n++){
					title1+="<th colspan='"+showDatas.length+"'>"+countDatas[n]+"</th>";
					for(var j=0;j<showDatas.length;j++){ //统计项
						title2+="<th>"+showDatas[j]+"</th>";
						nullhtml += nullTd;
						if($.inArray(showDatas[j],sumDatas) != -1){
							subtotalhtml += zeroTd;
							sumhtml += zeroTd;
						}else{
							subtotalhtml += nullTd;
							sumhtml += nullTd;
						}
					}
				}
			}
		}
	
		var html="<table class='only_table edit_table' border='0' cellSpacing='0' cellPadding='0' width='100%'><thead><tr>"+title1+"</tr>";
		if(!$.isNull(jcTitle)){
			html += "<tr>"+title2+"</tr>";
		}
		html += "</thead><tbody><tr>"+nullhtml+"</tr>";
		if(0 != sumDatas.length){//设置了 最后一行合计或者 行汇总
			if(num >= 0){//没有设置汇总字段，就不显示汇总行
				html += "<tr>"+subtotalhtml+"</tr>";
			}
			html += "<tr>"+sumhtml+"</tr>";
		}else{
			html += "<tr>"+nullhtml+"</tr>";
		}
		html += "</tbody></table>";
		
		$("#showTd").html(html);

	}
	
	//返回值拼接，以“,”隔开的字符串
    function union(_self, _new) {
        (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
        return _self;
    }
</script>
</html>
