package com.xad.bullfly.core.common.base.repository;

import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;

/**
 * Created by liuwenping on 2019/8/27.
 */
@NoRepositoryBean
public interface BaseRepository<T extends ManagedObject, I extends Serializable> extends JpaRepository<T, I> {


}
