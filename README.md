# NYC Taxi & Limousine Commission - yellow taxi trip records

## Azure dataset source:
https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=pyspark

## Volume and retention
This dataset is stored in Parquet format. There are about 1.5B rows (50 GB) in total as of 2018.
This dataset contains historical records accumulated from 2009 to 2018. You can use parameter settings in our SDK to fetch data within a specific time range.

## Goal:
Output mean and median of cost, price and passenger counts by payment type, year and month

## Implementation Methods:
### 1. Use Python and Pandas Dataframe:
* Ensure the `azureml.opendatasets` package is installed before running the code.
  ```
  pip install azureml.opendatasets
  ```
* Code: NYC T&L Yellow Pandas.ipynb
* Output csv file:
  * NYC T&L Yellow mean and median output 2009 to 2018.csv

### 2. Use Python, Pyspark and Spark Dataframe:
* For easiest installation of pyspark and the hadoop azure dependencies on Windows, Docker is recommended.
* Setup Docker Desktop, you can follow this [article](https://towardsdatascience.com/apache-spark-on-windows-a-docker-approach-4dd05d8a7147) to install it.
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
* Open your integrated terminal, run the following code, please don't remove '.' which is important:
  ```
  docker build -t my-custom-pyspark-notebook .
  ```
  ```
  docker run -p 8888:8888 my-custom-pyspark-notebook
  ```
* Navigate to the URL and paste it in the Chrome, create a python notebook, you can copy my pyspark code in this notebook.
* Code 1: NYC T&L Yellow Spark.ipynb
  * Due to the limitation of Docker, it was unable to compute the whole 1.5B records to generate the parquet file. I created a separate code to run a sample of 5 records, please see Code 2:
* Code 2: NYC T&L Yellow Spark Sample.ipynb
  * Output parquet files:
    * part-00000-13657153-c709-4034-a595-0bb7391af309-c000.snappy.parquet
