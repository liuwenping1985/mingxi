<%--
 $Author:  翟锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>F1-流程节点操作</title>
    <style type="text/css">
        .stadic_body_top_bottom { bottom: 0px; top: 0px; }
    </style>
    <script type="text/javascript">
    
        $(function(){
            //候选操作绑定双击事件
            $('#reserve').dblclick(function(){
                move($('#reserve'),$('#selected'));
            });
            //选中操作 绑定双击事件
            $('#selected').dblclick(function(){
                move($('#selected'),$('#reserve'));
            });
            //向左移动 绑定点击事件
            $('#toLeft').click(function(){
                move($('#selected'),$('#reserve'));
            });
            //向右移动 绑定点击事件
            $('#toRight').click(function(){
                move($('#reserve'),$('#selected'));
            });
            //向上移动绑定点击事件
            $('#toUp').click(function(){
                upDown($('#selected'),'up');
            });
            //向下移动绑定点击事件
            $('#toDown').click(function(){
                upDown($('#selected'),'down');
            });
        });
        
        // 指定回退操作
        function submitStyle(tObj, Obj){
          var dialog = $.dialog({
            url: _ctxPath + "/permission/permission.do?method=settingSpecifiesReturn&submitStyle=0",
            width:280,
            height:150,
            title:"${ctp:i18n('system.prompt.js')}", //系统提示
            targetWindow:getCtpTop(),
            buttons : [ {
                isEmphasize:true,
                text : "${ctp:i18n('permission.confirm')}",//确定
                handler : function() {
                  var returnValue = dialog.getReturnValue();
                  if(returnValue){
                    $("#submitStyle").val(returnValue);
                    //节点 移动
                    tObj.append("<option value='"+Obj.val()+"'>"+Obj.text()+"</option>");
                    //将当前选中节点从左侧删除
                    Obj.remove();
                    dialog.close();
                  }
                }
              }, {
                text : "${ctp:i18n('permission.cancel')}",//取消
                handler : function() {
                  dialog.close();
                }
              } ]
          });
        }
        
        //左右两侧节点栏内数据相互移动
        function move(fObj,tObj){
          fObj.find('option').each(function(){
              if(this.selected){
                  if(tObj.attr("id") === "selected" && $(this).val() === "SpecifiesReturn"){
                    submitStyle(tObj, $(this));
                  }else{
                	  if(tObj.attr("id") === "selected" && $(this).val() === "HtmlSign"){
                		    var advanceOfficeOcx="${v3x:hasPlugin('advanceOffice')}";
                			if(advanceOfficeOcx=="false"){
                				alert("${ctp:i18n('edoc.advanceOffice.htmlSign.label')}");
                				return ;
                			}
                      }
                    //节点 移动
                    tObj.append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
                    //将当前选中节点从左侧删除
                    $(this).remove();
                  }
              }
          });
        }
        
        //上下节点移动,selObj 移动的对象，flag 标志位，up表示向上移动，down表示向下移动
        function upDown(selObj,flag){
            //向上移动
            if('up' === flag){
                var name = "";
                var value = "";
                selObj.find('option').each(function(i){
                    if(this.selected){
                        if(i!==0){
                            //当前选中节点不是第一个的时候，取前一个节点的数据
                            name = $(this).prev().text();
                            value = $(this).prev().val();
                            //去当前选中节点的值，并且与前一个节点的值进行互换
                            $(this).prev().text($(this).text());
                            $(this).prev().val($(this).val());
                            $(this).text(name);
                            $(this).val(value);
                            //将互转后的节点置为选中状态
                            $(this).prev().attr('selected',true);
                            $(this).attr('selected',false);
                            //终止循环
                            return false;
                        }
                    } 
                });
            }else if('down' === flag){
                var name = "";
                var value = "";
                selObj.find('option').each(function(i){
                    if(this.selected){
                        //取下一个节点的值，判断是否是最后一个节点，如果空值，则为最后一个节点
                        name = $(this).next().text();
                        if(name!==""){
                            //当前选中节点不是最后一个的时候，取下一个节点的数据
                            value = $(this).next().val();
                            //取当前选中节点的值，并且与下一个节点的值进行互换
                            $(this).next().text($(this).text());
                            $(this).next().val($(this).val());
                            $(this).text(name);
                            $(this).val(value);
                            //将互转后的节点置为选中状态
                            $(this).next().attr('selected',true);
                            $(this).attr('selected',false);
                            //终止循环
                            return false;
                        }
                    } 
                });
            }
        }
        //定义回调函数，返回节点栏中选中的数据,以json字符串形式返回
        function OK(){
            var returnValue = "{\"submitStyle\":\"[{\\\"value\\\":\\\"" + $("#submitStyle").val() + "\\\"}]\", \"options\":\"[";
            var returnVal = "";
            $('#selected').find('option').each(function(){
                if($(this).next().text()!=""){
                    returnVal = returnVal + "{\\\"text\\\":\\\"" + $(this).text() + "\\\",\\\"value\\\":\\\""+$(this).val()+"\\\"},";
                }else{
                    returnVal = returnVal +"{\\\"text\\\":\\\"" + $(this).text() + "\\\",\\\"value\\\":\\\""+$(this).val()+"\\\"}";
                }
            });
            returnValue = returnValue + returnVal + "]\"}";
            return returnValue ;
        }
    </script>
</head>
<body class="h100b over_hidden">
    <!-- 指定回退再处理的流转方式 -->
    <input type="hidden" id="submitStyle" value="${submitStyle }">
    <div class="stadic_layout_body stadic_body_top_bottom border_t page_color">
            <table align="center" class="margin_t_10 font_size12">
                <tr>
                    <td>
                        ${ctp:i18n('permission.operation.wait.choose')}<%--候选操作 --%><br />
                        <select id="reserve" name="reserve" multiple="multiple" class="margin_t_10" 
                            style="width: 150px; height: 220px;">
                            <c:forEach items="${metadata}" var="permissionOperation">
                                <option value="${permissionOperation.key}">${ctp:i18n(permissionOperation.label)}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 select_selected" id="toRight"></em><br />
                        <em class="ico16 select_unselect" id="toLeft"></em>
                    </td>
                    <td>
                        ${ctp:i18n('permission.operation.check.choose')}<%--选中操作 --%><br />
                        <select id="selected" name="selected" multiple="multiple" class="margin_t_10" 
                            style="width: 150px; height: 220px;">
                            <c:forEach items="${existMetaData}" var="permissionOperation">
                                <c:if test="${permissionOperation.key eq 'SpecifiesReturn'}">
                                    <c:if test="${submitStyle eq '0'}">
                                        <!-- 流程重走 -->
                                        <c:set var="titleString" value="${ctp:i18n('collaboration.appointStepBack.ProcessTheHeavy')}"/>
                                    </c:if>
                                    <c:if test="${submitStyle eq '1'}">
                                        <!-- 提交回退者 -->
                                        <c:set var="titleString" value="${ctp:i18n('collaboration.appointStepBack.CommitRollback')}"/>
                                    </c:if>
                                    <c:if test="${submitStyle eq '2'}">
                                        <c:set var="titleString" value="${ctp:i18n('collaboration.appointStepBack.ProcessTheHeavy')},${ctp:i18n('collaboration.appointStepBack.CommitRollback')}"/>
                                    </c:if>
                                    <option title="${titleString }" value="${permissionOperation.key}">${ctp:i18n(permissionOperation.label)}</option>
                                </c:if>
                                <c:if test="${permissionOperation.key ne 'SpecifiesReturn'}">
                                    <option value="${permissionOperation.key}">${ctp:i18n(permissionOperation.label)}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <em class="ico16 sort_up" id="toUp"></em><br />
                        <em class="ico16 sort_down" id="toDown"></em>
                    </td>
                </tr>
            </table>
        </div>
</body>
</html>
