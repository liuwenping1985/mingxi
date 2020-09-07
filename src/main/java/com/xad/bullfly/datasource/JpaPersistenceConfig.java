package com.xad.bullfly.datasource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.orm.jpa.JpaProperties;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.persistence.EntityManager;
import javax.sql.DataSource;
import java.util.Map;

/**
 * 持久化配置，支持多个数据源，主要的切换在这里配置
 * Created by liuwenping on 2019/8/27.
 * @Author liuwenping
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(basePackages={"com.xad.bullfly"})
public class JpaPersistenceConfig {

    private static final Logger log = LoggerFactory.getLogger(JpaPersistenceConfig.class);

    @Autowired
    @Qualifier("primary_data_source")
    private DataSource primaryDataSource;

    @Autowired
    private JpaProperties jpaProperties;

    @Primary
    @Bean(name = "entityManager")
    public EntityManager entityManager(EntityManagerFactoryBuilder builder) {
        log.debug("init entityManager=====[START]");
        EntityManager entityManager = entityManagerFactoryPrimary(builder).getObject().createEntityManager();
        log.debug("init entityManager=====["+(entityManager==null?"FAILED":"OK")+"]");
        return entityManager;
    }

    @Primary
    @Bean(name = "entityManagerFactory")
    public LocalContainerEntityManagerFactoryBean entityManagerFactoryPrimary (EntityManagerFactoryBuilder builder) {
        return builder
                .dataSource(primaryDataSource)
                .properties(getVendorProperties(primaryDataSource))
                .packages("com.xad.bullfly")
                .persistenceUnit("primaryPersistenceUnit")
                .build();
    }



    private Map<String, String> getVendorProperties(DataSource dataSource) {

        return jpaProperties.getProperties();

    }

    @Primary
    @Bean(name = "transactionManager")
    public PlatformTransactionManager transactionManagerPrimary(EntityManagerFactoryBuilder builder) {
        return new JpaTransactionManager(entityManagerFactoryPrimary(builder).getObject());
    }

}
