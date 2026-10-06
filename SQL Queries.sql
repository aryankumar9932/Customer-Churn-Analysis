-- CREATING TABLE

CREATE TABLE churn(
					Customer_ID	VARCHAR(20) PRIMARY KEY,
					Gender	VARCHAR(20),
					Age	INT,
					Married VARCHAR(20),
					State VARCHAR(50),
					Number_of_Referrals INT,
					Tenure_in_Months INT,
					Value_Deal VARCHAR(20),
					Phone_Service VARCHAR(20),
					Multiple_Lines VARCHAR(20),
					Internet_Service VARCHAR(20),
					Internet_Type VARCHAR(50),
					Online_Security VARCHAR(20),
					Online_Backup VARCHAR(20),
					Device_Protection_Plan VARCHAR(20),
					Premium_Support VARCHAR(20),
					Streaming_TV VARCHAR(20),
					Streaming_Movies VARCHAR(20),
					Streaming_Music VARCHAR(20),
					Unlimited_Data VARCHAR(20),
					Contract VARCHAR(100),
					Paperless_Billing VARCHAR(20),
					Payment_Method VARCHAR(100),
					Monthly_Charge FLOAT,
					Total_Charges FLOAT,
					Total_Refunds FLOAT,
					Total_Extra_Data_Charges INT,
					Total_Long_Distance_Charges FLOAT,
					Total_Revenue FLOAT,
					Customer_Status VARCHAR(50),
					Churn_Category VARCHAR(50),
					Churn_Reason VARCHAR(200)
)

SELECT * FROM churn

-- DATA EXPLORATION

-- % of Gender in dataset

SELECT 
	Gender,
	COUNT(Gender),
	ROUND(COUNT(Gender)*100.0/(SELECT COUNT(*) FROM churn),2) || '%' AS Percentage
FROM churn
GROUP BY 1

-- Types of contract and their Percentage

SELECT 
	contract,
	COUNT(contract),
	ROUND(COUNT(contract)*100.0/(SELECT COUNT(*) FROM churn),2) || '%' AS Percentage
FROM churn
GROUP BY 1

-- Types of Payment Method

SELECT 
	payment_method,
	COUNT(payment_method),
	ROUND(COUNT(payment_method)*100.0/(SELECT COUNT(*) FROM churn),2) || '%' AS Percentage
FROM churn
GROUP BY 1


-- Top 5 Reasons of Churning

SELECT 
	churn_reason,
	COUNT(churn_reason),
	ROUND(COUNT(churn_reason)*100.0/(SELECT COUNT(*) FROM churn),2) || '%' AS Percentage
FROM churn
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5




-- Finding Null Values

SELECT 
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_Null_Count,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Null_Count,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Null_Count,
    SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS Married_Null_Count,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS State_Null_Count,
    SUM(CASE WHEN Number_of_Referrals IS NULL THEN 1 ELSE 0 END) AS Number_of_Referrals_Null_Count,
    SUM(CASE WHEN Tenure_in_Months IS NULL THEN 1 ELSE 0 END) AS Tenure_in_Months_Null_Count,
    SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END) AS Value_Deal_Null_Count,
    SUM(CASE WHEN Phone_Service IS NULL THEN 1 ELSE 0 END) AS Phone_Service_Null_Count,
    SUM(CASE WHEN Multiple_Lines IS NULL THEN 1 ELSE 0 END) AS Multiple_Lines_Null_Count,
    SUM(CASE WHEN Internet_Service IS NULL THEN 1 ELSE 0 END) AS Internet_Service_Null_Count,
    SUM(CASE WHEN Internet_Type IS NULL THEN 1 ELSE 0 END) AS Internet_Type_Null_Count,
    SUM(CASE WHEN Online_Security IS NULL THEN 1 ELSE 0 END) AS Online_Security_Null_Count,
    SUM(CASE WHEN Online_Backup IS NULL THEN 1 ELSE 0 END) AS Online_Backup_Null_Count,
    SUM(CASE WHEN Device_Protection_Plan IS NULL THEN 1 ELSE 0 END) AS Device_Protection_Plan_Null_Count,
    SUM(CASE WHEN Premium_Support IS NULL THEN 1 ELSE 0 END) AS Premium_Support_Null_Count,
    SUM(CASE WHEN Streaming_TV IS NULL THEN 1 ELSE 0 END) AS Streaming_TV_Null_Count,
    SUM(CASE WHEN Streaming_Movies IS NULL THEN 1 ELSE 0 END) AS Streaming_Movies_Null_Count,
    SUM(CASE WHEN Streaming_Music IS NULL THEN 1 ELSE 0 END) AS Streaming_Music_Null_Count,
    SUM(CASE WHEN Unlimited_Data IS NULL THEN 1 ELSE 0 END) AS Unlimited_Data_Null_Count,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Contract_Null_Count,
    SUM(CASE WHEN Paperless_Billing IS NULL THEN 1 ELSE 0 END) AS Paperless_Billing_Null_Count,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Payment_Method_Null_Count,
    SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END) AS Monthly_Charge_Null_Count,
    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Charges_Null_Count,
    SUM(CASE WHEN Total_Refunds IS NULL THEN 1 ELSE 0 END) AS Total_Refunds_Null_Count,
    SUM(CASE WHEN Total_Extra_Data_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Extra_Data_Charges_Null_Count,
    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Long_Distance_Charges_Null_Count,
    SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END) AS Total_Revenue_Null_Count,
    SUM(CASE WHEN Customer_Status IS NULL THEN 1 ELSE 0 END) AS Customer_Status_Null_Count,
    SUM(CASE WHEN Churn_Category IS NULL THEN 1 ELSE 0 END) AS Churn_Category_Null_Count,
    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Null_Count
FROM churn;



-- Removing Null and Inserting Values in It


CREATE TABLE churn_final AS
SELECT 
    customer_id,
    gender,
    age,
    married,
    state,
    number_of_referrals,
    tenure_in_months,
    COALESCE(value_deal, 'None') AS value_deal,
    phone_service,
    COALESCE(multiple_lines, 'No') AS multiple_lines,
    internet_service,
    COALESCE(internet_type, 'None') AS internet_type,
    COALESCE(online_security, 'No') AS online_security,
    COALESCE(online_backup, 'No') AS online_backup,
    COALESCE(device_protection_plan, 'No') AS device_protection_plan,
    COALESCE(premium_support, 'No') AS premium_support,
    COALESCE(streaming_tv, 'No') AS streaming_tv,
    COALESCE(streaming_movies, 'No') AS streaming_movies,
    COALESCE(streaming_music, 'No') AS streaming_music,
    COALESCE(unlimited_data, 'No') AS unlimited_data,
    contract,
    paperless_billing,
    payment_method,
    monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    customer_status,
    COALESCE(churn_category, 'Others') AS churn_category,
    COALESCE(churn_reason, 'Others') AS churn_reason
FROM churn;

SELECT * FROM churn_final



SELECT 
	contract,
	COUNT(contract),
	ROUND(COUNT(contract)*100.0/(SELECT COUNT(*) FROM churn),2) || '%' AS Percentage
FROM churn_final
where customer_status='Churned'
GROUP BY 1




















