{{
    config(
        database='AMAZON_SILVERLH',
        materialized='table',
        schema='dbo',
        alias='deduped_transactions',
        tags=['silver']
    )
}}

WITH source_data AS (
    SELECT 
        transaction_id,
        customer_id,
        product,
        amount,
        order_timestamp,
        recorded_at
    FROM {{ source('filecsv', 'AMAZON_CUSTOMER_TRANSACTIONS') }}
),

deduped AS (
    SELECT 
        transaction_id,
        customer_id,
        product,
        amount,
        order_timestamp,
        recorded_at
    FROM source_data
    QUALIFY ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY recorded_at DESC) = 1
)

SELECT DISTINCT
    transaction_id,
    customer_id,
    product,
    amount,
    order_timestamp,
    recorded_at,
    DATEADD(HOUR, 7, order_timestamp) AS order_timestamp_vn,
    DATEADD(HOUR, 7, recorded_at) AS recorded_at_vn,
    TO_NUMBER(TO_CHAR(DATEADD(HOUR, 7, order_timestamp), 'YYYYMMDD')) AS "OrderDate",
    TO_NUMBER(TO_CHAR(DATEADD(HOUR, 7, order_timestamp), 'HH24MISS')) AS "OrderTime",
    TO_NUMBER(TO_CHAR(DATEADD(HOUR, 7, recorded_at), 'YYYYMMDD')) AS "RecordedDate",
    TO_NUMBER(TO_CHAR(DATEADD(HOUR, 7, recorded_at), 'HH24MISS')) AS "RecordedTime"
FROM deduped