-- Completed all the table checks manually before creating the silver tables
-- NULL, Dedup, %LIKE, PK Checks

-- DIM TABLES
CREATE TABLE IF NOT EXISTS jackpot_party.silver.dim_users AS
SELECT
  user_id,
  created_at,
  first_seen_ts,
  last_seen_ts,
  country,
  platform,
  language,
  age_bucket,
  is_vip,
  vip_tier,
  lifetime_spend_usd,
  lifetime_ads_revenue_usd
FROM jackpot_party.bronze.dim_users;


CREATE TABLE IF NOT EXISTS jackpot_party.silver.dim_offers AS
SELECT
  offer_id,
  offer_name,
  price_usd,
  coins_granted,
  vip_only
FROM jackpot_party.bronze.dim_offers;
