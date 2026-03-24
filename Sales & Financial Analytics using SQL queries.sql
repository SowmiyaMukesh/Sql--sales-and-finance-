#Retrieve detailed sales records for customer 90002002 in fiscal year 2021,including product details and calculated gross sales amount.
select 
s.date,s.product_code,p.product,p.variant,s.sold_quantity,g.gross_price,round(g.gross_price*s.sold_quantity,2) as gross_price_total
 FROM fact_sales_monthly s 
 JOIN dim_product p on p.product_code=s.product_code 
JOIN fact_gross_price g on g.product_code=s.product_code and g.fiscal_year=get_fiscal_year(s.date)
 where customer_code=90002002 and get_fiscal_year(date)=2021 
 order by date asc limit 100000;
 
 #Calculate total gross sales per date for customer 90002002 by aggregating sales data
 select s.date,sum(g.gross_price*s.sold_quantity) as gross_price_total FROM fact_sales_monthly s 
 JOIN fact_gross_price g ON g.product_code=s.product_code and g.fiscal_year=get_fiscal_year(s.date) 
 WHERE customer_code=90002002 group by s.date order by s.date asc;
 
 #Calculate total gross sales per fiscal year for customer 90002002.
 select get_fiscal_year(date) as Fiscal_year,
 SUM(round(sold_quantity*g.gross_price,2)) FROM fact_sales_monthly s 
 JOIN fact_gross_price g on g.fiscal_year=get_fiscal_year(s.date) and g.product_code=s.product_code
 WHERE customer_code=90002002 group by get_fiscal_year(date) order by fiscal_year;
 
 #Calculate total monthly sales per date for customer 90002002
 select s.date,SUM(round(s.sold_quantity*g.gross_price,2)) as monthly_Sales
 FROM fact_sales_monthly s JOIN fact_gross_price g on  g.fiscal_year=get_fiscal_year(s.date) and g.product_code=s.product_code
 WHERE customer_code=90002002 group by date;
 
 #Calculate total sold quantity for the India market in fiscal year 2021.
 select c.market,sum(sold_quantity) as total_qty FROM fact_sales_monthly s
 JOIN dim_customer c on s.customer_code=c.customer_code WHERE get_fiscal_year(s.date)=2021 and c.market="india" group by c.market;
 
 #Retrieve detailed sales records for customer 90002002 in fiscal year 2021, including product details, gross sales amount, and pre-invoice discount percentage.
select 
s.date,s.product_code,p.product,p.variant,s.sold_quantity,g.gross_price as gross_price_per_item,
round(g.gross_price*s.sold_quantity,2) as gross_price_total,
pre.pre_invoice_discount_pct
 FROM fact_sales_monthly s 
 JOIN dim_product p on p.product_code=s.product_code 
JOIN fact_gross_price g on g.product_code=s.product_code and g.fiscal_year=s.fiscal_year 
JOIN fact_pre_invoice_deductions pre on pre.customer_code=s.customer_code and pre.fiscal_year=s.fiscal_year
 where s.customer_code=90002002 and s.fiscal_year=2021 
 order by date asc limit 100000;
 
 #Calculate net invoice sales after applying pre-invoice discount on gross sales.
select *,(gross_price_total-gross_price_total*pre_invoice_discount_pct) as net_invoice_sales FROM sales_preinv_discount;
select *,(1-pre_invoice_discount_pct)*gross_price_total as net_invoice_sales,(po.discounts_pct+po.other_deductions_pct) as post_invoice_discount_pct  
FROM sales_preinv_discount s
JOIN fact_post_invoice_deductions po on s.date=po.date and s.product_code=po.product_code
and s.customer_code=po.customer_code;

#Retrieve detailed sales records including gross sales, net invoice sales after pre-invoice discount, and post-invoice discount percentage by joining pre- and post-invoice data.
select s.date,s.fiscal_year,s.customer_code,s.market,s.product_code,s.product,s.variant,s.sold_quantity,
s.gross_price_total,s.pre_invoice_discount_pct,(s.gross_price_total-s.pre_invoice_discount_pct*s.gross_price_total) as net_invoice_Sales,
(po.discounts_pct+po.other_deductions_pct) as post_invoice_discount_pct
 FROM sales_preinv_discount s JOIN fact_post_invoice_deductions po 
on po.customer_code=s.customer_code AND po.product_code=s.product_code AND po.date=s.date;

#Calculate net sales after applying post-invoice discount on net invoice sales.
select *,(1-post_invoice_discount_pct)*net_invoice_sales as net_Sales FROM sales_postinv_discount;

#Retrieve detailed sales records with customer, product, quantity, and gross price information.
select s.date,s.fiscal_year,c.customer,s.customer_code,c.market,s.product_code,p.product,p.variant,s.sold_quantity,
g.gross_price as gross_price_per_item,round(s.sold_quantity*g.gross_price,2) as gross_price_total
 FROM fact_sales_monthly s JOIN dim_product p on s.product_code=p.product_code 
JOIN dim_customer c ON c.customer_code=s.customer_code
JOIN fact_gross_price g on g.fiscal_year=s.fiscal_year AND g.product_code=s.product_code;

#Retrieve top 5 markets by total net sales for fiscal year 2021.
select market,round(sum(net_sales)/1000000,2) as net_sales_mln FROM net_sales where fiscal_year=2021 group by market
order by net_sales_mln desc limit 5;

#Retrieve top N customers by total net sales for a given fiscal year and market.
select customer,round(sum(net_sales)/1000000,2) as net_sales_mln FROM net_sales s
JOIN dim_customer c ON s.customer_code=c.customer_code
where s.fiscal_year=in_fiscal_year AND s.market=in_market group by customer 
order by net_sales_mln desc 
limit in_top_n;

#Retrieve top 5 products by total net sales for fiscal year 2021.
select product,round(sum(net_sales)/1000000,2) as net_sales_mln FROM net_sales where fiscal_year=2021 group by product
order by net_sales_mln desc limit 5;

#Calculate customer-wise net sales and percentage contribution to total sales and regional sales for fiscal year 2021.
with cte1 as (select customer,round(sum(net_sales)/1000000,2) as net_sales_mln FROM net_sales s
JOIN dim_customer c ON s.customer_code=c.customer_code
where s.fiscal_year=2021  group by customer)
select *,
net_sales_mln*100/sum(net_Sales_mln) over() as pct FROM cte1
order by net_sales_mln desc ;
with cte1 as (select c.customer,c.region,round(sum(net_sales)/1000000,2) as net_sales_mln FROM net_sales s
JOIN dim_customer c ON s.customer_code=c.customer_code
where s.fiscal_year=2021  group by c.customer,c.region)
select *,net_sales_mln*100/sum(net_sales_mln) over(partition by region) as pct  FROM cte1
order by region, net_sales_mln desc;