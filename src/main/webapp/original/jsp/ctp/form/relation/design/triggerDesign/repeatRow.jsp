<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <script type="text/javascript">
     $(function () {
         var targetData = "${targetData}";
         if(targetData == ""){
             $("#targetDiv").addClass("hidden");
         }
     });

    </script>
</head>
<body class="over_hidden font_size12">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr height="15">
            <td>&nbsp</td>
        </tr>
        <tr>
            <td>
                <fieldset  style="margin-left:32px;margin-right:30px" class="form_area padding_5 margin_t_5">
                    <legend>&nbsp;${ctp:i18n('form.trigger.automatic.repeatrowlocation.label')}&nbsp;
                    </legend>
                    <div style="height: 380px;overflow: auto;">
                        <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="430"  style="overflow: auto;" disabled="disabled">
                                <tr height="22" style="margin-top: 5px;">
                                    <td width="40%" class="target" style="margin-top: 5px;">
                                        <div id="targetTD">
                                            <table>
                                                <tr>
                                                    <td align="center" width="20" class="padding_t_10">&nbsp;</td>
                                                    <td width="400" class="padding_t_10">
                                                        <div class="common_txtbox clearfix">
                                                            <div  class="w100b" style="border-style: none;white-space:pre-wrap " readonly="readonly" disabled="disabled">${repeatRowLoactionValue}</div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>

                        </table>
                    </div>
                </fieldset>
            </td>
        </tr>
    </table>

</body>
</html>