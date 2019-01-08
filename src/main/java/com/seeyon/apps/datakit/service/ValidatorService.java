package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.util.DataValidator;
import com.seeyon.apps.datakit.util.ValidateResult;
import com.seeyon.apps.datakit.vo.CommonParameter;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class ValidatorService {


    public static ValidateResult validate(CommonParameter p){

        DataValidator dv = new DataValidator(){

            public ValidateResult validate(CommonParameter p) {
                ValidateResult r = new ValidateResult();
                r.setResult(true);
                return r;
            }
        };
        return dv.validate(p);

    }
}
