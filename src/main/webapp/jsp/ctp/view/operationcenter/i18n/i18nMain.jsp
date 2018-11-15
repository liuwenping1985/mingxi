<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<jsp:include page="/WEB-INF/jsp/ctp/view/operationcenter/i18n/i18nMain_js.jsp"></jsp:include>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
	#searchHTML input,#searchHTML textarea{
		width:500px;
		padding-left:5px;
	}
	#searchHTML textarea {
		height: 44px;
	}
	#searchHTML button{
		 margin: auto;
	}
	#searchHTML table th {
		text-align: right;
	}
	.table{
		margin:auto;
	}
</style>
</head>
<body class="over_hidden h100b">
	<div id='layout' class="comp" comp="type:'layout'">
	    <div class="comp" comp="type:'breadcrumb',code:'T01_i18nresource'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
            <div id="searchDiv"></div>
            <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'0',extensions:'zip,xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'i18nzip',callMethod:'i18ncallBk'">
		</div>
		<div id='layoutCenter' class="layout_center over_hidden" layout="border:true">
		
				<table id="mytable" class="mytable" style="display: none"></table>
				<div id="grid_detail">
					<div id="welcome">
						<div class="color_gray margin_l_20">
							<div class="clearfix">
								<h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;"></h2>
								<div class="font_size12 left margin_t_20 margin_l_10">
									<div class="margin_t_10 font_size14">
										<span id="count"></span>
									</div>
								</div>
							</div>
							<div class="line_height160 font_size14" style="overflow:auto"></div>
						</div>
					</div>
					<div id="searchHTML" align="center" class="hidden">
						<table>
							<tr>
								<th noWrap="nowrap"><label class="margin_r_5" for="text">国际化资源Key名:</label></th>
								<td>
								   <input name="key" id="key" type="text" disabled="disabled"/>
								   <input name="uniqueKey" id="uniqueKey" type="hidden" disabled="disabled"/>
								</td>
							</tr>
							
							<c:forEach items="${allLocaleMap}" var="locale">
							<tr>
                                <th noWrap="nowrap"><label class="margin_r_5" for="text">${locale.value}(${locale.key}):</label></th>
                                <td><input name="locale_${locale.key}" id="locale_${locale.key}" type="text" /></td>
                            </tr>
							</c:forEach>
							
							<c:forEach items="${allLocaleMap}" var="locale">
							<tr>
                                <th noWrap="nowrap"><label class="margin_r_5" for="text">${locale.value}(${locale.key})路径:</label></th>
                                <td><textarea rows="2" cols="100" maxlength="200" readonly="readonly" disabled="disabled" id="locale_path_${locale.key}"></textarea></td>
                            </tr>
                            </c:forEach>
                            
							<tr>
								<th noWrap="nowrap"><label class="margin_r_5" for="text">加载等级:</label></th>
								<td><input name="levelType" disabled="disabled" id="levelType" type="text"></td>
							</tr>
						</table>
						<div class="align_center" style="width: 100%;">
					        <a class="common_button common_button_emphasize margin_5" href="javascript:void(0)" id="ok_1">确定</a>
					        <a class="common_button common_button_gray margin_5" id="cancel" href="javascript:void(0)" id="cancel">取消</a>
					    </div>
				    </div>
				</div>
	   </div>
	</div>
	<iframe id="exportIframe" name="exportIframe" style="display: none;" src="about:blank"></iframe>
</body>
</html>