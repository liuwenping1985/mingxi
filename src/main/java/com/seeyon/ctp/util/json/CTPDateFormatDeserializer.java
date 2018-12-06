//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.util.json;

import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.parser.DefaultJSONParser;
import com.alibaba.fastjson.parser.deserializer.SqlDateDeserializer;
import com.seeyon.ctp.util.Datetimes;
import java.lang.reflect.Type;
import java.util.Date;

public class CTPDateFormatDeserializer extends SqlDateDeserializer {
    public CTPDateFormatDeserializer() {
    }

    protected <T> T cast(DefaultJSONParser parser, Type clazz, Object fieldName, Object val) {
        if (val == null) {
            return null;
        } else if (val instanceof String) {
            String strVal = (String)val;
            return strVal.length() == 0 ? null :(T)Datetimes.parse(strVal);
        } else if(val instanceof Long){

                return (T)new Date((Long)val);
        }else{
            throw new JSONException("parse error");
        }
    }
}
