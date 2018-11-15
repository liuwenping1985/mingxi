<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/select2.js.jsp"%>
<script type="text/javascript" src="/seeyon/common/content/form.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
(function($) {
	//{leftChar:'(',fieldName:'field0001',...}
	var fieldWidth;//用于自定义模式点击重置后，普通模式下的值录入框宽度为0，记录一下初始化时候的宽度。
	$.defaultOperation = "<select id='operation' class='operation'></select>";
	$.fn.compThisCondition = function(options) {//初始化1行
		$(this).compChangeCondition(options);
		$(this).fillform(options);
	};
	$.fn.compChangeCondition = function(param2) {//修改字段触发事件
		var param = param2;
		if(param==null){
			param = {};
			param.fieldName = $("#fieldName",this).val();
			param.operation = $("#operation",this).val();
			param.fieldValue = $("#fieldValue",this).val();
		}
		var opt = param.operation?[param.operation]:[];
		var value = param.fieldValue?[param.fieldValue]:[];
		var o = new componentManager();
		var fieldNames = new Array();
		fieldNames[0]=param.fieldName;
		var objTr = $(this);
		var hmt = o.getFormConditionHTML($.formId,fieldNames,opt,value);
		if(param.fieldName==""){
			hmt[0][0]=$.defaultOperation;
		}
		if(hmt){
            var comp = $(hmt[0][1]);
            setOneComp(comp);
            $(".fieldInputValue",objTr).empty();
            $(".fieldInputValue",objTr).html(comp);
            $(".operationDiv",objTr).html(hmt[0][0]);
        }
		//objTr.comp();
	};
	//{formId:'2323',data:[{leftChar:'(',...},{leftChar:')',...}],
	//fieldNames:[{fieldName:'field001',display:'金额'},{fieldName:'start_date',display:'创建时间'}]}
	$.fn.compCondition = function(options) {//初始化全部
		var param = {};
		param = $.extend(param,options);
		$.formId = param.formId;
		//if($(this).html()==""){
			var showTable = "<table width='100%' id='userConditionTable' isGrid='true' style='table-layout:fixed;'></table>";
			var showTr = "<tr>"+
			"<td style='width: 8%'>"+
			"<DIV class=common_selectbox_wrap><select id='leftChar' class='leftChar'>"+
				"<option selected value=''></option>"+
				"<option value='('>(</option>"+
			"</select></DIV>"+
			"</td>"+
			"<td style='width: 22%'>"+
			"<DIV id='fieldNameDIV' class=common_selectbox_wrap><select onchange='$.changeField(this);' formId='"+param.formId+"' id='fieldName' name=\"${ctp:i18n('form.query.condition.label')}\" class='fieldName validate comp enumselect common_drop_down' comp=\"type:'autocomplete',autoSize:true,change:'showViewType4FormType'\" comptype='autocomplete' validate=\"type:'string',notNull:true,errorMsg:'输入查询条件不能为空!'\">"+
				"<option selected value=''></option>";
				for(var k =0;k<param.fieldNames.length;k++){
					showTr = showTr + "<option value='"+param.fieldNames[k].fieldName+"' formatType='" +param.fieldNames[k].formatType+"' inputType='"+param.fieldNames[k].inputType+"' enumId='"+param.fieldNames[k].enumId+"' enumLevel='"+param.fieldNames[k].enumLevel+"'>"+param.fieldNames[k].display+"</option>"
				}
				showTr = showTr + "</select></DIV>"+
			"</td>"+
			"<td style='width: 10%'>"+
			"<DIV class='common_selectbox_wrap operationDiv'>"+
			$.defaultOperation+
			//逻辑运算
			"</DIV>"+
			"</td>"+
			"<td style='width: 32%' align='left' class='fieldInputValue'>"+
			"<DIV class='common_txtbox_wrap'><input id='fieldValue' name='fieldValue' class='fieldValue'"+($.v3x.isMSIE7?" style='height:16px'":"")+"></DIV>"+//值
			"</td>"+
			"<td style='width: 8%'>"+
			"<DIV class=common_selectbox_wrap><select id='rightChar' class='rightChar'>"+
				"<option selected value=''></option>"+
				"<option value=')'>)</option>"+
			"</select></DIV>"+
			"</td>"+
			"<td style='width: 10%'>"+
			"<DIV class=common_selectbox_wrap><select id='rowOperation' class='rowOperation'>"+
				"<option selected value='and'>and</option>"+
				"<option value='or'>or</option>"+
			"</select></DIV>"+
			"</td>"+
			"<td  style='width: 10%'><span id='delButton' class='delButton repeater_reduce_16 ico16 revoked_process_16'>"+
			"</span> <span id='addButton' class='addButton repeater_plus_16 ico16'> </span></td>"+
		"</tr>";
			if(param.data==null){
				var t = $(showTable).html(showTr);
				t.width($(this).width()-16);
				$(this).append(t);
			}else{
				var t = $(showTable);
				t.width($(this).width()-16);
				for(var kk=0;kk<param.data.length;kk++){
					var r = $(showTr);
					t.append(r);
					r.compThisCondition(param.data[kk]);
				}
				$(this).append(t);
			}
            $(window).resize(function(){
				var tb=$("#userConditionTable");
				tb.css("width","");
				tb.width(tb.parent().width());
			});
			//保存为我的查询后，有的查询字段可能被移除了。此处对已被移除的字段进行清理，如果只有最后一条则情况，否则删除。
			$("tr","#userConditionTable").each(function(){
					var fn = $(this).find("#fieldName:first");
					if($(":selected",fn).val()==""){
						if($("tr","#userConditionTable").length>1){
						   $(this).remove();
						}else{
							$("input",$(this)).val("");
							$("option[value='']",$(this)).prop("selected",true);
							$("option[value='']",$(this)).attr("selected","selected");
							$("option[value!='']",$(this)).prop("selected",false);
							$("option[value!='']",$(this)).removeAttr("selected");
						}
					}
			});
			
			//重新计算数据域TD宽度 防止有滚动条时 日期控件的按钮位置没有对齐
			var fsWidth = 0;
			if($(".fieldInputValue","#userConditionTable")[0]!=undefined){
				fsWidth = $(".fieldInputValue","#userConditionTable")[0].offsetWidth;
				if(fsWidth == 0){
					fsWidth = fieldWidth;
				}
				fieldWidth = fsWidth;
			}
			$(".fieldInputValue","#userConditionTable").css("width",""+(fsWidth-38)+"px");
			$("#userConditionTable").attr("widthAttr",fsWidth);
			resetWidthComp($("#userConditionTable"));
			$("#userConditionTable").comp();
			bindEvent($("#userConditionTable"));
		      var cacheTr = $("tr:eq(0)",$(this)).clone(true);
		       $("#leftChar",cacheTr).val("");
		       $("#fieldName",cacheTr).val("");
		       $("#operation",cacheTr).val("=");
		       $("#fieldValue",cacheTr).val("");
		       $("#rightChar",cacheTr).val("");
		       $("#rowOperation",cacheTr).val("and");
		       cacheTr.compChangeCondition();
		       resetWidthComp(cacheTr);
		       $("body").data("cloneUserCondition",cacheTr);
        function bindEvent(obj) {
            $(".addButton",obj).click(function(){
                var tr = $("body").data("cloneUserCondition").clone(true);
                var curTr = $(this).parents("tr:eq(0)");
                if($("#fieldName",curTr).val()!=""){
                    var newTr = $(showTr);
                    curTr.after(newTr);
                    newTr.comp();
                    bindEvent(newTr);
                    //新增一行后，检查前一行的行操作符是否为null,若是 选中第一条
                    if($("#rowOperation",curTr).val()==null||$("#rowOperation",curTr).val()==""){
                        $("#rowOperation",curTr).find("option:first").prop("selected",true);
                    }
                    adjustQueryHeight();
					resetWidthComp($("#userConditionTable"),true);
                }else{
                    $.alert({
                        'type' : 0,
                        'msg' : "${ctp:i18n('form.formmasterdatalist.afterconfigtoadd')}",
                        ok_fn : function() {
                        }
                    });
                }
            });
            $(".delButton",obj).click(function(){
                var trs = $("tr",$("#userConditionTable"));
                if(trs.length>1){
                    $(this).parents("tr:eq(0)").remove();
                }else{
					var curTr = $(this).parents("tr:eq(0)");
					curTr.html($(showTr).html());
					curTr.comp();
					bindEvent(curTr);
				}
                adjustQueryHeight();
				resetWidthComp($("#userConditionTable"),true);
            });
        }
    };
	  //获取提交的值
	  $.getFieldValueByKey = function(container,keyId){
		  var tr = container;
		  keyId = keyId.replace("/","\\/");
		  var vaStr = $("#"+keyId,tr).val()||"";
		  var f = $("#fieldValue",tr);
		  switch (f.attr("inputType")) {
	      	case 'member':
	        case 'account':
	        case 'department':
	        case 'post':
	        case 'level':
	        case 'multimember':
            case 'multiaccount':
            case 'multidepartment':
            case 'multipost':
            case 'multilevel':
	          if(vaStr!=""){
		          var sss = vaStr.split(",");
		          var rr = "";
		          for(var o=0;o<sss.length;o++){
			          rr = rr + sss[o].substring(sss[o].indexOf("|")+1, sss[o].length)+",";
		          }
		          vaStr = rr.substring(0, rr.length-1);
	          }
	          break;
	        case 'radio':
	        case 'checkbox':
	        	var c = $("input:checked",tr);
		        if(c.length>0){
			        c.each(function(i){
			        	vaStr = vaStr + $(this).val();
			        	if(i!=c.length-1){
			        		vaStr = vaStr + ",";
			        	}
				    });
		        }
		        break;
		     default :
			        break;
			}
        	  var txt = $("#"+keyId+"_enumval",tr).val()
              if(txt){
                  vaStr = txt;
              }
			f.val(vaStr);
	  };
	  $.getFieldValueByInputType = function(tr,fieldObj){
		  $.getFieldValueByKey(tr,fieldObj.val());
	  };
	  //把查询条件设置成固定数据来提交
	  $.setFieldValueSubmit = function(){
		  $("tr","#userConditionTable").each(function(){
				var nn = $(":selected",$("#fieldName",$(this)));
				if(nn.val()!=""){
					$.getFieldValueByInputType($(this),nn);
				}
			});
	  };
	  $.validateBrackets = function(){
		  var charCout = 0;
      	var isTrue = true;
      	$("tr","#userConditionTable").each(function(){
          	if($("#leftChar",this).val()=="("){
              	charCout++;
          	}
          	if($("#rightChar",this).val()==")"){
          		charCout--;
          	}
          	if(charCout<0){
              	isTrue=false;
          	}
          });
          if(charCout!=0||!isTrue){
              $.error("${ctp:i18n('FormQuery.RightAndLeftBracketError')}");
              return false;
          }
          return true;
	  };
	  $.changeField = function(obj){
		  var objTr = $(obj).parents("tr:eq(0)");
		  objTr.compChangeCondition({formId:'',fieldName:$(obj).val(),formatType:$(":selected",obj).attr("formatType"),inputType:$(":selected",obj).attr("inputType"),enumId:$(":selected",obj).attr("enumId"),enumLevel:$(":selected",obj).attr("enumLevel")});
		  resetWidthComp(objTr);
		  objTr.comp();
		  try{
			  if(resetTableTop){
				  resetTableTop();
			  }
		  }catch(e){}
		  adjustQueryHeight();
	  }
})(jQuery);
//北边查询区除了查询条件以外的高度
var _decentFieldsetDivHeight = 0;
function adjustQueryHeight() {
	var conditionHeight = $("body")[0].scrollHeight - 220;//220是查询结果的最小高度 保证能看到table
  if($("fieldset").length == 0 || $($("fieldset")[0]).children("div").length == 0)
    return;
  if(_decentFieldsetDivHeight <= 0) {//OA-43270
	  //第一次加载的时候计算这个值
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
//hasComp : 是否已经组件化的标识；在新增行的时候，如果有selectPeople类型的，宽度计算会有问题，此处再减20px(chrome)
function resetWidthComp(comp,hasComp){
	$('.comp', comp).each(function(){
		  var $t = $(this), ct = $t.attr('comp');
		  if(ct && ct != '') {
		      var j = $.parseJSON('{'+ct+'}');
		      if(j.type == 'selectPeople') {
		          var widthAttr = $("#userConditionTable").attr("widthAttr")||$(this).parents("td:eq(0)")[0].offsetWidth;
				  if($.v3x.isChrome){
		              $t.css('height', '20px').css('width', (hasComp?(widthAttr-60):(widthAttr-40))+"px");
      	  		 }else{
          		    //$t.css('height', '20px').css('width', (needMinusWidth?(widthAttr-40):(widthAttr-20))+"px");
      	  		}
              }else if(j.type=='chooseProject'){
                  $t.css('height', '20px').css('width', ($(this).parents("td:eq(0)").width()-25)+"px");
      	  	  }else if(j.type == 'calendar') {
      	  	      $t.css('width', '99%');
      	  	      $t.attr('_widthed', 'true');
      		  }else if(j.type == 'autocomplete') {
                  $t.css('width', '99%');
              }
		  }
	});
  	if($.v3x.isMSIE7) {
  	    $('input', comp).each(function(){
  	        $(this).height('20px');
          });
  	}

    adjustQueryHeight();
	
	//控件显示有问题
		setTimeout(function() {
			comp.find('input').each(function () {

				var $t = $(this);
				if ($t.prev().is('select')) {
					$t.css('width', ($t.parents("td").width() - 26) + "px");
				}
			});
			if($.v3x.isMSIE7) {
				$('.edit_class').each(function () {
					var $t = $(this);
					$t.css('width', $t.closest("td").width() + "px");
					$t.find(".comp").css('width', ( $t.closest("td").width() - 16) + "px");
				});
			}
		},5);

}
function setOneComp(comp){
	 $('input', comp).each(function(){
	  	if($(this).hasClass("xdTextBox")){
	  		$(this).css("padding","0px").css("margin","0px");
	 	}
	 });
}

//外部写入显示格式是枚举,需要客户手工选择枚举后才能显示值
function selectEnums(param,id,parentId,enumId,enumLevel){
    var obj = new Array();
    var isfinal = false;
    var isReset = true;
    var urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&isfinal="+isfinal;
    if(enumId){
        isfinal=0;
        urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&isfinal="+isfinal+"&rootEnumId="+enumId+"&enumLevel="+enumLevel+"&isReset="+isReset;
    }
    obj[0] = window;
    var dialog = $.dialog({
            url:urlStr,
            title : '${ctp:i18n("form.field.bindenum.title.label")}',
            width:500,
            height:430,
            targetWindow:getCtpTop(),
            transParams:obj,
            buttons : [{
              text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
              id:"sure",
              handler : function() {
                  var result = dialog.getReturnValue();
                  if(result){
                    if(enumId){
                        var test = $("#"+id+"_enumval",param.parent()).size();
                        if(test != 0){
                            $("#"+id+"_enumval",param.parent()).val(result.enumId);
                            $("#"+id,param.parent()).val(result.enumName);
                        }else{
                            var html = "<input type='hidden' id='"+id+"_enumval' value='"+result.enumId+"'>";
                            param.parent().append(html);
                            $("#"+id,param.parent()).val(result.enumName);
                        }
                    }else{
                        var fMgr = new formManager();
                        var html = fMgr.getFieldHTML4Select(result.enumId,result.isFinalChild==null?false:result.isFinalChild,result.nodeType);
                        html = html.replace("id='field' name='field'","id='"+id+"' name='"+id+"'");
                        html = html.replace("width:100%","width:50%");
                        html = "<input type='text' style='width:50%' value='"+result.enumName+"' onclick='selectEnums($(this),\""+id+"\",\""+parentId+"\")'>"+html;
                        param.parent().html(html);
                    }
                    dialog.close(); 
                  }
              }
            }, {
              text : "${ctp:i18n('form.query.cancel.label')}",
              id:"exit",
              handler : function() {
                  returnObj = false;
                  dialog.close();
              }
            }]
    });
}
</script>