SELECT * FROM patients

select first_name, last_name, gender from patients where gender='M';

select first_name, last_name from patients where allergies is null;

select first_name from patients where first_name like 'C%';

select first_name, last_name from patients where weight between 100 and 120;

update patients set allergies = 'NKA' where allergies is null;

select first_name ||' '|| last_name as full_name from patients;

SELECT p.first_name, p.last_name, pro.province_name from patients p inner join province_names pro on p.province_id = pro.province_id;

SELECT count(patient_id)  FROM patients WHERE birth_date >= '2010-01-01' AND birth_date <= '2010-12-31';

select first_name, last_name, height from patients order by height desc limit 1;

select * from patients where patient_id in (1, 45, 534, 879, 1000);

select count(patient_id) as total_admissions from admissions;

select * from admissions where admission_date = discharge_date;

select patient_id, count(patient_id) from admissions where patient_id = 579 group by patient_id;

SELECT DISTINCT city AS unique_cities FROM patients WHERE province_id = 'NS';

select first_name, last_name, birth_date from patients where height>160 and weight>70;

select first_name, last_name, allergies from patients where allergies is not null and city = 'Hamilton';

select first_name from patients group by first_name having count(first_name)=1;

select distinct year (birth_date) as birth_year from patients order by birth_year;

select patient_id, first_name from patients where first_name like 'S%s' and len(first_name)>=6;

select p.patient_id, p.first_name, p.last_name from patients p inner join admissions a on p.patient_id = a.patient_id where a.diagnosis = 'Dementia';

select first_name from patients order by len(first_name), first_name;

select sum(case when gender = 'M' then 1 end) as male_count, sum(case when gender = 'F' then 1 end) as female_count from patients;

select first_name, last_name, allergies from patients where allergies = 'Penicillin' or allergies = 'Morphine' order by allergies, first_name, last_name;

select patient_id, diagnosis from admissions group by patient_id, diagnosis having count(patient_id)>1;

select city, count(patient_id) as num_patients from patients group by city order by num_patients desc, city;

SELECT first_name, last_name, 'Patient' AS role FROM patients UNION all SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

SELECT allergies, COUNT(*) AS total_diagnosis FROM patients WHERE allergies IS NOT NULL GROUP BY allergies ORDER BY total_diagnosis DESC;

select first_name, last_name, birth_date from patients where birth_date between '1970-01-01' and '1979-12-31' order by birth_date;

select upper(last_name)||','||lower(first_name) as new_name_format from patients order by first_name desc;

select province_id, sum(height) as sum_height from patients group by province_id having sum_height>=7000;

select (max(weight) - min(weight)) as weight_data from patients where last_name = 'Maroni';

select day(admission_date) as day_number ,count(patient_id) as number_of_admissions from admissions group by day_number order by number_of_admissions desc;

select * from admissions where patient_id = 542 order by admission_date desc limit 1;

SELECT patient_id, attending_doctor_id, diagnosis FROM admissions WHERE (patient_id % 2 = 1 AND attending_doctor_id IN (1, 5, 19))OR (attending_doctor_id LIKE '%2%' AND LENGTH(CAST(patient_id AS TEXT)) = 3);

select d.first_name, d.last_name, count(a.attending_doctor_id) from doctors d right join admissions a on d.doctor_id = a.attending_doctor_id group by a.attending_doctor_id;

SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, MIN(a.admission_date) AS first_admission_date, MAX(a.admission_date) AS last_admission_date FROM doctors d JOIN admissions a ON d.doctor_id = a.attending_doctor_id GROUP BY d.doctor_id, d.first_name, d.last_name;

select p.province_name, count(pa.patient_id) as patient_count from province_names p right join patients pa on pa.province_id = p.province_id group by pa.province_id order by patient_count desc;

select p.first_name || ' ' || p.last_name, a.diagnosis, d.first_name || ' '|| d.last_name from admissions a left join patients p on a.patient_id = p.patient_id left join doctors d on a.attending_doctor_id = d.doctor_id;

select first_name, last_name, count(*) as num_of_duplicates from patients group by first_name, last_name having num_of_duplicates != 1;

SELECT first_name || ' ' || last_name AS full_name, ROUND(height / 30.48, 1) AS height_feet, ROUND(weight * 2.205, 0) AS weight_pounds, birth_date, CASE WHEN gender = 'M' THEN 'Male' WHEN gender = 'F' THEN 'Female' ELSE 'Other' END AS gender_full FROM patients;

select p.patient_id, p.first_name, p.last_name from patients p left join admissions a on p.patient_id = a.patient_id where a.admission_date is null;

select max(count(*)), min(count(*)), avg(count(*)) from admissions group by admission_date;

SELECT MAX(admission_count) AS max_visits, MIN(admission_count) AS min_visits, ROUND(AVG(admission_count), 2) AS average_visits FROM (SELECT COUNT(*) AS admission_count FROM admissions GROUP BY admission_date) AS daily_counts;

select p.first_name || ' ' || p.last_name, max(a.admission_date), d.first_name || ' ' || d.last_name from patients p inner join admissions a on p.patient_id = a.patient_id inner join doctors d on a.attending_doctor_id = d.doctor_id group by p.patient_id;

SELECT (weight / 10) * 10 AS weight_group, COUNT(*) AS patients_in_group FROM patients GROUP BY weight_group ORDER BY weight_group DESC;

SELECT patient_id, weight, height, CASE WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1 ELSE 0 END AS isObese FROM patients;