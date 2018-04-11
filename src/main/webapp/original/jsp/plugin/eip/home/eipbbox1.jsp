<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 数据看板 显示块 ------>
<c:if test="${fn:contains(columnCodes, 'pl_databoard')}">
	<div class="s-n-l fl" style="margin-top: 35px;">
		<h1 id="pl_databoard_h1">
			
		</h1>
		<div id="pl_databoard" class="nt-content" style="margin-top: -20px;">
			
		</div>
	</div>
	<div class="s-m-r sm-til fr" style="height: 364px;margin-top: 35px;">
		<h1>
			通知公告 <a
				href="javascript:openUrl('${path}/bulData.do?method=bulIndex&typeId=${bulTypeId}&spaceType=&spaceId=')"
				class="more">更多 ></a>
		</h1>
		<ul class="snr-gg" id="bulsPortalList1"
			style="padding: 5px 16px 5px 16px;">
		</ul>
	</div>
</c:if>
<script type="text/javascript">
	function pl_databoard() {
		var columnCodes = "${columnCodes}";
		if (!(columnCodes.indexOf("pl_databoard") > -1)) {
			return;
		}
		var columnCode = "pl_databoard";
		var objParam = new Object();
		var isEnable = "0";
		var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable="
				+ isEnable
				+ "&columnCode="
				+ columnCode
				+ "&portalCode="
				+ encodeURI(encodeURI("${portalCode}"));
				$.ajax({
					url : url,
					data : '',
					type : "POST",
					async : true,
					dataType : 'text',
					success : function(result) {
						if (result) {
							result = $.parseJSON(result);
						}
						var postdetil = result;
						if (postdetil) {
							var html = new StringBuffer();
							var htmlh1 = new StringBuffer();
							for (var i = 0; i < postdetil.length; i++) {
								var url = postdetil[i].columnDetailName;
								if (!url || url == null || url == 'null'
										|| url == '#') {
									url = "#";
								}
								html.append("<div class=\"ntList nt\">");
								html
										.append("   <div style=\"background-color: #fff;width: 835px;height: 278px;padding: 20px 20px 20px 20px;\">");
								html
										.append("       <iframe frameborder=\"0\" width=\"100%\" height=\"100%\" display=\"black\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\" src=\""
												+ url + "\"></iframe>");
								html.append("   </div>");
								html.append("</div>");
								if (i == 0) {
									htmlh1.append("<div class=\"n1 nn act\">"
											+ postdetil[i].appSystemName
											+ "</div>");
								} else {
									htmlh1.append("<div class=\"n1 nn\">"
											+ postdetil[i].appSystemName
											+ "</div>");
								}
							}
							htmlh1.append("<div class=\"clear\"></div>");
							$("#pl_databoard").empty();
							$("#pl_databoard").append(html.toString());
							$("#pl_databoard_h1").empty();
							$("#pl_databoard_h1").append(htmlh1.toString());

						}
					}
				});
	}
	$(document).on("click",".nn",function(){
			var $this = $(this);
			if(!$this.is(".act")){
				var index = $this.index();
				$this.siblings(".act").removeClass("act");
				$this.addClass("act");
				var content = $this.parent().next(".nt-content");
				content.find(".nt").hide();
				content.find(".nt").eq(index).show();
				var more = $this.siblings(".more");
				more.find("a").hide();
				more.find("a").eq(index).show();
			}
		});
</script>