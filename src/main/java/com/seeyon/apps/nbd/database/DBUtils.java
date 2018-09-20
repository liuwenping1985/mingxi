package com.seeyon.apps.nbd.database;

import org.hibernate.dialect.Dialect;
import org.hibernate.dialect.MySQLDialect;
import org.hibernate.dialect.Oracle10gDialect;
import org.hibernate.tool.hbm2ddl.DatabaseMetadata;

import java.sql.SQLException;

/**
 * Created by liuwenping on 2018/9/18.
 */
public class DBUtils {


    /**
     *
     Oracle10gDialect dialect = new Oracle10gDialect();
     DatabaseMetadata databaseMetadata = new DatabaseMetadata(dataSource.getConnection(),dialect, null);
     TableMetadata tableMetadata = databaseMetadata.getTableMetadata("demotable", "demoschema", "", false);
     Field field = FieldUtils.getField(TableMetadata.class,"columns",true);
     Map<String,ColumnMetadata> columns = (Map<String, ColumnMetadata>) field.get(tableMetadata);

     Table table = new Table("demotable");
     columns.values().stream().forEach(e -> {
     Column column = new Column(e.getName());
     column.setNullable("YES".equals(e.getNullable()));
     column.setSqlType(e.getTypeName());
     table.addColumn(column);
     });
     System.out.println("table.sqlCreateString(dialect,null,null,"demoschema"));


     */


    public static void main(String[] args){
        Dialect dialect = new Oracle10gDialect();
        MySQLDialect dialect1 = new MySQLDialect();
        try {
            DatabaseMetadata databaseMetadata = new DatabaseMetadata(null,dialect, true);
        } catch (SQLException e) {
            e.printStackTrace();
        }


    }
}
