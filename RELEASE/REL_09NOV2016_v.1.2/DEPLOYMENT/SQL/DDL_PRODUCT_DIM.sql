create table product_dim(
PRODUCT_KEY	NUMBER(22),
CODE	VARCHAR2(32),
DESCRIPTION	VARCHAR2(200),
FAMILY	VARCHAR2(32),
PRODUCT	VARCHAR2(32),
PRODUCT_SUB_GROUP	VARCHAR2(32),
THRESHOLD_TYPE	VARCHAR2(32),
PRODUCT_ATTRIBUTE_KEY	NUMBER(22),
BEGIN_EFFECTIVE_DATE	DATE,
END_EFFECTIVE_DATE	DATE,
PRODUCT_GROUP	VARCHAR2(32));