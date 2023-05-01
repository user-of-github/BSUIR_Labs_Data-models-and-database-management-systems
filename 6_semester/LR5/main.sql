-- before executing re-create tables, logging (journaling) tables and triggers
-- and insert data in fill_tables_with_data.sql as well
BEGIN
    NULL;
END;

/

SELECT * FROM journal_movies;