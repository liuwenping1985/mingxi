<%@ page import="com.seeyon.ctp.form.util.Enums" %>
<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
        <title>Insert title here</title>
        <script type="text/javascript">
        $().ready(function(){
            $("#rowConditionSet").click(function(){
                rowConditionSetFun($(this));
            });
        });
        function OK(){
            var fieldType = "${field.fieldType}";
            var returnValue = $("#fieldSelect").val();
            if(fieldType == "<%=Enums.FieldType.DECIMAL.getKey()%>") {
                var rowCondition = $("#rowCondition").val();
                var rcs = rowCondition.split("|");
                var rcArray = new Array();
                if(rcs != "" && rcs.length > 0) {
                    for(var i=0;i<rcs.length;i++){
                        rcArray.push("{"+rcs[i]+"}");
                    }
                    returnValue += ","+rcArray.join("|");
                }
            }
            return returnValue;
        }

        function rowConditionSetFun(obj) {
            if(obj.hasClass("common_button_disable")){
                return;
            }
            selectChoose("rowCondition",null,null,{ownerTableIndex:'${oField.ownerTableIndex}',fieldName:'${oField.name}'},function(valueObj){
                var key="";
                var value="";
                for ( var i = 0; i < valueObj.length; i++) {
                    if(i==valueObj.length-1){
                        key += valueObj[i].key;
                        value += valueObj[i].value;
                    }else{
                        key += valueObj[i].key+"|";
                        value += valueObj[i].value+"|";
                    }
                }
                $("#rowCondition").val(value);
            });
        }
        </script>
    </head>
    <body>
        <form action="">
            <div class="clearfix font_size12 margin_t_10">
	            <div class="left"  style="width: 110px;text-align: right;">${ctp:i18n("form.formula.engin.formdata.label") }：</div>
	            <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <select id="fieldSelect" name="fieldSelect" style="width: 200px;">
                            <c:forEach items="${fieldList}" var="obj" varStatus="status">
                                <option id="${obj['id']}" value="{${obj['display']}}"  formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if><c:if test="${field.display eq obj.display}"> selected=selected</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj['ownerTableIndex'] }]</c:if>${obj['display']}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
            <c:if test="${field.fieldType eq 'DECIMAL'}">
                <div class="clearfix font_size12 margin_t_10">
                    <div class="left"  style="width: 110px;text-align: right;">${ctp:i18n("form.formula.engin.function.preRow.set.rowCondition.label") }：</div>
                    <div class="left" style="width: 200px;">
                        <div class="common_txtbox_wrap">
                            <input id="rowCondition" name ="rowCondition" value="" type="text" readonly style="width: 200px;"  mytype="13" />
                        </div>
                     </div>
                    <div class="clearfix">
                        <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="rowConditionSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                    </div>
                </div>
            </c:if>
        </form>
    </body>
<%@ include file="../common/common.js.jsp" %>
</html>