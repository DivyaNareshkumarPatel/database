select b.starttime from cd.bookings b inner join cd.members m on m.memid = b.memid where m.firstname = 'David' and m.surname = 'Farrell';

select b.starttime, f.name from cd.bookings b inner join cd.facilities f on b.facid = f.facid where b.starttime between '2012-09-21 00:00:00' and '2012-09-21 18:00:00' order by starttime;

SELECT DISTINCT rec.firstname, rec.surname
FROM cd.members mem
INNER JOIN cd.members rec ON rec.memid = mem.recommendedby
ORDER BY rec.surname, rec.firstname;

select distinct m.firstname, m.surname from cd.members m inner join cd.bookings b on m.memid = m.memid inner join cd.facilities f on b.facid = f.facid where f.name like '%Tennis%' order by m.firstname, m.surname;

select distinct m.firstname || ' ' || m.surname as member, (select n.firstname || ' ' || n.surname from cd.members n where n.memid = m.recommendedby) as recommender from cd.members m;

select v.customer_id, COUNT(v.visit_id) AS count_no_trans from Visits v left join Transactions t on v.visit_id = t.visit_id where t.transaction_id is null group by v.customer_id;

select w1.id from Weather w1 inner join Weather w2 on DATEDIFF(w1.recordDate, w2.recordDate) = 1 and w1.temperature > w2.temperature; 

select e.name, b.bonus from Employee e left join Bonus b on e.empId = b.empId where b.bonus < 1000 or b.bonus is null;

select s.student_id, s.student_name, su.subject_name, count(e.student_id) from Students s cross join Subjects su inner join Examinations e on s.student_id = e.student_id group by e.student_id, e.subject_name; 
select s.student_id, s.student_name, su.subject_name, count(e.student_id) from Students s cross join Subjects su left join Examinations e on e.student_id = s.student_id group by e.student_id, e.subject_name;

select s.student_id, s.student_name, su.subject_name, count(e.student_id)  as attended_exams from Students s cross join Subjects su left join Examinations e on s.student_id = e.student_id and su.subject_name = e.subject_name group by s.student_id, s.student_name, su.subject_name order by s.student_id, su.subject_name;

select count(student_id) from Examinations group by student_id, subject_name;

select e1.name from Employee e1 inner join Employee e2 on e1.id = e2.managerId having count(e2.managerId)>=5;
select managerId from Employee group by managerId having count(managerId)>=5;
select m1.name from Employee m1 join Employee m2 on m1.id = m2.managerId group by m1.id having count(m1.id)>=5;

select count(user_id) from confirmations group by user_id;
select s.user_id, round(ifnull(sum(c.action='confirmed')/count(s.user_id),0),2) as confirmation_rate from signups s left join confirmations c on s.user_id = c.user_id group by s.user_id;

