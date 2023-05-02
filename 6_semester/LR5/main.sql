-- before executing re-create tables, logging (journaling) tables and triggers
-- and insert data in fill_tables_with_data.sql as well

DECLARE
    html_report VARCHAR2(4096) := NULL;
BEGIN
    html_report := generate_html_report(TO_TIMESTAMP('02-MAY-23 10.04.52.529376000 AM'));
    DBMS_OUTPUT.PUT_LINE(html_report);
    NULL;
    --rollback_all_tables(TO_TIMESTAMP('02-MAY-23 10.04.52.529376000 AM'), TRUE);
    --recovery_manager.make_rollback(TO_TIMESTAMP('02-MAY-23 05.04.15.766216000 PM'), TRUE);
END;

/
-- clear journals :
--TRUNCATE TABLE journal_movies;
--TRUNCATE TABLE JOURNAL_ENTERTAINMENT_CORPORATIONS;
--TRUNCATE TABLE JOURNAL_CINEMATIC_UNIVERSES;

-- clear data :
--TRUNCATE TABLE movies;
--TRUNCATE TABLE cinematic_universes;
--TRUNCATE TABLE entertainment_corporations;

SELECT * FROM JOURNAL_CINEMATIC_UNIVERSES ORDER BY time_stamp DESC;
SELECT * FROM JOURNAL_MOVIES ORDER BY time_stamp DESC;
SELECT * FROM ENTERTAINMENT_CORPORATIONS;
SELECT * FROM CINEMATIC_UNIVERSES;
SELECT * FROM MOVIES;
