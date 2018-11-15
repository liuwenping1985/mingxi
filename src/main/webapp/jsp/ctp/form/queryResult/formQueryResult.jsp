<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('formsection.infocenter.formquery')}</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../common/common.js.jsp" %>
<%@ include file="../component/formFieldConditionComp.js.jsp" %>
<c:if test="${ctp:hasPlugin('collaboration')}">
    <script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
</c:if>

    <script>
    var currentDate = "${currentDate}";
    var isAutoReset = false;//是否自动触发的重置
    var operat = new Array();
    var initState;//初始化的时候的状态选项
    var field;
    var urlFieldList = $.parseJSON('${urlFieldList}');
    var imageDisList  = $.parseJSON('${imageDisList}');
    <c:forEach var="f" items="${fields }">
        field = {};
        field.fieldName = '${f.name}';
        field.display = '${f.extraMap["showDisplay"]}';
        field.inputType = '${f.inputType}';
        field.formatType =  '${f.formatType}';
        field.enumId = '${f.enumId}';
        field.enumLevel = '${f.enumLevel}';
        operat[operat.length] = field;
    </c:forEach>
    var formType = ${queryBean.formBean.formType };
    var queryFormId = '${queryBean.formBean.id }';
    var isMyQuery = ${queryBean.myQuery};
    var myConditionData = null;
    if((isMyQuery || "${param.type eq 'drQuery'}" == "true") && "${hasUserCondition}" == "true"){
      myConditionData = $.parseJSON('${ctp:escapeJavascript(userCondition)}');
    }
    var showPanel = false;//是否显示上面的选择模式。没有用户输入条件或没有自定义查询项时为false.其他为true
    var fm = new formManager();

    function initFieldOperation(){
        var opt ="<option value=''></option>";
        for(var i=0;i<operat.length;i++){
            var f = operat[i];
            opt = opt + "<option value='"+f.fieldName+"'>"+f.display+"</option>";
        }
        $(".fieldName").each(function(){
            var temValue = $(this).val();
            $(this).empty();
            $(this).html(opt);
            $(this).val(temValue);
        });
    }
    var decentHeight = 130;
    $(document).ready(function(){
      new inputChange($("#set_display"),"${ctp:i18n('form.query.clickToShow')}");
      new inputChange($("#sort_display"),"${ctp:i18n('form.query.clickToOrderBy')}");
       var layout= new MxtLayout({
            'id': 'layout',
            'northArea': {
            'id': 'north',
            'height': 155,
            'sprit': true,
            'maxHeight':300,
            'minHeight':0,
            'border': true,
            'spritBar': true,
            spiretBar: {
                    show: true,
                    handlerB: function () {
                       if($(".layout_north").height()<1){
                       $("#conditionDiv2").css("height","70px");
                       layout.setNorth(155);
                       adjustQueryHeight();
                       }
                    },
                    handlerT: function () {
                        if($(".layout_north").height()>1){
                        layout.setNorth(0);
                        var h = $("#center").height();
                        resetTableTop();
                        $("table.flexme1").ajaxgrid().grid.resizeGrid(parseInt(h-decentHeight));
                        }
                    }
                }
            },
            'centerArea': {
                'id': 'center',
                'border': true,
                'minHeight':20
            }
        });
       $("#layout").attrObj("_layout",layout);
       <c:if test="${fieldSize > 0}">
       $("#userConditionDiv").compCondition({formId:queryFormId,fieldNames:operat,data:myConditionData});
       </c:if>
       var stateMap;
       //表单管理员设置系统查询条件的表单状态  还应该有一种情况：用户自己勾选表单状态后保存为个人查询
       <c:if test="${stateMap != null}">
       stateMap = ${stateMap};
       var allRadios
       if(stateMap.state!=null){
         propRadios($(".state_class"),stateMap.state);
       }
       if(stateMap.finishedflag!=null){
         propRadios($(".finishedflag_class"),stateMap.finishedflag);
       }
       if(stateMap.ratifyflag!=null){
         propRadios($(".ratify_class"),stateMap.ratifyflag);
       }
       </c:if>
       <%---此处处理个人查询中流程状态、核定状态、审核状态的回填---%>
       <c:if test="${allstatus != null}">
        var allStatus = "${allstatus}";
        allStatus = $.trim(allStatus).split(",");
        $(":checkbox","#stateTr").each(function(){
            $(this).prop("checked", false);
        });
        for(var i=0;i<allStatus.length;i++){
            var sss = allStatus[i];
            var re = sss.split("=");
            if (sss.indexOf(":")>0) {
                re = sss.split(":");
            }
            allStatus[i]=re;
            if(allStatus[i][1]!="null"){
                $("#"+$.trim(allStatus[i][0])).prop("checked",true);
                $("#"+$.trim(allStatus[i][0])).prop("disabled",false);
            }else{
                $("#"+$.trim(allStatus[i][0])).prop("checked",false);
                $("#"+$.trim(allStatus[i][0])).prop("disabled",false);
            }
        }
      </c:if>
       initState = $("#stateTr").formobj();
       $("#excQuery").click(function(){
           if($("#currentShowFieldNames").val()==""){
             $.alert("${ctp:i18n('form.query.querydisplayfieldset.label')}${ctp:i18n('form.base.notnull.label')} !");
               return false;
           }
           $.setFieldValueSubmit();
           search();
       });
       $("#showFieldBn").click(function(){
           var ooo = {};
           ooo.DialogTitle = "${ctp:i18n('form.query.querydisplayfieldset.label')}";
           selectChoose("currentShowFieldNames","${queryBean.formBean.id}",null,ooo);
       });
       $("#sortOrderBn").click(function(){
         var ooo = {};
           ooo.DialogTitle = "${ctp:i18n('form.query.queryresultsort.label')}";
           ooo.LeftUpTitle = "${ctp:i18n('form.query.querydatafield.label')}";
         selectChoose("orderByShowList","${queryBean.formBean.id}",null,ooo);
       });

       $("#conditionReset").click(function(){
           //重置右侧的显示项和排序字段
           //因为从自定义模式切换到普通模式的时候执行了一次reset，导致我的查询被的显示项被重置为了最原始的，特加这个参数控制。
           if(!isAutoReset){
               $("#currentShowFields").val($("#showFields").val());
               $("#currentShowFieldNames").val($("#showFieldNames").val());
               $("#orderByNameList").val($("#oldOrderByNameList").val());
               $("#orderByShowList").val($("#oldOrderByShowList").val());
           }
           isAutoReset = false;
           if($("#userConditionTable").length>0){
                $("#userConditionDiv").empty();
                $("#userConditionDiv").compCondition({formId:queryFormId,fieldNames:operat,data:myConditionData});
           }
           if($("#queryModuleType").val()==1){
             $("#userFastCondition").empty();
             $("#userFastCondition").append($("body").data("userFastConditionObject").clone(true));
             $('.comp', "#userFastCondition").each(function(){
              var $t = $(this), ct = $t.attr('comp');
              if(ct && ct != '') {
                  var j = $.parseJSON('{'+ct+'}');
                  var compObj = $(this);
                  if(j.type=='chooseProject') {//关联项目组件重复comp有些问题   在外面处理
                     var clObj = $(this).clone();
                     var clParent = $(this).parent();
                     clParent.empty();
                     var clId = clObj.prop("id");
                     clObj.prop("id",clId.substring(0,clId.length-4));
                     clObj.prop("name",clId.substring(0,clId.length-4));
                     clParent.append(clObj);
                     compObj = clObj;
                  } else if (j.type=='autocomplete' || j.type == "fastSelect"){
                   var clParent = $(this).parent();
                   $(this).width(100);
                   clParent.empty();
                  clParent.append($(this));
                  }
                 compObj.comp();
              }
            });
             //$("#userFastCondition").comp();
             resetWidthUserFastCondition();
           }
           $("#stateTr").fillform(initState);
       });
       $("#saveMyQuerySet").click(function(){
           var flag = true;
           $("tr","#userConditionTable").each(function(i){
               var vll = $(".fieldName",$(this)).val();
               if (!vll){
                   flag = false;
                   return false;
               }
             });
             if(flag){
               saveMyQuery();
             }else{
                 $.alert("${ctp:i18n('form.query.defineConditionFieldNotNull')}");
             }
       });
     $("#delMyQuerySet").click(function(){
       $.confirm({
         'msg' : "${ctp:i18n('form.queryResult.confirm.label')}",
         ok_fn : function() {
           var manager = new formQueryResultManager();
           manager.deleteMyQuery($("#queryId").val(),{
                   success: function(obj){
              var p = parent;
            p.location.href=p.location.href;
                   }
               });
         }
       });
     });
     $(":checkbox","#stateTr").click(function(){
       if($(this).prop("checked")){
       }else{
           if($(this).prop("id").indexOf("finished")>-1){
               if($(":checkbox:checked",$(this).parents("div:eq(0)")).length==0){
                  $.alert("${ctp:i18n('form.query.chooseOneAtLeast')}");
                  $(this).prop("checked",true);
               }
           }else{
               if($(":checkbox:checked",$(this).parents("#formStateDiv")).length==0){
                   $.alert("${stateLabel.text },${ratifyLabel.text }${ctp:i18n('form.query.chooseOneAtLeast')}");
                   $(this).prop("checked",true);
               }
           }
       }
    });
    $("#formStateHref").click(function(){
      $("#formStateDiv").toggleClass("hidden");
      adjustQueryHeight();
      resetTableTop();
    });
    $("#advanceButton").click(function(){
      if($("#queryModuleType").val()==2){
        $("#queryModuleType").val(1);
      }else{
        $("#queryModuleType").val(2);
      }
      setQueryModuleType($("#queryModuleType").val());
      adjustQueryHeight();
      resetTableTop();
    });
    $("#queryPrint").click(function(){
      printQuery();
    });
    $("#transColButton").click(function(){
      if($("#queryInfo").val()==""){
        $.error("${ctp:i18n('FormQuery.error.exeQueryFirst.label')}");
        return false;
      }
      transColl();
    });
    $("#exportQueryResult").click(function(){
      if($("#queryInfo").val()==""){
        $.error("${ctp:i18n('FormQuery.error.exeQueryFirst.label')}");
        return false;
      }
        var result = fm.canDownload(queryFormId, "${queryId }", $.ctx.CurrentUser.id);
        if (result && result.success) {
            var confirm = $.confirm({
                'msg': $.i18n('form.export.excel.msg'),
                ok_fn: function () {
                    $.batchExport($("table.flexme1")[0].p.total,function(page,size){
                        $("#exportResult").jsonSubmit({action:'${path}/form/queryResult.do?method=exportQueryResult&page='+page+'&size='+size,target:'exportQueryResultIframe'});
                    });
                }
            });
        } else {
            if (result && result.errorKey == "haveRecord") {
                $.alert($.i18n('form.export.excel.msg'));
            }
        }
    });
    //拖动上下
    $("#center").resize(function(){
        var h = $("#center").height();
        var h2 = $("#resultButtomDiv").height();
        var h3 = $(".pDiv").height();
        $("#center1").height(h-h2);//表格外层高度
        $("table.flexme1").ajaxgrid().grid.resizeGrid(parseInt(h-h2-h3*2+20));//表格高度
    });
    
    if(!$.ctx.resources.contains('F01_newColl')){
      $("#transColButton").hide();
    }
       $("body").data("showTableObject",$("table.flexme1").clone(true));
       $("body").data("defineStateTrObject",$("#stateTr").children().clone(true));
       $("body").data("nomorlStateTrObject",$("#stateTr").children().clone(true));
       $("body").data("userFastConditionObject",$("#userFastCondition").children().clone(true));
       initShowTable();
       if(<c:if test="${queryBean.userCondition == null }">false&&</c:if>operat.length>0){
           $("#moduleTr").removeClass("hidden");
           $("#queryModuleType").val(1);
           if(isMyQuery){
             $("#queryModuleType").val(2);
           }
           setQueryModuleType($("#queryModuleType").val());
        showPanel=true;
      }else {
        $("#queryModuleType").val(2);
        <c:if test="${queryBean.userCondition != null }">
        $("#queryModuleType").val(1);
        </c:if>
        setQueryModuleType($("#queryModuleType").val());
      }
       <c:if test = "${param.showResult eq 'true'}">
       $("#delMyQuerySet").remove();
       $("#saveMyQuerySet").remove();
       $.setFieldValueSubmit();
       search();
       </c:if>
       <c:if test = "${param.showResult ne 'true'}">
       if($("#queryModuleType").val()==2){
         $.setFieldValueSubmit();
          search();
       }
       </c:if>
     var from = "${ctp:escapeJavascript(from)}";
     if(from){//表单栏目进来的查询都删除我的XX按钮
       $("#delMyQuerySet").remove();
       $("#saveMyQuerySet").remove();
     }
     resetWidthUserFastCondition();
     adjustQueryHeight();
     resetWidthUserFastCondition();
     
     <c:if test = "${param.srcFrom ne 'bizconfig' and param.hidelocation eq 'true'}">
     try{
        getA8Top().hideLocation();
     }catch(eee){}
     </c:if>
     <c:if test="${param.showTopLabel eq 'true'}">
     getCtpTop().showMoreSectionLocation("${ctp:i18n('menu.formquery.label')}");
     </c:if>
    });
    function search(){
        var checkData = true;
        var queryModuleType = $("#queryModuleType").val();
        //OA-93655表单查询统计，先自定义模式下设置条件并增加1空行，然后切换到普通模式下，输入条件后点击查询统计按钮，还提示自定义条件不能为空。
        if(queryModuleType == "2"){
            if($(".fieldName").length>1){
                $(".fieldName").each(function(index){
                    var temValue = $(this).val();
                    if(temValue == ""){
                        $.alert("${ctp:i18n('form.query.defineConditionFieldNotNull')}");
                        checkData = false;
                        return false;
                    }
                });
            }
        }
        var checkValidate = true;
        var clearObj;
        if($("#queryModuleType").val() == 2){
            $("#userConditionTable :input").each(function (){
                var value = $(this).val();
                if($(this).attr("type") == "text" || $(this).attr("type") == "textarea"){
                    if(value != null && (value.indexOf("<") != -1 || value.indexOf(">") != -1)){
                        //BUG_重要_V5_V5.1sp1_北京嘀嘀无限科技发展有限公司_部门有“<”新建的时候不报错，查询的时候提示“条件中的输入值有特殊字符！”_20160119016434
                        var p = $(this).parent();
                        var fieldVal = $(p).attr("fieldVal");
                        var needCheck = true;
                        if(fieldVal != undefined){
                            fieldVal = $.parseJSON(fieldVal);
                            if(fieldVal.inputType == "member" || fieldVal.inputType == "account" || fieldVal.inputType == "department" || fieldVal.inputType == "post" ||
                                    fieldVal.inputType == "level" || fieldVal.inputType == "multimember" || fieldVal.inputType == "multiaccount" || fieldVal.inputType == "multidepartment" ||
                                    fieldVal.inputType == "multipost" || fieldVal.inputType == "multilevel"){
                                needCheck = false;
                            }
                        }
                        if(needCheck){
                            checkValidate = false;
                            clearObj = $(this);
                            return false;
                        }
                    }
                }
            });
        }
        if(checkValidate == true){
            if($("#queryModuleType").val() == 1){
                $("#userFastCondition :input").each(function (){
                    var value = $(this).val();
                    if($(this).attr("type") == "text" || $(this).attr("type") == "textarea"){
                    if(value != null && (value.indexOf("<") != -1 || value.indexOf(">") != -1)){
                        checkValidate = false;
                        clearObj = $(this);
                        return false;
                    }
                    }
                });
            }
        }
        if(!checkValidate){
            $.alert({'msg':"条件中的输入值有特殊字符！",ok_fn:function(){
                $(clearObj).val("");
            }
            });
            return;
        }
        if(!checkData){
            return;
        }
        if($("#queryModuleType").val()=="2"){
            if(!$.validateBrackets()){
                return;
            }
        }
        $("#queryTitle").text("${queryBean.name }");
        var showFieldList = $("#currentShowFields").val();
        var showList = $("#currentShowFieldNames").val();
        $("#resultTable").empty();
        $("#resultTable").append($("body").data("showTableObject").clone(true));
        showConditionDetail();
        resetTableTop("excQuery");
    
        if(showFieldList!=""){
            var fields = showFieldList.split(",");
            var names = showList.split(",");
            var col;
            var colData = new Array();
            for(var i=0;i<fields.length;i++){
                col = new Object();
                col.name=fields[i].substring(fields[i].indexOf(".")+1);
                col.width=getTHWidthTable(fields.length);
                col.display=getShowColName(names[i]);
                col.sortable=true;
                colData[colData.length] = col;
            }

            $("table.flexme1").ajaxgrid({
                click : clk,
                colModel: colData,
                managerName : "formQueryResultManager",
                managerMethod : "getQueryResult",
                usepager: true,
                showTableToggleBtn: false,
                isToggleHideShow:false,
                showToggleBtn: false,
                resizable:false,
                dataTable:true,
                render : rend,
                customId : "customId_${queryId}",
                customize:true,
                onSuccess:successFn,
                parentId:'center1'
            });

           var o = new Object();
           var userCondition = $("#userConditionTable").formobj({validate : false});
           $("tr","#userFastCondition").each(function(){//处理数据
               var ff = $("#user_fieldName",$(this));
               $.getFieldValueByInputType($(this),ff);
           });
           var userFastCon = $("#userFastCondition").formobj();
           var stateCon = $("#stateTr").formobj();
           var show = $("#showCol").formobj();
           o.userCondition = userCondition;
           o.userFastCon = userFastCon;
           o.stateCon = stateCon;
           o.show = show;
           o.baseInfo = $("#baseInfo").formobj();
           $("#queryInfo").val($.toJSON(o));
           var parm = {};
           parm.queryInfo = $("#queryInfo").val();
           $("table.flexme1").ajaxgridLoad(parm).width("");
           decentHeight = $("#center").height() - $($("table.flexme1").ajaxgrid().grid.bDiv).height();
           $($("table.flexme1").ajaxgrid()).attr("_decentHeight", decentHeight);
           //OA-63796
           $("#excQuery").focus();
        }
        //OA-98443公司协同：表单查询，当条件比较多的时候，查询结果显示区域滚动条翻页看不见
        adjustQueryHeight();
    }

    function rend(txt,rowData, rowIndex, colIndex,colObj) {
        var isUrl = false;
        var isDisImage = false;
        if(urlFieldList){
            for(i in urlFieldList){
                if(urlFieldList[i] == colObj.name){
                    isUrl = true;
                    break;
                }
            }
        }
        if(imageDisList){
            for(j in imageDisList){
                if(imageDisList[j] == colObj.name){
                    isDisImage = true;
                    break;
                }
            }
        }
        if(isUrl){
            return '<a class="noClick" href='+txt+' target="_blank">'+txt+'</a>';
        }else if(isDisImage && txt != ""){
            var imgSrc = _ctxPath+"/fileUpload.do?method=showRTE&fileId="+txt+"&expand=0&type=image";
            return "<img class='showImg' src='"+imgSrc+"' height=25 />";
        }else{
            return txt;
        }
    }

    function getShowColName(n){
        var charIndex = n.lastIndexOf("(");
      if(n.length==(n.lastIndexOf(")")+1)&&charIndex>0){
          n = n.substring(charIndex+1,n.length-1);
      }
      return n;
    }
    //处理显示能选择的状态按钮
    function propRadios(cont,va){
      cont.prop("checked",false);
      cont.prop("disabled",true);
      cont.each(function(){
       if(va.indexOf($(this).val())>=0){
        $(this).prop("checked",true);
       $(this).prop("disabled",false);
         }
        });
    }

    function propCurrentCondition(){
      var conDataMap = {};
      var show = '';
      var f = '';
      var showMap = new Properties();
      //自定义选项条件
      if($("#queryModuleType").val()==2){
          $("tr","#userConditionTable").each(function(i){
            var vl = getShow($(".fieldInputValue",$(this)));
            if(vl){
                var fieldName = $(":selected",$(".fieldName",$(this))).text()+':';
                if(showMap.containsKey(fieldName)){
                    showMap.put(fieldName,showMap.get(fieldName)+','+vl);
                }else{
                    showMap.put(fieldName,vl);
                }
            }
          });
      }
      //用户输入条件  下面的key中含有':'
      if($("#queryModuleType").val()==1){
        $("tr","#userFastCondition").each(function(i){
            var vl = getShow($("td:eq(1)",$(this)));
            if(vl){
                var text = $("td:eq(0)",$(this)).text();
                showMap.put(text,vl);
             }
         });
      }
      //处理各种状态
      <c:if test="${queryBean.formBean.formType == 1 }">
      //流程表单
      show = '';
      f = $(".finishedflag_class:checked");
      if(f.length<3){//流程状态少于3个时要显示出来
          f.each(function(i){
              if(i!=0){
                show = show + "," + $(this).parent().text(); 
              }else{
                show = $(this).parent().text(); 
              }
          });
          showMap.put('${ctp:i18n("formquery_sheetfinished.label")}'+':',show);
      }
      f = $(".state_class:checked");
      show = "";
      f.each(function(i){
          if(i!=0){
            show = show + "," + $(this).parent().text(); 
          }else{
            show = $(this).parent().text(); 
          }
      });
      showMap.put('${stateLabel.text }'+':',show);
      f = $(".ratify_class:checked");
      show = "";
      f.each(function(i){
          if(i!=0){
            show = show + "," + $(this).parent().text(); 
          }else{
            show = $(this).parent().text(); 
          }
      });
      showMap.put('${ratifyLabel.text}'+':',show);
      </c:if>
      //组织table
      show = '';
      if(!showMap.isEmpty()){
          show = '${ctp:i18n('form.query.label')}:'+'<table width="100%"  border="0" cellpadding="0" cellspacing="0">'
          var len = showMap.size();
          var keys = showMap.keys();
          for(var i = 0;i < len;i++){
             show = show +'<tr height="20">';
             for(var j = 0; j < 3; j++){
                 if(j!==0 && i < len-1){
                     i++;
                 }
                 if(i === len -1){
                     j=3;
                 }
                 show = show +'<td align="left" width="33%" class="font_size12 padding_0">'+keys.get(i)+escapeStringToHTML(showMap.get(keys.get(i)),false,false)+'</td>';
             }
             show = show +'</tr>';
          }
          show = show +'</table>';
      }
      conDataMap.condition=show;
      conDataMap.currentDate =currentDate;
      return conDataMap;
    }
    function showConditionDetail(){
        var conDataMap = propCurrentCondition();
        $("#queryDateTD").text("");
        $("#queryDateTD").text("${ctp:i18n('form.query.querydate')}: "+conDataMap.currentDate);
        if(conDataMap.condition!=""){
          $("#conditionTD").text("");
          $("#conditionTD").html(conDataMap.condition);
        }else{
          $("#conditionTD").html("&nbsp;");
        }
    }
    //重新定位列表的高度
    function resetTableTop(e){
        //$("#center1").css("top",($("#resultTableShow").height()+$("#resultButtomDiv").height())+"px");
        $("#center1").css("top",$("#resultButtomDiv").height()+"px");
        $("#center1").css("height",($("#center").height()-$("#resultButtomDiv").height())+"px");
    }
    function getShow(contain){
        var showObj = $(":input:visible",contain);
        var returnShowValue = "";
        var tName = showObj.prop("nodeName") == undefined ? showObj.prop("nodeName") : showObj.prop("nodeName").toLowerCase();
        if(tName=="select"){
          returnShowValue = $(":selected",showObj).text();
        }else if(tName=="input"){
            if(showObj.is(":radio")||showObj.is(":checkbox")){
              showObj.each(function(i){
                  if($(this).is(":checked")){
                      if(returnShowValue!=""){
                        returnShowValue = returnShowValue + "," + $(this).parent().text(); 
                      }else{
                        returnShowValue = $(this).parent().text(); 
                      }
                  }
                });
            }else{
              returnShowValue = showObj.val(); 
            }
        }else if(tName=="textarea"){
            $("textarea",contain).each(function(){//多组织控件
                if($(this).attr("id")!="" && $(this).attr("id")!=undefined){
                    if($(this).attr("id").indexOf("_txt")>0){
                        returnShowValue = $(this).val();
                    }
                }
            });
        }
        return returnShowValue;
    }
    
    function clk(data, r, c) {
       <c:if test="${rightStr != ''}">
        showFormData4Statistical(formType,data.id,"${rightStr}","${queryBean.name }",null,queryFormId,"${queryId }");
       </c:if>
    }
    function  initShowTable(){
        $("#queryTitle").text("${queryBean.name }");
    var showFieldList = $("#currentShowFields").val();
    var showList = $("#currentShowFieldNames").val();
    $("#resultTable").empty();
    $("#resultTable").append($("body").data("showTableObject").clone(true));
    resetTableTop();
    if(showFieldList!=""){
      var fields = showFieldList.split(",");
      var names = showList.split(",");
      var data = new Object();
      var dataFields = new Array();
      var field = new Object();var col;
      var colData = new Array();
      for(var i=0;i<fields.length;i++){
        col = new Object();
        eval("field.field"+i+"=''");
        //col.name="field"+i;
        col.name=fields[i].substring(fields[i].indexOf(".")+1);
        col.width=getTHWidthTable(fields.length);
        col.display=getShowColName(names[i]);
        colData[colData.length] = col;
      }
      dataFields[0] = field;
      dataFields[1] = field;
      dataFields[2] = field;
      dataFields[3] = field;
      data.rows = dataFields;

      $("table.flexme1").ajaxgrid({
          colModel: colData,
          usepager: true,
          datas:{},
          showTableToggleBtn: false,
          customId : "customId_${queryId}",
          customize:true,
          dataTable:true,
          resizable:false,
          parentId:'center1'
      });
      decentHeight = $("#center").height() - $($("table.flexme1").ajaxgrid().grid.bDiv).height();
      $($("table.flexme1").ajaxgrid()).attr("_decentHeight", decentHeight);
    }
  }
  function getTHWidthTable(thCount){
    if(thCount>=10){
      return "10%";
    }
    return 100/thCount+"%";
  }

  function saveMyQuery(){
    $("#sameName").val(0);
    var isSubmited=false;//防止因网络原因造成的多次提交，添加了判断。
    var dialog = $.dialog({
        htmlId : 'myQueryTable',
        title : "${ctp:i18n('form.query.myplan')}",
        width: "300px",
        height:"150px",
        buttons : [ {
          text : "${ctp:i18n('common.button.ok.label')}",
          id:"sure",
            isEmphasize: true,
          handler : function() {
            if(!$("#myQueryTable").validate({errorAlert:true,errorIcon:false})||isSubmited){
              return;
            }
            isSubmited=true;
            $.setFieldValueSubmit();
            //修改更新
            var myOldQueryName = $("#myOldQueryName").val();
            var myqueryVal = $("#myquery").val();
            if(myOldQueryName != "" && myOldQueryName == myqueryVal){
              $.confirm({
                'msg' : "${ctp:i18n('form.queryResult.cover.confirm.label')}",//确定覆盖原有的吗
                ok_fn : function() {
                    $("#sameName").val(1);
                    saveToSubmitMyQueryFunc(dialog,"${path }/form/queryResult.do?method=saveMyQuery");
                    isSubmited=true;
                },
                cancel_fn: function(){
                  isSubmited=false;
                }
             });
            }else{
                //新建 我的查询
                //校验是否已经存在同名的
                var fqrm = new formQueryResultManager();
                var params = new Object();
                params['planName'] = myqueryVal;
                params['planType'] = 1;
                params['queryId'] = $("#queryId").val();
                params['userId'] = '${CurrentUser.id}';
                fqrm.existsMyQuery(params,{
                    success : function(msg){
                        if(msg){
                            var win = new MxtMsgBox({
                                'type': 0,
                                'title':'${ctp:i18n("permission.prompt")}',//提示
                                'imgType':2,
                                'msg': "${ctp:i18n('form.queryResult.chongfu.label')}",//已有同名名称，请重命名
                                 ok_fn:function(){
                                    isSubmited=false;
                                    return;
                                 },
                                close_fn:function(){
                                    isSubmited=false;
                                    return;
                                }
                            });
                        }else{
                            saveToSubmitMyQueryFunc(dialog);
                        }
                    }, 
                    error : function(request, settings, e){
                        $.alert(e);
                    }
               });
                
            }
          }
        }, {
          text : "${ctp:i18n('common.button.cancel.label')}",
          id:"exit",
          handler : function() {
            dialog.close();
          }
        } ]
      });
  }
  function saveToSubmitMyQueryFunc(dialog,url){
    var url1 = url||"${path }/form/queryResult.do?method=saveMyQuery";
    $(":selected",$("#userConditionDiv")).prop("selected",true).attr("selected",true);
      $(".fieldValue",$("#userConditionDiv")).each(function(){
        $(this).prop("value",$(this).val()).attr("value",$(this).val());
      });
      $("#myConditionHtml").val($("#userConditionDiv").html());
      $("body").jsonSubmit({
          action : url1,
          domains : ["userConditionTable","showCol","myQueryTable","baseInfo","conditionDiv2"],
          debug : false,
          validate : false,
          beforeSubmit:function(){
              processBar =  new MxtProgressBar({text: "${ctp:i18n('form.query.savingMyQuery')}"});
          },
          callback : function(objs) {
              if(processBar!=undefined){
                  processBar.close();
              }
              dialog.close();
              if(parent.location.href.indexOf("queryResult.do")>-1){
                parent.location.href=parent.location.href;//"${path}/form/queryResult.do?method=queryIndex";
              }
          }      
      });
  }
  
  function setQueryModuleType(t){
    var saveMyQuerySet = $("#saveMyQuerySet");
    var delMyQuerySet = $("#delMyQuerySet");
    if(t==1){//自定义模式
      $("#advanceButton").text("[${ctp:i18n('form.query.custom.label')}]");
      $("#normalConditionTr").removeClass("hidden").addClass("hidden");
      $("#userFastCondition").removeClass("hidden");
      saveMyQuerySet.removeClass("common_button").removeClass("display_none").addClass("display_none");
      delMyQuerySet.removeClass("common_button").removeClass("display_none").addClass("display_none");
    }else if(t==2){//普通模式
      $("#advanceButton").text("[${ctp:i18n('form.query.normal.label')}]");
      $("#userFastCondition").removeClass("hidden").addClass("hidden");
      $("#normalConditionTr").removeClass("hidden");
      saveMyQuerySet.removeClass("common_button").addClass("common_button").removeClass("display_none");
      delMyQuerySet.removeClass("common_button").addClass("common_button").removeClass("display_none");
      isAutoReset = true;
      $("#conditionReset").trigger("click");//重新调一次普通模式的重置，不然普通模式下的select宽度有问题。
    }
  }

  function printQuery(){
    var printColBody= "${ctp:i18n('common.toolbar.content.label')}";
    //去掉表格区域的静态布局，否则在打印页面显示混乱布局，获取内容后再恢复该样式
    //$("#center1").removeClass("stadic_body_top_bottom");
    //$("#center1").removeClass("stadic_layout_body");
    var rt = $('#resultTableShow').clone();
    var c = $("#center1").clone();
    c.removeClass("stadic_body_top_bottom").removeClass("stadic_layout_body");
    rt.append("<tr><td>"+c.html()+"</td></tr>");
    rt.find("div.text_overflow").each(function(){
      //打印页面对列表做了特殊处理，将td下子节点的内容直接拷贝到TD中，所以td下的<div>样式会全部丢失，在空行中行高样式丢失
      //所以 如果单元格内容为空，则使用 &nbsp;填充一个空格占位
      if($(this).html()==""){
        $(this).html("&nbsp;");
      }
    });
    var colBody =  "<table id=\"resultTableShow\" width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"+rt.html()+"</table>"; 
   // $("#center1").addClass("stadic_body_top_bottom");
    //$("#center1").addClass("stadic_layout_body");
    var colBodyFrag = new PrintFragment("", colBody);

    var cssList = new ArrayList();
    var pl = new ArrayList();
    pl.add(colBodyFrag);
    printList(pl,cssList);
  }
  function transColl(){
      var cdiv = $("#_transCollContentHandle");
        cdiv.children().remove();
        var tb = $("<table width='100%' class='border_all' style='border-collapse: collapse'></table>"), rt = $("#center1");
        //cdiv.append(tb);
        tb.append($(".hDiv table thead", rt).clone()).append($(".bDiv table tbody", rt).clone());
        $("thead tr",tb).css("background-color","#EEEEEE");
        $("thead tr th",tb).addClass("border_all");
        $("tbody tr td",tb).addClass("border_all");
        //转发协同的时候去掉行事件
      tb.find("th,tr").each(function(){
          $(this).removeAttr("onmousedown").removeAttr("onmouseup").removeAttr("onclick").removeAttr("onmouseenter").removeAttr("onmouseleave");
      });
        //添加标题  表单条件 名称 日期
        var tranTable = $("#resultTableShow").clone();
        var tTd = $("<td></td>");
        var tTr = $("<tr></tr>");
        tranTable.append(tTr);
        tTr.append(tTd);
        tTd.append(tb);
        cdiv.append(tranTable);
        //转发协同时去掉手型的样式
        cdiv.find("#list").removeAttr("class");
      /*
      $("#bodyContent").val(cdiv.html());
        $("#transQueryId").val($("#queryId").val());
        $("#colTitle").val($("#queryTitle").text());

        var tarWin = window;
        var isModelOpen = false;//是否是模态对话框弹出
        try{
          tarWin = top.$("#main")[0].contentWindow;
        }catch(e){
            tarWin = window.opener.top.$("#main")[0].contentWindow;
            isModelOpen = true;
        }
        $("#trans").jsonSubmit({targetWindow:tarWin});
        try{
            if(isModelOpen){
              this.close();
              window.dialogArguments.closeDialog();
            }
        }catch(e){}*/
      collaborationApi.newColl({
          subject : $("#queryTitle").text()+' '+propCurrentCondition().currentDate,// 协同标题, 默认：""
          bodyType : '10',// 正文类型，MainbodyType, 默认 : 10
                            //HTML(10),
                            //FORM(20),
                            //TXT(30),
                            //OfficeWord(41),
                            //OfficeExcel(42),
                            // WpsWord(43),
                            //WpsExcel(44),
                            //Pdf(45);
          bodyContent : cdiv.html(),// 正文内容,默认:''
                            //HTML正文:传入HTML内容
                            //Office等正文：传入正文ID
          manual : "false",//是否通过后台代码设置协同正文, 默认: false
                            //true : 正文内容通过JAVA代码设置，关联
                            //        关联handlerName属性
                            //false:正文内容由bodyType和bodyContent
                            //        置
          personId : '',// 流程人员ID，目前只有人员卡片用到
          from : '',// 来源，保留属性，暂时没有用到
          handlerName : '',//继承NewCollDataHandler获取转协同数据的处理
          sourceId : '',// 业务ID，用于获取数据, 如会议的meetingId
          ext : ''// 扩展信息，用于sourceId不满足业务处理时的扩展，非必填
      });
  }
  var cw = null;
  function resetWidthUserFastCondition(){
      var hasHide = false;
      if($("#userFastCondition").hasClass("hidden")){
          hasHide = true;
          $("#userFastCondition").removeClass("hidden");
      }
      cw = cw||parseInt($('table:eq(0)', "#userFastCondition").width()*40/100);
      $('.comp', "#userFastCondition").each(function(){
          var $t = $(this), ct = $t.attr('comp');
          if(ct && ct != '') {
          var j = $.parseJSON('{'+ct+'}');
          if(j.type == 'selectPeople'||j.type=='chooseProject' || j.type == 'fastSelect') {
            $t.css('height', '20px').css('width', (cw-30)+"px");
              if(j.type == 'fastSelect') {
                  $t.parent().find(".select2-container").css("width", (cw-30)+"px").find(".select2-search__field").css("width", "100%");
              }
          }
          }
        });
        if(hasHide){
            $("#userFastCondition").addClass("hidden");
        }
  }
  function successFn(){
      //处理图片宽度超过单元格大小
      $(".showImg").each(function(){
          var _image = $(this);
          if (_image.width() > _image.parent().width()) {
              _image.width(_image.parent().width());
          }
          _image.on('load', function() {
              if (_image.width() > _image.parent().width()) {
                  _image.width(_image.parent().width());
              }
          });
      });
  }
</script>
<style>
  .stadic_head_height{
            height:105px;
        }
        .stadic_body_top_bottom{
          bottom: 0px;
            top: 105px;
        }
</style>
</head>
<body class="h100b overflow_hidden page_color border_t" id="layout">
    <c:if test = "${param.srcFrom eq 'bizconfig' }">
        <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
    </c:if>
    <div id="baseInfo" class="hidden">
        <input id="formId" value='${queryBean.formBean.id }'>
        <input id="type" value="${type }">
        <input id="queryId" value="${queryId }">
        <input id="queryModuleType" value=2 type='hidden'>
    </div>
    <div class="layout_north" id="north" style="display: block">
        <div class="form_area set_search  margin_5" >
            ${ctp:i18n('form.query.label')}:<!-- 查询条件 -->
            <table width="100%" height="100px" border="0" cellspacing="0" cellpadding="0" align="center" id="allDataTable">
                <tr height="10px" id="moduleTr" class="hidden">
                    <td align="right" class="margin_r_5">
                        <!-- 自定义模式 -->
                        <a style="width:120px;cursor: pointer;" id="advanceButton">[${ctp:i18n('form.query.custom.label')}]</a>
                    </td>
                </tr>
                <tr>
                    <td width="60%" valign="top">
                        <fieldset class="fieldset_box margin_t_5">
                            <!-- 输入条件 -->
                            <legend>${ctp:i18n('form.query.condition.label')}:</legend>
                            <div style="height:70px;overflow-x:hidden;overflow-y:auto;" id="conditionDiv2">
                                <table width="100%" >
                      <tr id="normalConditionTr">
                          <td>
                            <div id="userConditionDiv"></div>
                          </td>
                      </tr>
                      <tr id="userFastCondition" isGrid='true'>
                          <td>${userFieldTable }</td>
                      </tr>
                      <tr id="stateTr" <c:if test="${queryBean.formBean.formType != 1 }">class='hidden'</c:if>>
                          <td>
                              <!-- finishedflag:0=未结束→finishedflag:1=已结束→finishedflag:3=终止
                              →state:0=草稿→state:1=未审核→state:2=审核通过→state:3=审核不通过
                              →ratifyflag:0=未核定→ratifyflag:1=核定通过→ratifyflag:2=核定不通过 -->
                              <div class="common_checkbox_box clearfix padding_tb_5">
                                  ${ctp:i18n('formquery_sheetfinished.label')}：<!-- 流程状态 -->
                                  <label class="margin_r_10 hand" for="finishedflag0"> 
                                  <!-- 未结束 -->
                                  <input id="finishedflag0" class="radio_com finishedflag_class" name="finishedflag0"
                                    checked="checked" value="0" type="checkbox">${ctp:i18n('formquery_finishedno.label')}</label> 
                                  <label class="margin_r_10 hand" for="finishedflag1"> 
                                  <!-- 已结束 -->
                                  <input id="finishedflag1" class="radio_com finishedflag_class" name="finishedflag1"
                                    checked="checked" value="1" type="checkbox">${ctp:i18n('formquery_finished.label')}</label> 
                                  <label class="margin_r_10 hand" for="finishedflag3"> 
                                  <!-- 终止 -->
                                  <input id="finishedflag3" class="radio_com finishedflag_class" name="finishedflag3"
                                    checked="checked" value="3" type="checkbox">${ctp:i18n('formquery_stop.label')}</label> 
                                  <!-- 单据状态 -->
                                  <a href="javascript:void(0)" id="formStateHref">[${ctp:i18n('form.query.sheetstatus.label')}]</a>
                              </div>
                              <div class="common_checkbox_box clearfix hidden" id="formStateDiv">
                                  <div>
                                      ${stateLabel.text }：
                                      <label class="margin_r_10 hand" for="state0"> 
                                      <!-- 草稿 -->
                                      <input id="state0" class="radio_com state_class" name="state0" value="0" type="checkbox">${ctp:i18n('form.query.draft.label')}
                                      </label>
                                      <label class="margin_r_10 hand" for="state1"> 
                                          <!-- 未审核 -->
                                          <input checked="checked" id="state1" class="radio_com state_class" name="state1" value="1" type="checkbox">${ctp:i18n('form.query.nodealwith.label')}
                                      </label>
                                      <label class="margin_r_10 hand" for="state2"> 
                                          <!-- 审核通过 -->
                                          <input checked="checked" id="state2" class="radio_com state_class" name="state2" value="2" type="checkbox">${ctp:i18n('form.query.passing.label')}
                                      </label>
                                      <label class="margin_r_10 hand" for="state3"> 
                                          <!-- 审核不通过 -->
                                          <input checked="checked" id="state3" class="radio_com state_class" name="state3" value="3" type="checkbox">${ctp:i18n('form.query.nopassing.label')}
                                      </label>
                                  </div>
                                  <div class="common_checkbox_box clearfix padding_t_5">
                                      ${ratifyLabel.text }：
                                      <label class="margin_r_10 hand" for="ratifyflag0"> 
                                          <!-- 未核定 -->
                                          <input checked="checked" id="ratifyflag0" class="radio_com ratify_class" name="ratifyflag0" value="0" type="checkbox">${ctp:i18n('form.query.noapproved.label')}
                                      </label>
                                      <label class="margin_r_10 hand" for="ratifyflag1"> 
                                          <!-- 核定通过 -->
                                          <input checked="checked" id="ratifyflag1" class="radio_com ratify_class" name="ratifyflag1" value="1" type="checkbox">${ctp:i18n('flowBind.vouch.pass')}
                                      </label>
                                      <label class="margin_r_10 hand" for="ratifyflag2">
                                          <!-- 核定不通过 --> 
                                          <input checked="checked" id="ratifyflag2" class="radio_com ratify_class" name="ratifyflag2" value="2" type="checkbox">${ctp:i18n('form.query.noapprovedpass.label')}
                                      </label>
                                  </div>
                              </div>
                         </td>
                    </tr>
              </table>
              </div>
            </fieldset>
          </td>
          <td width="40%" valign="top">
              <fieldset class="fieldset_box margin_l_10 margin_t_5" id="showCol">
              <!-- 查询设置 -->
              <legend>${ctp:i18n('form.pagesign.queryconfig.label')}</legend>
              <input id="showFields" type="hidden">
              <input id="showFieldNames" type="hidden" hideText="showFields">
              <input id="oldOrderByNameList" type="hidden">
              <input id="oldOrderByShowList" type="hidden" hideText="oldOrderByNameList">
              <div class="common_txtbox clearfix margin_5">
                  <label class="margin_r_10 left title" for="text">${ctp:i18n('form.query.querydisplayfieldset.label')}:</label>
                  <label class="margin_l_10 right">
                       <a class="common_button common_button_gray valign_m" href="javascript:void(0)" id="showFieldBn">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                  </label>
                  <div class="common_txtbox_wrap">
                      <input id="currentShowFields" type="hidden">
                      <input type="text" id="currentShowFieldNames" readonly="readonly" datafiledId="showFieldNames" mytype="7" hideText="currentShowFields"/>
                  </div>
              </div>
              <div class="common_txtbox clearfix margin_5">
                  <label class="margin_r_10 left title" for="text">${ctp:i18n('form.query.queryresultsort.label')}:</label>
                  <label class="margin_l_10 right">
                       <a class="common_button common_button_gray valign_m" href="javascript:void(0)" id="sortOrderBn">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                  </label>                  
                  <div class="common_txtbox_wrap">
                      <input id="orderByNameList" type="hidden">
                      <input type="text" id="orderByShowList" readonly="readonly" datafiledId="showFieldNames" mytype="5" hideText="orderByNameList"/>
                  </div>
              </div>
            </fieldset>
          </td>
        </tr>
      </table>
      <div class="align_center clear">
            <!-- 查询 -->
            <a class="common_button common_button_emphasize margin_r_10" href="javascript:void(0)" id="excQuery">${ctp:i18n('form.query.querybutton')}</a>
            <!-- 重置 -->
            <a class="common_button margin_r_10" href="javascript:void(0)" id="conditionReset">${ctp:i18n('form.compute.reset.label')} </a>
            <c:if test="${fieldSize > 0 }">
                <!-- 保存我的查询 -->
                <a class="common_button margin_r_10" href="javascript:void(0)" id="saveMyQuerySet" >
                    ${ctp:i18n('form.query.save.label')}${ctp:i18n('form.query.myplan')}
                </a>
            </c:if>
            <c:if test="${type eq 'myQuery' }">
                <!-- 删除我的查询 -->
                <a class="common_button margin_r_10" href="javascript:void(0)" id="delMyQuerySet">
                    ${ctp:i18n('form.datamatch.del.label')}${ctp:i18n('form.query.myplan')}
                </a>
            </c:if>
    </div>
    </div>
  </div>
  <!--查询设置end-->
    <div class="layout_center over_hidden" id="center">
          <div class="stadic_layout_head stadic_head_height" >
            <div class="padding_lr_5" id="resultButtomDiv">
            <table border="0" cellpadding="0" cellspacing="0" class="common_toolbar_box" width="100%">
            <tr><td>
            <span class="left">
              <span class="left margin_t_5 font_size12">${ctp:i18n('form.query.queryresult.label')}：</span><!-- 查询结果 -->
              <a class="img-button margin_r_5 font_size12" href="javascript:void(0)" id="transColButton">
                  <em class="ico16 forwarding_16"></em>${ctp:i18n('form.query.col.transubmit.label')}<!-- 转发协同 -->
              </a> 
              <a class="img-button margin_r_5 font_size12" href="javascript:void(0)" id="exportQueryResult">
                  <em class="ico16 export_excel_16"></em>${ctp:i18n('common.toolbar.exportExcel.label')}<!-- 导出EXCEL -->
              </a> 
              <a class="img-button margin_r_5 font_size12" href="javascript:void(0)" id="queryPrint">
                  <em class="ico16 print_16"></em>${ctp:i18n('common.toolbar.print.label')}<!-- 打印 -->
              </a> 
            </span>
            </td></tr>
            </table>
                <table id="resultTableShow" width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td id="queryTitle" align="center" style="text-align:center;font-size: 12px;"></td>
              </tr>
              <tr>
                <td align="center">
                <table width="100%" id="conditionDetailTable" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2" width="66%"></td>
                        <td id="formNameTD" align="left" width="34%" class="font_size12 padding_0" >
                        <!-- 表单名称： -->
                        ${ctp:i18n("form.base.formname.label")}: ${queryBean.formBean.formName }
                      </td>
                    </tr>
                    <tr>
                        <td colspan="2" width="66%"></td>
                        <td id="queryDateTD" align="left" width="34%" class="font_size12 padding_0"></td>
                    </tr>
                    <tr>
                        <td id="conditionTD" colspan="3"  align="left" width="100%" class="font_size12 padding_0">&nbsp;</td>                  
                    </tr>
                </table>
                </td>
              </tr>
            </table>
            </div>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom" style="overflow-y:hidden;" id="center1">
                <div class="search_result clear h100b" style="background: #fff;" id="resultTable">
                    <table class="flexme1">
                    </table>
                </div>
            </div>
    </div>
<div class="hidden form_area" id="myQueryTable" width="90%" height="100%" style="margin-top: 45px;">
    <div class="left" style="text-align: right;height: 24px;line-height: 24px;width: 100px;"><input id="myqueryId" class="hidden" value="${queryId }">
    <input id="sameName" class="hidden" value="0">
    <input id="myOldQueryName" class="hidden" value='${type == "myQuery" ? queryBean.name : "" }'>
    <input id="myConditionHtml" class="hidden">${ctp:i18n('form.query.myplan')}：</div>
    <div class="common_txtbox_wrap left" ><input value='${type == "myQuery" ? queryBean.name : "" }' id="myquery" name="${ctp:i18n('form.query.myplan')}" validate="type:'string',notNull:true,maxLength:60,avoidChar:'\\\'&&quot;&lt;&gt;'" class="validate"></div>
</div>
<form action="${path}/form/queryResult.do?method=transCol" target="parent" id="trans" class="hidden">
  <input id="bodyContent" /> <input id="transQueryId" /> <input id="colTitle" />
</form>
<div id="exportResult" class="hidden">
    <input id="queryExportName" value="${queryBean.name }" type="hidden">
    <input id="queryInfo" type="hidden" />
</div>
<iframe id="exportQueryResultIframe" class="hidden" name="exportQueryResultIframe"></iframe>
<div id="_transCollContentHandle" style="display:none"></div>
</body>
</html>