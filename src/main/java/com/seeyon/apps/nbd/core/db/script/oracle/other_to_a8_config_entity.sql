CREATE TABLE other_to_a8_config_entity
(
	id              NUMBER(20, 0) NOT NULL ENABLE,
	name            NVARCHAR2(255),
	create_time     DATE,
	update_time     DATE,
	status          NUMBER(6, 0),
	affair_type     NVARCHAR2(255),
	trigger_type    NVARCHAR2(512),
	export_type     NVARCHAR2(255),
	export_url      NVARCHAR2(255),
	link_id         NVARCHAR2(255),
	ftd_id          NUMBER(20, 0),
	table_name      NVARCHAR2(255),
	period       		NVARCHAR2(255),
	trigger_process NVARCHAR2(255),
	PRIMARY KEY (id)
)