export GOOGLE_APPLICATION_CREDENTIALS="keys/dp1-sa.json"

mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-1-df-temp/staging_1/ \
    --gcpTempLocation=gs://dp-1-df-temp/temp_1/ \
    --tempLocation=gs://dp-1-df-temp/temp_1/ \
    --output=data-mesh-demo:dp2ds.test \
    --runner=DataflowRunner"