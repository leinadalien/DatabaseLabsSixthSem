SELECT * FROM students_log;
SELECT * FROM students;
SELECT * FROM groups;
UPDATE students SET NAME = 'Alex' WHERE NAME = 'Owen';
INSERT INTO STUDENTS (NAME, group_id) VALUES ('Owen', 2);
BEGIN
    ROLL_BACK(TO_TIMESTAMP('03.04.23 06:55:00'));
END;

UPDATE students SET group_ID = 1 WHERE NAME = 'Owen';
DELETE FROM STUDENTS WHERE ID > 30;
