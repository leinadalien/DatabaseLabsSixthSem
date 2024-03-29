CREATE TABLE STUDENTS_LOG (
    ID NUMBER,
    LOG_TIME TIMESTAMP,
    LOG_USERNAME VARCHAR2(50),
    LOG_OPERATION VARCHAR2(50),
    OLD_ID NUMBER DEFAULT NULL,
    OLD_NAME VARCHAR2(50)DEFAULT NULL,
    OLD_GROUP_ID NUMBER DEFAULT NULL,
    NEW_ID NUMBER DEFAULT NULL,
    NEW_NAME VARCHAR2(50) DEFAULT NULL,
    NEW_GROUP_ID NUMBER DEFAULT NULL
);

CREATE SEQUENCE STUDENTS_LOG_SEQ
START WITH 1
INCREMENT BY 1;


CREATE OR REPLACE TRIGGER STUDENTS_LOG_TRIGGER
AFTER INSERT OR UPDATE OR DELETE ON STUDENTS
FOR EACH ROW
BEGIN
    CASE
        WHEN INSERTING THEN BEGIN
            INSERT INTO STUDENTS_LOG (ID, LOG_TIME, LOG_USERNAME, LOG_OPERATION, NEW_ID, NEW_NAME, NEW_GROUP_ID)
            VALUES (STUDENTS_LOG_SEQ.NEXTVAL, CURRENT_TIMESTAMP, USER, 'INSERTING', :NEW.ID, :NEW.NAME, :NEW.GROUP_ID);
        END;
        WHEN UPDATING THEN BEGIN
            INSERT INTO STUDENTS_LOG (ID, LOG_TIME, LOG_USERNAME, LOG_OPERATION, OLD_ID, OLD_NAME, OLD_GROUP_ID, NEW_ID, NEW_NAME, NEW_GROUP_ID)
            VALUES (STUDENTS_LOG_SEQ.NEXTVAL, CURRENT_TIMESTAMP, USER, 'UPDATING', :OLD.ID, :OLD.NAME, :OLD.GROUP_ID, :NEW.ID, :NEW.NAME, :NEW.GROUP_ID);
        END;
        WHEN DELETING THEN BEGIN
            INSERT INTO STUDENTS_LOG (ID, LOG_TIME, LOG_USERNAME, LOG_OPERATION, OLD_ID, OLD_NAME, OLD_GROUP_ID)
            VALUES (STUDENTS_LOG_SEQ.NEXTVAL, CURRENT_TIMESTAMP, USER, 'DELETING', :OLD.ID, :OLD.NAME, :OLD.GROUP_ID);
        END;
    END CASE;
END;