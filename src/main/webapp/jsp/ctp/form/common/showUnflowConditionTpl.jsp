<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 文本框条件 --%>
<script type="text/html" id="screenConditionTpl">
<div class="condition-wrap clearfix relative">
	<div class="condition-line positive ">
		<div class="time_item time_itemFrist">
			{{d.screenHtml }}
		</div>
	</div>
	<div class="condition-line-right display_none">
		<span class="ico16 more_down_16"></span>
	</div>
</div>
</script>
<%-- 文本框条件 --%>
<script type="text/html" id="textConditionTpl">
{{# var fieldBase = d.fieldBase; }}
	<div class="g1">
		<div class="condition-line-left">
			<span class="condition-name" title="{{=d.display }}">{{=d.display }}</span>
		</div><div class="g2">
			<div class="condition-line-main">
				{{# if (d.fieldType == 'DECIMAL') { }}
                    <input type="text" name="{{d.name }}" id="{{d.name }}" value="{{=fieldBase.defaultVal }}" class="comp" comp="type:'onlyNumber',numberType:'float',decimalDigit:{{d.digitNum }}" validate="name:'{{=d.display }}',isNumber:true,decimalDigits:0,maxLength:20,integerDigits:20,maxEqual:false,minEqual:false,notNull:false" onkeydown="if(event.keyCode == 13) excSearch()">
                {{# } else { }}
                    <input type="text" name="{{d.name }}" id="{{d.name }}" value="{{=fieldBase.defaultVal }}" onkeydown="if(event.keyCode == 13) excSearch()">
                {{# } }}
			</div>
		</div>
	</div>
</script>
<%-- 枚举类型条件（单选按钮、下拉框）弹出方式 --%>
<script type="text/html" id="enumChooseTpl">
{{# var fieldBase = d.fieldBase; }}
	<div class="g1">
		<div class="condition-line-left">
			<span class="condition-name" title="{{=d.display }}">{{=d.display }}</span>
		</div><div class="g2">
			<div class="condition-line-main">
                <input class="hand" readonly="readonly" type="text" value="" onclick="enumChoose(this,'{{fieldBase.formId }}','{{d.name }}')">
				<input type="hidden" name="{{d.name }}" id="{{d.name }}" value="">
			</div>
		</div>
	</div>
</script>
<%-- 枚举类型条件（单选按钮、下拉框） --%>
<script type="text/html" id="enumConditionTpl">
{{# var fieldBase = d.fieldBase; }}
	<div class="condition-wrap clearfix relative">
		<div class="condition-line positive">
			<div class="time_title" title="{{=d.display }}">{{=d.display }}</div>
			<div class="time_item">
				{{# for(var i = 0, len = fieldBase.checkboxList.length; i < len; i++){ }}
		            <label class="condition-lable" for="{{d.name }}|enum{{i }}">
						<input type="checkbox" id="{{d.name }}|enum{{i }}" name="{{d.name }}" value="{{fieldBase.checkboxList[i].value }}">
						<span>{{ fieldBase.checkboxList[i].name }}</span>
					</label>
	            {{# } }}
			</div>
		</div>
		<div class="condition-line-right display_none">
			<span class="ico16 more_down_16"></span>
		</div>
	</div>
</script>
<%-- 日期和日期时间 --%>
<script type="text/html" id="dateConditionTpl">
{{# var fieldBase = d.fieldBase; }}
<div class="condition-wrap clearfix relative">
	<div class="condition-line positive ">
		<div class="time_title" title="{{=d.display }}" id="dis_{{d.name.replace('.','') }}">{{=d.display }}</div>
		<div class="time_item">
			{{# for(var i = 0, len = fieldBase.checkboxList.length; i < len; i++){ }}
                 <label class="condition-lable" for="{{d.name }}|time{{i }}">
                     {{# if (fieldBase.defaultCheckFirst == '1' && i == 0) { }}
                         <input type="checkbox" checked id="{{d.name }}|time{{i }}" name="{{d.name }}" value="{{fieldBase.checkboxList[i].value }}">
                     {{# } else { }}
                         <input type="checkbox" id="{{d.name }}|time{{i }}" name="{{d.name }}" value="{{fieldBase.checkboxList[i].value }}">
                     {{# } }}
                     <span>{{ fieldBase.checkboxList[i].name }}</span>
                 </label>
            {{# } }}
            <div style=" display: inline-block; ">
	            {{# if (d.finalInputType == 'date') { }}
	                <label class="condition-lable"><input readonly="readonly" id="{{d.name }}|startTime" type="text" class="comp" comp="type:'calendar',cache:false,isOutShow:false,ifFormat:'%Y-%m-%d',isClear:true,onUpdate:clearSelected" comptype="calendar" _inited="1"></label>
	                <lable>-</lable>
	                <label class="condition-lable"><input readonly="readonly" id="{{d.name }}|endTime" type="text" class="comp" comp="type:'calendar',cache:false,isOutShow:false,ifFormat:'%Y-%m-%d',isClear:true,onUpdate:clearSelected" comptype="calendar" _inited="1"></label>
	            {{# } else { }}
	                <label class="condition-lable"><input readonly="readonly" id="{{d.name }}|startTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',isClear:true,onUpdate:clearSelected,minuteStep:1,showsTime:true,cache:false" comptype="calendar" _inited="1"></label>
	                <lable>-</lable>
	                <label class="condition-lable"><input readonly="readonly" id="{{d.name }}|endTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',isClear:true,onUpdate:clearSelected,minuteStep:1,showsTime:true,cache:false" comptype="calendar" _inited="1"></label>
	            {{# } }}
			</div>                                                    
		</div>
	</div>
	<div class="condition-line-right display_none">
		<span class="ico16 more_down_16"></span>
	</div>
</div>
</script>
<%-- 复选框条件 --%>
<script type="text/html" id="checkboxConditionTpl">
{{# var fieldBase = d.fieldBase; }}
	<div class="g1">
		<div class="condition-line-left " {{# if (fieldBase.frontlabelVal == null) { }} style='display:none' {{# } }}>
			<span class="condition-name" title="{{=fieldBase.frontlabelVal }}">{{=fieldBase.frontlabelVal }}</span>
		</div><div class="g2">
			<div class="condition-line-main">
				{{# if (fieldBase.defaultVal == '1') { }}
                    <label class="checkbox-lable" for="{{d.name }}"><input type="checkbox" checked name="{{d.name }}" id="{{d.name }}" value="1"><span>{{=d.display }}</span></label>
                {{# } else { }}
                    <label class="checkbox-lable" for="{{d.name }}"><input type="checkbox" name="{{d.name }}" id="{{d.name }}" value="1"><span>{{=d.display }}</span></label>
                {{# } }}
			</div>
		</div>
	</div>
</script>
<%-- 组织机构相关条件（选择人员、部门、单位...） --%>
<script type="text/html" id="orgConditionTpl">
{{# var fieldBase = d.fieldBase; var finalInputType = d.finalInputType; var externalType = d.externalType;}}
	<div class="g1">
		<div class="condition-line-left">
			<span class="condition-name" title="{{=d.display }}">{{=d.display }}</span>
		</div><div class="g2">
			<div class="condition-line-main">
				{{# if ('member' == finalInputType || 'multimember' == finalInputType) { }}
                     {{# if ('0' == externalType) { }}
                         {{# var panels = 'Department,Team,Post,Level,Outworker'; }}
                         {{# if ('start_member_id' == d.name) { }}
                             {{# panels = 'Department,Team,Post,Level,Outworker,JoinOrganization'; }}
                         {{# } }}
                         <span fieldVal='{name:"{{d.name }}",displayName:"{{=d.display }}"}' id="{{d.name }}_span" name="{{d.name }}_span">
                             <select id="{{d.name }}_select" class="comp" style="width:131px;border: 1px solid #e4e4e4;" multiple="multiple"
							     comp="outBtn:true,panels:'{{panels }}',id:'{{d.name }}',isNeedCheckLevelScope:false,type:'fastSelect',mode:'open',selectType:'Member',minSize:0,extendWidth:true,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                             <select>
                         </span>
                     {{# } else { }}
                         <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                             comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                             panels:'JoinOrganization',selectType:'Member',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                     {{# } }}
                {{# } else if('department' == finalInputType) { }}
                     {{# if ('0' == externalType) { }}
                         <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                             comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                             panels:'Department',isAllowContainsChildDept:false,isConfirmExcludeSubDepartment:true,selectType:'Department',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                     {{# } else { }}
                         {{# if ('1' == externalType) { }}
                             <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                                 comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                                 panels:'JoinOrganization',showExternalType: '1',isAllowContainsChildDept:false,isConfirmExcludeSubDepartment:true,selectType:'Department',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                         {{# } else { }}
                             <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                                 comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                                 panels:'JoinAccount',isAllowContainsChildDept:false,isConfirmExcludeSubDepartment:true,selectType:'Department',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                         {{# } }}
                     {{# } }}
				{{# } else if('multidepartment' == finalInputType) { }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Department',isAllowContainsChildDept:true,isConfirmExcludeSubDepartment:false,selectType:'Department',showBtn:true,minSize:0,maxSize:10,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } else if('account' == finalInputType){ }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Account',selectType:'Account',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } else if('multiaccount' == finalInputType){ }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Account',selectType:'Account',showBtn:true,minSize:0,maxSize:10,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } else if('post' == finalInputType){ }}
                     {{# if ('0' == externalType) { }}
                         <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                             comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                             panels:'Post',selectType:'Post',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                     {{# } else { }}
                         <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                             comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                             panels:'JoinPost',selectType:'Post',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                     {{# } }}
                {{# } else if('multipost' == finalInputType){ }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Post',selectType:'Post',showBtn:true,minSize:0,maxSize:10,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } else if('level' == finalInputType){ }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Level',selectType:'Level',showBtn:true,minSize:0,maxSize:-1,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } else if('multilevel' == finalInputType){ }}
                     <input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" 
                          comp="type:'selectPeople',isNeedCheckLevelScope:false,showAllOuterDepartment:true,extendWidth:true,
                          panels:'Level',selectType:'Level',showBtn:true,minSize:0,maxSize:10,value:'{{=fieldBase.handOrgIds }}',text:'{{=fieldBase.defaultVal }}'">
                {{# } }}
			</div>
		</div>
	</div>
</script>
<%-- 关联项目条件 --%>
<script type="text/html" id="projectConditionTpl">
{{# var fieldBase = d.fieldBase; }}
	<div class="g1">
		<div class="condition-line-left">
			<span class="condition-name" title="{{=d.display }}">{{=d.display }}</span>
		</div><div class="g2">
			<div class="condition-line-main">
				<input type="text" id="{{d.name }}" name="{{d.name }}" class="comp" comp="type:'chooseProject'" readonly="">
			</div>
		</div>
	</div>
</script>












