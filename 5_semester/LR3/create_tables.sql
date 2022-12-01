CREATE TABLE IF NOT EXISTS rooms (
    room_id SMALLSERIAL PRIMARY KEY,
    number SMALLSERIAL UNIQUE NOT NULL CHECK(number > 0),
    possible_people_count SMALLSERIAL NOT NULL CHECK(possible_people_count >= 1)
);

CREATE TABLE IF NOT EXISTS abstract_users (
	user_id SERIAL PRIMARY KEY,
    email VARCHAR(256) UNIQUE NOT NULL,
    password VARCHAR(256) NOT NULL,
    name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL	
);

CREATE TABLE IF NOT EXISTS medical_jobs (
	medical_job_id SMALLSERIAL PRIMARY KEY,
	job_title VARCHAR(100) NOT NULL UNIQUE	
);

CREATE TABLE IF NOT EXISTS medical_employees (
	id SERIAL PRIMARY KEY REFERENCES abstract_users,
    job SMALLSERIAL,
    cabinet SMALLSERIAL NOT NULL CHECK(cabinet > 0),
    room SMALLSERIAL,
	FOREIGN KEY (job) REFERENCES medical_jobs (medical_job_id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (room) REFERENCES rooms(room_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS administrators (
	id SERIAL PRIMARY KEY REFERENCES abstract_users,
    room SMALLSERIAL,
    FOREIGN KEY (room) REFERENCES rooms(room_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS vacationers (
    id SERIAL PRIMARY KEY REFERENCES abstract_users,
    rests_from DATE NOT NULL,
    rests_to DATE NOT NULL,
    room SMALLSERIAL REFERENCES rooms(room_id) ON UPDATE CASCADE ON DELETE SET NULL 
    CHECK (rests_from <= rests_to)
);

CREATE TABLE IF NOT EXISTS logging (
	log_id BIGSERIAL PRIMARY KEY,
    user_id SERIAL REFERENCES abstract_users (user_id) ON UPDATE CASCADE ON DELETE SET NULL,
    description VARCHAR(200) NOT NULL,
    datetime TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS extra_events (
    event_id SMALLSERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    price MONEY CHECK(price >= 0::MONEY),
    date TIMESTAMP NOT NULL
);

-- middle table between vacationers and extra events (which was many to many)

CREATE TABLE IF NOT EXISTS visited_events (
    vacationer_id SERIAL REFERENCES vacationers(id) ON UPDATE CASCADE ON DELETE CASCADE,
    extra_event_id SMALLSERIAL REFERENCES extra_events(event_id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS entertainments (
    entertainment_id SMALLSERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    price MONEY CHECK(price >= 0::MONEY)
);

-- middle table between vacationers and entertainments (which was many to many)

CREATE TABLE IF NOT EXISTS used_entertainments (
    vacationer_id SERIAL REFERENCES vacationers(id) ON UPDATE CASCADE ON DELETE CASCADE,
    entertainment_id SMALLSERIAL REFERENCES entertainments(entertainment_id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS procedures (
    procedure_id SMALLSERIAL PRIMARY KEY,
    title VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(200),
    price MONEY CHECK(price >= 0::MONEY)
);

-- middle table between vacationers and procedures (which was many to many)

CREATE TABLE IF NOT EXISTS used_procedures (
    vacationer_id SERIAL REFERENCES vacationers(id) ON UPDATE CASCADE ON DELETE CASCADE,
    procedure_id SMALLSERIAL REFERENCES procedures(procedure_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- middle table between medical employees and procedures (which was many to many)

CREATE TABLE IF NOT EXISTS serviced_procedures (
    medical_id SERIAL REFERENCES medical_employees(id) ON UPDATE CASCADE ON DELETE CASCADE,
    procedure_id SMALLSERIAL REFERENCES procedures(procedure_id) ON UPDATE CASCADE ON DELETE CASCADE
);
