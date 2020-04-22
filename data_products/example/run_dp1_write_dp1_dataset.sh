export GOOGLE_APPLICATION_CREDENTIALS="/Users/srahman/Downloads/data-mesh-demo-71648318ba19.json"
echo $GOOGLE_APPLICATION_CREDENTIALS
mvn -Pdataflow-runner compile exec:java \
    -Dexec.mainClass=data.mesh.cookbook.DataProductProcessor \
    -Dexec.args="--project=data-mesh-demo \
    --stagingLocation=gs://dp-a-df-temp/staging/ \
    --gcpTempLocation=gs://dp-a-df-temp/temp_loc/ \
    --tempLocation=gs://dp-a-df-temp/temp/ \
    --output=data-mesh-demo:dp1ds.test \
    --runner=DataflowRunner"