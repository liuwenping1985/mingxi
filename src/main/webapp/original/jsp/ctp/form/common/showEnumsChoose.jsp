<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>表单单元格左选右组件</title>
  <style>
    .titleLabel{
      height: 25px;
      vertical-align: middle;
      line-height: 25px;
    }
  </style>
  <script type="text/javascript" src="${path}/common/form/common/showEnumsChoose.js${ctp:resSuffix()}"></script>
</head>
<body class="over_hidden font_size12">
  <div class="clearfix margin_5">
    <div class="left" style="width:260px">
      <div id="fieldHead" class="clearfix">
        <div id="fieldLabel" class="left titleLabel">${ctp:i18n('form.unflow.optional.enumeration')}</div>
        <div id="searchArea" class="left">
          <ul class="common_search">
            <li id="inputBorder" class="common_search_input">
              <input id="searchValue" class="search_input" type="text">
            </li>
            <li>
              <a id="serachbtn" class="common_button search_buttonHand" href="javascript:void(0)">
                <em></em>
              </a>
            </li>
          </ul>
        </div>
      </div>
      <div id="fieldBody" class="clearfix">
        <select name="fieldList" id="fieldList" style="width: 260px;height: 410px" multiple="multiple" class="margin_t_5" ></select>
      </div>
    </div>
    <div id="middle" class="left" style="width: 35px;padding-top: 200px">
      <span id="add" class="ico16 select_selected"></span>
      <br>
      <br>
      <span id="del" class="ico16 select_unselect"></span>
    </div>
    <div class="left" style="width: 260px">
      <div id="valueHead" class="titleLabel">${ctp:i18n('form.unflow.selected.enumeration')}</div>
      <div id="valueBody">
        <select name="selectValue" id="selectValue" size="24" style="width: 260px;height: 410px" multiple="multiple" class="margin_t_5"></select>
      </div>
    </div>
    <div id="right" class="left" style="width: 35px;padding-top: 200px">
      <span id="up"  class="ico16 sort_up"></span>
      <br><br>
      <span id="down"  class="ico16 sort_down"></span>
    </div>
  </div>
  <div id="readme" class="margin_5" style="display: none">
    <div id="label" style="color: green">${ctp:i18n('form.forminputchoose.reaseme')}</div>
    <div id="content" style="color: green"></div>
  </div>
</body>
<script type="text/javascript">
  var dialogArg = window.dialogArguments;//窗口所有传入参数
  var showFieldArray =  new Properties(); //用于展示的字段对象map，默认就用后台返回的，可以用前台传人的，前台传人的必须是后台返回的子集
  var searchFieldArray = new Properties();

  var valueArray = new Properties(); //选择值map
  $(document).ready(function(){
      var body = $("body");
      body.hide(); //界面先隐藏，元素组装完后显示

      bindEvent();

      init();
      body.show();
  });

  function initBaseSourceFieldList(){
    var field;
    <c:forEach items="${enumList}" var="field">
    	field = new Vo("${field.showvalue}","${field.id}");
    	showFieldArray.put(field.value,field);
    </c:forEach>
  }
</script>
</html>
