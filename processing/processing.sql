USE IMF_DB;
GO
---
SELECT *
FROM [WEO_Data]
GO
 
-- 1. Process indicators table:
-- a. Remove "(....)"
CREATE OR ALTER VIEW [v_indicators_RemoveParentheses] as
SELECT
    [id] as [Subject Code],
    trim(
        left([title], charindex('(', [title]) - 1)
        ) as [Subject Descriptor],
    [description] as [Description],
    [units] as [Units],
    [scale] as [Scale]
FROM [indicators]
GO
 
-- 2. Process WEO data table
-- a. Create View for WEO_data table: Choose Columns
CREATE OR ALTER VIEW [v_WEOdata_ChooseColumns] as
SELECT
    [Country Group Name],
    [Subject Descriptor],
    [Units],
    [Scale],
    try_cast(nullif(trim([2019]), '') as real) as [2019],
    try_cast(nullif(trim([2020]), '') as real) as [2020],
    try_cast(nullif(trim([2021]), '') as real) as [2021],
    try_cast(nullif(trim([2022]), '') as real) as [2022],
    try_cast(nullif(trim([2023]), '') as real) as [2023],
    try_cast(nullif(trim([2024]), '') as real) as [2024],
    try_cast(nullif(trim([2025]), '') as real) as [2025],
    try_cast(nullif(trim([2026]), '') as real) as [2026]
FROM  WEO_data
WHERE
    try_cast(nullif(trim([2019]), '') as real) is not null
    and try_cast(nullif(trim([2020]), '') as real) is not null
    and try_cast(nullif(trim([2022]), '') as real) is not null
    and try_cast(nullif(trim([2023]), '') as real) is not null
    and try_cast(nullif(trim([2024]), '') as real) is not null
    and try_cast(nullif(trim([2025]), '') as real) is not null
    and try_cast(nullif(trim([2026]), '') as real) is not null
GO
-- b. Create View for WEO_data table: Convert [2019], ..., [2026] columns into [Year] column
CREATE OR ALTER VIEW [v_WEOdata_YearConverting] as
SELECT [Country Group Name], [Subject Descriptor], [Units], [Scale], [Value], [Year]
    FROM [v_WEOdata_ChooseColumns] UNPIVOT ([Value]
                            FOR [Year]
                            IN ([2019], [2020], [2021], [2022], [2023], [2024], [2025], [2026])) AS [Unpivot_table]
GO
 
-- c. Add (Subject) id for WEO data table (v_WEOdata) from indicators table (v_indicators)
CREATE OR ALTER VIEW [v_WEOdata_AddSubjectID] as
SELECT
    weo.[Country Group Name],
    weo.[Subject Descriptor],
    weo.[Units],
    weo.[Scale],
    weo.[Value],
    weo.[Year],
    i.[Subject Code]
FROM [v_WEOdata_YearConverting] weo
INNER JOIN [v_indicators_RemoveParentheses] i
ON weo.[Subject Descriptor] = i.[Subject Descriptor] AND weo.[Units] = i.[units];
GO
 
-- 3. Process WEOOct2021all table
-- a. Choose Columns
CREATE OR ALTER VIEW [v_WEOOct2021all_ChooseColumns] as
SELECT
    [WEO Country Code],
    [ISO],
    [WEO Subject Code],
    [Country],
    [Subject Descriptor],
    [Units],
    [Scale],
    try_cast(nullif(trim(replace([1980], 'n/a', '')), '') as real) as [1980],
    try_cast(nullif(trim(replace([1981], 'n/a', '')), '') as real) as [1981],
    try_cast(nullif(trim(replace([1982], 'n/a', '')), '') as real) as [1982],
    try_cast(nullif(trim(replace([1983], 'n/a', '')), '') as real) as [1983],
    try_cast(nullif(trim(replace([1984], 'n/a', '')), '') as real) as [1984],
    try_cast(nullif(trim(replace([1985], 'n/a', '')), '') as real) as [1985],
    try_cast(nullif(trim(replace([1986], 'n/a', '')), '') as real) as [1986],
    try_cast(nullif(trim(replace([1987], 'n/a', '')), '') as real) as [1987],
    try_cast(nullif(trim(replace([1988], 'n/a', '')), '') as real) as [1988],
    try_cast(nullif(trim(replace([1989], 'n/a', '')), '') as real) as [1989],
    try_cast(nullif(trim(replace([1990], 'n/a', '')), '') as real) as [1990],
    try_cast(nullif(trim(replace([1991], 'n/a', '')), '') as real) as [1991],
    try_cast(nullif(trim(replace([1992], 'n/a', '')), '') as real) as [1992],
    try_cast(nullif(trim(replace([1993], 'n/a', '')), '') as real) as [1993],
    try_cast(nullif(trim(replace([1994], 'n/a', '')), '') as real) as [1994],
    try_cast(nullif(trim(replace([1995], 'n/a', '')), '') as real) as [1995],
    try_cast(nullif(trim(replace([1996], 'n/a', '')), '') as real) as [1996],
    try_cast(nullif(trim(replace([1997], 'n/a', '')), '') as real) as [1997],
    try_cast(nullif(trim(replace([1998], 'n/a', '')), '') as real) as [1998],
    try_cast(nullif(trim(replace([1999], 'n/a', '')), '') as real) as [1999],
    try_cast(nullif(trim(replace([2000], 'n/a', '')), '') as real) as [2000],
    try_cast(nullif(trim(replace([2001], 'n/a', '')), '') as real) as [2001],
    try_cast(nullif(trim(replace([2002], 'n/a', '')), '') as real) as [2002],
    try_cast(nullif(trim(replace([2003], 'n/a', '')), '') as real) as [2003],
    try_cast(nullif(trim(replace([2004], 'n/a', '')), '') as real) as [2004],
    try_cast(nullif(trim(replace([2005], 'n/a', '')), '') as real) as [2005],
    try_cast(nullif(trim(replace([2006], 'n/a', '')), '') as real) as [2006],
    try_cast(nullif(trim(replace([2007], 'n/a', '')), '') as real) as [2007],
    try_cast(nullif(trim(replace([2008], 'n/a', '')), '') as real) as [2008],
    try_cast(nullif(trim(replace([2009], 'n/a', '')), '') as real) as [2009],
    try_cast(nullif(trim(replace([2010], 'n/a', '')), '') as real) as [2010],
    try_cast(nullif(trim(replace([2011], 'n/a', '')), '') as real) as [2011],
    try_cast(nullif(trim(replace([2012], 'n/a', '')), '') as real) as [2012],
    try_cast(nullif(trim(replace([2013], 'n/a', '')), '') as real) as [2013],
    try_cast(nullif(trim(replace([2014], 'n/a', '')), '') as real) as [2014],
    try_cast(nullif(trim(replace([2015], 'n/a', '')), '') as real) as [2015],
    try_cast(nullif(trim(replace([2016], 'n/a', '')), '') as real) as [2016],
    try_cast(nullif(trim(replace([2017], 'n/a', '')), '') as real) as [2017],
    try_cast(nullif(trim(replace([2018], 'n/a', '')), '') as real) as [2018],
    try_cast(nullif(trim(replace([2019], 'n/a', '')), '') as real) as [2019],
    try_cast(nullif(trim(replace([2020], 'n/a', '')), '') as real) as [2020],
    try_cast(nullif(trim(replace([2021], 'n/a', '')), '') as real) as [2021],
    try_cast(nullif(trim(replace([2022], 'n/a', '')), '') as real) as [2022],
    try_cast(nullif(trim(replace([2023], 'n/a', '')), '') as real) as [2023],
    try_cast(nullif(trim(replace([2024], 'n/a', '')), '') as real) as [2024],
    try_cast(nullif(trim(replace([2025], 'n/a', '')), '') as real) as [2025],
    try_cast(nullif(trim(replace([2026], 'n/a', '')), '') as real) as [2026],
    [Estimates Start After]
FROM [dbo].[WEOOct2021all]
WHERE
        try_cast(nullif(trim(replace([1980], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1981], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1982], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1983], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1984], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1985], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1986], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1987], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1988], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1989], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1990], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1991], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1992], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1993], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1994], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1995], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1996], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1997], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1998], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([1999], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2000], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2001], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2002], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2003], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2004], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2005], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2006], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2007], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2008], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2009], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2010], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2011], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2012], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2013], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2014], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2015], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2016], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2017], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2018], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2019], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2020], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2021], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2022], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2023], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2024], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2025], 'n/a', '')), '') as real) is not null
    and try_cast(nullif(trim(replace([2026], 'n/a', '')), '') as real) is not null
GO
 
 
-- b. Year converting
CREATE OR ALTER VIEW [v_WEOOtct2021all_YearConverting] as
SELECT
    [WEO Country Code] as [Country Code],
    [ISO],
    [WEO Subject Code] as [Subject Code],
    [Country],
    [Subject Descriptor],
    [Units],
    [Scale],
    [Value],
    [Year]
FROM [v_WEOOct2021all_ChooseColumns] UNPIVOT ([Value]
                            FOR [Year]
                            IN ([1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989],
                            [1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999],
                            [2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009],
                            [2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019],
                            [2020], [2021], [2022], [2023], [2024], [2025], [2026])) AS [Unpivot_table]
GO
 
-- 4. Process indicators table
CREATE OR ALTER VIEW [v_values_ChangeNameColumns] AS
SELECT
    [Country] as [ISO],
    [Indicator] as [Subject Code],
    [Year],
    [Value]
FROM [values]
GO
 
-- 5. Create tables from views
 
IF OBJECT_ID('[dbo].[t_Indicators]', 'U') IS NOT NULL
DROP TABLE [dbo].[t_Indicators]
SELECT *
INTO t_Indicators
FROM [v_indicators_RemoveParentheses]
GO
 
IF OBJECT_ID('[dbo].[t_Region]', 'U') IS NOT NULL
DROP TABLE [dbo].[t_Region]
SELECT *
INTO t_Region
FROM [v_WEOdata_AddSubjectID]
 
IF OBJECT_ID('[dbo].[t_Country]', 'U') IS NOT NULL
DROP TABLE [dbo].[t_Country]
SELECT *
INTO t_Country
FROM [v_WEOOtct2021all_YearConverting]
 
IF OBJECT_ID('[dbo].[t_Values]', 'U') IS NOT NULL
DROP TABLE [dbo].[t_Values]
SELECT *
INTO t_Values
FROM [v_values_ChangeNameColumns]
GO
 
 

 
-- SELECT *
-- FROM [t_Values]
-- WHERE [Subject Code] = 'NGDP_R' AND [YEAR] = 2000 AND [ISO] = 'QAT'
-- GO
 
-- SELECT *
-- FROM [t_Country]
-- WHERE [Subject Code] = 'NGDP_R'AND [YEAR] = 2000 AND [ISO] = 'QAT'
 

 
-- SELECT *
-- FROM [t_Country]
-- WHERE [Subject Code] = 'NGDP_R'AND [YEAR] = 2000

SELECT *
FROM [t_Indicators]
GO

SELECT *
FROM [t_Region]
GO

SELECT *
FROM [t_Country]
GO

SELECT *
FROM [t_Values]
GO