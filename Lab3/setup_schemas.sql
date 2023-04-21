CREATE USER dev_schema IDENTIFIED BY dev_schema;
CREATE USER prod_schema IDENTIFIED BY prod_schema;
GRANT ALL PRIVILEGES TO dev_schema;
GRANT ALL PRIVILEGES TO prod_schema;