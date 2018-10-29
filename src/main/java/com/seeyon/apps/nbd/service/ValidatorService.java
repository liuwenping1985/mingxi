package com.seeyon.apps.nbd.service;

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
                r.setResult(true);
                return r;
            }
        };
        return dv.validate(p);

    }
}
