CREATE TABLE ftd
   (	id BIGINT NOT NULL,
	    name NVARCHAR(255),
	    create_time DATETIME,
	    update_time DATETIME,
	    status NUMERIC(6,0),
	    data NTEXT,
			PRIMARY KEY (id)
	)