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

# Creating an Empty RDD
rdd1 = spark.sparkContext.emptyRDD()
print(rdd1)

# Converting RDD to a DataFrame based on the above defined schema
df = spark.createDataFrame(rdd1, schema)
df.printSchema()
