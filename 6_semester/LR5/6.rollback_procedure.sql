DROP TABLE rollback_scripts;

CREATE TABLE rollback_scripts (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_of_operation NUMBER NOT NULL,
    operation_time TIMESTAMP NOT NULL,
    script VARCHAR2(1000)
);

CREATE OR REPLACE PROCEDURE rollback_entertainment_corporations_table(ts TIMESTAMP) 
AS
BEGIN
    FOR	log_row in (SELECT operation_id, operation, time_stamp, id, title, ceo FROM journal_entertainment_corporations WHERE time_stamp > ts AND is_reverted = 0 ORDER BY time_stamp DESC) LOOP
        CASE log_row.operation
            WHEN 'INSERT' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'DELETE FROM entertainment_corporations WHERE id =' || log_row.id );
             
            WHEN 'UPDATE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'UPDATE entertainment_corporations SET title = ''' || log_row.title || ''', ceo = ''' || log_row.ceo || ''' WHERE id =' || log_row.id );
            
            WHEN 'DELETE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'INSERT INTO entertainment_corporations(id, title, ceo) VALUES (' || log_row.id || ', ''' || log_row.title || ''', ''' || log_row.ceo || ''' )');
        END CASE;
    END LOOP;
END;

/


CREATE OR REPLACE PROCEDURE rollback_cinematic_universes_table(ts TIMESTAMP) 
AS
BEGIN
    FOR	log_row in (SELECT operation_id, operation, time_stamp, id, title, owning_corporation FROM journal_cinematic_universes WHERE time_stamp > ts AND is_reverted = 0 ORDER BY time_stamp DESC) LOOP
        CASE log_row.operation
            WHEN 'INSERT' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'DELETE FROM cinematic_universes WHERE id =' || log_row.id );
             
            WHEN 'UPDATE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'UPDATE cinematic_universes SET title = ''' || log_row.title || ''', owning_corporation = ' || log_row.owning_corporation || ' WHERE id =' || log_row.id );
            
            WHEN 'DELETE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'INSERT INTO cinematic_universes(id, title, owning_corporation) VALUES (' || log_row.id || ', ''' || log_row.title || ''', ' || log_row.owning_corporation || ' )');
        END CASE;
    END LOOP;
END;

/

CREATE OR REPLACE PROCEDURE rollback_movies_table(ts TIMESTAMP) 
AS
BEGIN
    FOR	log_row in (SELECT operation_id, operation, time_stamp, id, title, release_date, cinematic_universe FROM journal_movies WHERE time_stamp > ts AND is_reverted = 0 ORDER BY time_stamp DESC) LOOP
        CASE log_row.operation
            WHEN 'INSERT' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'DELETE FROM movies WHERE id =' || log_row.id );
             
            WHEN 'UPDATE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'UPDATE movies SET title = ''' || log_row.title || ''', release_date = TO_DATE(''' || TO_CHAR(log_row.release_date) || '''), cinematic_universe  = ' || log_row.cinematic_universe || ' WHERE id =' || log_row.id );
            
            WHEN 'DELETE' THEN
                INSERT INTO	rollback_scripts(id_of_operation, operation_time, script) VALUES (log_row.operation_id, log_row.time_stamp, 'INSERT INTO movies(id, title, release_date, cinematic_universe) VALUES (' || log_row.id || ', ''' || log_row.title || ''', TO_DATE(''' || TO_CHAR(log_row.release_date) || '''), ' || log_row.cinematic_universe|| ' )');
        END CASE;
    END LOOP;
END;

/

CREATE OR REPLACE PROCEDURE rollback_all_tables(time_stamp TIMESTAMP)
AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE rollback_scripts';
    
    rollback_entertainment_corporations_table(time_stamp); 
    rollback_cinematic_universes_table(time_stamp);
    rollback_movies_table(time_stamp);

    FOR	script_row in (SELECT id_of_operation, script FROM rollback_scripts ORDER BY operation_time DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('[rollback_all_tables]: ' || script_row.script);
    END LOOP;

    -- TODO TEST
    --EXECUTE IMMEDIATE 'UPDATE journal_entertainment_corporations SET is_reverted = 1 WHERE operation_id IN (SELECT id_of_operation FROM rollback_scripts)';
    --EXECUTE IMMEDIATE 'UPDATE journal_cinematic_universes SET is_reverted = 1 WHERE operation_id IN (SELECT id_of_operation FROM rollback_scripts)';
    --EXECUTE IMMEDIATE 'UPDATE journal_movies SET is_reverted = 1 WHERE operation_id IN (SELECT id_of_operation FROM rollback_scripts)';
END;