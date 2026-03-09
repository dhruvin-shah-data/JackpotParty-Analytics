# 🎰 SciPlay Analytics — Jackpot Party

![Databricks](https://img.shields.io/badge/Databricks-SQL-FF3621?style=flat&logo=databricks&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=flat&logo=python&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-Public-E97627?style=flat&logo=tableau&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat)

> **Academic project using fictional simulated data. No confidential or proprietary information is included.**  
> Data is limited but will be expanded for further analysis.

| Game Health | Player Engagement | Monetization |
|:-----------:|:-----------------:|:------------:|
| ![](images/dashboards/game_health.png) | ![](images/dashboards/livops_and_player.png) | ![](images/dashboards/monetization_dashboard.png) |

---

## 📌 Overview

This project simulates an **end-to-end analytics workflow** for a mobile gaming studio (SciPlay) product — **Jackpot Party**. The objective is to transform raw gameplay and transaction data into actionable insights that support decision-making across:

- 🎮 Game health monitoring
- 👤 Player engagement analysis
- 🎯 LiveOps evaluation
- 💰 Monetization performance

---

## 🧠 Business Context

Mobile game teams rely on accurate and well-defined metrics to track stability, understand player behavior, measure the effectiveness of LiveOps initiatives, and optimize revenue strategies.

This project reflects how an analytics team would respond to those needs using **structured data modeling** and **KPI-driven dashboards**.

---

## ❓ Stakeholder Questions

| # | Business Question |
|---|-------------------|
| 1 | Is the game stable and healthy over time? |
| 2 | How deeply and frequently are players engaging with the game? |
| 3 | Which LiveOps cohorts drive higher player engagement? |
| 4 | Which regions and user segments generate the most revenue? |
| 5 | Which offers and gameplay mechanics contribute most to monetization and activity? |

---

## 🗂️ Dataset

10 simulated CSV files covering January 2024:

| File | Rows | Description |
|------|------|-------------|
| `users.csv` | 301 | Player profiles — country, platform, age, VIP tier, lifetime spend |
| `sessions.csv` | 1,200 | Play sessions — duration, platform, app version, crash flag |
| `spins.csv` | 800 | Slot activity — machine, bet/win amounts, bonus spin flag |
| `purchases.csv` | 200 | IAP transactions — offer, price, status (success/refunded/failed) |
| `economy_transactions.csv` | 600 | Virtual coin flows — type, delta, anomaly flag |
| `game_events.csv` | 1,000 | Raw event stream — session start/end, platform, latency |
| `ads.csv` | 300 | Ad impressions — type, placement, revenue |
| `installs.csv` | 300 | UA data — source, campaign, country, reinstall flag |
| `liveops_events.csv` | 200 | Live event participation — type, score, completion |
| `offers.csv` | 5 | Offer lookup — Starter / Value / Mega Pack pricing |

---

## 🏗️ Data Pipeline — Medallion Architecture
```
Raw CSVs
   │
   ▼
┌─────────────────────────────────────────┐
│  🥉 BRONZE LAYER                         │
│  Raw ingested datasets                   │
│  gameplay events, sessions, installs,    │
│  purchases, LiveOps activity             │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  🥈 SILVER LAYER                         │
│  Cleaned & standardized tables           │
│  • Duplicates handled                    │
│  • Data types corrected                  │
│  • Nulls addressed                       │
│  • Categorical fields normalized         │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  🥇 GOLD LAYER                           │
│  Business-ready metric tables            │
│  • Directly maps to stakeholder KPIs     │
│  • Single source of truth for dashboards │
│  • One table per analytical domain       │
└─────────────────────────────────────────┘
```

---

## 📊 Dashboards & Insights

### 1. 🎮 Game Health Overview

**Business Question:** Is the game stable and healthy over time?

| KPI | Value | Status |
|-----|-------|--------|
| Total Sessions | 1,200 | ✅ |
| Crash Rate | **50.6%** | 🔴 Critical |
| Daily Active Users | ~40/day | ✅ |
| Total Installs | 300 | ✅ |

> **⚠️ Key Insight:** Game stability and activity levels remain generally consistent over time, with occasional spikes in crashes and revenue volatility indicating potential release-related or operational issues that warrant monitoring. Version **v1.1.0 shows the lowest crash rate (48.3%)** vs older versions.

---

### 2. 👤 Player Engagement & LiveOps Impact

**Business Questions:** How deeply are players engaging? Which LiveOps cohorts drive higher engagement?

| KPI | Value |
|-----|-------|
| Avg Session Duration | ~46 min |
| LiveOps Completion Rate | 46.8% |
| VIP Players | 86 (28.6% of base) |
| Largest Age Segment | 45–54 (59 users) |

> **💡 Key Insight:** Players who participate in LiveOps events show higher session duration and engagement frequency, suggesting LiveOps initiatives are effective in deepening player engagement.

---

### 3. 💰 Monetization & Gameplay Performance

**Business Questions:** Which regions and segments generate the most revenue? Which offers and mechanics contribute most?

| KPI | Value |
|-----|-------|
| Total IAP Revenue | $1,464 |
| ARPU | ~$4.87 |
| Refund Rate | **32.3%** 🔴 |
| Top Region | US — $404.91 |
| Top VIP Tier | Platinum — $5,905 |

> **💡 Key Insight:** Revenue is concentrated in the US and GB. Mega Pack has the highest refund rate (43%). Bonus spins account for 52.9% of total spin volume, with M2 driving the highest net regular spin revenue ($21,700).

---

## 🔑 Key Findings
```
🔴 CRITICAL  — 50.6% crash rate across all sessions (industry norm: <10%)
🔴 HIGH      — 32.3% purchase refund rate; Mega Pack is the primary driver
🟡 WATCH     — Revenue highly concentrated in US + GB (47% of total)
🟢 POSITIVE  — LiveOps participants show longer session durations
🟢 POSITIVE  — v1.1.0 shows improvement over v1.0.x in crash rate
🟢 POSITIVE  — Platinum VIPs generate 38% more than Gold tier
```

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|------|-------|
| **Databricks SQL** | Data pipeline, medallion architecture, metric tables |
| **Python** | Data simulation, validation, quality checks |
| **Tableau Public** | Interactive dashboards |
| **Notion** | Project documentation & tracking |
| **GitHub** | Version control & portfolio |

---

## 📁 Repository Structure
```
sciplay-analytics/
│
├── data/
│   ├── raw/                    # Bronze layer — original CSV files
│   │   ├── users.csv
│   │   ├── sessions.csv
│   │   ├── spins.csv
│   │   ├── purchases.csv
│   │   ├── economy_transactions.csv
│   │   ├── game_events.csv
│   │   ├── ads.csv
│   │   ├── installs.csv
│   │   ├── liveops_events.csv
│   │   └── offers.csv
│   └── gold/                   # Gold layer — aggregated metric tables
│
├── notebooks/
│   ├── 01_bronze_ingestion.sql
│   ├── 02_silver_cleaning.sql
│   └── 03_gold_metrics.sql
│
├── dashboards/
│   ├── sciplay_dashboard.html  # Interactive HTML dashboard
│   └── screenshots/
│       ├── game_health.png
│       ├── monetization.png
│       └── player_engagement.png
│
├── docs/
│   └── project_writeup.md
│
└── README.md
```

---

## 🚀 Suggested Next Steps

- [ ] Investigate crash spikes in relation to release timelines and platform versions
- [ ] Analyze retention and conversion metrics for LiveOps participants vs non-participants
- [ ] Deep-dive into high-performing regions and offers to understand monetization drivers
- [ ] Validate gameplay activity patterns by machine with additional cohorts and time windows
- [ ] Expand dataset beyond January 2024 for trend and seasonality analysis

---

## 💡 Key Learnings

- Translating stakeholder questions into well-defined KPIs leads to more meaningful analysis than starting from available data alone
- Early alignment on metric definitions reduces ambiguity and prevents downstream rework
- A layered data model (Bronze → Silver → Gold) improves data reliability and simplifies business logic
- Business-friendly metric naming significantly improves dashboard usability and stakeholder trust
- Thorough documentation of assumptions is as important as correct SQL when delivering analytics projects

---

## ⚠️ Disclaimer

This is an academic project. All data is **fictional and simulated** for educational purposes only. No real player data, proprietary business information, or confidential SciPlay/Jackpot Party data is used.

---

