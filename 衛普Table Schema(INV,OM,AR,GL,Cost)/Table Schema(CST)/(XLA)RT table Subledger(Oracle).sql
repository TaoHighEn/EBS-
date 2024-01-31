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
--mta
,b.RCV_TRANSACTION_ID 
,b.ACTUAL_FLAG 
,b.SET_OF_BOOKS_ID 
,b.ACCOUNTING_DATE 
,b.CODE_COMBINATION_ID 
,b.ACCOUNTED_DR 
,b.ACCOUNTED_CR 
,b.ENCUMBRANCE_TYPE_ID 
,b.ENTERED_DR 
,b.ENTERED_CR 
,b.BUDGET_VERSION_ID 
,b.CURRENCY_CONVERSION_DATE 
,b.USER_CURRENCY_CONVERSION_TYPE 
,b.CURRENCY_CONVERSION_RATE 
,b.TRANSACTION_DATE 
,b.PERIOD_NAME 
,b.FUNCTIONAL_CURRENCY_CODE 
,b.GL_SL_LINK_ID 
,b.ENTERED_REC_TAX 
,b.ENTERED_NR_TAX 
,b.ACCOUNTED_REC_TAX 
,b.ACCOUNTED_NR_TAX 
,b.RCV_SUB_LEDGER_ID 
,b.ACCOUNTING_EVENT_ID 
,b.ACCOUNTING_LINE_TYPE 
FROM xla_transaction_entities_upg ent,
xla_events e,
xla_distribution_links a,
rcv_receiving_sub_ledger b,
rcv_transactions rt,
xla_ae_headers ah,
xla_ae_lines al
WHERE rt.transaction_date BETWEEN :FROM_DATE AND :TO_DATE
AND rt.transaction_id = NVL(ent.source_id_int_1,-99)
AND ent.entity_code = 'RCV_ACCOUNTING_EVENTS'
AND ent.ledger_id = :LEDGER_ID
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
AND a.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
AND a.source_distribution_id_num_1 = b.rcv_sub_ledger_id
AND b.rcv_transaction_id= rt.transaction_id