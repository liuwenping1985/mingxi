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
@Table(name = "pf_table_meta")
public class TableMeta extends AbstractMeta<Long> {

    @Column(name = "table_name")
    private String tableName;
    @Column(name = "table_type")
    private String tableType;
    @Column(name = "table_group")
    private String tableGroup;

}
