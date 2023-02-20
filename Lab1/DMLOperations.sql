CREATE OR REPLACE PROCEDURE insert_function(id NUMBER, val NUMBER := DBMS_RANDOM.normal())
    IS
    table_name CHAR(7) := 'mytable';
BEGIN
    EXECUTE IMMEDIATE UTL_LMS.FORMAT_MESSAGE('INSERT INTO %s (id, val) VALUES (%d, %d)', table_name, TO_CHAR(id), TO_CHAR(val));
END;

CREATE OR REPLACE PROCEDURE update_function(id NUMBER, val NUMBER := DBMS_RANDOM.normal())
    IS
    table_name CHAR(7) := 'mytable';
BEGIN
    EXECUTE IMMEDIATE UTL_LMS.FORMAT_MESSAGE('UPDATE %s SET val=%d WHERE id=%d', table_name, TO_CHAR(val), TO_CHAR(id));
END;

CREATE OR REPLACE PROCEDURE delete_function(id NUMBER)
    IS
    table_name CHAR(7) := 'mytable';
BEGIN
    EXECUTE IMMEDIATE UTL_LMS.FORMAT_MESSAGE('DELETE FROM %s WHERE id=%d', table_name, TO_CHAR(id));
END;