/**
 * Author : xuqw
 *   Date : 2014年11月7日 上午11:09:25
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.v3x.system.signet.enums;


/**
 * <p>Title       : 网页签名类型枚举</p>
 * <p>Description : 网页签名类型枚举</p>
 * <p>Copyright   : Copyright (c) 2012</p>
 * <p>Company     : seeyon.com</p>
 */
public enum V3xHtmSignatureEnum {
    
    /** 网页签章，默认类型 **/
    HTML_SIGNATURE_DOCUMENT(0),
    
    /** 公文审批，签名显示电子签名 **/
    HTML_SIGNATURE_EDOC_FLOW_INSCRIBE(1);

    private int key = 0;

    V3xHtmSignatureEnum(int key) {
        this.key = key;
    }

    public int getKey() {
        return this.key;
    }

    public int key() {
        return this.key;
    }

    /**
     * 根据key得到枚举类型
     * 
     * @param key
     * @return StateEnum
     */
    public static V3xHtmSignatureEnum valueOf(int key) {
        V3xHtmSignatureEnum[] enums = V3xHtmSignatureEnum.values();

        if (enums != null) {
            for (V3xHtmSignatureEnum enum1 : enums) {
                if (enum1.getKey() == key) {
                    return enum1;
                }
            }
        }

        return null;
    }
}
