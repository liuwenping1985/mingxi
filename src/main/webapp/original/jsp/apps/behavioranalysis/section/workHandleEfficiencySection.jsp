<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<style type="text/css">
		body{padding: 0px;border: 0px;margin: 0px;background: none;}
		#w_content{margin: 9px 12.5px  30px 12.5px ;}
		.data_li{height: 90px;width: 147px;background-color: #F9F9F9;display: inline-block;border: 1px dashed #DBDBDB;border-radius:15px;margin: 21px 17.5px 0px 17.5px;float: left;}
		.li_time{height: 55px;border-radius:15px  15px 0px   0px ;text-align: center;line-height: 55px;color: #FFF;}
		.li_name{line-height: 35px;text-align: center;font-size: 12px;color: #666666;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;padding: 0px 5px;word-wrap: normal;}
		.zyxt{background-color: #57c9ca;}
		.mblc{background-color: #b8a3df;}
		.jh{background-color: #5ab1ef;}
		.hy{background-color: #f7a256;}
		.xw{background-color: #d97a80;}
		.dc{background-color: #8c99b2;}
		.li_time .num_txt{font-size: 22px;}
	</style>
	<script type="text/javascript">
	$(function(){
		$(".textContent").each(function(index,e){
			//将1天21小时转换为   <span class="num_txt">1</span>天<span class="num_txt">21</span>小时
			$(e).html($(e).html().replace(/\d+/ig,"<span class=\"num_txt\">$&</span>")).show();;
		});
	});
	</script>
</head>
<body style="overflow: auto;">
	<div id="w_content">
		<c:if test="${!empty datas}">
			<c:forEach var="itm" items="${ datas}" varStatus="s">
				<div class="data_li">
					<div class="li_time ${ itm.className}"><span class="textContent display_none">${empty itm.time ? '-' : itm.time}</span></div>
					<div class="li_name" title="${ itm.name}" alt="${ itm.name}">${ itm.name}</div>
				</div>
			</c:forEach>
		</c:if>
	</div>
</body>
</html>