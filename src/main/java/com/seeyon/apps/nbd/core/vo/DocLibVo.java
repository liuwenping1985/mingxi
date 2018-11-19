package com.seeyon.apps.nbd.core.vo;

import com.seeyon.apps.doc.po.DocLibPO;

import java.util.List;

/**
 * Created by liuwenping on 2018/11/19.
 */
public class DocLibVo {

    private DocLibPO data;

    private List<DocLibVo> child;

    public DocLibPO getData() {

        return data;
    }

    public void setData(DocLibPO data) {
        this.data = data;
    }

    public List<DocLibVo> getChild() {
        return child;
    }

    public void setChild(List<DocLibVo> child) {
        this.child = child;
    }
}
