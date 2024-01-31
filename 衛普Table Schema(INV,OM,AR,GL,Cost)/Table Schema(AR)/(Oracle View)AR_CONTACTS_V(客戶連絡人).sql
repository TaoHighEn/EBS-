DROP VIEW APPS.AR_CONTACTS_V;

/* Formatted on 2013/11/18 10:24 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW apps.ar_contacts_v (row_id,
                                                 contact_id,
                                                 customer_id,
                                                 address_id,
                                                 last_update_date,
                                                 object_version,
                                                 last_updated_by,
                                                 creation_date,
                                                 created_by,
                                                 last_update_login,
                                                 title,
                                                 title_meaning,
                                                 first_name,
                                                 last_name,
                                                 first_name_alt,
                                                 last_name_alt,
                                                 status,
                                                 job_title,
                                                 job_title_code,
                                                 job_title_code_meaning,
                                                 mail_stop,
                                                 orig_system_reference,
                                                 contact_key,
                                                 attribute_category,
                                                 attribute1,
                                                 attribute2,
                                                 attribute3,
                                                 attribute4,
                                                 attribute5,
                                                 attribute6,
                                                 attribute7,
                                                 attribute8,
                                                 attribute9,
                                                 attribute10,
                                                 attribute11,
                                                 attribute12,
                                                 attribute13,
                                                 attribute14,
                                                 attribute15,
                                                 attribute16,
                                                 attribute17,
                                                 attribute18,
                                                 attribute19,
                                                 attribute20,
                                                 attribute21,
                                                 attribute22,
                                                 attribute23,
                                                 attribute24,
                                                 attribute25,
                                                 email_address,
                                                 contact_party_id,
                                                 org_contact_id,
                                                 contact_point_id,
                                                 contact_number,
                                                 cont_res_last_update_date,
                                                 per_lang_last_update_date,
                                                 per_lang_object_version,
                                                 cont_point_last_update_date,
                                                 cont_point_object_version,
                                                 party_last_update_date,
                                                 party_object_version,
                                                 rel_last_update_date,
                                                 org_cont_last_update_date,
                                                 org_cont_object_version,
                                                 party_relationship_id,
                                                 rel_party_last_update_date,
                                                 rel_party_object_version,
                                                 rel_party_id,
                                                 relation_object_version
                                                )
AS
   SELECT acct_role.ROWID row_id, acct_role.cust_account_role_id contact_id,
          acct_role.cust_account_id customer_id,
          acct_role.cust_acct_site_id address_id,
          acct_role.last_update_date last_update_date,
          acct_role.object_version_number object_version,
          acct_role.last_updated_by last_updated_by,
          acct_role.creation_date creation_date,
          acct_role.created_by created_by,
          acct_role.last_update_login last_update_login,
          party.person_pre_name_adjunct title,
          arpt_sql_func_util.get_lookup_meaning
                                 ('CONTACT_TITLE',
                                  party.person_pre_name_adjunct
                                 ) title_meaning,
          SUBSTRB (party.person_first_name, 1, 40) first_name,
          SUBSTRB (party.person_last_name, 1, 50) last_name,
          NULL first_name_alt, NULL last_name_alt, acct_role.status,
          org_cont.job_title job_title,
          org_cont.job_title_code job_title_code,
          NVL (arpt_sql_func_util.get_lookup_meaning ('RESPONSIBILITY',
                                                      org_cont.job_title_code
                                                     ),
               org_cont.job_title
              ),
          org_cont.mail_stop mail_stop,
          acct_role.orig_system_reference orig_system_reference,
          party.customer_key contact_key,
          acct_role.attribute_category attribute_category,
          acct_role.attribute1 attribute1, acct_role.attribute2 attribute2,
          acct_role.attribute3 attribute3, acct_role.attribute4 attribute4,
          acct_role.attribute5 attribute5, acct_role.attribute6 attribute6,
          acct_role.attribute7 attribute7, acct_role.attribute8 attribute8,
          acct_role.attribute9 attribute9, acct_role.attribute10 attribute10,
          acct_role.attribute11 attribute11,
          acct_role.attribute12 attribute12,
          acct_role.attribute13 attribute13,
          acct_role.attribute14 attribute14,
          acct_role.attribute15 attribute15,
          acct_role.attribute16 attribute16,
          acct_role.attribute17 attribute17,
          acct_role.attribute18 attribute18,
          acct_role.attribute19 attribute19,
          acct_role.attribute20 attribute20,
          acct_role.attribute21 attribute21,
          acct_role.attribute22 attribute22,
          acct_role.attribute23 attribute23,
          acct_role.attribute24 attribute24,
          acct_role.attribute25 attribute25, rel_party.email_address,
          party.party_id, org_cont.org_contact_id,
          cont_point.contact_point_id, org_cont.contact_number,
          NULL /*CONT_RES.LAST_UPDATE_DATE bug 4235168*/,
          per_lang.last_update_date, per_lang.object_version_number,
          cont_point.last_update_date, cont_point.object_version_number,
          party.last_update_date, party.object_version_number,
          rel.last_update_date, org_cont.last_update_date,
          org_cont.object_version_number, rel.relationship_id,
          rel_party.last_update_date, rel_party.object_version_number,
          rel_party.party_id, rel.object_version_number
     FROM 
/* HZ_CUST_ACCOUNT_ROLES CONT, HZ_PARTIES CONT_PARTY, HZ_PARTY_RELATIONSHIPS CONT_REL, HZ_RELATIONSHIPS CONT_REL, HZ_ORG_CONTACTS CONT_ORG, HZ_PARTIES CONT_REL_PARTY, HZ_PARTY_RELATIONSHIPS REL, HZ_CUST_ACCOUNTS CONT_ROLE_ACCT, HZ_CONTACT_RESTRICTIONS CONT_RES, HZ_PERSON_LANGUAGE PER_LANG AR_LOOKUPS L, AR_LOOKUPS L1,*/ 
           hz_contact_points cont_point,
           hz_cust_account_roles acct_role,
           hz_parties party,
           hz_parties rel_party,
           hz_relationships rel,
           hz_org_contacts org_cont,
           hz_cust_accounts role_acct, /* HZ_CONTACT_RESTRICTIONS CONT_RES, bug 4235168*/
           hz_person_language per_lang
    WHERE acct_role.party_id = rel.party_id
      AND acct_role.role_type = 'CONTACT'
      AND org_cont.party_relationship_id = rel.relationship_id
      AND rel.subject_id = party.party_id
      AND rel_party.party_id = rel.party_id
      AND cont_point.owner_table_id(+) = rel_party.party_id
      AND cont_point.contact_point_type(+) = 'EMAIL'
      AND cont_point.primary_flag(+) = 'Y'
      AND acct_role.cust_account_id = role_acct.cust_account_id
      AND role_acct.party_id = rel.object_id
      AND party.party_id = per_lang.party_id(+)
      AND per_lang.native_language(+) =
             'Y' /* AND PARTY.PARTY_ID = CONT_RES.SUBJECT_ID(+) bug 4235168*/ /* AND CONT_RES.SUBJECT_TABLE(+) = 'HZ_PARTIES' bug 4235168*/ /******************* Bug Fix Begin:3477266 **************************/
      AND cont_point.owner_table_name(+) =
             'HZ_PARTIES'
/******************* Bug Fix End:3477266 **************************/
/* CONT_ORG.TITLE = L.LOOKUP_CODE AND L.LOOKUP_TYPE(+) = 'CONTACT_TITLE' AND ORG_CONT.JOB_TITLE_CODE = L1.LOOKUP_CODE(+) AND L1.LOOKUP_TYPE(+ = 'RESPONSIBILITY' AND CONT_ORG.JOB_TITLE_CODE = L1.LOOKUP_CODE(+) AND CONT.CUST_ACCOUNT_ROLE_ID = ACCT_ROLE.CUST_ACCOUNT_ROLE_ID AND CONT.PARTY_ID = CONT_REL.PARTY_ID AND CONT.ROLE_TYPE = 'CONTACT' AND CONT_ORG.PARTY_RELATIONSHIP_ID = CONT_REL.RELATIONSHIP_ID AND CONT_REL.SUBJECT_ID = CONT_PARTY.PARTY_ID AND CONT_REL.PARTY_ID = CONT_REL_PARTY.PARTY_ID AND PARTY.PARTY_ID = PER_LANG.PARTY_ID(+) AND PER_LANG.NATIVE_LANGUAGE(+) = 'Y' AND CONT_POINT.OWNER_TABLE_ID(+) = REL_PARTY.PARTY_ID AND CONT_POINT.CONTACT_POINT_TYPE(+) = 'EMAIL' AND CONT_POINT.PRIMARY_FLAG(+) = 'Y' AND PARTY.PARTY_ID = CONT_RES.SUBJECT_ID(+) AND CONT_RES.SUBJECT_TABLE(+) = 'HZ_PARTIES' AND CONT.CUST_ACCOUNT_ID = CONT_ROLE_ACCT.CUST_ACCOUNT_ID AND CONT_ROLE_ACCT.PARTY_ID = CONT_REL.OBJECT_ID */
                         ;

