-------------DATE DIMENSION SCRIPT---------------- 
CREATE OR REPLACE PROCEDURE sp_DATE_DIMENSION (v_START_YEAR IN INT, v_END_YEAR IN INT) AS
-----------DECLEAR VARIABLES----------------
  l_current_date DATE;
  l_end_date DATE;
  var_L_W CHAR(1 BYTE);
  var_L_M CHAR(1 BYTE);
  var_W_I VARCHAR2(7 BYTE);
  var_H_I VARCHAR2(12 BYTE);
  var_D_F_Y INTEGER;
  var1 integer;
  var2 integer;
  var_F_W integer;
  var_F_Y integer;
  var_H WORKHOURSTYPE;
  var_W integer;
  var_WW integer;
    
BEGIN
---------------------SUM OF LOGIC----------------
  l_current_date := to_date('01/01/' || v_START_YEAR,'dd/mm/yyyy');
  l_end_date := to_date('31/12/' || v_END_YEAR,'dd/mm/yyyy');
  var_F_W:=40;
  var_WW:=0;
  var_W:=0;
-----------------start loop-----------------
  WHILE l_current_date <= l_end_date LOOP
  
  ---------WEEK IMPLIMENT---------- 
  if(to_char(l_current_date,'D')='1')
  then
       var_W:=var_W+1;
       var_WW:=var_WW+1;
  end if;
  
  if(to_char(l_current_date,'MM')='01' AND to_char(l_current_date,'DD')='01')
  then
  var_WW:=1;
  var_W:=1;
  end if;
  
  if(to_char(l_current_date,'DD')='01')
  then
  var_W:=1;
  end if;
  ----------LAST_DAY_IN_WEEK_INDICATOR   	CHAR(1 BYTE),
  if to_char(l_current_date,'D')='7' 
  or to_char(l_current_date,'D')='1' 
  then 
  var_L_W:='Y'; 
  var_W_I:='Weekend';
  var_H:=WORKHOURSTYPE(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  else 
  var_L_W:='N';
  var_W_I:='Weekday';
  var_H:=WORKHOURSTYPE(0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1);
  end if;
  ---------------LAST_DAY_IN_MONTH_INDICATOR  	CHAR(1 BYTE),
  if last_day(l_current_date)=l_current_date
  then
  var_L_M:='Y'; 
  else 
  var_L_M:='N'; 
  end if;
  -------------HOLIDAY INDICATOR
  if(to_char(l_current_date,'D')='1')
  then
  var_H_I:='Holiday';
  else
  var_H_I:='Non-Holiday';
  end if;
  --DAY_NUM_IN_FISCLE_YEAR
  var1:=to_char(l_current_date,'MM');
  --var2:=to_char(l_current_date,'DDD');
  --------------FISCAL LOGIC----------
  if(var1<4)
  then
  var_D_F_Y:=to_char(l_current_date,'DDD')+275;
  --var_F_W:=to_char(l_current_date,'WW')+39;
  var_F_Y:=to_char(l_current_date,'YYYY')-1;
  else
  var_D_F_Y:=to_char(l_current_date,'DDD')-(62+to_char(last_day(to_date('01-02-'||to_char(l_current_date,'YYYY'),'DD-MM_YYYY')),'DD'));
  --var_F_W:=(to_char(l_current_date,'DDD')-to_char(to_date('31-03-'||to_char(l_current_date,'YYYY'),'DD-MM_YYYY'),'DDD'))/7+1;
  var_F_Y:=to_char(l_current_date,'YYYY');
  end if;
  
  if(to_char(l_current_date,'D')='1')
  then
  var_F_W:=var_F_W+1;
  end if;
  
  if(to_char(l_current_date,'DD')='01' AND to_char(l_current_date,'MM')='04')
  then
  var_F_W:=1;
  end if;
  
---------------------INSERT STETMENT------------------------

    INSERT INTO CLP_DATE_DIM (
    DATE_KEY                  ,
  DATE_STAMP                  ,
  SHORT_DATE_DESCRIPTION     	,
  FULL_DATE_DESCRIPTION        	,
  DAY_OF_WEEK                  	,
  DAY_NUM_IN_CALENDAR_MONTH   	,
  DAY_NUM_IN_CALENDAR_YEAR     	,
  DAY_NUM_IN_FISCAL_MONTH      	,
  DAY_NUM_IN_FISCAL_YEAR       	,
  LAST_DAY_IN_WEEK_INDICATOR   	,
  LAST_DAY_IN_MONTH_INDICATOR  	,
  CALENDAR_WEEK_NUM_IN_YEAR    	,
  CALENDAR_MONTH_NAME          	,
  CALENDAR_MONTH_NUM_IN_YEAR  	,
  CALENDAR_YEAR_MONTH  ,
  CALENDAR_QUARTER     ,
  CALENDAR_YEAR_QUARTER,
  CALENDAR_YEAR,
  FISCAL_WEEK_NUM_IN_YEAR      	,
  FISCAL_MONTH_NAME            	,
  FISCAL_MONTH_NUM_IN_YEAR     	,
  FISCAL_YEAR_MONTH            	,
  FISCAL_QUARTER               	,
  FISCAL_YEAR_QUARTER          	,
  FISCAL_YEAR                  	,
  HOLIDAY_INDICATOR            	,
  WEEKDAY_INDICATOR            	,
  WORKHOURS                    	,
  UTC_TO_UK_TIME               	,
  UTC_TO_EASTERN_TIME         	,
  UTC_TO_CENTRAL_TIME         	,
  UTC_TO_MOUNTAIN_TIME         	,
  UTC_TO_PACIFIC_TIME          	,
  UTC_TO_INDIAN_TIME          	,
  WEEK_KEY                     	,
  MONTH_KEY                    	,
  EXECUTIVE_DATE_FORMAT        	
  
    )VALUES (
  --DATE_KEY                      INTEGER,
  to_char(l_current_date,'YYYYMMDD'),
  --DATE_STAMP                   	DATE,
  l_current_date,
  --SHORT_DATE_DESCRIPTION     	  VARCHAR2(12 BYTE),
  to_char(l_current_date,'DD-MON-YYYY'),
  --FULL_DATE_DESCRIPTION        	VARCHAR2(18 BYTE),
  to_char(l_current_date,'MONTH DD,YYYY'),
  --DAY_OF_WEEK                  	VARCHAR2(10 BYTE),
  to_char(l_current_date,'day'), 
  --DAY_NUM_IN_CALENDAR_MONTH   	INTEGER,
  to_char(l_current_date,'DD'),
  --DAY_NUM_IN_CALENDAR_YEAR     	INTEGER,
  to_char(l_current_date,'DDD'),
  --DAY_NUM_IN_FISCAL_MONTH      	INTEGER,
  to_char(l_current_date,'DD'),
  --DAY_NUM_IN_FISCAL_YEAR       	INTEGER,
  var_D_F_Y,
  --LAST_DAY_IN_WEEK_INDICATOR   	CHAR(1 BYTE),
  var_L_W,
  --LAST_DAY_IN_MONTH_INDICATOR  	CHAR(1 BYTE),
  var_L_M,
  --CALENDAR_WEEK_NUM_IN_YEAR    	INTEGER,-------------------------------
  var_WW,
  --CALENDAR_MONTH_NAME          	VARCHAR2(10 BYTE),
  to_char(l_current_date,'MONTH'),
  --CALENDAR_MONTH_NUM_IN_YEAR  	INTEGER,
  to_char(l_current_date,'MM'),
  --CALENDAR_YEAR_MONTH          	VARCHAR2(8 BYTE),
  to_char(l_current_date,'YYYY-MM'),
  --CALENDAR_QUARTER             	VARCHAR2(2 BYTE),
  'Q'||to_char(l_current_date,'Q'),
  --CALENDAR_YEAR_QUARTER        	VARCHAR2(7 BYTE),
  to_char(l_current_date,'YYYY')||'Q'||to_char(l_current_date,'Q'),
  --CALENDAR_YEAR                	INTEGER,
  to_char(l_current_date,'YYYY'),
  --FISCAL_WEEK_NUM_IN_YEAR      	INTEGER,--------------------------------
  var_F_W,
  --FISCAL_MONTH_NAME            	VARCHAR2(10 BYTE),
  to_char(l_current_date,'MONTH'),
  --FISCAL_MONTH_NUM_IN_YEAR     	INTEGER,
  DECODE(to_char(l_current_date,'MM'),'01',10,'02',11,'03',12,'04',1,'05',2,'06',3,'07',4,'08',5,'09',6,'10',7,'11',8,'12',9),
  --FISCAL_YEAR_MONTH            	VARCHAR2(8 BYTE),
  var_F_Y||'-'||DECODE(to_char(l_current_date,'MM'),'01',10,'02',11,'03',12,'04',1,'05',2,'06',3,'07',4,'08',5,'09',6,'10',7,'11',8,'12',9),
  --FISCAL_QUARTER               	VARCHAR2(2 BYTE),
  'Q'||DECODE(to_char(l_current_date,'Q'),'1',4,'2',1,'3',2,'4',3),
  --FISCAL_YEAR_QUARTER          		VARCHAR2(7 BYTE),
  var_F_Y||'-Q'||DECODE(to_char(l_current_date,'Q'),'1',4,'2',1,'3',2,'4',3),
  --FISCAL_YEAR                  		INTEGER,
  var_F_Y,
  --HOLIDAY_INDICATOR            		VARCHAR2(12 BYTE),
  var_H_I,
  --WEEKDAY_INDICATOR            		VARCHAR2(7 BYTE),
  var_W_I,
  --WORKHOURS                    		VARCHAR2(35 BYTE),
  var_H,
  --UTC_TO_UK_TIME               		INTERVAL DAY(2) TO SECOND(6),
  '+00 00:00:00.000000',
  --UTC_TO_EASTERN_TIME         		INTERVAL DAY(2) TO SECOND(6),
  '-00 05:00:00.000000',
  --UTC_TO_CENTRAL_TIME         		INTERVAL DAY(2) TO SECOND(6),
  '-00 06:00:00.000000',
  --UTC_TO_MOUNTAIN_TIME         		INTERVAL DAY(2) TO SECOND(6),
  '-00 07:00:00.000000',
  --UTC_TO_PACIFIC_TIME          		INTERVAL DAY(2) TO SECOND(6),
  '-00 08:00:00.000000',
  --UTC_TO_INDIAN_TIME          		INTERVAL DAY(2) TO SECOND(6),
  '+00 05:30:00.000000',
  --WEEK_KEY                     		INTEGER,
  to_char(TRUNC(l_current_date,'D')+6,'YYYYMMDD'),
  --MONTH_KEY                    		INTEGER,
  to_char(trunc(ADD_MONTHS(l_current_date,1),'MM')-1,'YYYYMMDD'),
  --EXECUTIVE_DATE_FORMAT        	VARCHAR2(18 BYTE)
  to_char(l_current_date,'DY')||'-'||to_char(l_current_date,'MM/DD')
    );

    l_current_date := l_current_date + 1;
  END LOOP;
  -------------------end loop--------------------
  commit;
END;
