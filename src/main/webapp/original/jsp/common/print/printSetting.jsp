<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
 <head id='linkList'>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <!--签章控件需要在IE9模式下才能显示  -->
        
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
        <title>print</title>
       <%@ include file="/WEB-INF/jsp/common/common.jsp"%>
		<script type="text/javascript">
		    if($.ctx.CurrentUser == null){
		        $.ctx.CurrentUser = opener.$.ctx.CurrentUser;
		    }
		</script>

		<script src="${path}/apps_res/print/js/LodopFuncs.js"></script>
		<script src="${path}/apps_res/print/js/printerControl.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/print/css/style.css">

</head>
<body style="padding-left: 50px;">
    <div class="col-12">
        <label class="head">打印机设置</label><br>
        <div class="col-6">
            <label for="selectPrinter">选择打印机</label><br>
            <select class="full-width" id="selectPrinter"></select>
        </div>
        <div class="col-6">
            <label for="numCopy">打印份数</label> <br>
            <input type="text" id="numCopy">
        </div>
    </div>

    <div class="col-12">
        <br>
    </div>

	<div class="col-12">
		<label class="head">纸张选项</label> <br>
		<div class = "col-6">
			<label for="pageSize">纸张大小</label> <br>
			<select class="full-width" id="pageSize"></select>

            <form id="pageOrientation">
			<input type="radio" name="pageOrientation" id="horizontal" value="horizontal"> <label for="horizontal">横向</label>
			<input type="radio" name="pageOrientation" id="vertical" value="vertical"> <label for="vertical">纵向</label>
            </form>

			<input type="checkbox" id="printBackground"> <label for="printBackground">打印背景颜色和图像</label>
			<br>
			<input type="checkbox" id="shrinkOverflow" checked> <label for="shrinkOverflow">启用收缩到纸张大小</label>
		</div>

        <div class="col-6">
            <label>页边距（毫米）</label> <br>
            <div class="edge">
                <label for="edgeLeft">左(L):</label> <input type="text" id="edgeLeft"> <br>
                <label for="edgeRight">右(R):</label> <input type="text" id="edgeRight"> <br>
                <label for="edgeTop">上(T):</label> <input type="text" id="edgeTop"> <br>
                <label for="edgeBottom">下(B):</label> <input type="text" id="edgeBottom">
            </div>
        </div>
    </div>

	<div class="col-12">
	<br> 
	</div>

	<div class="col-12">
		<label class="head">页眉与页脚</label> <br>
		<div class="col-6">
			<label>页眉(H):</label> <br>
			<select id="h1" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select> <br>
			<select id="h2" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select> <br>
			<select id="h3" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select>
		</div>
		<div class="col-6">
			<label>页脚(F):</label> <br>
			<select id="f1" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select> <br>
			<select id="f2" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select> <br>
			<select id="f3" class="full-width">
                <option value="empty">-空-</option>
                <option value="title">标题</option>
                <option value="url">URL</option>
                <option value="pageNumber">页码</option>
                <option value="pageNumberAndTotalPageNumber">总页数第#页</option>
                <option value="totalPageNumber">总页数</option>
                <option value="shortDate">短格式日期</option>
                <option value="longDate">长格式日期</option>
                <option value="timeIn12h">时间</option>
                <option value="timeIn24h">采用24小时制的时间</option>
			</select>
		</div>
	</div>

	<div class="col-12">
	<br> 
	</div>

    <div class="col-12">
        <div class="col-6">
            <label for="shrinkPercentage">缩放大小</label> <br>
            <select class="full-width" id="shrinkPercentage">
                <option value="50%">50%</option>
                <option value="60%">60%</option>
                <option value="70%">70%</option>
                <option value="80%">80%</option>
                <option value="90%">90%</option>
                <option value="100%">100%</option>
                <option value="110%">110%</option>
                <option value="120%">120%</option>
                <option value="130%">130%</option>
                <option value="140%">140%</option>
				<option value="150%">150%</option>
				<option value="200%">200%</option>
                <option value="400%">400%</option>
                <!--More options can be provided by simply add an option element here, and the shrinkPercentage can range from 5% to 800%-->
                <!-- <option value="800">800%</option> -->
            </select>
        </div>
    </div>

    <div class="col-12">
        <br>
    </div>

    <div class="col-12">
        
            <input type="button" width="80px;" value="确认" onclick="formToObject()">
        
            <input type="button" width="80px;" value="取消" onclick="window.close()">
       
    </div>

	<script type="text/javascript">
        var printer = getLodop();

        $("document").ready(setPrinter())
                     .ready(setPageSize())
                     .ready(objectToForm());

        $("#selectPrinter").change(function(){setPageSize()});

        function setPageSize() {
            var availablePageSizeList = printer.GET_PAGESIZES_LIST(parseInt($("#selectPrinter").val()), "\n").split("\n");
            var $pageSize = $("#pageSize");
            $pageSize.empty();
            $.each(availablePageSizeList, function (i, item) {
                $pageSize.append($("<option>", {
                    value: item, text : item
                }));
            });
        }

        function setPrinter() {
            var printerCount = printer.GET_PRINTER_COUNT();
            var defaultPrinterName = printer.GET_PRINTER_NAME(-1);
            var defaultPrinterIndex = -1;
            var $selectPrinter = $("#selectPrinter");

            for(var i = 0; i < printerCount; i++) {
                var option = document.createElement('option');
                option.innerHTML = printer.GET_PRINTER_NAME(i);
                option.value = i;
                if (option.innerHTML === defaultPrinterName) {
                    defaultPrinterIndex = i;
                }
                $selectPrinter.append(option);
            }
            $selectPrinter.val(defaultPrinterIndex.toString());
        }

        function objectToForm() {
            var setting = window.opener.setting;
            $("#pageSize").val(setting.pageSize);
            $("input[name=pageOrientation]").val([setting.pageOrientation]);
            $("#printBackground").prop("checked", setting.printBackground);
            $("#shrinkOverflow").prop("checked", setting.shrinkOverflow);
            $("#shrinkPercentage").val(setting.shrinkPercentage);
            $("#edgeLeft").val(setting.edgeLeft);
            $("#edgeRight").val(setting.edgeRight);
            $("#edgeTop").val(setting.edgeTop);
            $("#edgeBottom").val(setting.edgeBottom);
			$("#numCopy").val(setting.numCopy);
            $("#selectPrinter").val(setting.printer);
            $("#h1").val(setting.h1);
            $("#h2").val(setting.h2);
            $("#h3").val(setting.h3);
            $("#f1").val(setting.f1);
            $("#f2").val(setting.f2);
            $("#f3").val(setting.f3);
            $.post("whatever_url", setting);
        }

		function formToObject() {
            var setting = window.opener.setting;
            setting.pageSize = $("#pageSize").val();
            setting.pageOrientation = $("input[name=pageOrientation]:checked").val();
            setting.printBackground = $("#printBackground").prop("checked");
            setting.shrinkOverflow = $("#shrinkPage").prop("checked");
            setting.shrinkPercentage = $("#shrinkPercentage").val();
            setting.edgeLeft = $("#edgeLeft").val();
            setting.edgeRight = $("#edgeRight").val();
            setting.edgeTop = $("#edgeTop").val();
            setting.edgeBottom = $("#edgeBottom").val();
            setting.numCopy = $("#numCopy").val();
            setting.printer = $("#selectPrinter").val();
            setting.h1 = $("#h1").val();
            setting.h2 = $("#h2").val();
            setting.h3 = $("#h3").val();
            setting.f1 = $("#f1").val();
            setting.f2 = $("#f2").val();
            setting.f3 = $("#f3").val();
            //window.opener.debug();
            new ctpUserPreferenceManager().savePrintPreference(${moduleId},JSON.stringify(setting, null, 4));
           // alert(JSON.stringify(setting, null, 4));
            window.close();
		}
	</script>
</body>
</html>