CREATE OR REPLACE VIEW jackpot_party.gold.segment_monetization AS
WITH purch AS (
  SELECT
    user_id,
    SUM(CASE WHEN status = 'success' THEN price_usd ELSE 0 END) AS purchase_revenue_usd
  FROM jackpot_party.silver.fact_purchases
  GROUP BY user_id
),
ads_u AS (
  SELECT
    user_id,
    SUM(revenue_usd) AS ad_revenue_usd
  FROM jackpot_party.silver.fact_ads
  GROUP BY user_id
)
SELECT
  u.country,
  u.platform,
  COUNT(DISTINCT u.user_id) AS users,

  SUM(COALESCE(p.purchase_revenue_usd,0)) AS purchase_revenue_usd,
  SUM(COALESCE(a.ad_revenue_usd,0))       AS ad_revenue_usd,
  SUM(COALESCE(p.purchase_revenue_usd,0) + COALESCE(a.ad_revenue_usd,0)) AS total_revenue_usd,

  SUM(COALESCE(p.purchase_revenue_usd,0) + COALESCE(a.ad_revenue_usd,0)) / COUNT(DISTINCT u.user_id) AS arpu_usd,
  SUM(CASE WHEN COALESCE(p.purchase_revenue_usd,0) > 0 THEN 1 ELSE 0 END) / COUNT(DISTINCT u.user_id) AS payer_rate
FROM jackpot_party.silver.dim_users u
LEFT JOIN purch p ON u.user_id = p.user_id
LEFT JOIN ads_u a ON u.user_id = a.user_id
GROUP BY u.country, u.platform;

--offers
CREATE OR REPLACE VIEW jackpot_party.gold.offer_performance AS
SELECT
  o.offer_id,
  o.offer_name,
  o.price_usd AS offer_price_usd,

  COUNT(*) AS successful_purchases,
  SUM(p.price_usd) AS revenue_usd,
  COUNT(DISTINCT p.user_id) AS unique_buyers
FROM jackpot_party.silver.fact_purchases p
JOIN jackpot_party.silver.dim_offers o
  ON p.offer_id = o.offer_id
WHERE p.status = 'success'
GROUP BY o.offer_id, o.offer_name, o.price_usd;


--machine id
CREATE OR REPLACE VIEW jackpot_party.gold.machine_performance AS
SELECT
  machine_id,
  COUNT(*) AS spins,
  COUNT(DISTINCT user_id) AS unique_players,
  SUM(bet_amount) AS bet_amount_total,
  SUM(win_amount) AS win_amount_total,
  SUM(net_amount) AS net_amount_total
FROM jackpot_party.silver.fact_spins
GROUP BY machine_id;


