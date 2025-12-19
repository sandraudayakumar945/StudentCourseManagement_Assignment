USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_CheckDuplicateMapping]    Script Date: 18-12-2025 16:24:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_CheckDuplicateMapping]
    @StudentId INT,
    @CourseId INT
AS
BEGIN
    SELECT COUNT(*) AS DuplicateCount
    FROM StudentCourseMapping
    WHERE StudentId = @StudentId 
      AND CourseId = @CourseId
      AND IsActive = 1;
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_CheckStudentMapped]    Script Date: 18-12-2025 16:25:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_CheckStudentMapped]
    @StudentId INT
AS
BEGIN
    SELECT COUNT(*) AS MappingCount
    FROM StudentCourseMapping
    WHERE StudentId = @StudentId AND IsActive = 1;
END
GO





USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetActiveCourses]    Script Date: 18-12-2025 16:26:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetActiveCourses]
AS
BEGIN
    SELECT * FROM Courses WHERE IsActive = 1;
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetActiveMappings]    Script Date: 18-12-2025 16:26:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetActiveMappings]
AS
BEGIN
    SELECT 
        s.StudentName,
        c.CourseName,
        c.CourseCode,
        scm.MappingId
    FROM StudentCourseMapping scm
    JOIN Students s ON scm.StudentId = s.StudentId
    JOIN Courses c ON scm.CourseId = c.CourseId
    WHERE scm.IsActive = 1;
END
GO







USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetActiveStudents]    Script Date: 18-12-2025 16:27:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetActiveStudents]
    @SearchText VARCHAR(100) = ''
AS
BEGIN
    SELECT
        StudentId,
        StudentName,
        PhoneNumber,
        EmailId,
        IsActive
    FROM Students
    WHERE IsActive = 1
      AND (
           StudentName LIKE '%' + @SearchText + '%'
        OR PhoneNumber LIKE '%' + @SearchText + '%'
        OR EmailId LIKE '%' + @SearchText + '%'
      )
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetAllActiveStudents]    Script Date: 18-12-2025 16:27:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetAllActiveStudents]
AS
BEGIN
    SELECT StudentId, StudentName, PhoneNumber, EmailId
    FROM Students
    WHERE IsActive = 1
END
GO







USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetCourses]    Script Date: 18-12-2025 16:28:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetCourses]
    @SearchText VARCHAR(50)
AS
BEGIN
    SELECT CourseId, CourseName
    FROM Courses
    WHERE CourseName LIKE '%' + @SearchText + '%'
END
GO







USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetStudentCourseMappings]    Script Date: 18-12-2025 16:29:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_GetStudentCourseMappings]
AS
BEGIN
    SELECT
        scm.MappingId,
        s.StudentName,
        c.CourseName,
        c.CourseCode
    FROM StudentCourseMapping scm
    INNER JOIN Students s ON scm.StudentId = s.StudentId
    INNER JOIN Courses c ON scm.CourseId = c.CourseId
    WHERE scm.IsActive = 1
END
GO







USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_InsertCourse]    Script Date: 18-12-2025 16:29:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_InsertCourse]
    @CourseName NVARCHAR(100),
    @CourseCode NVARCHAR(20)
AS
BEGIN
    INSERT INTO Courses (CourseName, CourseCode)
    VALUES (@CourseName, @CourseCode);
END
GO








USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_InsertStudent]    Script Date: 18-12-2025 16:30:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[sp_InsertStudent]
    @StudentName NVARCHAR(100),
    @PhoneNumber VARCHAR(10),
    @EmailId NVARCHAR(100)
AS
BEGIN
    -- If same phone exists but inactive
    IF EXISTS (
        SELECT 1 FROM Students
        WHERE PhoneNumber = @PhoneNumber
          AND IsActive = 0
    )
    BEGIN
        UPDATE Students
        SET StudentName = @StudentName,
            EmailId = @EmailId,
            IsActive = 1
        WHERE PhoneNumber = @PhoneNumber

        RETURN
    END

    -- If same phone exists and active → error
    IF EXISTS (
        SELECT 1 FROM Students
        WHERE PhoneNumber = @PhoneNumber
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Phone number already exists.',16,1)
        RETURN
    END

    -- Fresh insert
    INSERT INTO Students (StudentName, PhoneNumber, EmailId, IsActive)
    VALUES (@StudentName, @PhoneNumber, @EmailId, 1)
END
GO








USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_MapStudentCourse]    Script Date: 18-12-2025 16:31:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[sp_MapStudentCourse]
    @StudentId INT,
    @CourseId INT
AS
BEGIN
    -- Check duplicate active mapping
    IF EXISTS (
        SELECT 1
        FROM StudentCourseMapping
        WHERE StudentId = @StudentId
          AND CourseId = @CourseId
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Mapping already exists', 16, 1)
        RETURN
    END

    INSERT INTO StudentCourseMapping (StudentId, CourseId, IsActive)
    VALUES (@StudentId, @CourseId, 1)
END
GO









USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_SearchStudent]    Script Date: 18-12-2025 16:31:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_SearchStudent]
    @SearchText NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM Students
    WHERE IsActive = 1 AND
    (
        StudentName LIKE '%' + @SearchText + '%'
        OR PhoneNumber LIKE '%' + @SearchText + '%'
        OR EmailId LIKE '%' + @SearchText + '%'
    );
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_SoftDeleteMapping]    Script Date: 18-12-2025 16:32:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_SoftDeleteMapping]
    @MappingId INT
AS
BEGIN
    UPDATE StudentCourseMapping
    SET IsActive = 0
    WHERE MappingId = @MappingId;
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_SoftDeleteStudent]    Script Date: 18-12-2025 16:33:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 ALTER   PROCEDURE [dbo].[sp_SoftDeleteStudent]
    @StudentId INT
AS
BEGIN
    -- If student mapped to any ACTIVE course
    IF EXISTS (
        SELECT 1
        FROM StudentCourseMapping
        WHERE StudentId = @StudentId
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Cannot delete student. Student is mapped to courses.', 16, 1)
        RETURN
    END

    -- Soft delete
    UPDATE Students
    SET IsActive = 0
    WHERE StudentId = @StudentId
END
GO






USE [StudentCourseDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateStudent]    Script Date: 18-12-2025 16:33:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_UpdateStudent]
    @StudentId INT,
    @StudentName NVARCHAR(100),
    @PhoneNumber VARCHAR(10),
    @EmailId NVARCHAR(100)
AS
BEGIN
    UPDATE Students
    SET StudentName = @StudentName,
        PhoneNumber = @PhoneNumber,
        EmailId = @EmailId
    WHERE StudentId = @StudentId;
END
GO


