# Segmentasi-Nasabah
Repository ini berisi solusi untuk Technical Test – Data Analyst (contract) , dengan fokus pada analisis perilaku pengguna berdasarkan data transaksi dan profil keuangan. File utama adalah Segmentasi.sql, yang berisi query SQL untuk membuat segmentasi klien menjadi beberapa kategori.

File Segmentasi.sql berisi skrip query SQL mengenai:
1. Agregasi transaksi per nasabah;
2. Penggabungan dengan data pengguna; dan
3. Penentuan segmen nasabah (client_segment) berdasarkan indikator finansial.

Tabel yang menjadi input untuk skrip ini adalah:
1. user_data
2. transaction_data

Query akan menghasilkan tabel hasil dengan kolom berikut:
1. client_id;
2. current_age;
3. yearly_income;
4. total_debt;
5. credit_score;
6. disposable_income_proxy;
7. retirement_readiness;
8. total_spending;
9. lifestyle_spending_ratio; dan
10. client_segment

Logika perhitungan segmentasi nasabah:
a. Investor Utama (Tier 1) → disposable income tinggi, skor kredit sangat baik, dan mendekati pensiun atau belanja gaya hidup tinggi.
b. Potensi Bertumbuh (Tier 2) → disposable income sedang, skor kredit baik.
c. Fokus Edukasi (Tier 3) → sisanya, dengan fokus pada literasi keuangan.
