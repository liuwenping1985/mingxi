<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2015-10-26
  Time: 13:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page import="com.seeyon.ctp.form.util.Enums.FlowDealOptionsType"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>设置流程处理意见格式</title>
</head>
<body>
<form method="post" action="" >
  <div class = "margin_t_30 margin_l_10 margin_r_10  font_size12 clearfix">
    <div>
    <fieldset id="authFieldMap" class="margin_l_10 margin_r_10 " style="border: 1px solid #dddddd;padding-left:10px;padding-right:10px;padding-top:15px;padding-bottom:15px;">
      <div class="margin_t_10">
        <label class="margin_r_10 hand" for="att">
          <span>【</span><input name="format" class="radio_com att" id="att" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.attitude")}">${ctp:i18n("form.format.flowprocessoption.attitude")}<span>】</span></label>
        <label class="margin_r_10 hand" for="inscribe">
          <input name="format" class="radio_com inscribe" id="inscribe" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.inscribe")}">${ctp:i18n("form.format.flowprocessoption.inscribe")}</label>
      </div>
      <div class="margin_tb_10 padding_r_5" style="vertical-align: middle;height: 26px;line-height: 26px;">
        <div class="right">
          <label class="margin_r_10 hand" for="date">
            <input name="format" class="radio_com date" id="date" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.date")}">${ctp:i18n("form.format.flowprocessoption.date")}</label>
          <label class="margin_r_2 hand" for="time">
            <input name="format" class="radio_com time" id="time" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.time")}">${ctp:i18n("form.format.flowprocessoption.time")}</label><span>]</span>
        </div>
        <div class="right margin_r_10 padding_lr_4" style="border:1px dotted #87abd6;border-radius: 3px;">
          <label class="margin_r_10 margin_l_4" for="name">
            <input name="name" class="radio_com name" id="name" type="radio" title="${ctp:i18n("form.format.flowprocessoption.name")}">${ctp:i18n("form.format.flowprocessoption.name")}</label>
          <label class="margin_r_10 hand" for="signet">
            <input name="name" class="radio_com signet" id="signet" type="radio" title="${ctp:i18n("form.format.flowprocessoption.signet")}">${ctp:i18n("form.format.flowprocessoption.signet")}</label>
          <label class="margin_r_4 hand" for="none">
            <input name="name" class="radio_com none" id="none" type="radio"  title="${ctp:i18n("form.format.flowprocessoption.none")}">${ctp:i18n("form.format.flowprocessoption.none")}</label>
        </div>
        <div class="right">
          <span>[</span><label class="margin_r_10 hand" for="dept">
          <input name="format" class="radio_com dept" id="dept" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.dept")}">${ctp:i18n("form.format.flowprocessoption.dept")}</label>
          <label class="margin_r_10 hand" for="post">
            <input name="format" class="radio_com Post" id="post" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.post")}">${ctp:i18n("form.format.flowprocessoption.post")}</label>
        </div>
      </div>
    </fieldset>
    </div>
    <div class="margin_t_20">
      <div>
        <label class="margin_r_10 hand" for="nullToShow">
          <input name="controll" class="radio_com nullToShow" id="nullToShow" type="checkbox" title="${ctp:i18n("form.format.flowprocessoption.nullOpinion")}">${ctp:i18n("form.format.flowprocessoption.nullOpinion")}</label>
      </div>
      <div class="margin_t_20">
      <label class="margin_r_10 hand" for="temporaryToShow">
        <input name="controll" class="radio_com temporaryToShow" id="temporaryToShow" type="checkbox"  title="${ctp:i18n("form.format.flowprocessoption.temporaryToShow")}">${ctp:i18n("form.format.flowprocessoption.temporaryToShow")}</label>
        </div>
      <div class="margin_t_20">
      <label class="margin_r_10 hand" for="backToShow">
        <input name="controll" class="radio_com backToShow" id="backToShow" type="checkbox"  title="${ctp:i18n("form.format.flowprocessoption.backOpinion")}">${ctp:i18n("form.format.flowprocessoption.backOpinion")}</label>
        </div>
    </div>
  </div>
</form>
</body>
<script type="text/javascript">
  var hasSetted = ${hasSetted};//是否已经设置显示格式
  var typeArray = new Array;//所有设置的集合

  <c:forEach items="${opinionTypes}" var="type">
    $("#"+"${type.text}").val("${type.key}");
    var obj = new Object;
    obj.key = "${type.key}";
    obj.text = "${type.name}";
    typeArray.push(obj);
  </c:forEach>
  var formatStr = "${formatStr}";

  $().ready(function(){
    if(hasSetted){
      //回填已设置的格式
      var selected = formatStr.split(",");
      for(var i = 0,len = selected.length;i<len;i++){
        $("input[value="+selected[i]+"]").attr("checked",true);
      }
    }else {
      //缺省勾选：态度、意见、姓名、日期、时间、回退意见不显示
      $("input:checkbox").each(function(){
        var id = $(this).attr("id");
        if(id == "att" || id == "inscribe" || id == "date" || id == "time" || id == "backToShow"){
          $(this).attr("checked",true);
        }
      });
      $("#name").attr("checked",true);
    }
  });
  function OK(){
    var result;//值
    var showText;//显示值，不包下方三个复选框
    var valueArr = new Array;
    var showArr = new Array;
    var i = 0;
    $("input[name=format]:checked").each(function(){
      valueArr.push($(this).val());
      i++;
    });

    var name = $("input[name=name]:checked").attr("id");
    valueArr.push($("input[name=name]:checked").val());

    if(i == 0 && (name == "none" || name == undefined)){
      $.alert("${ctp:i18n('form.format.flowprocessoption.isNotNull')}");
      return;
    }
    $("input[name=controll]:checked").each(function(){
      valueArr.push($(this).val());
    });

    valueArr.sort();//排序

    for(var i = 0,len = valueArr.length;i<len;i++){
      if(valueArr[i] && getCanShowText(valueArr[i])){
        for(var n = 0,l=typeArray.length;n<l;n++){
          if(typeArray[n].key == valueArr[i]){
            showArr.push(typeArray[n].text);
            break;
          }
        }
      }
    }
    result = valueArr.toString();
    showText = showArr.toString().replace(/,/ig,"");
    return {'key':result,'text':showText};
  }
  //查看设置项是否回填名称
  function getCanShowText(key){
    var arr = "<%=FlowDealOptionsType.getAllCantShowTextString()%>";
    if(arr.indexOf(key) >=0 ){
      return false;
    }
    return true;
  }
</script>
</html>
