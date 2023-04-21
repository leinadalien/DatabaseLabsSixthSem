CREATE TABLE dev_schema.employees(
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
DROP TABLE prod_schema.EMPLOYEES;


CREATE TABLE .departments (
   department_id NUMBER(10) PRIMARY KEY,
   department_name VARCHAR2(50) NOT NULL,
   manager_id NUMBER(10),
   location_id NUMBER(10)
);
DROP TABLE dev_schema.departments;

ALTER TABLE dev_schema.employees
ADD (
    middle_name VARCHAR2(50),
    gender CHAR(1),
    birth_date DATE,
    marital_status VARCHAR2(10),
    nationality VARCHAR2(50)
);

CREATE TABLE fk_table
(
    id     NUMBER,
    child  VARCHAR2(100),
    parent VARCHAR2(100)
);

CREATE TABLE ddl_table
(
    table_name VARCHAR2(100),
    ddl_script VARCHAR2(3000),
    type       VARCHAR2(100),
    priority   NUMBER(10) DEFAULT 100000
);

CREATE OR REPLACE PROCEDURE DEV_SCHEMA.FIRST_PROCEDURE(val VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(val || ' AND ONE MORE TIME ' || val);
END;

CREATE OR REPLACE PROCEDURE PROD_SCHEMA.FIRST_PROCEDURE(val VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('OUTPUT IS ' || val);
END;

CREATE TABLE DEV_SCHEMA.STAFF (
  employee_id NUMBER,
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  hire_date DATE,
  salary NUMBER
);

CREATE TABLE DEV_SCHEMA.orders (
  order_id NUMBER,
  order_date DATE,
  customer_name VARCHAR2(50),
  total_amount NUMBER
);

DROP TABLE DEV_SCHEMA.orders;
CREATE TABLE DEV_SCHEMA.products (
  product_id NUMBER,
  product_name VARCHAR2(50),
  price NUMBER,
  in_stock NUMBER
);

CREATE TABLE DEV_SCHEMA.cycle_table (
  id NUMBER,
  
  constraint pk primary key(id),
  constraint fk_id foreign key (id) references DEV_SCHEMA.cycle_table(id)
);
