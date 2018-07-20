<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@page import="com.seeyon.apps.ncvoucher.manager.NCVoucherManagerImpl,java.util.List,java.util.ArrayList,java.util.Properties"%>
<%@page import="com.seeyon.apps.ncvoucher.manager.NCVoucherManagerImpl.Provider"%>
<%@page import="com.seeyon.apps.ncvoucher.manager.NCVoucherManager"%>
<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
	<%
		NCVoucherManager ncVoucherManagerImpl1 = (NCVoucherManager)AppContext.getBean("ncVoucherManager");
		List<Provider> providers1=ncVoucherManagerImpl1.getGlorgProviderList();
		pageContext.setAttribute("provider2", providers1);
	%>


<script type="text/javascript" language="javascript">
		<c:forEach var="provider3" items="${provider2}">
			//alert("provider3.id="+p.getId+",name="+"${provider3.name}");
			//alert("provider3.id="+"${provider3.id}"+",name="+"${provider3.name}");
		</c:forEach>

	function OK() {
	    var ncAccount =$("#ncAccount").val();
	    var ncGlorgCode =$("#ncGlorgCode").val();
	    var billdate =$("#billdate").val();
	    var obj = new Array;
		obj[0]=ncAccount;
		obj[1]=ncGlorgCode;
		obj[2]=billdate;
	    return obj;
	}
	
	function onw(){

		var jj=document.getElementById("ncAccount");
		var accouttext="";
		for(i=0;i<jj.length;i++){
			if(jj.value==jj.options(i).value){
				accouttext= jj.options(i).text;
			}
		}
		
		var ii=document.getElementById("ncGlorgCode");
		ii.options.length=0;
		<c:forEach var="provider3" items="${provider2}">
			if(accouttext=="${provider3.id}"){
				var oOption = document.createElement("OPTION");
				oOption.text="${provider3.name}";
				oOption.value="${provider3.code}";
				ii.options.add(oOption);
			}
			//alert("accouttext="+accouttext+",name="+"${provider3.name}"+",provider3.code="+"${provider3.code}"+",id="+"${provider3.id}");
			//alert("provider3.id="+"${provider3.code}"+",name="+"${provider3.name}");
		</c:forEach>

	}
</script>
</head>
<body onload="onw();">
	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row">
		<p class="align_right"></p>
			<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-top: 50px;">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />
				
					<tr>
						<th nowrap="nowrap" width="30%"><label class="margin_r_10" for="text">${ctp:i18n('ncvoucher.plugin.name.choseacount')}</label></th>
						<td>
							<div>
								<select name="ncAccount" id="ncAccount"  class="" onchange="onw()">
								<%
								NCVoucherManager ncVoucherManagerImpl = (NCVoucherManager)AppContext.getBean("ncVoucherManager");
								List<Provider> providers=ncVoucherManagerImpl.getAcountProviderList();
								for(Provider p:providers){
									%>
									<option value="<%=p.getId()%>"><%=p.getName()%></option>
									<%
								}
								%>
								
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap" width="30%"><label class="margin_r_10" for="text">${ctp:i18n('ncvoucher.plugin.name.choseglorg')}</label></th>
						<td>
							<div>
								<select name="ncGlorgCode" id="ncGlorgCode"  class="" >
								<%
								
								for(Provider p:providers1){
									%>
									<option value="<%=p.getCode()%>"><%=p.getName()%></option>
									<%
								}
								%>
								
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ncvoucher.plugin.name.billdate')}</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input id="billdate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'">
							</div>

						</td>
					</tr>		
					<tr>
						<td align="right"></td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>

</body>
</html>