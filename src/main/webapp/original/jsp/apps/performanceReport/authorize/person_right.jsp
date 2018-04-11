<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=reportAuthManager"></script>
<title>${ctp:i18n('performanceReport.authorize.person_right.title')}</title>
    <style>
        .stadic_head_height{
            height:30px;
        }
        .stadic_body_top_bottom{
            bottom: 30px;
            top: 30px;
        }
        .stadic_footer_height{
            height:30px;
        }
        
        .error-form {
			border: 1px #dd7870 solid;
		}
		
		.error-title {
			background: url(${path}/skin/default/images/control_icon.png) no-repeat 0 -120px;
			display: inline-block;
			height: 16px;
			width: 16px;
		}
    </style>

<script type="text/javascript">

var templateOrginalData;
var reportAuthManager_ = new reportAuthManager();
$(document).ready(function() {
    var templateAuth = '${templateAuth}';
    var accountId = "${accountId }";
    var templateArray = eval(${templateNameArray });
    var scope = "MaxScope";
   	$("#setPersonColumn").hide();
   	$("#setRangeColumn").hide();
    var isNew="${ctp:toHTML(isNew)}";
    if(isNew=='true'){
    	$("#personColumn").val("${ctp:i18n('performanceReport.input.person')}");
    	$("#rangeColumn").text(" ${ctp:i18n('performanceReport.input.range')}");
    }
    if(!$.isNull(templateAuth)){
      if(templateAuth == 2){
        $("input[type=radio][value=1]").removeAttr("checked");
        $("input[type=radio][value=2]").attr("checked",'checked');
      }
    }
  
	$("#setPersonColumn,#personColumn").click(function(){
		var values = $("#personColumnHidden").val();
		var txt = $("#personColumn").val();
		$.selectPeople({
	        type : 'selectPeople',
	        panels : 'Department',
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
	        selectType : 'Account,Department,Member,Team,Post,Level',
	        isCanSelectGroupAccount:false,
            hiddenOtherMemberOfTeam:true,
	        onlyLoginAccount : true,
	        unallowedSelectEmptyGroup:true,
	        isNeedCheckLevelScope: false,
	        hiddenPostOfDepartment:true,
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
	$("input:radio[name=setTemplateColumn]").click(function(){
		selectTemplates();
	});
	$("#templateColumn").click(function(){
		$("input:radio[id=setTemplateColumnSinge]").attr("checked","checked");
		selectTemplates();
	});
	function selectTemplates(){
		if($("#templateColumnHidden").val() !=''){
			templateOrginalData=new Object();
		    templateOrginalData["ids"]  = $("#templateColumnHidden").val();
		    templateOrginalData["names"]= templateArray;
		}
		if($("input:radio[name=setTemplateColumn]:checked").val() == 2){
		    templateChoose(templateChooseCallback, '1,2,4', true, accountId, scope);
		  }else{
		    templateChooseCallback("","");
		    templateOrginalData = null;
		    //弹出框组件将已选项存放在全局变量rv中，这里选择全部模板后，将rv置空
		    templateOrginalData = null;
		  }
	}
	function templateChooseCallback(keys, arrayName, values){
		$("#templateColumn").val(values);
		$("#templateColumnHidden").val(keys);
		templateArray=arrayName;
	}	
	$("#saveQuery").click(function(){
		if($("#reportId").val() == ""){
			alert("${ctp:i18n('performanceReport.authorize.dialog.saveQuery')}");
			return;
		}
		if ($("#performanceTable").validate()) {
			if($("#setTemplateColumnSinge:checked").val() == 2 && $("#templateColumn").val() == ""){
				alert("${ctp:i18n('performanceReport.authorize.person.errorNoEmptyTemp')}");//指定模版不能为空,请选择
				return;
			}
			reportAuthManager_.checkReportExistAuthMember($("#reportId").val(),$("#authId").val(),$("#personColumnHidden").val(),{
					success : function(result) {
				        if(result != ""){
				        	//alert($.i18n('colCube.auth.detail.dialog.alreadAyuth', result));
				        	//alert("已经对"+result+"进行授权,不能重复设置！");
				        	//return;
				        }
						$("#form_performance").attr("action", url_performanceReport_authSave);
					    var proce = getCtpTop().$.progressBar({
						      text : "${ctp:i18n('performanceReport.authorize.dialog.saving')}"
					    });
			            $("#form_performance").jsonSubmit({
			            	callback : function() {
			            		 //window.parent.window.load_report();
			            		 //$("#authDetail",parent.document).attr("src","${url_performanceReport_personRight}&reportId=${reportId}&parentId=${parentId}");
			            	     proce.close();
			            	     parent.document.location.reload();
			            	}
			            }); 
				    }
			});
		}
	});
	$("#reset").click(function (){
		parent.document.location.reload();
	});
	
	initButton();
});
  //只读状态不显示设置，确认，取消三个按钮，radio按钮不可用，输入框置灰
  function initButton() {
      <c:if test="${!hasButton}">
           $("#setPersonColumn,#saveQuery,#reset,#setRangeColumn").hide();
           $("input:radio[name=setTemplateColumn],#personColumn,#rangeColumn,#templateColumn").attr("disabled",true);
      </c:if>
  }
</script>
</head>
<body class="h100b" >
<div class="stadic_layout" id="form">
	<form id="form_performance" name="form_performance" action="#" method="post">
	<!-- <fieldset class="form_area padding_10" id="queryFieldSet">
	<legend><font color="blue">${ctp:i18n('performanceReport.authorize.person.new')}</font></legend> -->
    
    
        <div class="stadic_layout_head stadic_head_height">
            
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix" overflow="scroll">

        

	<table width="100%" border="0" cellpadding="2" cellspacing="0" id="performanceTable">
	     <tr height="30px">
	         <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
	             for="text"><span class="required">*</span>${ctp:i18n('performanceReport.authorize.person.personName')}：</label></td>
	         <td nowrap="nowrap">
	             <div class=common_txtbox_wrap>
	             	 <input type="hidden" id="reportId" value="${reportId }"/>
	             	 <input type="hidden" id="authId" value="${authId }"/>
	             	 <input type="hidden" id="logType" value="1"/>
	                 <input readonly="readonly" id="personColumn" style='font-size:12px' name="${ctp:i18n('performanceReport.authorized.personnel.label.errorMsg')}"
	                     class="w100b validate" type="text" validate="type:'string',notNull:true,avoidChar:'\&#39;&quot;&lt;&gt;',errorMsg:'${ctp:i18n('performanceReport.authorized.personnel.label.errorMsg')}'" value="${bean.personsName }"/>
	                 <input type="hidden" id="personColumnHidden" value="${ctp:parseElementsOfTypeAndId(bean.personsNameId) }"/>
	             </div>
	         </td>
	         <td align="left" width="100">
	         	<a class="common_button common_button_gray margin_l_5"
	             href="javascript:void(0)" id="setPersonColumn" dialogTitle="${ctp:i18n('performanceReport.authorize.person.personName')}" dialogId="dialog_crossColumn">${ctp:i18n('performanceReport.authorize.person.set')}</a>
	         </td>
	     </tr>
         <c:if test="${hasTemplat}">
         <tr>
             <td><label class="margin_r_10 right title" for="text"><font color="red">*</font>${ctp:i18n('performanceReport.authorize.person.template')}：</label></td>
             <td nowrap="nowrap">
                 <!-- <div id="setTemplateColumn" class="codecfg"
        codecfg="codeType:'java',render:'radioh',codeId:'com.seeyon.apps.performanceReport.enums.WorkFlowAnalysisTemplateAuthEnums',defaultValue:1"></div>
                  -->
                  <div class="codecfg">
                  <label for='setTemplateColumnAll' class='margin_r_10 hand'>
                  <input type='radio' value='1' name='setTemplateColumn' id="setTemplateColumnAll" class='radio_com' checked/>
                  	${ctp:i18n('performanceReport.authorize.person.allTemplate')}</label><!-- 全部模版 -->
             </td>
             <td></td>
         </tr>
         <tr>
             <td></td>
             <td>
                <div class="common_txtbox clearfix">
                    <label label class="margin_r_10 left title" for="setTemplateColumnSinge"><input id="setTemplateColumnSinge" type='radio' value='2' name='setTemplateColumn' class='radio_com'/>
                    	${ctp:i18n('performanceReport.authorize.person.designatedTemplate')}<input type="hidden" id="templateColumnHidden" value="${bean.templatesNameId }">  </label>                                                   
                    <div class="common_txtbox_wrap" style="padding-right:0">
                        <textarea readonly="readonly" style="border:none;" id="templateColumn" name="templateColumn"  rows="3" class="w100b">${bean.templatesName }</textarea>
                    </div>
                </div>
             </td>
             <td></td>
         </tr>
         </c:if>
         <c:if test="${!hasTemplat && hasRanges }">
            <tr height="30px" class="">
             <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
                 for="text"><font color="red">*</font>${ctp:i18n('performanceReport.authorize.queryRangs')}：</label></td>
             <td>
                 <div class="common_txtbox  clearfix">
                     <input type="hidden" id="rangeColumnHidden" value="${ctp:parseElementsOfTypeAndId(bean.queryRangsId) }">
                     <textarea readonly="readonly" id="rangeColumn" style="font-size:12px" name="${ctp:i18n('performanceReport.authorize.list.queryRangs')}" class="w100b validate" 
                     validate="type:'string',notNull:true,avoidChar:'\&#39;&quot;&lt;&gt;',errorMsg:'${ctp:i18n('performanceReport.authorize.list.queryRangs')}'">${bean.queryRangs }</textarea><!-- 查看范围不能为空 -->
                 </div>
             </td>
             <td align="left" width="100">
             	<a class="common_button common_button_gray margin_l_5"
                 href="javascript:void(0)" id="setRangeColumn" dialogTitle="${ctp:i18n('performanceReport.authorize.list.queryRangs')}">${ctp:i18n('performanceReport.authorize.person.set')}</a>
             </td>
            </tr>
         </c:if>
	</table>
	<!-- </fieldset> -->
       </div>
        <div align="center" id="buttonDiv" class="stadic_layout_footer stadic_footer_height page_color">
            <a class="common_button common_button_emphasize margin_r_5" href="javascript:void(0)" id="saveQuery">${ctp:i18n('performanceReport.authorize.person.button.confirm')}</a>
            <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('performanceReport.authorize.person.button.cancel')}</a>
        </div>
	</form>
</div>
</body>
</html>