select *from job_data order by ds;

-- Inserting more records
Insert into job_data values('2020-11-25', 24, 1001, 'skip', 'English', 155, 'A'); 
Insert into job_data values('2020-11-25', 26, 1003, 'skip', 'English', 28, 'B'); 
Insert into job_data values('2020-11-25', 27, 1003, 'transfer', 'Hindi', 30, 'A'); 
Insert into job_data values('2020-11-25', 24, 1002, 'skip', 'Hindi', 70, 'C'); 

Insert into job_data values('2020-11-26', 21, 1002, 'decision', 'Italian', 57, 'c'); 
Insert into job_data values('2020-11-26', 27, 1005, 'skip', 'English', 80, 'A'); 
Insert into job_data values('2020-11-26', 22, 1006, 'transfer', 'Hindi', 98, 'A'); 
Insert into job_data values('2020-11-26', 20, 1001, 'skip', 'Hindi', 123, 'C'); 
Insert into job_data values('2020-11-26', 20, 1007, 'skip', 'Enlish', 128, 'B'); 

Insert into job_data values('2020-11-28', 21, 1007, 'skip', 'Enlish', 102, 'B'); 

Insert into job_data values('2020-11-30', 15, 1005, 'decision', 'Italian', 59, 'B'); 
Insert into job_data values('2020-11-30', 12, 1008, 'skip', 'English', 80, 'A'); 
Insert into job_data values('2020-11-30', 18, 1000, 'transfer', 'Hindi', 93, 'A'); 
Insert into job_data values('2020-11-30', 19, 1001, 'skip', 'Hindi', 129, 'C'); 
Insert into job_data values('2020-11-30', 14, 1003, 'transfer', 'Enlish', 228, 'B'); 

Insert into job_data values('2020-11-01', 7, 1008, 'skip', 'English', 177, 'A'); 
Insert into job_data values('2020-11-02', 9, 1009, 'skip', 'French', 232, 'A'); 
Insert into job_data values('2020-11-03', 12, 1001, 'transfer', 'English', 55, 'B'); 
Insert into job_data values('2020-11-04', 18, 1003, 'skip', 'Hindi', 145, 'A'); 
Insert into job_data values('2020-11-05', 20, 1002, 'decision', 'English', 255, 'A'); 
Insert into job_data values('2020-11-06', 2, 1000, 'skip', 'English', 159, 'A'); 
Insert into job_data values('2020-11-07', 13, 1005, 'skip', 'Hindi', 185, 'B'); 
Insert into job_data values('2020-11-08', 15, 1011, 'transfer', 'Italian', 175, 'A'); 
Insert into job_data values('2020-11-09', 12, 1013, 'transfer', 'English', 350, 'A'); 
Insert into job_data values('2020-11-10', 13, 1014, 'skip', 'Hindi', 150, 'C'); 

Insert into job_data values('2020-11-11', 32, 1011, 'decision', 'Arabic', 150, 'A'); 
Insert into job_data values('2020-11-12', 9, 1015, 'skip', 'Hindi', 150, 'C'); 
Insert into job_data values('2020-11-13', 29, 1024, 'decision', 'English', 150, 'B'); 
Insert into job_data values('2020-11-14', 21, 1004, 'skip', 'Hindi', 150, 'A'); 
Insert into job_data values('2020-11-15', 55, 1008, 'transfer', 'Hindi', 150, 'C'); 
Insert into job_data values('2020-11-16', 43, 1016, 'skip', 'English', 150, 'B'); 
Insert into job_data values('2020-11-17', 30, 1025, 'decision', 'French', 150, 'C'); 
Insert into job_data values('2020-11-18', 18, 1027, 'skip', 'Hindi', 150, 'C'); 
Insert into job_data values('2020-11-19', 22, 1019, 'skip', 'Hindi', 150, 'B'); 
Insert into job_data values('2020-11-20', 6, 1010, 'transfer', 'English', 150, 'A'); 
Insert into job_data values('2020-11-21', 9, 1014, 'skip', 'French', 150, 'C'); 
Insert into job_data values('2020-11-22', 15, 1013, 'decision', 'Persian', 150, 'C'); 
Insert into job_data values('2020-11-23', 31, 1025, 'skip', 'Hindi', 150, 'A'); 
Insert into job_data values('2020-11-24', 27, 1029, 'transfer', 'French', 150, 'C'); 

-- Questions on Case study 1

-- A) Number of jobs reviewed: Calculate the number of jobs reviewed per hour per day for November 2020?
select ds, 
count(job_id) total_jobs_reviewed, 
round(sum(time_spent)/3600, 2) time_spent_in_hour, 
count(job_id)/(sum(time_spent)/3600) approx_jobs_per_hour 
from job_data
group by ds
order by total_jobs_reviewed desc;


-- B) Throughput: Calculate 7 day rolling average of throughput?

with throughput as 
	(
    select ds, 
	count(job_id) total_jobs_reviewed, 
	round(sum(time_spent)/3600, 2) time_spent_in_hour, 
	count(job_id)/(sum(time_spent)/3600) approx_jobs_per_hour 
	from job_data
	group by ds
	order by total_jobs_reviewed desc
    )
select ds, 
avg(approx_jobs_per_hour) over(order by ds rows between 6 preceding and current row) rolling_average_7days
from throughput 
order by ds;



-- C) Percentage share of each language: Calculate the percentage share of each language in the last 30 days

select language, 
	round(count(language)*100/(select count(language) 
	from job_data 
    where ds between '2020-11-01' and '2020-11-30'), 2) percentage
from job_data 
group by language;


-- D) Duplicate rows: How will you display duplicates from the table?

select * from
	(select *, row_number() over(partition by ds, job_id, actor_id, event, language, time_spent, org order by ds) as row_no
	from job_data) x
where x.row_no <>1;

-- adding duplicate row to check-
Insert into job_data values('2020-11-23', 31, 1025, 'skip', 'Hindi', 150, 'A'); 
Insert into job_data values('2020-11-24', 27, 1029, 'transfer', 'French', 150, 'C'); 


------------------------------------------------------------------------------------


-- Case Study 2
select *from email_events;
select *from users;
SELECT * FROM events;
describe events;
alter table events modify column occurred_at datetime;


-- A) To measure the activeness of a user. Measuring if the user finds quality in a product/service.
-- Task: Calculate the weekly user engagement?

select extract(week from occurred_at) Weeks, count(event_type) engagement
from events
where event_type="engagement"
group by Weeks
order by engagement desc;



-- B) User Growth: Amount of users growing over time for a product.
-- Task: Calculate the user growth for product?

select *, 
(total_new_users - lag(total_new_users) over(order by years))*100/lag(total_new_users) over() yearly_users_growth_percentage 
from
(	
	select extract(year from activated_at) years, count(user_id) total_new_users
	from users
	group by years
	having years is not null
) x;



-- C) Weekly Retention: Calculate the weekly retention of users-sign up cohort? 	
select extract(week from created_at) weeks, count(state) retained_users
from users
where state = "active"
group by weeks
order by retained_users desc;


-- D) Weekly Engagement: Weekly Engagement: 
select device, extract(week from occurred_at) Weeks, count(event_type) engagement
from events
where event_type="engagement"
group by weeks, device
order by engagement desc;



-- E) Users engaging with the email service.
-- Your task: Calculate the email engagement metrics?

-- Calculating Open Rate (in percentage)

with counting as
(select action, count(action) count
from email_events
group by action)
SELECT ((SELECT count FROM counting WHERE action = 'email_open') / 
(SELECT count FROM counting WHERE action = 'sent_weekly_digest')) * 100 AS email_open_rate_percentage;


-- Calculating Clickthrough Rate (in percentage)
with counting as
	(
    select action, count(action) count
	from email_events
	group by action
    )
SELECT ((SELECT count FROM counting WHERE action = 'email_clickthrough') / 
(SELECT count FROM counting WHERE action = 'sent_weekly_digest')) * 100 AS email_clickthrough_rate_percentage;







