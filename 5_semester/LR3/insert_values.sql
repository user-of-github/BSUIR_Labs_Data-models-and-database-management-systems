INSERT 
INTO medical_jobs(job_title) 
VALUES ('massage therapist'), ('coach'), ('pediatrician'), ('nurse')
ON CONFLICT DO NOTHING;

INSERT 
INTO entertainments(title, description, price) 
VALUES 
('table tennis', 'a table and stuff to spend time with pleasure playing ping-pong. Price is set per hour', 5), 
('volleyball', 'a field with sand coverage to play beach volley there', 0), 
('basketball', 'a field with solid coverage to play basketball there', 0),  
('snooker', 'table for professional snooker with necessary balls and stuff. Price is set per hour', 8)
ON CONFLICT DO NOTHING;

INSERT 
INTO extra_events(title, description, price, date) 
VALUES 
('laser tag', 'price is set for one game with duration of 60 minutes', 10, '2021-08-13'),
('excursion to the forest', 'A good way to discover great forest around our sanatorium resort', 0, '2022-08-13')
ON CONFLICT DO NOTHING;
