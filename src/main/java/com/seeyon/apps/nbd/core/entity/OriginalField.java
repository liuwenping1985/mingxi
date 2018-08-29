package com.seeyon.apps.nbd.core.entity;

/**
 * 关联子表
 * Created by liuwenping on 2018/8/22.
 */
public class OriginalField extends FieldMeta {


    private Entity entity;



    public Entity getEntity() {
        return entity;
    }

    public void setEntity(Entity entity) {
        this.entity = entity;
    }
}
