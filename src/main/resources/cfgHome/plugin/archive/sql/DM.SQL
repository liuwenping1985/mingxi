/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2015/6/3 14:41:02                            */
/*==============================================================*/


/*==============================================================*/
/* Table: DOC_ARCHIVE                                    */
/*==============================================================*/
CREATE TABLE DOC_ARCHIVE (
  ID BIGINT NOT NULL,
  ARCHIVE_ID BIGINT,
  DOC_XML CLOB,
  CREATE_TIME TIMESTAMP,
  STATE SMALLINT,
  CONSTRAINT PK_DOC_ARCHIVE PRIMARY KEY (ID)
)