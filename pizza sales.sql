create database Pizza_sales;
use Pizza_sales;

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

/* Total number of order placed*/
select count(distinct order_id) as Total_orders
from order_details;

/* Total Revenue generated from pizza sales */
select cast(sum(order_details.quantity*pizzas.price) as decimal(10,2)) as total_revenue
from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id;

/* The highest priced pizza */
select pizza_types.name, pizzas.price as price
from pizzas 
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc
limit 1;

/* Average order value */
select cast((sum(pizzas.price)/count(distinct order_details.order_id)) as decimal(10,2)) as Average_order_value
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id;

/* Top 5 most ordered pizza types along their quantities */
select pizza_types.name, sum(order_details.quantity) as Total_Ordered
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by sum(order_details.quantity) desc
limit 5;

/* Most common pizza size ordered */
select pizzas.size as size, count(order_details.order_id) as Total_order
from pizzas
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by count(order_details.order_id) desc
limit 1;

/* The average no. of pizzas ordered per day */
select avg(Daily_pizzas) as Average_pizzas_per_day
from (select orders.date, sum(order_details.quantity) as Daily_pizzas
from orders
join order_details on orders.order_id = order_details.order_id
group by orders.date)
as Daily_order;

/* Top 5 most order pizza type based on revenue for each pizza category */
select pizza_types.name, pizza_types.category, sum(order_details.quantity*pizzas.price)  as total_revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name,pizza_types.category
order by total_revenue desc
limit 5;

/* The percentage contribution of each pizza type of revenue */
with Total_Revenue as (
    select sum(order_details.quantity * pizzas.price) as total_revenue
    from order_details
    join pizzas on order_details.pizza_id = pizzas.pizza_id
),
Category_Revenue as (
    select pizza_types.category,
           sum(order_details.quantity * pizzas.price) as category_revenue
    from order_details
    join pizzas on order_details.pizza_id = pizzas.pizza_id
    join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
    group by pizza_types.category
)
select category,
       concat(cast((category_revenue / total_revenue * 100) as decimal(10,2)), '%') as revenue_contribution
from Category_Revenue, Total_Revenue
order by revenue_contribution desc;



