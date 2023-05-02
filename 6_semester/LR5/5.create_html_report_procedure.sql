CREATE OR REPLACE FUNCTION generate_html_report(ts IN TIMESTAMP) 
RETURN VARCHAR2 
IS
    response VARCHAR2(4096):='
<!DOCTYPE html>
<html>
<head>
<title>Report sinse ' || TO_CHAR(ts) || '</title>
    <style>
    * {
        font-family: ''Roboto'', sans-serif;
    }
    table, th, td {
        border: 1px solid black;
    }
    table {
        margin: auto;
    }

    td {
        text-align: center;
        padding: 5px;
    }
    </style>
</head>
<body> 
<table>';
    
    sys_ref_c SYS_REFCURSOR := NULL;
    operation_name VARCHAR(100) := NULL; 
    operation_count NUMBER := NULL; 

BEGIN
    -- entertainment_corporations TABLE
    response := response || '<tr><td colspan="2"><strong> ENTERTAINMENT CORPORATIONS </strong></td> </tr>' || CHR(10);

    OPEN sys_ref_c FOR 'SELECT operation, COUNT(*) FROM journal_entertainment_corporations WHERE is_reverted=0 AND TO_CHAR(time_stamp, ''YYYY-MM-DD HH24:MI:SS.FF3'') > ' || '''' || TO_CHAR(ts, 'YYYY-MM-DD HH24:MI:SS.FF3') || '''' || ' GROUP BY operation';
    LOOP
        FETCH sys_ref_c INTO operation_name, operation_count; 
        EXIT WHEN sys_ref_c%NOTFOUND;
        response := response || '<tr><td>' || operation_name || '</td><td>' || operation_count || '</td></tr>' || CHR(10); 
    END LOOP;

    CLOSE sys_ref_c;
--
--
    ---- cinematic_universes TABLE
    response := response || '<tr><td colspan="2"><strong> CINEMATIC UNIVERSES </strong></td> </tr>' || CHR(10);
    
    OPEN sys_ref_c FOR 'SELECT operation, COUNT(*) FROM journal_cinematic_universes WHERE is_reverted=0 AND TO_CHAR(time_stamp, ''YYYY-MM-DD HH24:MI:SS.FF3'') > ' || '''' || TO_CHAR(ts, 'YYYY-MM-DD HH24:MI:SS.FF3') || '''' || ' GROUP BY operation';
    LOOP
        FETCH sys_ref_c INTO operation_name, operation_count; 
        EXIT WHEN sys_ref_c%NOTFOUND;
        response := response || '<tr><td>' || operation_name || '</td><td>' || operation_count || '</td></tr>' || CHR(10); 
    END LOOP;

    CLOSE sys_ref_c;


    -- movies TABLE
    response := response || '<tr><td colspan="2"><strong> MOVIES </strong></td> </tr>' || CHR(10);

    OPEN sys_ref_c FOR 'SELECT operation, COUNT(*) FROM journal_movies WHERE is_reverted=0 AND TO_CHAR(time_stamp, ''YYYY-MM-DD HH24:MI:SS.FF3'') > ' || '''' || TO_CHAR(ts, 'YYYY-MM-DD HH24:MI:SS.FF3') || '''' || ' GROUP BY operation';
    LOOP
        FETCH sys_ref_c INTO operation_name, operation_count; 
        EXIT WHEN sys_ref_c%NOTFOUND;
        response := response || '<tr><td>' || operation_name || '</td><td>' || operation_count || '</td></tr>' || CHR(10); 
    END LOOP;

    CLOSE sys_ref_c;


    response := response || '</table>' || CHR(10) || '</body>' || CHR(10) || '</html>'; 

    RETURN response;
END;
