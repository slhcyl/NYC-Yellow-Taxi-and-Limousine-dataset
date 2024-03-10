FROM jupyter/pyspark-notebook

# Add the Azure Hadoop and Azure Storage JARs
ENV SPARK_JARS_DIR /usr/local/spark/jars
ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.6/hadoop-azure-3.3.6.jar $SPARK_JARS_DIR
ADD https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.6/azure-storage-8.6.6.jar $SPARK_JARS_DIR