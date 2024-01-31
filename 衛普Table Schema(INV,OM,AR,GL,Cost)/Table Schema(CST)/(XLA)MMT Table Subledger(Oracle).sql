SELECT /*+INDEX(ah XLA_AE_HEADERS_N2)
INDEX (al XLA_AE_LINES_U1)
INDEX(a XLA_DISTRIBUTION_LINKS_N3) */
--ae_lines
al.AE_HEADER_ID 
,al.AE_LINE_NUM 
,al.CODE_COMBINATION_ID 
,al.GL_TRANSFER_MODE_CODE 
,al.GL_SL_LINK_ID 
,al.ACCOUNTING_CLASS_CODE 
,al.ENTERED_DR 
,al.ENTERED_CR 
,al.ACCOUNTED_DR 
,al.ACCOUNTED_CR 
,al.CURRENCY_CODE 
,al.CURRENCY_CONVERSION_DATE 
,al.CURRENCY_CONVERSION_RATE 
,al.CURRENCY_CONVERSION_TYPE 
,al.GL_SL_LINK_TABLE 
,al.BUSINESS_CLASS_CODE 
--distribution_link
,a.SOURCE_DISTRIBUTION_TYPE 
,a.SOURCE_DISTRIBUTION_ID_NUM_1 
,a.ACCOUNTING_LINE_CODE 
,a.LINE_DEFINITION_CODE 
,a.EVENT_CLASS_CODE 
,a.EVENT_TYPE_CODE 
,a.UPG_BATCH_ID 
--entity
,ent.ENTITY_ID 
,ent.ENTITY_CODE 
,ent.SOURCE_ID_INT_1 
,ent.SOURCE_ID_INT_2 
,ent.SECURITY_ID_INT_1 
,ent.TRANSACTION_NUMBER 
--rrsl
,b.TRANSACTION_ID 
,b.REFERENCE_ACCOUNT 
,b.ORGANIZATION_ID 
,b.TRANSACTION_DATE 
,b.TRANSACTION_SOURCE_ID 
,b.TRANSACTION_SOURCE_TYPE_ID 
,b.TRANSACTION_VALUE 
,b.GL_BATCH_ID 
,b.ACCOUNTING_LINE_TYPE 
,b.BASE_TRANSACTION_VALUE 
,b.COST_ELEMENT_ID 
,b.CURRENCY_CODE 
,b.CURRENCY_CONVERSION_DATE 
,b.CURRENCY_CONVERSION_TYPE 
,b.CURRENCY_CONVERSION_RATE 
,b.GL_SL_LINK_ID 
,b.INV_SUB_LEDGER_ID 
FROM xla_transaction_entities_upg ent,
xla_events e,
xla_distribution_links a,
mtl_transaction_accounts b,
mtl_material_transactions mmt,
xla_ae_headers ah,
xla_ae_lines al
WHERE mmt.transaction_date BETWEEN :p_date_from  AND  :p_date_to
AND mmt.transaction_id = NVL(ent.source_id_int_1,-99)
AND ent.entity_code = 'MTL_ACCOUNTING_EVENTS'
AND ent.ledger_id = :ledger_id
AND ent.application_id = 707
AND ent.entity_id = e.entity_id
AND e.application_id = 707
AND e.event_id = a.event_id
AND ah.application_id = 707
AND ah.entity_id = ent.entity_id
AND ah.event_id = e.event_id
AND ah.ledger_id = ent.ledger_id
AND ah.ae_header_id = al.ae_header_id
AND al.application_id = 707
AND al.ledger_id = ah.ledger_id
AND al.AE_HEADER_ID = a.AE_HEADER_ID
AND al.AE_LINE_NUM = a.AE_LINE_NUM
AND a.application_id = 707
AND a.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
AND a.source_distribution_id_num_1 = b.inv_sub_ledger_id
AND b.transaction_id = mmt.transaction_id