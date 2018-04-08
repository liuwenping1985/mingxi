/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2015/6/3 14:52:01                            */
/*==============================================================*/
CREATE TABLE DOC_ARCHIVE (
  ID BIGINT NOT NULL,
  ARCHIVE_ID BIGINT,
  DOC_XML TEXT,
  CREATE_TIME DATETIME,
  STATE SMALLINT,
  CONSTRAINT PK_DOC_ARCHIVE PRIMARY KEY NONCLUSTERED (ID)
)