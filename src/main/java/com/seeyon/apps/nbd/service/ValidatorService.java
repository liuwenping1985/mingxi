package com.seeyon.apps.nbd.service;

import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.DataValidator;
import com.seeyon.apps.nbd.core.util.ValidateResult;
import com.seeyon.apps.nbd.core.vo.CommonParameter;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class ValidatorService {


    public static ValidateResult validate(CommonParameter p){

        DataValidator dv = new DataValidator(){

            public ValidateResult validate(CommonParameter p) {
                ValidateResult r = new ValidateResult();
                String dataType = p.$("data_type");
                if(NbdConstant.A8_TO_OTHER.equals(dataType)||NbdConstant.OTHER_TO_A8.equals(dataType)){
                    String name = p.$("name");
                    if(CommonUtils.isEmpty(name)){
                        r.setResult(false);
                        r.setMsg("名称不能为空");
                        return r;
                    }
                }

                r.setResult(true);
                return r;
            }
        };
        return dv.validate(p);

    }
}
