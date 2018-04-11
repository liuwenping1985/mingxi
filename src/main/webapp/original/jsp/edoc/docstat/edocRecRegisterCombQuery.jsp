<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="edoc.recbook.query" /></title><!-- 收文登记薄组合查询 -->
<script type="text/javascript">

    var isG6 = "${isG6}";
    var registerSwitch = "${registerSwitch}";

    $(function(){
        _initData();
    });

    /**
     *  数据回填
     */
    function _initData(){
        if(window.transParams && window.transParams.parentWin && window.transParams.parentWin.compQueryParam){
            var params = window.transParams.parentWin.compQueryParam;
           //有数据，进行回填
           for(var i = 0; i < params.length; i++){
               var conditon = params[i];
               var name = conditon["condition"];
               var type = conditon["type"];
               var value = conditon["value"];
               if("datemulti" == type){
                   $("#" + name + "Begin").val(value[0]);
                   $("#" + name + "End").val(value[1]);
               }else{
                   $("#" + name).val(value);
               }
           }
        }
    }
    
    /**
     * 回调函数
     */
    function OK() {
        var ret = {"status":true, "errMsg":"","conditions" : null};//返回的对象
        var retconditions = [];
        $("._condition").each(function(){
            var $this = $(this);
            var name = $this.attr("name");
            var type = $this.attr("conditionType");
            var condition = {"type":type,
                             "condition":name
                             };
            if("datemulti" == type){
                var valArray = [];
                var beginValue = $("#" + name + "Begin").val();
                var endValue = $("#" + name + "End").val()
                valArray.push(beginValue);
                valArray.push(endValue);
                
                if(beginValue && endValue){
                    if(new Date(beginValue.replace(/-/g,"/")) > new Date(endValue.replace(/-/g,"/"))){
                        //$.alert("${ctp:i18n('edoc.timevalidate')}");
                        ret["status"] = false;
                        ret["errMsg"] = "${ctp:i18n('edoc.timevalidate')}";
                        return false;//结束each循环
                    }
                }
                condition['value'] = valArray;
            }else{
                condition['value'] = $this.val();
            }
            retconditions.push(condition);
        });
        ret["conditions"] = retconditions;
        return ret;
    }
</script>

<style type="text/css">
    
    .div_row{
        height: 22px;
        line-height: 22px;
    }
    
    .div_row_nonal{
        margin-bottom: 14px;
    }
    
    .div_row_label{
       text-align: right;
       width: 130px;
       float: left;
       height:22px;
       line-height:12px;
       padding-right: 10px;
    }
    
    .div_row_item{
        float: left;
        width: 210px;
    }
    
    .div_row_2_item{
       float: left;
       width: 100px;
    }
    
    .div_row_time_separate{
       width: 10px;
       float: left;
       height: a;
       text-align: center;
       height:22px;
       line-height:22px;
    }
    .div_column_separate{
        width: 40px;
        float: left;
    }
</style>

</head>
<body class="h100b w100b" style="">
<div>
    <div class="font_size12" style="padding: 36px 20px 40px 20px;">

       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.subject')}:<%-- 公文标题 --%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="subject" id="subject"/>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
          		${ctp:i18n('edoc.edoctitle.fromUnit.label')}:<%-- 来文单位--%>
           </div>
           <div class="div_row_item">
           		<input type="text" class="w100b _condition" conditionType="input" name="sendUnit" id="sendUnit"/>
           </div>
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.receive.serial_no')}:<%-- 收文编号--%>
               </div>
               <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="serialNo" id="serialNo"/>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
           		${ctp:i18n('edoc.element.fromWordNo')}:<%-- 来文文号 --%>
           </div>
           <div class="div_row_item">
           		<input type="text" class="w100b _condition" conditionType="input" name="docMark" id="docMark"/>
           </div>
          
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
           		${ctp:i18n('edoc.element.undertakeUnit')}:<%-- 承办机构--%>
           </div>
           <div class="div_row_item">
           		<input type="text" class="w100b _condition" conditionType="input" name="undertakenoffice" id="undertakenoffice"/>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
           		${ctp:i18n('edoc.element.undertaker')}:<%-- 承办人--%>
           </div>
           <div class="div_row_item">
           		<input type="text" class="w100b _condition" conditionType="input" name="undertaker" id="undertaker"/>
           </div>
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
       
           <div class="div_row_label">
           ${ctp:i18n('exchange.edoc.receivedperson')}:<%-- 签收人--%>
           </div>
           <div class="div_row_item">
           <input type="text" class="w100b _condition" conditionType="input" name="recieveUserName" id="recieveUserName"/>
           </div>
           
           <div class="div_column_separate">&nbsp;</div>
           
           <div class="div_row_label">
           ${ctp:i18n('edoc.element.receipt_date')}:<%-- 签收日期 --%>
           </div>
           <div class="div_row_item">
           <div class="_condition w100b h100b" conditionType="datemulti" name="recieveDate">
               <div class="div_row_2_item">
               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="recieveDateBegin" id="recieveDateBegin"/>
               </div>
               <div class="div_row_time_separate">-</div>
               <div class="div_row_2_item">
               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="recieveDateEnd" id="recieveDateEnd"/>
               </div>
               <div style="clear: both;"></div>
           </div>
           </div>
           
           <div style="clear: both;"></div>
       </div>
       <%-- G6 开起公文登记 --%>
       <c:if test="${isG6 && registerSwitch}">
       <div class="div_row div_row_nonal">
       
           <div class="div_row_label">
           ${ctp:i18n('edoc.edoctitle.regPerson.label')}:<%-- 登记人 G6--%>
           </div>
           <div class="div_row_item">
           <input type="text" class="w100b _condition" conditionType="input" name="registerUserName" id="registerUserName"/>
           </div>
           
           <div class="div_column_separate">&nbsp;</div>
       
           <div class="div_row_label">
           ${ctp:i18n('edoc.edoctitle.regDate.label')}:<%-- 登记日期 G6 --%>
           </div>
           <div class="div_row_item">
	           <div class="_condition w100b h100b" conditionType="datemulti" name="registerDate">
		           <div class="div_row_2_item">
	               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="registerDateBegin" id="registerDateBegin"/>
	               </div>
	               <div class="div_row_time_separate">-</div>
	               <div class="div_row_2_item">
	               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="registerDateEnd" id="registerDateEnd"/>
	               </div>
	               <div style="clear: both;"></div>
	           </div>
           </div>
         	 
           <div style="clear: both;"></div>
       </div>
       </c:if>
       <div class="div_row">
       
          <div class="div_row_label">
           <%-- G6名字叫分发 --%>
                <c:if test="${isG6}">
                ${ctp:i18n('edoc.element.receive.distributer')}:<%-- 分发人 --%>
                </c:if>
                <%-- A8叫登记 --%>
                <c:if test="${!isG6}">
                ${ctp:i18n('edoc.edoctitle.regPerson.label')}:<%-- 登记人 --%>
                </c:if>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="distributer" id="distributer"/>
           </div>
           
           <div class="div_column_separate">&nbsp;</div>
       
           <div class="div_row_label">
                <%-- G6名字叫分发 --%>
                <c:if test="${isG6}">
                ${ctp:i18n('edoc.edoctitle.disDate.label')}:<%-- 分发日期 --%>
                </c:if>
                <%-- A8叫登记 --%>
                <c:if test="${!isG6}">
                ${ctp:i18n('edoc.edoctitle.regDate.label')}:<%-- 登记日期 --%>
                </c:if>
           </div>
           <div class="div_row_item">
               <div class="_condition w100b h100b" conditionType="datemulti" name="createTime">
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="createTimeBegin" id="createTimeBegin"/>
                   </div>
                   <div class="div_row_time_separate">-</div>
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="createTimeEnd" id="createTimeEnd"/>
                   </div>
                   <div style="clear: both;"></div>
               </div>
           </div>
           <div style="clear: both;"></div>
       </div>
    </div>
   </div>
</body>
</html>