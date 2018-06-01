create table IDTable  (
  name           NVARCHAR2(50),
  value          NUMBER(4),
  nextValue      NUMBER(4),
  initValue      NUMBER(4),
   constraint PK_IDTable primary key (name)
);

create table Tab_Content_File_Recive  (
  id         	 NUMBER(4) not null,  
  fileId         NUMBER(4),
  fileName       NVARCHAR2(100),
  fileContent    BLOB,
  fileState      NUMBER(4),
   constraint PK_Tab_Content_File_Recive primary key (fileId)
);

create table Tab_Content_File_Send  (
  id         	 NUMBER(4) not null,  
  fileId         NUMBER(4),
  fileName       NVARCHAR2(100),
  fileContent    BLOB,
  fileState      NUMBER(4),
   constraint PK_Tab_Content_File_Send primary key (fileId)
);

create table Tab_Content_Recive  (
  id         	 NUMBER(4) not null,  
  content        NVARCHAR2(2000),
  flag    	 NUMBER(4),
  createDate     DATE,
  unitName       NVARCHAR2(40),
   constraint PK_Tab_Content_Recive primary key (id)
);

create table Tab_Content_send  (
  id         	 NUMBER(4) not null,  
  content        NVARCHAR2(2000),
  flag    	 NUMBER(4),
  createDate     DATE,
  lockstatus	 NVARCHAR2(2),
  unitName       NVARCHAR2(40),
  constraint PK_Tab_Content_send primary key (id)
);

create sequence S_Tab_Content_File_Recive;

create sequence S_Tab_Content_File_Send;

create sequence S_Tab_Content_Recive;

create sequence S_Tab_Content_send;