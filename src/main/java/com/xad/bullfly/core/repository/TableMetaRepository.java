package com.xad.bullfly.core.repository;

import com.xad.bullfly.core.common.base.repository.BaseRepository;
import com.xad.bullfly.core.common.db.meta.TableMeta;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.annotation.sql.DataSourceDefinition;

/**
 * Created by liuwenping on 2019/8/27.
 */

@Repository
public interface TableMetaRepository extends BaseRepository<TableMeta,Long> {
    /**
     * 自注释
     * @param metaName
     * @return
     */
    @Query("select u from TableMeta u where u.metaName=:metaName")
    TableMeta findTableMetaByMetaName(@Param("metaName") String metaName);



}
