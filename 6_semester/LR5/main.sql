-- before executing re-create tables, logging (journaling) tables and triggers
-- and insert data in fill_tables_with_data.sql as well

DECLARE
    html_report VARCHAR2(4096) := NULL;
BEGIN
    --html_report := generate_html_report(TO_TIMESTAMP('01-MAY-23 06.18.00.000000000 PM'));
    --DBMS_OUTPUT.PUT_LINE(html_report);

   rollback_all_tables(TO_TIMESTAMP('01-MAY-23 06.18.00.000000000 PM'), FALSE);
END;

/

SELECT * FROM journal_movies;
