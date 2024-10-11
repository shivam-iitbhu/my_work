def selt_variables(parms: dict = {}, jobtask: str = "configs", reset: bool = False):
    import inspect
    
    if reset:
        dbutils.widgets.removeAll()
        
    locals_ = inspect.stack()[1][0].f_locals
    out = {}
    for k, v in parms.items():
        try:
            # Parameters set through workflows appear as widgets
            v = dbutils.widgets.get(k)
        except:
            pass
        try:
            # set defaults for passing to other workflow tasks
            val = str(
                dbutils.jobs.taskValues.get(
                    taskKey=jobtask, key=k, default=v, debugValue=v
                )
            )
        except:
            val = str(parms.get(k, ""))
        dbutils.widgets.text(k, val)
        try:
            dbutils.jobs.taskValues.set(key=k, value=val)
        except:
            pass
        locals_[k] = str(dbutils.widgets.get(k))
        out.update({k: locals_[k]})
    return out



# Dataframe columns rename using dictionary key-value pair
def rename_columns(df: DataFrame, rename_dict: dict) -> DataFrame:
    from pyspark.sql import DataFrame
    for old_col, new_col in rename_dict.items():
        df = df.withColumnRenamed(old_col, new_col)
    return df