def execution_function(source):
    import pyspark.sql.functions as func
    import yaml
    import sys, os
    
    your_output_table_name = "put your table name here"
    
    # Set Path one-step back
    path = os.path.join(os.getcwd(), ".")
    # Get the absolute path
    abs_path = os.path.abspath(path)
    
    yaml_path = f"{abs_path}/config_yaml/{source}.yaml"
    
    with open(yaml_path, 'r') as file:
        config = yaml.safe_load(file)
    print(config)
    
    # Setting first table name defined in YAML
    for i, j in config['first_table'].items():
        global()[i] = j
    first_tbl = f"{catalog}.{schema}.{table}"
    print(first_tbl)
    
    # Setting second table name defined in YAML
    for i, j in config['second_table'].items():
        global()[i] = j
    second_tbl = f"{catalog}.{schema}.{table}"
    print(second_tbl)
    
    first_df = spark.table(first_tbl)
    fst_df = first_df
    sec_df = spark.table(second_tbl)
    
    fst_df_cols = fst_df.columns
    sec_df_cols = sec_df.columns
    
    if fst_df_cols != sec_df_cols:
        sys.exit("Columns do not match. Please check both tables' columns ")
    
    for col in fst_df.columns:
        fst_df = fst_df.withColumnRenamed(col, col+'_fst')
    fst_df.show(2)
    
    for col in sec_df.columns:
        sec_df = sec_df.withColumnRenamed(col, col+'_sec')
    sec_df.show(2)
    
    jc = ''
    for pk in config['primary_key']:
        x = f"(fst_df['{pk}_fst'] == sec_df['{pk}_sec'])"
        if jc:
            jc = jc + " & " + x
        else:
            jc = x
    
    print(jc)
    
    # Join DataFrames based on the concatenated primary key
    result_df = fst_df.join(sec_df, eval(jc), 'inner')
    
    result_df.show(2)
    
    
    for column in first_df.columns:
        result_df = result_df.withColumn(f'{column}_comp', func.lit(func.col(f'{column}_fst') == func.col(f'{column}_sec')))
        
    print(result_df.columns)
    result_df.show(2)
    
    out_cols = []
    for column in first_df.columns:        
        tf = [f'{column}_fst'] + [f'{column}_sec'] + [f'{column}_comp']
        out_cols = out_cols + tf
        
    print(out_cols)
    
    final_df = result_df.select(out_cols)
    final_df = final_df.withColumn('last_mod_ts', func.current_timestamp())
    
    final_df.write.mode('overwrite').saveAsTable(your_output_table_name)
    
    print(f"Test results are saved in {your_output_table_name}.")