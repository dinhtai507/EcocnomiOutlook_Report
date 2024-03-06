use IMF_DB
go

-- 1. Xem bảng t_Country
select * from t_Country
go

-- 2. Tạo view để trích xuất GDP danh nghĩa
create or alter view v_GDP_View as 
select 
        [Country], [Subject Code], [Subject Descriptor], [Units], [Scale], [Year], 
        [Value] as GDP
    from t_Country
    where trim([Subject Descriptor]) = 'Gross domestic product, current prices'
go

-- 3. Tạo view để tính toán cột Grownth, Percent
create or alter view v_GDP_Detail_View as 
select 
    [Country], [Subject Code], [Subject Descriptor], [Units], [Scale], [Year], 
    [GDP],
    -- (lag(GDP) over (partition by [Country] order by [Year] asc)) as [LastYear_GDP],
    (GDP - lag(GDP) over (partition by [Country] order by [Year] asc)) / lag(GDP) over (partition by [Country] order by [Year]) as [Grownth],
    (GDP / sum(GDP) over (partition by [Year])) as [Percent]
from GDP_View
go

-- 4. Tạo function để xử lý %
create or alter function f_Convert_To_Percentage (@index real)
returns varchar(20)
as
begin
    declare @output varchar(20)
    if @index is not null
    begin
        set @output = round(@index*100, 2)
        set @output = convert(numeric(17, 2), @output)
        set @output = convert(varchar(20), @output) + '%'
    end
    return @output
end
go
-- 5. Tạo view để chuyển đổi thành % cho cột Grownth, Percent
create or alter view v_GDP_DetailView_Percent as 
with temp_table as
(
select 
    [Country], [Subject Code], [Subject Descriptor], [Units], [Scale], [Year], 
    [GDP],
    -- (lag(GDP) over (partition by [Country] order by [Year] asc)) as [LastYear_GDP],
    (GDP - lag(GDP) over (partition by [Country] order by [Year] asc)) / lag(GDP) over (partition by [Country] order by [Year]) as [Grownth],
    (GDP / sum(GDP) over (partition by [Year])) as [Percent]
from GDP_Detail_View
)
select 
    [Country], [Subject Code], [Subject Descriptor], [Units], [Scale], [Year], 
    [GDP],
    dbo.f_Convert_To_Percentage([Grownth]) as [Grownth],
    dbo.f_Convert_To_Percentage([Percent]) as [Percent]
from temp_table 
go