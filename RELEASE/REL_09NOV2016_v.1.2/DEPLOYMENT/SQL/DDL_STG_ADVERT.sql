select p.PRODUCT_ID           as CODE
, p.LABEL                     as DESCRIPTION
, pf.PRODUCT_FAMILY_NAME      as FAMILY
, p.PRODUCT_NAME              as PRODUCT
, w.WORKFLOW_GROUP_NAME       as PRODUCT_SUB_GROUP
, pg.PRODUCT_GROUP_NAME       as PRODUCT_GROUP
, p.LAST_MODIFIED             as last_modified
from $$Prefix.product p 
left join $$Prefix.PRODUCT_GROUP pg on p.PRODUCT_GROUP_ID=pg.PRODUCT_GROUP_ID 
left join $$Prefix.PRODUCT_FAMILY pf on pg.PRODUCT_FAMILY_ID=pf.PRODUCT_FAMILY_ID
left join $$Prefix.PRODUCT_WORKFLOW_GROUP w on p.WORKFLOW_GROUP_ID=w.WORKFLOW_GROUP_ID