<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title>选择科目</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=subjectMapperManager"></script>
<script type="text/javascript" language="javascript">

//请勿轻易修改这个变量不仅批量关闭窗口用，角色回填也需要回传值
$().ready(function() {
    //列表
    var grid = $("#subjectTable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.selectSub.subname')}",
            name : 'subName',
            width : '25%'
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.selectSub.subcode')}",
            name : 'subCode',
            width : '20%'
        }
        , 
        {
            display : "${ctp:i18n('voucher.plugin.cfg.subject.selectSub.direction')}",
            name : 'direction',
            width : '20%'
        }
        ,
        {
            display : "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.name')}",
            name : 'bookName',
            width : '30%'
        }		
        ],
        width: "auto",
        managerName: "subjectMapperManager",
        managerMethod: "showSubjectList",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.bookCode=$("#bookCode").val();
    o1.accountId=$("#accountId").val();
    $("#subjectTable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.bookCode=$("#bookCode").val();
      ssss.accountId=$("#accountId").val();
      $("#subjectTable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.subject.selectSub.subname')}",
      value: 'name'
    },{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('voucher.plugin.cfg.subject.selectSub.subcode')}",
      value: 'code'
    }
    ,{//方向
        id: 'search_direction',
        name: 'search_direction',
        type: 'select',
        text: "${ctp:i18n('voucher.plugin.cfg.subject.debit')}",
        value: 'direction',
        items: [{
            text: "${ctp:i18n('voucher.plugin.cfg.subject.debit.one')}",
            value: '1'
        }, {
            text: "${ctp:i18n('voucher.plugin.cfg.subject.debit.two')}",
            value: '2'
        }]
    }]
  });
   function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	    var roles = new Array();
	    var boxs = $("#subjectTable input:checked");
	    var v = $("#subjectTable").formobj({
	      	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	      	}
	    });
	    
	    if (boxs.length <= 0) {
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.subject.selectSub.atlast')}");
	    	return false;
	    }else if(boxs.length > 1){
	    	$.alert("${ctp:i18n('voucher.plugin.cfg.subject.selectSub.mustone')}");
	    	return false;
	    }else{
	    	return {"id":v[0].id,"subName":v[0].subName,"subCode":v[0].subCode,"direction":v[0].direction};
	    }

	    
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv">
	        	<input type="hidden" id="bookCode" name="bookCode" value="${ctp:toHTML(bookCode)}">
		        <input type="hidden" id="accountId" name="accountId" value="${ctp:toHTML(accountId)}">
	        </div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="subjectTable" class="flexme3" style="display: none">
            </table>
        </div>
    </div>
</body>
</html>