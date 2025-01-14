# Verve-DS-Challenge


# Auction Analysis for Application A

The following table contains the aggregated outcomes of several auctions that we participated in for application A. We responded with a variety of bid prices (`bid_price` column), and either won that auction or lost it (indicated via `1` or `0` in the `win` column). The `events` column shows how many times a particular response with a given outcome was observed.

---

## Table 1. Aggregated Auction Statistics for Application A

| app | bid_price($) | win | events   |
|-----|-----------|-----|----------|
| A   | 0.01      | 0   | 100000   |
| A   | 0.01      | 1   | 0        |
| A   | 0.1       | 0   | 7000     |
| A   | 0.1       | 1   | 3000     |
| A   | 0.2       | 0   | 8000000  |
| A   | 0.2       | 1   | 2000000  |
| A   | 0.4       | 0   | 700000   |
| A   | 0.4       | 1   | 300000   |
| A   | 0.5       | 0   | 80000    |
| A   | 0.5       | 1   | 20000    |
| A   | 0.75      | 0   | 7000     |
| A   | 0.75      | 1   | 3000     |
| A   | 1         | 0   | 400      |
| A   | 1         | 1   | 600      |
| A   | 2         | 0   | 30       |
| A   | 2         | 1   | 70       |
| A   | 5         | 0   | 2        |
| A   | 5         | 1   | 8        |
| A   | 9         | 0   | 0        |
| A   | 9         | 1   | 1        |

---

## Problem 1

Based on the table in the above scenario, estimate the expected win rate for a bid response at a given price (prices are listed in the table). State your assumptions clearly and provide the steps on how you arrived at your answer.

---

### Solution

**What is winRate?**  
`win_rate = wins / total_auction`

| app | bid_price($) | non_win_events | win_events | total_auctions | win_rate | auction_percent |
|-----|-----------|----------------|------------|----------------|----------|-----------------|
| A   | 0.01      | 100000         | 0          | 100000         | 0.0      | 0.89            |
| A   | 0.10      | 7000           | 3000       | 10000          | 0.3      | 0.09            |
| A   | 0.20      | 8000000        | 2000000    | 10000000       | 0.2      | 89.12           |
| A   | 0.40      | 700000         | 300000     | 1000000        | 0.3      | 8.91            |
| A   | 0.50      | 80000          | 20000      | 100000         | 0.2      | 0.89            |
| A   | 0.75      | 7000           | 3000       | 10000          | 0.3      | 0.09            |
| A   | 1.00      | 400            | 600        | 1000           | 0.6      | 0.01            |
| A   | 2.00      | 30             | 70         | 100            | 0.7      | 0.00            |
| A   | 5.00      | 2              | 8          | 10             | 0.8      | 0.00            |
| A   | 9.00      | 0              | 1          | 1              | 1.0      | 0.00            |

---

#### Assumptions

##### 1. **Data Assumption**
- Assuming this is yesterday's data, and we have total spend : 533339.0, and total_auction_volume : 11221111 

---

##### 2. **Estimating Expected Win Rate for Given Prices**
- **Scenario**: If we only need to estimate the win rate for `bid_price` values listed in the table:
  - Use a **deterministic approach**:  
    **`win_rate = total_past_wins / total_past_auction_events`**
- **Scenario**: If we want to estimate win rates for a **range of bid prices** (including those listed in the table):
  - Use a **regression model**.

---

##### 3. **Win Rate as a Function**
- The **win rate** is a function of:
  - `bid_price`
  - `external_reason` (e.g., competition bidding, seasonality)
- **Assumption**: External reasons are constant, so the win rate is **directly dependent on bid_price**.

---

##### 4. **Here Bid Price selection is random and not Function of below**
- The `bid_price` usually depends on:
  - **Spending patterns**
  - **User signals**
  - **Contextual signals**
  - **Bid constraints**
- **Assumption**: using this type of model for bid_prices selection will predetermine max auction_volume at individual bid_prices, but here we didnt know why specfic bid_prices were choosen hence assuming more non-learned model selection of bid-prices. hence, max auction_volume at individual bid_price  is unknown and but can assumed to be capped at total_auction_events.
  * example : Assumption - $0.2 bid auction volume is not capped at 10000000, but we are capping at 11221111.

also since win_rate depends on what bid_price is set and bid_price is related to contextual signal -> this can explain the affect of win_rate to rise then dip then again rises with bid_prices.
  - **Example**:  
    - special cases like premium/private audience unlocking at specific bid prices - giving higher win_rate.
    - or scenarios where higher bid prices significantly increase total auction events.
    - **Overall total auctions and win rates flatten after a specific bid price**.

---


##### 5. **Data Limitations and Confidence**
- **Less data → Less confidence**:  
  - After a certain bid price, the number of auction events decreases.  
  - This reduces confidence in accuracy due to limited training data for validation.

---

##### 6. **Win Rate Cap**
- The **win rate** is capped at **1**.

---

##### 7. **Regression Model : Weighting for Bid Price Data**
- **Observation**: Bid prices like **0.2** and **0.4** account for **98% of auctions**.  
- To ensure other bid price data contributes meaningfully to the model:
  - Use **log(10) weighting** for these data points.

---

##### 8. **Regression Model : Non-Linear Trends in Auctions**
- **Observation**: The maximum number of auctions occurs between **0.1** and **0.85** bid prices.  
- The win rate shows a **non-linear trend**:
  - It **dips**, **rises**, **dips again**, and then **rises**.  
- To model this behavior and reduce Mean Squared Error (MSE):
  - Use a **non-linear model** like **XGBoost**.

---

## Problem 2

We receive money from our advertisers if we deliver them a win. Let's say that our advertiser is willing to pay \$0.50 per win. This then becomes the upper bound for the bid valuation that we can submit in response to the publisher. For example, if we submit a bid response of \$0.40 and we win, then the advertiser pays us \$0.50, we pay \$0.40 to the publisher, and we make a net revenue of \$0.10.

If our goal was to maximize net revenue, what is the most optimal bid valuation we should send in our response? Use your estimations from **Problem 1** and all other available information.

---

### Solution 2

We can solve this problem if we know:

1. **Maximum Auction Volume at each bid price**, or  
2. **Maximum Spend at each bid price**.

### Key Formulas:

1. **Profit at a given bid price**:  
   `Profit(bid_price) = advertiser_price - bid_price`

2. **Total Revenue at a given bid price**:  
   `Total_Revenue(bid_price) = win_events(bid_price) * Profit(bid_price)`

3. **Win Events Calculation**:  
   We can calculate `win_events(bid_price)` using two approaches:  
   - **Approach 1**:  
     `win_events(bid_price) = total_auction(bid_price) * win_rate(bid_price)`  
   - **Approach 2**:  
     `Spend(bid_price) = win_events(bid_price) * bid_price`  
     `win_events(bid_price) = Spend(bid_price) / bid_price`

---

### Approach 1. Capping Auction Volume at each bid price to Total Auction Events but with infinite spend.

- In Solution-1 Assumption-3 we discussed that, variety of bids are placed for auctions, hence - we are not known to the maxAuction Volume from DSP at each bidPrice.
- In this scenario, we assume that the **maximum auction volume at a bid price is equal to the total auction volume across all bid prices**.  
- This assumption allows us to calculate revenue based on the total auction events and win rate for each bid price.

#### Revenue Formula:

**`revenue(bid_price) = Σ(auction_events over all bid prices) * win_rate(bid_price) * (advertiser_price - bid_price)`**

#### Why is $0.1 the best bid price?

From the table, the **total auction events across all bid prices** is:

**`Σ(auction_events) = 100,000 + 10,000 + 10,000,000 + 1,000,000 + 100,000 + 10,000 + 1,000 + 100 + 10 + 1 = 11,211,111`**

For **$0.1**, using the formula:

**`revenue(0.1) = Σ(auction_events) * win_rate(0.3) * (advertiser_price - bid_price)`**  
Assuming the advertiser price is **$0.5**, we calculate:

**`revenue(0.1) = 11,211,111 * 0.3 * (0.5 - 0.1)`**  
**`revenue(0.1) = 11,211,111 * 0.3 * 0.4 = $1,346,533`**

This matches the table value of **$1,346,533**, which is the maximum revenue achieved at **$0.1**. Other bid prices result in lower revenues due to lower win rates or higher bid prices reducing profit margins.

#### Result Table:

| #   | App | Bid Price | Win Events | Auction Events | Win Rate | Profit Margin | Revenue     |
|-----|-----|-----------|------------|----------------|----------|---------------|-------------|
| 0   | A   | 0.01      | 0          | 100,000        | 0.0      | 0.49          | 0           |
| 1   | A   | 0.10      | 3,000      | 10,000         | 0.3      | 0.40          | 1,346,533   |
| 2   | A   | 0.20      | 2,000,000  | 10,000,000     | 0.2      | 0.30          | 673,266     |
| 3   | A   | 0.40      | 300,000    | 1,000,000      | 0.3      | 0.10          | 336,633     |
| 4   | A   | 0.50      | 20,000     | 100,000        | 0.2      | 0.00          | 0           |
| 5   | A   | 0.75      | 3,000      | 10,000         | 0.3      | -0.25         | -841,583    |
| 6   | A   | 1.00      | 600        | 1,000          | 0.6      | -0.50         | -3,366,333  |
| 7   | A   | 2.00      | 70         | 100            | 0.7      | -1.50         | -11,782,166 |
| 8   | A   | 5.00      | 8          | 10             | 0.8      | -4.50         | -40,395,999 |
| 9   | A   | 9.00      | 1          | 1              | 1.0      | -8.50         | -95,379,443 |

---

### Approach 2. Capped Spend at each bid price but with infinite auctions.

- In this scenario, we assume a **capped spend of $500**.  
- This assumption allows us to calculate the total auctions and revenue for each bid price based on the capped spend.

#### Revenue Formula:

**`total_auctions(bid_price) = capped_spend / bid_price`**  
**`revenue(bid_price) = total_auctions(bid_price) * win_rate(bid_price) * (advertiser_price - bid_price)`**  
**`revenue(bid_price) = (capped_spend / bid_price) * win_rate(bid_price) * (advertiser_price - bid_price)`**

#### Why is $0.1 the best bid price?

For **$0.1**, the total auctions are calculated as:

**`total_auctions(0.1) = capped_spend / bid_price = 500 / 0.1 = 5,000`**

Using the formula:

**`revenue(0.1) = total_auctions(5,000) * win_rate(0.3) * (advertiser_price - bid_price)`**  
Assuming the advertiser price is **$0.5**, we calculate:

**`revenue(0.1) = 5,000 * 0.3 * (0.5 - 0.1)`**  
**`revenue(0.1) = 5,000 * 0.3 * 0.4 = $600`**

This matches the table value of **$600**, which is the maximum revenue achieved at **$0.1**. Other bid prices result in lower revenues due to lower total auctions or higher bid prices reducing profit margins.

#### Result Table:

| #   | App | Bid Price | Win Events | Auction Events | Win Rate | Profit Margin | Revenue |
|-----|-----|-----------|------------|----------------|----------|---------------|---------|
| 0   | A   | 0.01      | 0          | 100,000        | 0.0      | 0.49          | 0       |
| 1   | A   | 0.10      | 3,000      | 10,000         | 0.3      | 0.40          | 600     |
| 2   | A   | 0.20      | 2,000,000  | 10,000,000     | 0.2      | 0.30          | 150     |
| 3   | A   | 0.40      | 300,000    | 1,000,000      | 0.3      | 0.10          | 37      |
| 4   | A   | 0.50      | 20,000     | 100,000        | 0.2      | 0.00          | 0       |
| 5   | A   | 0.75      | 3,000      | 10,000         | 0.3      | -0.25         | -49     |
| 6   | A   | 1.00      | 600        | 1,000          | 0.6      | -0.50         | -150    |
| 7   | A   | 2.00      | 70         | 100            | 0.7      | -1.50         | -262    |
| 8   | A   | 5.00      | 8          | 10             | 0.8      | -4.50         | -360    |
| 9   | A   | 9.00      | 1          | 1              | 1.0      | -8.50         | -472    |

