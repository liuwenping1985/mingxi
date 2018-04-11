<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../info/include/info_header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/template/template_print.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/gov/govtemplate/template_gov_print.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<title></title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/content.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=govTemplateManager"></script>
<script>
  var isHide = true;
  $(function() {
    var layout = $("#layout").layout();
    layout.setEast(55);
    $("#tabs2").hide();
    $("#right_tab_btn").show();
    //附件控制
    if ('${hasAttachments}' != 'true') {
      $("#nm").css("display", "none");
    } else {
      //$("#kzdiv").css("height", parseInt($("#kzdiv").css("height")) + 30);
    }
    $(".slideUpBtn",parent.document).click(function(){
      if(isHide)
        try{setTimeout("layoutEastClose()",10);}catch(e){}
    });
    $(".slideDownBtn",parent.document).click(function(){
      if(isHide)
        try{setTimeout("layoutEastClose()",10);}catch(e){}
    });
    
    $(window).resize(function(){
        $("#tabs2").tab().resetSize();
    });
    var contentType;
    if(typeof(getMainBodyDataDiv$) != 'undefined'){
	    contentType = $("#contentType", getMainBodyDataDiv$()).val();
    }
    if(contentType=='41' 
      || contentType=='42' 
      || contentType=='43' 
      || contentType=='44' 
      || contentType=='45'){
       $("#cc").css("height",'500px').css("font-size",'2px');
       $("#cc .content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
    }
    fillFormInfo();
    
    if(!hasOffice($("#contentType").val())) return;
    
  });
  
  function modifyTemplateContent() {
	  if(!hasOffice($("#contentType").val())) return;
	  updateInfoContent('detail');
  }
  
  function fillFormInfo(){
	var gtManager = new govTemplateManager();
	 var obj = new Object();
	 obj.templateId = '${template.id}';
	 obj.formId = '${summary.formId}';
	 obj.appType = '32';
	 obj.type= 0;
	 gtManager.ajaxFillFormDate(obj,{
        success : function(map){
            var xml_text = map.xml;
            var xsl_text = map.xsl;
            $("#xml").val(xml_text);
            $("#xsl").val(xsl_text);
            infoFormDisplay();
        }, 
        error : function(request, settings, e){
            $.alert(e);
        }
    });
}

  function infoFormDisplay(){
		var xml = document.getElementById("xml");
		var xsl = document.getElementById("xsl");
		//buttondnois();
		//document.getElementById("content").value = xsl.value;
		$("#document","#forformlist").val(xsl.value);
		if(xml.value!="" && xsl.value!="") {
			try{
				initSeeyonForm(xml.value, xsl.value);
				//setObjEvent();
			}catch(e){
				$.alert("信息单数据读取出现异常! 错误原因 : "+e);
				return false;
			}
			//substituteLogo(logoURL);
			return false;
		} else {
			//autoWidthAndHeight(false);
		}
	}
  
  function layoutEastClose() {
    isHide = true;
    var layout = $("#layout").layout();
    layout.setEast(55);
    $("#tabs2").hide();
    $("#right_tab_btn").show();
  }
  function layoutEastShow(n) {
    isHide = false;
    var layout = $("#layout").layout();
    if (n == 0 || n == 1) {
        layout.setEast(300);
        $("#tabs2").show();
        $("#tabs2").tab().resetSize();
        $("#right_tab_btn").hide();
    }
    if(${template.type ne 'text'}){
	    $("#tabs2_head li:eq(" + n + ") a").trigger("click");
    }else{
    	$("#tabs2_head li:eq(" + (n-1) + ") a").trigger("click");
    }
  }
  function getWFinfo(wfId) {
    var url = '${path}/workflow/designer.do?method=showDiagram&isTemplate=true&showPeopleTip=false&isDebugger=false&scene=2&isModalDialog=false&processId='
        + wfId;
    $("#showWFinfo").attr("src", url);
    $("#tabs2_body").removeClass("over_auto");
    //window.location = url;
  }
  function setCname() {
    $("#tabs2_body").addClass("over_auto");
  }
</script>
<style type="text/css">
/**重写样式**/
.stadic_layout_head{
   height: auto;
}

.stadic_head_height {
  /* height: 55px; */
}

.stadic_body_top_bottom {
  bottom: 0px;
  /* top: 55px; */
}
</style>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="layout_east" class="layout_east over_hidden" layout="width:300,border:false">
	        <input type="hidden" id="templateView" value='1'></input>
	        <input type="hidden" id="templateId" value="${template.id}"></input>
	        <input type="hidden" id="newBusiness" value="0"></input>
	        
            <div id="right_tab_btn" class="hidden">
                <a href="javascript:void(0)" class="common_button common_button_gray" onclick="layoutEastShow(0)">${ctp:i18n('collaboration.workflow.label')}</a><br /><!-- 流程 -->
                <a href="javascript:void(0)" class="common_button common_button_gray margin_t_5" onclick="layoutEastShow(1)">${ctp:i18n('template.templateDeatail.property')}</a><br /><!-- 属性 -->
                <a href="javascript:void(0)" class="common_button common_button_gray margin_t_5" onclick="modifyTemplateContent()">${ctp:i18n('govform.label.text')}</a><br /><!-- 正文 -->
                <a href="javascript:void(0)" class="common_button common_button_gray margin_t_5" onclick="doTemplatePrint()">${ctp:i18n('collaboration.newcoll.print')}</a><!-- 打印 -->
            </div>
            <div id="tabs2" class="comp" comp="type:'tab',parentId:'layout_east'">
                <div id="tabs2_head" class="common_tabs clearfix">
                    <div class="left padding_t_5 padding_l_10 padding_r_5" onclick="layoutEastClose()"><span class="ico16 arrow_2_r"></span></div>
                    <ul class="left">
                        <li class="current"><a href="javascript:void(0)" tgt="tab1_div" onclick="getWFinfo('${wfId}')"><span>${ctp:i18n('collaboration.workflow.label')}</span></a></li><!-- 流程 -->
                        <li><a href="javascript:void(0)" tgt="tab2_div" onclick="setCname()"><span>${ctp:i18n('template.templateDeatail.property')}</span></a></li><!-- 属性 -->
                        <!--
                        	<c:if test="${template.type ne 'workflow' && openFrom ne 'tempConfigFrame'}"><li><a class="last_tab" onclick="doPrint('template')"><span>${ctp:i18n('collaboration.newcoll.print')}</span></a></li></c:if>
                    	-->
                    	<li>
                    		<a href="javascript:void(0)" onclick="modifyTemplateContent()"><span>${ctp:i18n('govform.label.text')}<!-- 正文 --></span></a>
                    	</li>
                    	<li><a href="javascript:void(0)" onclick="doTemplatePrint()" class="last_tab"><span>${ctp:i18n('collaboration.newcoll.print')}</span></a></li>
                    </ul>
                    <div style="clear: both;"></div>
                </div>
                <div id="tabs2_body" class="common_tabs_body border_all over_auto">
                    <div id="tab1_div" style="border: 20px;">
                    	<iframe id="showWFinfo" src="" style="width:100%;height:100%;" frameborder="0" scrolling="no"></iframe>
                    </div>
                    <div id="tab2_div" class="hidden">
                        <table class="font_size12 line_height100 margin_t_10" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <!-- 流程期限 -->
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n("collaboration.process.cycle.label")}:</td>
                                <td><input type="text" name="name" disabled='true' value="${deadLine}" /></td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('common.remind.time.label')}:</td><!-- 提醒 -->
                                <td><input type="text" name="name" disabled='true' value="${remind}" /></td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('template.templateDeatail.prearchivedTo')}:</td><!-- 预归档到 -->
                                <td><input type="text" name="name" disabled='true' value="${archiveName}" /></td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10"></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="layout_center" layout="border:false">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height" id='kzdiv'>
                    <table class="font_size12 line_height100" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="80" align="right" class="padding_t_10">${ctp:i18n('collaboration.newcoll.subject')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td class="padding_t_10"><span id="subject">${ctp:toHTMLWithoutSpace(template.subject)}</span></td>
                        </tr>
                        <tr>
                            <td width="80" align="right" class="padding_t_10"  nowrap="nowrap">${ctp:i18n('template.temPrint.createMember')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td class="padding_t_10"><span id="senderInfo">${senderInfo}</span></td>
                        </tr>
                        <tr id="nm">
                        	<td width="80" align="right" class="padding_t_10">${ctp:i18n('common.attachment.label')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <table>
                                    <tr>
                                        <td class="padding_t_10">(<span id="attachmentNumberDiv22"></span>)</td>
                                        <td class="padding_t_10" align="left">
                                            <c:choose>
                                                <c:when test="${openFrom eq 'tempConfigFrame'}">
                                                     <input id="myfile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',attachmentTrId:'22',canDeleteOriginalAtts:false,originalAttsNeedClone:'${cloneOriginalAtts}'"
                                                attsdata='${attListJSON}' />
                                                </c:when>
                                                <c:otherwise>
                                                    <input id="myfile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',canFavourite:false,attachmentTrId:'22',canDeleteOriginalAtts:false,originalAttsNeedClone:'${cloneOriginalAtts}'"
                                                attsdata='${attListJSON}' />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <!-- 正文组建开始 -->
                <div id="content_workFlow" class="stadic_body_top_bottom content_view processing_view align_center">
                	<div style="width:0px;height:0px;overflow:hidden; position: absolute;">
                		<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
                	</div>
                  <ul class="view_ul align_left content_view" id='display_content_view'>
                    <li id="cc" class="view_li" style="margin-bottom: 2px;width:auto;min-width:786px">
                    	<%@ include file="../govform/form_show.jsp" %>
                    </li>
                  </ul>
                </div>
                <!-- 正文组件结束 -->
      </div>
        </div>
    </div>
</body>
</html>
<script>

</script>
