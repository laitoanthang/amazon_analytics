{{
    config(
        database='AMAZON_GOLDLH',
        materialized='table',
        schema='dbo',
        alias='FACTTransaction',
        tags=['gold']
    )
}}

SELECT 
    *
FROM {{ ref('full_load_transactions') }}