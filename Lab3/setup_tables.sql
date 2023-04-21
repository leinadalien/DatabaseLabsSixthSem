CREATE TABLE dev_schema.employees; (
   employee_id NUMBER(10) PRIMARY KEY,
   first_name VARCHAR2(50) NOT NULL,
   last_name VARCHAR2(50) NOT NULL,
   email VARCHAR2(100) UNIQUE,
   phone_number VARCHAR2(20),
   hire_date DATE DEFAULT SYSDATE,
   job_id VARCHAR2(30),
   salary NUMBER(8,2),
   commission_pct NUMBER(2,2),
   manager_id NUMBER(10),
   department_id NUMBER(10)
);



CREATE TABLE dev_schema.departments (
   department_id NUMBER(10) PRIMARY KEY,
   department_name VARCHAR2(50) NOT NULL,
   manager_id NUMBER(10),
   location_id NUMBER(10),
   CONSTRAINT fk_manager_id FOREIGN KEY (manager_id)
      REFERENCES dev_schema.employees(employee_id)
);




ALTER TABLE dev_schema.employees
ADD (
    middle_name VARCHAR2(50),
    gender CHAR(1),
    birth_date DATE,
    marital_status VARCHAR2(10),
    nationality VARCHAR2(50)
);