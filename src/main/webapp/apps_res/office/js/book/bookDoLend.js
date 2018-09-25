$(function(){
	//选择图书
	$("#selectBook").click(fnSelectBook);
	// 列表table初始化
	pTemp.tab = officeTab().addAll([ "id", "bookNum", "bookName","bookType_txt", "houseName", "bookCount","lendSum", "memo","operat"]).init("bookDoLendTab", {
        argFunc : "fnBookInfoItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false, //上下收缩按钮是否显示
        resizable : false,//明细页面的分隔条
        render:fnOperatRender,
        usepager: false,
        "managerName" : "bookInfoManager",
        "managerMethod" : "findBooksByIds"
   });
	pTemp.editTab = $("#bookDoLendTab");
	//选择人员 [回调方式]
	$("#applyUser_txt").click(function(){
		$.selectPeople({
			type : 'selectPeople',
			panels : "Department,Team,Post,Level",
			selectType :  "Member",
			onlyLoginAccount : false,
			isNeedCheckLevelScope:false,
			hiddenPostOfDepartment:true,
			maxSize: 1,
			params : {
			      text : $("#applyUser_txt").val(),
			      value : $("#applyUser").val()
			    },
			callback : function(ret) {
				$("#applyUser_txt").val(ret.text);
				$("#applyUser").val(ret.value);
				if(pTemp.tab.datas()){
					var rows = pTemp.tab.datas().rows;
					for(var i=0;i<rows.length;i++){
						pTemp.tab.removeRow(rows[i].id);
					}
				}
			}
	    });
	});
});

/**
 * 选择当前管理员管理的图书
 */
function fnSelectBook(){
	var toPerson = $("#applyUser").val();
	//回填
	var rows = pTemp.tab.datas();
	var tranVal = {toPerson:toPerson,rows:rows};
	if(toPerson == ""){
		$.alert($.i18n("office.bookapply.dolend.selectpeoson.js"));
		return;
	}
	var doLendDialog = $.dialog({
		id : 'sBook',
		url : _path+'/office/bookUse.do?method=selectBook',
		width : 860,
		height : 500,
		title : $.i18n('office.book.bookHouseEdit.ptszlk.js'),
		targetWindow : getCtpTop(),
		transParams : tranVal,
		buttons: [{
	    	id : "sure",
	    	isEmphasize:true,
	    	text : $.i18n('calendar.sure'),
	        handler : function() {
	        	var ids = doLendDialog.getReturnValue();
	        	pTemp.tab.load({id:ids});
	        	doLendDialog.close();
	        }
	    }, {
	    	id : "cancel",
	    	text : $.i18n('calendar.cancel'),
	        handler : function() {doLendDialog.close();}
	    }]
	});
}

function fnBookInfoItems(){
	  return {
	        "id" : {
	            display : 'id',
	            name : 'id',
	            width : "5%",
	            sortable : false,
	            align : 'center',
	            type : 'checkbox',
	            hide : true,
	            isToggleHideShow : false
	        },
	        "bookNum" : {
	            display : $.i18n('office.bookinfo.num.js'),
	            name : 'bookNum',
	            width : '10%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
	        "bookName" : {
	            display : $.i18n('office.asset.apply.assetName.js'),
	            name : 'bookName',
	            width : '12%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
	        "houseName" : {
	            display : $.i18n('office.bookhouse.js'),
	            name : 'houseName',
	            width : '15%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
	        "bookType_txt" : {
	            display : $.i18n('office.bookinfo.type.js'),
	            name : 'bookType_txt',
	            width : '8%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
	        "bookCount" : {
	            display : $.i18n('office.stock.countsum.js'),
	            name : 'bookCount',
	            width : '15%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
	        "lendSum" : {
	            display : $.i18n('office.book.bookStcInfoShow.jysl.js'),
	            name : 'lendSum',
	            width : '15%',
	            sortable : true,
	            align : 'left',
	            isToggleHideShow : false
	        },
		      "memo" : {
		        display : $.i18n('office.assetinfo.memo.js'),
		        name : 'memo',
		        width : '10%',
		        sortable : true,
		        align : 'left',
		        isToggleHideShow : false
		     },
		     "operat" : {
			     display : '',
			     name : 'operat',
			     width : '8%',
			     sortable : true,
			     align : 'center'
			   }
	    }
}

/**
 * 操作的render
 */
function fnOperatRender(text, row, rowIndex, colIndex, col){
	var _text = (text == null) ? "" : text;
	
	if (col.name === 'operat') {
		return "<a href='javascript:void(0);' class='margin_r_5' onclick='fnDelRow("+row.id+");'><span class='ico16 affix_del_16' title='"+$.i18n('office.tbar.delete.js')+"'></span> </a>";
	}
   
  	//借阅数量
    if(col.name === 'lendSum'){
    	return "<input id='lendSum"+row.id+"' maxlength='9' style='width:55px' class='align_right font_size12 grid_black' onblur='fnCheckLendSum(this);' onkeyup='fnApplyAmountCheck(this);'>";
    }
    //备注
    if(col.name === 'memo'){
    	return "<input id='memo"+row.id+"' maxlength='80' style='width:55px' class='align_right font_size12 grid_black'>";
    }
  return "<span class='grid_black'>"+_text+"</span>";
}

/**
 * 删除选择的图书资料
 */
function fnDelRow(rowId){
	var ids = [],filldata = [],totalPriceData = [];//缓存已填数据
	var amountInputs = pTemp.editTab.find("input[id^=lendSum]");
	var totalPriceDivs = pTemp.editTab.find("input[id^=memo]");
	
	for ( var i = 0; i < amountInputs.length; i++) {
		if (amountInputs[i].value) {
			filldata[i] = amountInputs[i].value;
			totalPriceData[i] = totalPriceDivs[i].value;
		} else {
			filldata[i] = '';
		}
		ids[i] = $(amountInputs[i]).attr("id");
	}
	pTemp.tab.removeRow(rowId);
	fnFillDataToTab(ids,filldata,totalPriceData);
}

/**
 * 向tab表回填输入数据
 */
function fnFillDataToTab(ids,applyAmounts,totalPrices){
	var amountInputs = pTemp.editTab.find("input[id^=lendSum]");
	var totalPriceDivs = pTemp.editTab.find("input[id^=memo]");
	// 回填已填数据
	for ( var i = 0; i < amountInputs.length; i++) {
		var id = $(amountInputs[i]).attr("id");
		var index = ids.indexOf(id);
		if(index!=-1){
			
			if(applyAmounts[index]){
				amountInputs[i].value = applyAmounts[index];
			}
			
			if (totalPrices && totalPrices[index]) {
				totalPriceDivs[i].value = totalPrices[index];
			}
		}
	}
}

function OK(){
	if(pTemp.tab.datas() == null || pTemp.tab.datas().rows.length == 0){
		return {rows:"null"};
	}
	//回填输入的借阅数量和备注
	var validate = $("#toPersonDiv").validate();
	if(validate){
		var rows = pTemp.tab.datas().rows;
		var lendSumInputs = pTemp.editTab.find("input[id^=lendSum]");
		var memoInputs = pTemp.editTab.find("input[id^=memo]");
		for ( var i = 0; i < lendSumInputs.length; i++) {
			var lendSum = lendSumInputs[i].value;
			var memo = memoInputs[i].value;
			rows[i].lendSum = lendSum;
			rows[i].memo = memo;
		}
		return {rows:rows,toPerson:$("#applyUser").val()};
	}else{
		return {rows:"false"};
	}

}

/**
 * 校验输入数字是否合法
 */
function fnCheckLendSum(_this){
	var rows = pTemp.tab.datas().rows;
	var lendSumInputs = pTemp.editTab.find("input[id^=lendSum]");
	var memoInputs = pTemp.editTab.find("input[id^=memo]");
	for ( var i = 0; i < lendSumInputs.length; i++) {
		var lendSum = lendSumInputs[i].value;
		//大于库存，提示
		if($.isNumeric(lendSum) && $.isNumeric(rows[i].bookCount)){
			if(parseInt(lendSum)>parseInt(rows[i].bookCount)){
				$.alert($.i18n('office.bookapply.dolend.sum.notright.js'));
				lendSumInputs[i].value = "";
			}
		}
	}
}

/**
 *借阅数量输入框校验函数 
 */
function fnApplyAmountCheck(_this){
	_this.value = _this.value.replace(/\D/g, '');
}

