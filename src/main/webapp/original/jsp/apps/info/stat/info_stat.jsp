<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoStatManager"></script>
<html class="h100b w100b over_hidden">
<head>
<%-- 信息统计 --%>
<script type="text/javascript">
	var orgName = "${orgName}";
	
	function _doInit(){
	    
	    //页面加载完成后执行, 解决IE7下页面布局问题
	    
	  //统计页面数据设置
	    if($('#llayout').length > 0){
	        window.layout = $('#llayout').layout();
	    }
	    if($("#autoReloadWindowSearch").length > 0){//条件页面
	        var type = $("#autoReloadWindowSearch").val();
	        if(type == "0"){
	           var form1 = document.getElementById("infoStatform");
	               form1.action = _ctxPath+"/info/infoStat.do?method=listInfoSearchStat";
	               form1.target = "content";
	               form1.submit();
	        }
	    }
	}
</script>
<title>${ctp:i18n('infosend.label.statInfo')}</title>
<script type="text/javascript" src="${path}/apps_res/info/js/stat/infoStat.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b w100b over_hidden" onload="_doInit()">
 <div id='llayout' class="comp" comp="type:'layout'">
        <div id="infoStatTable" class="layout_north page_color" layout="height:120,minHeight:5,maxHeight:120,border:true,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(120);}}">
            <div class="form_area" id="statData">
              <form id="searchform" name="searchform" method="post">
                  <table  style="height:100;width:100%;" border="0" cellSpacing="10" cellPadding="10">
                           <tr>
                               <td align="right" nowrap="nowrap" width="13%">
                               			${ctp:i18n('infosend.label.stat.range')}<!-- 统计范围 -->：
                               </td>
                               <td width="20%" align="left">
                               		<input  type="text" id="orgSelect" name="orgSelect" value="${orgName}">
							    	<input  type="hidden" id="viewPeopleId" name="viewPeopleId" value="${vobj.projectId}">
                               </td>
                               <td align="right" nowrap="nowrap" width="13%">
                               		   ${ctp:i18n('infosend.listInfo.shangbaoTime')}：
                               </td>
                               <td width="40%" align="left" colspan="3">
                                   <input id="fromdate" name="fromdate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/> -
		                    	   <input id="todate" name="todate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/>
                               </td>
                           </tr>
                           <tr>
                           <td align="right" nowrap="nowrap" width="13%">
                          			 ${ctp:i18n('infosend.label.stat.statByInfoType')}<!-- 按信息类型统计 -->：
                           </td>
                           <td align="left" nowrap="nowrap" width="13%">
                          		<input id="infoCategoryNames" name="infoCategoryNames" type="text"/>
			  					<input id="infoCategoryIds" name="infoCategoryIds" type="hidden"/>
                           </td>
                           <td align="right" nowrap="nowrap" width="13%">
                          			 ${ctp:i18n('infosend.label.stat.statByMagazine')}<!-- 按期刊统计 -->：
                           </td>
                           <td align="left" nowrap="nowrap" width="13%">
                          		<input id="infoMagazineNames" name="infoMagazineNames" type="text"/>
			  					<input id="infoMagazineIds" name="infoMagazineIds" type="hidden"/>
                           </td>
                           <td align="right" nowrap="nowrap" width="13%">
                          			 ${ctp:i18n('infosend.label.stat.statByScoreStandard')}<!-- 按评分标准统计 -->：
                           </td>
                           <td align="right" nowrap="nowrap" width="13%">
                         		 <input id="infoScoreNames" name="infoScoreNames" type="text"/>
		  						 <input id="infoScoreIds" name="infoScoreIds" type="hidden"/>
                           </td>
                           </tr>
                         </table>
              </form>
               <div id="button" class="common_checkbox_box align_center clearfix padding_t_5 padding_b_10">
                        <a href="javascript:void(0)" class="common_button common_button_gray" id="btnSaveMore"><!-- 查询 -->${ctp:i18n('infosend.label.stat')}</a>&nbsp;<%--查询 --%>
                        <a href="javascript:void(0)" class="common_button common_button_gray" id="btnCancelMore" onclick="cancelSearch();"><!-- 重置 -->${ctp:i18n('infosend.label.stat.button.reset')}</a>
                </div>
            </div>
        </div>
        <div class="layout_center" layout="border:false" style="overflow-y:hidden;">
           <form id="infoStatform" name="infoStatform" method="post">
     	   	 	<input type="hidden" value="0" id="autoReloadWindowSearch" name="autoReloadWindowSearch"/>
            </form>
            <iframe id="content" name="content" width="100%" height="100%" src="about:blank" scrolling="no" frameborder="0"></iframe>
        </div>
    </div>
</body>
</html>