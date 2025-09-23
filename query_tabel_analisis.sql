#Membuat tabel analisis dengan kolom-kolom yang mandatory
CREATE OR REPLACE TABLE kimia_farma.tabel_analisis AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,

  -- Menambah kolom nama cabang + kota
  CASE
    WHEN c.branch_name = 'Kimia Farma - Apotek' THEN CONCAT('A - ', c.kota)
    WHEN c.branch_name = 'Kimia Farma - Klinik & Apotek' THEN CONCAT('KA - ', c.kota)
    WHEN c.branch_name = 'Kimia Farma - Klinik-Apotek-Laboratorium' THEN CONCAT('KAL - ', c.kota)
  END AS branch_kota,

  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,

  -- Menghitung persentase laba dari harga obat
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  
  -- Menghitung harga setelah diskon
  t.price * (1 - t.discount_percentage) AS nett_sales,

  -- Menghitung profit = nett_sales * persentase_gross_laba
  t.price * (1 - t.discount_percentage) * 
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  t.rating AS rating_transaksi

FROM `kimia_farma.kf_final_transaction` t
LEFT JOIN `kimia_farma.kf_product` p 
  ON t.product_id = p.product_id
LEFT JOIN `kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id;




