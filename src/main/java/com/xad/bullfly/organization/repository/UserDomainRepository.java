package com.xad.bullfly.organization.repository;

import com.xad.bullfly.core.common.base.repository.BaseRepository;
import com.xad.bullfly.organization.domain.UserDomain;
import org.springframework.stereotype.Repository;

/**
 * Created by liuwenping on 2019/9/2.
 */
@Repository
public interface UserDomainRepository  extends BaseRepository<UserDomain,Long> {


}
