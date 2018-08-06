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

function renderDeptThreeHtml(key){


    var r_depts = [];
    var depts = window.LevelFour;

    for(var p in depts){
        var dept = depts[p];

        if(dept.parentPath == key){
            r_depts.push(dept);
        }
    }
    var htmls=[];
    r_depts.sort(function(o1,o2){
        return o1.path.localeCompare(o2.path);
    });

    htmls.push("<ol style='display:block;cursor:pointer'>");
    var trigger = null;
    for(var k in r_depts){

        var dept = r_depts[k];
        if(trigger==null){
            trigger={};
            trigger.deptId=dept.deptId;
            trigger.deptName=dept.deptName;
            trigger.path=dept.path;
        }
        htmls.push("<li class='more_left_li_p' onclick='showDepartmentMembers(\""+dept.deptId+"\",\""+dept.deptName+"\",\""+dept.path+"\")'><a>"+dept.deptName+"</a></li>");
    }
    htmls.push("</ol>");
    $(".deptTwo").html("");
    $("#two"+key).html(htmls.join(""));
    showDepartmentMembers(trigger.deptId,trigger.deptName,trigger.deptName);
}

var member_cache={};
var max_person_num = 4;
function renderPeopleSpan(data){
    member_cache={};
    function addHtmls(items){
        var tag =0;
        var htmls =[];
        $(items).each(function(index,item){
            //  console.log(item);

              member_cache['id:'+item.memberId] = item;

              if(htmls.length == 0){
                  htmls.push("<li><div class='marginTop38'><div class='w999'>");
              }
              if(tag>=max_person_num){
                  tag = 0;
                 htmls.push("</div></div></li><li><div class='marginTop38'><div class='w999'>");

              }
              htmls.push('<dl style="margin-bottom:1px"><dt><a style="cursor:pointer" onclick="showPersonSummary(\''+item.memberId+'\')" target="_blank"><img src="'+item.avtar+'" width="128" height="148"></a></dt>');
              htmls.push('<dd><a style="cursor:pointer;font-size:16px;line-height:32px;" onclick="showPersonSummary(\''+item.memberId+'\')" target="_blank">'+item.memberName+'</a></dd>');
              htmls.push('<dd><table><tr style="width:128px"><td style="text-align:left" >职务：   '+item.postName+'</td></tr>');
              htmls.push('<tr style="width:128px"><td  style="text-align:left" >联系方式：'+item.v3xOrgMember.properties.officenumber+'</td></tr>');
             // htmls.push('<tr style="width:128px"><td  style="text-align:left" >内网邮箱：'+item.v3xOrgMember.properties.emailaddress+'</td></tr>');
              htmls.push('</table></dd></dl>');
              tag++;
          });
          htmls.push("</div></div></li>");
          return htmls;
    }
    if(data&&data.items&&data.items.length>0){
        //人员照片下显示名字，联系方式和邮箱
        /*
        *1、书记、主任；书记
         2、副书记；副书记、副主任
         3、常委、委员；常委；委员；常委、委员（正县）；常委（正县）；委员（正县）
         4、部长；主任；副部长；副主任；组长；副组长；负责人
         5、其它
        */
       // console.log(data.items);
        var dataArys = data.items;
        var data_level_persons={
            "one":["书记、主任","书记"],
            "two":["副书记、副主任","副书记"],
            "three":["常委、委员","常委","委员","常委、委员（正县）","常委（正县）","委员（正县）"],
            "four":["部长","主任","副部长","副主任","组长","副组长","负责人"]
        };
        var item_data_level={
         "one":[],
         "two":[],
         "three":[],
         "four":[],
         "five":[]
        }
        $(dataArys).each(function(index,item){
            var postName = item.postName;
//            var one_ary = data_level_persons["one"];
//            var two_ary = data_level_persons["two"];
//            var three_ary = data_level_persons["three"];
//            var four_ary = data_level_persons["four"];
            var isPushed = false;
            for( var p in data_level_persons){
                 if(isPushed){
                     break;
                 }
                var arys = data_level_persons[p];
                for(var index=0;index<arys.length;index++){
                    if(postName == arys[index]){
                        isPushed = true;
                        item_data_level[p].push(item);
                        break;
                    }
                }
            }
            if(!isPushed){
                item_data_level["five"].push(item);
            }

        });
        //
        var html1 = addHtmls(item_data_level["one"]);
        var html2 = addHtmls(item_data_level["two"]);
        var html3 = addHtmls(item_data_level["three"]);
        var html4 = addHtmls(item_data_level["four"]);
        var html5 = addHtmls(item_data_level["five"]);
        var htmls=[];
        htmls.push(html1.join(""));
        htmls.push(html2.join(""));
        htmls.push(html3.join(""));
        htmls.push(html4.join(""));
        htmls.push(html5.join(""));
        $("#container_ul").html(htmls.join(""));
    }else{
        $("#container_ul").html("");
    }
}
function showDepartmentMembers(deptId,deptName,deptPath){
    var dept = window.LevelFour[deptPath];
   // console.log(dept);
    $("#deptNameSpan").html("<span style='font-size:18px'>"+deptName+"</span>");
    if(dept){
        var mail = dept.v3xOrgDepartment.properties.unitMail;
        var fax = dept.v3xOrgDepartment.properties.fax;
       // console.log(dept.v3xOrgDepartment);
        var desc = dept.v3xOrgDepartment.description;
        if(desc != null&&desc!=""){
            var descs = desc.split(",");
            fax = descs[0];
            mail = descs[1];

        }
        if(mail == null){
            mail = "";
        }
        if(fax == null){
            fax = "";
        }
        if(deptName!="委领导"){
            $("#deptMailSpan").html("<span style='margin-left:10px;font-size:16px'>内网邮箱:"+mail+"</span>");
            $("#deptFaxSpan").html("<span style='margin-left:10px;font-size:16px'>电话传真:"+fax+"</span>");
        }else{
            $("#deptMailSpan").html("");
            $("#deptFaxSpan").html("");
        }

    }

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
    function flatDepartmentData(data){
        var accounts=[];
        //过滤掉没有部门的单位
        $(data).each(function(index,item){
            if(item.depts==null||item.depts.length==0){
                return;
            }
            accounts.push(item);
        });
        var root = accounts[0];
        root.path = root.v3xOrgAccount.path;
        root.level = root.path.length/4;

        var depts = root.depts;
        for(var p in depts){
            depts[p].path = depts[p].v3xOrgDepartment.path;
            depts[p].level = depts[p].path.length/4;
            depts[p].parentPath = depts[p].v3xOrgDepartment.parentPath;
        }
        var LevelTwo={

        };
        LevelTwo[root.path] = root;
        var LevelThree={};
        var LevelFour={};
        for(var p in depts){
            var dept = depts[p];
            if(dept.level == 3){
                LevelThree[dept.path] =dept;
            }
            if(dept.level == 4){
                LevelFour[dept.path] =dept;
            }

        }
        window.rootAccount = root;
        window.LevelFour = LevelFour;
       // console.log(LevelFour);
        window.LevelThree = LevelThree;
        window.LevelTwo = LevelTwo;


    }
    function renderDepartment(data){

        flatDepartmentData(data.items);
        renderDeptTwo(window.LevelTwo);
        renderDeptThree(window.LevelThree);
        // console.log(data+data&&data.items&&data.items.length>0);
        // if(data&&data.items&&data.items.length>0){
        //     var items = data.items;
        //     $(items).each(function(index,item){
        //         var depts = item.depts;
        //         if(depts&&depts.length>0){
        //             var htmls=[];
        //             var seed = null;
        //             $(depts).each(function(index,item){
        //                 htmls = loadDeptSpan(item,htmls);
        //                 if(seed ==null){
        //                     seed = item;
        //                 }
        //             });
        //             $("#departmentList").html(htmls.join(""));
        //             if(seed){
        //                 showDepartmentMembers(seed.deptId,seed.deptName);
        //             }

        //         }
        //     });
        // }
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
    function renderDeptTwo(){
        var htmls=[];
        var account = window.rootAccount;
        htmls.push('<div class="dept_level_two">');
        htmls.push('<a  target="_blank" style="color:#000;cursor:pointer">'+account.v3xOrgAccount.name+'人事信息</a></div>');
        $("#departmentList").html(htmls.join(""));
    }
    function renderDeptThree(){
        var htmls=[];
        var depts = window.LevelThree;
        var trigger = null;
        for(var key in depts){
            if(trigger == null){
                trigger = key;
            }
            htmls.push('<div class="gwy-list">');
            //<div style="width:255px;height:40px;line-height:40px;text-align:center;font-size: 22px;background: #dcdcdd;margin-bottom: 15px;font-family:'FZZHUNYSK','微软雅黑','宋体'">国务院组成部门负责人</div>
            htmls.push('<div  class="department-li" onclick="renderDeptThreeHtml(\''+key+'\')"  style="font-family:\'FZZHUNYSK\',\'微软雅黑\',\'宋体\'">'+depts[key].deptName+'</div>');
            htmls.push('<div class="deptTwo" id="two'+key+'" ></div>');
            htmls.push('</div>');
        }

        $("#departmentList").append(htmls.join(""));
        renderDeptThreeHtml(trigger);
    }
    function renderLevelFour(){

    }
    function loadDeptSpan(item,htmls){
        htmls.push('<div class="column box box1">');
        htmls.push('<a  target="_blank" style="cursor:pointer" onclick="showDepartmentMembers(\''+item.deptId+'\',\''+item.deptName+'\')" title="'+item.deptName+'">'+item.deptName+'</a></div>');
        return htmls;
    }
    loadDepartment();

});