CREATE TABLE CLP_STG.STG_STATE_HISTORY 
   (	
    BATCHNUM           NUMBER(22,0), 
	TIME_              STAMP DATE, 
	SOURCE             VARCHAR2(32 BYTE), 
	WORKITEM_ID        NUMBER(22,0), 
	CLIPPER_VERSION    NUMBER(22,0), 
	PUB_VERSION        VARCHAR2(30 BYTE), 
	STATUS             VARCHAR2(100 BYTE), 
	STATUS_DATE        DATE, 
	STATUS_REASON_CODE NVARCHAR2(60), 
	REASON_TEXT        VARCHAR2(1000 BYTE), 
	LOC_NAME           VARCHAR2(70 BYTE), 
	ACTOR              VARCHAR2(15 BYTE), 
	REASON_BRIDGE_CODE NUMBER(22,0)
   )