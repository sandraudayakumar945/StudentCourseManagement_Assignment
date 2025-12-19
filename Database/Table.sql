USE [StudentCourseDB]
GO

/****** Object:  Table [dbo].[Courses]    Script Date: 18-12-2025 16:14:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Courses](
	[CourseId] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[CourseCode] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CourseCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO









USE [StudentCourseDB]
GO

/****** Object:  Table [dbo].[StudentCourseMapping]    Script Date: 18-12-2025 16:16:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StudentCourseMapping](
	[MappingId] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StudentCourseMapping] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[StudentCourseMapping] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[StudentCourseMapping]  WITH CHECK ADD  CONSTRAINT [FK_Course] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([CourseId])
GO

ALTER TABLE [dbo].[StudentCourseMapping] CHECK CONSTRAINT [FK_Course]
GO

ALTER TABLE [dbo].[StudentCourseMapping]  WITH CHECK ADD  CONSTRAINT [FK_Student] FOREIGN KEY([StudentId])
REFERENCES [dbo].[Students] ([StudentId])
GO

ALTER TABLE [dbo].[StudentCourseMapping] CHECK CONSTRAINT [FK_Student]
GO










USE [StudentCourseDB]
GO

/****** Object:  Table [dbo].[Students]    Script Date: 18-12-2025 16:17:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Students](
	[StudentId] [int] IDENTITY(1,1) NOT NULL,
	[StudentName] [nvarchar](100) NOT NULL,
	[PhoneNumber] [varchar](10) NOT NULL,
	[EmailId] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Students_Phone] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO


