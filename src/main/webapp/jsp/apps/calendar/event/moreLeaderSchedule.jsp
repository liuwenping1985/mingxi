<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Dialog_js.jsp"%>
<html class="h100b">
<style>
.stadic_body_top_bottom {
    overflow: hidden;
}
</style>
<head>
<title>${ctp:i18n('calendar.event.list.title')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript">
  var isList = new Object();
  isList.isList = "isList";
  var curTab = "leaderSchedule";
  var searchobj;
  var continueValue = "";
  var listDataObj = null;
  var rp = 20;

  var curTransParams = {
    searchFunc : search,
    diaClose : viewDialogClose,
    showButton : showBtn,
    isHasConVal : "Yes"
  };

  var initTableForCalEvent = function() {
    var o = new Object();
    o.userId = "${CurrentUser.id}";
    $("#myEvent").ajaxgridLoad(o);
  }

  var initPlanTableForCalEvent = function() {
    //以下是初始化列表数据
    listDataObj = $("#myEvent").ajaxgrid({
      render : rend,
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '5%',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : "${ctp:i18n('calendar.event.create.beginDate')}",
        name : 'beginDate',
        sortable : true,
        width : '10%'
      }, {
        display : "${ctp:i18n('plan.initdata.endTime')}",
        name : 'endDate',
        width : '10%',
        sortable : true
      }, {
        display : "${ctp:i18n('member.list.find.name')}",
        name : 'createUserName',
        width : '10%',
        sortable : true
      }, {
        display : "${ctp:i18n('calendar.event.create.subject')}",
        name : 'subject',
        sortable : true,
        width : '33%'
      }, {
        display : "${ctp:i18n('import.type.account')}",
        name : 'accountName',
        width : '10%',
        sortable : true
      }, {
        display : "${ctp:i18n('import.type.dept')}",
        name : 'departMentName',
        sortable : true,
        width : '10%'
      }, {
        display : "${ctp:i18n('calendar.level.label')}",
        name : 'postName',
        sortable : true,
        width : '10%'
      } ],
      click : dblclk,
      resizable : false,
      parentId : "id",
      managerName : "calEventManager",
      managerMethod : "getLeaderSchedulePage"
    });
    //initTableForCalEvent();
  };

  /**
   * 设置查询条件
   */
  function setQueryParams(returnValue) {
  	if(returnValue==null){
  		return;
  	}
    var condition = returnValue.condition;
    var value = returnValue.value;
    var obj = new Object();
    if (listDataObj != null) {
      if (listDataObj.p.params) {
        obj = listDataObj.p.params;
      }
    }
    if (obj.userId == undefined) {
      obj.userId = $.ctx.CurrentUser.id;
    }
    obj.condition = condition;
    if (condition == "departMentName") {
      var departMentValue = $("#departMentNameValueText").val();
      obj.queryValue = departMentValue;
    } else if (condition == "levelName") {
      var levelValue = $("#levelNameValueText").val();
      obj.queryValue = levelValue;
    } else if (condition == "beginDate" || condition == "endDate") {
      if (value.length > 0) {
        obj.queryValue = value[0];
        obj.queryValue1 = value[1];
      }
    } else {
      obj.queryValue = value;
    }
    $("#conditionText").val(obj.condition);
    $("#firstQueryValueText").val(obj.queryValue);
    $("#secondQueryValueText").val(obj.queryValue1);
    return obj;
  }

  /**
   * 选人界面的操作
   */
  function selectOrganization(valueId, textId, retText, retValue, sltType) {
    var panelsValue = "Department";
    var selectTypeValue = "Department";
    if (sltType == "Department") {
      panelsValue = "Department";
      selectTypeValue = "Department";
    } else {
      panelsValue = "Level";
      selectTypeValue = "Level";
    }
    $.selectPeople({
      type : 'selectPeople',
      panels : panelsValue,
      selectType : selectTypeValue,
      isNeedCheckLevelScope : false,
      text : $.i18n('common.default.selectPeople.value'),
      params : {
        text : retText,
        value : retValue
      },
      maxSize : 1,
      callback : function(ret) {
        if (ret) {
          $("#" + textId).val(ret.text);
          $("#" + valueId).val(ret.value);
        }
      }
    });
  }

  //以下是初始化按钮
  function initToobar() {
    $("#toolbar").toolbar({
      toolbar : [ {
        name : "${ctp:i18n('calendar.event.create.out')}Excel",
        click : exportToExcel,
        className : "ico16 export_excel_16"
      } ]
    });
  }
  //初始化查询控件
  function initSearch() {
    searchobj = $.searchCondition({
      top : 2,
      right : 5,
      searchHandler : function() {
        var obj = setQueryParams(searchobj.g.getReturnValue());
        $("#myEvent").ajaxgridLoad(obj);
      },
      conditions : [
          {
            id : 'title',
            name : 'title',
            type : 'input',
            text : "${ctp:i18n('calendar.event.create.subject')}",
            value : 'subject'
          },
          {
            id : 'memberName',
            name : 'memberName',
            type : 'input',
            text : "${ctp:i18n('member.list.find.name')}",
            value : 'memberName'
          },
          {
            id : 'departMentName',
            name : 'departMentName',
            type : 'input',
            text : "${ctp:i18n('import.type.dept')}",
            value : 'departMentName',
            click : function() {
              var retText = "";
              var retValue = "";
              retText = $("#departMentName").val();
              retValue = $("#departMentNameValueText").val();
              selectOrganization("departMentNameValueText", "departMentName",
                  retText, retValue, "Department");
            }
          },
          {
            id : 'levelName',
            name : 'levelName',
            type : 'input',
            text : "${ctp:i18n('calendar.level.label')}",
            value : 'levelName',
            click : function() {
              var retText = "";
              var retValue = "";
              retText = $("#levelName").val();
              retValue = $("#levelNameValueText").val();
              selectOrganization("levelNameValueText", "levelName", retText,
                  retValue, "Level");
            }
          }, {
            id : 'beginDate',
            name : 'beginDate',
            type : 'datemulti',
            text : "${ctp:i18n('calendar.event.create.beginDate')}",
            value : 'beginDate',
            ifFormat : "%Y-%m-%d",
            dateTime : false
          }, {
            id : 'endDate',
            name : 'endDate',
            type : 'datemulti',
            text : "${ctp:i18n('plan.initdata.endTime')}",
            value : 'endDate',
            ifFormat : "%Y-%m-%d",
            dateTime : false
          } ]
    });
  }
  $(document).ready(function() {
    initSearch();
    initToobar();
    initPlanTableForCalEvent();
    initTableForCalEvent();
    /**********禁止文本框粘贴功能***********/
    $("#departMentName").attr("onpaste","return false");
    $("#levelName").attr("onpaste","return false");
  });
</script>
</head>
<body class="h100b page_color">
    <div id='layout' class="comp stadic_layout" comp="type:'layout'">
        <input type="hidden" id="caleventtotal" name="caleventtotal" value="${caleventtotal}" />
        <div class="stadic_layout_head stadic_head_height" layout="border:false,height:30,maxHeight:100,minHeight:30">
            <div class="common_search_box right clearfix" id="curSearchVal"></div>
            <div id="toolbar"></div>
            <input type="hidden" id="departMentNameValueText" name="departMentNameValueText" /> <input type="hidden"
                id="levelNameValueText" name="levelNameValueText" /> <input type="hidden" id="conditionText"
                name="conditionText" /> <input type="hidden" id="firstQueryValueText" name="firstQueryValueText" /> <input
                type="hidden" id="secondQueryValueText" name="secondQueryValueText" /> <input type="hidden"
                id="EventListtype" name="EventListtype" value="8" />
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom over_hidden" layout="border:false" id="id">
            <table id="myEvent" style="display: none"></table>
            <form id="deleteCalEvent" action="calEvent.do?method=deleteCalEvent" method="post">
                <input type="hidden" id="formId" name="formId" /> <input type="hidden" id="checkVal" name="checkVal"
                    value="1" />
            </form>
        </div>
    </div>
</body>
</html>