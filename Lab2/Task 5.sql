CREATE OR REPLACE PROCEDURE ROLL_BACK(TIME TIMESTAMP, OFFSET_SECONDS NUMBER := 0)
IS
CURSOR LOGS IS SELECT * FROM STUDENTS_LOG
WHERE LOG_TIME > TIME - OFFSET_SECONDS / 86400
ORDER BY LOG_TIME DESC;
BEGIN
    FOR CURRENT_LOG IN LOGS LOOP
        CASE CURRENT_LOG.LOG_OPERATION
            WHEN 'INSERTING' THEN BEGIN
                DELETE FROM STUDENTS
                WHERE ID = CURRENT_LOG.NEW_ID;
            END;
            WHEN 'UPDATING' THEN BEGIN
                UPDATE STUDENTS SET
                ID = CURRENT_LOG.OLD_ID,
                NAME = CURRENT_LOG.OLD_NAME,
                GROUP_ID = CURRENT_LOG.OLD_GROUP_ID
                WHERE ID = CURRENT_LOG.NEW_ID;
            END;
            WHEN 'DELETING' THEN BEGIN
                INSERT INTO STUDENTS
                (ID, NAME, GROUP_ID) VALUES
                (CURRENT_LOG.OLD_ID, CURRENT_LOG.OLD_NAME, CURRENT_LOG.OLD_GROUP_ID);
            END;
        END CASE;
    END LOOP;
END;
