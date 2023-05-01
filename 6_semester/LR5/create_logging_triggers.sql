--DROP TRIGGER journal_entertainment_corporations_trigger;
--DROP TRIGGER journal_cinematic_universes_trigger;
--DROP TRIGGER journal_movies_trigger;

/

CREATE OR REPLACE TRIGGER journal_entertainment_corporations_trigger
AFTER UPDATE OR INSERT OR DELETE ON entertainment_corporations FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
    records_count NUMBER := NULL;
BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM journal_entertainment_corporations' INTO records_count;

    CASE
        WHEN inserting THEN
            INSERT INTO journal_entertainment_corporations 
            VALUES (records_count + 1, 'INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title, :NEW.ceo);
        
        WHEN updating THEN
             INSERT INTO journal_entertainment_corporations 
             VALUES (records_count + 1, 'UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.ceo);         
        
        WHEN deleting THEN
           INSERT INTO journal_entertainment_corporations 
           VALUES (records_count + 1, 'DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.ceo);
    END CASE;
END;

/

CREATE OR REPLACE TRIGGER journal_cinematic_universes_trigger
AFTER UPDATE OR INSERT OR DELETE ON cinematic_universes FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
    records_count NUMBER := NULL;
BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM journal_cinematic_universes' INTO records_count;

    CASE
        WHEN inserting THEN
            INSERT INTO journal_cinematic_universes 
            VALUES (records_count + 1, 'INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title, :NEW.owning_corporation);
        
        WHEN updating THEN
             INSERT INTO journal_cinematic_universes 
             VALUES (records_count + 1, 'UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.owning_corporation);         
        
        WHEN deleting THEN
           INSERT INTO journal_cinematic_universes 
           VALUES (records_count + 1, 'DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title, :OLD.owning_corporation);
    
    END CASE;
END;

/

CREATE OR REPLACE TRIGGER journal_movies_trigger
AFTER UPDATE OR INSERT OR DELETE ON movies FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
    records_count NUMBER := NULL;
BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM journal_movies' INTO records_count;

    CASE
        WHEN inserting THEN
            INSERT INTO journal_movies 
            VALUES (records_count + 1, 'INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.title,:NEW.release_date, :NEW.cinematic_universe);
        
        WHEN updating THEN
             INSERT INTO journal_movies 
             VALUES (records_count + 1, 'UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title,:OLD.release_date, :OLD.cinematic_universe);         
        
        WHEN deleting THEN
           INSERT INTO journal_movies 
           VALUES (records_count + 1, 'DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.title,:OLD.release_date, :OLD.cinematic_universe);
    
    END CASE;
END;