<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

</head>
<script type="text/javascript">
	$().ready(function(){
		$(".dataTd").click(function(){
			$(".dataTr").removeAttr("bgcolor");
			$(this).parent("tr").attr("bgColor","#D3E0EC");
			$("input[type='checkbox']").removeAttr("checked");
			$(this).parent("tr").find("td input[name='memberId']").attr("checked","checked");
		});
		$("input[name='memberId']").click(function(){
			if($(this).attr("checked")=='checked'){
				$(".dataTr").removeAttr("bgcolor");
				$(this).parent("td").parent("tr").attr("bgColor","#D3E0EC");
			}else{
				$(this).parent("td").parent("tr").removeAttr("bgcolor");
			}
		});
		$("#checkbox").click(function(){
			if($(this).attr("checked")=='checked'){
				$("input[type='checkbox']").attr("checked","checked");
			}else{
				$("input[type='checkbox']").removeAttr("checked");
			}
		});
	});
	function OK(){
		var v = $("input[name='memberId']:checked");
	    if (v.length < 1) {
	        $.alert("${ctp:i18n('multicall.plugin.message.choosedata')}");
	        return false;
	    }else if (v.length > 200){
	    	$.alert("${ctp:i18n('multicall.plugin.message.limit')}"+v.length);
	        return false;
	    }else{
	    	var params = new Object();
	    	params.company_id = $("#company_id").val();
	    	params.call_time = $("#call_time").val();
	    	params.signature = $("#signature").val();
	    	params.user_name = $("#user_name").val();
	    	params.user_phone = $("#user_phone").val();
	    	params.user_role = $("#user_role").val();
	    	var noPhoneArr = new Array();
	    	var invalidPhoneArr = new Array();
	    	var parties = "[";
	    	var num = 0;
	    	var regex = /((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/;
	    	if(params.user_phone=='' || !regex.test(params.user_phone)){
	    		$.alert("${ctp:i18n('multicall.plugin.message.hostphone')}");
	    		return false;
	    	}
	    	for(var i=0; i<v.length; i++){
	    		var memberName = $(v[i]).parent().next().children("span").text();
	    		var memberPhone = $(v[i]).parent().next().next().children("span").text();
	    		if(memberPhone==''){
	    			noPhoneArr[noPhoneArr.length] = memberName;
	    		}else if(!regex.test(memberPhone)){
	    			invalidPhoneArr[invalidPhoneArr.length] = memberName;
	    		}else{
	    			parties = parties + '{"name":"'+memberName+'","phone":"'+memberPhone+'"},';
	    			num++;
	    		}
	    	}
	    	if(num<1){
	    		$.alert("${ctp:i18n('multicall.plugin.message.choosetwodata.valid')}");
	    		return false;
	    	}
     	    parties = parties.substring(0,parties.length-1);
    	    parties = parties+"]";
	    	params.parties = parties;
	    	params.noPhoneArr = noPhoneArr;
	    	params.invalidPhoneArr = invalidPhoneArr;
	    	return params;
		}
	}
</script>
<style>
	#handtable td{
		text-align: left;
		padding: 6pt;
		border-bottom: 1px solid #E1E1E1;
		 white-space:nowrap;overflow:hidden;text-overflow: ellipsis;
	}
</style>
<body>

	<form name="addForm" id="addForm" method="post" target="_add">
		<div class="form_area">
			<div class="one_row" style="width:90%;">
					<div  style="width: 100%;border: 0px;overflow:auto; margin-top: 10px;" align="left">
						<input type="hidden" id="systemAccount" value="${systemAccount}">
						<input type="hidden" id="company_id" value="${company_id}">
						<input type="hidden" id="call_time" value="${call_time}">
						<input type="hidden" id="signature" value="${signature}">
						<input type="hidden" id="user_name" value="${user_name}">
						<input type="hidden" id="user_phone" value="${user_phone}">
						<input type="hidden" id="user_role" value="${user_role}">
				        <table id="handtable" class="flexme3" border="0" cellspacing="0"  cellpadding="0" width="100%" style="table-layout: fixed;margin-top: 5px;">
				        <tbody class="hand">
				        	<tr bgcolor="#80aad4" style="font-size: 12px;font-family: Microsoft YaHei; white-space: nowrap;">
				        		<td width="15%" align="center"><input type="checkbox" id="checkbox"></td>
				        		<td width="40%">${ctp:i18n('multicall.plugin.initiate.peoplelist')}</td>
				        		<td width="44%">${ctp:i18n('multicall.plugin.initiate.phone')}</td>
				        	</tr>
				        	<c:forEach	items="${peopleMap}" var="people">
				        		<tr class="dataTr">
					        		<td align="center" width="15%">
					        			<input type="checkbox" id="memberId" name="memberId" value="${people.value.id}">
					        		</td>
					        		<td width="40%" class="dataTd" nowrap="nowrap">
					        			<span>${ctp:toHTML(people.value.name)}</span>
					        		</td>
					        		<td width="44%" class="dataTd" nowrap="nowrap">
					        			<span>${ctp:toHTML(people.value.phone)}</span>
					        		</td>
				        		</tr>
				        	</c:forEach>
				        	</tbody>
				        </table>
				    </div>
			</div>
		</div>
	</form>
</body>
</html>