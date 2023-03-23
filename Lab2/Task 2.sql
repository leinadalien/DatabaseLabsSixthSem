CREATE OR REPLACE TRIGGER unique_student_id 
    FOR INSERT OR UPDATE OF ID
    ON STUDENTS
    COMPOUND TRIGGER
    id_list SYS_REFCURSOR;
    id_curr STUDENTS.ID%TYPE;
    is_unique BOOLEAN;
    
    BEFORE STATEMENT IS
    BEGIN
        OPEN id_list FOR
            SELECT ID FROM STUDENTS;
    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
    BEGIN
        is_unique := true;
        
        LOOP
            FETCH id_list INTO id_curr;
            EXIT WHEN id_list%NOTFOUND;
            IF id_curr = :NEW.ID THEN
                is_unique := false;
            END IF;
        END LOOP;
        CLOSE id_list;
        IF NOT is_unique THEN
            RAISE_APPLICATION_ERROR(-20999, 'NOT UNIQUE');
        END IF;
    END BEFORE EACH ROW;
END unique_student_id;