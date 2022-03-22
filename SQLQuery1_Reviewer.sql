select *
from [G12.Review]

--change the data type of G12.reviewer partly
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrId CHAR(10) NOT NULL;
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrName VARCHAR(50);
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrDate DATE;
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrText VARCHAR(8000);
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrStar integer;
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrSource VARCHAR(20);
ALTER TABLE [G12.Reviewer]
ALTER COLUMN revrExperience_Positive_or_Negative CHAR(2);
ALTER TABLE [G12.Reviewer]
ALTER COLUMN restId CHAR(10);

ALTER TABLE [G12.Reviewer] ADD FOREIGN KEY (restId) REFERENCES [G12.restaurant](restId)

--change the data type of G12.review partly
ALTER TABLE [G12.Review]
ALTER COLUMN commentFocus VARCHAR(50);

ALTER TABLE [G12.Review] ADD FOREIGN KEY (revrId) REFERENCES [G12.Reviewer](revrId)

--Which restaurant has the most complete features and where is the location?
SELECT r.restName, CONCAT(r.restStreet, ' ', r.restState) as 'Location'
FROM [G12.Restaurant] r,
(SELECT f.restId
FROM [G12.Features] f
WHERE f.feaReservation = 'Y'
and f.feaDeliver = 'Y'
and f.feaTakeOut = 'Y') a1
WHERE r.restId = a1.restId

-- What are the restaurant names and corresponding cuisine types in order of restaurant names that received 1 star reviews? 
SELECT r.restName, c.cuisType, e.revrStar
FROM [G12.Restaurant] r,  [G12.Cuisine] c, [G12.Reviewer] e
WHERE r.restId = c.restId AND e.restName = r.restName
GROUP BY r.restName, c.cuisType, e.revrStar
HAVING e.revrStar = 1
ORDER BY (r.restName)

-- Find the number of reviews per each restaurant in alphabetical order of restaurant name
SELECT r.restName, COUNT(e.revrId) AS 'Number of reviews'
FROM [G12.Restaurant] r, [G12.Reviewer] e
WHERE r .restName = e.restName
GROUP BY r.restName
ORDER BY r.restName

--How many negative/positive reviews each restaurant received? And what about their rate?
SELECT r.restName, COUNT(r.revrExperience_Positive_or_Negative ) 'Number of
Comments',
c1.Pos 'Number of Positive',ROUND(CAST(c1.Pos AS FLOAT)/COUNT
(r.revrExperience_Positive_or_Negative ),2)'Positive Rate', c1.Neg
'Number of Negetive',
ROUND(CAST(c1.Neg AS FLOAT) /COUNT
(r.revrExperience_Positive_or_Negative ),2) 'Negative Rate'
FROM [G12.Reviewer] r,
(SELECT n.restName, n.Neg, p.Pos
FROM
(SELECT restName, COUNT(revrExperience_Positive_or_Negative ) 'Neg'
FROM [G12.Reviewer]
WHERE revrExperience_Positive_or_Negative = 'N'
GROUP BY restName) n,
(SELECT restName, COUNT(revrExperience_Positive_or_Negative ) 'Pos'
FROM [G12.Reviewer]
WHERE revrExperience_Positive_or_Negative = 'P'
GROUP BY restName) p
WHERE n.restName=p.restName) c1
WHERE r.restName = c1.restName
GROUP BY r.restName, c1.Pos,c1.Neg 

--What the average star rate of each restaurant
SELECT r.restName,AVG(r.revrStar) 'avgRevrStar'
FROM [G12.Reviewer] r
GROUP BY r.restName 