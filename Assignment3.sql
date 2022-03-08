CREATE TABLE Assignment_3(
	Visitor_ID int NOT NULL PRIMARY KEY,
	Adv_Type VARCHAR(50) NOT NULL,
	[Action] VARCHAR(50) NOT NULL,
);


INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (1,N'A',N'Left')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (2, N'A',N'Order')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (3, N'B',N'Left')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (4, N'A',N'Order')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (5, N'A',N'Review')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (6, N'A',N'Left')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (7, N'B',N'Left')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (8, N'B',N'Order')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (9, N'B',N'Review')
INSERT [dbo].[Assignment_3] ([Visitor_ID],[Adv_Type],[Action]) VALUES (10, N'A',N'Review')



SELECT *
FROM [dbo].[Assignment_3]


SELECT Adv_Type, CAST(ROUND((COUNT(CASE WHEN Action='ORDER' THEN 1.0 END)/(COUNT(Action)*1.0)),2) AS numeric(12,2))  AS 'Conversion_Rate'
FROM [dbo].[Assignment_3]
GROUP BY Adv_Type