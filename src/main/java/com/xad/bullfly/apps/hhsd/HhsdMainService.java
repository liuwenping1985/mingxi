package com.xad.bullfly.apps.hhsd;

import com.xad.bullfly.apps.hhsd.repository.HhsdDubanTaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Component
public class HhsdMainService {



    @Autowired
    private HhsdDubanTaskRepository hhsdDubanTaskRepository;


    public HhsdDubanTaskRepository saveHhsdDubanTaskRepository(){
       return null;
    }


}
