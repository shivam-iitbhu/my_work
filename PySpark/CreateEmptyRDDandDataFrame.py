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

