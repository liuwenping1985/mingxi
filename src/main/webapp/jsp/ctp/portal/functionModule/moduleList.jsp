<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>功能菜单设置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=functionalModuleManager"></script>
<script type="text/javascript" src="${path}/common/js/startOrStopModal.js"></script>
<script type="text/javascript" src="${path}/common/js/resizeBrowser.js"></script>
<link rel="stylesheet" href="${path}/common/css/model.css${ctp:resSuffix()}" type="text/css" />

</head>
<body>
	<div style="width:100%;height:auto;overflow:hidden;margin-top:5px;">
	<div class="comp" comp="type:'breadcrumb',code:'T11_functionalModule'"></div>
	<form id="menuForm" name="menuForm" method="post" action="">
		<div style="width:50%;float:left;">
			<div class ="wrap">
				<!--文化建设  -->
				<div class="model">
					<div class="model_left">文化建设</div>
					<div class="model_right">
					<c:forEach items="${culture}" var="culture">
						<div class="model_list">
							<div class="model_title"></div>
							<div class="onoff">
								<input type="checkbox" id="${culture}"name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
				<!-- 知识社区 -->
				<div class="model">
					<div class="model_left">知识社区</div>
					<div class="model_right">
					<c:forEach items="${knowledge}" var="knowledge">
						<div class="model_list">
							<div class="model_title" ></div>
							<div class="onoff">
								<input type="checkbox" id="${knowledge}" name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
				<!-- 项目管理 -->
				<div class="model">
					<div class="model_left">目标管理</div>
					<div class="model_right">
					<c:forEach items="${target}" var="target">
						<div class="model_list">
							<div class="model_title"></div>
							<div class="onoff">
								<input type="checkbox" id="${target}" name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
				<!-- 协同驾驶舱 -->
		        <div class="model">
					<div class="model_left b_bottom">协同驾驶舱</div>
					<div class="model_right">
					<c:forEach items="${coordination}" var="coordination">
						<div class="model_list">
							<div class="model_title_border"></div>
							<div class="onoff_border">
								<input type="checkbox" id="${coordination}" name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
			</div>
		</div>
		<div style="width:50%;float:left">
			<div class="wrap">
				<!-- 公文管理 -->
				<c:forEach items="${map}" var="map">
				<div class="model">
					<div class="model_right no_title">
						<div class="model_list">
							<div class="model_title no_title"></div>
							<div class="onoff">
								<input type="checkbox" id="${map}" name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</div>
				</div>
				</c:forEach>
				<!-- HR管理 -->
				<div class="model">
					<div class="model_left">HR管理</div>
					<div class="model_right">
					<c:forEach items="${HR}" var="HR">
						<div class="model_list">
							<div class="model_title"></div>
							<div class="onoff">
								<input type="checkbox" id="${HR}" name="check-box" value="on" isCheck="true" />
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
				<!-- 其他应用 -->
				<div class="model">
					<div class="model_left b_bottom" style="height:232px;line-height:232px;">其他应用</div>
					<div class="model_right">
					<c:forEach items="${other}" var="other">
						<div class="model_list">
							<div class="model_title_border"></div>
							<div class="onoff_border">
								<input type="checkbox" id="${other}" name="check-box" value="on" isCheck="true"/>
				                <div class="lcs_switch  lcs_on lcs_checkbox_switch">
				                    <div class="lcs_cursor"></div>
				                </div>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
			</div>
		</div>
		<div class="hidden">
			<c:forEach items="${map1}" var="map1">
				<span class="hidden_value" value="${map1.key }">${map1.value }</span>
			</c:forEach>
			<c:forEach items="${show}" var="show">
				<span class="hidden_value1" value="${show.key }">${show.value }</span>
			</c:forEach>
		</div>	
		</form>
	</div>
	<div class="footer">
	    <input id="okbt" type="button" class="common_button common_button_emphasize hand" value="提交" />&nbsp;&nbsp;<input id="cancelbt" type="button" class="common_button common_button_gray hand" value="取消" /></div>
	</div>
</body>
<script type="text/javascript">
$(".model_left").each(function(){
    if ($(this).hasClass("b_bottom")) {
    	$(this).height($(this).next().height() - 2);
    	$(this).css("line-height",$(this).height() +"px");
    }else{
    	$(this).height($(this).next().height());
    	$(this).css("line-height",$(this).height() +"px");
    };
});
var fManager = new functionalModuleManager();
$("#okbt").click(function(){
	var map="";
	for(var i = 0;i < $("input[name='check-box']").length;i++){
		var m="";
		var id=$("input[name='check-box']").eq(i).attr("id");
	    var value=$("input[name='check-box']").eq(i).attr("value");
	    if(i==$("input[name='check-box']").length-1){
	    	m='"'+id+'"'+':'+'"'+value+'"';
	    }else{
	    	m='"'+id+'"'+':'+'"'+value+'"'+",";
	    }
	    map=map+m;
		}
	   map="'"+"{"+map+'}'+"'";
	   var obj= jQuery.parseJSON(map);
		fManager.updateMenu(obj,{
		    success: function(memberBean) {
			      $.messageBox({
			        'title': "${ctp:i18n('common.prompt')}",
			        'type': 0,
			        'imgType':0,
			        'msg': "${ctp:i18n('organization.ok')}",
			        ok_fn: function() {
			        	window.location.href = window.location;
			        }
			      });
			      try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
			    }
			  });
	});
$("#cancelbt").click(function(){
	window.location.href = window.location;
});
var fDetail = fManager.showList();
$("#menuForm").fillform(fDetail);
</script>
</html>