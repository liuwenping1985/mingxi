CREATE TABLE ftd
   (	id BIGINT NOT NULL,
	    name NVARCHAR(255),
	    create_time DATETIME,
	    update_time DATETIME,
	    status NUMERIC(6,0),
	    data NTEXT,
	ext_string1    NVARCHAR(255),
	ext_string2    NVARCHAR(255),
	ext_string3    NVARCHAR(255),
	ext_string4    NVARCHAR(255),
	ext_string5    NVARCHAR(255),
	ext_string6    NVARCHAR(255),
	ext_string7    NVARCHAR(255),
	ext_string8    NVARCHAR(255),
			PRIMARY KEY (id)
	)