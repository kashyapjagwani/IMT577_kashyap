USE DATABASE IMT577_DW_KASHYAP_JAGWANI;
--DIM_DATE
create 
or replace table DIM_DATE (
  DATE_PKEY number(9) PRIMARY KEY, 
  DATE date not null, 
  FULL_DATE_DESC varchar(64) not null, 
  DAY_NUM_IN_WEEK number(1) not null, 
  DAY_NUM_IN_MONTH number(2) not null, 
  DAY_NUM_IN_YEAR number(3) not null, 
  DAY_NAME varchar(10) not null, 
  DAY_ABBREV varchar(3) not null, 
  WEEKDAY_IND varchar(64) not null, 
  US_HOLIDAY_IND varchar(64) not null, 
  
  /*<COMPANYNAME>*/
  _HOLIDAY_IND varchar(64) not null, 
  MONTH_END_IND varchar(64) not null, 
  WEEK_BEGIN_DATE_NKEY number(9) not null, 
  WEEK_BEGIN_DATE date not null, 
  WEEK_END_DATE_NKEY number(9) not null, 
  WEEK_END_DATE date not null, 
  WEEK_NUM_IN_YEAR number(9) not null, 
  MONTH_NAME varchar(10) not null, 
  MONTH_ABBREV varchar(3) not null, 
  MONTH_NUM_IN_YEAR number(2) not null, 
  YEARMONTH varchar(10) not null, 
  QUARTER number(1) not null, 
  YEARQUARTER varchar(10) not null, 
  YEAR number(5) not null, 
  FISCAL_WEEK_NUM number(2) not null, 
  FISCAL_MONTH_NUM number(2) not null, 
  FISCAL_YEARMONTH varchar(10) not null, 
  FISCAL_QUARTER number(1) not null, 
  FISCAL_YEARQUARTER varchar(10) not null, 
  FISCAL_HALFYEAR number(1) not null, 
  FISCAL_YEAR number(5) not null, 
  SQL_TIMESTAMP timestamp_ntz, 
  CURRENT_ROW_IND char(1) default 'Y', 
  EFFECTIVE_DATE date default to_date(current_timestamp), 
  EXPIRATION_DATE date default To_date('9999-12-31')
) comment = 'Type 0 Dimension Table Housing Calendar and Fiscal Year Date Attributes';
-- Populate data into DIM_DATE
insert into DIM_DATE 
select 
  DATE_PKEY, 
  DATE_COLUMN, 
  FULL_DATE_DESC, 
  DAY_NUM_IN_WEEK, 
  DAY_NUM_IN_MONTH, 
  DAY_NUM_IN_YEAR, 
  DAY_NAME, 
  DAY_ABBREV, 
  WEEKDAY_IND, 
  US_HOLIDAY_IND, 
  COMPANY_HOLIDAY_IND, 
  MONTH_END_IND, 
  WEEK_BEGIN_DATE_NKEY, 
  WEEK_BEGIN_DATE, 
  WEEK_END_DATE_NKEY, 
  WEEK_END_DATE, 
  WEEK_NUM_IN_YEAR, 
  MONTH_NAME, 
  MONTH_ABBREV, 
  MONTH_NUM_IN_YEAR, 
  YEARMONTH, 
  CURRENT_QUARTER, 
  YEARQUARTER, 
  CURRENT_YEAR, 
  FISCAL_WEEK_NUM, 
  FISCAL_MONTH_NUM, 
  FISCAL_YEARMONTH, 
  FISCAL_QUARTER, 
  FISCAL_YEARQUARTER, 
  FISCAL_HALFYEAR, 
  FISCAL_YEAR, 
  SQL_TIMESTAMP, 
  CURRENT_ROW_IND, 
  EFFECTIVE_DATE, 
  EXPIRA_DATE 
from 
  (
    select 
      to_date(
        '2012-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS'
      ) as DD, 
      
      /*<<Modify date for preferred table start date*/
      seq1() as Sl, 
      row_number() over (
        order by 
          Sl
      ) as row_numbers, 
      dateadd(day, row_numbers, DD) as V_DATE, 
      case when date_part(dd, V_DATE) < 10 
      and date_part(mm, V_DATE) > 9 then date_part(year, V_DATE)|| date_part(mm, V_DATE)|| '0' || date_part(dd, V_DATE) when date_part(dd, V_DATE) < 10 
      and date_part(mm, V_DATE) < 10 then date_part(year, V_DATE)|| '0' || date_part(mm, V_DATE)|| '0' || date_part(dd, V_DATE) when date_part(dd, V_DATE) > 9 
      and date_part(mm, V_DATE) < 10 then date_part(year, V_DATE)|| '0' || date_part(mm, V_DATE)|| date_part(dd, V_DATE) when date_part(dd, V_DATE) > 9 
      and date_part(mm, V_DATE) > 9 then date_part(year, V_DATE)|| date_part(mm, V_DATE)|| date_part(dd, V_DATE) end as DATE_PKEY, 
      V_DATE as DATE_COLUMN, 
      dayname(
        dateadd(day, row_numbers, DD)
      ) as DAY_NAME_1, 
      case when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Mon' then 'Monday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Tue' then 'Tuesday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Wed' then 'Wednesday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Thu' then 'Thursday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Fri' then 'Friday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Sat' then 'Saturday' when dayname(
        dateadd(day, row_numbers, DD)
      ) = 'Sun' then 'Sunday' end || ', ' || case when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Jan' then 'January' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Feb' then 'February' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Mar' then 'March' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Apr' then 'April' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'May' then 'May' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Jun' then 'June' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Jul' then 'July' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Aug' then 'August' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Sep' then 'September' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Oct' then 'October' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Nov' then 'November' when monthname(
        dateadd(day, row_numbers, DD)
      ) = 'Dec' then 'December' end || ' ' || to_varchar(
        dateadd(day, row_numbers, DD), 
        ' dd, yyyy'
      ) as FULL_DATE_DESC, 
      dateadd(day, row_numbers, DD) as V_DATE_1, 
      dayofweek(V_DATE_1)+ 1 as DAY_NUM_IN_WEEK, 
      Date_part(dd, V_DATE_1) as DAY_NUM_IN_MONTH, 
      dayofyear(V_DATE_1) as DAY_NUM_IN_YEAR, 
      case when dayname(V_DATE_1) = 'Mon' then 'Monday' when dayname(V_DATE_1) = 'Tue' then 'Tuesday' when dayname(V_DATE_1) = 'Wed' then 'Wednesday' when dayname(V_DATE_1) = 'Thu' then 'Thursday' when dayname(V_DATE_1) = 'Fri' then 'Friday' when dayname(V_DATE_1) = 'Sat' then 'Saturday' when dayname(V_DATE_1) = 'Sun' then 'Sunday' end as DAY_NAME, 
      dayname(
        dateadd(day, row_numbers, DD)
      ) as DAY_ABBREV, 
      case when dayname(V_DATE_1) = 'Sun' 
      and dayname(V_DATE_1) = 'Sat' then 'Not-Weekday' else 'Weekday' end as WEEKDAY_IND, 
      case when (
        DATE_PKEY = date_part(year, V_DATE)|| '0101' 
        or DATE_PKEY = date_part(year, V_DATE)|| '0704' 
        or DATE_PKEY = date_part(year, V_DATE)|| '1225' 
        or DATE_PKEY = date_part(year, V_DATE)|| '1226'
      ) then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Wed' 
      and dateadd(
        day, 
        -2, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Thu' 
      and dateadd(
        day, 
        -3, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Fri' 
      and dateadd(
        day, 
        -4, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Sat' 
      and dateadd(
        day, 
        -5, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Sun' 
      and dateadd(
        day, 
        -6, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Mon' 
      and last_day(V_DATE_1) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'May' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Tue' 
      and dateadd(
        day, 
        -1, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Wed' 
      and dateadd(
        day, 
        5, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Thu' 
      and dateadd(
        day, 
        4, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Fri' 
      and dateadd(
        day, 
        3, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Sat' 
      and dateadd(
        day, 
        2, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Sun' 
      and dateadd(
        day, 
        1, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Mon' 
      and date_part(year, V_DATE_1)|| '-09-01' = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Tue' 
      and dateadd(
        day, 
        6, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Wed' 
      and (
        dateadd(
          day, 
          23, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          22, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Thu' 
      and (
        dateadd(
          day, 
          22, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          21, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Fri' 
      and (
        dateadd(
          day, 
          21, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          20, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Sat' 
      and (
        dateadd(
          day, 
          27, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          26, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Sun' 
      and (
        dateadd(
          day, 
          26, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          25, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Mon' 
      and (
        dateadd(
          day, 
          25, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          24, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Tue' 
      and (
        dateadd(
          day, 
          24, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1 
        or dateadd(
          day, 
          23, 
          (
            date_part(year, V_DATE_1)|| '-11-01'
          )
        ) = V_DATE_1
      ) then 'Holiday' else 'Not-Holiday' end as US_HOLIDAY_IND, 
      
      /*Modify the following for Company Specific Holidays*/
      case when (
        DATE_PKEY = date_part(year, V_DATE)|| '0101' 
        or DATE_PKEY = date_part(year, V_DATE)|| '0219' 
        or DATE_PKEY = date_part(year, V_DATE)|| '0528' 
        or DATE_PKEY = date_part(year, V_DATE)|| '0704' 
        or DATE_PKEY = date_part(year, V_DATE)|| '1225'
      ) then 'Holiday' when monthname(V_DATE_1) = 'Mar' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Fri' 
      and last_day(V_DATE_1) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Mar' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Sat' 
      and dateadd(
        day, 
        -1, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Mar' 
      and dayname(
        last_day(V_DATE_1)
      ) = 'Sun' 
      and dateadd(
        day, 
        -2, 
        last_day(V_DATE_1)
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Tue' 
      and dateadd(
        day, 
        3, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Wed' 
      and dateadd(
        day, 
        2, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Thu' 
      and dateadd(
        day, 
        1, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Fri' 
      and date_part(year, V_DATE_1)|| '-04-01' = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Wed' 
      and dateadd(
        day, 
        5, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Thu' 
      and dateadd(
        day, 
        4, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Fri' 
      and dateadd(
        day, 
        3, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Sat' 
      and dateadd(
        day, 
        2, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Sun' 
      and dateadd(
        day, 
        1, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Mon' 
      and date_part(year, V_DATE_1)|| '-04-01' = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Apr' 
      and dayname(
        date_part(year, V_DATE_1)|| '-04-01'
      ) = 'Tue' 
      and dateadd(
        day, 
        6, 
        (
          date_part(year, V_DATE_1)|| '-04-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Wed' 
      and dateadd(
        day, 
        5, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Thu' 
      and dateadd(
        day, 
        4, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Fri' 
      and dateadd(
        day, 
        3, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Sat' 
      and dateadd(
        day, 
        2, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Sun' 
      and dateadd(
        day, 
        1, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Mon' 
      and date_part(year, V_DATE_1)|| '-09-01' = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Sep' 
      and dayname(
        date_part(year, V_DATE_1)|| '-09-01'
      ) = 'Tue' 
      and dateadd(
        day, 
        6, 
        (
          date_part(year, V_DATE_1)|| '-09-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Wed' 
      and dateadd(
        day, 
        23, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Thu' 
      and dateadd(
        day, 
        22, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Fri' 
      and dateadd(
        day, 
        21, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Sat' 
      and dateadd(
        day, 
        27, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Sun' 
      and dateadd(
        day, 
        26, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Mon' 
      and dateadd(
        day, 
        25, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' when monthname(V_DATE_1) = 'Nov' 
      and dayname(
        date_part(year, V_DATE_1)|| '-11-01'
      ) = 'Tue' 
      and dateadd(
        day, 
        24, 
        (
          date_part(year, V_DATE_1)|| '-11-01'
        )
      ) = V_DATE_1 then 'Holiday' else 'Not-Holiday' end as COMPANY_HOLIDAY_IND, 
      case when last_day(V_DATE_1) = V_DATE_1 then 'Month-end' else 'Not-Month-end' end as MONTH_END_IND, 
      case when date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      ) < 10 
      and date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) < 10 then date_part(
        yyyy, 
        date_trunc('week', V_DATE_1)
      )|| '0' || date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      )|| '0' || date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) when date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      ) < 10 
      and date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) > 9 then date_part(
        yyyy, 
        date_trunc('week', V_DATE_1)
      )|| '0' || date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      )|| date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) when date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      ) > 9 
      and date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) < 10 then date_part(
        yyyy, 
        date_trunc('week', V_DATE_1)
      )|| date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      )|| '0' || date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) when date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      ) > 9 
      and date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) > 9 then date_part(
        yyyy, 
        date_trunc('week', V_DATE_1)
      )|| date_part(
        mm, 
        date_trunc('week', V_DATE_1)
      )|| date_part(
        dd, 
        date_trunc('week', V_DATE_1)
      ) end as WEEK_BEGIN_DATE_NKEY, 
      date_trunc('week', V_DATE_1) as WEEK_BEGIN_DATE, 
      case when date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      ) < 10 
      and date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) < 10 then date_part(
        yyyy, 
        last_day(V_DATE_1, 'week')
      )|| '0' || date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      )|| '0' || date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) when date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      ) < 10 
      and date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) > 9 then date_part(
        yyyy, 
        last_day(V_DATE_1, 'week')
      )|| '0' || date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      )|| date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) when date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      ) > 9 
      and date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) < 10 then date_part(
        yyyy, 
        last_day(V_DATE_1, 'week')
      )|| date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      )|| '0' || date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) when date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      ) > 9 
      and date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) > 9 then date_part(
        yyyy, 
        last_day(V_DATE_1, 'week')
      )|| date_part(
        mm, 
        last_day(V_DATE_1, 'week')
      )|| date_part(
        dd, 
        last_day(V_DATE_1, 'week')
      ) end as WEEK_END_DATE_NKEY, 
      last_day(V_DATE_1, 'week') as WEEK_END_DATE, 
      week(V_DATE_1) as WEEK_NUM_IN_YEAR, 
      case when monthname(V_DATE_1) = 'Jan' then 'January' when monthname(V_DATE_1) = 'Feb' then 'February' when monthname(V_DATE_1) = 'Mar' then 'March' when monthname(V_DATE_1) = 'Apr' then 'April' when monthname(V_DATE_1) = 'May' then 'May' when monthname(V_DATE_1) = 'Jun' then 'June' when monthname(V_DATE_1) = 'Jul' then 'July' when monthname(V_DATE_1) = 'Aug' then 'August' when monthname(V_DATE_1) = 'Sep' then 'September' when monthname(V_DATE_1) = 'Oct' then 'October' when monthname(V_DATE_1) = 'Nov' then 'November' when monthname(V_DATE_1) = 'Dec' then 'December' end as MONTH_NAME, 
      monthname(V_DATE_1) as MONTH_ABBREV, 
      month(V_DATE_1) as MONTH_NUM_IN_YEAR, 
      case when month(V_DATE_1) < 10 then year(V_DATE_1)|| '-0' || month(V_DATE_1) else year(V_DATE_1)|| '-' || month(V_DATE_1) end as YEARMONTH, 
      quarter(V_DATE_1) as CURRENT_QUARTER, 
      year(V_DATE_1)|| '-0' || quarter(V_DATE_1) as YEARQUARTER, 
      year(V_DATE_1) as CURRENT_YEAR, 
      
      /*Modify the following based on company fiscal year - assumes Jan 01*/
      to_date(
        year(V_DATE_1)|| '-01-01', 
        'YYYY-MM-DD'
      ) as FISCAL_CUR_YEAR, 
      to_date(
        year(V_DATE_1) -1 || '-01-01', 
        'YYYY-MM-DD'
      ) as FISCAL_PREV_YEAR, 
      case when V_DATE_1 < FISCAL_CUR_YEAR then datediff(
        'week', FISCAL_PREV_YEAR, V_DATE_1
      ) else datediff(
        'week', FISCAL_CUR_YEAR, V_DATE_1
      ) end as FISCAL_WEEK_NUM, 
      decode(
        datediff(
          'MONTH', FISCAL_CUR_YEAR, V_DATE_1
        )+ 1, 
        -2, 
        10, 
        -1, 
        11, 
        0, 
        12, 
        datediff(
          'MONTH', FISCAL_CUR_YEAR, V_DATE_1
        )+ 1
      ) as FISCAL_MONTH_NUM, 
      concat(
        year(FISCAL_CUR_YEAR), 
        case when to_number(FISCAL_MONTH_NUM) = 10 
        or to_number(FISCAL_MONTH_NUM) = 11 
        or to_number(FISCAL_MONTH_NUM) = 12 then '-' || FISCAL_MONTH_NUM else concat('-0', FISCAL_MONTH_NUM) end
      ) as FISCAL_YEARMONTH, 
      case when quarter(V_DATE_1) = 4 then 4 when quarter(V_DATE_1) = 3 then 3 when quarter(V_DATE_1) = 2 then 2 when quarter(V_DATE_1) = 1 then 1 end as FISCAL_QUARTER, 
      case when V_DATE_1 < FISCAL_CUR_YEAR then year(FISCAL_CUR_YEAR) else year(FISCAL_CUR_YEAR)+ 1 end || '-0' || case when quarter(V_DATE_1) = 4 then 4 when quarter(V_DATE_1) = 3 then 3 when quarter(V_DATE_1) = 2 then 2 when quarter(V_DATE_1) = 1 then 1 end as FISCAL_YEARQUARTER, 
      case when quarter(V_DATE_1) = 4 then 2 when quarter(V_DATE_1) = 3 then 2 when quarter(V_DATE_1) = 1 then 1 when quarter(V_DATE_1) = 2 then 1 end as FISCAL_HALFYEAR, 
      year(FISCAL_CUR_YEAR) as FISCAL_YEAR, 
      to_timestamp_ntz(V_DATE) as SQL_TIMESTAMP, 
      'Y' as CURRENT_ROW_IND, 
      to_date(current_timestamp) as EFFECTIVE_DATE, 
      to_date('9999-12-31') as EXPIRA_DATE --from table(generator(rowcount => 8401)) /*<< Set to generate 20 years. Modify rowcount to increase or decrease size*/
    from 
      table(
        generator(rowcount => 730)
      ) 
      /*<< Set to generate 20 years. Modify rowcount to increase or decrease size*/
      ) v;
--DIM_PRODUCT      
create 
or replace table Dim_Product (
  DimProductID number(9) PRIMARY KEY, 
  ProductID number(9) not null, 
  ProductTypeID number(9) not null, 
  ProductCategoryID number(9) not null, 
  ProductName varchar(64) not null, 
  ProductType varchar(64) not null, 
  ProductCategory varchar(64) not null, 
  ProductRetailPrice number(9, 2) not null, 
  ProductWholesalePrice number(9, 2) not null, 
  ProductCost number(9, 2) not null, 
  ProductRetailProfit number(9, 2) not null, 
  ProductWholesaleUnitProfit number(9, 2) not null, 
  ProductProfitMarginUnitPercent number(9, 2) not null
);
INSERT INTO Dim_Product(
  DimProductID, ProductID, ProductTypeID, 
  ProductCategoryID, ProductName, 
  ProductType, ProductCategory, ProductRetailPrice, 
  ProductWholesalePrice, ProductCost, 
  ProductRetailProfit, ProductWholesaleUnitProfit, 
  ProductProfitMarginUnitPercent
) 
VALUES 
  (
    -1, -1, -1, -1, 'Unknown', 'Unknown', 
    'Unknown', -1, -1, -1, -1, -1, -1
  );
INSERT INTO Dim_Product(
  DimProductID, ProductID, ProductTypeID, 
  ProductCategoryID, ProductName, 
  ProductType, ProductCategory, ProductRetailPrice, 
  ProductWholesalePrice, ProductCost, 
  ProductRetailProfit, ProductWholesaleUnitProfit, 
  ProductProfitMarginUnitPercent
) 
SELECT 
  pr.productid, 
  pr.productid, 
  pr.producttypeid, 
  pc.productcategoryid, 
  pr.product, 
  pt.producttypeid, 
  pc.productcategory, 
  pr.price, 
  pr.wholesaleprice, 
  pr.cost, 
  pr.price - pr.cost as RetailProfit, 
  pr.wholesaleprice - pr.cost as WholesaleUnitProfit, 
  (
    (pr.price - pr.cost)/ pr.price
  )* 100 as ProfitMarginUnitPercent 
FROM 
  (
    (
      STAGE_PRODUCT pr 
      inner join STAGE_PRODUCT_TYPE pt on pr.producttypeid = pt.producttypeid
    ) 
    inner join STAGE_PRODUCT_CATEGORY pc on pc.productcategoryid = pt.productcategoryid
  );
--DIM_LOCATION
create 
or replace table Dim_Location (
  DimLocationID INT IDENTITY(1, 1) PRIMARY KEY, 
  Address varchar(128) not null, 
  City varchar(64) not null, 
  PostalCode number(6) not null, 
  State_Province varchar(64) not null, 
  Country varchar(64) not null
);
insert into Dim_Location(
  address, city, postalcode, state_province, 
  country
) 
values 
  (
    'Unknown', 'Unknown', -1, 'Unknown', 
    'Unknown'
  );
insert into Dim_Location(
  address, city, postalcode, state_province, 
  country
) 
select 
  address, 
  city, 
  postalcode, 
  stateprovince, 
  country 
from 
  stage_reseller 
union 
select 
  address, 
  city, 
  postalcode, 
  stateprovince, 
  country 
from 
  stage_store 
union 
select 
  address, 
  city, 
  postalcode, 
  stateprovince, 
  country 
from 
  stage_customer;
--DIM_STORE
create 
or replace table Dim_Store (
  DimStoreID number(9) PRIMARY KEY, 
  DimLocationID INT references Dim_Location(DimLocationID), 
  SourceStoreID number(9) not null, 
  StoreNumber number(9) not null, 
  StoreManager varchar(64) not null
);
insert into Dim_Store(
  DimStoreID, DimLocationID, SourceStoreID, 
  StoreNumber, StoreManager
) 
values 
  (-1, -1, -1, -1, 'Unknown');
insert into Dim_Store(
  DimStoreID, DimLocationID, SourceStoreID, 
  StoreNumber, StoreManager
) 
select 
  storeid, 
  dimlocationid, 
  subsegmentid, 
  storenumber, 
  storemanager 
from 
  stage_store s 
  inner join dim_location dl on s.address = dl.address;
--What is SourceStoreID?
--DIM_RESELLER
create 
or replace table Dim_Reseller (
  DimResellerID varchar(255) PRIMARY KEY, 
  DimLocationID INT references Dim_Location(DimLocationID), 
  ResellerID varchar(255) not null, 
  ResellerName varchar(255) not null, 
  ContactName varchar(255) not null, 
  PhoneNumber varchar(255) not null, 
  Email varchar(255) not null
);
insert into Dim_Reseller(
  DimResellerID, DimLocationID, ResellerID, 
  ResellerName, ContactName, PhoneNumber, 
  Email
) 
values 
  (
    'Unknown', -1, 'Unknown', 'Unknown', 
    'Unknown', 'Unknown', 'Unknown'
  );
insert into Dim_Reseller(
  DimResellerID, DimLocationID, ResellerID, 
  ResellerName, ContactName, PhoneNumber, 
  Email
) 
select 
  resellerid, 
  dimlocationid, 
  resellerid, 
  resellername, 
  contact, 
  phonenumber, 
  emailaddress 
from 
  stage_reseller s 
  inner join dim_location dl on s.address = dl.address;

--DIM_CUSTOMER
create 
or replace table Dim_Customer (
  DimCustomerID varchar(255) PRIMARY KEY, 
  DimLocationID INT references Dim_Location(DimLocationID), 
  CustomerID varchar(255) not null, 
  CustomerFullName varchar(128) not null, 
  CustomerFirstName varchar(64) not null, 
  CustomerLastName varchar(64) not null, 
  CustomerGender varchar(10) not null
);
insert into Dim_Customer(
  DimCustomerID, DimLocationID, CustomerID, 
  CustomerFullName, CustomerFirstName, 
  CustomerLastName, CustomerGender
) 
values 
  (
    -1, -1, 'Unknown', 'Unknown', 'Unknown', 
    'Unknown', 'Unknown'
  );
insert into Dim_Customer(
  DimCustomerID, DimLocationID, CustomerID, 
  CustomerFullName, CustomerFirstName, 
  CustomerLastName, CustomerGender
) 
select 
  customerid, 
  dimlocationid, 
  customerid, 
  firstname || ' ' || lastname, 
  firstname, 
  lastname, 
  gender 
from 
  stage_customer s 
  inner join dim_location dl on s.address = dl.address;
--DIM_CHANNEL
create 
or replace table Dim_Channel (
  DimChannelID number(9) PRIMARY KEY, 
  ChannelID number(9) not null, 
  ChannelCategoryID number(9) not null, 
  ChannelName varchar(64) not null, 
  ChannelCategory varchar(64) not null
);
insert into Dim_Channel(
  DimChannelID, ChannelID, ChannelCategoryID, 
  ChannelName, ChannelCategory
) 
values 
  (-1, -1, -1, 'Unknown', 'Unknown');
insert into Dim_Channel(
  DimChannelID, ChannelID, ChannelCategoryID, 
  ChannelName, ChannelCategory
) 
select 
  c.channelid, 
  c.channelid, 
  c.channelcategoryid, 
  c.channel, 
  cc.channelcategory 
from 
  stage_channel c 
  inner join stage_channel_category cc on c.channelcategoryid = cc.channelcategoryid;