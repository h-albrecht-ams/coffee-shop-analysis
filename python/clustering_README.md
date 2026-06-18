# Coffee Shop Sales: Transaction Clustering

Unsupervised clustering of ~149K coffee shop transactions to find distinct purchasing patterns, and a check on whether store locations differ in their mix of those patterns.

**Tools:** Python (pandas, scikit-learn), Tableau
**Data:** Maven "Coffee Shop Sales" — 149,116 transactions, 3 NYC locations, Jan–Jun 2023

---

## Key findings

- **Four distinct transaction patterns:** Weekday Quick Grab, Weekday Multi-Buy, Weekend Purchase, and a small Premium / High-Spend niche.
- **Patterns are defined by *what and how much* people buy, not *when*.** Quantity, price, and weekday/weekend separate the clusters; time of day does not.
- **The most frequent pattern isn't the most valuable.** Quick Grab is 41.05% of transactions but only 28.39% of revenue. Multi-Buy (30.56% of transactions) is the biggest revenue contributor at 39.60%. Premium is ~1.5% of transactions but ~7% of revenue.
- **Stores are nearly identical** in their pattern mix. There is no meaningful "store types."
- **Volume peaks in a broad 8–10 am morning band**, and is uniform across the days of the week.

> This analysis clusters **transactions, not customers**.  The dataset has no customer identifier, so individual people can't be tracked across visits. Patterns describe purchases, not people.

---

## The question

The original goal was to find "customer types." The dataset has **no customer identifier**, so individuals can't be followed across visits. I reframed the question honestly to one the data can answer: **What distinct transaction patterns exist, and do stores differ in their mix of them?**

---

## Method

1. **Confirmed data grain:** 1 row = 1 transaction (149,116 unique IDs across 149,116 rows), so no aggregation needed.
2. **Engineered four numeric features:**  `hour`, `is_weekend`, `transaction_qty`, `unit_price`. Store and product category were excluded from clustering (categorical so no meaningful distance for KMeans) and compared afterward.
3. **Scaled** with `StandardScaler` so features with different ranges (price up to 45, weekend just 0–1) each get a fair vote.
4. **Chose k = 4** via the elbow method. The elbow was soft, so I broke the tie on interpretability and confirmed the choice by inspecting clean, distinct cluster profiles.
5. **KMeans** clustering, then named each cluster after the feature that defines it.
6. **PCA** (2 components, 53% of variance) for a scatter plot; exported the labeled data to Tableau.
7. **Tableau charts:** PCA scatter, normalized cluster-profile bars, revenue-vs-count share chart, and an hour × day volume heatmap.

### Cluster profiles

| Cluster | Avg qty | Avg price | Weekend rate | Defined by |
|---|---|---|---|---|
| Weekday Quick Grab | 1.0 | $3.24 | 0% | the baseline (single, low-price, weekday) |
| Weekday Multi-Buy | 2.1 | $2.93 | 2% | quantity |
| Weekend Purchase | 1.4 | $3.11 | 100% | the day |
| Premium / High-Spend | 1.0 | $20.98 | 29% | price (~1.5% of all transactions) |

---

## Limitations

- **No customer data:** patterns describe transactions, not people.
- **One product per row:** multi-item buckets aren't visible as a single combined purchase.
- **PCA scatter explains 53% of variance:** clusters overlap in 2D; the profile table is the real evidence of distinctness.
- **`hour` does not separate clusters** (it averaged around 11–12 in all of them). Kept as a reported negative finding rather than dropped to force tidier groups. It drives *volume* but not *segmentation*.
- **Revenue ≠ profit:** no cost data, so no profitability claims.
- **Store differences are small (around 4 points max):** and would need a significance test to confirm.


