# Bank Customer Analysis

## Project Description
The company **Banking Intelligence** aims to develop a supervised machine learning model to predict future behaviors of its customers based on transactional data and product ownership characteristics. The goal of the project is to create a denormalized table with a series of indicators (features) derived from the available tables in the database, which represent customer behaviors and financial activities.

## Objective
Our objective is to create a **feature table** for training machine learning models, enriching customer data with various indicators calculated from their transactions and accounts. The final table will be referred to by the customer ID and will contain both quantitative and qualitative information.

## Added Value
The denormalized table will allow the extraction of **advanced behavioral features** for training supervised machine learning models, providing numerous advantages to the company:

- **Customer behavior prediction**: By analyzing transactions and product ownership, behavior patterns can be identified to predict future actions, such as purchasing new products or closing accounts.
  
- **Reduction in churn rate**: Using behavioral indicators, a model can be built to identify customers at risk of churn, enabling timely interventions by the marketing team.
  
- **Improved risk management**: Segmentation based on financial behaviors helps to identify high-risk customers and optimize credit and risk strategies.
  
- **Personalization of offers**: The extracted features can be used to personalize product and service offers based on individual customers' habits and preferences, thus increasing customer satisfaction.
  
- **Fraud prevention**: By analyzing transactions by type and amount, the model can detect behavioral anomalies indicative of fraud, improving security and prevention strategies.

These advantages will lead to an overall improvement in business operations, enabling more efficient customer management and sustainable business growth.

## Database Structure
The database consists of the following tables:

- **Cliente**: Contains personal information about customers (e.g., age).
- **Conto**: Contains information about the accounts held by customers.
- **Tipo_conto**: Describes the different types of accounts available.
- **Tipo_transazione**: Contains the types of transactions that can occur on the accounts.
- **Transazioni**: Contains the details of transactions made by customers across various accounts.

## Behavioral Indicators to Calculate
The indicators will be calculated for each individual customer (referred to by `id_cliente`) and will include:

### Basic Indicators
- Age of the customer (from the **Cliente** table).

### Transaction Indicators
- Number of outgoing transactions across all accounts.
- Number of incoming transactions across all accounts.
- Total amount transacted in outgoing transactions across all accounts.
- Total amount transacted in incoming transactions across all accounts.

### Account Indicators
- Total number of accounts held.
- Number of accounts held by type (one indicator for each account type).

### Transaction Indicators by Account Type
- Number of outgoing transactions by account type (one indicator per account type).
- Number of incoming transactions by account type (one indicator per account type).
- Total amount transacted in outgoing transactions by account type (one indicator per account type).
- Total amount transacted in incoming transactions by account type (one indicator per account type).

## Plan for Creating the Denormalized Table

### 1. Joining Tables
To construct the final table, a series of joins between the available tables in the database will be necessary.

### 2. Calculating Indicators
Behavioral indicators will be calculated using aggregation operations (`SUM`, `COUNT`) to obtain the required totals.

