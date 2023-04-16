CREATE OR REPLACE PROCEDURE compare_schemas(
    dev_scheme_name IN VARCHAR2,
    prod_scheme_name IN VARCHAR2)
    IS
    CURSOR dev_tables_cursor IS 
        SELECT table_name
        FROM all_tables
        WHERE owner = dev_scheme_name;
    CURSOR prod_tables_cursor IS
        SELECT table_name
        FROM all_tables
        WHERE owner = prod_scheme_name;
    temp_table_name VARCHAR2(30) := 'temp_table_diff';
    temp_table_exists BOOLEAN := FALSE;
BEGIN
    EXECUTE IMMEDIATE
    'CREATE TABLE ' || temp_table_name || '(
        table_name VARCHAR2(30),
        column_name VARCHAR2(30),
        data_type VARCHAR2(30))';
    temp_table_exists := TRUE;
    
    FOR dev_table IN dev_tables_cursor LOOP
        DECLARE
            prod_table_exists BOOLEAN := FALSE;
        BEGIN
        END;
    END LOOP;
END;
    