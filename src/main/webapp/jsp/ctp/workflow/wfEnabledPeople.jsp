<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>模板批量节点替换功能</title>
</head>
<body>
	<div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
        	<div class="form_area">
            	<div class="form_area_content">
                    <div class="one_row">
                        <table border="0" width="100%;" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <th nowrap="nowrap" width="90">
                                        <label class="margin_r_10" for="text" >&nbsp;&nbsp;${ctp:i18n('workflow.replaceNode.19')}:</label></th>
                                    <td width="110" nowrap="nowrap">
                                        <div class="common_txtbox_wrap">
											<input type="text" name="select" id="select"/>
										</div>
                                    </td>
                                    <td width="30" nowrap="nowrap">
                                       <ul class="common_search common_search_condition clearfix right">
        									<li class="">
												<a id="searchButton" class="common_button common_button_gray search_buttonHand" href="#">
													<em jQuery183045148832554360635="39"></em>
												</a>
											</li>
										</ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
           </div>
        </div>
        <div id="resultListArea" class="layout_center page_color over_hidden" layout="border:false">
			<table id="resultList" class="flexme3" style="display: none;"></table>
		</div>
	</div>
<script type="text/javascript">
<%@include file="wfEnabledPeople_js.jsp"%>
</script>
<%@include file="workflowDesigner_js_api.jsp"%>
</body>
</html>