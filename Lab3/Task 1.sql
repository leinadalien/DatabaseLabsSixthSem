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
    --temp_table_name VARCHAR2(30) := 'temp_table_diff';
    temp_table_exists BOOLEAN := FALSE;
BEGIN
    CREATE TABLE temp_table_diff(
        table_name VARCHAR2(30),
        column_name VARCHAR2(30),
        data_type VARCHAR2(30));
    temp_table_exists := TRUE;
    
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
                FOR dev_column IN (
                SELECT column_name, data_type
                FROM all_tab_columns
                WHERE owner = dev_schema_name
                    AND table_name = dev_table.table_name
                ORDER BY column_id) LOOP
                    DECLARE
                        prod_column_exists INTEGER := 0;
                        prod_column_data_type VARCHAR2(30);
                    BEGIN
                        SELECT COUNT(*), data_type
                        INTO prod_column_exists, prod_column_data_type
                        FROM all_tab_columns
                        WHERE owner = prod_schema_name
                            AND table_name = dev_table.table_name
                            AND column_name = dev_column.column_name;
                        IF prod_column_exists = 0 THEN -- COLUMN DOES NOT EXIST
                            INSERT INTO temp_table_diff
                            VALUES (dev_table.table_name,
                                dev_column.column_name,
                                dev_column.data_type);
                        ELSIF prod_column_data_type != dev_column.data_type THEN
                            -- COLUMN EXISTS, BUT WITH TYPE MISMATCH 
                            INSERT INTO temp_table_diff
                            VALUES (dev_table.table_name,
                                dev_column.column_name,
                                dev_column.data_type);
                        END IF;
                    END;
                END LOOP;
            END IF;
        END;
    END LOOP;
END;
    