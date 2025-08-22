WITH TransactionSummary AS (
    -- Langkah 1: Mengagregasi data transaksi untuk setiap klien
    SELECT
        client_id,
        SUM(CAST(amount AS DECIMAL(18, 2))) AS total_spending,
        AVG(CAST(amount AS DECIMAL(18, 2))) AS avg_transaction_amount,
        -- Menghitung rasio pengeluaran "gaya hidup"
        SUM(CAST(CASE
            WHEN (mcc >= 5811 AND mcc <= 5814) OR (mcc >= 7800 AND mcc <= 7999) OR mcc = 4722
            THEN amount ELSE 0
            END AS DECIMAL(18, 2))) / 
        SUM(CAST(CASE WHEN amount > 0 THEN amount ELSE 1 END AS DECIMAL(18, 2))) AS lifestyle_spending_ratio
    FROM
        transactions_data
    GROUP BY
        client_id
),
ClientFinancialProfile AS (
    -- Langkah 2: Menggabungkan data pengguna dengan ringkasan transaksi dan menghitung metrik keuangan
    SELECT
        u.client_id,
        u.current_age,
        u.retirement_age,
        u.yearly_income,
        u.total_debt,
        u.credit_score,
        (u.yearly_income - u.total_debt) AS disposable_income_proxy,
        (CAST(u.retirement_age AS INT) - CAST(u.current_age AS INT)) AS retirement_readiness,
        COALESCE(ts.total_spending, 0) AS total_spending,
        COALESCE(ts.lifestyle_spending_ratio, 0) AS lifestyle_spending_ratio
    FROM
        users_data u
    LEFT JOIN
        TransactionSummary ts ON u.client_id = ts.client_id
)
-- Langkah 3: Menerapkan logika segmentasi pada profil klien yang komprehensif
SELECT
    client_id,
    current_age,
    yearly_income,
    total_debt,
    credit_score,
    disposable_income_proxy,
    retirement_readiness,
    total_spending,
    lifestyle_spending_ratio,
    CASE
        -- Tier 1: Klien bernilai tinggi dengan kesehatan finansial dan kapasitas investasi yang kuat
        WHEN disposable_income_proxy > 40000 AND credit_score > 720 AND (retirement_readiness < 15 OR lifestyle_spending_ratio > 0.25)
        THEN 'Investor Utama (Tier 1)'
        
        -- Tier 2: Klien dengan potensi baik yang kemungkinan besar akan menerima produk berorientasi pertumbuhan
        WHEN disposable_income_proxy > 15000 AND credit_score > 670
        THEN 'Potensi Bertumbuh (Tier 2)'
        
        -- Tier 3: Klien yang mungkin lebih mendapat manfaat dari literasi keuangan dan produk dasar
        ELSE 'Fokus Edukasi (Tier 3)'
    END AS client_segment
FROM
    ClientFinancialProfile;