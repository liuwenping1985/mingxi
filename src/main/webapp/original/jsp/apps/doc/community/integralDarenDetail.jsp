<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="height: 100%;overflow: hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
$(function(){
    $("#ok").click(function() {
    	if(!$("#detailForm").validate()){
    		return false;
    	}
    	
        var minScore1 = $('#minScore').val();
        var maxScore1 = $('#maxScore').val();
        //第一行
        if(minScore1 == "" && maxScore1 == ""){
            $.alert("${ctp:i18n('doc.daren.integral.nullwarning')}!");
            return;
        }
        
        //中间行
        if(!selectRowData.isFrist && !selectRowData.isEnd && maxScore1.trim() == ""){
        	$.alert($.i18n('doc.daren.integral.nullwarning.js'));
        	return;
        }
        
        var minScore2 = minScore1;
    	if(selectRowData.isFrist && minScore1.trim()==""){
    		minScore2 = 0;
    	}
    	
        //当前行的最大值 = 前行的最小值  到   下一行的最小值之间
        if(minScore1 != "" && maxScore1 != ""){
        	var range = selectRowData.nextRow.integratingRange.split("~");//下一行的最大值
        	if(selectRowData.isEnd){
        		range[1] = 100000;
        	}
            if(parseFloat(minScore2) >= parseFloat(maxScore1)||parseFloat(maxScore1) >= parseFloat(range[1])){
                $.alert($.i18n('doc.daren.integral.errorwarning.js',minScore2,range[1]));
                return;
            }
        }
        
        var integralManager = new knowledgeManager();
        var params = new Array();
        
        if(minScore1 == ""){
            minScore1 = -10000;
        }
        
        if(maxScore1 == ""){
            maxScore1 = -10000;
        }
        var DarenId = $('#id').val();
        params[0] = minScore1;
        params[1] = maxScore1;
        params[2] = DarenId;
        params[3] = $('#medal').val();
        $("#detailForm").jsonSubmit();
    });
    
    
    $("#cancel").click(function() {
        parent.location.reload();
    });
    
});
var id;
var integralLevel;
var medal;
var medalIcon;
var minScore;
var maxScore;
var description;
var selectRowData;
var change = [];
//判断是否是第一次执行
/* function ifChange() {
    if (change.length == 0) {
        change[0] = new inputChange($("#integralLevel"));
        change[1] = new inputChange($("#medal"));
        change[2] = new inputChange($("#medalIcon"));
        change[3] = new inputChange($("#minScore"));
        change[4] = new inputChange($("#description"));
        change[5] = new inputChange($("#id"));
    } else {
        for ( var i = 0; i < 6; i++) {
            change[i].check();
        }
    }
} */

function check(arg, rowData) {
	var row = rowData.selectRow;
	selectRowData = rowData;
    if (row) {
        id = row.id;
        integralLevel = row.integralLevel;
        medal = row.medal;
        medalIcon = row.medalIcon;
        var score = row.integratingRange;
        if(score.indexOf("以上") != -1){
            minScore = score.substring(0,score.length-2);
            maxScore = "";
        }else if(score.indexOf("以下") != -1){
            maxScore = score.substring(0,score.length-2);
            minScore = "";
        }else{
            var temp = score.split("~");
            minScore = temp[0];
            maxScore = temp[1];
        }
        description = row.description;
    }
    //点击新建
    /*if (arg == "new") {
        $("#id").val("0");
        $("#integralLevel").val("");
        $("#medal").val("");
        $("#medalIcon").val("");
        $("#minScore").val("");
        $("#maxScore").val("");
        $("#description").val("");
    }*/
    //点击列表行
    if (arg == "disable") {
    	var disable2readOnly ={"disabled" : "disabled","readonly" : "readonly"};
    	$("#ok").attr(disable2readOnly);
    	$("#cancel").attr(disable2readOnly);
        $("#integralLevel").attr(disable2readOnly).val(integralLevel);//查看列表时input框 disable状态
        $("#medal").attr(disable2readOnly).val(medal);
        $("#medalIcon").attr(disable2readOnly).val(medalIcon);
        $("#minScore").attr(disable2readOnly).val(minScore);
        $("#maxScore").attr(disable2readOnly).val(maxScore);
        $("#description").attr(disable2readOnly).val(description);
        $("#id").val(id);
        //ifChange();//查看列表不需要inputChange方法；
    }else {//点击修改,双击
    	if(rowData.isFrist){
    		$("#minScore").removeAttr("disabled").removeAttr("readonly");
    	}
    	$("#ok").removeAttr("disabled").removeAttr("readonly");
    	$("#cancel").removeAttr("disabled").removeAttr("readonly");
        //$("#integralLevel").removeAttr("disabled").removeAttr("readonly");
        $("#medal").removeAttr("disabled").removeAttr("readonly");
        $("#medalIcon").removeAttr("disabled").removeAttr("readonly");
        $("#maxScore").removeAttr("disabled").removeAttr("readonly");
        $("#description").removeAttr("disabled").removeAttr("readonly");
    }
}
    
</script>
</head>
<body style="height: 100%">
	<div class="form_area align_center" style="height: 85%;overflow: auto;">
    <form id="detailForm" class="align_center" action="/seeyon/doc/knowledgeController.do?method=saveKnowledgeDarenSetting">
        <input type="hidden" id="id" name="id" value="0">
        <table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
                <tbody><tr>
                    <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('doc.daren.level')}:</label></th>
                    <td colspan="3"><div class="common_txtbox_wrap">
                        <input id="integralLevel" disabled="disabled" class="validate" value="" type="text" validate='isWord:false,name:"${ctp:i18n('doc.daren.level')}",isNumber:true,notNull:true,min:1,max:10'>
                    </div></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('doc.daren.medal')}:</label></th>
                    <td colspan="3"><div class="common_txtbox_wrap">
                        <input id="medal" disabled="disabled" class="validate" name="medal" value="" type="text" validate='type:"string",name:"${ctp:i18n('doc.daren.medal')}",notNull:true,minLength:1,maxLength:20,avoidChar:"-!@#$%^&amp;*()_+"'>
                    </div></td>
                </tr>
                <tr style="display: none;">
                    <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('doc.daren.medal.image')}:</label></th>
                    <td colspan="3"><div class="common_txtbox_wrap">
                        <input id="medalIcon" disabled="disabled" class="validate" name="medalIcon" value="" type="text" validate='type:"string",name:"${ctp:i18n('doc.daren.medal.image')}",notNull:true'>
                    </div></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <th noWrap="nowrap"> <label class="margin_r_5" for="text">${ctp:i18n('doc.daren.integral')}:</label></th>
                    <td class="w50b"><div class="common_txtbox_wrap">
                        <input id="minScore" disabled="disabled" class="validate" name="minScore" value="" type="text" size="4" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,min:-9999,max:100000'>
                    </div></td>
                    <td noWrap="nowrap">——</td>
                    <td class="w50b"><div class="common_txtbox_wrap">
                        <input id="maxScore" disabled="disabled" class="validate" name="maxScore" value="" type="text" size="4" validate='isWord:false,name:"${ctp:i18n('doc.daren.fenzhi')}",isNumber:true,min:-9999,max:100000'>
                    </div></td>
                    <td>&nbsp;</td>
                </tr>   
                <tr><th noWrap="nowrap">
                    <label class="margin_r_10" for="text">${ctp:i18n('doc.explain')}:</label>
                </th>
                <td colspan="3">
                    <div class="common_txtbox  clearfix margin_t_5">
                        <textarea id="description" class="padding_5" style="width: 97%; height: 40px;" disabled="disabled" class="validate" cols="16" rows="3" validate='type:"string",name:"${ctp:i18n('doc.explain')}",notNull:false,maxLength:50,character:"-!@#$%^&amp;*()_+"'> </textarea>
                    </div>
                </td>
                <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="5">
                          <div class="explanationh">
                            <ul class="explanationh_list">
                                <li><span class="left">${ctp:i18n('doc.log.integral.declare')}</span></li>
                                <li><span class="left">${ctp:i18n('doc.log.integral.declare.a')}</span></li>
                                <li><span class="left">${ctp:i18n('doc.log.integral.declare.b')}</span></li>
                                <li><span class="left">${ctp:i18n('doc.log.integral.declare.c')}：${path}/skin/default/images/icon24.png</span></li>
                                <li><span class="left">${ctp:i18n('doc.log.integral.declare.d')}</span></li>
                            </ul>
                           </div>
                        </td>
                    </tr>
                    </tbody>
              </table>
              
        </form>
    </div>
 <div class="align_center margin_t_5 bg_color_black">
                        <a id="ok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
                        <a id="cancel" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
</div>
</body>
</html>