1. Active Customers

select count(distinct(customer_id)) as active_customers
from accounts
where status = 'Active'

--------------alternate query------------- 

select count(distinct(c.customer_id)) active_customers
from accounts a
join customers c
on a.customer_id = c.customer_id
where a.status = 'Active'

2. Customer Distribution by Segment

select customer_segment, count(*) as customer_distribution
from customers
group by customer_segment

--------------alternate query------------- 

select customer_segment, count(*) customer_distribution
from customers
group by 1

3. Cities with Highest Customer Concentration

select city, count(*) as number_of_customers,
	         rank() over (order by count(*) desc) as Rank
from customers
group by city
limit 3

4. Total Balance across all acounts

select sum(balance) as total_balance
from accounts

5. Average Balance by account type

select account_type, round(avg(balance),2) as average_balance
from accounts
group by account_type
order by average_balance

--------------alternate query------------- 

select account_type, round(avg(balance),2) average_balance
from accounts
group by 1
order by 2

6. Total Loan Portfolio Value

with payments as (select loan_id, sum(payment_amount) as payment_amount
from loan_payments
group by loan_id)
select sum(loans.loan_amount) - sum(coalesce(payments.payment_amount,0)) as total_portfolio_value
from loans 
left join payments
on loans.loan_id = payments.loan_id
where loans.status = 'Active'

7. Average Loan Amount by Loan Type

select loan_type, round(avg(loan_amount),2) as average_loan_amount
from loans
group by loan_type

8. Monthly Transaction Volume Trend

select to_char(date_trunc('month', transaction_date),'MON YY') as month, count(*) as transaction_volume
from transactions
group by date_trunc('month', transaction_date)
order by date_trunc('month', transaction_date)

--------------alternate query------------- 

select date_part('month', transaction_date) as month,
	   count(*) as transaction_volume
from transactions
group by month
order by month

9. Monthly Transaction Value Trend

select to_char(date_trunc('month', transaction_date), 'Mon YY') as month, 
       sum(amount) as transaction_value
from transactions
group by date_trunc('month', transaction_date)
order by date_trunc('month', transaction_date)

10. Deposits vs Withdrawal Percentage
		
select round(sum(case when transaction_type = 'Withdrawal' then 1 else 0 end) * 100.0/
       count(*),1)as withdrawal_percentage,
	   round(sum(case when transaction_type = 'Deposit' then 1 else 0 end) * 100.0/
	   count(*), 1) as deposit_percentage
from transactions

11. Highest Average Account Balance by Customer Segment

select customers.customer_segment, round(avg(accounts.balance),2) as highest_avg_blnc
from customers 
join accounts
on customers.customer_id = accounts.customer_id
group by customers.customer_segment
order by avg(accounts.balance) desc
limit 1 

12. Top 100 Customers by Total Banking Value

select customer_id,
       sum(balance) total_balance
from accounts
group by customer_id
order by total_balance desc
limit 100

13. Customers with Multiple Banking Products(accounts, loans, credit_cards)

with products as (select customer_id, account_type as product
from accounts
union 
select customer_id, loan_type as product
from loans
union
select customer_id, card_type as product
from credit_cards)
select customer_id, count( distinct product) as number_of_products
from products
group by customer_id
having count(distinct product) > 1
order by customer_id

14. Customers with credit cards but no loans

select distinct  credit_cards.customer_id
from credit_cards
left join loans
on loans.customer_id = credit_cards.customer_id
where loans.customer_id is NULL
order by credit_cards.customer_id

--------------alternate query------------- 

select distinct credit_cards.customer_id 
from loans
right outer join credit_cards
on loans.customer_id = credit_cards.customer_id
where loans.customer_id is NULL
order by credit_cards.customer_id






