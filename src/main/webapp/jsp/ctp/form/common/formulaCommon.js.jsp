<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../formula/formulaCommon.js.jsp" %>
<script type="text/javascript">
	
    //单元测试公式条件组件
    function testFormula(){
    	var obj = getFormulaArgs(function(formulaStr){
        	$.alert(formulaStr);
    	},"${formBean.id}","formulaType_number","","");
    	obj.otherformId="-4245051878421477633";
    	showFormula(obj);
    }

    
	var _formulaType_varchar = '<%=FormulaEnums.formulaType_varchar%>';
	var _formulaType_number = "<%=FormulaEnums.formulaType_number%>"
    var _workDay =  "<%=FormConstant.WorkDay%>";
    var _workDateTime = "<%=FormConstant.WorkDateTime%>";
    var _dateTime = "<%=FormConstant.DateTime%>";
    var _day = "<%=FormConstant.Day%>";
    var _imageEnumFormat = '<%=FormatType.FORMAT4IMAGEENUMOPTION.getText()%>';
    var _imageEnumFormat4Formula = '<%=FormatType.FORMAT4IMAGEENUMFORMULAOPTION.getText()%>';
</script>

<script type="text/javascript" src="${path}/common/form/common/formulaCommon.js${ctp:resSuffix()}"></script>