package com.xad.bullfly.core.service;

import com.xad.bullfly.core.common.service.MicroService;

import java.io.Serializable;

/**
 * 数据持久化。提供关系数据库。NOSQL 数据库，内存数据库，文件库等多种方式
 * Created by liuwenping on 2019/8/19.
 */
public interface DataPersistenceService extends MicroService {


    <T extends Serializable> T save(T t);

    <T extends Serializable> T saveOrUpdate(T t);

    <T extends Serializable> T update(T t);


    <T extends Serializable> T delete(T t);



}
