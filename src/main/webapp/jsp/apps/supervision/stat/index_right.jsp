<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n("report.queryReport.tree.formReport")}</title>
<script type="text/javascript">
 
	//初始JS
	$(document).ready(function() {
		//如果是督办空间,默认选中交办单位统计
		if(window.parent.location.href.indexOf("F20_SuperviseStaffSpace") != -1){
			$("input[name=tjfw]:eq(1)").click();
			$("#departmentText").show();
		}
		initPage();
		initPageDisplay();
	    addButtonEvent();
		$("input[name=tjfw]").click(function(){
			var _this = $(this);
			if(_this.val() == 2){
				$("#departmentText").show();
			}else{
				$("#departmentText").hide();
			}
		});
		$("#excQuery").click(function(){
		      $("#previewDiv").addClass("hidden");
		      search();
		  });
		
		//重置
		  $("#conditionReset").click(function(){
		  	  //重置统计设置	
			$("#fromdate").val('${fromDate}');
			$("#todate").val('${toDate}');
			//如果是督办空间,默认选中交办单位统计
			if(window.parent.location.href.indexOf("F20_SuperviseStaffSpace") != -1){
				$("input[name=tjfw]:eq(1)").click();
			}else{
				$("input[name=tjfw]").eq(0).click();
			}
			$("input[name=blxz]").eq(0).attr("checked","checked");
			$("input[name=blxz]").eq(1).attr("checked","checked");
			$("input[name=sxzt]").eq(0).attr("checked","checked");
			$("input[name=sxzt]").eq(1).attr("checked","checked");
			$("#departmentText").val('');
			$("#departmentValue").val('');
		  });
	
	});

	function initPageDisplay() {
		$("#searchResultDiv").show();
		search();
	}

	function initPage() {
		var decentHeight = 130;
		var heitht = 198;
		var layout = new MxtLayout({
			'id' : 'layout',
			'northArea' : {
				'id' : 'north',
				'height' : heitht,
				'sprit' : true,
				'maxHeight' : 250,
				'minHeight' : 0,
				'border' : true,
				'spritBar' : true,
				spiretBar : {
					show : true,
					handlerB : function() {
						layout.setNorth(200);
						search();
						resizeQueryHeight();
					},
					handlerT : function() {
						search();
						layout.setNorth(0);
					}
				}
			},
			'centerArea' : {
				'id' : 'center',
				'border' : true,
				'minHeight' : 20
			}
		});
		$("#layout").attrObj("_layout", layout);
	}

	function search() {
		if (!$("#previewDiv").hasClass("hidden")) {
			return false;
		}
		 var beginDate = $("#fromdate").attr("value");//初始日期 string
		 var endDate = $("#todate").attr("value");//结束日期 string
		if(beginDate==""){
			alert("开始日期不能为空");
			return;
		}
		if(endDate==""){
			alert("结束日期不能为空");
			return;
		}
		if($('input[name=blxz]:checked').length == 0){
			alert("请至少选择一种办理性质");
			return;
		}
		if($('input[name=sxzt]').length > 0 && $('input[name=sxzt]:checked').length == 0){
			alert("请至少选择一种事项状态");
			return;
		}
		if(endDate<beginDate){
			alert("开始日期不能大于结束日期");
			return;
		}
		$("#contentForm").submit();
		$("#searchResultDiv").show();
		addButtonEvent();
		//OA-63796
		$("#excQuery").focus();
	}
	
	function chooseDepartment(){
		var param = new Object();
		param.text = $("#departmentText").val();
		param.value = $("#departmentValue").val();
		param.elements = [];
		$.selectPeople({
	        panels: 'Account,Department,OrgTeam,ExchangeAccount',
	        selectType: 'Account,Department,OrgTeam,ExchangeAccount',
	        params:param,
	        showFlowTypeRadio : false,
	        isNeedCheckLevelScope:false,
	        hiddenPostOfDepartment:true,
            showAllOuterDepartment:true,
            isCheckInclusionRelations:false,
            isMultipleAccountAndDepartment:true,
	        minSize:0,
	        callback : function(ret) {
	        	$("#departmentText").val(ret.text);
	            $("#departmentValue").val(ret.value);
	        }
	      });
	}
	function dataLoad(){ // 用户点击统计后，再点击回退，页面不显示
    	try{
    		var data = $("#content")[0];
    		if(data.contentWindow.location.href){}
    	}catch(e){
    		$("#excQuery").click();
    	}
    }
	
	//重新计算查询页面的高度
	  //为了多处用到  先封装成一个方法
	  function resizeQueryHeight(){
	  	decentHeight = $("#center").height() - $("#result").height();
	      $("#result").attr("_decentHeight", decentHeight);
	      adjustQueryHeight();
	  }
	  var _decentFieldsetDivHeight = 0;
	  function adjustQueryHeight() {
	  	var conditionHeight = $("body")[0].scrollHeight - 220;//220是查询结果的最小高度 保证能看到table
	    if($("fieldset").length == 0 || $($("fieldset")[0]).children("div").length == 0)
	      return;
	    if(_decentFieldsetDivHeight <= 0) {//OA-43270
	      _decentFieldsetDivHeight = $("#north").height() - $($("fieldset")[0]).children("div").height();
	    //  return;
	    }
	    $($("fieldset")[0]).children("div").height(0);
	    var h = $($("fieldset")[0]).children("div")[0].scrollHeight;
	    //自定义查询模式链接显示的时候增加高度
	    var flag = $('#moduleTr').css('display') !== 'none';
	    var moduleHeight = 0;
	    if(flag){
	        moduleHeight = $('#moduleTr').height()
	    }
	    var sh = h;
	    if(h + _decentFieldsetDivHeight > conditionHeight)
	      h = conditionHeight - _decentFieldsetDivHeight;
	    else if(h < 70)
	      h = 70;
	    $("#layout").layout().setNorth(h + _decentFieldsetDivHeight+moduleHeight);
	    $($("fieldset")[0]).children("div").height(h);
	    if($("table.flexme1").length == 1 && $("table.flexme1")[0].grid!=null) {
	      var th = $("#center").height(), _decentHeight = $($("table.flexme1").ajaxgrid()).attr("_decentHeight");
	      if($.browser.msie&&parseInt($.browser.version,10)==7){
	          //OA-46863  IE7下可能是组件有问题，没计算一次，center区域的高度变小1px，此处做特殊处理。
	          try{
	  			th = th+1;
	  			$("#center").height(th);
	  			var top = $("#center")[0].currentStyle.top;
	  			top = top.substring(0,top.indexOf("px"));
	  			top = parseInt(top)-1;
	  			$("#center").css("top",top+"px");
	  			$("#northSp_layout").css("top",top-6+"px");
	          }catch(e){}
	      }
	      $("table.flexme1").ajaxgrid().grid.resizeGrid(th-(_decentHeight?_decentHeight:130));
	    }
	  };
</script>

</head>
<body class="h100b overflow_hidden page_color" id="layout">
	<div id="myQueryTable" class="hidden">
		<table height="110px">
			<tr>
				<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('report.queryReport.index_right.myReport')}:</label></th>
				<td width="100%">
					<div>
						<input type="text"
							validate="type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\\\&#39;&quot;&lt;&gt;!,@#$%&*()',maxLength:85"
							class="validate" name="name" id="name" value="${reportSave.name}" />
						<input type="hidden" id="rSid" value="$"> <input
							type="hidden" id="rportname" value="">
					</div>
				</td>
			</tr>
		</table>
	</div>
	<form action="#" id="queryConditionForm" method="post" target="main">
		<div id="baseInfo" class="hidden">
			<input id="type" value=""> <input type="hidden" id="reportId"
				value="" /> <input type="hidden" id="formid" value=""> <input
				type="hidden" id="formType" value="">
		</div>
	</form>
	<div class="layout_north " id="north">
		<div class="form_area set_search padding_b_10  margin_5">
			${ctp:i18n('report.queryReport.index_right_grid.statisticConditions')}:
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				align="center" id="allDataTable">
				<tr>
					<td><div class="align_right" id="mode_set_link_div"></div></td>
					<td></td>
				</tr>
				<tr>
					<td valign="top">
						<fieldset class="fieldset_box margin_t_5">
							<legend>${ctp:i18n('report.queryReport.index_right.inputStatCondition')}:</legend>
							<form id="contentForm" enctype="multipart/form-data"
								method="post" target="content"
								action="${path}/supervision/supervisionStatController.do?method=stat&type=${type}">
								<div style="height: 80px; overflow: auto;">
									开始日期: <input id="fromdate" name="fromdate" type="text"
										value="${fromDate }" class="comp"
										comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly/>
									结束日期： <input id="todate" name="todate" type="text"
										value="${toDate }" class="comp"
										comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;统计范围：<label> <input
										name="tjfw" type="radio" value="1" checked />本单位办理
									</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><input
										name="tjfw" type="radio" value="2" />本单位交办</label>&nbsp;&nbsp;&nbsp;&nbsp;<input
										type="text" readonly id="departmentText" name="departmentText"
										onclick="chooseDepartment()" style="display: none;" /> <input
										type="hidden" id="departmentValue" name="departmentValue">
									</br> </br> </br>
									<c:if test="${type != 2 }">
									 事项状态：<label><input name="sxzt" type="checkbox"
											value="1" checked />进行中</label>
										</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<label><input name="sxzt" type="checkbox" value="2"
											checked />已销账</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</c:if>
									办理性质：<label><input name="blxz" type="checkbox"
										value="1" checked />责任</label> </label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label><input
										name="blxz" type="checkbox" value="2" checked />协办</label>
								</div>
							</form>
						</fieldset>
					</td>
				</tr>
			</table>
			<div class="align_center clear margin_t_5">
				<a class="common_button margin_r_10" href="javascript:void(0)"
					id="excQuery">${ctp:i18n('report.queryReport.index_right.button.excQuery')}</a>
				<!-- 统计 -->
				<a class="common_button margin_r_10" href="javascript:void(0)"
					id="conditionReset">${ctp:i18n('report.queryReport.index_right.button.conditionReset')}</a>
				<!-- 重置 -->
			</div>
		</div>
	</div>

	<!--查询设置end-->
	<div class="layout_center stadic_layout over_hidden" id="center">
		<div class="stadic_layout w100b h100b hidden"
			style="*position: absolute;" id="searchResultDiv">
			<div id="gridOrChart" class="common_toolbar_box">
				<div class="padding_lr_10  set_search align_left">
					<span>
						${ctp:i18n('report.queryReport.index_right.statResult.title')}：<!-- 统计结果 -->
					</span> <span> <a class="img-button margin_r_5" href="#"
						id="leadingOut"> <em class="ico16 export_excel_16"></em>${ctp:i18n('report.queryReport.index_right.toolbar.leadingOut')}
					</a> <!-- 导出Excel --> <a class="img-button margin_r_5" href="#"
						id="print"> <em class="ico16 print_16"></em>${ctp:i18n('report.queryReport.index_right.toolbar.print')}
					</a> <!-- 打印 -->
					</span>
				</div>
				<div
					class="common_tabs clearfix stadic_layout_head stadic_head_height">
					<span class="left margin_b_10">
						<li id="gridLi" class="current"><a hideFocus
							style="WIDTH: auto" class="last_tab" href="javascript:void(0)">
								${ctp:i18n('report.queryReport.index_right.statResult.grid')}</a></li> <!-- 表格 -->
					</span>
				</div>
			</div>
			<div id="result"
				class="align_center border_t common_tabs_body stadic_layout_body stadic_body_top_bottom"
				style="top: 45px; bottom: 0px; background: #fff; overflow: hidden;">
				<div id="gridDiv" class="absolute h100b" width="100%" height="100%"
					style="top: 0px; bottom: 0px; left: 0; right: 0; background: #fff;">
					<iframe id="content" onload="dataLoad();" name="content"
						frameborder="0" src="" width="100%" height="100%"></iframe>
				</div>
			</div>
		</div>
		<div id="previewDiv"
			class="hidden h100b stadic_layout_body stadic_body_top_bottom"
			style="overflow-y: hidden;">
			<fieldset id="showTable" class="bg_color_white">
				<legend>
					<span class="ico16 preview_16"></span><span style="color: blue">${ctp:i18n('report.reportDesign.preview')}</span>
				</legend>
				<iframe id="preview" frameborder="0" src="" width="100%"
					height="95%"></iframe>
			</fieldset>
		</div>
	</div>
	<script type="text/javascript">
    function addButtonEvent() {
        $("#leadingOut,#print,#synergy,#selctChart,#exitDee").removeAttr("disabled");
        $('#leadingOut,#print,#synergy,#selctChart,#exitDee').unbind("click");
        $("#leadingOut").unbind("click").bind("click").click(function() {
        	if($("#content").contents().find("#reportName").html() == undefined){
        		$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
        		return false;
        	}
        	$("#contentForm").attr("action",_ctxPath+"/supervision/supervisionStatController.do?method=exportToExcel&type=${type}");
        	$("#contentForm").submit();
        	$("#contentForm").attr("action",_ctxPath+"/supervision/supervisionStatController.do?method=stat&type=${type}");
    	
        });
        $("#print").unbind("click").bind("click").click(function() {
            var iframeobj = $("#content").contents();//获得iframe对象
            var contentHtml = iframeobj.find("#context").html();
            var printSubject ="";
            //OA-52486表单统计结果打印，左边的框线丢失
            iframeobj.find("#ftable").attr("style","border-left: display");
            var printsub = iframeobj.find("#reportName").html();
            if(printsub == undefined){
            	$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
            }else{
            	printsub = "<center><hr style='height:1px' class='Noprint'&lgt;</hr><span style='font-size:24px;line-height:24px;'>"+printsub+"</span></center>";
				//打印时将标题和正文合并到一起  如果页面只有一个对象则可以出滚动条
				var colBodyFrag = new PrintFragment("", contentHtml);         
				var cssList = new ArrayList();
				cssList.add("<c:url value="/apps_res/supervision/css/stat2.css" />");
				var pl = new ArrayList();
				//pl.add(printSubFrag);
				pl.add(colBodyFrag);
				printList(pl,cssList);
				//OA-52486表单统计结果打印，左边的框线丢失
				iframeobj.find("#ftable").attr("style","border-left: none");
				//iframeobj.find("#context").html(contentHtml);
            }
            
        });
    }
    </script>
</body>
</html>
