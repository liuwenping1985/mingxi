
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<style type="text/css">
.stadic_body_top_bottom {
	bottom: 0px;
	top: 0px;
}
</style>
<script type="text/javascript">
    
        $(function(){
            //候选操作绑定双击事件
            $('#reserve').dblclick(function(){
                move($('#reserve'),$('#selected'));
            });
            //选中操作 绑定双击事件
            $('#selected').dblclick(function(){
                moveTo($('#selected'),$('#reserve'));
            });
            //向左移动 绑定点击事件
            $('#toLeft').click(function(){
                moveTo($('#selected'),$('#reserve'));
            });
            //向右移动 绑定点击事件
            $('#toRight').click(function(){
                move($('#reserve'),$('#selected'));
            });
        });
        //左右两侧节点栏内数据相互移动
        function move(fObj,tObj){
          fObj.find('option').each(function(){
        	  if(fObj.find('option:selected').length > 1){
        		  alert("推送门户栏目只允许选择一个！");
        		  return false;
        	  }
              if(this.selected){
                  if(tObj.find("option").length <1){
                    tObj.append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
                    //将当前选中节点从左侧删除
                    $(this).remove();
                  } else {
                	  alert("推送门户栏目只允许选择一个！");
                	  return false;
                  }
              }
          });
           
        }
         function moveTo(fObj,tObj){
              fObj.find('option').each(function(){
              if(this.selected){
                    tObj.append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
                    $(this).remove();
              }
          });
        }


        
        //定义回调函数，返回节点栏中选中的数据,以json字符串形式返回
        function OK(){
            //alert($('#selected').find("option").val())
            var selectedVal = $("#selected").find("option").val();
            var selectedName = $("#selected").find("option").text();
            var returnValue = {
            	"value" : selectedVal ,
            	"name" : selectedName
            };
            return returnValue ;
        }
    </script>
</head>
<body class="h100b over_hidden">
<table align="center" class="margin_t_10 font_size12">
	<tr>
		<td>${ctp:i18n('permission.operation.wait.choose')}<%--候选操作 --%><br />
		<select id="reserve" name="reserve" multiple="multiple"
			class="margin_t_10" style="width: 150px; height: 220px;">

			<c:forEach items="${allOuterspaces}" var="spaces">
				<option value="${spaces.id}">${spaces.sectionLabel}</option>
			</c:forEach>
		</select></td>
		<td><em class="ico16 select_selected" id="toRight"></em><br />
		<em class="ico16 select_unselect" id="toLeft"></em></td>
		<td>${ctp:i18n('permission.operation.check.choose')}<%--选中操作 --%><br />
		<select id="selected" name="selected" multiple="multiple"
			class="margin_t_10" style="width: 150px; height: 220px;">

		</select></td>
	</tr>
</table>
</div>
</body>
</html>
