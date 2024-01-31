SELECT  
        wnd.NAME                    DELIVERY_NMAE , 
        ooh.ORDER_NUMBER            ORDER_NUMBER, 
        ool.LINE_NUMBER || '.' || ool.SHIPMENT_NUMBER
                                    ORDER_LINE,
        ool.ORDERED_ITEM            ORDER_ITEM,     ----- 訂單料號: 可能是CUSTOMER ITEM/INTERNAL ITEM
        wdd.PICKED_QUANTITY         PICKED_QUANTITY ,
        wdd.SHIPPED_QUANTITY        SHIPPED_QUANTITY,  
        wnd.STATUS_CODE             DELIVERY_STATUS_CODE , 
        wnd_status.MEANING          DELIVERY_STATUS , 
        wdd.RELEASED_STATUS         RELEASED_STATUS_CODE,
        pick_status.MEANING         RELEASED_STATUS 
  FROM 
        ( SELECT * FROM fnd_lookup_values WHERE lookup_type = 'PICK_STATUS' AND LANGUAGE = USERENV ('LANG') ) pick_status , 
        ( SELECT * FROM OE_LOOKUPS WHERE LOOKUP_TYPE = 'SHIPPING_STATUS')  wnd_status,
        WSH_NEW_DELIVERIES         wnd, 
        WSH_DELIVERY_ASSIGNMENTS   wda,
        OE_ORDER_HEADERS_ALL       ooh,
        OE_ORDER_LINES_ALL         ool,
        WSH_DELIVERY_DETAILS       wdd 
 WHERE  1=1
   AND  wdd.SOURCE_CODE            =  'OE'
   AND  wdd.SOURCE_LINE_ID         =  ool.LINE_ID
   AND  ool.HEADER_ID              =  ooh.HEADER_ID
   AND  wdd.DELIVERY_DETAIL_ID     =  wda.DELIVERY_DETAIL_ID
   AND  wda.DELIVERY_ID            =  wnd.DELIVERY_ID
   AND  wnd.STATUS_CODE            =  wnd_status.LOOKUP_CODE
   AND  wdd.RELEASED_STATUS        =  pick_status.LOOKUP_CODE