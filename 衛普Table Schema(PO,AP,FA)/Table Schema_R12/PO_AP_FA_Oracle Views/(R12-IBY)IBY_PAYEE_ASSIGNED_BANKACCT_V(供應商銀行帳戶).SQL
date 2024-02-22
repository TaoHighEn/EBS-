DROP VIEW APPS.IBY_PAYEE_ASSIGNED_BANKACCT_V;

/* Formatted on 2013/11/18 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW apps.iby_payee_assigned_bankacct_v (row_id,
                                                                 instr_assignment_id,
                                                                 payment_function,
                                                                 party_id,
                                                                 org_id,
                                                                 org_type,
                                                                 party_site_id,
                                                                 supplier_site_id,
                                                                 order_of_preference,
                                                                 start_date,
                                                                 end_date,
                                                                 ext_bank_account_id,
                                                                 currency_code,
                                                                 iban,
                                                                 account_number,
                                                                 bank_name,
                                                                 bank_number,
                                                                 branch_name,
                                                                 branch_number,
                                                                 bic_number,
                                                                 description,
                                                                 created_by,
                                                                 creation_date,
                                                                 last_updated_by,
                                                                 last_update_date,
                                                                 last_update_login
                                                                )
AS
   SELECT instr_assign.ROWID row_id,
          instr_assign.instrument_payment_use_id instr_assignment_id,
          payee.payment_function payment_function,
          payee.payee_party_id party_id, payee.org_id org_id,
          payee.org_type org_type, payee.party_site_id party_site_id,
          payee.supplier_site_id supplier_site_id,
          instr_assign.order_of_preference order_of_preference,
          instr_assign.start_date start_date, instr_assign.end_date end_date,
          bankacct.ext_bank_account_id ext_bank_account_id,
          bankacct.currency_code currency_code, bankacct.iban iban,
          bankacct.bank_account_num account_number,
          cebranch.bank_name bank_name, cebranch.bank_number bank_number,
          cebranch.bank_branch_name branch_name,
          cebranch.branch_number branch_number, bankacct.iban bic_number,
          bankacct.description description,
          instr_assign.created_by created_by,
          instr_assign.creation_date creation_date,
          instr_assign.last_updated_by last_updated_by,
          instr_assign.last_update_date last_update_date,
          instr_assign.last_update_login last_update_login
     FROM
          iby_pmt_instr_uses_all          instr_assign,
          iby_external_payees_all         payee,
          iby_ext_bank_accounts         bankacct,
          ce_bank_branches_v             cebranch
    WHERE instr_assign.instrument_id = bankacct.ext_bank_account_id
      AND instr_assign.ext_pmt_party_id = payee.ext_payee_id
      AND instr_assign.instrument_type = 'BANKACCOUNT'
      AND instr_assign.payment_flow = 'DISBURSEMENTS'
      AND bankacct.branch_id = cebranch.branch_party_id(+);
