$(function() {
	//树
	initBookTree();
	
  var bAParam = getAllParams();
	tabLoad(bAParam);
	
	initSearchBar();
    
});
var treeTempValue = 2631;

function getParamsByHouse () {
	  if($("#_officeSBar_input")[0].className.indexOf('color_gray') < 0){
			 $("#_officeSBar_input").addClass('color_gray');
	     	 $("#_officeSBar_input").val($.i18n('office.book.bookLib.smzz.js'));
	  }
	  var bAParam = new Object();
	  bAParam.page = 1;
	  bAParam.size = 8;
	  if(treeTempValue!=2631){
		bAParam.bookCategory = treeTempValue;
	  }	
	  if($("#_officeSBar_select").val()!='bookLibAll'){
		bAParam.houseId = $("#_officeSBar_select").val();
	  }
	  bAParam.selectType = $("input[name='_officeSBar_radio']:checked").val();
	  return bAParam;
}

function searchByConditionByHouse() {
	var bAParam = getParamsByHouse();
	tabLoad(bAParam);
}

function getAllParams(){
  var bAParam = new Object();
  bAParam.page = 1;
	bAParam.size = 8;
	if(treeTempValue!=2631){
		bAParam.bookCategory = treeTempValue;
	}
	if($("#_officeSBar_select").val()!='bookLibAll'){
		bAParam.houseId = $("#_officeSBar_select").val();
	}
	bAParam.selectType = $("input[name='_officeSBar_radio']:checked").val();
	bAParam.selectName = $("#_officeSBar_input").val();
	if ($("#_officeSBar_input")[0].className.indexOf('color_gray') > -1){
		bAParam.selectName = '';
	}
	if (bAParam.selectType != null && bAParam.selectType.length > 1200) {//内容太多，会导致后台查询错误OA-59233
		bAParam.selectType = bAParam.selectType.substr(0,1200)
	}
	
	if (bAParam.selectName != null && bAParam.selectName.length > 1200) {
		bAParam.selectName = bAParam.selectName.substr(0,1200)
	}
	
	return bAParam;
}
/****
 * 右上角的查询按钮的事件方法
 */
function searchByCondition(){
	var bAParam = getAllParams();
	tabLoad(bAParam);
}
/****
 * 弹出图书资料详情的方法
 * @param bookId
 */
function openBookDetail(bookId){
	var url = "/office/bookUse.do?method=openBookDetail&bookId="+bookId,title = $.i18n('office.book.bookLib.xq.js');
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:600});
}

function fnReloadByType(type){
	searchByConditionByHouse();
}

function initSearchBar(){
	//获取查询框中的select中的内容，
	var bAManager = new bookApplyManager();
    var bAParam = new Object();
	bAManager.getBookHousesByAcl(bAParam, {
        success: function(list){
    		var str = "";
        	for(var i = 0;i<list.length;i++){
        		var text = list[i].text;
        		str = str + "<option value=\""+list[i].value+"\" title='"+text+"'>"+text.getLimitLength(19,'...')+"</option>";
        	}
        	$("#_officeSBar_select").append(str);
        }
    });
	
}

function tabLoad(bAParam){
	var bAManager = new bookApplyManager();
	//画页面
  bAManager.getBookLibs(bAParam, {
      success: function(map){
      	var fpi = map.fpi;
      	var html = initLibList(fpi);
      	$("#bookLib").html("");
      	$("#bookLib").append(html);
      }
  });
}

function fnBookOpenWindow(){
	var ckB = $("#borrowCB");
	var bookIds = "";
	var bookIdLength = $('input:checkbox[name="borrowCB"]:checked').length;
	if (bookIdLength < 1) {
		$.alert($.i18n('office.book.bookLib.qxzyjydsj.js'));
		return ;
	}
	if (bookIdLength > 10) {
		$.alert($.i18n('office.book.bookLib.ycxzyxjybtszlqzxxzhjy.js'));
		return ;
	}
	$('input:checkbox[name="borrowCB"]').each(function (){
		if ($(this).attr('checked') == 'checked') {
			bookIds = bookIds + $(this).val()+",";
		}
	});
	if (bookIds != '' && bookIds.length > 1) {
		bookIds = bookIds.substr(0,bookIds.length -1);
	}
	var url = "/office/bookUse.do?method=bookBorrowPage&isNew=true&rows=",title = $.i18n('office.book.bookLib.tszljy.js');
	fnAutoOpenWindow({"url":url,"id":"bookUseView","title":title,hasBtn:true,width:880,height:400,transParams:bookIds,cancelReturnValue:false});
}

function savePage(fpi){
	$('#_afpPage').val(fpi.page);
    $('#_afpPages').val(fpi.pages);
    $('#_afpSize').val(fpi.size);
    $('#_afpTotal').val(fpi.total);
}

function initBookTree(){
	$("#bookTree").tree({
		idKey: "id",
		pIdKey: "pid",
		nameKey: "name",
		managerName : "bookApplyManager",
	    managerMethod : "getBookTreeNodes",
	    onClick: fnTreeClk,
	    nodeHandler: function(n) {
	      if (n.data.pid == '-1') {
	        n.open = true;
	        n.isParent=true;
	      } else {
	        n.open = false;
	      }
	    }
	});
	$("#bookTree").treeObj().reAsyncChildNodes(null, "refresh");
}

/**
 * 点击树查询
 * @param e
 * @param treeId
 * @param node
 */
function fnTreeClk(e, treeId, node) {
	treeTempValue = node.data.id;
	var bAParam = getAllParams();
	tabLoad(bAParam);
}

/**
 * 查询
 */
function fnSBarQuery(obj){
	//查询的时候，记录下查询条件，供导出用
	pTemp.condition = obj.condition;
	pTemp.value = obj.value;
	pTemp.tab.load(obj);
}

function initLibList(fpi){
	savePage(fpi);
	
	var str = "";
	str = str+  "<table width=\"98%\" style='margin-top:20px;' height=\"\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\">";
	str = str+  "<tbody id='libBody'>";
	
	str = appendLibList(fpi,str);
	
	str = str+  "</tbody>";
	str = str+  "</table>";
	if(fpi.total>fpi.size*fpi.page){
		str = str + "<div class=\"number margin_t_10 padding_tb_5 align_center border_all\" id=\"myajaxgridbar\" onclick=\"javascript:addLibToLibBody();\"><a class=\"alink\" id=\"_afpNext\" href=\"javascript:void(0);\">"+$.i18n('office.book.bookLib.ckgd.js')+"</a></div>";
	}
	return str;
}

function appendLibList(fpi,str){
	savePage(fpi);
	var total = fpi.total;
	var size = fpi.size;
	var page = fpi.page;
	var length = 0;
	if(total>=size){
		if(total-size*(page-1)>=size){
			length=size;
		}else{
			length=total-size*(page-1);
		}
	}else{
		length = total;
	}
	
	str = str+	"<tr valign=\"top\" >";
	for(var i = 0;i<length;i++){
		var bean = fpi.data[i];
		
		var fileUrl = bean.fileUrl;
		var createDate = bean.imageCreateDate;
		var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
		var path = _ctxServer;
		var url = " ";
		url = url + path + url1;
		var imgStr = "<img src='" + url + "' width='150' height='180'>";
		
		if(fileUrl==null || createDate==null){
			if (bean.bookType == '0') {
				imgStr = "<img src='/seeyon/apps_res/office/images/book.jpg' width='150' height='180'>";
			} else {
				imgStr = "<img src='/seeyon/apps_res/office/images/book1.png' width='150' height='180'>";
			}
		}
		
		var publishTime = bean.bookPublishTime;
		if(publishTime==null){
			publishTime="";
		}
		if(i%2==0&&i!=0){
			str = str+	"<tr valign=\"top\" >";
		}
		str = str+  "<td height=\"180\">";
		str = str+  "<div id='bookLibs' style =\"height:100%;width:100%;border-radius:15px;\">";
		str = str+  "<table width=\"100%\"  height=\"90%\" style=\"padding-top:15px;\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
		str = str+  "<tr>";
		str = str+  "<td width=\"20\" valign=\"center\">";
		if(bean.bookState=='1' || bean.bookCount=='0'||bean.bookCount=='null'){
			str = str+  "<input type='checkBox' style='background:red;' disabled='disabled' value='"+bean.id+"' id='borrowCB' name='borrowCB' />";
		}else{
			str = str+  "<input type='checkBox' value='"+bean.id+"' id='borrowCB' name='borrowCB' />";
		}
		str = str+  "</td>";
		str = str+  "<td width=\"150\" valign=\"top\">";
		str = str+ 	"<div style=\"width: 150px; height: 180px;margin-left:5px; text-align: center; background-color: rgb(255, 255, 255);\">";
		str = str+ 	"	 <div style=\"width: 150px; height: 180px; text-align: center;\">";
//		str = str+ 	"		<img width=\"120\" height=\"150px;\" src=\"/seeyon/apps_res/v3xmain/images/personal/pic.gif\" border=\"0\">";
		str = str+ imgStr;
		str = str+ 	"</div>";
		str = str+ 	"</div>";
		str = str+  "</td>";
		str = str+  "<td align='left'>";
		str = str+ 	"	<table width=\"100%\"  height=\"100%\"  style=\"margin-top:10px; margin-left:20px;\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
		str = str+ 	"		<tbody>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td>";
		var wordLen = 18;
		wordLen = (getCtpTop().screen.width>1024 && getCtpTop().screen.width) < 1280? 22:28;
		if (getCtpTop().screen.width <= 1024) {
			str = str+ 	"						<span style=\"font-size:14px;font-weight:bold;font-style:normal;text-decoration:none;color:#000000;\"><a href=\"javascript:void(0)\" onclick=\"javascript:openBookDetail('"+bean.id+"');\" title=\""+bean.bookName+"\">"+bean.bookName.getLimitLength(wordLen)+"</a></span>";
		}else{
			str = str+ 	"						<span style=\"font-size:16px;font-weight:bold;font-style:normal;text-decoration:none;color:#000000;\"><a href=\"javascript:void(0)\" onclick=\"javascript:openBookDetail('"+bean.id+"');\" title=\""+bean.bookName+"\">"+bean.bookName.getLimitLength(wordLen)+"</a></span>";
		}
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td title=\"\" style='padding-top: 10px;'>";
		str = str+ 	"						<span style=\"font-size:13px; font-color:gray;font-weight:normal;font-style:normal;text-decoration:none;color:gray;\" title=\""+bean.bookAuthor+"\">"+$.i18n('office.book.bookLib.zz.js')+":"+bean.bookAuthor.getLimitLength(10)+"</span>";
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td>";
		str = str+ 	"						<span style=\"font-size:13px; font-color:gray;font-weight:normal;font-style:normal;text-decoration:none;color:gray;\" title=\""+bean.bookPublisher+"\">"+$.i18n('office.book.bookLib.cbs.js')+":"+bean.bookPublisher.getLimitLength(8)+"</span>";
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td>";
		str = str+ 	"						<span style=\"font-size:13px; font-color:gray;font-weight:normal;font-style:normal;text-decoration:none;color:gray;\">"+$.i18n('office.bookinfo.publishdate.js')+":"+publishTime+"</span>";
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td>";
		str = str+ 	"						<span style=\"font-size:13px;font-weight:normal;font-style:normal;text-decoration:none;color:gray;\">"+$.i18n('office.book.bookLib.zs.js')+"：</span><span style='font-size:12px;color:gray;'>"+bean.bookState_txt+"</span>";
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"		<tr>";
		str = str+ 	"			<td>";
		str = str+ 	"				<br>";
		str = str+ 	"			</td>";
		str = str+ 	"		</tr>";
		str = str+ 	"	</tbody></table>";
		str = str+  "	</td>";
		str = str+  " </tr>";
		str = str+  "</table>";
		str = str+  "</div>";
		str = str+  "</td>";
		if(i%2!=0&&i!=0){
			str = str+ 	"</tr>";
		}
	}
	if(length%2!=0&&length!=0){
		str = str+ 	"</tr>";
	}
	return str;
}

/***
 * 查看更多的查询
 */
function addLibToLibBody(){
    var bAManager = new bookApplyManager();
	var bAParam = getAllParams();
	bAParam.page = Number($('#_afpPage').val())+1;
	bAParam.size = $('#_afpSize').val();
	bAManager.getBookLibs(bAParam, {
        success: function(map){
        	var fpi = map.fpi;
        	var html = appendLibList(fpi);
        	if(fpi.total<=fpi.size*fpi.page){
        		$("#myajaxgridbar").hide();
        	}
        	$("#libBody").append(html);
        }
    });
}


function fnBookBorrow(){
	
}

function fnPageInIt() {
}

function fnPageReload() {
	pTemp.tab.load();
}

function fnNew() {
    fnShowDetail('add');
}

function fnEdit() {
    fnShowDetail('modify');
}

function fnOK (params) {
	var okparam = params.okParam;
	var tempCou = "";
	if (okparam != null) {
		for ( var i = 0; i < okparam.length; i++) {
			if (parseInt(okparam[i].realNum) < parseInt(okparam[i].applyTotal)) {
				tempCou = "《" + okparam[i].bookName + "》 ";
			}
		}
		var ajaxM = new bookApplyManager();
		if (tempCou.length != 0) {
			$.confirm({
			  "msg" : $.i18n('office.book.bookBorrow.yxtskcbzqdjy.js') + "<br>" + tempCou,
			  ok_fn : function(){
				  if (okparam != null) {
					  ajaxM.save(okparam, {
						  success : function(){
							  $.infor($.i18n('office.book.bookLib.jycg.js'));
							  if (params.dialog) {
								  params.dialog.close();
							  }
						  }
					  });
				  }
			  },
			  cancel_fn : function(){
			  }
			});
		}else{
			ajaxM.save(okparam, {
			  success : function(){
				  $.infor($.i18n('office.book.bookLib.jycg.js'));
				  if (params.dialog) {
					  params.dialog.close();
				  }
			  }
		  });
		}
	}
}

function fnCancel (params) {
	if (params.dialog){
		params.dialog.close();
	}
}


$("#bookLibs").live("mouseenter",function(){
	$(this).css("backgroundColor","#F0F6F8");
	$(this).find("div").css('backgroundColor','#F0F6F8');
}).live("mouseleave",function(){
	$(this).css("backgroundColor","#FFFFFF"); 
	$(this).find("div").css('backgroundColor','#FFFFFF');
});

$("#bookLibs").live("click", function (event){
	var srcEle = event.srcElement || event.target;
	if (srcEle.type && srcEle.type == 'checkbox') {
		return ;
	}
	$(this).find('input').each(function (){
		if ($(this).attr('type').toLowerCase() == 'checkbox') {
			if ($(this).attr('checked') == 'checked') {
				$(this).removeAttr('checked'); 
			} else {
				if($(this).attr('disabled') != "disabled"){
					$(this).attr('checked','checked');
				}
			}
		}
	})
})

$('#_officeSBar_input').live('focus',function (){
	 if($(this)[0].className.indexOf('color_gray') > 0){
		 $(this).removeClass('color_gray');
 		 $(this).val('');
	 }
}).live('blur',function (){
	  var values = $(this).val();
	  if(values == '' || values.length <=0){
		 $(this).addClass('color_gray');
     	 $(this).val($.i18n('office.book.bookLib.smzz.js'));
	  }
}).live('keyup',function (event){
	  var values = $(this).val();
	  if(values == '' || values.length <=0){
		  if($(this)[0].className.indexOf('color_gray') > 0){
    		  $(this).removeClass('color_gray');
	              $(this).val('');
		  }
	  }
	  if (event.keyCode == 13) {
		  searchByCondition();
	  }
})
