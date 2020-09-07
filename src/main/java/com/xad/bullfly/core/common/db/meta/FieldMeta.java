package com.xad.bullfly.core.common.db.meta;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by liuwenping on 2019/8/19.
 * @Author liuwenping
 */
@Data
@Entity
@Table(name = "pf_field_meta")
public class FieldMeta extends AbstractMeta<Long> {

    @Column(name = "table_name")
    private String fieldName;

    @Column(name = "field_type")
    private String fieldType;

    @Column(name = "field_data")
    private String fieldData;


}
