from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

# 1st Way of Creating Empty RDD
rdd1 = spark.sparkContext.emptyRDD()
print(rdd1)

# 2nd Way of Creating Empty RDD
rdd2 = spark.sparkContext.parallelize([])
print(rdd2)

# Creating schema and DataFrame using above RDD
from pyspark.sql.types import StructType, StructField, StringType
schema = StructType([
    StructField('Firstname', StringType(), True),
    StructField('Middlename', StringType(), True),
    StructField('Lastname', StringType(), True),
])

df = spark.createDataFrame(rdd2, schema)
df.printSchema()

# Convert empty RDD to dataframe (Another Way)
df1 = rdd2.toDF(schema)
df1.printSchema()

# Create empty dataframe with schema
df2 = spark.createDataFrame([], schema)
df2.printSchema()

# Create an empty dataframe without schema (with NO schema)
df3 = spark.createDataFrame([], StructType([]))
df3.printSchema()

# Convert PySpark RDD which contains the actual data
dept = [('Data Engineer', 100), ('ML', 200), ('AI', 300)]
rdd = spark.sparkContext.parallelize(dept)

# Convert PySpark RDD to dataframe
df = rdd.toDF()
df.printSchema()
df.show(truncate=False)

# Assigning column names to the above data
deptColumns = ['DeptName', 'DeptID']
df_withcol = rdd.toDF(deptColumns)
df_withcol.printSchema()
df_withcol.show(truncate=False)

