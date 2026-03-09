CREATE OR REPLACE VIEW jackpot_party.gold.vip_user_rollup AS
SELECT
  u.user_id,
  u.is_vip,
  u.vip_tier,
  u.country,
  u.platform,
  COALESCE(p.purchase_revenue_usd,0) AS purchase_revenue_usd,
  COALESCE(a.ad_revenue_usd,0)       AS ad_revenue_usd,
  COALESCE(p.purchase_revenue_usd,0) + COALESCE(a.ad_revenue_usd,0) AS total_revenue_usd,
  COALESCE(s.sessions,0)             AS sessions,
  COALESCE(s.session_time_sec,0)     AS session_time_sec
FROM jackpot_party.silver.dim_users u
LEFT JOIN (
  SELECT user_id, SUM(CASE WHEN status='success' THEN price_usd ELSE 0 END) AS purchase_revenue_usd
  FROM jackpot_party.silver.fact_purchases
  GROUP BY user_id
) p ON u.user_id=p.user_id
LEFT JOIN (
  SELECT user_id, SUM(revenue_usd) AS ad_revenue_usd
  FROM jackpot_party.silver.fact_ads
  GROUP BY user_id
) a ON u.user_id=a.user_id
LEFT JOIN (
  SELECT user_id, COUNT(*) AS sessions, SUM(session_length_sec) AS session_time_sec
  FROM jackpot_party.silver.fact_sessions
  GROUP BY user_id
) s ON u.user_id=s.user_id;


-- LiveOps 

CREATE OR REPLACE VIEW jackpot_party.gold.liveops_engagement AS
WITH liveops_participants AS (
  SELECT DISTINCT
    user_id
  FROM jackpot_party.silver.fact_liveops_events
),

user_sessions AS (
  SELECT
    user_id,
    COUNT(*)                AS sessions,
    SUM(session_length_sec) AS session_time_sec,
    AVG(session_length_sec) AS avg_session_length_sec
  FROM jackpot_party.silver.fact_sessions
  GROUP BY user_id
)

SELECT
  CASE
    WHEN lp.user_id IS NOT NULL THEN 'participant'
    ELSE 'non_participant'
  END AS liveops_cohort,

  COUNT(DISTINCT u.user_id)                    AS users,
  AVG(COALESCE(us.sessions, 0))                AS avg_sessions_per_user,
  AVG(COALESCE(us.session_time_sec, 0))        AS avg_session_time_sec_per_user,
  AVG(COALESCE(us.avg_session_length_sec, 0))  AS avg_session_length_sec

FROM jackpot_party.silver.dim_users u
LEFT JOIN liveops_participants lp
  ON u.user_id = lp.user_id
LEFT JOIN user_sessions us
  ON u.user_id = us.user_id
GROUP BY 1;

