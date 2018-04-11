<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>${ctp:i18n("show.section.selector") }</title>
	<style type="text/css">
	   body{overflow:hidden; }
	   .selector-head,.content-area,.footer-area{width: 680px;margin: 0px auto;}
	   .selector-head{height: 40px;}
	   .radios-area{display: inline-block;margin-left: 30px;margin-top: 10px;}
	   .searsh-area{display: inline-block;float: right;margin-top: 5px;}
	   
	   .content-area{height: 300px;border-bottom: 2px solid  #dedede;}
	   .noClick{margin-top: 3px;}
	   
	   .footer-area .selected-tips{height: 30px;line-height: 30px;padding-left: 5px;display: block;font-size: 12px;}
	   .footer-area .showbar-items{padding: 0px 10px;width: 660px;height: 95px;overflow-y: auto;}
	   .footer-area .showbar-item{font-size: 12px; float: left; height: 26px; background: #e6eef7; padding: 2px 10px; border-radius: 3px; overflow: hidden;}
       .showbar-ico{float: left; margin-top: 5px;}	   
       .show_16{background: url(${path}/apps_res/show/images/common/show_16_16.png) no-repeat;}	   
	   .footer-area .showbar-name{max-width: 200px;display: inline-block;text-overflow: ellipsis;white-space: nowrap;word-break: normal;overflow: hidden;}
	   input::-ms-clear{display:none;}
		/*滚动体样式*/
		.showbar-items::-webkit-scrollbar {width: 5px;}
		.showbar-items::-webkit-scrollbar-track {background-color: #fff;}
		.showbar-items::-webkit-scrollbar-thumb {background-color: #ccc;}
		.bDiv::-webkit-scrollbar {width: 5px;}
		.bDiv::-webkit-scrollbar-track {background-color: #fff;}
		.bDiv::-webkit-scrollbar-thumb {background-color: #ccc;}
		input::-ms-clear { display: none; } 
		.gray{color: gray;}
		.heise{color: #000;}
	</style>
</head>
<body>
	<%-- 头部搜索区域 --%>
	<div class="selector-head">
		<div class="common_radio_box clearfix radios-area">
			<label for="newst" class="margin_r_10 hand"> 
				<input type="radio" id="newst" value="newst" name="findType" class="radio_com" checked="checked" >${ctp:i18n("show.section.selector.newst") }
			</label> 
			<label for="hotst" class="margin_r_10 hand">
				<input type="radio" id="hotst" value="hotst" name="findType" class="radio_com">${ctp:i18n("show.section.selector.hotst") }
			</label> 
		</div>
		
		<ul class="common_search searsh-area">
			<li id="inputBorder" class="common_search_input">
				<input class="condition gray" dplaceholder="${ctp:i18n("show.section.selector.search") }" style="border-radius: 5px 0px 0px 5px;" type="text">
			</li>
			<li>
				<a class="common_button search_buttonHand" href="javascript:void(0)">
					<em></em>
				</a>
			</li>
		</ul>
	</div>
	<%-- ajax grid --%>
	<div class="content-area clearfix" id="showbar-table-id">
		<table id="showbar-table" style="display: none"></table>
	</div>
	<%-- 已经选择区域 --%>
	<div class="footer-area">
		<span class="selected-tips">${ctp:i18n("show.section.selector.selected") }</span>
		<div class="showbar-items">
		</div>
	</div>
</body>
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/html" id="showbar-item-tpl">
<div class="showbar-item" id="showbar-{{d.id}}">
	<span class="ico16 show_16 margin_r_5 showbar-ico"></span>
	<a class="showbar-name showbar-ico" title="{{=d.name}}" href="javascript:void(0);">
		{{=d.name}}
	</a>
	<span class="ico16 affix_del_16 showbar-ico" title="${ctp:i18n("show.section.selector.delete") }" onclick="deleteThis('{{d.id}}')"></span>
</div>
</script>
<script type="text/javascript">
	var $condition = $(".condition");
	var dplaceholder = $condition.attr("dplaceholder");
	$condition.val(dplaceholder);
	$condition.on("focus",function(){
		if(this.value == dplaceholder){
			this.value = "";
		}
		$(this).addClass("heise").removeClass("gray");
	}).on("blur",function(){
		if(this.value == ""){
			this.value = dplaceholder;
			$(this).addClass("gray").removeClass("heise");
		}else{
			$(this).addClass("heise").removeClass("gray");
		}
	});
	
	//已经选择的秀吧的缓存
	var selectedShowbars= {}; 
	// 本页面的grid数据缓存
  	var dataCache = [];
  	var showbarItemTpl = laytpl($("#showbar-item-tpl").html());
	/** 数据加载 */
	$(function() {
			var queryoptions = window.parentDialogObj["showSectionSelector"].getTransParams();
			var idsList = [];
			if(queryoptions){
				var temp = queryoptions.split(",");
				for(var i = 0; i <　temp.length ; i++){
					var sid	= temp[i]; 
					if(sid != ""){
						idsList.push(sid);
						selectedShowbars[sid] = sid;
					}
				}
			}
			
		  $("#showbar-table").ajaxgrid({
		      colModel : [ {
		        width : '30',
		        sortable : false,
		        name : 'id',
		        align : 'center'
		      }, {
		        display : $.i18n("show.section.selector.name"),
		        name : 'name',
		        width : '410',
		        sortable : true,
		        align : 'left'
		      }, {
		        display : $.i18n("show.section.selector.creator"),
		        name : 'createUser',
		        width : '100',
		        sortable : true,
		        align : 'left'
		      } ,{
		        display : $.i18n("show.section.selector.createtime"),
		        name : 'createDate',
		        width : '100',
		        sortable : true,
		        align : 'left'
			  }],
			  render:function rend(txt,rowData, rowIndex, colIndex,colObj){
				  if(rowIndex == 0 && colIndex == 0){
					  dataCache = []; 
				  }
				  if(colIndex == 0){
					  dataCache[rowIndex] = rowData;
					  txt = '<input type="checkbox" class="noClick" row="0" id="showbar-checkbox-' + rowData.id + '" onclick="selectedThis(' + rowIndex + ',this)" ';
					  if(selectedShowbars[rowData.id]){
						  txt = txt + " checked=\"checked\" ";
					  }
					  txt = txt + " > ";
				  }
				  return txt;
			  },
		      parentId:"showbar-table-id",
		      slideToggleBtn:false,
		      resizable:false,
		      customize:false,
		      managerName : "showManager",
		      managerMethod : "findShowbar4SectionSelector"
		    });
		  
		  //初始化加载
		  var queryParams = {"findType":"newst"};
		  
		  //搜索
		  var $findType = $("[name='findType']");
		  var $condition = $(".condition");
		  function doSearch(){
			  queryParams = {};
			  var condition = $.trim($condition.val());
			  var findType = "";
			  $findType.each(function(){
				  if(this.checked){
					  findType = this.value;
				  }
			  });
			  var dplaceholder = $condition.attr("dplaceholder");
			  if(condition == dplaceholder){
				  condition = "";
			  }
			  if(findType == queryParams.findType && condition == queryParams.condition){
				  return;
			  }
			  //查询参数
			  if(condition != null && condition != ""){
				  queryParams.createUser = condition;
				  queryParams.showbarName = condition;
			  }
			  //查询类型
			  queryParams.findType = findType;
			  //重新从第一页加载
			  queryParams.page = 1;
			  $("#showbar-table").ajaxgridLoad(queryParams);
		  }
		  
		 /**
		  * 注：必须要等回填选择好的数据才能初始化其他数据
		  */
		  function init(){
			  $("#showbar-table").ajaxgridLoad(queryParams);
			  //绑定事件
			  $findType.off("click").on("click",function(){
				  doSearch();
			  });
			  $(".search_buttonHand").off("click").on("click",function(){
				  doSearch();
			  });
		  }
		 
		 
		 if(idsList.length > 0){
			  var manager = new showManager();
			  manager.findShowbarByIds(idsList,{
				  success:function(datas){
						if(datas != null && datas.length > 0){
							selectedShowbars = {};
							for(var i =0 ; i < datas.length ; i++ ){
								var data = datas[i];
								data.name = data.showbarName;
							 	var html = showbarItemTpl.render(data);
							    $(".showbar-items").append(html);
							    selectedShowbars[data.id + "" ] = data.id + "";
							}
						}
					    init();
				  },
				  error:function(){
					  init();
				  }
			  });
		 }else{
			 init();
		 }
		    
	 });
	
	
	
	
	 /** 选择其中一项  */
	 function selectedThis(index,dom){
		 if(dom.checked && getSelectedLength() >= 20){
			 $.alert($.i18n("show.section.selector.20"));
			 dom.checked = false;
			 return;
		 }
	  	//dataCache
		var data = dataCache[index];
		//限制20
	  	if(data != null){
			if(dom.checked){
			 	var html = showbarItemTpl.render(data);
			    $(".showbar-items").append(html);
			    selectedShowbars[data.id + "" ] = data.id + "" ;
			}else{
			  	deleteThis(data.id); 
			}
		}
	 }
	 
	 /** 获取已经选择的数据大小 */
	 function getSelectedLength(){
		 var i = 0;
		 for(var id in selectedShowbars){
			i++;
		}
		 return i;
	 }
	/** 删除一个选择项  */
	function deleteThis(id){
		var showbar = selectedShowbars[id];
		if(showbar != null){
			delete selectedShowbars[id];
		}
		$("#showbar-" + id).remove();
		//列表中的数据联动
		var checkbox = document.getElementById("showbar-checkbox-" + id);
		if(checkbox){
			checkbox.checked = false;
		}
	}
	
	
	/** 选择回调  */
	function OK() {
		/*
		 *此处说明：
		 *	返回的数据必须是个数组，且数组的第一个也是个数组，并且是数据
		 */
		var dataValue = [];
		for(var id in selectedShowbars){
			dataValue.push(id);
		}
		var resultValue = [];
		resultValue.push(dataValue);
		return resultValue;
	}
</script>
</html>