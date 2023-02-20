DECLARE
    n NUMBER := 10000;
BEGIN
    FOR i IN 1..n
        LOOP
            INSERT INTO mytable VALUES (i, DBMS_RANDOM.normal());
        END LOOP;
END;