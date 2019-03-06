--Outer Joins Exercise
USE [A01-School]
GO

--1. Select All position descriptions and the staff ID's that are in those positions
SELECT  PositionDescription, StaffID
FROM    Position P -- Start with the Position table, because I want ALL position descriptions...
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means the entire "row", or "all the columns".
--      Which gives the correct result in this question?
SELECT  PositionDescription,
        COUNT(StaffID) AS 'Number of Staff'
FROM    Position P
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription
-- but -- The following version gives the WRONG results, so just DON'T USE *  !
SELECT PositionDescription, 
       Count(*) -- this is counting the WHOLE row (not just the Staff info)
FROM   Position P
    LEFT OUTER JOIN Staff S
        ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        AVG(Mark) AS 'Average'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--4. Select the highest and lowest mark for each student. 
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        MAX(Mark) AS 'Highest',
		MIN(Mark) 'Lowest'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--5. How many students are in each club? Display club name and count.
-- TODO: Student Answer Here...
SELECT  ClubName,
        COUNT(StudentID) AS 'Number of students'
FROM    Club C
    LEFT OUTER JOIN Activity A
        ON C.ClubId = A.ClubId
GROUP BY ClubName

--6. How many times has each course been offered? Display the CourseId and CourseName along with the number of times it has been offered
-- HINT: Run the following to add some more rows in your Course table.
INSERT INTO Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
VALUES  ('DMIT115', 'Visual SQL', 60, 12, 500),
        ('DMIT175', 'Database Programming', 60, 12, 500),
        ('DMIT228', 'Advanced Application Development', 60, 12, 500),
        ('DMIT215', 'Database Administration', 60, 12, 500)
--TODO: Student answer here
SELECT  C.CourseId AS 'Course Id',
        CourseName AS 'Course Name',
        COUNT(R.CourseId) AS 'Offered Times'
FROM    Course C
    LEFT OUTER JOIN Registration R
    ON C.CourseId = R.CourseId
GROUP BY C.CourseId, CourseName

--7. How many courses have each of the staff taught? Display the full name and the count
-- TODO: Answer here
SELECT  FirstName + ' ' + LastName AS 'Staff Name',
        COUNT(CourseId) AS 'Courses taught'
FROM    Staff S
    LEFT OUTER JOIN Registration R
        ON S.StaffID = R.StaffID
GROUP BY FirstName, LastName

--8. How many second-year courses have the staff taught? Include all the staff and their job position.
-- A second year couse is one where the number portion of the CourseId starts with a '2'
SELECT  FirstName + ' ' + LastName AS 'Staff Name',
        PositionDescription AS 'Job Position',
        COUNT(CourseId) AS '2nd Year Courses'
FROM    Position P
    LEFT OUTER JOIN Staff S
        ON P.PositionID = S.PositionID
    LEFT OUTER JOIN Registration R
        ON S.StaffID = R.StaffId
WHERE   CourseId LIKE 'DMIT2%'
GROUP BY FirstName, LastName, PositionDescription

--9. What is the average payment amount made by each student? Included all the students, and display student's full names
SELECT  FirstName + ' ' + LastName AS 'Student Name',
        AVG(Amount) AS 'Avergage Payments'
FROM    Student S
    LEFT OUTER JOIN Payment P
        ON S.StudentID = P.StudentID
GROUP BY FirstName, LastName

--10. Display the names of all students who have not made a payment.

SELECT FirstName + ' ' + LastName AS 'Students that have not paid'
FROM   Student S
    LEFT OUTER JOIN Payment P
        ON S.StudentID = P.StudentID
GROUP BY FirstName, LastName
HAVING COUNT(Amount) <= 0