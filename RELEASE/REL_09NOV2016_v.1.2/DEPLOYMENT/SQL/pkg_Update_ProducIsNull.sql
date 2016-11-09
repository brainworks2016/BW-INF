CREATE or REPLACE PACKAGE BODY pkg_Update_ProductIsNull
IS
procedure sp_Update_ProductIsNull
as    
   value                 varchar2(32 byte);
   row_num               number(10);
                                                                   --Create cursor on STG_ADVERT with Increamental Load
    cursor C_STG_ADVERT is
    select   AD_ID
            ,SOURCE
            ,CLIPPER_VERSION 
            ,PUB_AD_CODE_DESC
            ,PLACEHOLDER_FLAG
            ,COVER_FLAG
            ,TEMPLATE_FLAG
            ,WEBREACH_FLAG
            ,TYPE_ID
            ,PA_UDAC
            ,WE_UDAC
    from     STG_ADVERT
    where    product_name is NULL and BATCHNUM=(select max(BATCHNUM) from STG_ADVERT);
begin
                                                               ---fetch record  row by row
   row_num:=0;                                                  --row_num is set ziro
        for row in  C_STG_ADVERT loop                         --start loop
        
        if(row.SOURCE='ADV')  then                             --- this if block set ADVERT record values        
            if( row.PLACEHOLDER_FLAG=3)then 
             value:='custweb';            
            elsif( row.PLACEHOLDER_FLAG=1)then 
             value:='profile_page';
            elsif( row.PLACEHOLDER_FLAG=5)then 
             value:='rich_media_banner';
            elsif( row.PLACEHOLDER_FLAG=5)then 
             value:='rich_media_banner';
            elsif( row.PLACEHOLDER_FLAG=2 )then 
               if(row.PA_UDAC in ('NVC', 'NNVC'))then
                 value:='customer_supp_vid';
               elsif(row.PA_UDAC in ('NPM', 'NNPM'))then
                  value:='photomotion';
               elsif(row.PA_UDAC in ('NVS', 'NNVS'))then
                  value:='stock_video';
               end if;
            elsif( row.PLACEHOLDER_FLAG=4 and row.PA_UDAC in ('NV3', 'NV6', 'NNV3', 'NNV6') )then 
               value:='vendor_supp_vid'; 
            elsif( row.PLACEHOLDER_FLAG=6 )then 
               value:='direct_mail';
            elsif( instr(row.PUB_AD_CODE_DESC,'coupon')>0)then 
               value:='coupon';         
            elsif( row.COVER_FLAG=1 )then 
               value:='cover';     
      	    elsif( instr(row.PUB_AD_CODE_DESC,'half space')>0)then 
                value:='hs';
	          elsif( instr(row.PUB_AD_CODE_DESC,'menu')>0)then 
                value:='menu';
            elsif( instr(row.PUB_AD_CODE_DESC,'trade_mark')>0)then 
                value:='tm';
            elsif( row.WE_UDAC in ('MICRO', 'MICRO-R') )then 
                value:='webreach_micro';
            elsif( row.WE_UDAC in ('MIRROR', 'MIRROR-R') )then 
                value:='webreach_mirrored';      
            elsif( row.WE_UDAC in ('NV3', 'NV6', 'NNV3', 'NNV6') )then 
                value:='webreach_conversion';      
            else
                   value:='display';                                  --default set value value
            end if;                                                   ---END if 
        else                                                          --this else block set spec_visual record values       
            if( row.WEBREACH_FLAG=1 )then 
                value:='webreach_lite';
            elsif( row.TYPE_ID=1)then 
                value:='spec_standard';
            elsif( row.TYPE_ID=2)then 
               value:='spec_rush';
            elsif( row.TYPE_ID=3)then 
                value:='spec_express';
            elsif( row.TYPE_ID=4)then 
                value:='spec_premium';
            elsif( row.TYPE_ID=4)then 
                 value:='spec_premium';
            elsif( row.TYPE_ID=6)then 
                value:='spec_virtual_studio';
            elsif( row.TEMPLATE_FLAG=1)then 
                value:='spec_template';
            elsif( row.WE_UDAC in ('MICRO', 'MICRO-R') )then 
                value:='webreach_micro';
            elsif( row.WE_UDAC in ('MIRROR', 'MIRROR-R') )then 
                value:='webreach_mirrored';      
            elsif( row.WE_UDAC in ('NV3', 'NV6', 'NNV3', 'NNV6') )then 
                value:='webreach_conversion';      
            else
                   value:='display';                             --default set values value
            end if;    
      end if;                                                    ----  end if
      
        
        update STG_ADVERT 
        set PRODUCT_NAME=value 
        where AD_ID=row.AD_ID and CLIPPER_VERSION=row.CLIPPER_VERSION;  
      
      row_num:=row_num+SQL%ROWCOUNT;
      if(row_num=10000)then
	     row_num:=0;
         commit;                                               --commit per 1000 row
      end if;   
              
    end loop;
     dbms_output.put_line('NUMBER OF UPDATED ROW = ' || SQL%ROWCOUNT||'NUMBER OF selected ROW = '|| row_num);
    commit;                                                    -----commit at the end
   
             EXCEPTION                                        -- exception handlers begin
         
             WHEN OTHERS THEN                                 -- handles all other errors
             ROLLBACK;
         
   
end;

END;
/