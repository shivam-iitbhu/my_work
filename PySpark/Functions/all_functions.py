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


# Drop an existing column from a pyspark df
from pyspark.sql import DataFrame
from typing import List

def drop_existing_cols(df: DataFrame, col_list_to_drop: list[str]) -> DataFrame:
    # Verify which columns exist in the DataFrame
    existing_cols = set(df.columns)
    cols_to_remove = [
        col for col in cols_to_drop
        if col in existing_cols
    ]

    # Drop only existing columns
    if cols_to_remove:
        df = df.drop(*cols_to_remove)

    return df


# Filter pyspark df based on a column and a list value
from pyspark.sql import DataFrame
from pyspark.sql import functions as F
from typing import List, Any

def filter_df(df: DataFrame, filter_column: str, filter_values: List[Any], is_in: bool = True) -> DataFrame:
    """
    Filter a PySpark DataFrame using IN or NOT IN conditions.

    Parameters:
        df (DataFrame): Input PySpark DataFrame.
        filter_column (str): Column on which the filter is applied.
        filter_values (List[Any]): List of values to filter by.
        is_in (bool): True for IN, False for NOT IN. Defaults to True.

    Returns:
        DataFrame: Filtered PySpark DataFrame.
    """

    # Verify that the filter column exists
    if filter_column not in df.columns:
        raise ValueError(
            f"Filter column '{filter_column}' does not exist in the DataFrame."
        )

    # Apply IN or NOT IN condition
    if is_in:
        condition = F.col(filter_column).isin(filter_values)
    else:
        condition = ~F.col(filter_column).isin(filter_values)

    return df.filter(condition)
