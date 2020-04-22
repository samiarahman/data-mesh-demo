export GOOGLE_APPLICATION_CREDENTIALS="/Users/srahman/Downloads/data-mesh-demo-71648318ba19.json"

mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-a-df-temp/staging_1/ \
    --gcpTempLocation=gs://dp-a-df-temp/temp_1/ \
    --tempLocation=gs://dp-a-df-temp/temp_1/ \
    --output=data-mesh-demo:dp2ds.test \
    --runner=DataflowRunner"