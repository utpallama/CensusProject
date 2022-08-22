

Select *
From projectCensus.dbo.Data1 

Select *
From projectCensus.dbo.Data2


-- (1) The number of rows in the dataset
Select count(*) 
From projectCensus.dbo.Data1 

Select count(*) 
From projectCensus.dbo.Data2


-- (2) Find State Jharkhand and bihar 
Select State
From projectCensus.dbo.Data1 
Where State in ('Jharkhand' , 'Bihar')


-- (3) Population of India
Select sum(Population) as Population
From projectCensus.dbo.Data2 


-- (4) Average growth of India
Select avg(Growth)*100 as avg_growth 
From projectCensus.dbo.Data1 


-- (5) Average growth of India by State
Select State, avg(Growth)*100 as avg_growth
From projectCensus.dbo.Data1 
Group by State


-- (6) Average sex Ratio
Select State, round(avg(sex_ratio),0) as avg_sex
From projectCensus.dbo.Data1 
Group by State
Order by avg_sex desc;


-- (7) Average literacy rate that is greater than 90
Select State, round(avg(Literacy),0) as avg_literacy
From projectCensus.dbo.Data1 
Group by State
Having round(avg(Literacy),0) > 90
Order by avg_literacy desc;


-- (8) Top 3 state showing highest growth ratio
Select top 3 State, avg(Growth)*100 as avg_growth
From projectCensus.dbo.Data1 
Group by State
Order by avg_growth desc;


-- (9) Bottom 3 state showing lowest sex ratio
Select top 3 State, round(avg(sex_ratio),0) as avg_sex
From projectCensus.dbo.Data1 
Group by State
Order by avg_sex asc;


-- (10) Top and Bottom 3 states in literacy state. Created a table identical to step (7), but in this case our colomun name is 'topstate'
-- drop table = Deletes the table from the database. Lets us run the entire code again with Create Table
drop table if exists #topstates
Create Table #topstates
( state nvarchar(255),
  topstate float

)

Insert into #topstates
Select State, round(avg(Literacy),0) as avg_literacy
From projectCensus.dbo.Data1 
Group by State
Order by avg_literacy desc;

Select top 3 * from #topstates
Order by #topstates.topstate desc


-- (10.1) 
drop table if exists #Bottomstates
Create Table #Bottomstates
( state nvarchar(255),
  bottomstate float

)

Insert into #Bottomstates
Select State, round(avg(Literacy),0) as avg_literacy
From projectCensus.dbo.Data1 
Group by State
Order by avg_literacy desc;

Select top 3 * from #Bottomstates
Order by #Bottomstates.bottomstate asc


-- (10.2) Combine step (10) and (10.1) in a single table to get the Top and Bottom 3 states for the literacy rate
-- Using union operator to combine
Select * 
From (
Select top 3 * from #topstates
Order by #topstates.topstate desc) a

union

Select * 
From (
Select top 3 * from #Bottomstates
Order by #Bottomstates.bottomstate asc) b



-- (11) Filter out states starting with letter a
Select distinct state
From projectCensus.dbo.Data1 
Where lower(state) like 'a%' or lower(state) like 'b%'


-- (12) Filter out states ending with letter d
Select distinct state
From projectCensus.dbo.Data1 
Where lower(state) like '%d'


--- (13) Joining both Original tables using District coloumn from both
Select a.District, a.State, a.Sex_Ratio, b.Population
From projectCensus.dbo.Data1 a
inner join projectCensus.dbo.Data2 b 
on a.district=b.district


--- (13.1) Total males and females
Select c.District, c.state, round(c.Population/(sex_ratio+1),0) as males, round((c.Population*Sex_Ratio)/(c.Sex_Ratio+1),0) as females From
(Select a.District, a.State, a.Sex_Ratio/1000 as Sex_Ratio, b.Population
From projectCensus.dbo.Data1 a
inner join projectCensus.dbo.Data2 b 
on a.district=b.district) c


