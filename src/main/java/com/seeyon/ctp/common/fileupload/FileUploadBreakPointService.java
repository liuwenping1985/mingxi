package com.seeyon.ctp.common.fileupload;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2018/11/25.
 */
public class FileUploadBreakPointService {

    private PartitionManager partitionManager;


    private PartitionManager getPartitionManager(){
        if(partitionManager == null){
            partitionManager = (PartitionManager)AppContext.getBean("partitionManager");
        }

        return partitionManager;
    }

    public ModelAndView queryFileUploadProcess(HttpServletRequest request, HttpServletResponse response){





        return null;
    }




}
