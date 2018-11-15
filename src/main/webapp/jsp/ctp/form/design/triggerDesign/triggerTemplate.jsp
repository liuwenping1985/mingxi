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
        <title></title>
        <script type="text/javascript">
            $(document).ready(function(){
              $("#struction").tooltip({
                event:true,
                openAuto:false,
                width:400,
                htmlID:'operInstructionDiv',
                targetId:'struction'
              });
              new MxtLayout({
                'id' : 'layout',
                'northArea' : {
                  'id' : 'north',
                  'height' : 40,
                  'sprit' : false,
                  'border' : false
                },
                'centerArea' : {
                  'id' : 'center',
                  'border' : false
                },
                'successFn' : function() {
                }
              });
              $("#operInstructionDiv").show();
              var catg = new Array();
              <c:forEach items="${category}" var="item">
              catg.push({text:"${fn:escapeXml(item.name)}",value:"${item.id}"});
              </c:forEach>
              if(catg.length == 0){
                catg.push({text:"",value:""});
              }
              var searchobj = $.searchCondition({
                top:5,
              right:10,
                searchHandler: function(){
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    var value = "";
                    if(choose === 'subject'){
                        value =  $('#names').val();
                        if(value.trim()===""){
                        }
                    }else if(choose === 'categoryId'){
                        value = $('#categorys').val();
                    }else{
                      choose = 'subject';
                    }
                    $("#selectType").val(choose);
                    $("#value").val(value);
                    $("#option").val($("#templateCategory").val());
                    $("#queryForm").jsonSubmit({
                        targetWindow:document.getElementById('allColumnsIFrame').contentWindow
                    });
                    //window.open('${path}/form/triggerDesign.do?method=triggerTemplateTree&type=showAll&selectType='+choose+'&value='+value+'&option='+$("#templateCategory").val(),'allColumnsIFrame');
                },
                conditions: [{
                    id: 'names',
                    name: 'names',
                    type: 'input',
                    text: '${ctp:i18n('formsection.config.template.name')}',//标题
                    value: 'subject'
                }, {
                    id: 'categorys',
                    name: 'categorys',
                    type: 'select',
                    text: '${ctp:i18n('formsection.config.template.category')}',
                    value: 'categoryId',
                    items: catg
                }]
            });
              $("#selectColumns").dblclick(function(){
                  removeTemplate();
              });
                //默认执行一次查询
                $("#queryForm").jsonSubmit({
                    targetWindow:document.getElementById('allColumnsIFrame').contentWindow
                });
            });
            function OK(param){
                if ($("#selectColumns option").length != 1){
                    return "must";
                }
                var o = new Object();
                o.value = $("#selectColumns option").val();
                o.name = $("#selectColumns option").text();
                return o;
          }
            function selectTemplate(node){
                $("#selectColumns option").remove();
                $("#selectColumns").append("<option value = \"" + node.data.value +"\">" + node.data.name + "</option>");
                refresh();
            }
            
            function removeTemplate(){
                $("#selectColumns option:selected").remove();
                refresh();
            }
            
           function refresh(){
             var html = $("#selectedColumns").html();
             $("#selectColumns").remove();
             $("#selectedColumns").html(html);
             $("#selectColumns",$("#selectedColumns")).unbind("click").bind("click",function(){
               
             });
             $("#selectColumns",$("#selectedColumns")).unbind("dblclick").bind("dblclick",function(){
               removeTemplate();
             });
           }
        </script>
    </head>
    <body id='layout'>
        <!-- 由于url后面添加参数+号会被转义，所以改为ajax提交 -->
        <form id="queryForm" name="queryForm" method="post" action="${path }/form/triggerDesign.do?method=triggerTemplateTree&type=showAll" class="font_size12">
            <input type="hidden" id="selectType"/>
            <input type="hidden" id="value"/>
            <input type="hidden" id="option">
        </form>
	    <div class="layout_north" id="north">
	       <span class="align_right padding_l_10" id="struction"><a class="hand font_size12">[${ctp:i18n('formsection.config.operinstruction.label') }]</a></span>
	       <div id="searchDiv"></div>
	    </div>
	    <div class="layout_center padding_l_5" id="center">
	       <table>
            <tr>
                <td colspan="2" class="font_size12">${ctp:i18n('formsection.config.column.category.canbeselected') }</td>
                <td class="font_size12">${ctp:i18n('formsection.config.column.category.selected') }</td>
            </tr>
            <tr height="170">
                <%-- 栏目可选项 --%>
                <td width="270" style="text-align: center;">
                    <div id="allColumns" class="border_all padding5" style="height: 410px">
                        <iframe name="allColumnsIFrame" id="allColumnsIFrame" height="100%" width="100%" frameBorder="no" ></iframe>
                    </div>
                </td>

                <td valign="middle" width="40">
                    <c:if test="${param.type ne 'view' }">
                        <div class="align_center" onClick="allColumnsIFrame.selectColumn(true)"><span class="ico16 select_selected"></span></div>
                        <div class="align_center" style="margin-top: 20px;" onClick="removeTemplate()"><span class="ico16 select_unselect"></span></div>
                    </c:if>
                </td>
                <%-- 栏目已选项 --%>
                <td width="260">
                    <%-- 嵌套一层table，避免已选项中节点文字过多时，可选项部分空间被全部占用无法正常显示并进行操作 --%>
                    <table width="100%" height="100%" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                        <tr>
                            <td>
                                <div id="selectedColumns" class="padding5" style="height: 410px">
                                    <select id="selectColumns" multiple="multiple" class="border_all" style="width: 100%;height: 100%;">
                                        <c:forEach items="${templateList }" var="item">
                                        <option value="${item.value }">${item.name }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
	    </div>
	    <div id="operInstructionDiv"  style="color:  green;font-size: 12px;display: none;">
	       <ul>
	           <li><span class="font_size12">●</span>${ctp:i18n('form.trigger.triggerSet.template.info.label1') }</li>
	           <li><span class="font_size12">●</span>${ctp:i18n('form.trigger.triggerSet.template.info.label2') }</li>
	           <li><span class="font_size12">●</span>${ctp:i18n('form.trigger.triggerSet.template.info.label3') }</li>
	       </ul>
	    </div>
    </body>
</html>