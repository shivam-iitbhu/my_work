from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

from pyspark.sql.types import StructType, StructField, StringType, IntegerType

dataStruct = [(('James', '', 'Smith'), '36636', 'M', '3000'),\
        (('Michael', 'Rose', ''), '40288', 'M', '4000'),\
        (('Robert', '', 'Williams'), '42114', 'M', '4000'),\
        (('Maria', 'Anne', 'Jones'), '39192', 'F', '4000'),\
        (('Jen', 'Mary', 'Brown'), '', 'F', '-1')]

schemaStruct = StructType([
    StructField('name', StructType([
        StructField('first_name', StringType(), True),
        StructField('middle_name', StringType(), True),
        StructField('last_name', StringType(), True)
    ])),
    StructField('dob', StringType(), True),
    StructField('gender', StringType(), True),
    StructField('salary', StringType(), True)
])

df = spark.createDataFrame(data=dataStruct, schema=schemaStruct)
df.printSchema()
df.show(truncate=False)       #truncate=False shows full content of the dataframe
