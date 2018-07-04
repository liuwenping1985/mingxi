<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
  var personIds = "", personString = "";
  var planTypeArray = [ 2 ], receiTypeArray = [ 1, 2, 3 ], replyArray = [ 0, 1 ,2 ];

  $().ready(function() {
    var pv = getA8Top().paramValue;
    //"personids='1,2,3';personString='a,b,c';arr1=[1,2,3];arr2=[4,2,5];arr3=[2,3,4]"
    if (pv && pv != null && pv != "default") {
      var params = pv.split("&,");
      for ( var i = 0; i < params.length; i++) {
        eval(params[i]);
      }
    }
    fillTheForm();
    $(".radio_com").change(function() {
      checkIt(this);
    });
  });
  function fillTheForm() {
    $("#selectPeople").val(personString);

    var checkboxPlanType = $("[name=planType]");
    var checkboxReceiveType = $("[name=receiveType]");
    var checkboxReply = $("[name=reply]");

    for ( var k = 0; k < checkboxPlanType.length; k++) {
      for ( var i = 0; i < planTypeArray.length; i++) {
        if (checkboxPlanType[k].id == "planType_" + planTypeArray[i]) {
          checkboxPlanType[k].checked = true;
        }
      }
    }
    for ( var k = 0; k < checkboxReceiveType.length; k++) {
      for ( var i = 0; i < receiTypeArray.length; i++) {
        if (checkboxReceiveType[k].id == "receiveType_" + receiTypeArray[i]) {
          checkboxReceiveType[k].checked = true;
        }
      }
    }
    var replyArrayIndex = 0;
    for ( var k = 0; k < checkboxReply.length; k++) {
      for ( var i = 0; i < replyArray.length; i++) {
        if(replyArray[i] != 1) {
            replyArrayIndex = 0;
        } else {
            replyArrayIndex = 1;
        }
        if (checkboxReply[k].id == "reply_" + replyArrayIndex) {
          checkboxReply[k].checked = true;
        }
      }
    }
  }
  function OK() {
    var needChoosePerson = "${allPeople}";
    if (needChoosePerson == "false" && personIds == "") {
      $.alert("${ctp:i18n('plan.portal.conditionpanel.selectpeople')}！");
      return;
    }

    var rvArr = new Array();
    var array = new Array();
    var str1 = 'personIds="' + personIds + '"&';
    var str2 = 'personString="' + personString + '"&';
    var str3 = 'planTypeArray=' + $.toJSON(planTypeArray) + "&";
    var str4 = 'receiTypeArray=' + $.toJSON(receiTypeArray) + "&";
    var str5 = 'replyArray=' + $.toJSON(replyArray);
    array[0] = str1;
    array[1] = str2;
    array[2] = str3;
    array[3] = str4;
    array[4] = str5;
    rvArr[0] = array;
    return rvArr;
  }

  var removeEle = function(array, ele) {
    var tempList = new Array();
    var k = 0;
    for ( var i = 0; i < array.length; i++) {
      if (array[i] != ele) {
        tempList[k++] = array[i];
      }
    }

    return tempList;
  };

  function checkIt(dom) {
    var id = dom.id;
    var value = parseInt(dom.value);
    var checked = dom.checked;
    if (id.indexOf("planType_") >= 0) {
      if (checked) {
        planTypeArray.push(value);
      } else {
        if (planTypeArray.length == 1) {
          $.alert("${ctp:i18n('plan.portal.conditionpanel.leastone')}！");
          dom.checked = true;
        } else {
          planTypeArray = removeEle(planTypeArray, value);
        }
      }
    }
    if (id.indexOf("receiveType_") >= 0) {
      if (checked) {
        receiTypeArray.push(value);
      } else {
        if (receiTypeArray.length == 1) {
          $.alert("${ctp:i18n('plan.portal.conditionpanel.leastone')}！");
          dom.checked = true;
        } else {
          receiTypeArray = removeEle(receiTypeArray, value);
        }
      }
    }
    if (id.indexOf("reply_") >= 0) {
      if (checked) {
        replyArray.push(value);
        if(value == 0) {
            replyArray.push(2);
        }
      } else {
        if (replyArray.length == 1) {
          $.alert("${ctp:i18n('plan.portal.conditionpanel.leastone')}！");
          dom.checked = true;
        } else {
          replyArray = removeEle(replyArray, value);
          if(value == 0) {
              var val = 2;
              replyArray = removeEle(replyArray, val);
          }
        }
      }
    }

  }

  function selectPeople() {
    $.selectPeople({
      panels : 'Department,Team,Post,Level,Outworker,RelatePeople',
      selectType : 'Member,Account,Department,Team,Post,Level',
      minSize : 0,
      showMe : false,
      isNeedCheckLevelScope : false,
      params : {
        type : 'selectPeople',
        value : personIds,
        text : personString
      },
      callback : function(ret) {
        personIds = ret.value;
        personString = ret.text;
        $("#selectPeople").val(personString);
      }
    });
  }
</script>
<body>
  <div class="font_size12">
    <table align="center">
      <c:if test="${allPeople eq false}">
        <tr id="selectPeopleArea" style="height: 30px;">
          <td>${ctp:i18n('plan.portal.conditionpanel.assignpeople')}:</td>
          <td colspan="2"><input id="selectPeople" type="text" value=""
            onclick="selectPeople()" />
          <td>
          <td></td>
          <td></td>
        </tr>
      </c:if>
      <tr id="planTypeArea" style="height: 30px;">
        <td>${ctp:i18n('plan.summary.tab.plantype')}:</td>
        <td><label for="Checkbox1" class="margin_r_10 hand"> <input
            type="checkbox" value="2" id="planType_2" name="planType"
            class="radio_com">${ctp:i18n('plan.portal.conditionpanel.weeklyplan')}
        </label></td>
        <td><label for="Checkbox2" class="margin_r_10 hand"> <input
            type="checkbox" value="3" id="planType_3" name="planType"
            class="radio_com">${ctp:i18n('plan.portal.conditionpanel.monthlyplan')}
        </label></td>
        <td><label for="Checkbox3" class="margin_r_10 hand"> <input
            type="checkbox" value="1" id="planType_1" name="planType"
            class="radio_com">${ctp:i18n('plan.portal.conditionpanel.daylyplan')}
        </label></td>
        <td><label for="radio17" class="hand"> <input
            type="checkbox" value="4" id="planType_4" name="planType"
            class="radio_com">${ctp:i18n('plan.portal.conditionpanel.allanyscopeplan')}
        </label></td>
      </tr>
      <tr id="receiveType" style="height: 30px;">
        <td>${ctp:i18n('plan.portal.conditionpanel.receivetype')}:</td>
        <td><label for="Checkbox1" class="margin_r_10 hand"> <input
            type="checkbox" value="1" id="receiveType_1" name="receiveType"
            class="radio_com">${ctp:i18n('plan.toolbar.button.to')}
        </label></td>
        <td><label for="Checkbox2" class="margin_r_10 hand"> <input
            type="checkbox" value="2" id="receiveType_2" name="receiveType"
            class="radio_com">${ctp:i18n('plan.toolbar.button.cc')}
        </label></td>
        <td><label for="Checkbox3" class="margin_r_10 hand"> <input
            type="checkbox" value="3" id="receiveType_3" name="receiveType"
            class="radio_com">${ctp:i18n('plan.toolbar.button.apprize')}
        </label></td>
        <td></td>
      </tr>
      <tr id="replyArea" style="height: 30px;">
        <td>${ctp:i18n('plan.grid.label.replystatus')}:</td>
        <td><label for="Checkbox1" class="margin_r_10 hand"> <input
            type="checkbox" value="1" id="reply_1" name="reply"
            class="radio_com">${ctp:i18n('plan.desc.replydetail.replyed')}
        </label></td>
        <td><label for="Checkbox2" class="margin_r_10 hand"> <input
            type="checkbox" value="0" id="reply_0" name="reply"
            class="radio_com">${ctp:i18n('plan.desc.replydetail.unreplyed')}
        </label></td>
        <td></td>
        <td></td>
      </tr>
    </table>
  </div>
</body>
</html>