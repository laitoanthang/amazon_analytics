-- Kiểm tra không có transaction_id trùng lặp
SELECT transaction_id, COUNT(*)
FROM {{ ref('full_load_transactions') }}
GROUP BY transaction_id
HAVING COUNT(*) > 1