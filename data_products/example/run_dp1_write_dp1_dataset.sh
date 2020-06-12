mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-a-df-temp/staging/ \
    --gcpTempLocation=gs://dp-a-df-temp/temp_loc/ \
    --tempLocation=gs://dp-a-df-temp/temp/ \
    --output=data-mesh-demo:dp1ds.test \
    --runner=DataflowRunner"