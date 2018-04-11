<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
<style type="text/css">
	tr{
		height: 30px;
	}
</style>
<script type="text/javascript" language="javascript">

$().ready(function() {
});

function OK(){
	var json = "";
	$("input[name='assistvalue']").each(function(){
		if($(this).val()==''){
			$.alert("辅助核算不能为空！");
			return false;
		}
		var type = $("#type_"+$(this).attr("index")).val();
		json = json + type + ": "+$(this).val()+";";
	});
	return json;
}
</script>
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="">
	<div class="form_area">
		<div class="one_row" style="width:90%;">
			
			<div  style="width: 100%;border: 0px;" align="left">				        
				<table id="mytable" border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top: 10px;">
		        	<tr bgcolor="#B5DBEB" style="font-weight: bold;" align="center">
		        		<td width="50%">辅助核算项类型</td>
		        		<td width="50%">辅助核算</td>
		        	</tr>
					        	
		        	<c:forEach	items="${map}" var="assist" varStatus="status">					        		
			        	<tr align="center">
			        		<td  class="common_txtbox_wrap" id="type">
			        			<input type="text" id="type_${status.count }" name="assisttype" readonly="readonly"  value="${assist.key}" name="辅助核算项类型"
									 style="border: 0px;">
			        		</td>
			        		<td  class="common_txtbox_wrap">
								<input type="text" id="value_${status.count }" index="${status.count }" class="validate word_break_all"  value="${assist.value}" name="assistvalue"
									validate="minLength:1,maxLength:255" style="border: 0px;">
							</td>
			        </tr>
		        </c:forEach>
		     </table>
		</div>
	</div>
</body>
</html>