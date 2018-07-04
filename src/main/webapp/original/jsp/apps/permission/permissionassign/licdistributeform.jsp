<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
$().ready(function() {
$("#query").click(function(){
	 $(".org_accname").each(function() {
	     if($(this).html().indexOf($("#queryacc").val())!=-1){	     
	     $(this).parents("tr").find("input:enabled").focus();
	     return false;
		 
	 }
	    });
});
var MxVersion=$("#MxVersion").val();
$(".MxVersion").html(MxVersion);
});
</script>
</head>
<body>

	<input type="hidden" id="MxVersion"/>
	<form name="unit" id="unit" method="post">
	<div>
		<div class="form_area">
			<div >
				<table border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
						
						<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									
									"${ctp:i18n('licensePermission.queryacc')}":
								</label>
						</th>
						<td nowrap="nowrap">
						<input type="text" id="queryacc" value="" ><a id="query" class="ico16 search_16"></a>
						</td>
							
						</tr>
						<tr>
						<td>
						</td>
							<td nowrap="nowrap">
								<label class="margin_r_10" for="text">
									
									"${ctp:i18n('licensePermission.totalnum')}":server(<label id="totalservernum"></label>);<label class="MxVersion"></label>(<label id="totalm1num"></label>) 
								</label>
							</td>
						</tr>	
						<tr>
						<td>
						</td>
							<td nowrap="nowrap">
								<label class="margin_r_10" for="text">
									
									"${ctp:i18n('licensePermission.unusernum')}":server(<label id="levelservernum"></label>);<label class="MxVersion"></label>(<label id="levelm1num"></label>)
								</label>
							</td>
							
						</tr>
						
						
						<c:forEach items="${ffunitTree}" var="rl">
						<c:if test="${rl.id!='-1730833917365171641'}">
						<tr>
						<th nowrap="nowrap">
								<label class="margin_r_10 org_accname" for="text">
									
									${rl.name}
								</label>
						</th>
						<td nowrap="nowrap" >
							<div id="server">
								Server:
								<input value="0" onchange="getlevelnum()" class = "servertd validate"  size="6" type="text" id="1_${rl.id}" 
									validate="isInteger:true,name:'${rl.name}'">
							</div>
						</td>
						<td nowrap="nowrap" >
							<div id="m1">
							
								<label class="MxVersion"></label>:
								<input value="0" onchange="getlevelnum()" class = "m1td validate" size="6" type="text" id="2_${rl.id}"  
									validate="isInteger:true,name:'${rl.name}'">
							</div>
						</td>
						</tr>
						</c:if>
						</c:forEach>
						
						
					</tbody>
				</table>
			</div>
		
		</div>
	</div>
</form>


</body>
</html>