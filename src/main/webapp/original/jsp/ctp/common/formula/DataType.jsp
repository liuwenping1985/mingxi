<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.seeyon.ctp.common.formula.enums.*" %>
<script type="text/javascript">
function getDataType(v){
	<% DataType[] enums = DataType.values();
		for(DataType a : enums){%>
			if(v=='<%=a.getKey()%>'){
				
				return '<%=a.getText()%>';
			}
	<%}	%>
		return v;
}

</script>