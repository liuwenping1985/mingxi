package com.seeyon.apps.kdXdtzXc.util.json;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

import java.text.DecimalFormat;

import org.apache.commons.lang.StringUtils;

public class DoubleJsonValueProcessor implements JsonValueProcessor {
   // protected Logger logger = LoggerFactory.getLogger(getClass());
    private DecimalFormat decimalFormat;

    public DoubleJsonValueProcessor(String doublePattern) {
        try {
            if (!StringUtils.isEmpty(doublePattern))
                decimalFormat = new DecimalFormat(doublePattern);
        } catch (Exception ex) {
            decimalFormat = null;
        }
    }

    public Object processArrayValue(Object value, JsonConfig jsonConfig) {
        if (value == null)
            return null;
        String[] obj = {};
        if (decimalFormat == null)
            return obj;
        Double[] doubles = (Double[]) value;
        if (doubles != null && doubles.length > 0) {
            for (int i = 0; i < doubles.length; i++) {
                obj[i] = decimalFormat.format((Double) value);
            }
        }
        return obj;
    }

    public Object processObjectValue(String key, Object value, JsonConfig jsonConfig) {
        if (value == null)
            return null;
        if (decimalFormat == null)
            return value;
        return decimalFormat.format((Double) value);
    }

}