create database data_transformer;
use data_transformer;

create table Customers (
CustomerID int primary key ,
Firstname varchar (50),
Lastname varchar (50),
Email varchar (50),
RegistrationDate date 
);

INSERT INTO Customers (CustomerID, Firstname, Lastname, Email, RegistrationDate) values
(1, 'John', 'Doe', 'john.doe@email.com' , '2022-03-15' ),   
(2, 'Jane ', 'Smith' , 'jane.smith@email.com' ,'2021-11-02' );

create table Orders ( 
OrderID int primary key ,
CustomerID int ,
OrderDate date ,
TotalAmount decimal (10,2),
foreign key (CustomerID)  REFERENCES Customers(CustomerID)
);

insert into Orders (OrderID, CustomerID, OrderDate, TotalAmount) values
(101, 1 , '2023-07-01' , 150.50 ),
(102, 2 , '2023-07-03' , 200.75);

create TABLE Employees (
EmployeeID int primary key ,
Firstname varchar(50),
Lastname varchar (50),
Department varchar(50),
HireDate date ,
salary decimal (10,2)
);

insert into Employees (EmployeeID, Firstname , Lastname , Department, HireDate, Salary ) values
(1, 'Mark' , 'Johnson' , 'Sales' , '2020-01-15' , 50000.00 ),
(2, 'Susan' , 'Lee' , 'HR' , '2021-03-20' , 55000.00 );

select o.OrderID , o.OrderDate, o.TotalAmount, c.CustomerID, c.Firstname, c.Lastname, c.Email
from Orders o inner join Customers c on c.CustomerID = c.CustomerID order by o.OrderDate ;

select  c.CustomerID, c.Firstname, c.Lastname, c.Email , o.OrderID , o.OrderDate, o.TotalAmount
from Customers c left join Orders o on c.CustomerID = c.CustomerID order by c.CustomerID,o.OrderDate; 

select o.OrderID, o.OrderDate, o.TotalAmount, c.CustomerID, c.Firstname, c.Lastname, c.Email
from Customers c right join Orders o on c.CustomerID = c.CustomerID order by c.CustomerID,o.OrderDate; 

select  c.CustomerID, c.Firstname, c.Lastname, c.Email , o.OrderID , o.OrderDate, o.TotalAmount
from Customers c left join Orders o on c.CustomerID = c.CustomerID  
union
select c.CustomerID, c.Firstname, c.Lastname, c.Email , o.OrderID, o.OrderDate, o.TotalAmount
from Customers c right join Orders o on c.CustomerID = c.CustomerID order by c.CustomerID,o.OrderDate;

select distinct c.CustomerID, c.Firstname , c.Lastname 
from Customers c
join Orders o on c.CustomerID = c.CustomerID 
where o.TotalAmount > (select AVG(TotalAmount) from Orders );

select EmployeeID, FirstName, LastName, Department, Salary
from Employees
where Salary > (select avg(Salary) from  Employees);

select OrderId,OrderDate,
year(OrderDate) AS OrderYear, month(OrderDate) AS Ordermonth from Orders;

select OrderID, OrderDate,
datediff(current_date , OrderDate ) as DayDifference from Orders ;

select OrderID, Date_format(OrderDate,'%d,%b,%Y' ) As FormatOrderdate 
from Orders; 

Select CustomerID , concat(Firstname,' ' , Lastname) AS FullName
from Customers;

select CustomerID, Firstname , replace(Firstname,'John','Jonathon') As Replace_Firstname 
from Customers ;

select EmployeeID,
upper(Firstname) As Firstname_upperCase,
lower(Lastname) AS Lastname_lowerCase
from Employees;

SELECT CustomerID,
CONCAT('>', Email, '<') AS RawEmail, TRIM(Email) AS TrimmedEmail,
CONCAT('>', TRIM(Email), '<') AS TrimmedEmailBrackets FROM Customers;

select OrderID, CustomerID, OrderDate, TotalAmount,
sum(TotalAmount) over (order by OrderDate,OrderID rows between unbounded preceding and current row ) as RunningTotal
 from Orders  order by OrderDate,OrderID ;


select OrderID,CustomerID,OrderDAte, TotalAmount,
rank() over (order by TotalAmount desc ) as AmountRank from Orders order by AmountRank ;

select OrderID,TotalAmount ,
case
	when TotalAmount > 1000 then concat('%10 (', Format (TotalAmount * 0.10,2),')')
    when TotalAmount > 500 then concat('%5 (', Format (TotalAmount * 0.05,2),')')
    else '%0'
    
    end AS DiscountApplied,
    
    case
		when TotalAmount > 1000 THEN TotalAmount * 0.90
		when TotalAmount > 500 THEN TotalAmount * 0.95
		else TotalAmount
       end AS AmountAfterDiscount
from Orders
order by TotalAmount desc;

select EmployeeID ,Firstname,Lastname , Salary ,
case 
when Salary >= 55000 then 'High'
when Salary >= 30000 then 'Medium'
else 'Low'
end as SalaryCategory from Employees order by SalaryCategory ;