// js开始处理
var bookMap = new Properties();
$(function() {
	var bookIds = window.parentDialogObj['bookUseView'].getTransParams();
    var ajaxM = new bookApplyManager();
    var ajaxTestBean = new Object();
    ajaxTestBean.ids = bookIds;
    ajaxM.findBookByIds(ajaxTestBean, {
        success: function(fpi){
        	for (var i = 0 ; i < fpi.length ; i ++) {
        		var bookInfo = fpi[i];
        		bookMap.put(bookInfo.id,bookInfo);
        	}
            fnCreateTable(bookMap.values());
        }
    });
});




/**
 * 查询时间校验
 */
function TimeVer() {
  var recordDate0 = fnDateParse($('#recordDate0').val());
  var recordDate1 = fnDateParse($('#recordDate1').val());
  if (recordDate0 > recordDate1) {
    $.alert($.i18n('office.book.bookBorrow.jsrqbnzyksrq.js'));
    return true;
  }else{
    return false;
  }
}  
/**
 * 生成table
 * @param obj
 */
function fnCreateTable(obj) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;border-left-color:white;table-layout:fixed'>";
	tableHtml += '<thead>';
	tableHtml += '<tr>';
	tableHtml += fnCrateTh('',10);
	tableHtml += fnCrateTh($.i18n('office.auto.bookStcInfo.bh.js'),90);
	tableHtml += fnCrateTh($.i18n('office.auto.bookStcInfo.mc.js'),90);
	tableHtml += fnCrateTh($.i18n('office.auto.bookStcInfo.lb.js'),70);
	tableHtml += fnCrateTh($.i18n('office.book.bookStcInfoShow.tsk.js'),50);
	tableHtml += fnCrateTh($.i18n('office.book.bookBorrow.ssfl.js'),50);
	tableHtml += fnCrateTh($.i18n('office.book.bookBorrow.dqkc.js'),50);
	tableHtml += fnCrateTh($.i18n('office.book.bookStcInfoShow.jysl.js'),70);
	tableHtml += fnCrateTh($.i18n('office.book.bookBorrow.bz.js'),160);
	tableHtml += fnCrateTh('',30);
	tableHtml += "</tr>";
	tableHtml += "</thead>";
	tableHtml += "<tbody>";
	for (var i = 0 ; i < obj.size() ; i ++) {
		var bookInfo = obj.get(i);
		tableHtml +="<tr>";
		var bookNumId = bookInfo.id + "_Num";
		var bookDescId = bookInfo.id + "_Desc";
		var bookNum = bookInfo.applyTotal != undefined ? bookInfo.applyTotal : "";
		var bookDesc = bookInfo.applyDesc != undefined ? bookInfo.applyDesc : "";
		tableHtml +=fnCreateTd({"showValue":i+1,"type":"text","width":10});
		tableHtml +=fnCreateTd({"showValue":bookInfo.bookNum,"type":"text","width":90});
		tableHtml +=fnCreateTd({"showValue":bookInfo.bookName,"type":"text","width":90});
		tableHtml +=fnCreateTd({"showValue":bookInfo.bookType_txt,"type":"text","width":70});
		tableHtml +=fnCreateTd({"showValue":bookInfo.houseName,"type":"text","width":50});
		tableHtml +=fnCreateTd({"showValue":bookInfo.bookCategoryStr,"type":"text","width":50});
		tableHtml +=fnCreateTd({"showValue":bookInfo.bookCount,"type":"text","width":50});
		tableHtml +=fnCreateTd({"showValue":bookNum,"type":"input","objid":bookNumId,"maxSize":9,"maxLength":9,"width":70});
		tableHtml +=fnCreateTd({"showValue":bookDesc,"type":"input","objid":bookDescId,"maxSize":25,"maxLength":30,"width":160});
		tableHtml +=fnCreateTd({"showValue":$.i18n('office.book.bookBorrow.sc.js'),"type":"link","linked":"deleteBooK("+bookInfo.id+")","width":30});
		tableHtml +="</tr>";
	}
	tableHtml += "</tbody>";
	tableHtml += "</table>";
	$('#queryResult').html(tableHtml);
}
/*
 * 更具值生成指定的th
 */
function fnCrateTh (showText,widthCss) {
	var thThml = "";
	thThml += '<th align="center" width="'+widthCss+'" abbr="stockHouseName" axis="col1" colmode="stockHouseName" sorttype="string" istogglehideshow="false">';
	thThml += '<div style="width: '+widthCss+'px; text-align: center;">'+showText+'</div></th>';
	return thThml;
}
/*
 * 更具类型和值生成指定的td
 */
function fnCreateTd(options) {
	var showValue = options.showValue != undefined ? options.showValue : "";
	var type = options.type != undefined ? options.type : ""; 
	var linked = options.linked != undefined ? options.linked : "";
	var objid = options.objid != undefined ? options.objid : "";
	var maxSize = options.maxSize != undefined ? options.maxSize : "";
	var maxLength = options.maxLength != undefined ? options.maxLength : "";
	var width = options.width != undefined ? options.width : "";
	var tdHtml = "";
	if (type == 'text') {
		tdHtml +="<td align='center' width='"+width+"' title='"+showValue+"' id='"+objid+"'  style='text-align:left;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;word-break:keep-all'>"+showValue+"</td>";
	} else if (type == 'input'){
		tdHtml +="<td align='center' width='"+width+"' style='text-align:left;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;word-break:keep-all'><input id='"+objid+"' type='input' value='"+showValue+"' size='"+maxSize+"' maxlength='"+maxLength+"'/></td>";
	} else {
		tdHtml +="<td align='center' width='"+width+"' style='text-align:left;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;word-break:keep-all'><a style='color:blue;' id='"+objid+"' onclick='"+linked+"'>"+showValue+"</a></td>";
	}
	return tdHtml;
		
}

function deleteBooK(obj) {
	var bookIds = bookMap.keys();
	if (bookIds.size() < 2) {
		$.alert($.i18n('office.book.bookBorrow.bxblyttsjl.js'));
		return ;
	}
	//在remove之前获取之前所有输入的数量和备注
	for (var i = 0 ; i < bookIds.size() ; i ++ ) {
		var bookId = bookIds.get(i);
		var Num = $('#'+bookId+'_Num').val();
		var Desc = $('#'+bookId+'_Desc').val();
		var bookObj = bookMap.get(bookId);
		bookObj.applyTotal = Num;
		bookObj.applyDesc = Desc;
		bookMap.put(bookId,bookObj);
	}
	bookMap.remove(obj);
	fnCreateTable(bookMap.values());
}

function OK () {
	var bookApplys = new ArrayList();
	var bookIds = bookMap.keys();
	var reg =/^[0-9]{1,9}$/;
	for (var i = 0 ; i < bookIds.size() ; i ++ ) {
		var bookObj = new Object();
		var bookId = bookIds.get(i);
		var Num = $('#'+bookId+'_Num').val();
		var Desc = $('#'+bookId+'_Desc').val();
		var realNum = $('#'+bookId+'_Num').parent().prev().attr("title");
		var book = bookMap.get(bookId);
		if (Num == '' || Num == '0') {
			$.alert($.i18n('office.book.bookBorrow.tszldsqslwlhkqzxtx.js',book.bookName));
			return null;
		}
		if (!fnCheckNum(Num) || !reg.test(Num)) {
			$.alert($.i18n('office.book.bookBorrow.tszldsqslbhfqzxtx.js',book.bookName));
			return null;
		}
		if (Num>10) {
			$.alert($.i18n('office.book.bookBorrow.ycxzyxjybtszltsdsqslbhfqzxtxhjy.js',book.bookName));
			return null;
		}
		bookObj.bookId = bookId;
		bookObj.applyTotal = Num;
		bookObj.applyDesc = Desc;
		bookObj.realNum = realNum;
		bookObj.bookName = book.bookName;
		bookApplys.add(bookObj);
	}
	return  bookApplys.toArray();
}


function fnCheckNum (num) {
	var reg1 =  /^\d+$/;
	if (num.match(reg1) == null) {
		return false;
	}
	return true;
}
