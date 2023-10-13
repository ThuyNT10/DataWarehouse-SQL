DAP303 - asm1 - Cau1
select year(website_sessions.created_at) as yr,
       quarter(website_sessions.created_at) as qtr,
       count(distinct website_sessions.website_session_id) as sessions,
       count(distinct orders.order_id) as orders
from website_sessions left join orders
     on website_sessions.website_session_id=orders.website_session_id
group by 1,2;
       
       
DAP303 - asm1 - Cau2
select year(website_sessions.created_at) as yr,
       quarter(website_sessions.created_at) as qtr,
       count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) 
             as session_to_order_conv_rate,
       sum(orders.price_usd)/count(distinct orders.order_id) as revenue_per_order,
       sum(orders.price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session
    from website_sessions left join orders
     on website_sessions.website_session_id=orders.website_session_id
group by 1,2;    

select distinct pageview_url from website_pageviews;   

DAP303 - asm1 - Cau3
select year(website_sessions.created_at) as yr,
       quarter(website_sessions.created_at) as qtr,
       count(distinct case when website_sessions.utm_source='gsearch'and website_sessions.utm_campaign='nonbrand' 
             then orders.order_id else null end) as gsearch_nonbrand_orders,
       count(distinct case when website_sessions.utm_source='bsearch'and website_sessions.utm_campaign='nonbrand' 
             then orders.order_id else null end) as bsearch_nonbrand_orders,
       count(distinct case when website_sessions.utm_campaign='brand' 
             then orders.order_id else null end) as brand_search_orders,
       count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is not null 
             then orders.order_id else null end) as organic_type_in_orders,      
       count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is null
             then orders.order_id else null end) as direct_type_in_orders
       from website_sessions left join orders 
            on website_sessions.website_session_id=orders.website_session_id
group by 1,2;


DAP303 - asm1 - Cau4
select year(website_sessions.created_at) as yr,
       quarter(website_sessions.created_at) as qtr,
       count(distinct case when website_sessions.utm_source='gsearch'and website_sessions.utm_campaign='nonbrand' 
then orders.order_id else null end)/count(distinct website_sessions.website_session_id) as gsearch_nonbrand_conv_rt,
       count(distinct case when website_sessions.utm_source='bsearch'and website_sessions.utm_campaign='nonbrand' 
then orders.order_id else null end)/count(distinct website_sessions.website_session_id) as bsearch_nonbrand__conv_rt,
       count(distinct case when website_sessions.utm_campaign='brand' 
then orders.order_id else null end)/count(distinct website_sessions.website_session_id) as brand_search__conv_rt,
       count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is not null 
then orders.order_id else null end)/count(distinct website_sessions.website_session_id) as organic_type_in__conv_rt,      
       count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is null
then orders.order_id else null end)/count(distinct website_sessions.website_session_id) as direct_type_in__conv_rt
       from website_sessions left join orders 
            on website_sessions.website_session_id=orders.website_session_id
group by 1,2;	

select distinct pageview_url from website_pageviews;


DAP303 - asm1 - Cau5
select year(website_pageviews.created_at) as yr,
       month(website_pageviews.created_at) as mo,
sum(case when website_pageviews.pageview_url='/the-original-mr-fuzzy' then orders.price_usd else null end) 
    as fuzzy_rev,
sum(case when website_pageviews.pageview_url='/the-original-mr-fuzzy' then (orders.price_usd-orders.cogs_usd)
 else null end) as fuzzy_marg,    
sum(case when website_pageviews.pageview_url='/the-forever-love-bear' then orders.price_usd else null end) 
    as lovebear_rev,
sum(case when website_pageviews.pageview_url='/the-forever-love-bear' then (orders.price_usd-orders.cogs_usd)
 else null end) as lovebear_marg,
 sum(case when website_pageviews.pageview_url='/the-birthday-sugar-panda' then orders.price_usd else null end) 
    as panda_rev,
sum(case when website_pageviews.pageview_url='/the-birthday-sugar-panda' then (orders.price_usd-orders.cogs_usd)
 else null end) as panda_marg,
 sum(case when website_pageviews.pageview_url='/the-hudson-river-mini-bear' then orders.price_usd else null end) 
    as minibear_rev,
sum(case when website_pageviews.pageview_url='/the-hudson-river-mini-bear' then (orders.price_usd-orders.cogs_usd)
 else null end) as minibear_marg,
sum(orders.price_usd) as total_revenue,
sum(orders.price_usd-orders.cogs_usd) as total_margin
from website_pageviews left join orders on website_pageviews.website_session_id=orders.website_session_id 
and website_pageviews.pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear',
                                       '/the-birthday-sugar-panda','/the-hudson-river-mini-bear')
group by 1,2;


DAP303 - asm1 - Cau6
create temporary table table10
select  year(created_at) as yr, 
        month(created_at) as mo, 
	    website_session_id,
        website_pageview_id
from website_pageviews where pageview_url='/products'
group by 1,2,3,4;       
       
select * from table10;       
       
create temporary table table11
select table10.yr, table10.mo, 
       table10.website_session_id,
       min(website_pageviews.website_pageview_id) as min_next_pageview_id
from table10 left join website_pageviews 
on table10.website_session_id=website_pageviews.website_session_id
and  website_pageviews.website_pageview_id > table10.website_pageview_id
group by 1,2,3;      
       
select * from table11;        
       
create temporary table table13
select table11.yr, table11.mo, table11.website_session_id, table11.min_next_pageview_id,
       orders.order_id
from table11 left join orders on table11.website_session_id=orders.website_session_id;       

select * from table13;
    
      
       
 create temporary table table14
 select yr, mo,
        count(distinct website_session_id) as sessions_to_product_page,
        count(distinct case when min_next_pageview_id is not null then website_session_id else null end)
              as click_to_next,
        count(distinct case when min_next_pageview_id is not null then website_session_id else null end)/
             count(distinct website_session_id) as clickthrough_rt,
        count(distinct case when order_id is not null then website_session_id else null end) as orders,
        count(distinct case when order_id is not null then website_session_id else null end)/
             count(distinct website_session_id) as product_to_order_rt     
from table13 group by 1,2;             
       
select * from table14;       
       
select distinct product_id from order_items;


DAP303 - asm1 - Cau7
select orders.primary_product_id,
       count(distinct orders.order_id) as total_orders,
count(distinct case when order_items.product_id=1 then orders.order_id else null end) as _xsold_p1,
count(distinct case when order_items.product_id=2 then orders.order_id else null end) as _xsold_p2,
count(distinct case when order_items.product_id=3 then orders.order_id else null end) as _xsold_p3,
count(distinct case when order_items.product_id=4 then orders.order_id else null end) as _xsold_p4,  
count(distinct case when order_items.product_id=1 then orders.order_id else null end)/
      count(distinct orders.order_id) as p1_xsold_rt,
count(distinct case when order_items.product_id=2 then orders.order_id else null end)/
      count(distinct orders.order_id) as p2_xsold_rt,
count(distinct case when order_items.product_id=3 then orders.order_id else null end)/
      count(distinct orders.order_id) as p3_xsold_rt,
count(distinct case when order_items.product_id=4 then orders.order_id else null end)/
      count(distinct orders.order_id) as p4_xsold_rt    
from orders left join order_items on orders.order_id=order_items.order_id
   and order_items.is_primary_item = 0 and orders.created_at > '2014-12-05'
group by 1;   
   









