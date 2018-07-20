<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp" %>
<html class="h100b over_hidden">

<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>新建网页 1</title>
<style>
    .stadic_head_height{
        height:30px;
    }
    .stadic_body_top_bottom{
        bottom: 30px;
        top: 25px;
    }
    .stadic_footer_height{
        height:30px;
    }
</style>
<script type="text/javascript" src="${url_ajax_collCubeIndexManager}"></script>
<script type="text/javascript">
 var width;
  $(document).ready(function(){
  width= document.body.clientWidth/5-70;
  $("#myfirst").addClass("hidden");
	  var _isDefault = false ;
	  //读取value值,展示界面
	  showIndexValue(_isDefault);
	  
	  //恢复默认
	  $("#btnBack").click(function() {
		  var confirm = $.confirm({
		        'msg' : "${ctp:i18n('colCube.colCubeDesign.dialog.promptBackDefault')}",
		        cancel_fn : function() {
		        },
		        ok_fn : backDefault
		      });
	  });

	  //保存
	  $("#btnSave").click(function() {
	      var confirm = $.confirm({
	        'msg' : "${ctp:i18n('colCube.colCubeDesign.dialog.promptSave')}",
	        cancel_fn : function() {
	        },
	        ok_fn : saveIndex
	      });
	    });
	  $("#cubeAuth").click(function(){
	      window.location.href = url_colCube_collCubeAuth;
	  });
	  $("#cubeIndex").click(function(){
	      window.location.href = url_collCubeIndex_collCubeIndexSet;
	  });
	  
	//指标说明
	  $('#introOfIndex').click(function(){
	  //$('#introOfIndex').click(function(){
		    var dialog = $.dialog({
		        id : 'dialogintroOfIndex',
		        url : url_colCube_introOfIndex,
		        width : 900,
		        height : 500,
		        targetWindow:getCtpTop(),
		        title : "${ctp:i18n('colCube.indexSetup.href.indexIntro')}",
		        buttons : [{
		          text : "${ctp:i18n('colCube.indexSetup.href.return')}",
		          handler : function() {
		            dialog.close();
		          }
		        } ]
		      });
		    })
	  
  });
  
  //展示指标的value或者default value
  function showIndexValue(_isDefault){
	  $("body").data("index_table",$("#myfirst").clone(true));
	  $("body").data("index",$("#index_label").clone(true));
	  var collCubeIndexManager_ = new collCubeIndexManager();
	  collCubeIndexManager_.findAllCollCubeIndex({
	      success : function(result) {
	    	  var len = result.length;
	    	  var cateList= new Array();
	    	  var k = 0;//记录category的数量
	    	  for(var i = 0 ; i < len ; i ++){
	    		  var temp =  result[i];
	    		  var _exist=$.inArray(temp.category,cateList);
	    		  var value = "";
	    		  if(!_isDefault){
	    			  value = temp.value;
	    		  }else{
	    			  value = temp.defaultValue;
	    		  }
	    		  if(_exist>=0){//已经存在分类则直接增加指标
	    			  var obj = $("body").data("index").clone(true);
	    			  createSlider(obj, value, temp.id);
	    			  $('#index_label', obj).attr("style","display: none");
	    		  
	    			  $('#name',obj).text(temp.name);
	                  $("input[type='hidden']", obj).attr("id", temp.id);
	                  $("input[type='hidden']", obj).val(value);
	                  $("table[value='"+temp.category+"']").append(obj);
	    		  }
	    		  else{//不存在分类则新建分类
	    			  cateList[i] = temp.category;
		    		  var obj = $("body").data("index_table").clone(true);
		    		  $(obj).show();
		    		  createSlider(obj, value, temp.id);
		    		  $('#category',obj).text(temp.category);
		    		  $('table',obj).attr("value",temp.category);
		    		  if (temp.name == "文档借阅/共享"){ //借阅共享指标取消掉(代码隐藏)
		    			  $('#index_label', obj).attr("style","display: none");
		    		  }
		    		  $('#name',obj).text(temp.name);
		    		  $("input[type='hidden']", obj).attr("id", temp.id);
		    		  $("input[type='hidden']", obj).val(value);
		    		  //$("#myfirst").after(obj);
		    		  //$("#index_table").append(obj);
		    		  k++;
		    		  if(k <= 3){
		    			  $("#row1").append(obj);
		    		  }else if(k > 3 && k <=6){
		    			  $("#row2").append(obj);
		    		  }else if(k > 6 && k <=9){
		    			  $("#row3").append(obj);
		    		  }else{
		    			  $("#row4").append(obj);
		    		  }
	    		  }
	    	  }
	      }
	  });
  }
  //创建slider
  function createSlider(obj, value, id){
	  var sliderTemp = $("<div id='sliderTemp' name='"+id+"'><div style='height:12px;*display:none;'></div></div>").css({"width":width+"px"})
	  $('#td1', obj).append(sliderTemp);
	  sliderTemp.slider({
		  value: value,
		  range: "min",
		  min: 1,
		  max: 10,
		  slide: update,
		  text: ["", "不重要", "", "", "", "", "", "", "","", "重要"]
		  });
	  }
  
  //保存权重设置
  function saveIndex() {
	  $("#index_list").attr("action", url_collCubeIndex_colCubeUpdate);
	  $("#index_list").jsonSubmit({});
	  }
  //恢复默认权重
  function backDefault(){
	  _isDefault = true;
	  //清空页面以便重新载入value值
	  $("#row1").empty();
	  $("#row2").empty();
	  $("#row3").empty();
	  $("#row4").empty();
	  showIndexValue(_isDefault);
	  }
  
  function update(event, ui){
	  var name = $(this).attr("name");
	  ui.handle.title = ui.value; //update title
	  $("input[id='"+name+"']").val(ui.value);
		}  
</script>
</head>

<body class="h100b over_hidden page_color">
    <div class="stadic_layout ">
        <div class="stadic_layout_head stadic_head_height clearfix">
               <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F08_cubeAuth'"></div>
               <div class="common_tabs clearfix left padding_t_5 padding_l_5">
                    <ul class="left">
                        <li><a hideFocus="true"href="javascript:void(0)" class="no_b_border" id="cubeAuth">${ctp:i18n('colCube.common.crumbs.authSet')}</a></li>
                        <li><a href="javascript:void(0)" class="no_b_border" tgt="tab3_div" id="cubeIndex"><span>${ctp:i18n('colCube.index.set')}</span></a></li>
                        <li class="current"><a hideFocus="true" class="last_tab" href="javascript:void(0)" style="max-width: 100px;">${ctp:i18n('colCube.common.crumbs.indexSet')}</a></li>
                    </ul>
               </div>
               <div class="align_right padding_r_5 padding_t_5"><a href="#" id="introOfIndex" >[${ctp:i18n('colCube.indexSetup.href.indexIntro')}]</a></div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom bg_color_white border_all" style="border-left: none;margin-top:6px">
        	
        	<form id="index_list" method="post">
            <table class="w100b" id="index_table" cellSpacing="0" cellpadding="0">
                <tbody>
                <tr id="row1">
                <!--插入指标 -->
                </tr>
                <tr id="row2">
                <!--插入指标 -->
                </tr>
                <tr id="row3">
                <!--插入指标 -->
                </tr>
                <tr id="row4">
                <!--插入指标 -->
                </tr>
                </tbody>
            </table>
            </form>
            <table style="table-layout:fixed;">
        	<tr>
        		<td class="w20b padding_10" id="myfirst" valign="top">
        			<fieldset >
        				<legend id="category" >模版</legend>
        				<table class=" padding_5" value=""><!-- style="display:none" -->
        					<tr id = "index_label">
        						<td id="th1" class="padding_10" width="94px" align="right"><span id="name" class="margin_r_10">发送/处理:</span></td>
        						<td id="td1" style="padding-bottom:30px;" ><input type="hidden" id="" name="indexHidden" value="" >
   
        						 </td>
        					</tr>
        				</table>
        			</fieldset>
        		</td>
        		</tr>
        	</table>
        </div>
        <div class="stadic_layout_footer stadic_footer_height align_center">
               <a id="btnSave" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('colCube.indexSetup.button.save')}</a>
               <a id="btnBack" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('colCube.indexSetup.button.backDefault')}</a>
               <!-- <a href="#">[指标说明]</a>
               <a href="#" id="introOfIndex" >[${ctp:i18n('colCube.indexSetup.href.indexIntro')}]</a> -->
        </div>
    </div>  
</body>

</html>