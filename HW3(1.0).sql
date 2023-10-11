alter table merchants
add primary key(mid);

alter table products
add primary key(pid);

alter table sell
add foreign key(mid) references merchants(mid);
alter table sell
add foreign key(pid) references products(pid);

alter table orders
add primary key(oid);

alter table contain 
add foreign key(oid) references orders(oid);
alter table contain
add foreign key(pid) references products(pid);

alter table customers
add primary key(cid);

alter table place
add foreign key(cid) references customers(cid);
alter table place
add foreign key(oid) references orders(oid);

alter table products
add constraint pname
check (products.name = "Printer" or products.name = "Ethernet Adapter" or products.name = "Desktop" or products.name = "Hard Drive" or products.name = "Laptop" or products.name = "Router" or products.name = "Network Card" or products.name = "Super Drive" or products.name = "Monitor");

alter table products
add constraint pcategory
check (products.category = "Peripheral" or products.category = "Networking" or products.category = "Computer");

alter table sell
add constraint sprice
check (sell.price >= 0 and sell.price <= 100000);

alter table sell
add constraint squantity
check (sell.quantity_available >= 0 and sell.quantity_available <= 1000);

alter table orders
add constraint smethod
check (orders.shipping_method = "UPS" or orders.shipping_method = "FedEx" or orders.shipping_method = "USPS");

alter table orders
add constraint scost
check (orders.shipping_cost >= 0 and orders.shipping_cost <= 500);


#1:
select products.name as "Product", merchants.name as "Seller"
from sell inner join products using (pid) inner join merchants using (mid)
where sell.quantity_available = 0;

#2:
select products.name as "Products", products.description as "Description"
from products
where not exists
				(select *
                from sell
                where sell.pid = products.pid
                );
 
#3:
Select count(distinct cid)
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid)
where products.description like "%SATA%" and not exists (select distinct cid
														from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid)
														where products.name = "Router"
                                                        );

#4:
Update sell inner join products using (pid) inner join merchants using (mid)
Set sell.price = sell.price * .8
where merchants.name = "HP" and products.category = "Networking";

select *
from sell inner join products using (pid) inner join merchants using (mid)
where merchants.name = "HP" and products.category = "Networking";

#5:
select products.name, sell.price
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
where customers.fullname = "Uriel Whitney" and merchants.name = "Acer";

#6:
Create Table Sales as

Select merchants.name, sum(sell.price) as "Sales", "2011" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2011%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2012" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2012%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2013" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2013%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2014" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2014%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2015" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2015%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2016" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2016%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2017" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2017%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2018" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2018%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2019" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2019%"
Group by mid

Union

Select merchants.name, sum(sell.price) as "Sales", "2020" as "Year"
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
Where place.order_date like "%2020%"
Group by mid;

Select *
from Sales
Order by name;

#7:
Select name, Sales, Year
from Sales
where Sales >= (Select Max(Sales)
				from Sales
                );

#8:
Select shipping_method, avg(shipping_cost)
from orders
group by shipping_method
Having avg(shipping_cost) <= (Select avg(shipping_cost)
							  from orders
							  );
                              
#9:
Create Table Categories as

Select merchants.name, products.category, sum(sell.price) as total
from orders inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
group by mid, products.category;


Select name, category, total
from Categories
Where name = "Acer" and total >= (Select Max(total)
								  from Categories
                                  Where name = "Acer"
								  )

Union

Select name, category, total
from Categories
Where name = "Apple" and total >= (Select Max(total)
								  from Categories
                                  Where name = "Apple"
								  )
                                  
Union

Select name, category, total
from Categories
Where name = "HP" and total >= (Select Max(total)
								from Categories
                                Where name = "HP"
								)

Union

Select name, category, total
from Categories
Where name = "Dell" and total >= (Select Max(total)
								  from Categories
                                  Where name = "Dell"
								  )

Union

Select name, category, total
from Categories
Where name = "Lenovo" and total >= (Select Max(total)
								   from Categories
                                   where name = "Lenovo"
								   );
                                   
#10:
Create Table Customer_Sales as

Select merchants.name as Merchant, customers.fullname as Customer, sum(sell.price) as Total
from customers inner join place using (cid) inner join orders using (oid) inner join contain using (oid) inner join products using (pid) inner join sell using (pid) inner join merchants using (mid)
group by mid, cid;

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Acer" and Total >= (Select max(Total)
									  from Customer_Sales
									  Where Merchant = "Acer"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Acer" and Total <= (Select min(Total)
									  from Customer_Sales
									  Where Merchant = "Acer"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Apple" and Total >= (Select max(Total)
									  from Customer_Sales
									  Where Merchant = "Apple"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Apple" and Total <= (Select min(Total)
									  from Customer_Sales
									  Where Merchant = "Apple"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "HP" and Total >= (Select max(Total)
									  from Customer_Sales
									  Where Merchant = "HP"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "HP" and Total <= (Select min(Total)
									  from Customer_Sales
									  Where Merchant = "HP"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Dell" and Total >= (Select max(Total)
									  from Customer_Sales
									  Where Merchant = "Dell"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Dell" and Total <= (Select min(Total)
									  from Customer_Sales
									  Where Merchant = "Dell"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Lenovo" and Total >= (Select max(Total)
									  from Customer_Sales
									  Where Merchant = "Lenovo"
									  )

Union

Select Merchant, Customer, Total
from Customer_Sales
where Merchant = "Lenovo" and Total <= (Select min(Total)
									  from Customer_Sales
									  Where Merchant = "Lenovo"
									  );





