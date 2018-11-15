<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var v3x = new V3X();
var selectNode = -1;
$(document).ready(function(){
    $("#struction").tooltip({
      event:true,
      openAuto:false,
      width:400,
      htmlID:'operInstructionDiv',
      targetId:'struction'
    });
    $("#operInstructionDiv").show();
    var catg = new Array();
    <c:forEach items="${category}" var="item">
    catg.push({text:"${fn:escapeXml(item.name)}",value:"${item.id}"});
    </c:forEach>
    if(catg.length == 0){
      catg.push({text:"",value:""});
    }
    new MxtLayout({
        'id' : 'layout',
        'northArea' : {
          'id' : 'north',
          'height' : 70,
          'sprit' : false,
          'border' : false
        },
        'centerArea' : {
          'id' : 'center',
          'border' : false
        },
        'successFn' : function() {
        }
      });
    var searchobj = $.searchCondition({
        top:33,
        left:10,
        searchHandler: function(){
          $("#type").val("showAll");
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            var value = "";
            if(choose === 'subject'){
                value =  $('#names').val();
            }else if(choose === 'categoryId'){
                value = $('#categorys').val();
            }else{
              choose === 'subject';
            }
            $("#selectType").val(choose);
            $("#value").val(value);
            $("#option").val($("#templateCategory").val());
            $("#searchForm").jsonSubmit({
              targetWindow:document.getElementById('allColumnsIFrame').contentWindow
            });
        },
        conditions: [{
            id: 'names',
            name: 'names',
            type: 'input',
            text: '${ctp:i18n('formsection.config.template.name')}',//标题
            value: 'subject'
        }, {
            id: 'categorys',
            name: 'categorys',
            type: 'select',
            text: '${ctp:i18n('formsection.config.template.category')}',//重要程度
            value: 'categoryId',
            items: catg
        }]
    });
    
    $("#selectColumns").dblclick(function(){
        delTemplate();
    });
    $("#selectColumns").click(function(){
        $("option","#selectColumns").each(function(i){
            if ($(this).attr("selected")){
                selectNode = i;
                return false;
            }
        });
    });
});
function OK(param){
    var value = "";
    var name = "";
    <c:set var="msg" value="${ctp:i18n('formsection.config.choose.template.length')}" /> 
    if($("#selectColumns option").length > 15){
      $.alert('${msg}'+$("#selectColumns option").length);
      return "length";
    }
    
    $("#selectColumns option").each(function(){
        value=value+$(this).val()+",";
        name=name+$(this).text()+",";
    });
    if($("#selectColumns option").length < 1){
        return "must";
    }
    var o = new Object();
    o.value = value.substring(0,value.length-1);
    o.name = name.substring(0,name.length-1);
    return o;
}

function moveColumn(type){
    if (selectNode == -1){
        return;
    }
    if ($("#selectColumns option").length == 1){
        return;
    }
    var selectTemplate = $($("#selectColumns option").get(selectNode)); 
    var temp;
    if(type == "next"){
        if (selectNode == $("#selectColumns option").length-1){
            return;
        }
        var nextNode = selectTemplate.next();
        nextNode.after(selectTemplate.clone());
        selectTemplate.remove();
        selectNode++;
    }else{
        if (selectNode == 0){
            return;
        }
        var nextNode = selectTemplate.prev();
        nextNode.before(selectTemplate.clone());
        selectTemplate.remove();
        selectNode--;
    }
    $("#selectColumns").get(0).selectedIndex = selectNode;
    refresh();
}

function delTemplate(){
    $("#selectColumns option:selected").remove();
    refresh();
}

function refresh(){
     var html = $("#selectedColumns").html();
     $("#selectColumns").remove();
     $("#selectedColumns").html(html);
     $("#selectColumns",$("#selectedColumns")).unbind("click").bind("click",function(){
       $("option","#selectColumns").each(function(i){
         if ($(this).attr("selected")){
             selectNode = i;
             return false;
         }
     });
     });
     $("#selectColumns",$("#selectedColumns")).unbind("dblclick").bind("dblclick",function(){
       delTemplate();
     });
}

function changeTemplateCategory(category){
    $("#templateCategory").val(category)
    window.open('${path}/form/formSection.do?method=searchTemplateTree&type=showAll&selectType=&value=&option='+category,'allColumnsIFrame');
}

function addTemplate(node){
    if(node.isParent){
        var subNodes = node.children;
        if (subNodes){
            for(var i=0;i<subNodes.length;i++){
                if(!isExist(subNodes[i])){
                    addTemplate(subNodes[i]);
                }
            }
        }
    }else{
        if(!isExist(node) && node.data.canSelecte=="true"){
            $("#selectColumns").append("<option value = \"" + node.data.value +"\">" + node.data.name + "</option>");
            refresh();
        }
    }
}

function isExist(node){
    if($("option[value="+node.data.value+"]","#selectColumns").get(0)){
        return true;
    }
    return false;
}

function showOperDetailInfo() {
    var infoContent;
    var postionX;
    var postionY;
    //infoContent = "${ctp:i18n('formsection.config.operinstruction.info2')}";
    postionX = parseInt(window.event.clientX);
    postionY = parseInt(window.event.clientY) + 10;
    $("#operInstructionDiv").css("top",postionY + parseInt(document.body.scrollTop));
    $("#operInstructionDiv").css("left",postionX);
    $("#operInstructionDiv").html(infoContent);
    showOrHideOperInstruction('true');
}
function showOrHideOperInstruction(show) {
    document.getElementById('operInstructionDiv').style.display = show=="true" ? "block" : "none";
}

function selectTreeNode(){
	allColumnsIFrame.selectColumn(true);
}
</script>