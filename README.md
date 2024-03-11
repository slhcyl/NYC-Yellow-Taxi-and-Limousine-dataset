# NYC Taxi & Limousine Commission - yellow taxi trip records

## Azure dataset source:
https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=pyspark

## Volume and retention
This dataset is stored in Parquet format. There are about 1.5B rows (50 GB) in total as of 2018.
This dataset contains historical records accumulated from 2009 to 2018. You can use parameter settings in our SDK to fetch data within a specific time range.

## Goal:
Output mean and median of cost, price and passenger counts by payment type, year and month

## Implementation Methods:
Due to the substantial dataset size (50 GB), Spark DataFrame is recommended for its ability to process and analyze large-scale data in parallel across a cluster of machines. However, my Windows laptop has performance and resource constraints that won't fully utilize Spark scalability. Therefore, I implemented two methods (Pandas and Spark) to generate the desired output.

### 1. Use Python and Pandas Dataframe:
* Source Code used to read the dataset but modified in my code file, please see the [code link](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=pyspark):
  ```
  # This is a package in preview.
  from azureml.opendatasets import NycTlcYellow
  
  from datetime import datetime
  from dateutil import parser
  
  
  end_date = parser.parse('2018-06-06')
  start_date = parser.parse('2018-05-01')
  nyc_tlc = NycTlcYellow(start_date=start_date, end_date=end_date)
  nyc_tlc_df = nyc_tlc.to_pandas_dataframe()
  
  nyc_tlc_df.info()
  ```
* Ensure the `azureml.opendatasets` package is installed before running the code.
  ```
  pip install azureml.opendatasets
  ```
* My Code: [NYC T&L Yellow Pandas.ipynb](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/NYC%20T%26L%20Yellow%20Pandas.ipynb)
  * Output csv file:
    [NYC T&L Yellow mean and median output 2009 to 2018.csv](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/NYC%20T%26L%20Yellow%20mean%20and%20median%20output%202009%20to%202018.csv)

### 2. Use Python, Pyspark and Spark Dataframe:
* Source Code used to read the dataset but modified in my code file, please see the [code link](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=pyspark)::
  ```
  # Azure storage access info
  blob_account_name = "azureopendatastorage"
  blob_container_name = "nyctlc"
  blob_relative_path = "yellow"
  blob_sas_token = "r"
  
  # Allow SPARK to read from Blob remotely
  wasbs_path = 'wasbs://%s@%s.blob.core.windows.net/%s' % (blob_container_name, blob_account_name, blob_relative_path)
  spark.conf.set(
    'fs.azure.sas.%s.%s.blob.core.windows.net' % (blob_container_name, blob_account_name),
    blob_sas_token)
  print('Remote blob path: ' + wasbs_path)
  
  # SPARK read parquet, note that it won't load any data yet by now
  df = spark.read.parquet(wasbs_path)
  ```
* To facilitate running PySpark on Windows, Docker is recommended, follow this [article](https://towardsdatascience.com/apache-spark-on-windows-a-docker-approach-4dd05d8a7147) for Docker Desktop installation.
* Check Docker Installation by running the following code in PowerShell:
  ```
  docker run hello-world
  ```
* Create a docker file called 'Dockerfile' in the Visual Studio, please don't change the file, paste the following code to this file and save it:
  ```
  FROM jupyter/pyspark-notebook
  # Add the Azure Hadoop and Azure Storage JARs
  ENV SPARK_JARS_DIR /usr/local/spark/jars
  ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.6/hadoop-azure-3.3.6.jar $SPARK_JARS_DIR
  ADD https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.6/azure-storage-8.6.6.jar $SPARK_JARS_DIR
  ```
* Docker Build:
  * Open your integrated terminal, run the following code, please don't remove '.' which is important:
  ```
  docker build -t my-custom-pyspark-notebook .
  ```
* Docker Run:
  ```
  docker run -p 8888:8888 my-custom-pyspark-notebook
  ```
* Navigate to the URL and paste it in the Chrome, create a python notebook, you can copy my pyspark code in this notebook.
* My Code 1: [NYC T&L Yellow Spark.ipynb](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/NYC%20T%26L%20Yellow%20Spark.ipynb)
  * Due to the size of dataset (1.5B records) and the limited resources available in my local environment (windows laptop), processing a large dataset on a Windows laptop using Docker led to performance and resource constraints where it didn't allow Spark to utilize its distributed computing, parallel processing and scability. Therefore, I was unable to output entire aggregated data from 2009 to 2018. However, to prove my code is functional, I sampled the dataset of 5 records to be able to generate a parquet output using my code, please see [Code 2](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/NYC%20T%26L%20Yellow%20Spark%20Sample.ipynb):
* My Code 2: [NYC T&L Yellow Spark Sample.ipynb](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/NYC%20T%26L%20Yellow%20Spark%20Sample.ipynb)
  * Output parquet files:
    [part-00000-13657153-c709-4034-a595-0bb7391af309-c000.snappy.parquet](https://github.com/slhcyl/NYC-Yellow-Taxi-and-Limousine-dataset/blob/main/part-00000-13657153-c709-4034-a595-0bb7391af309-c000.snappy.parquet)
