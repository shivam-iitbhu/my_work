from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

data = [('James', '', 'Smith', '36636', 'M', 60000),
        ('Michael', 'Rose', '', '40288', 'M', 70000),
        ('Robert', '', 'Williams', '42114', 'M', 400000),
        ('Maria', 'Anne', 'Jones', '39192', 'M', 500000),
        ('Jen', 'Mary', 'Brown', '', 'M', 0)]
columns = ['first_name', 'middle_name', 'last_name', 'dob', 'gender', 'salary']
psDF = spark.createDataFrame(data=data, schema=columns)
psDF.printSchema()
psDF.show(truncate=False)
