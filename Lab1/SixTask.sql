CREATE OR REPLACE FUNCTION calculate(salary NUMBER, percentage_rate NUMBER)
RETURN NUMBER
IS
    incorrect EXCEPTION;
BEGIN
    IF percentage_rate < 0 OR salary < 0 THEN
        RAISE incorrect;
    END IF;

    RETURN (1 + percentage_rate / 100) * 12 * salary;

    EXCEPTION
        WHEN incorrect THEN
            RETURN NULL;
        WHEN INVALID_NUMBER THEN
            RETURN NULL;
        WHEN VALUE_ERROR THEN
            RETURN NULL;
END;