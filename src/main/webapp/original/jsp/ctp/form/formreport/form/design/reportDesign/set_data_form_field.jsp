<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="${url_ajax_reportDesignManager}"></script>
    <title>选择表单字段</title>
    <script type="text/javascript">
        //获取父窗口参数
        var parentPara = window.dialogArguments;
		var showDataList = parentPara.showDataList;

        $(function () {
            //定义左右选择面板
            var set = setBordFun(true, "", "", 200);

            $("#select_ico").click(function () {
                var returnValue = set.add();
                if (returnValue) {
                    var unselectObj = $("#unselect").find("option:selected");
                    unselectObj.each(function () {
                    	var title = $(this).attr("title");
                        var selectedObj = $("#selected option[title='" + title + "']");
                        selectedObj.text(title);
                    });
                }
            });
            $("#unselect_ico").click(function () {
                if(checkColumn()){
                	$("#selected").find("option:selected").each(function(){
                		var title = $(this).val();
                		$("#unselect").find("option").each(function(){
                			if(title == subName($(this).val())){
                				$(this).removeClass("color_gray");
                			}
                		});
						
					});
                    if($("#selected option").length>1){
                        set.remove();
                    }else {
                        $.alert("${ctp:i18n('report.queryReport.index_right.prompt.selectOne')}");
                    }
            	}
            });
            $("#sort_up").click(function () {
                set.moveT(set.removeObj);
            });
            $("#sort_down").click(function () {
                set.moveB(set.removeObj);
            });
            /**
             * 按enter键搜索 
             */
            $("#searchField").keyup(function(event) {
                if (event.keyCode == 13) {
                	searchField();
                }
            });
            //初始化表单数据域
            initShowData();
            //初始化已选择项
            initSelectedFields();
            //初始化双击事件
            initDbClick();
        });
        //截取字段名称前面的主表重表
        function subName(text){
            return text.substring(text.indexOf("]")+1);
        }
		//判断移除后还有统计项和公式列
		function checkColumn(){
			var hasUnselect = false;
			var hasColumnUnselect = false;
			var canRemove = true;
			
			$("#selected option:not(:selected)").each(function(){
				if($(this).attr("type") == "unselect"){
					hasUnselect = true;
				}else{
					hasColumnUnselect = true;
					for(var i=0;i<showDataList.length;i++){
						if($(this).val() == showDataList[i].title){
							var formulastr = showDataList[i].formula;
							$("#selected").find("option:selected").each(function(){
								var index = formulastr.indexOf("["+$(this).val()+"]");
								if(index != -1){
									canRemove = false;
								}
							});
						}
					}
				}
			});

            if($("#selected option:not(:selected)").length==0){
                $.alert("${ctp:i18n('report.queryReport.index_right.prompt.selectOne')}");
                return false;
            }
			//移除的统计项，设置在公式列的公式里面，不能移除
			if(!canRemove){
				$.alert("${ctp:i18n('report.reportDesign.set.canNotRemove')}");
				return false;
			}
			//在有列汇总公式列，而没有统计项的时候是不允许移除的
			if(hasColumnUnselect && !hasUnselect){
				$.alert("${ctp:i18n('report.reportDesign.set.canNotCovarianceItem')}");
				return false;
			}
				return true;
		}
        //初始化selected/unselect双击事件
        function initDbClick() {
        	$("#selected").dblclick(function () {
                $("#unselect_ico").trigger("click");
            });
            $("#unselect").dblclick(function () {
                $("#select_ico").trigger("click");
            });
        }
       
        // 向Select中填写数据
        function initShowData() {
        	var parentTitles = parentPara.titles.split(",");
        	 
            $("#unselect").empty(); // 填写之前先清空最初的数据
            for (var i = 0; i < showDataList.length; i++) {
                var showData = showDataList[i];
                type = isColumn(showData.code) ? "column":"unselect";
                
                var nameBefore = "${ctp:i18n('form.base.mastertable.label')}";
                if(showData.tableCode.indexOf("formson") != -1){
                	nameBefore = "${ctp:i18n('formoper.dupform.label')}";
                }
                
                if($.inArray(showData.title, parentTitles) == -1){
                	$("#unselect").append(
                        "<option title='" + showData.title +
                        "' type='" + type + "'>" +"["+nameBefore+"]"+ showData.title +
                        "</option>");
                }else{
                	$("#unselect").append(
                        "<option class='color_gray' title='" + showData.title +
                        "' type='" + type + "'>" +"["+nameBefore+"]"+ showData.title +
                        "</option>");
                }
            }
        }
  //是否是列汇总或公式列
  function isColumn(value){
  	if(value == "sum" || value == "count" || value == "avg" || value == "max" || value == "min" || value == "formula" ){
  		return true;
  	}
  	return false;
  }
        /**
         *isKeep    boolean 是否在备选中保留已选项
         *unselect  string  备选项ID
         *selected  string  已选项ID
         *maxLength number  最多选择个数
         */
        function setBordFun(isKeep, unselect, selected, maxLength) {
            var bord_ = new setBord({
                maxLength: maxLength,
                isKeep: isKeep,
                addObj: $("#unselect"),
                removeObj: $("#selected")
            });

            return bord_;
        }

        /*
         *进入页面，先判断父页面是否有数据,如果有则初始化选择列表
         */
        function initSelectedFields() {
            if (!$.isNull(parentPara.titles)) {
				var parentTitles = parentPara.titles.split(",");
				var parentTypes = parentPara.types.split(",");
				
				if ( parentTitles.length > 0) {
					for (var i = 0; i < parentTitles.length; i++) {
						$("#selected").append(
							"<option title='" + parentTitles[i] + "' value='" + parentTitles[i] +
							"' type='" + parentTypes[i] + "'>" + parentTitles[i]+
							"</option>");
					}
				}
            }
        }

        /*
         *父子界面交互方法，return值能在父页面获得
         */
        function OK(parms) {
            var returnObj = new Object();
            var titles = "";
            var types = "";
           
			$("#selected option").each(function () {
				titles = union(titles, $(this).attr("title"));
				types = union(types, $(this).attr("type"));
			});

			returnObj.titles = titles;
			returnObj.types = types;
			return returnObj;
            
        }
        //返回值拼接，以“,”隔开的字符串
        function union(_self, _new) {
            (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
            return _self;
        }
        /**
         *根据输入条件搜寻字段
         */
        function searchField() {
            var searchValue = $("#searchField").val();
            var formFileds = $("#unselect option");
            var len = formFileds.length;
            $("#unselect").children("span").each(function () {
                $(this).children().clone().replaceAll($(this));
            });
            for (var i = 0; i < len; i++) {
                var filed = formFileds[i];
                if ($(filed).text().indexOf(searchValue) === -1) {
                    $("#unselect option").eq(i).each(function () {
                        $(this).wrap("<span style='display:none'></span>");
                    });
                }
            }
        }
    </script>
</head>
<body class="h100b">
	<div id="div_selectField" class="align_left" style="width:540px; padding:0px 20px;background:#fafafa;">
    <table border="0" cellpadding="0" cellspacing="0" align="center" class="font_size12">
        <tr>
            <td class="margin_t_5>
                <p class="font_size12 margin_b_5 margin_t_10">
                    <span class="left">${ctp:i18n('report.reportDesign.dialog.formdatadomain')}:
                    <input class="comp" id="searchField" name="name" value="" type="text" comp="type:'search',fun:'searchField',title:'查询数据域'" style="width: 180px;" /></span>
                </p>
            </td>
            <td></td>
            <td colspan="2">
	           <p class="font_size12 margin_b_5 margin_t_10">${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}:</p>
            </td>
        </tr>
        <tr>
            <td valign="top" width="260">
                <select class="font_size12" style="width:250px; height: 340px;" id="unselect" size="20" multiple></select>
            </td>
            <td valign="middle" align="center" class="padding_lr_5">
	            <span class="select_selected hand" id="select_ico"></span><br><br>
	            <span class="select_unselect hand" id="unselect_ico"></span>
            </td>
            <td align="top">
	            <select class="font_size12"style="width:220px; height: 340px;" multiple size="20" id="selected"></select>
            </td>
            <td valign="middle" align="center" class="padding_l_5">
	            <span class="sort_up hand" id="sort_up"></span><br><br>
				<span class="sort_down hand" id="sort_down"></span>
            </td>
        </tr>
    </table>
</body>
</html>
