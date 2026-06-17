CREATE DATABASE marketing_db;
USE marketing_db; 
#Giờ chạy SQL kiểm tra thực tế — confirm giả thuyết của bạn:
SELECT 
    COUNT(DISTINCT Z_CostContact) as unique_cost,
    COUNT(DISTINCT Z_Revenue) as unique_revenue,
    MIN(Income) as min_income,
    MAX(Income) as max_income,
    COUNT(*) - COUNT(Income) as missing_income
FROM ml_project1_data;
#KTRA LẠI ĐỂ CHẮC CHẮN XEM CÓ NULL K HAY BỊ NULL IMORT VÀO = 0
SELECT COUNT(*) FROM ml_project1_data WHERE Income = 0;
SELECT COUNT(*) FROM ml_project1_data WHERE Income IS NULL;
