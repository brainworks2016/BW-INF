select 
'ADV'                     as source_name 
,A.CLIPPER_WI_REF         as CLIPPER_WI_REF 
,A.CLIPPER_ADVERTISER_REF as CLIPPER_ADVERTISER_REF
,A.VERSION_NUM            as VERSION_NUM
,A.CURRENT_STATUS         as CURRENT_STATUS
,A.CURRENT_STATUS_DATE    as CURRENT_STATUS_DATE
,A.CANCEL_FLAG            as CANCEL_FLAG
,A.NATIONAL_FLAG          as NATIONAL_FLAG
,A.PUB_VERSION_NUM        as PUB_VERSION_NUM
,A.PUBLISHER_CONTRACT     as PUBLISHER_CONTRACT
,A.CLIPPER_BOOK_ID        as CLIPPER_BOOK_ID
,A.PUB_AD_CODE            as PUB_AD_CODE
,A.BOOK_EDITION           as BOOK_EDITION
,A.WORKITEM_ID            as WORKITEM_ID
,A.CLIPPER_REP_CODE       as CLIPPER_REP_CODE
,A.BUSINESS_CENTRE_ID     as BUSINESS_CENTRE_ID
,A.PUBLISHER_ID           as PUBLISHER_ID
,A.LAST_MODIFIED          as ADV_LAST_MODIFIED
--,A.SPEC_LAST_MODIFIED     as SPEC_LAST_MODIFIED
,PA.COLOUR_CODE           as COLOUR_CODE
,W.BUNDLE_ID              as BUNDLE_ID
,W.LAST_MODIFIED          as W_LAST_MODIFIED
,S.SALES_REP_CODE         as SALES_REP_CODE
,B.BUSINESS_CENTRE_DESC   as BUSINESS_CENTRE_DESC
,P.PRODUCT_NAME           as PRODUCT_NAME
,NULL                     as WEBREACH_FLAG
,NULL                     as TYPE_ID
,NULL                     as TEMPLATE_FLAG
,PA.PLACEHOLDER_FLAG      as PLACEHOLDER_FLAG 
,PA.UDAC                  as PA_UDAC 
,PA.PUB_AD_CODE_DESC      as PUB_AD_CODE_DESC
,PA.COVER_FLAG            as COVER_FLAG   
,WE.UDAC                  as WE_UDAC  
from      $$Prefix.ADVERT               A
left join $$Prefix.WORK_ITEM            W   on A.WORKITEM_ID            = W.WORKITEM_ID   
left join $$Prefix.SALES_REPRESENTATIVE S   on A.CLIPPER_REP_CODE       = S.CLIPPER_REP_CODE
left join $$Prefix.PUB_AD_CODE          PA  on A.PUB_AD_CODE            = PA.PUB_AD_CODE 
                                           and A.PUBLISHER_ID           = PA.PUBLISHER_ID 
left join $$Prefix.BUSINESS_CENTRE      B   on A.BUSINESS_CENTRE_ID     = B.BUSINESS_CENTRE_ID
left join $$Prefix.PRODUCT              P   on P.PRODUCT_ID             = W.PRODUCT_ID 
                                           and P.WORKFLOW_DEFINITION_ID = W.WORKFLOW_DEFINITION_ID 
left join $$Prefix.WEBREACH             WE  on A.CLIPPER_WI_REF		    = WE.CLIPPER_WI_REF
where     A.LAST_MODIFIED > TO_TIMESTAMP ('$$last_adv_pull_date', 'YYYYDDMMHH24MISSFF') 
or        W.LAST_MODIFIED > TO_TIMESTAMP ('$$last_wrk_pull_date', 'YYYYDDMMHH24MISSFF')