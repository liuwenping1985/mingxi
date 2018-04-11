<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('taskmanage.sortSetting.label') }</title>
</head>
<body class="font_size12">
    <div id="customer-order" class="customer-order" style="padding: 10px 20px;">
        <table class="customer-table" width="440" height="100%" border="0" cellpadding="0" cellspacing="0" class="font_size12 margin_t_5 margin_l_5">
            <tbody>
                <tr>
                    <td align="center" valign="middle" style="width: 100px">
                        <%-- 标题↑, 状态↑, 完成率↓, 开始时间↓, 结束时间↓, 重要程度↓, 风险↓ --%>
                        <select name="dataarea" id="leftupdataarea" size="16" class="input-100 margin_t_5" style="height: 240px;width: 100%;">
                            <option value="subject">${ctp:i18n("common.subject.label")}</option>
                            <option value="status">${ctp:i18n("common.state.label")}</option>
                            <option value="finishRate">${ctp:i18n("taskmanage.finishrate")}</option>
                            <option value="plannedStartTime">${ctp:i18n("taskmanage.starttime")}</option>
                            <option value="plannedEndTime">${ctp:i18n("common.date.endtime.label")}</option>
                            <option value="importantLevel">${ctp:i18n("common.importance.label")}</option>
                            <option value="riskLevel">${ctp:i18n("taskmanage.risk")}</option>
                        </select>
                    </td>
                    <td align="center" valign="middle" style="width: 30px">
                        <span id="add" class="ico16 select_selected"></span><br><br>
                        <span id="del" class="ico16 select_unselect"></span>
                    </td>
                    <td align="center" valign="middle" style="width: 100px">
                        <%-- 标题↑, 状态↑, 完成率↓, 开始时间↓, 结束时间↓, 重要程度↓, 风险↓ --%>
                        <select name="dataarea" id="rightupdataarea" size="16" class="input-100 margin_t_5" style="height: 240px;width: 100%;">
                        </select>
                    </td>
                    <td id="UpAndDown" align="center" valign="middle" style="width: 30px">  
                        <div>
                            <span id="up" class="ico16 sort_up"></span>
                            <br><br>
                            <span id="down" class="ico16 sort_down"></span>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div style="margin-top: 20px;">
            <span>${ctp:i18n('taskmanage.tips.label') }：</span><p>${ctp:i18n("taskmanage.tips.order") }</p>
        </div>
    </div>
</body>
<script type="text/javascript">
    var manager = new taskAjaxManager();
	$(function() {
		//栏直接返回的：plannedEndTime_asc,plannedStartTime_asc,createTime_asc
		var orders = window.parentDialogObj["openCustomerOrderPage"].getTransParams();
		orders = orders || "status_asc,plannedEndTime_asc";
		
		var $left = $("#leftupdataarea");
		var $right = $("#rightupdataarea");
		var slices = orders.split(",");
        for (var i = 0; i < slices.length; i++) {
            var option = slices[i].split("_"), $s = $left.find("option[value=" + option[0] + "]"), asc = option[1] == 'asc' ? '↑' : '↓';
            $('<option value="' + option[0] + '" order="' + option[1] +'">' + $s.text() + asc + '</option>').appendTo($right)
            $s.remove();
        }

		//左侧选择框双击事件
		$("#leftupdataarea").off("dblclick").on("dblclick", function() {
			addOrder();
		});
		//右侧选择框双击事件
		$("#rightupdataarea").off("dblclick").on("dblclick", function() {
			var $now = $("#rightupdataarea").find("option:selected"), text = $now.text().substr(0, $now.text().length - 1);
			var dialog = $.dialog({
				id : 'openSortPage',
				url : _ctxPath + '/taskmanage/taskinfo.do?method=openSortPage',
				width : 400,
				height : 200,
				//top : 150,
				title : '${ctp:i18n("common.toolbar.order.label")}',
				targetWindow : getCtpTop(),
				transParams : {
					text : text,
					order : $now.attr("order")
				},
				buttons : [ {
					id : "sure",
					text : $.i18n('common.button.ok.label'),
					isEmphasize : true,
					handler : function() {
						var order = dialog.getReturnValue();
						if ($now.attr("order") != order) {
							$now.attr("order", order).text(text + (order == 'asc' ? '↑' : '↓'));
						}
						dialog.close();
					}
				}, {
					id : "cancel",
					text : $.i18n('common.button.cancel.label'),
					handler : function() {
						dialog.close();
					}
				} ]
			});
		});
		$("#add").off("click").on("click", function() {
			addOrder();
		});
		$("#del").off("click").on("click", function() {
			delOrder();
		});

		$("#up").off("click").on("click", function(e) {
			var $now = $("#rightupdataarea").find("option:selected");
			$now.prev().insertAfter($now);
		});
		$("#down").off("click").on("click", function(e) {
			var $now = $("#rightupdataarea").find("option:selected");
			$now.next().insertBefore($now);
		});
	});

	/*删除排序*/
	function delOrder() {
		var $now = $("#rightupdataarea").find("option:selected");
		var text = $now.text();
		$('<option value="' + $now.val() + '">' + text.substr(0, text.length - 1) + '</option>').appendTo($("#leftupdataarea"))
		$now.remove();
	}

	/*新增排序*/
	function addOrder() {
		var $now = $("#leftupdataarea").find("option:selected");
		if ($now.length == 0) {
			return;
		}
		var dialog = $.dialog({
			id : 'openSortPage',
			url : _ctxPath + '/taskmanage/taskinfo.do?method=openSortPage',
			width : 400,
			height : 200,
			top : 150,
			title : '${ctp:i18n("common.toolbar.order.label")}',
			targetWindow : getCtpTop(),
			transParams : {
				text : $now.text()
			},
			buttons : [ {
				id : "sure",
				text : $.i18n('common.button.ok.label'),
				isEmphasize : true,
				handler : function() {
					var order = dialog.getReturnValue();
					if (order) {//可能排序窗口未加载完成就点击了此按钮，导致返回的值为空
						var asc = order == 'asc' ? '↑' : '↓';
						$('<option value="' + $now.val() + '" order="' + order + '">' + $now.text() + asc + '</option>').appendTo($("#rightupdataarea"));
						$now.remove();
						dialog.close();
					}
				}
			}, {
				id : "cancel",
				text : $.i18n('common.button.cancel.label'),
				handler : function() {
					dialog.close();
				}
			} ]
		});
	}

	/*dialog回调此方法*/
	function OK() {
		var ret = [];
		var checked = $("#rightupdataarea").find("option");
		if (checked.length != 0) {
			for (var i = 0; i < checked.length; i++) {
				var c = $(checked[i]);
				ret.push(c.val() + "_" + c.attr("order"));
			}
		}
		if ("${param.from}" == "section") {
			//栏目返回数组
			return [ ret ];
		} else {
			//列表返回数据
			return ret.join(",");
		}
	}
</script>
</html>