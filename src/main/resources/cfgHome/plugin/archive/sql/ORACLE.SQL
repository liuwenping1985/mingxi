/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2015/6/3 14:41:02                            */
/*==============================================================*/


/*==============================================================*/
/* Table: DOC_ARCHIVE                                    */
/*==============================================================*/
CREATE TABLE DOC_ARCHIVE (
  ID INTEGER NOT NULL,
  ARCHIVE_ID INTEGER,
  DOC_XML CLOB,
  CREATE_TIME DATE,
  STATE NUMBER(4),
  CONSTRAINT PK_DOC_ARCHIVE PRIMARY KEY (ID)
)