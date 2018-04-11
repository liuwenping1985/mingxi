<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css" />
</head>
<body class="h100b over_hidden">
	<div class="aInput" style="padding-left: 30px;">
		<div class="allInput">
			<div class="inputRow">
				<div class="name">
					<span><span class="node">*</span>钉钉CorpID：</span>
				</div>
				<div class="input">
					<input type="text" id="corpid" placeholder="请先输入钉钉CorpID！">
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function OK() {
		var corpid = document.getElementById("corpid").value;
		if (corpid == "" || corpid == null) {
			ctpAlert("请先输入钉钉CorpID");
			return null;
		}
		var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]");
		if(pattern.test(corpid)){
			ctpAlert("CorpID含有特殊字符");
     		return;
		}
		return corpid;
	}

	function ctpAlert(msg) {
        $.messageBox({
            'type' : 100,
            'imgType' : 1,
            'msg' : msg,
            buttons : [ {
                id : 'btn1',
                text : "确定",
                handler : function() {
                }
            }]
        });
    }
</script>
</html>