## _Laboratory work 5_
___   
_That not to conflict with previous labs, run [0.create_user_for_5_lab](./0.create_user_for_5_lab.sql) script from `SYS` role and then connect to this created `LR5_SCHEMA`_

### So to test this lab, you:  
* _Execute from SYS user `0.create_user_for_5_lab.sql` script, connect to DB from this created user (`LR5_SCHEMA`)_ 
* _Create tables from `1.create_tables.sql` script (without DROPing them, because initially they aren't created)_  
* _Then create journaling tables for logging DML actions by executing commands from script `2.create_tables_journals.sql` (also without DROPing them that not to catch `table or view does not exist` error)_  
* _Create logging triggers by executing CREATE OR REPLACE commands from `3.create_logging_triggers.sql` file. In my case Oracle threw errors when trying to execute the whole file - so probably recommend to create triggers one by one (execute only part of SQL for creating exact trigger)_  
* _After this you need to insert dome data to 3 main tables. You can use queries from `4.fill_tables_with_data.sql` file. But run commands with interval that to see difference in time in logging tables later_  
* _So now you can check out journals for every table. For example you can run `SELECT * FROM journal_movies;` command from `main.sql` (just entry-point-file to test everything) and see journal for `movies` table_  
* _To test my html-report-generator, create this function firstly by executing `5.create_html_report_procedure.sql` and call it for example from `main.sql` or other comfortable place. ==> You'll see string containing HTML markup_  
* _To test my rollback-procedure, create this procedure by executing `6.rollback_procedure.sql` and call it for example from `main.sql` or other comfortable place. ==> Your changes starting from some time are expected to be rollbacked_


___
###### Copyright © 2023 May