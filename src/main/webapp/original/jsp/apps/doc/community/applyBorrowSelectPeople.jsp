<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
select {
    font-size: 12px;
    font-family: SimSun, Arial, Helvetica, sans-serif;
}
</style>
<script type="text/javascript">
    var set = null;
    var pageData = new Object();
    var userI18n = "${ctp:i18n('doc.jsp.applay.person')}";
    var deptI18n = "${ctp:i18n('doc.jsp.applay.dept')}";
    
    $(function() {
        pageData.data = window.dialogArguments;
        initSelectPeople();
        fnAssemblyOption();
    });

    function OK() {
        //构造返回数据
        var names = "";
        var values = "";
        var len = 0;

        var selectObj = new Array();
        var unselectObj = new Array();

        //选中的数据
        $("#selected option").each(function(index) {
            if (len != 0) {
                names += "、"
                values += ","
            }

            var i = $(this).val();
            var obj = pageData.data.users[i];
            names += obj.userName;
            values += obj.userType + "|" + obj.userId;
            selectObj[index] = obj;
            len++;
        });

        //未选中的数据
        $("#unselect option").each(function(index) {
            var i = $(this).val();
            unselectObj[index] = pageData.data.users[i];
        });

        return {
            "name" : names,
            "values" : values,
            "len" : len,
            "selectObj" : selectObj,
            "unselectObj" : unselectObj
        };
    }

    /**
     * 根据传递过来的参数装配select的option
     */
    function fnAssemblyOption() {
        var sOption = "";
        var unselectObj = pageData.data.unselectObj;
        var iNameMaxLen = 6 ;
        var iDeptMaxLen = 10;
        //未选中中的数据
        for ( var i = 0; i < unselectObj.length; i++) {
            var user = unselectObj[i];
            var sOptionValue = getOption(user.userName,user.deptName);
            
            sOption += "<option value='"+user.index+"' type='unselect' title='"+userI18n+"："
            + user.userName + "\r"+deptI18n+"：" +user.deptName + "'>"
            + sOptionValue +
             "</option>";
        }

        addOption("unselect", sOption);
        sOption = "";
        var selectObj = pageData.data.selectObj;
        //选中的数据
        for ( var i = 0; i < selectObj.length; i++) {
            var user = selectObj[i];
            var sOptionValue = getOption(user.userName,user.deptName);
            
            sOption += "<option value='"+user.index+"' type='unselect' title='"+userI18n+"："
            + user.userName + "\r"+deptI18n+"：" +user.deptName + "'>"
            + sOptionValue + "</option>";
        }
        addOption("selected", sOption);
    }   
    var nameMaxSpace = 2;
    var nameMaxLength = {
            two   : [22], //2列
            three : [16, 18]  //3列
    };
    
    var NameSpace = {
            0 : "",
            1 : " ",
            2 : "  ",
            3 : "   ",
            4 : "    ",
            5 : "     ",
            6 : "      ",
            7 : "       ",
            8 : "        ",
            9 : "         ",
           10 : "          ",
           11 : "           ",
           12 : "            ",
           13 : "             ",
           14 : "              ",
           15 : "               ",
           16 : "                ",
           17 : "                 ",
           18 : "                  ",
           19 : "                   ",
           20 : "                    ",
           21 : "                     ",
           22 : "                      ",
           23 : "                       ",
           24 : "                        ",
           25 : "                         ",
           26 : "                          ",
           27 : "                           "
     };  
    
    function getOption(name,dept){
        var max = 10;
        var text = null;
        text = name.getLimitLength(nameMaxLength.two[0]);
        text += NameSpace[nameMaxLength.two[0] + nameMaxSpace - text.getBytesLength()];
        text +=dept.getLimitLength(nameMaxLength.two[0]);
        return text.escapeHTML(true);
    }
    
    function initSelectPeople() {
        set = new setBord({
            maxLength : 1,
            addObj : $("#unselect"),
            removeObj : $("#selected"),
            dbbinds : {
                "#unselect" : addItem,
                "#selected" : removeItem
            }
        //绑定双击事件
        });

        $("#unselect_ico").click(function() {
            set.remove();
        });

        $("#selected_ico").click(function() {
            set.add();
        });

        $("#sort_up").click(function() {
            set.moveT(set.removeObj);
        });

        $("#sort_down").click(function() {
            set.moveB(set.removeObj);
        });
    }

    function addItem() {
        set.add();
    }

    function removeItem() {
        set.remove();
    }

    function addOption(id, soption) {
        $("#" + id).html(soption);
    }
</script>
</head>
<body class="over_hidden">
<table style="width: 100%">
        <tr>
            <td style="width: 100%"></td>
            <td nowrap="nowrap"><div id="lengthCount"></div></td>
        </tr>
</table>
<table class="docsShowTable dev_hide font_size12" width="100%">
    <td class="td">
        <table align="center" width="100%" height="100%" class="margin_t_10 margin_l_5">
            <tr>
                <td valign="top" width="45%" height="100%">
                    <p class="margin_b_5">${ctp:i18n('doc.jsp.apply.spare')}</p> 
                    <select class="font_size12" multiple="multiple" id="unselect" size="13" style="width:100%; height:300px;">
                    </select>
                </td>
                <td width="5%" valign="middle" align="center">
                <span class="ico16 select_selected" id="selected_ico"></span>
                <br>
                <br> 
                <span class="ico16 select_unselect" id="unselect_ico"></span>
                </td>
                <td valign="top" width="45%" height="100%">
                    <p class="margin_b_5">${ctp:i18n('doc.jsp.apply.selected')}</p> 
                    <select class="w100b" multiple="multiple" id="selected" size="13" style="height:300px;">
                </select></td>
                <td valign="middle" width="2%" align="center"></td>
            </tr>
        </table></td>
</body>
</html>