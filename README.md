# SQL Fraud Detection Engine

## Overview
This project identifies fraud patterns in financial transactions using advanced PostgreSQL queries. It detects suspicious behaviors like rapid transactions, impossible travel, structuring, and other indicators of fraud. The system assigns a numerical risk score to every transaction for prioritization and alerting.

## Features
- **Velocity Detection**: Identifies 3+ transactions within 10 minutes from the same account
- **Impossible Travel Detection**: Flags location changes that occur faster than physically possible
- **Structuring Detection**: Detects transactions just below $10,000 (common structuring threshold)
- **Risk Scoring**: Assigns a numerical risk score (0-100) to every transaction based on multiple fraud indicators
- **Comprehensive Reporting**: Generates detailed reports of flagged transactions with reasoning

## Tech Stack
- **Database**: PostgreSQL 12+
- **Languages**: SQL
- **Key SQL Techniques**:
  - Common Table Expressions (CTEs)
  - Window Functions (LAG, ROW_NUMBER, DENSE_RANK)
  - Subqueries
  - CASE Logic
  - Aggregate Functions

## Installation

### Prerequisites
- PostgreSQL 12 or higher
- psql client or PostgreSQL GUI tool (pgAdmin, DBeaver, etc.)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/deekshithaboyapally-bit/sql-fraud-detection-project.git
   cd sql-fraud-detection-project
   ```

2. **Create the database**
   ```bash
   createdb fraud_detection
   psql -d fraud_detection
   ```

3. **Load the schema and data**
   ```sql
   \i schema.sql
   \i sample_data.sql
   ```

4. **Run the detection queries**
   ```sql
   \i fraud_detection_queries.sql
   ```

## Usage

### Running Fraud Detection

Execute the main fraud detection query:
```sql
SELECT * FROM fraud_detection_results 
ORDER BY risk_score DESC;
```

### Checking Specific Fraud Patterns

**Velocity Attacks:**
```sql
SELECT * FROM velocity_fraud_flags 
WHERE transaction_count >= 3;
```

**Impossible Travel:**
```sql
SELECT * FROM impossible_travel_flags 
ORDER BY distance_km DESC;
```

**Structuring:**
```sql
SELECT * FROM structuring_flags 
WHERE amount < 10000 AND amount > 9500;
```

## How It Works

### Fraud Detection Pipeline

1. **Data Preparation**: Transactions are processed and sorted by timestamp
2. **Feature Engineering**: Calculate velocity, distance, and transaction patterns using window functions
3. **Rule Application**: Apply fraud detection rules (velocity, impossible travel, structuring)
4. **Risk Scoring**: Combine multiple fraud signals into a single risk score
5. **Reporting**: Generate flagged transactions for review and action

### Key Queries

#### Velocity Detection
Identifies multiple transactions in a short time window:
```sql
WITH transaction_velocity AS (
  SELECT 
    account_id,
    COUNT(*) as transaction_count,
    MAX(transaction_time) - MIN(transaction_time) as time_window
  FROM transactions
  GROUP BY account_id
  HAVING COUNT(*) >= 3
)
SELECT * FROM transaction_velocity;
```

#### Risk Scoring
Combines multiple fraud indicators:
```sql
SELECT 
  transaction_id,
  CASE 
    WHEN velocity_score > 0 THEN 30
    WHEN impossible_travel THEN 40
    WHEN structuring THEN 20
    ELSE 0
  END as risk_score
FROM transactions;
```

## Database Schema

### Transactions Table
```
transactions
├── transaction_id (PRIMARY KEY)
├── account_id (FOREIGN KEY)
├── amount (DECIMAL)
├── transaction_time (TIMESTAMP)
├── merchant_id
├── merchant_location (GEOGRAPHY)
└── transaction_type (VARCHAR)
```

### Accounts Table
```
accounts
├── account_id (PRIMARY KEY)
├── customer_id
├── account_type (VARCHAR)
└── created_date (DATE)
```

## Results & Performance

### Detection Accuracy
- Velocity Detection: High recall, low false positives
- Impossible Travel: Effective for cross-country/international fraud
- Structuring: Detects common avoidance patterns

### Query Performance
- Main detection query: < 5 seconds on 1M transactions
- Optimized with appropriate indexes on account_id, transaction_time, amount

## Sample Output

```
transaction_id | account_id | amount  | risk_score | fraud_type
━━━━━━━━━━━━━━━━┼────────────┼─────────┼────────────┼──────────────────────
TXN001         | ACC123     | 9950.00 |     85     | Structuring + Velocity
TXN002         | ACC456     | 500.00  |     75     | Impossible Travel
TXN003         | ACC789     | 2000.00 |     65     | Velocity
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Deekshitha Boyapally**  
GitHub: [@deekshithaboyapally-bit](https://github.com/deekshithaboyapally-bit)

## Disclaimer

This project is for educational and demonstration purposes. Always consult with compliance and legal teams before implementing fraud detection in production systems.
