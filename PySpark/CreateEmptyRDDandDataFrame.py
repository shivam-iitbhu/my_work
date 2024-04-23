from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

# 1st Way of Creating Empty RDD
rdd1 = spark.sparkContext.emptyRDD()
print(rdd1)

# 2nd Way of Creating Empty RDD
rdd2 = spark.sparkContext.parallelize([])
print(rdd2)

