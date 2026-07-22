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

15. Customers with accounts but no credit cards

select accounts.customer_id
from accounts
left join credit_cards
on accounts.customer_id = credit_cards.customer_id
where credit_cards.customer_id is NULL
order by accounts.customer_id

16. Percentage of Customers owning All Major Products

select count(customers.customer_id) * 100/(select count(*) from customers) || '%' as percentage
from customers
where exists 
            (select 1
	           from accounts
			   where accounts.customer_id = customers.customer_id)
and exists  (select 1
             from credit_cards
			 where credit_cards.customer_id = customers.customer_id)
and exists  (select 1 
             from loans
			 where loans.customer_id = customers.customer_id)

---------------alternate query----------------

select count(distinct customers.customer_id) * 100/(select count(*) from customers) || '%' as percentage
from customers
inner join accounts
on customers.customer_id = accounts.customer_id
inner join credit_cards
on customers.customer_id = credit_cards.customer_id
inner join loans
on customers.customer_id = loans.customer_id
	
17. Branches with Highest Deposits

select transactions.branch_id, branches.branch_name, sum(transactions.amount) as deposits
from transactions
join branches
on transactions.branch_id = branches.branch_id
where transactions.transaction_type = 'Deposit'
group by transactions.branch_id,  branches.branch_name
order by deposits desc
limit 10

18. Cities with largest share of Deposits

select branches.city, sum(transactions.amount) as deposits
from transactions
join branches
on transactions.branch_id = branches.branch_id
where transactions.transaction_type = 'Deposit'
group by branches.city
order by deposits desc

19. Frequently used transaction channels

select channel, count(*) usage_frequency
from transactions
group by channel
order by usage_frequency desc

20. Channels with highest transaction_value

select channel, sum(amount) as transaction_value
from transactions
group by channel
order by transaction_value desc

21. Branches with more transactions processed

select transactions.branch_id, branches.branch_name, count(*) as transaction_volume
from transactions
join branches
on transactions.branch_id = branches.branch_id
group by transactions.branch_id,  branches.branch_name
order by transaction_volume desc

22. Customers with most transactions

select customers.customer_id, count(*) as transaction_volume
from customers
join accounts
on customers.customer_id = accounts.customer_id
join transactions
on accounts.account_id = transactions.account_id
group by customers.customer_id
order by transaction_volume desc

----------------- Assumption: Loan volume refers to the total value of loans issued -----------------

23. Highest Loan Volume by Loan Type

select loan_type, sum(loan_amount) loan_volume
from loans
group by loan_type
order by loan_volume desc
limit 1

24. Customer Segments with largest loans

select customers.customer_segment, sum(loan_amount) as loan_amount
from customers
join loans
on customers.customer_id = loans.customer_id
group by customers.customer_segment
order by loan_amount desc

25. Cities with Highest Loans

select customers.city, sum(loan_amount) as loan_amount
from customers
join loans
on customers.customer_id = loans.customer_id
group by customers.city
order by loan_amount desc
limit 5






