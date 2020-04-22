# Word Count Data Flow Example

## Run Local

```
    mvn compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.WordCount \
      -Dexec.args="--output=./output/"
```

## Run DataFlow

Read from storage account and write to storage account
```
    mvn -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.WordCount \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp2-native/staging/ \
      --output=gs://dp2-native/output \
      --runner=DataflowRunner"
```

Read from Big query dataset, write to big query dataset
```
      mvn -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp2-native/staging/ \
      --gcpTempLocation=gs://dp2-native/temp/ \
      --tempLocation=gs://dp2-native/temp/ \
      --output=data-mesh-demo:test_output_ds.test \
      --runner=DataflowRunner"  

mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-1-df-temp/staging/ \
    --gcpTempLocation=gs://dp-1-df-temp/temp/ \
    --tempLocation=gs://dp-1-df-temp/temp_1/ \
    --output=data-mesh-demo:dp1ds.test \
    --runner=DataflowRunner"

```

Run with dp1 temp account
```
      mvn -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.cookbook.BigQueryTornadoes \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp-1-df-temp/staging/ \
      --gcpTempLocation=gs://dp-1-df-temp/temp/ \
      --output=data-mesh-demo:dp1ds.test \
      --runner=DataflowRunner"
```


mvn -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.WordCount \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp-1-df-temp/staging/ \
      --gcpTempLocation=gs://dp-1-df-temp/temp/ \
      --output=gs://dp2-native/output \
      --runner=DataflowRunner"



    mvn -e -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.cookbook.BigQueryTornadoes \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp-1-df-temp/staging_1/ \
      --gcpTempLocation=gs://dp-1-df-temp/temp_1/ \
      --tempLocation=gs://dp-1-df-temp/temp_1/ \
      --output=data-mesh-demo:dp2ds.test \
      --runner=DataflowRunner"