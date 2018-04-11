<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
		<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}"/>
		<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}"/>
		<title></title>
		<style type="text/css">
			.tr-header{background: #80AAD4; height: 35px;color: #fff; text-align: left;}
			#data-content tr{height: 35px;}
			.f-td{border-bottom: 1px solid #ccc;text-align: center;}
			.s-td{ border-bottom: 1px solid #ccc;padding-left: 9px;}
			.border-left{border-left: 1px solid #ccc;}
		</style>
	</head>
	<body>
		<div style="border: 1px solid #d2d2d2;">
		   <div class="relative">
		        <table width="100%" border="0" cellspacing="0" cellpadding="0">
		            <tbody>
		                <tr class="tr-header">
		                    <th width="20%" class='f-td'><input type="checkbox" id="selectAll"/> </th>
		                    <th class='s-td border-left'>${ctp:i18n('attendance.common.name')}</th>
		                </tr>
		            </tbody>
		            </table> 
		    </div>
		    <div  style="height:265px;width: 100%;overflow-y: auto;">
		        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
		            <tbody id="data-content">
		            </tbody>
		        </table>    
		    </div>
		</div>
	</body>
    <%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
    <script type="text/html" id="data-tpl">
    {{# var size = d.length;							}}
    {{# for(var i = 0; i < size ; i++ ){ 				}}
	    <tr>
		    <td width="20%"  class='f-td'><input type="checkbox" data-id="{{d[i].id }}" data-name='{{=d[i].name }}' class='member-item' {{selectData[d[i].id] ? "checked" : ""}} /></td>
		    <td  class='s-td'>{{=d[i].name }}</td>
		</tr>
    {{# } 												}}
    </script>
	<script type="text/javascript">
		var selectData = {}; //缓存已经选择的数据
		var OK = function(){//返回结果集
			var res = [];
			for(var key in selectData ){
				res.push({
					"id":key,
					"name":selectData[key]
				})
			}
			return res;
	    }
		
		$(function(){
			//初始化列表
			var params = window.parentDialogObj['auth_range_dialog'].getTransParams();
            for(var i = 0; i < params.length ; i++ ){
            	selectData[params[i]["id"]] = params[i]["name"];
            }
            var proce = $.progressBar();
			new attendanceManager().getAuthScopeMembers({
				success:function(data){
					if(data.length > 0){
						if(params.length == data.length){//如果选择的和返回的数据相同  则表示是全选的
							$("#selectAll").prop("checked",true);
						}
						var tpl = laytpl($("#data-tpl").html());
						tpl.render(data,function(html){
							$("#data-content").html(html);
							proce.close();
						});
					}
				},
				error:function(){
					$.error("loading data error!");
				}
			});
			//全选
			$("#selectAll").click(function(){
				var items = $(".member-item");
				items.prop("checked",this.checked);
				for(var i = 0; i < items.length ; i++){
					if(this.checked){
						selectData[items.eq(i).attr("data-id")] = items.eq(i).attr("data-name");
					}else{
						selectData = {};
					}
				}
			});
			//点击一项
			$("#data-content").delegate(".member-item","click",function(e){
				if(this.checked){
					selectData[this.getAttribute("data-id")] = this.getAttribute("data-name");
				}else{
					$("#selectAll").prop("checked",false);
					delete selectData[this.getAttribute("data-id")];
				}
			});
			
		});
	</script>
</html>