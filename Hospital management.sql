use [Hospital Management System]
select * from [Billing]
select * from Doctor
select * from [Medical Procedure]
select * from [Appointment]
select * from Patient

--Data Cleaning
----Creating a table DoctorD
create table doctord(doctorid int,doctorname varchar(100),specialization varchar(100),doctorcontact varchar(100));
INSERT INTO doctord(doctorid,doctorname,specialization,doctorcontact)
select * from Doctor
select* from doctord as D

--checking duplicates in doctorD
select doctorname,specialization,doctorcontact,count(*) AS DUPLICATE from doctor
GROUP BY doctorname,specialization,doctorcontact
HAVING COUNT(*)>1

SELECT DoctorName, Specialization, COUNT(*)
FROM doctord
GROUP BY DoctorName, Specialization
HAVING COUNT(*) >= 1
order by doctorname

SELECT D.DoctorName, D.Specialization, D.DoctorContact
FROM Doctor D
LEFT JOIN DoctorD DD
ON D.DoctorName = DD.DoctorName
AND D.Specialization = DD.Specialization
AND D.DoctorContact = DD.DoctorContact
WHERE DD.DoctorName IS NULL;


--deleting duplicates in doctorD
WITH DoctorDuplicates AS (
    SELECT DoctorID, ROW_NUMBER() OVER (PARTITION BY DoctorName, Specialization ORDER BY DoctorID) AS RowNum
    FROM doctord)
DELETE FROM doctord
WHERE DoctorID IN (
    SELECT DoctorID FROM DoctorDuplicates WHERE RowNum > 1);


--1 Write a SQL Query to identify the patients who have undergone Plastic surgery. Return patient id,firstname, lastname, procedureName
select P.PatientID,P.firstname,P.lastname,P.email
from Patient AS P
JOIN Appointment AS A
ON P.PatientID=A.PatientID
WHERE A.AppointmentID IN 
(SELECT AppointmentID
from [Medical Procedure] AS MP
WHERE ProcedureName = 'Plastic surgery');

--2 Write a SQL Query to calculate the number of appointments made in 2020,2021,2022,2023
SELECT YEAR(Date) AS YEAR, COUNT(AppointmentID) AS Appointments_Made
FROM Appointment
WHERE YEAR(Date) IN (2020, 2021, 2022, 2023)
GROUP BY YEAR(Date)
ORDER BY YEAR(Date) ASC;

--3 Write a SQL Query to calculate the top 5 billing items and their amount.
SELECT top 10 Items as Items,sum(amount) AS SUM
from Billing
group by Items
order by sum(amount) desc;

--4 Write a SQL Query to List all the doctors and their specializations 
select doctorid,doctorname,Specialization,DoctorContact
from doctor
group by doctorid,Specialization,DoctorName,DoctorContact

--5 Write a SQL Query to get all appointments for a specific doctor-'brynna' by doctor ID
select d.doctorid,d.doctorname,d.specialization,d.DoctorContact
from Doctor as d
join Appointment as a
on d.DoctorID=a.DoctorID
where DoctorName='Brynna';

--6 Write a SQL Query to Find total billing amount for each patient
select * from Patient
select * from Billing
select p.firstname,p.lastname,sum(b.Amount) as total_billing from Patient as p
join Billing as b
on p.PatientID=b.PatientID
group by p.firstname,p.lastname

--7 Write a SQL Query to Count the number of appointments made by each patient
SELECT * FROM Appointment 
SELECT * FROM Patient 
SELECT p.PatientID,p.firstname,p.lastname,count(a.appointmentID) as Appointments
from Patient as p
join Appointment as a 
on a.PatientID=p.PatientID
group by p.firstname,p.lastname,p.PatientID
order by p.PatientID asc;

select firstname,lastname,count(firstname),count(lastname) from patient
group by firstname,lastname

--8 Write a SQL Query to List all patients who had an appointment in the last month
SELECT p.PatientID,a.Date,p.firstname,p.lastname,p.email
FROM Patient AS P
JOIN Appointment AS A 
ON A.PatientID=A.PatientID
WHERE YEAR(DATE)=2023 --AND MONTH(DATE)=8
ORDER BY DAY(Date) ASC;

--9 Write a SQL Query to get the doctor’s name and their total number of appointments
select * from Doctor
select * from Appointment
select d.doctorname,d.specialization,count(appointmentid) as Appointments
from Appointment as a
join Doctor as d
on d.DoctorID=a.DoctorID
group by d.doctorname,d.specialization
order by Appointments DESC;

--10 Write a SQL Query to Retrieve total billing amount for each doctor based on patient appointments
select * from Doctor
select * from Appointment
select * from Billing

SELECT d.DoctorName, d.Specialization, SUM(b.Amount) AS TotalAmount
FROM Doctor AS d
JOIN Appointment AS a ON d.DoctorID = a.DoctorID
JOIN Billing AS b ON a.PatientID = b.PatientID
GROUP BY d.DoctorName, d.Specialization;

--11 Write a SQL Query to Count the number of unique medical procedures performed for each patient
select * from Patient
select * from Appointment
select * from [Medical Procedure]

select p.firstname,p.lastname,count(DISTINCT(m.procedurename)) AS ProcedureCount
from Patient as p
JOIN Appointment AS a ON p.patientid=a.patientid
JOIN [Medical Procedure] AS m ON m.AppointmentID=a.AppointmentID
group by p.firstname,p.lastname
ORDER BY ProcedureCount DESC;

--12 Write a SQL Query to get the average billing amount for patients undergoing a specific medical procedure
select * from Patient
select * from Billing
select * from Appointment
select * from [Medical Procedure]
select * from Doctor

SELECT p.FirstName, p.LastName, m.ProcedureName, AVG(b.Amount) AS Avg_Billing_Amount
FROM Patient AS p
JOIN Appointment AS a ON p.PatientID = a.PatientID
JOIN Billing AS b ON a.PatientID = b.PatientID
JOIN [Medical Procedure] AS m ON m.AppointmentID = a.AppointmentID
GROUP BY p.FirstName, p.LastName, m.ProcedureName;

--12 Write a SQL Query to get the top 5 doctors with maximum appointments
SELECT a.DoctorID, d.DoctorName,d.Specialization,COUNT(a.DoctorID) AS Total_Appointments_Taken
FROM Appointment AS a
JOIN Doctor AS d ON d.DoctorID = a.DoctorID
GROUP BY a.DoctorID, d.DoctorName,d.Specialization  
ORDER BY Total_Appointments_Taken DESC

--13 Write a SQL Query to get the top 5 Specializations for which appointments were taken
select Specialization,count(Specialization) AS Total_Count from Doctor
group by Specialization
order by Total_Count DESC

--14 To check if the Billing Amount has increased or decreased over the years
SELECT YEAR(a.Date) AS YEAR, SUM(b.Amount) AS Total
FROM Appointment as a
join Billing as b ON a.patientid=b.patientid
WHERE YEAR(Date) IN (2020, 2021, 2022, 2023)
GROUP BY YEAR(a.Date)
ORDER BY Total DESC;

--15 Write a SQL Query to find out the customers which have repeated in all the 4 years
SELECT p.PatientID, p.FirstName, p.LastName, COUNT(DISTINCT YEAR(a.Date)) AS Years_Visited
FROM Patient AS p
JOIN Appointment AS a ON a.PatientID = p.PatientID
WHERE YEAR(a.Date) IN (2020, 2021, 2022, 2023)
GROUP BY p.PatientID, p.FirstName, p.LastName
HAVING COUNT(DISTINCT YEAR(a.Date)) = 4

--16 Write a SQL Query to find out the new customers which have not been repeated in 2020,2021,2022.
SELECT p.PatientID, p.FirstName, p.LastName, COUNT(YEAR(a.Date)) AS Total_Appointments
FROM Patient AS p
JOIN Appointment AS a ON a.PatientID = p.PatientID
WHERE YEAR(a.Date) = 2023
GROUP BY p.PatientID, p.FirstName, p.LastName
HAVING COUNT(DISTINCT YEAR(a.Date)) = 1
AND p.PatientID NOT IN (
    SELECT p2.PatientID
    FROM Patient AS p2
    JOIN Appointment AS a2 ON a2.PatientID = p2.PatientID
    WHERE YEAR(a2.Date) IN (2020, 2021, 2022))
