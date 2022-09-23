# Sanatorium resorts  
_Sanatoriums chain across several countries.   
A few relatively quiet and cozy places that will be happy to relax people of all ages and types.  
We offer health and therapeutic stays in our sanatoriums lasting from 3 days and more_

&nbsp;  
## Data description  
  
* #### Sanatorium Resorts  
    Our network has several resorts. Every one has its one almost unique atmosphere with nature features. Each sanatorium has its _address_, _phone number_ as well as _employees_ and of course our dear _vacationers_. And also _rooms_, _medical procedures_, _entertainment options_ and _equipment stuff_,  I guess :). And _events_

* #### Rooms  
    Every room has its link to _sanatorium_, its _description_,  _number_, _type_ (number of people to live there) and _current status_ (free or occupied by one/several _vacationers_)

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

### Sanatorium Resorts

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| sanatorium_id |serial, NOT NULL |__Primary Key__|
| adress   |VARCHAR(100), NOT NULL|
| phone_number     |VARCHAR(20), NOT NULL | 
| medical_employees   | | __Foreign Key references MedicalEmployee (employee_id)__
| vacationers   | | __Foreign Key references Vacationer (vacationer_id)__
| rooms   | | __Foreign Key references Room(room_id)__|
| medical_procedures   | | __Foreign Key references MedicalProcedure (room_id)__|
| entertainment_options   | | __Foreign Key references EntertainmentOption (entertainment_id)__|
| equipment_stuff   | | __Foreign Key references EquipmentStuff (equipment_id)__|
| events   | | __Foreign Key references Event(event_id)__|



### Rooms

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| room_id |serial, NOT NULL |__Primary Key__|
| description   |VARCHAR(400), NOT NULL|
| number     |INTEGER, NOT NULL | 
| occupied_by   | | __Foreign Key references Vacationer (vacationer_id)__
| people_count   | INTEGER, NOT NULL| |

### Medical Employees

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| medical_employee_id |serial, NOT NULL |__Primary Key__|
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
| name   |VARCHAR(20), NOT NULL|
| surname   |VARCHAR(20), NOT NULL|
| job   |VARCHAR(40), NOT NULL|
|timetable | VARCHAR(60), NOT NULL | |
|room | | __Foreign Key reference Room(room_id)__ if needed to live there|


### Vacationers

|   Column         |   Description   |   Additional info      
| ---------------- | ------------- | ------------- |
| vacationer_id |serial, NOT NULL |__Primary Key__|
| name   |VARCHAR(20), NOT NULL|
| surname   |VARCHAR(20), NOT NULL|
| rests_from   |DATE, NOT NULL|
| rests_to   |DATE, NOT NULL|
| procedures | | __Foreign Key references__|
| room |  | __Foreign Key reference Room(room_id)__ |


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



![](./scheme.drawio.svg)  



## Roles
---
| Right/Role | LogIned vacationer | Medical Employee | Administrator | Accountant |
|---|:---:|:---:|:---:|:---:|
| Accounts control | + | - | + | - |
| Entertainment booking | + | - | - | - |
| Equipment order | + | - | + | - |
| Room change | - | - | + | + |
| Procedures order | + | + | + | - |
| Personal account edit | + | + | + | + |
| Events tickets order | + | - | + | - |  



###### © 2022
