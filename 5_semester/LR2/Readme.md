# Sanatorium resort  

### Normalized + Datalogic model:  
![](./datalogic_model.svg)


### Roles  

---
| Right/Role  | Medical Employee | Administrator | Vacationer |  
|---|:---:|:---:|:---:|
| Administrators table full edit (CRUD) | - | + | - |
| Rooms table full edit (CRUD) (?) | - | + (?) | - |
| Vacationers table full edit (CRUD) | - | + | - |
| Medical Procedures table full edit (CRUD)| + | + | - |
| Extra events table full edit (CRUD) | - | + | - |
| Entertainment options table full edit (CRUD) | - | + | - |
| | | |
| Edit (add/remove) preocedures for vacationer | + | + | - |
| View list of entertainments stuff | + | + | + |
| View list of future events at Sanatorium | + | + | + |
| Edit (CRUD) 2 lists above | - | + | - |
| Add event to user's list | - | - | + |
| Change room for someone| - | + | - |
| Change medical's job | - | + | - |


### Requiremnts: 
#### For Vacationer:   
* Authorization 
* View my info
* View lists of available events, entertainments
* View list of my procedures  
* Add events (like tickets) to my events  
* View list of doctors (names, jobs)

#### For Medical Employee:  
* Authorization  
* View vacationers
* View my info
* View lists of available events, entertainments (but they don't need it :/)
* View list of doctors (names, jobs) as well  
* View vacationers' procedures and edit them  


#### For Administrator:  
* Authorization  
* CRUD vacatiners
* CRUD lists of available events, entertainments
* CRUD doctors 
* View vacationers' procedures and not edit them  


###### © 2022, October - November
