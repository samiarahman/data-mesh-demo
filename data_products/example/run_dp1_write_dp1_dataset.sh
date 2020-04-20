export GOOGLE_APPLICATION_CREDENTIALS="keys/dp1-sa.json"

mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-1-df-temp/staging/ \
    --gcpTempLocation=gs://dp-1-df-temp/temp/ \
    --tempLocation=gs://dp-1-df-temp/temp_1/ \
    --output=data-mesh-demo:dp1ds.test \
    --runner=DataflowRunner"