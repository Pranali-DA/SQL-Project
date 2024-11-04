Create Database MCT2;


select * from ev_populationdata;

CREATE TABLE EV_data (
    VIN VARCHAR(10),
    County VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(2),
    `Postal Code` VARCHAR(10),
    `Model Year` INT,
    Make VARCHAR(255),
    Model VARCHAR(255),
    `Electric Vehicle Type` VARCHAR(255),
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility` VARCHAR(255),
    `Electric Range` INT,
    `Base MSRP` DECIMAL(10, 2),
    `Legislative District` VARCHAR(255),
    `DOL Vehicle ID` INT,
    `Vehicle Location` VARCHAR(255),
    `Electric Utility` VARCHAR(255),
    `2020 Census Tract` VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/EV_data.csv'
INTO TABLE EV_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  -- Use '\n' for Unix-based systems
IGNORE 1 LINES  -- Skip the header row if your CSV file includes it
(VIN, County, City, State, `Postal Code`, `Model Year`, Make, Model, `Electric Vehicle Type`, 
 `Clean Alternative Fuel Vehicle (CAFV) Eligibility`, `Electric Range`, `Base MSRP`, 
 `Legislative District`, `DOL Vehicle ID`, `Vehicle Location`, `Electric Utility`, `2020 Census Tract`);

 select count(*) from EV_data;
select * from EV_data;

#Pranali 
select distinct count(*) from EV_data;


#1 Write a query to list all electric vehicles with their VIN (1-10), Make, and Model.
select distinct VIN, Make, Model from EV_data;
#Pranali
#2. Write a query to display all columns for electric 
#vehicles with a Model Year of 2020 or later.
select * from EV_data where `Model Year`>=2020;

#Pranali
#3Write a query to list electric vehicles manufactured by Tesla.
select * from ev_data where make = 'TESLA';
#Pranali
#4. Write a query to find all electric vehicles 
#where the Model contains the word Leaf.
select distinct* from ev_data 
where Model like "%Leaf%";
#Pranali 
#5. Write a query to count the total number
# of electric vehicles in the dataset.
select count(distinct Vin) as Total_EV_count from ev_data;

#Pranali
#6Write a query to find the average 
#Electric Range of all electric vehicles.
select Avg(`Electric Range`) 
as average_Electric_Range from ev_data;
#Pranali Rayasane
#Q7 Write a query to list the top 5 electric vehicles 
#with the highest Base MSRP, sorted in descending order.
SELECT distinct VIN, `Model Year`, Make, Model,
                `Base MSRP` FROM EV_data
		ORDER BY `Base MSRP` DESC
		LIMIT 5;

#Pranali 
 #Write a query to list all pairs of electric vehicles that have the same Make and Model Year. 
 #Include columns for VIN_1, VIN_2, Make, and Model Year.
Select E1.VIN As VIN_1, E2.VIN As VIN_2, E1.Make, E1.`Model Year`
From EV_data E1
Join EV_data E2 On E1.Make = E2.Make 
    And E1.`Model Year` = E2.`Model Year` 
    And E1.VIN < E2.VIN;


#
SELECT LEFT(ev1.VIN, 10) as VIN_1,
       LEFT(ev2.VIN, 10) as VIN_2,
       ev1.make,
       ev1.`Model Year`
FROM EV_data as ev1
JOIN EV_data as ev2
ON ev1.make = ev2.make AND ev1.`Model Year` = ev2.`Model Year`;

#Pranali rayasane
#9. Write a query to find the total number of electric vehicles for each Make. Display Make and the count of vehicles
#select 
select make, count(distinct VIN) as vehicle_count
from EV_data group by make 
order by vehicle_count DESC;
#Pranali 
#Write a query using a CASE statement to categorize electric 
#vehicles into three categories based on their Electric
SELECT VIN,
       `Electric Vehicle Type`,
       `Electric Range`,
       CASE WHEN `Electric Range` < 100 THEN 'short ranges'
           WHEN `Electric Range` BETWEEN 100 AND 200 THEN 'medium ranges'
           WHEN `Electric Range` > 200 THEN 'long ranges'
       END AS electric_range
FROM EV_data;
#Pranali 
#11.#Write a query to add a new column Model_Length to the electric 
#vehicles table that calculates the length of each Model name.
ALTER TABLE ev_data ADD COLUMN `Model Length` INT;
UPDATE ev_data SET `Model Length`=LENGTH(model); 
select * from ev_data;


ALTER TABLE ev_data
DROP COLUMN model_length;
#Pranali
 #12.#Write a query using an advanced function to find the 
 #electric vehicle with the highest Electric Range.
select distinct VIN, `Electric Vehicle Type`, `Electric Range`
from (select distinct VIN, 
           `Electric Vehicle Type`, 
           `Electric Range`,
           row_number() over (order by `Electric Range` desc) as rn
    from EV_data
) as RankedVehicles
where rn = 1;
#Pranali Rayasane
#13.Create a view named HighEndVehicles that includes 
#electric vehicles with a Base MSRP of $50,000 or higher.
create view HighEndVehicles3 as 
(select distinct VIN, Make, Model, `Electric Vehicle Type` , `Base MSRP`
from EV_data
where `Base MSRP` > 50000);

select * from HighEndVehicles2;




CREATE VIEW HighEndVehicles4 AS 
SELECT distinct* FROM ev_data WHERE `base MSRP` >=50000;
#Pranali
#14#Write a query using a window function to rank electric vehicles based on their Base MSRP within each Model Year.
Select distinct VIN, Make, Model,`model year`,`Base MSRP`, 
		RANK() OVER ( Partition by `model year` 
        order by `Base MSRP` DESC) as Ranking 
FROM EV_data;
select `Electric Vehicle Type`,
       `Base MSRP`,
       `Model Year`,
       dense_rank() over (partition by `Model Year` order by `Base MSRP` desc) as rank_electric_vehicles
from ev_data;
#Pranali
#15 . Write a query to calculate the cumulative count of 
#electric vehicles registered each year sorted by Model Year.
SELECT `Model Year`,count(*) as year_count,
	SUM(COUNT(*)) OVER (order by `model year`) as cumulative_count
FROM ev_data
group by `model year`;

#Pranali
#17 Write a query to find the county with the highest average 
#Base MSRP for electric vehicles. Use subqueries and aggregate functions to achieve this.
SELECT Distinct VIN, COUNTY, AVG_
FROM (
    SELECT DISTINCT VIN as VIN, COUNTY, AVG(`base msrp`) AS AVG_ 
    FROM EV_data 
    GROUP BY VIN, COUNTY
) AS t
ORDER BY AVG_ DESC
LIMIT 1;


#Pranali
DELIMITER //
CREATE PROCEDURE Update_msrp(IN a text, IN b INT)
BEGIN
    UPDATE evdata SET base_msrp=b WHERE `VIN(1-10)`=a;
END //
DELIMITER ;
CALL update_msrp('WBY8P6C58K',5000);
select VIN , `Base MSRP` from EV_data;








 





