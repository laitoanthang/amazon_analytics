{{
    config(
        database='AMAZON_GOLDLH',
        materialized='table',
        schema='dbo',
        alias='DIMProduct',
        tags=['gold']
    )
}}

SELECT DISTINCT
    UPPER(TRIM(product)) AS product,
    ROW_NUMBER() OVER (ORDER BY UPPER(TRIM(product))) AS product_id
FROM {{ ref('full_load_transactions') }}
