package com.xad.bullfly.core.common.vo;

import java.io.Serializable;
import java.util.Map;

/**
 * 仅仅是为了简写，少敲几个字
 * Created by liuwenping on 2019/8/19.
 */
public final class GVO<KEY extends Serializable,VALUE> extends GenericValueObject<KEY,VALUE> {

    /**
     * generateDataResponse
     * toResponseDataMapWhenResultIsSingleObject
     * @param ret
     * @param data
     * @param msg
     * @return
     */
    public static Map GDR(Boolean ret, Object data, String msg){
        GVO gvo = new GVO();
        gvo.put(RESPONSE_VO_DATA_FIELDNAME, data);
        gvo.put(RESPONSE_VO_RESULT_FIELDNAME,ret);
        gvo.put(RESPONSE_VO_MSG_FIELDNAME,msg);
        return gvo.toResponseDataMapWhenResultIsSingleObject();

    }

    /**
     * generateDataResponse
     * toResponseListMapWhenResultIsList
     * @param ret
     * @param data
     * @param msg
     * @return
     */
    public static Map GDLR(Boolean ret,Object data,String msg){
        GVO gvo = new GVO();
        gvo.put(RESPONSE_VO_RESULT_FIELDNAME,ret);
        gvo.put(RESPONSE_VO_MSG_FIELDNAME,msg);
        gvo.put(RESPONSE_VO_ITEMS_FIELDNAME,data);
        return gvo.toResponseListMapWhenResultIsList();

    }
}
