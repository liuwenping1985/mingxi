<%--
  Created by IntelliJ IDEA.
  User: daiy
  Date: 2015-1-9
  Time: 20:37
  To change this template use File | Settings | File Templates.
--%>
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
</head>
<body class="over_hidden font_size12">
  <div class="clearfix margin_5">
    <div class="left" style="width:260px">
      <div id="fieldHead" class="clearfix">
        <div id="fieldLabel" class="left titleLabel"></div>
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
        <select name="fieldList" id="fieldList" style="width: 260px;" multiple="multiple" class="margin_t_5" ></select>
      </div>
      <div id="sysDiv">
        <div id="sysLabel" class="titleLabel"></div>
        <div>
          <select name="sysList" id="sysList" style="width: 260px;height: 100px" size="6" multiple="multiple" class="margin_t_5"></select>
        </div>
      </div>
    </div>
    <div id="middle" class="left" style="width: 35px;padding-top: 200px">
      <span id="add" class="ico16 select_selected"></span>
      <br>
      <br>
      <span id="del" class="ico16 select_unselect"></span>
    </div>
    <div class="left" style="width: 260px">
      <div id="valueHead" class="titleLabel"></div>
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
  var paramWin = dialogArg.paramWin; //父窗口

  var baseFieldArray = new Properties(); //根据后台返回的列表组装的字段对象map
  var baseSysArray = new Properties(); //根据后台返回的列表组装的系统域对象map

  var showFieldArray =  new Properties(); //用于展示的字段对象map，默认就用后台返回的，可以用前台传人的，前台传人的必须是后台返回的子集
  var showSysArray = new Properties(); //用于展示的系统域对象map，默认就用后台返回的，可以用前台传人的，前台传人的必须是后台返回的子集

  var searchFieldArray = new Properties();
  var searchSysArray = new Properties();

  var valueArray = new Properties(); //选择值map
  $(document).ready(function(){
      var body = $("body");
      body.hide(); //界面先隐藏，元素组装完后显示

    initHtml();

    bindEvent();

    init();
      body.show();
  });

  function init(){
    //初始化后台返回数据
    initBaseSourceFieldList();
    initBaseSourceSysList();

    //初始化前台设置数据
    initShowFieldList(baseFieldArray);
    initShowSysList(baseSysArray);

    //筛选不能选择的数据
    filterSource();

    //初始化选择数据
    initValueFieldList();

    search();

    initOption(valueArray,$("#selectValue"),true);
  }

  function bindEvent(){
      var  selectValue = $("#selectValue");
      selectValue.click(function(){
      execute($(this),dialogArg.valueEvent.clk)
    });
      selectValue.dblclick(function(){
      execute($(this),dialogArg.valueEvent.dbclk);
    });

      var sysList = $("#sysList");
      sysList.click(function(){
      clearSelected($("#fieldList"));
      sourceClk($(this));
    });
      sysList.dblclick(function(){
      clearSelected($("#fieldList"));
      sourceDbClk($(this));
    });

      var fieldList = $("#fieldList");
      fieldList.click(function(){
      clearSelected($("#sysList"));
      sourceClk($(this));
    });
      fieldList.dblclick(function(){
      clearSelected($("#sysList"));
      sourceDbClk($(this));
    });

    $("#serachbtn").click(function(){
      search();
    });

    $("#add").click(function(){
      sourceDbClk($("#fieldList"));
      sourceDbClk($("#sysList"));
    });

    $("#del").click(function(){
      var option = getSelectOption($("#selectValue"));
      if (option){
        remove(option,$("#selectValue"));
      }
    });

    $("#up").click(function(){
      editSort(1);
    });

    $("#down").click(function(){
      editSort(-1);
    });

      $("#searchValue").keyup(function(event) {
          if (event.keyCode == 13) {
              search();
          }
      });
  }

  function search(){
    var searchValue = $("#searchValue").val();
    searchFieldArray.clear();
    searchSysArray.clear();
    searchVo(showFieldArray,searchValue,searchFieldArray);
    searchVo(showSysArray,searchValue,searchSysArray);
    //拼接html
    initOption(searchFieldArray,$("#fieldList"),true);
    initOption(searchSysArray,$("#sysList"),true);
  }

  function searchVo(source,value,target){
    var array = source.values();
    for(var i=0; i < array.size(); i++){
      var vo = array.get(i);
      if (vo.name.indexOf(value) > -1){
        target.put(vo.value,vo);
      }
    }
  }

  /**
   * 选择到右侧区域
   **/
  function select(option,select){
    if (option.length) {
      for (var i = 0; i < option.length; i++) {
        var op = $(option[i]);
        add2Right(op.val(),op.text());
      }
    }
  }

  function remove(option,select){
    var canNotDeleteOption;
      option.each(function(){
        var vo = valueArray.get($(this).val());
        if (vo && !vo.canDelete) {
          canNotDeleteOption = vo.name;
          return false;
        }
      });
    if (canNotDeleteOption) {
      $.alert($.i18n(dialogArg.delMsg,canNotDeleteOption));
      return false;
    }
    option.each(function(){
      valueArray.remove($(this).val());
    });
    option.remove();
  }

  function editSort(num){
    var selected = getSelectOption($("#selectValue"));
    if (selected){
      selected = $(selected[0]);
      if (num > 0){
        var pre = selected.prev();
        if (pre[0]){
          newSort(pre.val(),selected.val(),selected.val());
        }
      } else {
        var next = selected.next();
        if (next[0]){
          newSort(selected.val(),next.val(),selected.val());
        }
      }
    }
  }

  function newSort(pre,next,selected){
    valueArray.swap(pre,next);
      refresh(valueArray, $("#selectValue"), selected);
  }

  function refresh(array, select, selected){
      initOption(array, select, true);
      if (selected) {
          $("option[value='"+selected +"']",select).prop("selected",true);
      }
  }

  function clearSelected(select){
    var selected = getSelectOption(select);
    if (selected){
      selected.attr("selected",false);
    }
  }

  function add2Right(value,display){
    var vo = valueArray.get(value);
    if (!vo){
      vo = showFieldArray.get(value);
        if (!vo) {
            vo = baseSysArray.get(value);
        }
      vo = vo.copy();
      vo.name = display;
      valueArray.put(value,vo);
      add2Select($("#selectValue"),vo,true);
    }
  }

  function initHtml(){
    $("#fieldLabel").text(dialogArg.fieldTitle + "：");
    $("#valueHead").text(dialogArg.valueTitle + "：");

    //是否显示系统数据域区域
    if (dialogArg.showSysArea) {
      $("#sysLabel").text(dialogArg.sysAreaLabel + "：");
      $("#sysDiv").show();
      $("#fieldList").css("height",280);
    } else {
      $("#sysDiv").hide();
      $("#fieldList").css("height",410);
    }

    //是否显示排序设置图片
    if (dialogArg.canSort) {
      $("#right").show();
    } else {
      $("#right").hide();
    }

    //显隐查询区域
    if (dialogArg.search) {
      $("#searchArea").show();
    } else {
      $("#searchArea").hide();
    }

    if (dialogArg.desc) {
      $("#readme").show();
      $("#content").text(dialogArg.desc);
    }
  }

  function initShowFieldList(defalut){
    if (dialogArg.relationSource.value) {
      makeList(showFieldArray,dialogArg.relationSource.value,dialogArg.relationSource.display)
    } else {
      showFieldArray = defalut;
    }
  }

  function initShowSysList(defalut){
    if (dialogArg.relationSource.value) {
      makeList(showSysArray,dialogArg.relationSource.value,dialogArg.relationSource.display)
    } else {
      showSysArray = defalut;
    }
  }

  function initValueFieldList(){
    makeList(valueArray,dialogArg.relationValue.value,dialogArg.relationValue.display)
  }

  function initOption(vos,select,clear){
    var array = vos.values();
    if (clear){
      select.html("");
    }
    var flag = true;
    if(select.attr("id") == "fieldList"){
        flag = false;
    }
    for(var i=0; i < array.size(); i++){
      var vo = array.get(i);
      add2Select(select,vo,flag);
    }
  }

  function add2Select(select,vo,right){
    var display = '';
    if(right){
        display = vo.name;
        if(display.indexOf("[")>-1 && display.indexOf("]") >-1){
            display = display.substring(display.lastIndexOf(']')+1);
        }
    }else{
        display='[';
        if(vo.isMasterField){
            display += $.i18n('form.base.mastertable.label');
        }else{
            display += $.i18n('formoper.dupform.label')+vo.subTableIndex;
        }
        display +="]"+vo.name;
    }
    var optionHtml = "<option value='"+vo.value+"'>"+display+"</option>"
    select.append($(optionHtml));
  }
  /**
   * 选择源单击事件执行
   * @param obj
   **/
  function sourceClk(obj){
    execute(obj,dialogArg.sourceEvent.clk);
  }

  function sourceDbClk(obj){
    execute(obj,dialogArg.sourceEvent.dbclk);
  }

  function execute(obj,functionNams) {
    if (functionNams){
      var selected = getSelectOption(obj);
      if(selected) {
        executeFunc(functionNams,selected,obj);
      }
    }
  }

  /**
  * 获取某个下拉框选中的元素，无选择则返回null
* @param select 给定的下拉框jquery对象
* @returns {*}
   */
  function getSelectOption(select){
    var selected = $("option:selected",select);
    return selected.length ? selected : null;
  }

  /**
  * 执行给定函数列表
* @param funNames 函数组，用逗号分隔
* @param obj 参数对象
   * @param select 下拉对象
   */
  function executeFunc(funNames,obj,sel) {
    var clkArray = funNames.split(",");
    for (var i=0; i < clkArray.length;i++) {
      var name = clkArray[i];
      eval(name+"(obj,sel)");
    }
  }

  function checkHasSameDisplay(array, display, noCheck) {
      var length = array.size();
      if (length) {
          var values = array.values();
          for (var i=0; i < length; i++) {
              var vo = values.get(i);
              if (vo.value != noCheck) {
                  if (getDisplay(vo.name) == display) {
                      return true;
                  }
              }
          }
      }
      return false;
  }

  function getDisplay(display){
      var dis = display;
      if(display.indexOf("[") > -1 && display.indexOf("]") > -1) {
          dis = display.substring(display.lastIndexOf("]")+1);
      }
      return dis;
  }

  function rename(selected, select){
      var name = $(selected).text();
      var obj = {value:name};
      var dialog = $.dialog({
          id:'rename',
          url:_ctxPath + "/form/component.do?method=rename",
          title:"${ctp:i18n('form.forminputchoose.rename')}",
          width:350,
          height:200,
          targetWindow:getCtpTop(),
          transParams:obj,
          buttons:[{
              text : "${ctp:i18n('form.forminputchoose.enter')}",
              id:"sure",
              isEmphasize: true,
              handler: function(){
                  var result = dialog.getReturnValue();
                  if (result.success){
                      if (!result.newName) {
                          $.alert("${ctp:i18n('form.forminputchoose.titlecantnull')}");
                          return;
                      }
                      var field = $(selected).val();
                      if (checkHasSameDisplay(valueArray, result.newName, field)) {
                          $.alert("${ctp:i18n('form.forminputchoose.notallowsamename')}");
                          return;
                      }
                      var v = valueArray.get(field);
                      if (v) {
                          if (name != result.newName) {
                              if(name.indexOf("(")>-1 && name.indexOf(")") >-1){
                                  name = name.substring(0,name.indexOf("("));
                              }
                              v.name=name +"(" + result.newName + ")";
                          }
                          refresh(valueArray, select, field);
                      }
                      dialog.close();
                  }
              }
          },{
              text : "${ctp:i18n('form.query.cancel.label')}",
              id:"exit",
              handler : function() {
                  dialog.close();
              }
          }]
      });
  }

  function makeShowFieldList(){
    if (dialogArg.relation.source){

    } else {
      showFieldArray = baseFieldArray;
    }
  }

  function makeShowSysList(){
    showSysArray = baseSysArray;
  }

  /**
   * 根据父窗口传人的存放值和显示值的input id组装需要显示的map
   *
   **/
  function makeList(map,key,show){
    if(paramWin && key) {
      var keyValue = $("#"+key,paramWin.document).val();
      if (!keyValue){
        return;
      }
      var showValue = "";
      var showValues;
      var selfDisplay = false;
      if (show){
        showValue = $("#"+show,paramWin.document).val();
        showValues = showValue.split(",");
        selfDisplay = true;
      }
      var values = keyValue.split(",");
      for(var i=0;i<values.length; i++) {
        var vo = showFieldArray.get(values[i]);
        if (!vo){
          vo = showSysArray.get(values[i]);
        }
        if (selfDisplay && vo) {
          vo = vo.copy();
          vo.name = showValues[i];
        }
        if (vo){
          map.put(vo.value,vo);
        }
      }
    }
  }

  function OK(){
    var result = {};
    result.value = '';
    result.display = '';
    var array = valueArray.values();
      var length = array.size();
      if(dialogArg.min && length < dialogArg.min) {
          $.alert($.i18n("form.forminputchoose.need.min", dialogArg.min));
          return result;
      }
      if(dialogArg.max && length > dialogArg.max) {
          $.alert($.i18n("form.forminputchoose.need.max", dialogArg.max));
          return result;
      }
      var containMaster = false;
    for(var i=0; i < length; i++) {
      var vo = array.get(i);
      result.value += vo.value + ',';
      var _display = vo.name;
      if(_display.indexOf("[") > -1 && _display.indexOf("]") > -1){
          _display = _display.substring(_display.lastIndexOf("]")+1);
      }
        if(vo.isMasterField) {
            containMaster = true;
        }
      result.display +=  _display+ ',';
    }
      var checkNull = true;//当未选择任何一项时，看是否可以为空。
      if(length == 0 && dialogArg.min <= 0){
          checkNull = false;
      }
      if(dialogArg.needMaster && !containMaster && checkNull) {
          $.alert("${ctp:i18n('form.forminputchoose.need.master.field')}");
          result.ok = false;
          return result;
      }
    if (result.value != '') {
        result.value = result.value.substring(0, result.value.length - 1);
        result.display = result.display.substring(0, result.display.length - 1);
    }
    if (dialogArg.result.value){
      $("#"+dialogArg.result.value,paramWin.document).val(result.value);
      $("#"+dialogArg.result.display,paramWin.document).val(result.display);
    }
    result.ok = true;
    return result;
  }

  function filterSource(){
    filterByArray(showFieldArray);
    filterByArray(showSysArray);
  }

  /**
  * 根据调用时的参数过滤备选字段
* @param obj
   */
  function filterByArray(obj){
    var filterArg = dialogArg.filter;
    var array = obj.values();
    for(var i=0; i < array.size(); i++){
      var vo = array.get(i);
      //根据表单字段所属表过滤
      if (filterArg.table) {
        //主表数据暂时不支持做表过滤
        if (vo.isMasterField){
          continue;
        }
        filterSigleEle(obj,vo,filterArg.table,vo.ownerTable);
      }
      //根据表单字段录入类型过滤
      if (filterArg.inputType){
        filterSigleEle(obj,vo,filterArg.inputType,vo.inputType);
      }
      //根据字段类型过滤
      if (filterArg.fieldType){
        filterSigleEle(obj,vo,filterArg.fieldType,vo.fieldType);
      }
      //根据显示格式过滤
      if (filterArg.formatType){
        filterSigleEle(obj,vo,filterArg.formatType,vo.formatType);
      }
    }
  }

  function filterSigleEle(map,vo,filterValue,voValue){
    if (filterEle(filterValue, voValue)) {
      if (dialogArg.reverseFilter){
        map.remove(vo.value);
      }
    } else {
      if (!dialogArg.reverseFilter) {
        map.remove(vo.value);
      }
    }
  }

  function filterEle(filterValue,voValue) {
      var fv = filterValue.split(",");
      for (var i=0; i< fv.length; i++) {
          if (fv[i].toLocaleLowerCase() == voValue.toLocaleLowerCase()) {
              return true;
          }
      }
      return false;
  }


  function Vo(name,value,fieldType,inputType,formatType,ownerTable,isMasterField,canDelete,subTableIndex){
    this.name = name;
    this.value = value;
    this.fieldType = fieldType;
    this.inputType = inputType;
    this.formatType = formatType;
    this.ownerTable = ownerTable;
    this.isMasterField = isMasterField;
    this.canDelete = canDelete;
    this.subTableIndex = subTableIndex;
  }

  Vo.prototype.copy = function(){
    return new Vo(this.name,this.value,this.fieldType,this.inputType,this.formatType,this.ownerTable,this.isMasterField,this.canDelete,this.subTableIndex);
  };

  function initBaseSourceFieldList(){
    var field;
    <c:forEach items="${fieldList}" var="field">
      if(dialogArg.batchupdate){
          if(dialogArg.collectTables.indexOf("${field.ownerTable}") == -1){
              field = new Vo("${field.name}","${field.value}","${field.fieldType}","${field.inputType}","${field.formatType}","${field.ownerTable}",${field.masterField},${field.canDelete},"${field.subTableIndex}");
              baseFieldArray.put(field.value,field);
          }
      }else{
          field = new Vo("${field.name}","${field.value}","${field.fieldType}","${field.inputType}","${field.formatType}","${field.ownerTable}",${field.masterField},${field.canDelete},"${field.subTableIndex}");
          baseFieldArray.put(field.value,field);
      }
    </c:forEach>
  }

  function initBaseSourceSysList(){
    var field;
    <c:forEach items="${sysList}" var="field">
    field = new Vo("${field.name}","${field.value}","${field.fieldType}","${field.inputType}","${field.formatType}","${field.ownerTable}",${field.masterField},${field.canDelete},"${field.subTableIndex}");
    baseSysArray.put(field.value,field);
    </c:forEach>
  }
</script>
</html>
