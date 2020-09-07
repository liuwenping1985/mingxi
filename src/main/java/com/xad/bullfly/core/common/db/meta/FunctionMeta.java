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
@Table(name = "pf_function_meta")
public class FunctionMeta extends AbstractMeta<Long>  {

    @Column(name = "function_name")
    private String functionName;

    @Column(name = "function_data")
    private String functionData;
}
