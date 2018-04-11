<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<div id="index" class="hidden right-item">	
	<div class="right-item right-contsource">
		<div class="right-itemtitle">${ctp:i18n('ctp.dr.content.source.js')}</div>
		<div class="right-itemcontent">
			<div class="searchitem">
				<span class="leftname">搜索词：</span>
				<input type="text">
        <input id="dataType" type="hidden" value="3">
			</div>
			<div class="searchitem">
				<span class="leftname">标题：</span>
				<input type="text">
			</div>
			<div class="searchitem">
				<span class="leftname">发起人：</span>
				<input type="text">
			</div>
			<div class="searchitem">
				<span class="leftname">附件名：</span>
				<input type="text">
			</div>
			<div>
				<span class="leftname">起止时间：</span>
				<input type="text">
			</div>
			<div>
				<span class="leftname">类型：</span>
				<input type="checkbox" class="checkbox" id="cb1">
				<label for="cb1">全部</label>
				<div class="cbxgroup">
					<span>
						<input type="checkbox" class="checkbox" id="cb2">
						<label for="cb2">协同</label>
				    </span>
				    <span>
						<input type="checkbox" class="checkbox" id="cb3">
						<label for="cb3">表单</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb4">
						<label for="cb4">公文</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb5">
						<label for="cb5">计划</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb6">
						<label for="cb6">会议</label>
				    </span>
				    <span>
						<input type="checkbox" class="checkbox" id="cb7">
						<label for="cb7">事件</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb8">
						<label for="cb8">任务</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb9">
						<label for="cb9">新闻</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb10">
						<label for="cb10">公告</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb11">
						<label for="cb11">调查</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb12">
						<label for="cb12">讨论</label>
					</span>
					<span>
						<input type="checkbox" class="checkbox" id="cb13">
						<label for="cb13">文档</label>
					</span>
				</div>
			</div>
		</div>
	</div>
</div>
