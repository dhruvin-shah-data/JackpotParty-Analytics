-- Inspect Table
SELECT *
FROM csv.`dbfs:/Volumes/jackpot_party/source_data/raw/jackpot_party/users.csv`
LIMIT 10;

SELECT *
FROM csv.`dbfs:/Volumes/jackpot_party/source_data/raw/jackpot_party/users.csv`
WITH (header = 'true')
LIMIT 10;

--users
CREATE TABLE jackpot_party.bronze.dim_users
USING DELTA
AS
WITH users_raw AS (
  SELECT *
  FROM csv.`dbfs:/Volumes/jackpot_party/source_data/raw/jackpot_party/users.csv`
  WITH (header = 'true')
)
SELECT
  CAST(user_id AS STRING) AS user_id,
  CAST(created_at AS DATE) AS created_at,
  TO_TIMESTAMP(first_seen_ts) AS first_seen_ts,
  TO_TIMESTAMP(last_seen_ts) AS last_seen_ts,
  NULLIF(country,'null')  AS country,
  NULLIF(platform,'null')  AS platform,
  NULLIF(language,'null')  AS language,
  NULLIF(age_bucket,'null')  AS age_bucket,
  CAST(NULLIF(is_vip,'null') AS BOOLEAN) AS is_vip,
  NULLIF(vip_tier,'null') AS vip_tier,
  CAST(NULLIF(lifetime_spend_usd,'null') AS DECIMAL(12,2)) AS lifetime_spend_usd,
  CAST(NULLIF(lifetime_ads_revenue_usd,'null') AS DECIMAL(12,2)) AS lifetime_ads_revenue_usd,
  current_timestamp() AS bronze_ingest_ts
FROM users_raw;


-- offers 
CREATE TABLE jackpot_party.bronze.dim_offers
USING DELTA
AS
WITH offers_raw AS (
  SELECT *
  FROM csv.`dbfs:/Volumes/jackpot_party/source_data/raw/jackpot_party/offers.csv`
  WITH (header = 'true')
)
SELECT
  CAST(offer_id AS STRING) AS offer_id,
  NULLIF(offer_name,'null') AS offer_name,
  CAST(NULLIF(price_usd,'null') AS DECIMAL(12,2))  AS price_usd,
  CAST(NULLIF(coins_granted,'null') AS INT) AS coins_granted,
  CAST(NULLIF(vip_only,'null') AS BOOLEAN) AS vip_only,
  current_timestamp() AS bronze_ingest_ts
FROM offers_raw;
