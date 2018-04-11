<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@page import="com.seeyon.ctp.form.util.Enums.*"%>
<script type="text/javascript" src="${path}/common/form/formula/formulaCommon.js${ctp:resSuffix()}"></script>
<script type="text/javascript">

/*
*  formulaType:formulaType_number数字类型公式formulaType_varchar字符串类型公式(动态组合)formulaType_date日期类型公式
*var formulaArgs = getFormulaArgs(formId,window,receiverId,formulaType);//公式组件
*
*var formulaArgs = getConditionArgs(formId,window,receiverId,null);//条件组件
*
*showFormula(formulaArgs);
*/
function  getFormulaTypeByFieldType(fieldType){
    var formulaType = "";
    switch(fieldType){
        case "<%=FieldType.VARCHAR.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_varchar%>";
            break;
        };
        case "<%=FieldType.DECIMAL.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_number%>";
            break;
        };
        case "<%=FieldType.TIMESTAMP.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_date%>";
            break;
        };
        case "<%=FieldType.DATETIME.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_datetime%>";
            break;
        };
    }
    return formulaType;
}
</script>