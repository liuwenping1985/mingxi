<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>VoucherInfoList</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=voucherManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
    //列表
    var grid = $("#voucherInfo").ajaxgrid({
        colModel: [
        {
            display:"${ctp:i18n('voucher.plugin.generate.title')}",
            sortable: true,
            name: 'title',
            width: '23%'
        },
        {
            display: "${ctp:i18n('cannel.display.column.sendUser.label')}",
            sortable: true,
            name: 'startMember',
            width: '5%'
        },
        {
            display: "${ctp:i18n('common.date.sendtime.label')}",
            sortable: true,
            name: 'startTime',
            width: '12%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.generate.result')}",
            sortable: true,
            name: 'isSuccess',
            width: '5%',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.voucher.util.VoucherResult',query:'true'"
        },
        {
            display: "${ctp:i18n('voucher.plugin.generate.voucher_no')}",
            sortable: true,
            name: 'voucherNo',
            width: '10%'
        },
        {
            display: "${ctp:i18n('voucher.plugin.generate.failreason')}",
            sortable: true,
            name: 'exceptionInfo',
            width: '50%'
        }  
        ],
        width: "auto",
        managerName: "voucherManager",
        managerMethod: "showVoucherLogListByRecent",
        parentId: 'center'
    });
    //加载表格
    var o1 = new Object();
    o1.idStr = $("#idStr").val();
    o1.mergeflag = $("#mergeflag").val();
    $("#voucherInfo").ajaxgridLoad(o1);
});
</script>
<script type="text/javascript" language="javascript">
 function OK() {
	 	var obj = $("#voucherInfo").formobj();
	 	var ids = new Array();
	 	for(var i=0; i<obj.length; i++){
	 		ids[i]=obj[i].id;
	 	}
	 	return ids;
	};
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div class="form_area">
        	<div class="one_row" style="width:95%;">
        	<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.generate.target_account')}: </label></th>
						<td width="25%">
							<div class="common_txtbox_wrap" style="border: 0px;">
								<input type="text" id="targetAccount" class="word_break_all" readonly="readonly" value="${accountName}"  name="targetAccount">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.accountCfg.url')}: </label></th>
						<td width="35%">
							<div class="common_txtbox_wrap" style="border: 0px;">
								<input type="text" id="accountAddress" readonly="readonly" class="word_break_all" value="${accountAddress}" name="accountAddress">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.subject.book')}: </label></th>
						<td width="40%">
							<div class="common_txtbox_wrap" style="border: 0px;">
								<input type="text" id="bookCode" readonly="readonly" class="word_break_all" value="${ctp:toHTML(bookCode)}" name="bookCode">
							</div>
						</td>
					</tr>
					<tr>
						
					</tr>
				</tbody>
			</table>
			</div>
			</div>
    	</div>
    	
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="voucherInfo" class="flexme3" style="display: none"></table>
            <input type="hidden" id="idStr" name="idStr" value="${ctp:toHTML(idStr)}">
            <input type="hidden" id="mergeflag" name="mergeflag" value="${ctp:toHTML(mergeflag)}">
        </div>
    </div>
</body>
</html>