SELECT 
        ool.line_id                         LINE_ID,  
        hou.NAME                            OU_NAME ,
        ool.FLOW_STATUS_CODE                STATUS ,
        ooh.ORDER_NUMBER                    ORDER_NUMBER,
        ottt.NAME                           ORDER_TYPE ,  
        to_char(ooh.ORDERED_DATE,'YYYY/MM/DD')
                                            SO_DATE,    ----XML (Excel)避免不同Profile設定解讀出錯誤的日期
        nvl( ool.CUST_PO_NUMBER , ooh.CUST_PO_NUMBER )
                                            CUST_PO , 
        to_char( ool.LINE_NUMBER ) || '.' || to_char( ool.SHIPMENT_NUMBER )
                                            SO_LINE,
        '="' || msi.SEGMENT1  || '"'                   ----XML(Excel) 避免'0'開頭的料號, 會被系統認為是數字而不顯示
                                            ITEM_NUMBER, 
        msi.DESCRIPTION                     ITEM_DESCRIPTION , 
        msi.ITEM_TYPE                       ITEM_TYPE ,   
        to_char(ool.SCHEDULE_SHIP_DATE ,'YYYY/MM/DD') 
                                            SCHEDULE_SHIP_DATE , 
        ooh.TRANSACTIONAL_CURR_CODE         SO_CURRENCY_CODE, 
        decode( ool.LINE_CATEGORY_CODE
              , 'RETURN' , ool.ORDERED_QUANTITY * -1
              , ool.ORDERED_QUANTITY 
              )                             QUANTITY ,
        ool.UNIT_SELLING_PRICE              UNIT_SELLING_PRICE, 
        decode( ool.LINE_CATEGORY_CODE
              , 'RETURN' , ool.SHIPPED_QUANTITY * -1
              , ool.SHIPPED_QUANTITY
              )                             SHIPPED_QTY , 
        decode( ool.LINE_CATEGORY_CODE
              , 'RETURN' , ool.ORDERED_QUANTITY * -1
              , ool.ORDERED_QUANTITY 
              )  -
        decode( ool.LINE_CATEGORY_CODE
              , 'RETURN' , ool.SHIPPED_QUANTITY * -1
              , ool.SHIPPED_QUANTITY
              )                             BACKLOG_QTY ,  
        ool.TAX_CODE                        TAX_CODE ,  
        jrs.NAME                            SALES_PERSON, 

--- BILL TO / SHIP TO  
        bill_hp.PARTY_NAME                  BILL_TO_CUSTOMER_NAME ,
        bill.ACCOUNT_NUMBER                 BILL_TO_CUSTOMER_NUMBER, 
        bill.CUSTOMER_CLASS_CODE            BILL_TO_CUSTOMER_CLASS,       
        ship_hp.PARTY_NAME                  SHIP_TO_CUSTOMER_NAME ,
        ship.ACCOUNT_NUMBER                 SHIP_TO_CUSTOMER_NUMBER ,
        ship.CUSTOMER_CLASS_CODE            SHIP_TO_CUSTOMER_CLASS, 
        bill_hp.COUNTRY                     BILL_COUNTRY,
        bill_hp.STATE                       BILL_STATE,
        bill_hp.COUNTY                      BILL_COUNTY,
        bill_hp.CITY                        BILL_CITY,
        nvl(ship_hp.COUNTRY,'[NULL]')       SHIP_COUNTRY,
        nvl(ship_hp.STATE,'[NULL]')         SHIP_STATE,
        ship_hp.COUNTY                      SHIP_COUNTY, 
        ship_hp.CITY                        SHIP_CITY 

  FROM  
        HZ_PARTIES                    ship_hp,
        HZ_CUST_ACCOUNTS              ship ,  
        HZ_CUST_ACCT_SITES_ALL        hcas_s,   --- SHIP TO
        HZ_CUST_SITE_USES_ALL         hcsu_s,   --- SHIP TO
          
        HZ_PARTIES                    bill_hp,
        HZ_CUST_ACCOUNTS              bill ,  
        HZ_CUST_ACCT_SITES_ALL        hcas_b,   --- BILL TO
        HZ_CUST_SITE_USES_ALL         hcsu_b,   --- BILL TO   
----
        MTL_SYSTEM_ITEMS_B            msi ,
        JTF_RS_SALESREPS              jrs ,
        OE_ORDER_LINES_ALL            ool ,
        HR_OPERATING_UNITS            hou ,   
        OE_SYSTEM_PARAMETERS_ALL      osp , 
        OE_TRANSACTION_TYPES_TL       ottt , 
        OE_TRANSACTION_TYPES_ALL      ott ,
        OE_ORDER_HEADERS_ALL          ooh 

 WHERE  1=1
   AND  ooh.ORDERED_DATE        >=  :P_DATE
   AND  ooh.ORG_ID               =  nvl(:P_ORG_ID , ooh.ORG_ID) 
   AND  ooh.ORDER_TYPE_ID        =  ott.TRANSACTION_TYPE_ID 
   AND  ott.TRANSACTION_TYPE_ID  =  ottt.TRANSACTION_TYPE_ID 
   AND  ottt.LANGUAGE            =  USERENV ('LANG') 
   AND  ott.TRANSACTION_TYPE_CODE   = 'ORDER' 
   AND  ooh.ORG_ID               =  osp.ORG_ID 
   AND  ooh.ORG_ID               =  hou.ORGANIZATION_ID
   AND  ooh.HEADER_ID            =  ool.HEADER_ID 
   AND  NVL(ool.CANCELLED_FLAG,'N') = 'N' 
   AND  ool.SALESREP_ID          =  jrs.SALESREP_ID(+)
   AND  ool.ORG_ID               =  jrs.ORG_ID(+) 
   AND  ool.INVENTORY_ITEM_ID    =  msi.INVENTORY_ITEM_ID
   AND  msi.ORGANIZATION_ID      =  nvl( ool.SHIP_FROM_ORG_ID , osp.MASTER_ORGANIZATION_ID )  --- BILL TO 可以不指定 WAREHOUSE  
   
----  BILL TO  
   AND  ool.INVOICE_TO_ORG_ID    =  hcsu_b.SITE_USE_ID(+)
   AND  hcsu_b.CUST_ACCT_SITE_ID =  hcas_b.CUST_ACCT_SITE_ID(+)
   AND  hcas_b.cust_account_id   =  bill.CUST_ACCOUNT_ID(+)
   AND  bill.PARTY_ID            =  bill_hp.PARTY_ID(+)

-- SHIP TO 
   AND  ool.SHIP_TO_ORG_ID       =  hcsu_s.SITE_USE_ID(+)
   AND  hcsu_s.CUST_ACCT_SITE_ID =  hcas_s.CUST_ACCT_SITE_ID(+)
   AND  hcas_s.cust_account_id   =  ship.CUST_ACCOUNT_ID(+)
   AND  ship.PARTY_ID            =  ship_hp.PARTY_ID(+)
    