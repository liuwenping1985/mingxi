<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="" class="validate">
    <div class="form_area" id="interForm">
        <div class="one_row" style="width:50%;">
            <input type="hidden" id="count_id" name="count_id">
            <input type="hidden" id="current_id" name="current_id">
            <input type="hidden" id="id" name="id" value="-1">
            <input type="hidden" id="productItemList" name="productItemList">
            <input type="hidden" id="sonNeed">
            <input type="hidden" id="objectId">
            <input type="hidden" id="Category_id" />
			<input type="hidden" id="masterId" />
			<input type="hidden" id="productId" />
			<input type="hidden" id="resourcePackageIds" />
            <table border="0" cellspacing="0" cellpadding="0">
                   <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.interface.detail.product')}:</label></th>
                        <td width="100%">
                                <input type="text" id="product_flag"   class="w100b validate" validate="type:'string',name:'${ctp:i18n('cip.base.form.product.code')}'" disabled="disabled"></input>
                        </td>
                    </tr>        
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.interface.detail.type')}:</label></th>
                        <td width="100%">
                                <input type="text" id="typeName"  class="w100b validate"  validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.type')}'" disabled="disabled"/>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap" ><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.interface.detail.name')}:</label></th>
                        <td width="100%">
                                <input type="text" id="Interface_name"  class="w100b validate"  validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.name')}',notNull:true,maxLength:50,regExp:'^[0-9a-zA-Z_]+$', errorMsg:'${ctp:i18n('cip.base.interface.register.tip31')}'"/>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.interface.detail.des')}:</label></th>
                        <td width="100%">
                            <div class="common_txtbox clearfix">
                            	<input type="text" id="Interface_des"  class="w100b validate"  validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.des')}',notNull:true,maxLength:80"/>
                            </div> 
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.syscon')}:</label></th>
                        <td width="100%" >
                            <div class="common_txtbox clearfix">
                            	<textarea id="System_constraint" cols='2'  class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.syscon')}',maxLength:80"></textarea>
                            </div>
                         </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.sencon')}:</label></th>
                        <td width="100%" >
                            <div class="common_txtbox clearfix">
                            	<textarea id="business_constraint" cols='2'  class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.sencon')}',maxLength:80"></textarea>
                            </div>
                         </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.base.interface.detail.usedes')}:</label></th>
                        <td width="100%" >
                            <div class="common_txtbox clearfix">
                            	<textarea id="Call_des" cols='2'  class="validate" style="width:100%;height:80px;" validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.usedes')}',notNull:true,maxLength:300"></textarea>
                            </div>
                         </td>
                    </tr>
                    <tr>
                  		<th nowrap="nowrap" id="appText"><label class="margin_r_10">${ctp:i18n('cip.base.interface.detail.scenedes')}:</label></th>
                    	<td width="100%" >
						<table id="appTable"  class="only_table" border="0"  width="100%">
					    	<thead>
					        	<tr>
					            	<th width="20%">${ctp:i18n('cip.base.interface.detail.no')}</th>
					            	<th width="30%">${ctp:i18n('cip.base.interface.detail.scedes')}</th>
					            	<th width="50%">${ctp:i18n('cip.base.interface.detail.sceexe')}</th>
					        	</tr>
					    	</thead>
					    	<tbody id="mobody">
					        	<tr class="autorow" id = "1">
					           		<td>
					            		<div class="common_txtbox_wrap">
											<input type="text" id="sceneNo1" class="validate word_break_all" validate="type:'string',maxLength:50,name:'${ctp:i18n('cip.base.interface.detail.no')}',notNull:false,regExp:'^[0-9]+$',maxLength:10">
										</div>
					            	</td>
					            	<td>
										<div class="common_txtbox_wrap ">
											<input type="text" id="sceneDe1" class="validate word_break_all" validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.scedes')}',maxLength:85">
										</div>
									</td>
									<td>
								    	<div class="common_txtbox_wrap">
											<span id  ="tab1"></span>
											<div style="float:right;" id ="d1">
												<div class="comp" comp="type:'fileupload',applicationCategory:'39',quantity:1,maxSize:2097152,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:false,callMethod:'fillUpCallBk'"></div>
												<a id="a1" href="javascript:void(0)" onclick="befFillUp(1);insertAttachment()" class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.upfile')}</a>
												<a id="a21" href="javascript:void(0)" onclick="downFile(1)" class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.downfile')}</a>
												<input type="hidden" id="fileName1">
												<input type="hidden" id="fileId1">
											</div>
										</div>
									</td>
					        	</tr>
					    	</tbody>
						</table>
						</td>
                   </tr>
                   <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.base.interface.detail.friend')}:</label></th>
                        <td width="100%" >
							<div class="common_txtbox clearfix">
								<div id="dResource" class="file_box">
									<ul class="file_select padding_10 border_all clearfix">
										<li id="resourceLi">
										</li>
										<a id="aShowResource" href="javascript:void(0)" onclick="showResource()" class="common_button common_button_gray" 
											style="float: right;">${ctp:i18n('cip.localAgent.but.search')}</a>
									</ul>
								</div>
							</div>
						</td>
                    </tr>
            </table>
        </div>
        </div>
        <div id="img" style="width: 16px; height: 30px;  position: relative;float: right; border: 1px;">
			<div id="addDiv" style="height: auto;">
				<span title="${ctp:i18n('cip.base.product.add')}" class="ico16 repeater_plus_16" id="addImg" style="display: block;" onclick="createTrfn()"></span></div><div id="addEmptyDiv" style="height: auto;">
				<span title="${ctp:i18n('form.base.delRow.label')}" class="ico16 repeater_reduce_16" id="delImg" style="display: block;" onclick="delTrfn()"></span>
			</div>
		</div>
    </form>
</body>
</html>