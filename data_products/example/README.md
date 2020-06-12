# DataProductProcessor Example

## Build 

```
mvn compile
```

## Run DataFlow

Use data product 1 service account to read from a public bigquery dataset and write to big query dataset owned by this data product 1

Expect to see success in writing of data in the data product 1 dataset

```
GOOGLE_APPLICATION_CREDENTIALS="path to you dp 1 service account credentials" bash run_dp1_write_dp1_dataset.sh
```

To see the principle of least privelege being applied with a secure boundary per data product 

Using data product 1 service account read from a public bigquery dataset but this time time attempt to  write to big query dataset belonging to data product 2
Expect to see forbidden error

```
GOOGLE_APPLICATION_CREDENTIALS="path to you dp 1 service account credentials" bash run_dp1_write_dp2_dataset.sh
```

Expected error message 

```
com.google.api.client.googleapis.json.GoogleJsonResponseException: 403 Forbidden
{
  "code" : 403,
  "errors" : [ {
    "domain" : "global",
    "message" : "Access Denied: Dataset data-mesh-demo:dp2ds: User does not have bigquery.datasets.get permission for dataset data-mesh-demo:dp2ds.",
    "reason" : "accessDenied"
  } ],
  "message" : "Access Denied: Dataset data-mesh-demo:dp2ds: User does not have bigquery.datasets.get permission for dataset data-mesh-demo:dp2ds.",
  "status" : "PERMISSION_DENIED"
}
```