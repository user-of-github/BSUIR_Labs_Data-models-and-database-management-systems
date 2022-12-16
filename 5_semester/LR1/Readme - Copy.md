# Sanatorium resort  
_Sanatorium.   
A relatively quiet and cozy place that will be happy to relax people of all ages and types.  
We offer health and therapeutic stays in our sanatorium lasting from 3 days and more_



## Tables exact description  


### Rooms

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| room_id |serial, NOT NULL |__Primary Key__|
| description   |VARCHAR(400), NOT NULL|
| number     |INTEGER, NOT NULL | 
| free   | BOOLEAN, NOT NULL | 
| possible_people_count   | INTEGER, NOT NULL| |

### Medical Employees

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
|id |serial, NOT NULL | __Primary Key__, __Foreign Key reference Users(user_id)__ |
| job   |VARCHAR(40), NOT NULL|
|location | VARCHAR(40), NOT NULL | |
|procedures| |__Foreign Key references Procedures(procedure_id)__|
|room | | __Foreign Key reference Room(room_id)__ if needed to live there|


### Administrators

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| id | serial, NOT NULL | __Primary Key__, __Foreign Key reference Users(user_id)__ |
| job   |VARCHAR(40), NOT NULL|
|timetable | VARCHAR(60), NOT NULL | |
|room | | __Foreign Key reference Room(room_id)__ if needed to live there|


### Vacationers

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
|id| serial, NOT NULL| __Primary Key__, __Foreign Key Reference(user_id)__|
| rests_from   |DATE, NOT NULL|
| rests_to   |DATE, NOT NULL|
| procedures | | __Foreign Key references__|
| room |  | __Foreign Key reference Room(room_id)__ |
|visited_events | | __Foreign Key References(event_id)__|
|used_equipments | | __Foreign Key References(equipment_id)__|
|used_entertainments | | __Foreign Key References(entertainment_id)__|


### Medical procedures

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| procedure_id |serial, NOT NULL |__Primary Key__|
| title   |VARCHAR(20), NOT NULL|
| description   |VARCHAR(200), NOT NULL|
| price   |INTEGER, NOT NULL|


### Equipments

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| equipment_id |serial, NOT NULL |__Primary Key__|
| title   |VARCHAR(20), NOT NULL|
| description   |VARCHAR(200), NOT NULL|
| price   |INTEGER, NOT NULL|
| currently_free | BOOLEAN, NOT NULL |


### Entertainment options

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| entertainment_id |serial, NOT NULL |__Primary Key__|
| title   |VARCHAR(20), NOT NULL|
| description   |VARCHAR(200), NOT NULL|
| price   |INTEGER, NOT NULL|


### Extra events

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| event_id |serial, NOT NULL |__Primary Key__|
| title   |VARCHAR(20), NOT NULL|
| description   |VARCHAR(200), NOT NULL|
| price   |INTEGER, NOT NULL|
| date   | DATE, NOT NULL|

### Users
|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| user_id |serial, NOT NULL |__Primary Key__|
|email | VARCHAR(40), NOT NULL, UNIQUE|
|password | VARCHAR(100), NOT NULL|
|name | VARCHAR(30), NOT NULL|
|surname | VARCHAR(30), NOT NULL|

### Logging

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| log_id |serial, NOT NULL |__Primary Key__|
| user_id   || __Foreign Key reference Room(user_id)__
| description   |VARCHAR(200), NOT NULL|
| datetime | TIMESTAMP


![](./scheme.drawio.svg)  



## Roles
---
| Right/Role  | Medical Employee | Administrator | Vacationer |  
|---|:---:|:---:|:---:|
| Administrators (rooms, surnames, names) edit | - | + | + |
| Rooms table (add room) | - | + | - |
| Vacationers table edit (name, surname, room) | - | + | - |
| Medical Procedures add | + | + | - |
| Add procedures to list | + | + | - |
| View list of available entertainment options | + | + | + 
| Change room for someone| - | + | - |



## Signing in  
Via email and password  


###### © 2022, September - October
