CREATE OR REPLACE FUNCTION print_in_console(id NUMBER, val NUMBER := DBMS_RANDOM.normal())
    RETURN VARCHAR2
    IS
    table_name CHAR(7) := 'mytable';
BEGIN
    RETURN UTL_LMS.FORMAT_MESSAGE('INSERT INTO %s (id, val) VALUES (%d, %d)', table_name, TO_CHAR(id), TO_CHAR(val));
END;
