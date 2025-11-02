WITH BaseData AS (
  SELECT
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    ft.product_id,
    prod.product_name,
    ft.price AS actual_price,
    ft.discount_percentage,
    ft.rating AS rating_transaksi
  FROM
    `kimia_farma.kf_final_transaction` AS ft
  LEFT JOIN
    `kimia_farma.kf_kantor_cabang` AS kc
    ON ft.branch_id = kc.branch_id
  LEFT JOIN
    `kimia_farma.kf_product` AS prod
    ON ft.product_id = prod.product_id
),

Calculations AS (
  SELECT
    *,
    CASE
      WHEN actual_price <= 50000 THEN 0.10
      WHEN actual_price > 50000 AND actual_price <= 100000 THEN 0.15
      WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
      WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
      WHEN actual_price > 500000 THEN 0.30
      ELSE 0
    END AS persentase_gross_laba,
    (actual_price - (actual_price * discount_percentage)) AS nett_sales
  FROM
    BaseData
)

SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  persentase_gross_laba,
  nett_sales,
  (nett_sales * persentase_gross_laba) AS nett_profit,
  rating_transaksi
FROM
  Calculations;