from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

# All the datatypes to be used below must be imported in the below command
from pyspark.sql.types import StructType, StructField, StringType

# Here is our first schema. The last parameter "True" means that the respective columns can contain NULL values. If it were "False", it can't contain a null value.
schema = StructType([
    StructField('Firstname', StringType(), True),
    StructField('Middlename', StringType(), True),
    StructField('Lastname', StringType(), True),
])

df = spark.createDataFrame(rdd2, schema)
df.printSchema()
