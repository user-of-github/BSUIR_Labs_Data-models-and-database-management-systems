# Sanatorium resorts  
_Sanatorium.   
A relatively quiet and cozy place that will be happy to relax people of all ages and types.  
We offer health and therapeutic stays in our sanatorium lasting from 3 days and more_

&nbsp;  
## Data description  

* #### Rooms  
    Every room has its _description_,  _number_, _type_ (number of people to live there) and _current status_

* #### Medical Employees  
    Every employee has (of course) _name_ and _surname_, _job title_, his/her _location_ (cabinet), where one works. And also provided _procedures_ list. And also provided by sanatorium _room_, if needed, for life.

* #### Administrators 
    Every admin has _name_, _surname_, _job title_, _timetable_. And also provided by sanatorium _room_, if needed, for life.

* #### Vacationers
    Every vacationer has (of course) _name_, _surname_, one's _resort_ and _room_ of living as well as _dates_ range of rest. Also list of _procedures_. 

* #### Medical Procedures
    Its _price_, _title_ & _description_.

* #### Equipments for hire
    Every client is able to hire some kind of equipment.Every equipment has its _title_, _description or location_, _cost_ per hour or per day, and (if currently occupied) responsible _vacationer_ for it.

* #### Entertainment options
    Just _title_, _description_ and _cost_ (or NULL, if free).

* #### Extra events
    Event _title_, _description_, _resort_, _cost_ and _date_. For example special guest or laser tag.


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
| medical_employee_id |serial, NOT NULL |__Primary Key__|
|link_to_user | | __Foreign Key reference Room(user_id)__ |
| name   |VARCHAR(20), NOT NULL|
| surname   |VARCHAR(20), NOT NULL|
| job   |VARCHAR(40), NOT NULL|
|location | VARCHAR(40), NOT NULL | |
|procedures| |__Foreign Key references Procedures(procedure_id)__|
|room | | __Foreign Key reference Room(room_id)__ if needed to live there|


### Administrators

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| administrator_id |serial, NOT NULL |__Primary Key__|
|link_to_user | | __Foreign Key reference Room(user_id)__ |
| name   |VARCHAR(20), NOT NULL|
| surname   |VARCHAR(20), NOT NULL|
| job   |VARCHAR(40), NOT NULL|
|timetable | VARCHAR(60), NOT NULL | |
|room | | __Foreign Key reference Room(room_id)__ if needed to live there|


### Vacationers

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| vacationer_id |serial, NOT NULL |__Primary Key__|
|link_to_user| | __Foreign Key Reference(user_id)__|
| name   |VARCHAR(20), NOT NULL|
| surname   |VARCHAR(20), NOT NULL|
| rests_from   |DATE, NOT NULL|
| rests_to   |DATE, NOT NULL|
| procedures | | __Foreign Key references__|
| room |  | __Foreign Key reference Room(room_id)__ |
|visited_events | | __Foreign Key References(event_id)__|
|used_equpments | | __Foreign Key References(equipment_id)__|
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

### AllUsers
|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| user_id |serial, NOT NULL |__Primary Key__|
|email | VARCHAR(40), NOT NULL|
|hashed_password | VARCHAR(100), NOT NULL|

### Logging

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| log_id |serial, NOT NULL |__Primary Key__|
| user_id   || __Foreign Key reference Room(user_id)__
| description   |VARCHAR(200), NOT NULL|


![](./scheme.drawio.svg)  



## Roles
---
| Right/Role  | Medical Employee | Administrator | Vacationer |  
|---|:---:|:---:|:---:|
| Administrators table full edit | - | + | + |
| Rooms table full edit | - | + | - |
| Vacationers table full edit | - | + | - |
| Edit preocedures for vacationer | + | + | + |
| Medical Procedures table full edit | + | + | - |
| Extra events table full edit | - | + | - |
| Entertainment options table full edit | - | + | - |
| Equipments table full edit | - | + | - |


###### © 2022, September - October
