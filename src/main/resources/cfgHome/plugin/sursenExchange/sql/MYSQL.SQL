create table tab_content_file_recive (
id int not null,
fileId int not null auto_increment,
fileName varchar(100),
fileContent longblob,
fileState int,
primary key (fileId)
);

create table tab_content_file_send (
id int,
fileId int not null auto_increment,
fileName varchar(100) ,
fileContent longblob,
fileState int,
primary key (fileId)
);

create table tab_content_recive (
id int not null auto_increment ,
content varchar(4000),
flag int,
createDate datetime,
unitName varchar(40),
primary key (id)
);

create table tab_content_send (
id int not null auto_increment,
content varchar(4000),
flag int,
createDate datetime,
lockstatus varchar(2),
unitName varchar(40),
primary key (id)
);