<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016-1-6 0006
  Time: 19:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
    var dialogArg = window.dialogArguments;//所有参数
    var callback = dialogArg.callback;//父页面对象
    var formulaStr = dialogArg.formulaStr;
    $().ready(function() {
        copySelect2Hidden("dataToSelect0","dataToSelect0_bak");
        copySelect2Hidden("dataToSelect1","dataToSelect1_bak");
        copySelect2Hidden("dataToSelect2","dataToSelect2_bak");
        copySelect2Hidden("dataToSelect3","dataToSelect3_bak");
        $("#serachbtn").click(function(){
            var index = $("#dataItem").val();
            var select = $("#dataToSelect"+index);
            searchPre(select,$("#dataToSelect"+index+"_bak"),$("#searchValue").val());
        });
        $("#searchValue").keyup(function(event) {
            if (event.keyCode == 13) {
                var index = $("#dataItem").val();
                var select = $("#dataToSelect"+index);
                searchPre(select,$("#dataToSelect"+index+"_bak"),$("#searchValue").val());
            }
        });
        $("#select_selected").click(function (){
            selectToRight();
        });
        $("#selectarea").dblclick(function (){
            selectToRight();
        });
        $("#select_unselect").click(function (){
            deleteOption();
        });
        $("#hasSelect").dblclick(function (){
            deleteOption();
        });
        $("#sort_up").click(function (){
            sortItem("up");
        });
        $("#sort_down").click(function (){
            sortItem("down");
        });
        init();
    });
    //回填已设置的内容
    function init(){
        try{
            var obj = $.parseJSON(formulaStr);
            var content = obj.content;
            fillBackContent(content);
            $("#barcodeType").val(obj.barcodeType);
            $("#correctionOption").val(obj.correctionOption);
            $("#sizeOption").val(obj.sizeOption);
            if(obj.encrypt == "1"){
                $("#encrypt").attr("checked","checked");
            }
        }catch(e){}
    }
    //回填二维码内容组成项
    function fillBackContent(content){
        var arr = content.split('|');
        var innerStr = "";
        for(var i = 0,len = arr.length;i<len;i++){
            $("#bakarea").find("option[value='"+arr[i]+"']").each(function(){
                $("#hasSelect").append(this);
            });
        }
    }
    //数据域选项改变事件
    function selectDataArea(obj){
        var index = $(obj).val();
        $("div[id^='itemarea']").css("display","none");
        $("#itemarea"+index).css("display","block");
    }
    //将所有数据域的下拉备份到隐藏域，供查询用
    function copySelect2Hidden(oldId,newId) {
        var newObj = $("#"+oldId).clone(true);
        newObj.attr("id",newId);
        newObj.addClass("hidden");
        $("#bakarea").append(newObj);
    }
    function searchPre(select, backSelect, val){
        var options = backSelect.find("option");
        search(select,options,val);
    }

    function search(target,options, value) {
        var leaveOptios = [];
        options.each(function(){
            var text = this.text;
            if (text && text.indexOf(value) != -1){
                leaveOptios[leaveOptios.length] = $(this).clone(true);
            }
        });
        $("option",target).each(function(){
            $(this).remove();
        });
        for (var i=0; i < leaveOptios.length; i++) {
            var o = leaveOptios[i];
            target.append(o);
        }
    }
    //选择
    function selectToRight(){
        var index = $("#dataItem").val();
        var rightObjs = $("#dataToSelect"+index).find("option:selected");
        var canSelectArray = new Array;
        var leftObjs = $("#hasSelect").find("option");
        //$("#selectarea")[0].selectedIndex;
        if(rightObjs.length != 0){
            for(var i = 0;i<rightObjs.length;i++){
                var inRight = false;
                for(var j = 0;j<leftObjs.length;j++){
                    if(rightObjs[i].value == leftObjs[j].value){
                        //$.alert('['+rightObjs[i].text+']'+"${ctp:i18n('form.unique.marked.fieldisexits')}");
                        //return;
                        inRight = true;
                        continue;
                    }
                }
                if(!inRight){
                    canSelectArray.push(rightObjs[i]);
                }
            }
            var innerStr = "";
            for(var n = 0;n<canSelectArray.length;n++){
                innerStr += '<option value="'+canSelectArray[n].value+'" title="'+canSelectArray[n].text+'">'+canSelectArray[n].text+'</option>';
            }
            $("#hasSelect").append(innerStr);
        }
    }
    //删除已选
    function deleteOption(){
        var leftObjs = $("#hasSelect");
        removeOption(leftObjs);
    }
    //循环删除选中的多个项
    function removeOption(selObj) {
        if (selObj[0].selectedIndex > -1) {
            selObj[0].remove(selObj[0].selectedIndex);
            removeOption(selObj);
        }
    }
    //排序
    function sortItem(flag){
        var selectedObj = $("#hasSelect").find("option:selected");
        if(selectedObj.length == 1){
            if(flag == "up"){
                if($("#hasSelect")[0].selectedIndex > 0){
                    var temp = $(selectedObj).prev();
                    temp.before(selectedObj);
                }
            }else if(flag == "down"){
                if($("#hasSelect")[0].selectedIndex < ($("#hasSelect")[0].options.length-1)){
                    var temp = $(selectedObj).next();
                    temp.after(selectedObj);
                }
            }
        }else if(selectedObj.length > 1){
            $.alert("${ctp:i18n('form.format.flowprocessoption.onlymoveone')}");
        }
    }
    //确认
    function OK(){
        var content="";
        $("#hasSelect").find("option").each(function(){
            content = content + $(this).val()+"|";
        });
        content = content.substring(0,content.length-1);
        var barcodeType = $("#barcodeType").val();
        var correctionOption = $("#correctionOption").val();
        var sizeOption = $("#sizeOption").val();
        var encrypt = $("#encrypt").attr("checked") == "checked"?1:0;
        var resultObj = "{'content':'"+content+"','barcodeType':'"+barcodeType+"','correctionOption':'"+correctionOption+"','sizeOption':'"+sizeOption+"','encrypt':'"+encrypt+"'}";
        return callback(resultObj);
    }
</script>
