create table tab_content_file_recive (
id int not null,
fileId int IDENTITY (1, 1) not null,
fileName nvarchar(100),
fileContent image,
fileState int
);

create table tab_content_file_send (
id int,
fileId int not null,
fileName nvarchar(100) ,
fileContent image,
fileState int
);

create table tab_content_recive (
id int IDENTITY (1, 1) not null,
content nvarchar(4000),
flag int,
createDate datetime,
unitName nvarchar(40)
);

create table tab_content_send (
id int not null,
content nvarchar(4000),
flag int,
createDate datetime,
lockstatus nvarchar(2),
unitName nvarchar(40)
);