-- before executing re-create tables, logging (journaling) tables and triggers
-- and insert data in fill_tables_with_data.sql as well
BEGIN
    NULL;
END;

/

SELECT TO_CHAR(time_stamp, 'YYYY-MM-DD HH24:MI:SS') FROM JOURNAL_cinematic_universes;