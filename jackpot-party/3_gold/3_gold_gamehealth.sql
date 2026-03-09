-- Health of the Game -- 
CREATE TABLE IF NOT EXISTS jackpot_party.gold.game_health_daily AS
WITH
-- 1) Create a date spine so every day shows up even if a metric is missing
date_spine AS (
  SELECT DISTINCT DATE(install_ts) AS dt
  FROM jackpot_party.silver.fact_installs
  UNION
  SELECT DISTINCT DATE(session_start_ts) AS dt
  FROM jackpot_party.silver.fact_sessions
  UNION
  SELECT DISTINCT DATE(purchase_ts) AS dt
  FROM jackpot_party.silver.fact_purchases
),

-- 2) Installs per day
installs_daily AS (
  SELECT
    DATE(install_ts) AS dt,
    COUNT(*) AS installs
  FROM jackpot_party.silver.fact_installs
  GROUP BY DATE(install_ts)
),

-- 3) Sessions + DAU + crashed sessions per day
sessions_daily AS (
  SELECT
    DATE(session_start_ts) AS dt,
    COUNT(*) AS sessions,
    COUNT(DISTINCT user_id) AS dau,
    SUM(CASE WHEN crashed = TRUE THEN 1 ELSE 0 END) AS crashed_sessions
  FROM jackpot_party.silver.fact_sessions
  GROUP BY DATE(session_start_ts)
),

-- 4) Revenue per day (exclude non-successful statuses)
revenue_daily AS (
  SELECT
    DATE(purchase_ts) AS dt,
    SUM(price_usd) AS revenue_usd
  FROM jackpot_party.silver.fact_purchases
  WHERE LOWER(status) = 'success'
  GROUP BY DATE(purchase_ts)
)

SELECT
  d.dt AS date,

  COALESCE(i.installs, 0) AS installs,
  COALESCE(s.dau, 0) AS dau,
  COALESCE(s.sessions, 0) AS sessions,

  COALESCE(r.revenue_usd, 0) AS revenue_usd,

  -- ARPDAU
  COALESCE(r.revenue_usd, 0) / NULLIF(COALESCE(s.dau, 0), 0) AS arpdau,

  -- crash rate (% of sessions that crashed)
  COALESCE(s.crashed_sessions, 0) / NULLIF(COALESCE(s.sessions, 0), 0) AS crashes_pct,

  -- (optional but useful for dashboards)
  COALESCE(s.crashed_sessions, 0) AS crashed_sessions

FROM date_spine d
LEFT JOIN installs_daily i ON d.dt = i.dt
LEFT JOIN sessions_daily s ON d.dt = s.dt
LEFT JOIN revenue_daily r ON d.dt = r.dt
ORDER BY d.dt;
