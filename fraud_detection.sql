-- Fraud Detection Query Logic
WITH FraudLogic AS (
    SELECT 
        t.tx_id,
        t.user_id,
        t.amount,
        t.tx_time,
        t.city,
        (
            SELECT COUNT(*)
            FROM transactions t2
            WHERE t2.user_id = t.user_id
              AND t2.tx_time BETWEEN t.tx_time - INTERVAL '10 minutes' AND t.tx_time
        ) AS velocity_count,
        LAG(t.city) OVER (PARTITION BY t.user_id ORDER BY t.tx_time) AS prev_city,
        LAG(t.tx_time) OVER (PARTITION BY t.user_id ORDER BY t.tx_time) AS prev_time
    FROM transactions t
)
SELECT 
    tx_id, user_id, amount, tx_time, city,
    CASE
        WHEN velocity_count >= 3 THEN 'FRAUD: High Velocity'
        WHEN city <> prev_city AND tx_time - prev_time < INTERVAL '1 hour' THEN 'FRAUD: Impossible Travel'
        WHEN amount BETWEEN 9000 AND 9999 THEN 'FRAUD: Structuring Near 10k'
        ELSE 'Normal'
    END AS fraud_status,
    CASE
        WHEN velocity_count >= 3 THEN 40
        WHEN city <> prev_city AND tx_time - prev_time < INTERVAL '1 hour' THEN 50
        WHEN amount BETWEEN 9000 AND 9999 THEN 30
        ELSE 0
    END AS fraud_score
FROM FraudLogic
ORDER BY fraud_score DESC;
