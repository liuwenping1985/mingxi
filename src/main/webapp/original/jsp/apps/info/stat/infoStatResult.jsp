<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html class="h100b w100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=infoStatManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/stat/infoStat.js"></script>
<title></title>
</head>
  <script type="text/javascript">
  try {
    getA8Top().endProc();
  }
  catch(e) {
  }
  </script>
<style>
.table_brder{
border-top:1px solid #cdcdcd;
border-left:1px solid #cdcdcd;
}
.table_brder td{
border-right:1px solid #cdcdcd;
border-bottom:1px solid #cdcdcd;
line-height:24px;
}
</style>
<script type="text/javascript">


function infoPush(){
   if(confirm('确认要推送到信息发布！')){
     var statTitle=$("#statTitle").html();
     var htmls=$("#statTable").html();
     var smanage = new infoStatManager();
     var tranObj = new Object();
     tranObj.content = htmls;
     tranObj.statTitle = statTitle;
     /*smanage.publishStat(tranObj,{
       success : function(){
         alert("统计结果发布成功!");
       },
       error : function(request, settings, e){
         $.alert("发布失败！");
       }
      });*/
     openMagazinePublishDialog();
   }else{
     return false;
   }

}

function render(text, row, rowIndex, colIndex, col) {
    
    if(rendClickMap[col.name]){//循环时加了值
        
        var newText = rendClickMap[col.name];
        newText = newText.replace(/\\$rowIndex/g, rowIndex);
        
        newText = newText.replace(/\\$value/g, row[col.name]);//替换值
        
        return newText;
    }
    
    return text
}

$(document).ready(function () {
  
    loadToolbar();
    
    $("#infoPush").bind("click",function() {
      openMagazinePublishDialog();
    });
    
    //fixResultTableCSS();
    
    //显示数据
    _initGrid();
});

function showScore(ids, index,varType) {
    if(varType == 'manual') {
      openInfoStatScoreManualRecord(data_rows[index]["ids_values"]);
    } else {
      openInfoStatScoreAutoMaticRecord(data_rows[index]["ids_values"]);
    }
 }


/**
 * 加载列表
 */
var rendClickMap = [];//绑定点击事件的列
function _initGrid(){
    
    //数据拼接, 作为全局变量
    window.data_rows = [];
  
	 <c:forEach  items="${results}" var="content" varStatus="status">
	 var datarow_${status.index} = {};
	 datarow_${status.index}["stat_col_0"] = '${ctp:escapeJavascript(organizations[status.index])}';
	 
	 <c:set value="${fn:length(content.value)-1 }" var="lastIndex" />
     <c:set value="${fn:length(content.value)-3}" var="colManualIndex"/>
     <c:set value="${fn:length(content.value)-4}" var="colAutoIndex"/>
     <c:forEach  items="${content.value}" var="num" varStatus="coltatus">
     
     <c:if test="${coltatus.index < lastIndex }">
         datarow_${status.index}["stat_col_${coltatus.index + 1}"] = '${num}';
         <c:choose>
           <c:when test="${coltatus.index == colAutoIndex}">
             if(!rendClickMap["stat_col_${coltatus.index + 1}"]){
                 //定义了$rowIndex特殊字符
                 var preHtml = '<a href="#" class="scoreA color_blue" onClick=\'javascript:showScore("ids$rowIndex","$rowIndex","auto");\'>$value</a>';
                 rendClickMap["stat_col_${coltatus.index + 1}"] = preHtml;
             }
           </c:when>
           <c:when test="${coltatus.index == colManualIndex}">
           if(!rendClickMap["stat_col_${coltatus.index + 1}"]){
               var preHtml = '<a href="#" class="scoreA color_blue" onClick=\'javascript:showScore("ids$rowIndex","$rowIndex","manual");\'>$value</a>';
               rendClickMap["stat_col_${coltatus.index + 1}"] = preHtml;
           }
           </c:when>
         </c:choose>
     </c:if>
     <c:if test="${coltatus.index == lastIndex }">
         datarow_${status.index}["ids_values"] = '${num}';
     </c:if>
     </c:forEach>
	  data_rows.push(datarow_${status.index});
    </c:forEach>
  
    var tableDatas = {
        "total" : ${fn:length(results)},
        "page" : 1,
        "pages" : 1,
        "rows":data_rows,
        "size" : ${fn:length(results)}
    };
    
    
    //拼接列模型
    var colModels = [];
    var colWidth = "10%";
    
    <c:set value="${fn:length(strContentName)-1 }" var="lastNameIndex" />
    <%-- 每列最窄10% --%>
      <c:if test="${fn:length(strContentName) < 11 }">
      colWidth = (100 / ${fn:length(strContentName) - 1}).toFixed(2) + "%";
      </c:if>
    <c:forEach items="${strContentName}" var="cName" varStatus="colName">
      <c:if test="${colName.index < lastNameIndex }">
      colModels.push({
              display : '${ctp:escapeJavascript(cName)}',
              id:'stat_col_${colName.index}',
              name : 'stat_col_${colName.index}',
              width : colWidth,
              sortable : true,
              align : 'center',
              hide : false
          });
      </c:if>
    </c:forEach>
    

    var _dataGrid = $("#resultBodyTable").ajaxgrid({
        click : function(){},
        dblclick : function(){},//还没用
        onToggleCol:function(){},
        render : render,
        datas : tableDatas,
        isHaveIframe : false,
        colModel : colModels,
        usepager : false,
        showTableToggleBtn : false,
        parentId : "resultDiv",
        vChange : false,
        vChangeParam : {
            overflow : "hidden",
            autoResize : true
        },
        slideToggleBtn : false,
        showToggleBtn : false,
        resizable : false,
        customize : false,
        customId : "info_stat_rsult_table"
    });
}

function dealInfoStatData(domains) {
  var statTitle=$("#statTitle").html();
  var htmls=$("#statTable").html();
  htmls = $(htmls).find("a").each(function(){
     $(this).after($(this).text()).remove();
   }).end()[0].outerHTML;
  $("#content").val(htmls);
  $("#statName").val(statTitle);
  if(!domains) {
    domains = [];
  }
  domains.push("infoStatData");
  return domains;
}

/**
*修正统计结果table展示
*/
function fixResultTableCSS(){
  if(v3x.isMSIE9){
    $("#outerDiv").height($("#content",parent.document).height());
     }
  $("#resultDiv").height($("#outerDiv").height()-$("#toolBarDiv").height());
  var _w1 = $("#resultHeadTable").width();
  var _w2 = $("#resultDiv").width();
  if(_w1-_w2>2){
    $("#resultBodyDiv").height($("#resultDiv").height()-$("#resultHeadDiv").height()-30);
  }else{
    $("#resultBodyDiv").height($("#resultDiv").height()-$("#resultHeadDiv").height());
  }
  $("#resultBodyDiv").width($("#resultHeadTable").width())
  $("#resultBodyTable").width($("#resultHeadTable").width());
  //下面的代码是让两个不同的table中的tHead和tBody中的TD宽度保持一致
  //获取第一个table中tHead中TH的宽度集合
  var ths = new Array();
  $("#theadTR").find("th").each(function(){
    ths.push($(this).width());          
  });
  //获取第二个table中一共有多少个TR元素
  var trs = new Array();
  $("#resultBodyTable ").find("tr").each(function(){
    trs.push($(this));
  });
  //统一宽度
  for(var i =0;i<trs.length;i++){
    var tds = new Array();
    //获取没一个TR元素中的TD集合
    trs[i].find("td").each(function(){
      tds.push($(this));
    });
    //统一宽度
    for(var j=0;j<ths.length;j++){
      tds[j].width(ths[j]);
    }
  }
  
}
</script>
<body class="h100b w100b over_hidden">

  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north common_toolbar_box" layout="height:30,sprit:false,border:false">
    
      <div id="magazinePublishRange" style="display: none;">
        <%@ include file="../common/magazine_publish_common.jsp" %>
        <div id="infoStatData" style="display:none">
          <input id="statName" type="hidden"  />
          <textarea id="content" rows="" cols="" style="display:none"></textarea>
        </div>
      </div>

      <div id="infoPushDiv" style="display: none;">
        <input class="w100b validate" type="hidden" value="${infoMagazineVO.publishRangeNames}" id="publishRange"  readonly="readonly" name="publishRange"/>
        <!-- 隐藏显示查看页面人员的Account|id -->
        <input type="hidden" id="viewPeopleId" name="viewPeopleId" value="${infoMagazineVO.viewPeopleId}">
        <!-- 隐藏显示组织\单位查看人员的Account|id -->
        <input type="hidden" id="publicViewPeopleId" name="publicViewPeopleId" value="${infoMagazineVO.publicViewPeopleId}">
        <input type="hidden" id="orgSelectedTree" name="orgSelectedTree" value="${infoMagazineVO.orgSelectedTree}">
        <input type="hidden" id="UnitSelectedTree" name="UnitSelectedTree" value="${infoMagazineVO.unitSelectedTree}">
        <!-- 隐藏显示查看人员的中文 -->
        <input type="hidden" id="viewPeople" name="viewPeople" value="${infoMagazineVO.viewPeople}">
        <!-- 隐藏显示组织\单位查看人员的中文-->
        <input type="hidden" id="publicViewPeople" name="publicViewPeople" value="${infoMagazineVO.publicViewPeople}">
        <!-- 隐藏显示所选的ID-->
        <input type="hidden" id="selectIds" name="selectIds" value="">
        <!-- 后台传递参数，组件显示范围不受权限控制 0代表后台，1代表台 -->
        <input type="hidden" id="openFromType" name="openFromType" value="1">
      </div>
    
      <div id="statTable" style="overflow-x:auto;display:none;">
        <table align="center"  border="0" cellspacing="0" cellpadding="0" class="only_table edit_table" style="width: 100%;">
          <thead>
            <tr>
              <td align="center" colspan="${colspans}">
                <div id="statTitle" class="bg_color"> ${title}  </div>
              </td>
            </tr>
            <tr>
              <c:set value="${fn:length(strContentName)-1 }" var="lastNameIndex" />
              <c:forEach items="${strContentName}" var="cName" varStatus="colName">
                <c:if test="${colName.index < lastNameIndex }">
                  <th nowrap style="text-align:center" title="${ctp:toHTML(cName)}">
                    <c:if test="${fn:length(cName)<=8}">
                      ${ctp:toHTML(cName)}
                    </c:if>
                    <c:if test="${fn:length(cName)>8}">
                      ${ctp:toHTML(fn:substring(cName,0,8))}<br>
                      ${ctp:toHTML(fn:substring(cName,8,15))}...
                    </c:if>
                  </th>
                </c:if>
              </c:forEach>
            </tr>
          </thead>
          <tbody>
            <c:set var="i"  value="0"/>
            <c:forEach  items="${results}" var="content" varStatus="status">
              <tr>
                <td align="center">${organizations[status.index]}</td>
                <c:forEach  items="${content.value}" var="num" varStatus="coltatus">
                  <c:set value="${fn:length(content.value)-1 }" var="lastIndex" />
                  <c:set value="${fn:length(content.value)-3}" var="colManualIndex"/>
                  <c:set value="${fn:length(content.value)-4}" var="colAutoIndex"/>
                  <c:if test="${coltatus.index < lastIndex }">
                    <td align="center">
                      <c:choose>
                         <c:when test="${coltatus.index == colAutoIndex}">
                            <a href="#" id="viewScore" class='scoreA color_blue' onClick="javascript:showScore('ids${status.index}','${status.index}','auto');" name="viewScore"> ${num}</a>
                         </c:when>
                         <c:when test="${coltatus.index == colManualIndex}">
                           <a href="#" id="viewScore" class='scoreA color_blue' onClick="javascript:showScore('ids${status.index}','${status.index}','manual');" name="viewScore"> ${num}</a>
                         </c:when>
                         <c:otherwise>
                           ${num}
                         </c:otherwise>
                      </c:choose>
                    </td>
                  </c:if>
                  <c:if test="${coltatus.index == lastIndex }">
                    <input name="ids${status.index}" id="ids${status.index}" value="${num}" type="hidden"/>
                  </c:if>
                </c:forEach>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    
      <div id="toolBarDiv"  class="clearfix bg_color_gray">
        <div style="float: left;line-height: 20px;padding: 5px;vertical-align: middle;" class="font_size12">统计结果：</div>
        <div style="float: left;" id="toolbars"></div>
        <div style="clear: both;"></div>
      </div>
      
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
     <div id="resultDiv" class="w100b h100b">
     <%-- 展示布局 --%>
      <div id='resultLayout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north common_toolbar_box" layout="height:30,sprit:false,border:false">
            <table id="resultHeadTable" align="center"  border="0" cellspacing="0" cellpadding="0" class="only_table edit_table w100b h100b" >
              <tr>
                <td align="center" colspan="${colspans}">
                  <div id="statTitle" class="bg_color"> ${title}</div>
                </td>
              </tr>
            </table>
        </div>
        <div class="layout_center page_color over_hidden" layout="border:false">
        
           <table id="resultBodyTable" class="flexme3" style="display: none;"></table>
           
        </div>
      </div>
     </div>
    </div>
  </div>
</body>
</html>