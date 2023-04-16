## _Laboratory work 3_
___
### _To test lab:_  
* _Firstly set up and run DB_  
* _Connect to DB_  
* _From [./set_up_working_schemas](./set_up_working_schemas) folder execute scripts:_  
    * `create_schemas.sql`  
    * `dev_schema_queries.sql`   
    * `prod_schema_queries.sql`  
* _Create utils by executing [./functionality/utils.sql](./functionality/utils.sql)_  
* _Create comparison (and other) functions from `functionality` folder, that are used in main scripts `task1`, `task1` ..._  
* _Now you can run `task1`, `task2` .. and check out results_  
___

### _To launch Oracle Database inside Docker container:_  
* _Go to https://container-registry.oracle.com/_
* _Pull the last Oracle Database Express Edition image `docker pull container-registry.oracle.com/database/express:latest`_
* `docker run -e ORACLE_PWD="<any password>" --name <any image> -d -p 1521:1521 container-registry.oracle.com/database/express`
    * _For example, my command looked like `docker run -e ORACLE_PWD="SYSTEM" --name oracle-xe-db-docker -d -p 1521:1521 container-registry.oracle.com/database/express`_
* _In Microsoft Visual Studio Code download extension `Oracle Developer Tools for VS Code (SQL and PLSQL)` and insert following credentials to connect (in my case it all was already inserted initially automatically):_ 
![How to connect from VSCode](../vscode-connection-2.PNG)

* _And next time before connection don't forget to run container (for example, you can do this via UI client Docker Desktop):_
![Docker Desktop UI - running container](../docker-running.png)  

___  

###### Copyright © 2023 April