CREATE USER dev_schema IDENTIFIED BY dev_schema;
CREATE USER prod_schema IDENTIFIED BY prod_schema;

CREATE TABLE prod_schema.employees (
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

SET serveroutput ON
BEGIN
    compare_schemas('DEV_SCHEMA', 'PROD_SCHEMA');
END;

SELECT column_name, data_type
                    FROM all_tab_columns
                    WHERE owner = 'DEV_SCHEMA'
                        AND table_name = 'EMPLOYEES'
                    ORDER BY column_id;
