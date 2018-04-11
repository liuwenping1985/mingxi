<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/phrase/systemphraseset.js.jsp" %>
<html>
<head>
	<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
    <title>${ctp:i18n('phrase.sys.htmltitle')}</title>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_commonPhrase'"></div>
            <div id="toolbar"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="flexme3" style="display: none"></table>
            <form method="post" id="operForm">
            <div id="grid_detail">
          		<div id="old_id" class="hidden">	
            	<input type="hidden" id='s' name="s" style="width:300px;"/>
                <div id="newLagText" class='margin_l_10 hidden font_size14'>${ctp:i18n('phrase.sys.xjxtcyy')}</div>
                <div id="viewLagText" class='margin_l_10 hidden font_size14'>${ctp:i18n('phrase.sys.ylxtcyy')}</div>
                <div id="editLagText" class='margin_l_10 hidden font_size14'>${ctp:i18n('phrase.sys.xgxtcyy')}</div>
                <table align="center" id="ttttt">
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <textarea id="txtPhrase" name="txtPhrase" style="width: 400px; height: 120px;"></textarea>
                            <p class="font_size12 green">
${ctp:i18n('phrase.sys.sm')}<br />
${ctp:i18n('phrase.sys.cyycd')}
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td class="align_center padding_10"><a href="javascript:void(0)" id="okBtn" class="common_button common_button_emphasize">${ctp:i18n('phrase.sys.makesure')}</a>&nbsp;<a href="javascript:void(0)" id="cancelBtn" class="common_button common_button_gray">${ctp:i18n('phrase.sys.makecancle')}</a></td>
                    </tr>
                </table>
                </div>
                <div id="new_id" style="color:gray;margin-left:20px;" >
 					<div class="clearfix">
                        <!-- 常用语设置 -->
				        <h2 class="left">${ctp:i18n('collaboration.common.phraset.commonLanSet')}</h2>
				        <div class="font_size12 left margin_t_20 margin_l_10">
				            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                                <span class="font_bold">${dataCount}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
                            </div>
				        </div>
				    </div>
				    <div class="line_height160 font_size14">
                        <!-- 单击“新建”菜单，新建单位常用语。 -->
				        <p><span class="font_size12">●</span>${ctp:i18n('collaboration.common.phraset.label1')}</p>
				        <!-- 勾选一条常用语记录后单击“修改”菜单或双击列表中的常用语记录，修改常用语。 -->
                        <p><span class="font_size12">●</span>${ctp:i18n('collaboration.common.phraset.label2')}</p>
                        <!-- 勾选列表中的常用语记录，单击“删除”菜单，删除选中的常用语记录。 -->
				        <p><span class="font_size12">●</span>${ctp:i18n('collaboration.common.phraset.label3')}</p>
				    </div>
				</div>
            </div>
            
            </form>
        </div>
    </div>
</body>
</html>

