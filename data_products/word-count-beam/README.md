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
      -Dexec.mainClass=org.apache.beam.examples.cookbook.BigQueryTornadoes \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp2-native/staging/ \
      --output=data-mesh-demo:test_output_ds.test \
      --runner=DataflowRunner"  
```

Run with dp1 temp account
```
      mvn -Pdataflow-runner compile exec:java \
      -Dexec.mainClass=org.apache.beam.examples.cookbook.BigQueryTornadoes \
      -Dexec.args="--project=data-mesh-demo \
      --stagingLocation=gs://dp-1-df-temp/staging/ \
      --output=data-mesh-demo:dp2ds.test \
      --runner=DataflowRunner"
```