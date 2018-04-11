<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 节点、部门、人员表头模板 --%>
<script type="text/html" id="common-headerTpl">
<tr class="tableHeader">
	{{# for(var i = 0, len = d[0].length; i < len; i++){ }}
		{{# var headCell = d[0][i];}}
		<td class="border_right" colspan="{{ headCell.columnNum }}">{{ headCell.display }}</td>
	{{# } }}
</tr>
<tr class="table_thead">
	{{# for(var i = 0, len = d[1].length; i < len; i++){ }}
		{{# var headCell = d[1][i]; }}
		<td class="li_0 {{# if(headCell.isOrder){ }} hand {{# } }}" >
			<span id="head{{ i }}">{{headCell.display}}</span>
		{{# if(headCell.orderBy == "desc"){ }}
			<span class="ico16 arrow_4_b"></span>
		{{# }else if(headCell.orderBy == "asc"){ }}
			<span class="ico16 arrow_4_t"></span>
		{{# } }}
		</td>
	{{# } }}
</tr>
</script>
<%-- 节点、部门、人员效率数据模板 --%>
<script type="text/html" id="common-footTpl">
{{# for(var i = 0, len = d.length; i < len; i++){ }}
	{{# var row = d[i]; }}
	<tr class="table_tr">
		{{# for(var j = 0, l = row.length; j < l; j++){ }}
			{{# var cell = row[j]; }}
			<td 
				{{# if(cell.displayColor == "blue"&&j!==0){ }} 
					class="hand color_blue"  
			    {{# } }}
				{{# if(cell.displayColor == "red"){ }} 
					class="hand color_red"  
				{{# } }} 
				{{# if(j==0&&i!=d.length-1){ }} 
					style="text-align:left" 
				{{# } }} >

				<span 
					{{# if(j==0&&cell.isClick&&cell.conditions){ }} 
						class="hand color_blue nowarp span{{j}}"  
					{{# } }} 
						class="li_span_0 nowarp span{{j}}"  title="{{=cell.display}}"	>

					{{# if(j==0 ){ }} 
						<em class="icon16 hand em_show add_icon16" style="left:2px" ></em> 
					{{# } }}

					<span class="data_cell" > {{=cell.display}} </span>
				</span>
			</td>
		{{# } }}
	</tr>
{{# } }}
</script>
<%-- 节点、部门、人员效率汇总模板 --%>
<script type="text/html" id="common-bodyTpl">
<tr class="table_tr" style="background:#F0F0F0;">
	{{# for(var j = 0, l = d.length; j < l; j++){ }}
		{{# var cell = d[j]; }}
		<td 
			{{# if(cell.displayColor == "blue"&&j!==0){ }} 
				class="hand color_blue"  
		    {{# } }}
			{{# if(cell.displayColor == "red"){ }} 
				class="hand color_red"  
			{{# } }} 
			{{# if(j==0){ }} 
				style="text-align:left" 
			{{# } }} 
			{{# if(j!=0&&cell.conditions){ }} 
				data-click='{{cell.conditions }}' onclick="openThis(this,{{ j}})" 
			{{# } }}	>
			<span  {{# if(j==0&&cell.isClick&&cell.conditions){ }} 
					class="hand color_blue nowarp span{{j}}"  
				{{# } }} class="li_span_0 nowarp" title="{{=cell.display}}"	>
				
					<span 
					{{# if(j==0&&cell.isClick&&cell.conditions){ }} 
						onclick="openThisByName(this,{{ j }})"  data-click='{{cell.conditions }}' 
					{{# } }}  class="data_cell" > {{=cell.display}} </span>
			</span>
		</td>
	{{# } }}
</tr>
</script>
<%-- 流程效率表头模板 --%>
<script type="text/html" id="wfProcess-headerTpl">
<tr class="tableHeader">
	{{# for(var i = 0, len = d[0].length; i < len; i++){ }}
		{{# var headCell = d[0][i];}}
		<td class="border_right" colspan="{{ headCell.columnNum }}">{{ headCell.display }}</td>
	{{# } }}
</tr>
<tr class="table_thead">
	{{# for(var i = 0, len = d[1].length; i < len; i++){ }}
		{{# var headCell = d[1][i]; }}
		<td class="li_0 {{# if(headCell.isOrder){ }} hand {{# } }}" >
			<span id="head{{ i }}">{{headCell.display}}</span>
		{{# if(headCell.orderBy == "desc"){ }}
			<span class="ico16 arrow_4_b"></span>
		{{# }else if(headCell.orderBy == "asc"){ }}
			<span class="ico16 arrow_4_t"></span>
		{{# } }}
		</td>
	{{# } }}
</tr>
</script>
<%-- 流程效率数据模板 --%>
<script type="text/html" id="wfProcess-footTpl">
{{# for(var i = 0, len = d.length; i < len; i++){ }}
	{{# var row = d[i]; }}
	<tr class="table_tr">
		{{# for(var j = 0, l = row.length; j < l; j++){ }}
			{{# var cell = row[j]; }}
			<td 
				{{# if(cell.displayColor == "blue"&&j!==0){ }} 
					class="hand color_blue"  
			    {{# } }}
				{{# if(cell.displayColor == "red"){ }} 
					class="hand color_red"  
				{{# } }} 
				{{# if(j==0&&i!=d.length-1){ }} 
					style="text-align:left" 
				{{# } }} >
				<span 
					{{# if(j==0&&cell.isClick&&cell.conditions){ }} 
						class="hand color_blue nowarp span{{j}}"  
					{{# } }} 
						class="li_span_0 nowarp" title="{{=cell.display}}"	>
					<span class="data_cell" > {{=cell.display}} </span>
				</span>
			</td>
		{{# } }}
	</tr>
{{# } }}
</script>
<%-- 流程效率汇总模板 --%>
<script type="text/html" id="wfProcess-bodyTpl">
<tr class="table_tr" style="background:#F0F0F0;">
	{{# for(var j = 0, l = d.length; j < l; j++){ }}
		{{# var cell = d[j]; }}
		<td 
			{{# if(cell.displayColor == "blue"&&j!==0){ }} 
				class="hand color_blue"  
		    {{# } }}
			{{# if(cell.displayColor == "red"){ }} 
				class="hand color_red"  
			{{# } }} 
			{{# if(j==0){ }} 
				style="text-align:left" 
			{{# } }} 
			{{# if(j!=0&&cell.conditions){ }} 
				data-click='{{cell.conditions }}' onclick="openThis(this,{{ j}})" 
			{{# } }}	>
			<span  {{# if(j==0&&cell.isClick&&cell.conditions){ }} 
					class="hand color_blue nowarp span{{j}}"  
				{{# } }} class="li_span_0 nowarp" title="{{=cell.display}}"	>

					<span 
					{{# if(j==0&&cell.isClick&&cell.conditions){ }} 
						onclick="openThisByName(this,{{ j }})"  data-click='{{cell.conditions }}' 
					{{# } }}  class="data_cell" > {{=cell.display}} </span>
			</span>
		</td>
	{{# } }}
</tr>
</script>