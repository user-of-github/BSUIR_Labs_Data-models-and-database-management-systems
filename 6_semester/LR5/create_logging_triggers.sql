-- EXECUTE ONE BY ONE !!

DROP TRIGGER journal_entertainment_corporations_trigger;
DROP TRIGGER journal_cinematic_universes_trigger;
DROP TRIGGER journal_movies_trigger;



CREATE OR REPLACE TRIGGER journal_entertainment_corporations_trigger
AFTER UPDATE OR INSERT OR DELETE 
ON entertainment_corporations FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN inserting THEN
            INSERT INTO journal_entertainment_corporations (operation, time_stamp, id, title, ceo)
            VALUES ('INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title, :NEW.ceo);

            COMMIT; -- without commit caused error !
        
        WHEN updating THEN
            INSERT INTO journal_entertainment_corporations (operation, time_stamp, id, title, ceo)
            VALUES ('UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.ceo);      

            COMMIT; -- without commit caused error !   
        
        WHEN deleting THEN
           INSERT INTO journal_entertainment_corporations (operation, time_stamp, id, title, ceo)
           VALUES ('DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.ceo);

           COMMIT; -- without commit caused error !

    END CASE;
END;

/

CREATE OR REPLACE TRIGGER journal_cinematic_universes_trigger
AFTER UPDATE OR INSERT OR DELETE ON cinematic_universes FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN inserting THEN
            INSERT INTO journal_cinematic_universes (operation, time_stamp, id, title, owning_corporation)
            VALUES ('INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title, :NEW.owning_corporation);

            COMMIT; -- without commit caused error !

        WHEN updating THEN
            INSERT INTO journal_cinematic_universes (operation, time_stamp, id, title, owning_corporation)
            VALUES ('UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.owning_corporation);         

            COMMIT; -- without commit caused error !

        WHEN deleting THEN
           INSERT INTO journal_cinematic_universes (operation, time_stamp, id, title, owning_corporation)
           VALUES ('DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.owning_corporation);

            COMMIT; -- without commit caused error !

    END CASE;
END;

/

CREATE OR REPLACE TRIGGER journal_movies_trigger
AFTER UPDATE OR INSERT OR DELETE ON movies FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN inserting THEN
            INSERT INTO journal_movies (operation, time_stamp, id, title, release_date, cinematic_universe)
            VALUES ('INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title,:NEW.release_date, :NEW.cinematic_universe);

            COMMIT;
            
        WHEN updating THEN
            INSERT INTO journal_movies (operation, time_stamp, id, title, release_date, cinematic_universe)
            VALUES ('UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title,:OLD.release_date, :OLD.cinematic_universe);         

            COMMIT;

        WHEN deleting THEN
            INSERT INTO journal_movies (operation, time_stamp, id, title, release_date, cinematic_universe)
            VALUES ('DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title,:OLD.release_date, :OLD.cinematic_universe);

            COMMIT;

    END CASE;
END;