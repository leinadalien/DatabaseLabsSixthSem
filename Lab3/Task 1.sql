CREATE TABLE temp_table_diff(
        table_name VARCHAR2(30),
        column_name VARCHAR2(30),
        data_type VARCHAR2(30));

CREATE OR REPLACE PROCEDURE compare_schemas(
    dev_schema_name IN VARCHAR2,
    prod_schema_name IN VARCHAR2)
    IS
    CURSOR dev_tables_cursor IS 
        SELECT table_name
        FROM all_tables
        WHERE owner = dev_schema_name;
    CURSOR prod_tables_cursor IS
        SELECT table_name
        FROM all_tables
        WHERE owner = prod_schema_name;
BEGIN
    FOR dev_table IN dev_tables_cursor LOOP
        DECLARE
            prod_table_exists INTEGER := 0;
        BEGIN
            SELECT COUNT(*) 
            INTO prod_table_exists
            FROM all_tables
            WHERE owner = prod_schema_name
                AND table_name = dev_table.table_name;
            
            IF prod_table_exists = 0 THEN -- TABLE DOES NOT EXIST
                INSERT INTO temp_table_diff
                SELECT dev_table.table_name,
                    column_name,
                    data_type
                FROM all_tab_columns
                WHERE owner = dev_schema_name
                    AND table_name = dev_table.table_name;
            ELSE -- TABLE EXISTS
                DECLARE
                    CURSOR dev_columns IS 
                        SELECT column_name, data_type
                        FROM all_tab_columns
                        WHERE owner = dev_schema_name
                            AND table_name = dev_table.table_name
                        ORDER BY column_id;
                BEGIN
                FOR dev_column IN dev_columns LOOP
                    DECLARE
                        prod_column_data_type VARCHAR2(30);
                    BEGIN
                        SELECT data_type
                        INTO prod_column_data_type
                        FROM all_tab_columns
                        WHERE owner = prod_schema_name
                            AND table_name = dev_table.table_name
                            AND column_name = dev_column.column_name;
                        IF prod_column_data_type != dev_column.data_type THEN
                            -- COLUMN EXISTS, BUT WITH TYPE MISMATCH 
                            INSERT INTO temp_table_diff
                            VALUES (dev_table.table_name,
                                dev_column.column_name,
                                dev_column.data_type);
                        END IF;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            INSERT INTO temp_table_diff
                            VALUES (dev_table.table_name,
                                dev_column.column_name,
                                dev_column.data_type);
                    END;
                    
                END LOOP;
                END;
            END IF;
        END;
    END LOOP;
    
    FOR dev_table IN (SELECT table_name FROM temp_table_diff) LOOP
        DECLARE
            foreign_key_exists INTEGER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO foreign_key_exists
            FROM all_constraints
            WHERE owner = dev_schema_name
                AND constraint_type = 'R'
                AND table_name = dev_table.table_name;
            IF foreign_key_exists > 0 THEN
                FOR fk IN (SELECT r_constraint_name, table_name, constraint_name
                           FROM all_constraints
                           WHERE owner = dev_schema_name
                               AND constraint_type = 'R'
                               AND table_name = dev_table.table_name) LOOP
                    DECLARE
                        reffered_table_exists INTEGER := 0;
                    BEGIN
                        SELECT COUNT(*)
                        INTO reffered_table_exists
                        FROM temp_table_diff
                        WHERE table_name = (SELECT table_name
                                            FROM all_constraints
                                            WHERE owner = dev_schema_name
                                                AND constraint_type = 'P'
                                                AND constraint_name = fk.r_constraint_name);
                        IF reffered_table_exists > 0 THEN
                            DBMS_OUTPUT.PUT_LINE('Circular reference detected for table ' || dev_table.table_name ||
                                                 '. The foreign key ' || fk.constraint_name || 
                                                 ' references the table ' || fk.table_name || ', which does not exists in the differences.');
                        END IF;
                    END;
                END LOOP;
            END IF;
        END;
    END LOOP;
    
    FOR table_diff IN (SELECT DISTINCT table_name FROM temp_table_diff) LOOP
        DECLARE
            table_has_fk INTEGER := 0;
        BEGIN
            SELECT COUNT(*) INTO table_has_fk
            FROM all_constraints
            WHERE owner = dev_schema_name
                AND constraint_type = 'R'
                AND table_name = table_diff.table_name;
            IF table_has_fk = 0 THEN
                -- IF TABLE DOES NOT CONTAIN FOREIGN KEYS
                DBMS_OUTPUT.PUT_LINE(table_diff.table_name);
            ELSE
                -- IF TABLE CONTAINS FOREIGN KEYS
                DECLARE
                    fk_tables VARCHAR2(32767) := '';
                BEGIN
                    FOR fk IN (SELECT DISTINCT table_name
                           FROM all_constraints
                           WHERE owner = dev_schema_name
                               AND constraint_type = 'R'
                               AND r_constraint_name IN (SELECT constraint_name
                                                         FROM all_constraints
                                                         WHERE owner = dev_schema_name
                                                             AND constraint_type = 'P'
                                                             AND table_name = table_diff.table_name)
                           ORDER BY table_name) LOOP
                    fk_tables := fk_tables || ' ' || fk.table_name;
                    END LOOP;
                    DBMS_OUTPUT.PUT_LINE(fk_tables || ' ' || table_diff.table_name);
                END;
            END IF;
        END;
    END LOOP;

    DELETE FROM temp_table_diff;
END;
    