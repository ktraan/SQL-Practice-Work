-- Stored Procedures (Sprocs)
-- File: C - Stored Procedures.sql

USE [A01-School]
GO

-- Take the following queries and turn them into stored procedures.

-- 1.   Selects the studentID's, CourseID and mark where the Mark is between 70 and 80
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ListStudentMarksByRange')
    DROP PROCEDURE ListStudentMarksByRange
GO
CREATE PROCEDURE ListStudentMarksByRange
    @lower int,
    @upper int
AS
SELECT  StudentID, CourseId, Mark
FROM    Registration
WHERE   Mark BETWEEN @lower AND @upper -- BETWEEN is inclusive
--      Place this in a stored procedure that has two parameters,
--      one for the upper value and one for the lower value.
--      Call the stored procedure ListStudentMarksByRange
RETURN
GO
-- Testing
-- Good Inputs
EXEC ListStudentMarksByRange 70, 80
-- Bad Inputs
EXEC ListStudentMarksByRange 80, 70
EXEC ListStudentMarksByRange 70, NULL
EXEC ListStudentMarksByRange NULL, 80
EXEC ListStudentMarksByRange NULL, NULL
EXEC ListStudentMarksByRange -5, 80
EXEC ListStudentMarksByRange 70, 101
GO

ALTER PROCEDURE ListStudentMarksByRange
    @lower int,
    @upper int
AS
    IF @lower is NULL OR @upper is NULL
        RAISERROR('Lower and Upper values are required and cannot be null', 16, 1)
    ELSE IF @lower > @upper
        RAISERROR('The lower limit cannot be larger than the upper limit', 16, 1)
    ELSE IF @lower < 0
        RAISERROR('The lower limit cannot be less than zero', 16, 1)
    ELSE IF @upper > 100
        RAISERROR('The upper limit cannot be greater than 100.', 16, 1)
    ELSE
    SELECT  StudentID, CourseId, Mark
    FROM    Registration
    WHERE   Mark BETWEEN @lower AND @upper
RETURN
GO
/* ----------------------------------------------------- */


-- 2.   Selects the Staff full names and the Course ID's they teach.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CourseInstructors')
    DROP PROCEDURE CourseInstructors
GO
CREATE PROCEDURE CourseInstructors
AS
SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
        FirstName + ' ' + LastName AS 'Staff Full Name',
        CourseId
FROM    Staff S
    INNER JOIN Registration R
        ON S.StaffID = R.StaffID
ORDER BY 'Staff Full Name', CourseId
--      Place this in a stored procedure called CourseInstructors.
RETURN
GO

EXEC CourseInstructors


/* ----------------------------------------------------- */

-- 3.   Selects the students first and last names who have last names starting with S.
SELECT  FirstName, LastName
FROM    Student
WHERE   LastName LIKE 'S%'
--      Place this in a stored procedure called FindStudentByLastName.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable;
--      Your solution should concatenate the @PartialName with the wildcard.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindStudentByLastName')
    DROP PROCEDURE FindStudentByLastName
GO
CREATE PROCEDURE FindStudentByLastName
AS
SELECT  FirstName, LastName
FROM    Student
WHERE   LastName LIKE 'S%'
RETURN
GO

ALTER PROCEDURE FindStudentByLastName
    @PartialName    varchar(100) 
AS
    SELECT  FirstName + LastName
    FROM    Student
    WHERE   LastName LIKE @PartialName + 'S%'
RETURN
GO 

EXEC FindStudentByLastName ''
GO



/* ----------------------------------------------------- */

-- 4.   Selects the CourseID's and Coursenames where the CourseName contains the word 'programming'.

SELECT  CourseId, CourseName
FROM    Course
WHERE   CourseName LIKE '%programming%'
--      Place this in a stored procedure called FindCourse.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'Find Course')
    DROP PROCEDURE FindCourse
GO
CREATE PROCEDURE FindCourse
    @PartialName    varchar(100)
AS
    SELECT  CourseId, CourseName
    FROM    Course
    WHERE   CourseName LIKE @PartialName
RETURN
GO

EXEC FindCourse 'programming'
GO


/* ----------------------------------------------------- */

-- 5.   Selects the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--      Place this in a stored procedure called MostFrequentPaymentTypes.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'MostFrequentPaymentTypes')
    DROP PROCEDURE MostFrequentPaymentTypes
GO
CREATE PROCEDURE MostFrequentPaymentTypes
AS
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
RETURN
GO

EXEC MostFrequentPaymentTypes
