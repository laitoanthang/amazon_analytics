-- Kiểm tra order_timestamp_vn = order_timestamp + 7 giờ
SELECT *
FROM {{ ref('full_load_transactions') }}
WHERE DATEADD(HOUR, 7, order_timestamp) != order_timestamp_vn