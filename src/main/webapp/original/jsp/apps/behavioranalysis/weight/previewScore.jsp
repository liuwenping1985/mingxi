<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<style>
    .stadic_head_height{height:60px;background: #fbfbfb; }
    .stadic_body_top_bottom{top: 60px;bottom: 50px; background: #fff;}
    .stadic_footer_height{ height:50px; }
    .new-action-bottom{  height: 50px;background: #4d4d4d;border-bottom:none;	vertical-align:middle;text-align:right; line-height: 50px;}
    .new-action-bottom .common_button { height: 28px; line-height: 28px; text-align: center; font-size:12px; cursor: pointer;}
    .someInfo{ font-size: 14px; line-height: 23px;  color: #777; padding:7px 0 0 20px; height: 52px; border-bottom: 1px solid #e2e2e2;}
	.module{ width:355px; margin:12px 0 0 20px; float:left; background:#FBFBFB;}
	.module .moduleTable{ border-collapse: collapse; border-bottom: 1px solid #E3E3E3; border-right: 1px solid #E3E3E3; font-size: 14px;}
	.module .moduleTable .inputfield{ width:60px; height: 18px; line-height: 18px; font-size: 12px; text-align: center; margin:0 5px; font-size: 13px;}
	.module .moduleTable th{ height: 30px; }
	.module .moduleTable th .inputfield{ border:1px solid transparent;}
	.module .moduleTable th{ background: #80AAD4; color: #fff; }
	.module .moduleTable td{ height: 34px; }
	.module .moduleTable td .inputfield{ border:1px solid #DEE4EF;}
	.secondTitle td{border-bottom: 1px solid #fafafa;}
	.fieldTotal td{ height: 50px; padding-top:10px; padding-bottom:10px;}
	.error-info{ background: #FCD6D6; color: #E46666; }
	.padding_l_40{padding-left: 40px;}
	.clearboth{ clear: both; }

	.previewDiv{width:490px; margin:0 auto;}
	.previewDiv h4{ text-align: center; font-size: 14px; line-height: 30px; margin:0px}
	.previewDiv p{ font-size: 14px; line-height: 20px; }
	.previewDiv .previewDivTable td{border-bottom: 1px solid #E3E3E3; height: 30px;}
	.hasIcon{ padding-left: 80px; }
	.showName{width:150px;display: block;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;}
	.bg_color_blueLight tr{background: #80AAD4;color: #fff;height: 30px;line-height: 30px;font-size: 14px;}
	.score_rank tr {font-size: 14px;}
</style>
</head>
<body>
	<div class="clearboth previewDiv">
		<h4>${dataTime }</h4>
		<p>${ctp:i18n("behavioranalysis.weightSet.desc3") }<!-- 说明：仅对上月人员行为绩效分进行权重调整前后的对比显示（示例），不影响上月人员行为绩效，设置保存后，调整结果会在当月底统计生效。 --></p>
		
		<table class="previewDivTable" width="490" border="0" cellspacing="0" cellpadding="0">
		  <thead class="bg_color_blueLight">
		    <tr>
		      <th align="left" class="padding_l_20">${ctp:i18n("behavioranalysis.weightSet.name") }</th>
		      <th align="center" width="190">${ctp:i18n("behavioranalysis.weightSet.before") }<!-- 调整前 --></th>
		      <th align="center" width="190">${ctp:i18n("behavioranalysis.weightSet.after") }<!-- 调整后 --></th></tr>
		  </thead>
		  <tbody id="data_score" class="score_rank">
		    
		  </tbody>
		</table>
	</div>

<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript">
	$(function(){
		var queryoptions = window.parentDialogObj["previewScore"].getTransParams();
		var indexScoreManager = new rptIndexScoreManager();
		var retMap = indexScoreManager.findMemberScoreByAccount(queryoptions);
		var html = "";
		var len = retMap.scoreDataList.length;
		for(var i=0;i<len;i++){
			var data = retMap.scoreDataList[i];
			var arrow = "";
			if(parseInt(data[1]) > parseInt(data[2])){
				arrow = "&ensp;<span class='ico16 behavioranalysis_down'></span>";
			}else if(parseInt(data[1]) < parseInt(data[2])){
				arrow = "&ensp;<span class='ico16 behavioranalysis_up'></span>";
			}
			
			if(i == 20 && len == 40){
				var emputRow = "<tr><td></td><td align='center'>......</td><td></td></tr>";
				html += emputRow;
			}
			var row = "<tr><td align='left' class='padding_l_20'><span class='showName' title='"
				+ data[0] + "'>"
				+ data[0] + "</span></td><td align='center' width='190'>"
				+ data[1] + "${ctp:i18n("behavioranalysis.weightSet.fen") }</td><td align='left' width='190'><span class='hasIcon'>"
				+ data[2] + "${ctp:i18n("behavioranalysis.weightSet.fen") }" + arrow + "</span></td></tr>";
			html += row;
		}
		$("#data_score").html(html);
	});
</script>
</body>
</html>