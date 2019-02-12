package com.seeyon.apps.kdXdtzXc.util;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;

/**
 * Created by tap-pcng43 on 2017-8-15.
 */
public class ModelTool {
    public static String getSqlStr(String s){
        return StringUtilsExt.isNullOrNone(s)?null:"'"+s+"'";
    }
}
