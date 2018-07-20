<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_y_auto">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=cubeAuthManager"></script>
<title>${ctp:i18n('colCube.auth.detail.title')}</title>
<script type="text/javascript">

var cubeAuthManager_ = new cubeAuthManager();

var welcome = "${ctp:toHTML(welcome)}";
$(document).ready(function() {
     //隐藏显示欢迎页   
    if(welcome == "true"){
      $("#welcomeDiv").show();
    }else{
      $("#form").show();
    }
    $("#setPersonColumn").hide();
   	$("#setRangeColumn").hide();
   	if("${ctp:toHTML(flag)}" == "readOnly"){
   		$("#personColumn").attr("disabled",true);
   		$("#rangeColumn").attr("disabled",true);
   	}
   	if("${ctp:toHTML(flag)}" == "add"){
   		$("#personColumn").val("${ctp:i18n('performanceReport.input.person')}");
    	$("#rangeColumn").text(" ${ctp:i18n('performanceReport.input.range')}");
   	}
	$("#setPersonColumn,#personColumn").click(function(){
		var values = $("#personColumnHidden").val();
		var txt = $("#personColumn").val();
		$.selectPeople({
	        type : 'selectPeople',
	        panels : 'Department,Team,Post,Level,Outworker',
	        selectType : 'Member',
	        onlyLoginAccount : true,
	        isNeedCheckLevelScope: false,
		    params : {
		    	text : txt,
		        value : values
		    },
		    callback : function(ret) {
			  $("#personColumn").val(ret.text);
		      $("#personColumnHidden").val(ret.value);
		    }
		});
	});
	$("#setRangeColumn,#rangeColumn").click(function(){
		var values = $("#rangeColumnHidden").val();
		var txt = $("#rangeColumn").val();
		$.selectPeople({
	        type : 'selectPeople',
	        panels : 'Department,Team,Post,Level,Outworker',
	        selectType : 'Account,Department,Team,Post,Level,Member',
	        onlyLoginAccount : true,
	        isNeedCheckLevelScope: false,
		    params : {
		    	text : txt,
		        value : values
		    },
		    callback : function(ret) {
		      $("#rangeColumn").val(ret.text);
		      $("#rangeColumnHidden").val(ret.value);
		    }
		});
	});
	$("#saveQuery").click(function(){
		if($("#reportId").val() == ""){
			$.alert("${ctp:i18n('colCube.auth.detail.dialog.saveQuery')}");
			return;
		}
		if ($("#performanceTable").validate()) {
			cubeAuthManager_.checkCubeExistAuthMember($("#reportId").val(),$("#authId").val(),$("#personColumnHidden").val(),{
				success : function(result) {
			        if(result != ""){
			        	$.alert($.i18n('colCube.auth.detail.dialog.alreadAyuth', result));
			        	//alert("已经对"+result+"进行授权,不能重复设置！");
			        	return;
			        }
					$("#form_performance").attr("action", url_colCube_authDetailSave);
				    var proce = getCtpTop().$.progressBar({
				      text : "${ctp:i18n('colCube.auth.list.dialog.saving')}"
				    });
		            $("#form_performance").jsonSubmit({
		            	callback : function() {
// 		            		 window.parent.window.load_report();
// 		            		 $("#authDetail",parent.document).attr("src","${url_colCube_authDetail}&reportId=${reportId}");
		            	     proce.close();
		            	     parent.document.location.reload();
		            	}
		            }); 
				}
			});
		}
	});
	$("#reset").click(function (){
		$("#performanceTable input").each(function(){
			if(this.id != "reportId"){
				$(this).val("");
			}
		});
		$("#performanceTable textarea").each(function (){
			$(this).text("");
		});
		
         $("#welcomeDiv").show();
         $("#form").hide();
	});
});
</script>
</head>
<body class="bg_color_white" style="height:100%">

<div class="color_gray margin_l_20 hidden color_gray2" id="welcomeDiv">
    <div class="clearfix">
        <h2 class="left">${ctp:i18n('colCube.common.crumbs.colCubeSet')}</h2>
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('colCube.auth.detail.totals')} <span id="totals" class="font_bold color_black">${ctp:toHTML(totals)}</span> ${ctp:i18n('colCube.auth.detail.unit')}</div>
        </div>
    </div>
    <div class="line_height160 font_size14">
        <p><span class="font_size12">●</span> ${ctp:i18n('colCube.auth.detail.dialog.step1')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('colCube.auth.detail.dialog.step2')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('colCube.auth.detail.dialog.step3')}</p>
    </div>
</div>


<div class="form_area padding_5 hidden" id="form">
	<form id="form_performance" name="form_performance" action="#" method="post">
	<!-- <fieldset class="form_area padding_10" id="queryFieldSet">
    <c:if test="${flag == 'add'}">
    <legend><font color="blue">${ctp:i18n('colCube.auth.detail.new')}</font></legend>
    </c:if>
    <c:if test="${flag == 'edit'}">
    <legend><font color="blue">${ctp:i18n('colCube.auth.detail.edit')}</font></legend>
    </c:if>
    <c:if test="${flag == 'readOnly'}">
    <legend><font color="blue">${ctp:i18n('colCube.auth.detail.readOnly')}</font></legend>
    </c:if> -->
	
	
    <table width="100%" border="0" cellpadding="2" cellspacing="0" id="performanceTable">
	     <tr height="30px">
	         <th width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
	             for="text"><span class="required">*</span>${ctp:i18n('colCube.auth.detail.personName')}：</label></th>
	         <td width="50%" nowrap="nowrap">
	             <div class=common_txtbox_wrap>
	             	 <input type="hidden" id="reportId" value="${reportId }"/>
	             	 <input type="hidden" id="authId" value="${authId }"/>
	             	 <input type="hidden" id="logType" value="2"/>
	                 <input readonly="readonly" id="personColumn" style='font-size:12px' name="${ctp:i18n('performanceReport.authorized.personnel.label.errorMsg')}"
	                     class="w100b validate" type="text" validate="type:'string',notNull:true,avoidChar:'\&#39;&quot;&lt;&gt;',errorMsg:'${ctp:i18n('performanceReport.authorized.personnel.label.errorMsg')}'" value="${bean.personsName }"/>
	                 <input type="hidden" id="personColumnHidden" value="${ctp:parseElementsOfTypeAndId(bean.personsNameId) }"/>
	             </div>
	         </td>
	         <td align="left">
             <c:if test="${flag != 'readOnly'}">
             <a class="common_button common_button_gray margin_l_5"
	             href="javascript:void(0)" id="setPersonColumn" dialogTitle="${ctp:i18n('colCube.auth.detail.personName')}" dialogId="dialog_crossColumn">${ctp:i18n('colCube.auth.detail.set')}</a>
	         </c:if>
             </td>
	     </tr>
	     <tr height="30px">
	         <th width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
	             for="text"><font color="red">*</font>${ctp:i18n('colCube.auth.list.queryRangs')}：</label></th>
	         <td>
				     <input type="hidden" id="rangeColumnHidden" value="${ctp:parseElementsOfTypeAndId(bean.queryRangsId) }">
				     <div class="common_txtbox  clearfix">
                     <textarea readonly="readonly" id="rangeColumn" style="font-size:12px" name="${ctp:i18n('performanceReport.authorize.list.queryRangs')}" class="w100b validate" 
                     validate="type:'string',notNull:true,avoidChar:'\&#39;&quot;&lt;&gt;',errorMsg:'${ctp:i18n('performanceReport.authorize.list.queryRangs')}'">${bean.queryRangs }</textarea><!-- 查看范围不能为空 -->
                     </div>
	         </td>
	         <td align="left" width="100">
             <c:if test="${flag != 'readOnly'}">
             <a class="common_button common_button_gray margin_l_5"
	             href="javascript:void(0)" id="setRangeColumn" dialogTitle="${ctp:i18n('colCube.auth.list.queryRangs')}">${ctp:i18n('colCube.auth.detail.set')}</a>
             </c:if>
	         </td>
	     </tr>
	</table>
	<!--</fieldset>  -->
    <div align="center" id="buttonDiv" style='margin-bottom:7px;' class="stadic_layout_footer stadic_footer_height page_color">
        <c:if test="${flag != 'readOnly'}">
        <a class="common_button common_button_gray margin_5" href="javascript:void(0)" id="saveQuery">${ctp:i18n('colCube.auth.detail.button.confirm')}</a>
        <a class="common_button common_button_gray margin_5" href="javascript:void(0)" id="reset">${ctp:i18n('colCube.auth.detail.button.cancel')}</a>
        </c:if>
    </div>
	</form>
</div>

</body>
</html>