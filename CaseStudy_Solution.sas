******************************;
*  ACCESS AND EXPLORE DATA   *;
******************************;

/* Define the CS library to read SAS tables in the case_study folder */
%let path=s:/workshop;
libname cs "&path/case_study";

/* Step 1 */
proc sql outobs=10;
    title "Table: CLAIMSRAW";
    select * from cs.claimsraw;

    title "Table: ENPLANEMENT2017";
    select * from cs.enplanement2017;

    title "Table: BOARDING2013_2016";
    select * from cs.Boarding2013_2016;
    title;
quit;

/* Step 2 */
title 'Column Attribute Report';
proc sql;
select  name 'Column',memname 'Table Name', type, length
	from dictionary.columns
	where libname='CS' and memname in('CLAIMSRAW', 'ENPLANEMENT2017', 'BOARDING2013_2016')
	order by Name, memname;
quit;

/* Step 3 */
proc sql number;
title "Distinct Character Values";
/*Claim_Site*/
title2 "Column: Claim_Site";
select distinct Claim_Site 
    from cs.claimsraw 
	order by Claim_Site; 

/*Disposition*/
title2 "Column: Disposition";
select distinct Disposition 	
    from cs.claimsraw 
	order by Disposition;

/*Claim_Type*/
title2 "Column: Claim_Type";
select distinct Claim_Type 
    from cs.claimsraw 
    order by Claim_Type; 
quit;

/* Step 4 */
title "Distinct Date Values";
proc sql number;
/*Date_Received*/
title2 "Column: Date_Received";
select distinct put(Date_Received, year4.) as Date_Received 
    from cs.claimsraw 
    order by Date_Received;

/*Incident_Date*/
title2 "Column: Incident_Date";
select distinct put(Incident_Date, year4.) as Incident_Date 
    from cs.claimsraw 
    order by Incident_Date;
quit;

/* Step 5*/
title "Number of Claims where Incident Date Occurred after the Date Received";
proc sql;
select count(*) 
    from cs.claimsraw 
	where Incident_Date > Date_Received;
quit;
title;

/* Step 6 */
title "Claims with Invalid Dates";
proc sql number;
select Claim_Number, Date_Received, Incident_Date 
    from cs.claimsraw 
    where Incident_Date > Date_Received;
quit;

******************************;
*        PREPARE DATA        *;
******************************;

/* Step 7 */ 

proc sql;
create table Claims_NoDup as 
select distinct * 
    from cs.claimsraw;
quit;

/* Step 8 */ 
/*Select and label the Claim_Number and Incident_Date columns. */

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 		 
       Incident_Date label="Incident Date"
    from Claims_NoDup;
quit;

/* Step 9 */
/*Fix the 65 date issues you identified earlier by replacing the year 2017 with 2018 in the Date_Received column.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
	   Incident_Date label="Incident Date",		
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.
    from Claims_NoDup;
quit;

/* Step 10 */
/*Select the Airport_Name column.
  Replace missing values in the Airport_Code column with the value Unknown.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
	    when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
		else Date_Received 
	end as Date_Received label="Date Received" format=date9.,
	Airport_Name label="Airport Name",
	coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code
    from Claims_NoDup;	
quit;

/* Step 11 */
/*Clean the Claim_Type column by extracting the first type from the value.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.,
    Airport_Name label="Airport Name",
    coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code,
	case
        when Claim_Type is null then "Unknown" 
        else scan(Claim_Type,1,"/") 
    end as Claim_Type label="Claim Type"	
    from Claims_NoDup;	
quit;

/* Step 12 */
/*Clean the Claim_Site column by replacing missing values with the value Unknown.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.,
    Airport_Name label="Airport Name",
    coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code,
    case
        when Claim_Type is null then "Unknown" 
        else scan(Claim_Type,1,"/") 
    end as Claim_Type label="Claim Type",
    coalesce(Claim_Site,"Unknown") "Claim Site" as Claim_Site
    from Claims_NoDup;	
quit;

/* Step 13*/
/*Clean the Disposition column.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.,
    Airport_Name label="Airport Name",
    coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code,
    case
        when Claim_Type is null then "Unknown" 
        else scan(Claim_Type,1,"/") 
    end as Claim_Type label="Claim Type",
    coalesce(Claim_Site,"Unknown") "Claim Site" as Claim_Site,
    case
        when Disposition is null then "Unknown" 
        when Disposition="Closed: Canceled" then "Closed:Canceled" 
        when Disposition="losed: Contractor Claim" then "Closed:Contractor Claim" 
        else Disposition 
    end as Disposition 
    from Claims_NoDup;	
quit;

/* Step 14*/
/*Select the Close_Amount column and apply the DOLLAR format.
  Select the State column and uppercase all values. 
  Select the StateName, County and City column. Proper case all values. 
  Label */

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.,
    Airport_Name label="Airport Name",
    coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code,
    case
        when Claim_Type is null then "Unknown" 
        else scan(Claim_Type,1,"/") 
    end as Claim_Type label="Claim Type",
    coalesce(Claim_Site,"Unknown") "Claim Site" as Claim_Site,
    case
        when Disposition is null then "Unknown" 
        when Disposition="Closed: Canceled" then "Closed:Canceled" 
        when Disposition="losed: Contractor Claim" then "Closed:Contractor Claim" 
        else Disposition 
    end as Disposition, 
    Close_Amount format=Dollar20.2 label="Close Amount",
    upcase(State) as State,
    propcase(StateName) as StateName label="State Name", 
    propcase(County) as County, 
	propcase(City) as City 
    from Claims_NoDup;	
quit;

/* Step 15*/
/*Remove all rows where year of Incident_Date occurs after 2017. 
  Order the results by Airport_Code, Incident_Date.*/

proc sql;
create table work.Claims_Cleaned as 
select Claim_Number label="Claim Number", 
       Incident_Date label="Incident Date",
    case
        when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday") 
        else Date_Received 
    end as Date_Received label="Date Received" format=date9.,
    Airport_Name label="Airport Name",
	coalesce(Airport_Code,"Unknown") "Airport Code" as Airport_Code,
    case
        when Claim_Type is null then "Unknown" 
        else scan(Claim_Type,1,"/") 
    end as Claim_Type label="Claim Type",
    coalesce(Claim_Site,"Unknown") "Claim Site" as Claim_Site,
    case
        when Disposition is null then "Unknown" 
        when Disposition="Closed: Canceled" then "Closed:Canceled" 
        when Disposition="losed: Contractor Claim" then "Closed:Contractor Claim" 
        else Disposition 
    end as Disposition, 
    Close_Amount format=Dollar20.2 label="Close Amount",
    upcase(State) as State,
    propcase(StateName) as StateName label="State Name", 
    propcase(County) as County, 
	propcase(City) as City 
    from Claims_NoDup
    where year(Incident_Date) between 2013 and 2017
	order by Airport_Code, Incident_Date;
quit;

/* Step 16*/
/*Use the work.Claims_Cleaned table to create a view named TotalClaims 
to count the number of claims for each value of Airport_Code and Year*/				

proc sql;
create view TotalClaims as
select Airport_Code, Airport_Name, City, State,
       Year(Incident_date) as Year, 
       count(*) as TotalClaims 
    from work.claims_cleaned 
	group by Airport_Code, Airport_Name, City, State, calculated Year
	order by Airport_Code,Year; select * from TotalClaims;
quit;

/* Step 17*/
/*Create a view named TotalEnplanements by using the OUTER UNION set operator to 
concatenate the enplanement2017 and boarding2013_2016 tables.*/

proc sql;
create view TotalEnplanements as 
select LocID, Enplanement,input(Year,4.) as Year 
    from cs.enplanement2017 
    outer union corr 
    select LocID, Boarding as Enplanement, Year 
        from cs.boarding2013_2016 
        order by Year, LocID;
quit;

/* Step 18*/
/*Create a table named work.ClaimsByAirport by joining the 
TotalClaims and TotalEnplanements views.*/

proc sql; 
create table ClaimsByAirport as 
select t.Airport_Code, t.Airport_Name, t.City, t.State, 
	   t.Year, t.TotalClaims, e.Enplanement, 
	   TotalClaims/Enplanement as PctClaims format=percent10.4 
	from TotalClaims as t inner join TotalEnplanements as e 
	on t.Airport_Code = e.LocID and t.Year = e.Year 
	order by Airport_Code, Year;
quit;

title;


******************************;
* ANALYZE AND REPORT ON DATA *;
******************************;

/* Step 19 */
proc sql;
select sum(enplanement) as SumEnplanements format=comma14.
    from totalenplanements;
quit;

/* Step 20 */
proc sql;
select sum(TotalClaims) as SumClaims format=comma6.
    from totalclaims;
quit;

/* Step 21 */
proc sql;
select avg(Date_received-Incident_Date) as AvgDays format=4.1
    from claims_cleaned;
quit;

/* Step 22 */
proc sql;
select count(Airport_Code) as UnknownAirports
    from claims_cleaned
    where Airport_Code="Unknown";
quit;

/* Step 23 */
proc sql;
select Claim_Type, count(*) as Claims format=comma10.
    from claims_cleaned
    group by Claim_Type
    order by Claims desc;
quit;

/* Step 24 */
proc sql;
select Disposition, count(*) as Claims format=comma10.
    from claims_cleaned
    where Disposition like '%Closed%'
    group by Disposition;
quit;

/* Step 25 */
proc sql;
select Airport_Code, Airport_Name, Year, Enplanement, PctClaims
    from claimsByAirport
    where enplanement > 10000000
    order by PctClaims desc;
quit;
