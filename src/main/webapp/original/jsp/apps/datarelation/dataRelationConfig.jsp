<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="over_hidden">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
  <link rel="stylesheet" href="${path}/apps_res/datarelation/css/dataRelationConfig.css${ctp:resSuffix()}">
  <style type="text/css">
     /**修复jqueryUI样式冲突问题**/
     .dialog_close{
       position: relative;
       z-index: 1000;
     }
     .show_count span.error-title{
        float: right;
        top: 5px;
     }
  </style>
  <title>${ctp:i18n('ctp.dr.config.title.js')}</title>
</head>
<body>
<div class="link_header">
  <span class="logo"></span>
  <span>${ctp:i18n('ctp.dr.config.data.js')}</span>
</div>
<div class="link_content">
  <div class="left_wrap">
    <nav class="nav">
    <div class="nav-title">
      <span>${ctp:i18n('ctp.dr.config.source.js')}</span>
    </div>
    <ul class="nav-list">
      <c:set var="templateAction" value="${param.activityId eq 'start' ? 'templateSend':'templateDeal'}"/>
      <li dataTypeName="${templateAction}"  onmousedown="changeCss('${templateAction}')" class="current-nav">
        <span class="ico24 model_data_24"></span>
        <span>${ctp:i18n('ctp.dr.template.data.js')}</span>
      </li>
      <li dataTypeName="formSearch" onmousedown="changeCss('formSearch')">
        <span class="ico24 form_query_24"></span>
        <span>${ctp:i18n('ctp.dr.form.query.js')}</span>
      </li>
      <li dataTypeName="formStat" onmousedown="changeCss('formStat')">
        <span class="ico24 form_stat_24"></span>
        <span>${ctp:i18n('ctp.dr.form.stat.js')}</span>
      </li>
      <li dataTypeName="outSystem" onmousedown="changeCss('outSystem')">
        <span class="ico24 other_system_24"></span>
        <span>${ctp:i18n('ctp.dr.other.system.js')}</span>
      </li>
      <c:if test="${ctp:hasPlugin('doc')}">
	      <li dataTypeName="doc" onmousedown="changeCss('doc')">
	        <span class="ico24 doc_conter_24"></span>
	        <span>${ctp:i18n('ctp.dr.doc.center.js')}</span>
	      </li>
      </c:if>
      <c:if test="${ctp:hasPlugin('project')}">
	      <li dataTypeName="project" onmousedown="changeCss('project')">
	        <span class="ico24 project_24"></span>
	        <span>${ctp:i18n('ctp.dr.project.js')}</span>
	      </li>
	  </c:if>
      <li dataTypeName="index" class="display_none">
        <span class="ico24 index_24"></span>
        <span>${ctp:i18n('ctp.dr.index.js')}</span>
      </li>
    </ul>
    <div class="controler_l">
      <em class="left_l"></em><em class="left_r" style="display:none"></em>
    </div>
  </nav>
  </div>
  <div class="right_wrap">
    <div class="left_content">
      <div class="center">
        <div id="_title2" class="center-title form_area">
           <div style="margin-left:10px; display:inline-block; width:40%; padding-right:2px; margin-top:10px;">
              <input class="left title2 validate" type="text" id="title" value="${fn:escapeXml(title)}" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" maxlength="85" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" style="width:100%;">
           </div>
           <span class="title_exp">${ctp:i18n('ctp.template.tip.showOnly.js')}</span>
        </div>
        <div id="imgDiv" class="center-content" style="z-index:0;">
          <c:forEach items = "${configList}" var="config">
            <div class="infopic" onclick="fnImgClk(this);" style="filter:alpha(opacity=50); opacity:0.5;" dataTypeName="${config.dataTypeName}" class="hand" sort="${config.sort}">
             <div class="pictitle">
                <span class="title">${config.subjectHtml}</span>
                <span class="picclose" onclick="delRelationConfig(this,event);"></span>
             </div>
             <img src="${path}/apps_res/datarelation/image/${config.dataTypeName}.png" style="filter:alpha(opacity=50); ondragstart="return false">
            </div>
        </c:forEach>
        </div>
        <div id="defaultInfo" class="color_gray align_center" style="font-size:22px; top:50%; position:absolute; display:none; text-align:center; height:50px;width:100%;color:#aaa;">${ctp:i18n('datarelation.note.dragGuide.js')}</div>

        <div class="center-button">
          <div class="button_wrap" style="text-align:left;">
            <label class="isAllNode"><input type="checkbox" id="isAllNode" value="1" style="position:relative;top:-1px;"><span class="margin_l_5">${ctp:i18n('ctp.dr.copy.to.all.node.js')}</span></label>
            <div id="submitBtn" onclick="fnSubmit();" class="confirm">${ctp:i18n('ctp.dr.ok.js')}</div>
            <div onclick="fnCancel();">${ctp:i18n('ctp.dr.cancel.js')}</div>
            <div id="copyBtn" onclick="openCopyConfigWin()" style="background-color:#5191d1;">${ctp:i18n('ctp.dr.copy.js')}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="right_content">
      <div>
        <div>
          <div class="right-title">
            <span style="padding-top:12px;">${ctp:i18n('ctp.dr.field.set.js')}</span>
          </div>
          <div class="right-itemlist">
            <%@ include file="formSearchConfig.jsp"%>
            <%@ include file="formStatConfig.jsp" %>
            <%@ include file="templateSendConfig.jsp"%>
            <%@ include file="templateDealConfig.jsp" %>
            <%@ include file="docConfig.jsp" %>
            <%@ include file="outSystemConfig.jsp" %>
            <%@ include file="projectConfig.jsp" %>
            <%@ include file="indexConfig.jsp" %>
          </div>
          <div class="controler_r">
            <em class="right_r"></em><em class="right_l" style="display: none"></em>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- 模板 -->
<div id="imgTemplate" class="display_none">
  <div class="infopic" onmousedown="fnImgClk(this);">
     <div class="pictitle">
        <span class="title"></span>
        <span onclick="delRelationConfig(this,event);" class="picclose"></span>
     </div>
     <img width="321px" height="92px" src="" ondragstart="return false">
     <div class="mask display_none"><p>${ctp:i18n('ctp.dr.field.reset.js')}</p></div>
  </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/jquery-ui.js${ctp:resSuffix()}"></script>
  <script type="text/javascript">
    var pTemp = {"jval":'${jval}',"policyName":"${param.policyName}","activityDataId":"${param.activityDataId}"
            ,"processId":"${param.processId}","activityId":"${param.activityId}","objectId":"${param.formAppId}",
            "templateId":"${templateId}","templateImgSrc":"${path}/apps_res/datarelation/image/", 
            "nodeIdList":"${nodeIdList}","cacheDRs":"${param.cacheDRs}","isNew":"${isNew}"};
  </script>
  <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/dataRelationConfig.js${ctp:resSuffix()}"></script>
  <%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
</html>