{{
    config(
        database='AMAZON_GOLDLH',
        materialized='table',
        schema='dbo',
        alias='DIMCustomer',
        tags=['gold']
    )
}}

WITH customer_agg AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT transaction_id) AS total_orders,
        SUM(amount) AS total_spent,
        MIN(order_timestamp_vn) AS first_order_date,
        MAX(order_timestamp_vn) AS last_order_date
    FROM {{ ref('full_load_transactions') }}
    GROUP BY customer_id
)

SELECT 
    customer_id,
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_sk,
    total_orders,
    total_spent,
    first_order_date,
    last_order_date
FROM customer_agg
ORDER BY customer_id