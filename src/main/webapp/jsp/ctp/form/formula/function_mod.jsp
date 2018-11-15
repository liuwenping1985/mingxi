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
          setDisabled(true);
        });
        function setDisabled(init){
          if(init || $("#fieldval").prop("checked")){
              $("#fieldval").prop("checked",true);
              $("#field1").prop("disabled",false);
              $("#field2").prop("disabled",true);
          }else{
              $("#handval").prop("checked",true);
              $("#field1").prop("disabled",true);
              $("#field2").prop("disabled",false);
	          }
	      }
        function OK(){
          if($("#fieldval").prop("checked")){
            return $("#field1").val();
          } else{
            var value = $("#field2").val().trim();
            if (value =="0" || value===0){
              $.alert("除数不能为0！");
              return false;
            }
            if (value ==""){
              $.alert("除数不能为空！");
              return false;
            }
            value = parseFloat(value)+''
            return value;
          }
        }
        </script>
    </head>
    <body>
        <form action="">
            <div class="clearfix font_size12 margin_t_10">
	            <div class="left"  style="width: 110px;text-align: right;">${ctp:i18n("form.formula.engin.dividend.label") }：</div>
	            <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="title" name ="title" value="<c:if test="${field['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${field.display }" type="text" readOnly style="width: 200px;"></div>
                    </div>
                </div>
            </div>
            <div id="fieldvaldiv" class="clearfix margin_t_10">
                <div class="left"  style="width: 110px;text-align: right;">
                    <div class="common_radio_box clearfix" onclick="setDisabled()">
                        <label class=" hand" for="fieldval">
                        <input name="option" class="radio_com" id="fieldval" type="radio" value="0">${ctp:i18n("form.formula.engin.divisor.label") }：</label>
                    </div>
                </div>
                <div class="left common_selectbox_wrap" style="width: 200px;">
                     <select id="field1" name="field1" style="width: 200px;">
                     <c:forEach items="${fieldList}" var="obj" varStatus="status">
                         <option id="${obj['id']}" value="{${obj['display']}}"  formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
                     </c:forEach>
                     </select>
                 </div>
            </div>
            <div id="handvaldiv" class="clearfix margin_t_10">
                <div class="left"  style="width: 110px;text-align: right;">
                    <div class="common_radio_box clearfix"onclick="setDisabled()">
                        <label class=" hand" for="handval">
                        <input name="option" class="radio_com" id="handval" type="radio" value="1">${ctp:i18n("form.formula.engin.handwork.label") }：</label>
                    </div>
                </div>
                <div class="left common_selectbox_wrap" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="field2" name ="field2" value="" type="text"  style="width: 200px;" class="comp" comp="type:'onlyNumber',numberType:'int'"></div>
                    </div>
                 </div>
            </div>
        </form>
    </body>
</html>