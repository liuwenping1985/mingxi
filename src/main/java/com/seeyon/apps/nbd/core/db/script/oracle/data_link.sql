CREATE TABLE data_link
   (
   id NUMBER(20,0) constraint id_pr primary key,
	name NVARCHAR2(255),
	create_time DATE,
	update_time DATE,
	data_base_name NVARCHAR2(255),
	host NVARCHAR2(255),
	status NUMBER(6,0),
	"user" NVARCHAR2(255),
	password NVARCHAR2(512),
	port NVARCHAR2(255),
	ext_string1 NVARCHAR2(255),
	ext_string2 NVARCHAR2(255),
	ext_string3 NVARCHAR2(255),
	ext_string4 NVARCHAR2(255),
	ext_string5 NVARCHAR2(255),
	link_type NVARCHAR2(255),
	db_type NVARCHAR2(255)
  )