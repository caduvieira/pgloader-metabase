FROM dimitri/pgloader

COPY insert.sql insert.sql
COPY load.pgloader load.pgloader
	
