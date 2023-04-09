### To launch Oracle Database inside Docker container:  
* Go to https://container-registry.oracle.com/
* Pull the last Oracle Database Express Edition image `docker pull container-registry.oracle.com/database/express:latest`
* `docker run -e ORACLE_PWD="<any password>" --name <any image> -d -p 1521:1521 container-registry.oracle.com/database/express`
    * For example, my command looked like `docker run -e ORACLE_PWD="SYSTEM" --name oracle-xe-db-docker -d -p 1521:1521 container-registry.oracle.com/database/express`
* In Microsoft Visual Studio Code download extension `Oracle Developer Tools for VS Code (SQL and PLSQL)` and insert following credentials to connect (in my case it all was already inserted initially automatically): 
![How to connect from VSCode](../vscode-connection-2.PNG)
