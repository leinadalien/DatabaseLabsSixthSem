CREATE OR REPLACE FUNCTION is_even_numbers_more RETURN VARCHAR2
    IS
    even_numbers NUMBER := 0;
    not_even_numbers NUMBER := 0;
    result VARCHAR2(10);
BEGIN
    SELECT COUNT(*)INTO even_numbers FROM mytable WHERE MOD(ABS(val), 2) = 0;
    
    SELECT COUNT(*)INTO not_even_numbers FROM mytable WHERE MOD(ABS(val), 2) = 1;
    
    IF even_numbers > not_even_numbers THEN
        result := 'TRUE';
    ELSIF even_numbers < not_even_numbers THEN
        result := 'FALSE';
    ELSE result := 'EQUAL';
    END IF;
    
    RETURN result;
END;