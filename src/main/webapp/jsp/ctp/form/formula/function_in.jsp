<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.bean.FormFormulaBean"%>
<%@ page import="com.seeyon.ctp.form.bean.FormBean"%>
<HTML>
<HEAD>
<TITLE>in函数设置</TITLE>
<script type="text/javascript">
var enumSplitStr = "<%=FormFormulaBean.ENUM_SPLIT_STR%>";
//配置参数
var dialogArg = window.dialogArguments;//所有参数
var conditionType = dialogArg.conditionType;
var isRelation = false;
<c:if test="${otherForm ne null}">;
isRelation = true;
</c:if>
function OK(){
    var field = $("#field1").val();
    var checkedValue = $('input[type="radio"][name="radio"]:checked').val();
    var reValue;
    var reStr;
    var vaStr;
    if(checkedValue&& checkedValue=='1'){
        vaStr = $("#fieldvalue1").val();
        var orgName = $("#fieldvalue1_txt").val();
        var orgNames = orgName.split("、");
        if(vaStr){
            var sss = vaStr.split(",");
            var rr = "";
            for(var o=0;o<sss.length;o++){
                rr = rr + sss[o].substring(sss[o].indexOf("|")+1, sss[o].length)+enumSplitStr+orgNames[o]+enumSplitStr+",";
            }
            vaStr = rr.substring(0, rr.length-1);
        }else{            
            $.alert("${ctp:i18n('form.formula.function.in.notnull')}");
            return '';
        }
        reValue = "'"+vaStr+"'";
    }else{
        vaStr = $("#fieldvalue" + checkedValue).val();
        if(!vaStr){
            $.alert("${ctp:i18n('form.formula.function.in.notnull')}");
            return '';
        }
        reValue = vaStr;
    }
    reStr = " in("+field+","+reValue+") ";
    return reStr;
}
function init(){
  <c:if test="${compHtml ne null}">
    $("#fieldvalue1Lable").html("${compHtml}");
    $("#fieldvalue1").comp();
  </c:if>
  <c:if test="${compHtml eq null}">
    $("#input1Div").hide();
    $("#radio2").prop("checked",true);
    $("#fieldvalue2").prop("disabled",false);
    $("#input2Div").show();
  </c:if>
  <c:if test="${fn:length(optionList) > 0}">
    $("#input2Div").show();
  </c:if>
    //因为数据库不支持字段like字段,关联表单的除外，因为已经拿到值了
    if(conditionType == "conditionType_sql" && !isRelation){
        $("#otherField_div").hide();
    }
    if (!dialogArg.showCurrentValue) {
        $("#currentField_div").hide();
    }
    if(!dialogArg.isAutoupdate) {
        $("#auto_currentField_div").hide();
    }
    <%-- V-Join --%>
    <c:if test="${externalType != '0'}">
        $("#otherField_div").hide();
        $("#currentField_div").hide();
        $("#auto_currentField_div").hide();
    </c:if>
}
function setDisabled(id){
    $(".fieldvalue").prop("disabled",true);
    if (id == "fieldvalue1") {
      $("#fieldvalue1").prop("disabled",false);
      $("#fieldvalue1_txt").prop("disabled",false);
      $("span",$("#fieldvalue1Lable")).prop("disabled",false);
        //OA-111216 选中该项时让组织机构重新初始化
        $("#fieldvalue1").comp();
    } else {
      $("#fieldvalue1").prop("disabled",true);
      $("#fieldvalue1_txt").prop("disabled",true);
      $("span",$("#fieldvalue1Lable")).prop("disabled",true);
        //OA-111216 未选中该项时让组织机构图标取消绑定，不能被点击
      var _isrel =  $(".ico16").attr("_isrel");
        if(_isrel){
            $(".ico16").unbind();
        }
      $("#" + id).prop("disabled",false);
    }
}
</script>
</HEAD>
<BODY scroll=no onload="init()">
    <form name="formulaIn" method="post">
        <div class="form_area">
            <div class="clearfix margin_t_5">
                <div id = "field1Label" class="left" style="width: 110px;text-align: right;">
                    <c:if test="${compHtml eq null}">
                    ${ctp:i18n('form.formula.function.in.sys')}：
                    </c:if> 
                    <c:if test="${compHtml ne null}">
                    ${ctp:i18n('form.formula.engin.formdata.label')}：
                    </c:if> 
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="field1" name ="field1" value="${fieldDisplay}" type="text" readOnly style="width: 200px;"></div>
                    </div>
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "operatorLabel" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.operator.label')}：
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="function_str" value="in" type="text" readOnly style="width: 200px;"></div>
                    </div>
                </div>
            </div>
            
            <div id="input1Div" class="clearfix margin_t_5">
                <div id = "inputTypeLabe1" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio1">
                        <input type="radio" id="radio1" name="radio" class="radio_com"  checked=true value="1" onclick="setDisabled('fieldvalue1')">${ctp:i18n('form.formula.engin.value.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap" id="fieldvalue1Lable"><input id="fieldvalue1" name="fieldvalue1"  value="" type="text" style="width: 200px;"></div>
                    </div>
                </div>
            </div>
  
            <div id="input2Div" class="clearfix margin_t_5" style="display:none">
                <div id = "inputTypeLabe2" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio2">
                        <input type="radio" id="radio2" name="radio" class="radio_com"  value="2" onclick="setDisabled('fieldvalue2')">
                        <c:if test="${compHtml eq null}">
                            ${ctp:i18n('form.formula.engin.formdata.label')}：
                        </c:if> 
                        <c:if test="${compHtml ne null}">
                            ${ctp:i18n('form.formula.function.in.sys')}：
                        </c:if> 
                    </label>
                </div>
                <div class="left " style="width: 200px;">
                    <select class="fieldvalue" id="fieldvalue2" name="fieldvalue2" style="width: 200px;" disabled>
                    <c:forEach items="${optionList}" var="obj" varStatus="status">
                        <c:if test="${compHtml eq null}">
                            <option  value="${valueList[status.index]}">${obj}</option>
                        </c:if> 
                        <c:if test="${compHtml ne null}">
                            <option  value="[${obj}]">${obj}</option>
                        </c:if> 
                    </c:forEach>
                    </select>
                </div>
            </div>
            <c:if test="${compHtml ne null}">
            <div id="otherField_div" class="clearfix margin_t_5">
                <div class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio3">
                        <input type="radio" id="radio3" name="radio" class="radio_com" value="3" onclick="setDisabled('fieldvalue3')"><c:if test="${otherForm ne null}">a.</c:if>${ctp:i18n('form.formula.engin.formdata.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <select class="fieldvalue" id="fieldvalue3" name="fieldvalue3" style="width: 200px;" disabled>
                    <c:forEach items="${fieldList}" var="obj" varStatus="status">
                        <c:if test="${otherForm ne null}">
                        <option id="${obj['id']}" value="{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
                        </c:if>
                        <c:if test="${otherForm eq null}">
                        <option id="${obj['id']}" value="{${obj['display']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.ownerTableIndex}]</c:if>${obj['display']}</option>
                        </c:if>
                    </c:forEach>
                    </select>
                </div>
            </div>
            </c:if>
            <div id="currentField_div" class="clearfix margin_t_5">
                <div class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio4">
                        <input type="radio" id="radio4" name="radio" class="radio_com" value="4" onclick="setDisabled('fieldvalue4')">${ctp:i18n('form.formula.engin.formvalue.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <select class="fieldvalue" id="fieldvalue4" name="fieldvalue4" style="width: 200px;" disabled>
                        <c:forEach items="${fieldList}" var="obj" varStatus="status">
                            <c:if test="${obj['masterField']}">
                            <option id="${obj['id']}" value="[f.${obj['display']}]" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" >[${ctp:i18n('form.base.mastertable.label')}]</c:if> ${obj['display']}</option>
                            </select>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div id="auto_currentField_div" class="clearfix margin_t_5">
                <div class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio5">
                        <input type="radio" id="radio5" name="radio" class="radio_com" value="5" onclick="setDisabled('fieldvalue5')">${ctp:i18n('form.formula.engin.flowformvar.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <select class="fieldvalue" id="fieldvalue5" name="fieldvalue5" style="width: 200px;" disabled>
                        <c:forEach items="${fieldList}" var="obj" varStatus="status">
                            <c:if test="${obj['masterField']}">
                                <option id="${obj['id']}" value="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" ><%=FormBean.FLOW_PREFIX%>[${ctp:i18n('form.base.mastertable.label')}]
                            </c:if>
                            ${obj['display']}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
     </form>
</BODY>
</HTML>