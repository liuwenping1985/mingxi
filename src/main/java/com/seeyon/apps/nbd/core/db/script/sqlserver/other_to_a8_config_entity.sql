CREATE TABLE other_to_a8_config_entity
(
	id              BIGINT NOT NULL ,
	name            NVARCHAR(255),
	create_time     DATETIME,
	update_time     DATETIME,
	status          NUMERIC(6, 0),
	affair_type     NVARCHAR(255),
	trigger_type    NVARCHAR(512),
	export_type     NVARCHAR(255),
	export_url      NVARCHAR(255),
	link_id         NVARCHAR(255),
	ftd_id          BIGINT,
	table_name      NVARCHAR(255),
	[period]       		NVARCHAR(255),
	trigger_process NVARCHAR(255),
	PRIMARY KEY (id)
)