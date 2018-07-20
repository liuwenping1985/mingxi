<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>发文登记薄组合查询</title>
<script type="text/javascript">

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
       width: 55px;
       float: left;
       height:22px;
       line-height:22px;
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
<div style="width: 630px">
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
               ${ctp:i18n('edoc.element.wordinno.label')}:<%-- 内部文号--%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="serialNo" id="serialNo"/>
           </div>
           <div style="clear: both;"></div>
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.wordno.label')}:<%-- 公文文号--%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="docMark" id="docMark"/>
           </div>
           <div class="div_column_separate">&nbsp;</div>
            <div class="div_row_label">
               ${ctp:i18n('edoc.element.senddepartment')}:<%-- 发文部门--%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="departmentName" id="departmentName"/>
           </div>
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.sendunit')}:<%-- 发文单位--%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="sendUnit" id="sendUnit"/>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.secretlevel.simple')}:<%-- 密级 --%>
           </div>
           <div class="div_row_item">
               <select name="secretLevel" id="secretLevel" class="w100b codecfg _condition" conditionType="select" codecfg="codeId:'edoc_secret_level'">
                    <option value="" selected>${ctp:i18n('common.pleaseSelect.label')}</option>
                </select>
           </div>
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
       		<div class="div_row_label">
            ${ctp:i18n('edoc.element.sendingdate')}:<%-- 签发日期--%>
           </div>
           <div class="div_row_item">
               <div class="_condition w100b h100b" conditionType="datemulti" name=signingDate>
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="signingDateBegin" id="signingDateBegin"/>
                   </div>
                   <div class="div_row_time_separate">-</div>
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="signingDateEnd" id="signingDateEnd"/>
                   </div>
               </div>
           </div>
           <div class="div_column_separate">&nbsp;</div>
       	   <div class="div_row_label">
               	${ctp:i18n('edoc.element.issuer')}:<%-- 签发人 --%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="issuer" id="issuer"/>
           </div>
           
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.edoctitle.createDate.label')}:<%-- 拟文日期--%>
           </div>
           <div class="div_row_item">
               <div class="_condition w100b h100b" conditionType="datemulti" name="startTime">
	               <div class="div_row_2_item">
	               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="startTimeBegin" id="startTimeBegin"/>
	               </div>
	               <div class="div_row_time_separate">-</div>
	               <div class="div_row_2_item">
	               <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="startTimeEnd" id="startTimeEnd"/>
	               </div>
	               <div style="clear: both;"></div>
               </div>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.author')}:<%-- 拟稿人 --%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="createPerson" id="createPerson"/>
           </div>
           
           <div style="clear: both;"></div>
       </div>
       <div class="div_row div_row_nonal">
           <div class="div_row_label">
               ${ctp:i18n('edoc.exchange.sendDate')}:<%-- 送文日期 --%>
           </div>
           <div class="div_row_item">
               <div class="_condition w100b h100b" conditionType="datemulti" name="sendTime">
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="sendTimeBegin" id="sendTimeBegin"/>
                   </div>
                   <div class="div_row_time_separate">-</div>
                   <div class="div_row_2_item">
                   <input type="text" class="w100b comp" style="width:98px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" name="sendTimeEnd" id="sendTimeEnd"/>
                   </div>
                   <div style="clear: both;"></div>
               </div>
           </div>
           <div class="div_column_separate">&nbsp;</div>
           <div class="div_row_label">
              	${ctp:i18n('exchange.edoc.sendperson')}:<%-- 送文人 --%>
           </div>
           <div class="div_row_item">
               <input type="text" class="w100b _condition" conditionType="input" name="sendperson" id="sendperson"/>
           </div>
           
           <div style="clear: both;"></div>
       </div>
       <div class="div_row">
           <div class="div_row_label">
               ${ctp:i18n('edoc.element.urgentlevel')}:<%-- 紧急程度 --%>
           </div>
           <div class="div_row_item">
               <select name="urgentLevel" id="urgentLevel" class="w100b codecfg _condition" conditionType="select" codecfg="codeId:'edoc_urgent_level'">
                    <option value="" selected>${ctp:i18n('common.pleaseSelect.label')}</option>
                </select>
           </div>
           <div style="clear: both;"></div>
           <div class="div_column_separate">&nbsp;</div>
	       <div style="clear: both;"></div>
       </div>
    </div>
</div>
</body>
</html>