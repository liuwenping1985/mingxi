<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
    <head>
    	<%-- 开关设置 --%>
        <title>${ctp:i18n("infosend.score.switchSet.title")}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <script type="text/javascript" src="${path}/apps_res/info/js/list.js${ctp:resSuffix()}"></script>
        <style>
        .stadic_body_top_bottom{
            top: 0px;
            bottom: 40px;
        }
        .stadic_footer_height{
            height:40px;
        }
        </style>
        <script type="text/javascript">
            $(document).ready(function () {
            	$("#edit_confirm_button").click(function() {
            		submitScore();
            	});
            });

            function submitScore() {
                //表单提交
                var form = $("#addForm");
                var path = _ctxPath + "/info/switchSet.do?method=updateSwitchSetting";
                form.attr('action', path);
                form.jsonSubmit({
                    validate : true,
                    errorIcon : true,
                    callback : function(args) {
                		$.alert("${ctp:i18n('infosend.switchSet.successfullySaved')}");
                    }
                });
            }
        </script>
    </head>
    <body class="h100b over_hidden">
        <div class="stadic_layout_body stadic_body_top_bottom form_area" style="text-align: center"  id="content">
            <form style="height: 100%;" name="addForm" id="addForm" method="post" class="align_center">
              	<table style="height: 120px;width:100%;padding-top: 30px" border="0" cellSpacing="5" cellPadding="5">
                    <tr height="20px" align="center">
                        <!-- 信息积分原则 -->
                        <th width="30%" nowrap="nowrap">${ctp:i18n('infosend.score.switchSet.inforInteger')}</th>
                        <!-- 累计每次发布得分 -->
                        <td width="70%" class="w100b" align="left">
                            <label>
                                <input type="radio" id="scoreType" name="scoreType" value="totalScore" ${switchSetScoreType=="totalScore"?'checked="checked"':''}> ${ctp:i18n('infosend.score.switchSet.totalScore')}
                            </label>
                        </td>
                    </tr>
                    <tr height="20px" align="center">
                        <td width="30%" nowrap="nowrap" >&nbsp;</td>
                        <!-- 取发布次数中最高的得分（以每个刊登级别范围内） -->
                        <td width="70%" class="w100b" align="left">
                            <label>
                                <input type="radio" id="scoreType"  name="scoreType"  value="maxScore" ${switchSetScoreType=="maxScore"?'checked="checked"':''}> ${ctp:i18n('infosend.score.switchSet.maxScore')}
                            </label>
                        </td>
                    </tr>
      	         </table>
            </form>
        </div>

		<div class="stadic_layout_footer stadic_footer_height" id="bottomButton">
			<div id="button" class="common_checkbox_box align_center clearfix padding_t_5 border_t">
		           	<a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
		            <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
		        </div>
		</div>
    </body>
</html>








