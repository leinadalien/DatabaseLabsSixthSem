CREATE OR REPLACE TRIGGER STUDENTS_UNIQUE_ID
BEFORE INSERT ON STUDENTS
FOR EACH ROW
DECLARE
  ID_COUNT NUMBER;
BEGIN
  SELECT COUNT(*) INTO ID_COUNT FROM STUDENTS WHERE ID = :NEW.ID;
  IF ID_COUNT > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'ID ������ ���� ����������');
  END IF;
END;

CREATE OR REPLACE TRIGGER STUDENTS_AUTOINC_ID
BEFORE INSERT ON STUDENTS
FOR EACH ROW
DECLARE
  L_ID NUMBER;
BEGIN
  SELECT MAX(ID) + 1 INTO L_ID FROM STUDENTS;
  IF L_ID IS NULL THEN
    L_ID := 1;
  END IF;
  :NEW.ID := L_ID;
END;

CREATE OR REPLACE TRIGGER GROUPS_UNIQUE_NAME
BEFORE INSERT OR UPDATE ON GROUPS
FOR EACH ROW
DECLARE
  NAME_COUNT NUMBER;
BEGIN
  SELECT COUNT(*) INTO NAME_COUNT FROM GROUPS WHERE NAME = :NEW.NAME AND ID != :NEW.ID;
  IF NAME_COUNT > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'NAME MUST BE UNIQUE');
  END IF;
END;