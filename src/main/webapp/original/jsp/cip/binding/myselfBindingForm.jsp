<%@ page language="java" contentType="text/html; charset=UTF-8"%>

    <form name="addForm" id="addForm" method="post" target="delIframe" class="validate">
    <div class="form_area" >
        <div class="one_row" style="width: 550px;">
        <p class="align_right"><font color="red">*</font>${ctp:i18n('cip.form.must')}</p>
            <table border="0" cellspacing="0" cellpadding="0" style="width: 550px;">
            <input type="hidden" id="id" name="id" value="-1">
                     
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.register.appname')}:</label></th>
                        <td>
                        <div class="common_selectbox_wrap">
                                <select id="registerId" name="registerId" >
                                </select>
                                </div>
                        </td>
                    </tr>
                 
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n("cip.service.binding.thirdaccount")}:</label></th>
                   <td>
                    <div class="common_txtbox_wrap">
                            <input type="text" id="thirdAccount" name="thirdAccount" class="w100b validate" validate="notNull:true,name:'${ctp:i18n('cip.service.binding.thirdaccount')}',minLength:1,maxLength:85">
                        </div>
                     </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.config.third')}${ctp:i18n('cip.scheme.param.config.pass')}:</label></th>
                        <td>
                                <div class="common_txtbox_wrap">
                                 <input type="password" id="thirdPassword" name="thirdPassword" class="w100b validate" validate="notNull:false,name:'${ctp:i18n('cip.service.binding.userpassword')}'">
                                </div>
                            </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.binding.opertation.type')}:</label></th>
                        <td>
                                <div class="common_selectbox_wrap">
                                  <select id="bindingType" name="bindingType" >
                                   <option value="0">${ctp:i18n('cip.service.binding.type.idcard')}</option>
                                  </select>
                                </div>
                            </td>
                    </tr>
            </table>
        </div>
        </div>
    </form>
