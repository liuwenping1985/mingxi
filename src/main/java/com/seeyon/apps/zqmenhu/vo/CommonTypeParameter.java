package com.seeyon.apps.zqmenhu.vo;

/**
 * Created by liuwenping on 2018/10/24.
 */
public class CommonTypeParameter {

    private Integer offset=0;

    private Integer limit=100;

    private Long typeId;
    private Long docLibId;

    public Long getDocLibId() {
        return docLibId;
    }
    public void setDocLibId(Long docLibId) {
        this.docLibId = docLibId;
    }

    public Integer getOffset() {
        return offset;
    }

    public void setOffset(Integer offset) {
        this.offset = offset;
    }

    public Integer getLimit() {
        return limit;
    }

    public void setLimit(Integer limit) {
        this.limit = limit;
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }
}
