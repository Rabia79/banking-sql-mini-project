1. Active Customers

select count(distinct(customer_id)) as active_customers
from accounts
where status = 'Active'

or

select count(distinct(c.customer_id)) active_customers
from accounts a
join customers c
on a.customer_id = c.customer_id
where a.status = 'Active'

2. Customer Distribution by Segment

select customer_segment, count(*) as customer_distribution
from customers
group by customer_segment

or

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

or

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

or

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






