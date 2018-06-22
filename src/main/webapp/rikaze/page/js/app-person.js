;
var isMock = false;
function showPersonSummary(id){
  
    var member = member_cache["id:"+id];
    if(member){
        return;
        modalWin.open();
        $("#modalWin").show();
    }
   

}
var member_cache={};
var max_person_num = 5;
function renderPeopleSpan(data){
    member_cache={};
    if(data&&data.items&&data.items.length>0){
        //人员照片下显示名字，联系方式和邮箱
       // console.log(data.items);
        var tag =0;
        var htmls =[];
        $(data.items).each(function(index,item){
          //  console.log(item);
            member_cache['id:'+item.memberId] = item;
            if(htmls.length == 0){
                htmls.push("<li><div class='marginTop38'><div class='w999'>");
            }
            if(tag>=max_person_num){
                tag = 0;
               htmls.push("</div></div></li><li><div class='marginTop38'><div class='w999'>");
                
            }
            htmls.push('<dl><dt><a style="cursor:pointer" onclick="showPersonSummary(\''+item.memberId+'\')" target="_blank"><img src="'+item.avtar+'" width="128" height="148"></a></dt>');
            htmls.push('<dd><a style="cursor:pointer;font-size:18px" onclick="showPersonSummary(\''+item.memberId+'\')" target="_blank">'+item.memberName+'</a></dd>');
            htmls.push('<dd style="float:left">联系方式:'+item.v3xOrgMember.properties.officenumber+'</dd><br>');
            htmls.push('<dd style="float:left">邮箱:'+item.v3xOrgMember.properties.emailaddress+'</dd>');
            htmls.push('</dl>');
            tag++;
        });
        htmls.push("</div></div></li>");
        $("#container_ul").html(htmls.join(""));
    }else{
        $("#container_ul").html("");
    }
}
function showDepartmentMembers(deptId,deptName){
    $("#deptNameSpan").html(deptName);
    if(isMock){
        var p_mock_data = person_json;
            renderPeopleSpan(p_mock_data);
    }else{
        $.get(BASE_PERSON_URL+deptId,function(data){
            renderPeopleSpan(data);
        });

    }


}
var modalWin = null;

var BASE_PERSON_URL="/seeyon/rikaze.do?method=getDepartmentMemberList&deptId=";

var BASE_DEPARTMENT_URL="/seeyon/rikaze.do?method=getDepartmentListGroupByAccount";

$(document).ready(function(){

    modalWin  = new Custombox.modal({
        content: {
            effect: 'fadein',
            target: '#modalWin'
        }
    });
    $(".cs-header-close").click(function(){
        $("#modalWin").hide();
        Custombox.modal.close();

    });
    $(".cs-footer-btn").click(function(){

      $("#modalWin").hide();
            Custombox.modal.close();
    });
    function renderDepartment(data){
        // console.log(data+data&&data.items&&data.items.length>0);
        if(data&&data.items&&data.items.length>0){
            var items = data.items;
            $(items).each(function(index,item){
                var depts = item.depts;
                if(depts&&depts.length>0){
                    var htmls=[];
                    var seed = null;
                    $(depts).each(function(index,item){
                        htmls = loadDeptSpan(item,htmls);
                        if(seed ==null){
                            seed = item;
                        }
                    });
                    $("#departmentList").html(htmls.join(""));
                    if(seed){
                        showDepartmentMembers(seed.deptId,seed.deptName);
                    }
                  
                }
            });
        }
    }
    function loadDepartment(){
        if(isMock){
            var mock_data = dept_json;
            renderDepartment(mock_data);
        }else{
            $.get(BASE_DEPARTMENT_URL,function(data){
                renderDepartment(data);
            });
        }
    }
    function loadDeptSpan(item,htmls){
        htmls.push('<div class="column box box1">');
        htmls.push('<a  target="_blank" style="cursor:pointer" onclick="showDepartmentMembers(\''+item.deptId+'\',\''+item.deptName+'\')" title="'+item.deptName+'">'+item.deptName+'</a></div>');
        return htmls;
    }
    loadDepartment();

});