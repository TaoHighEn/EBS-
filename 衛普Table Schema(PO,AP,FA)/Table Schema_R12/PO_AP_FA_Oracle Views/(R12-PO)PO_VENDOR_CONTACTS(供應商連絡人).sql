DROP VIEW APPS.PO_VENDOR_CONTACTS;

/* Formatted on 2013/11/18 10:30 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW apps.po_vendor_contacts (vendor_contact_id,
                                                      vendor_site_id,
                                                      last_update_date,
                                                      last_updated_by,
                                                      last_update_login,
                                                      creation_date,
                                                      created_by,
                                                      first_name,
                                                      middle_name,
                                                      last_name,
                                                      prefix,
                                                      title,
                                                      mail_stop,
                                                      area_code,
                                                      phone,
                                                      request_id,
                                                      program_application_id,
                                                      program_id,
                                                      program_update_date,
                                                      contact_name_alt,
                                                      first_name_alt,
                                                      last_name_alt,
                                                      department,
                                                      email_address,
                                                      url,
                                                      alt_area_code,
                                                      alt_phone,
                                                      fax_area_code,
                                                      fax,
                                                      inactive_date,
                                                      per_party_id,
                                                      relationship_id,
                                                      rel_party_id,
                                                      party_site_id,
                                                      org_contact_id,
                                                      org_party_site_id,
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
                                                      vendor_id
                                                     )
AS
   SELECT pvc.vendor_contact_id vendor_contact_id,
          pvs.vendor_site_id vendor_site_id,
          pvc.last_update_date last_update_date,
          pvc.last_updated_by last_updated_by,
          pvc.last_update_login last_update_login,
          pvc.creation_date creation_date, pvc.created_by created_by,
          SUBSTR (hp.person_first_name, 1, 15) first_name,
          SUBSTR (hp.person_middle_name, 1, 15) middle_name,
          SUBSTR (hp.person_last_name, 1, 15) last_name,
          NVL (hp.person_pre_name_adjunct, hp.salutation) prefix,
          SUBSTR (hp.person_title, 1, 30) title                   --Bug9215166
                                               ,
          hps.mailstop mail_stop,
          (SELECT hp2.primary_phone_area_code
             FROM hz_parties hp2
            WHERE pvc.rel_party_id = hp2.party_id
              AND hp2.primary_phone_line_type = 'GEN') area_code,
          (SELECT hp2.primary_phone_number
             FROM hz_parties hp2
            WHERE pvc.rel_party_id = hp2.party_id
              AND hp2.primary_phone_line_type = 'GEN') phone,
          pvc.request_id request_id,
          pvc.program_application_id program_application_id,
          pvc.program_id program_id,
          pvc.program_update_date program_update_date,
          hp.organization_name_phonetic contact_name_alt,
          hp.person_first_name_phonetic first_name_alt,
          hp.person_last_name_phonetic last_name_alt,
          hoc.department department, hp2.email_address email_address,
          hp2.url url,
          (SELECT hcp4.phone_area_code
             FROM hz_contact_points hcp4
            WHERE hcp4.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp4.owner_table_id
              AND hcp4.contact_point_type = 'PHONE'
              AND hcp4.phone_line_type = 'PHONE'
              AND hcp4.primary_flag = 'N'
              AND ROWNUM < 2) alt_area_code,
          (SELECT hcp7.phone_number
             FROM hz_contact_points hcp7
            WHERE hcp7.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp7.owner_table_id
              AND hcp7.contact_point_type = 'PHONE'
              AND hcp7.phone_line_type = 'PHONE'
              AND hcp7.primary_flag = 'N'
              AND ROWNUM < 2) alt_phone,
          (SELECT hcp5.phone_area_code
             FROM hz_contact_points hcp5
            WHERE hcp5.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp5.owner_table_id
              AND hcp5.contact_point_type = 'PHONE'
              AND hcp5.phone_line_type = 'FAX'
              /* AND HCP5.PRIMARY_FLAG = 'N' Commented for bug#9200951 */
              AND hcp5.status = 'A'                /* Added for bug#9200951 */
              AND ROWNUM < 2) fax_area_code,
          (SELECT hcp6.phone_number
             FROM hz_contact_points hcp6
            WHERE hcp6.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp6.owner_table_id
              AND hcp6.contact_point_type = 'PHONE'
              AND hcp6.phone_line_type = 'FAX'
              /* AND HCP6.PRIMARY_FLAG = 'N' Commented for bug#9200951 */
              AND hcp6.status = 'A'                /* Added for bug#9200951 */
              AND ROWNUM < 2) fax,
          LEAST (NVL (hpr.end_date, TO_DATE ('12/31/4712', 'MM/DD/RRRR')),
                 NVL (pvc.inactive_date, TO_DATE ('12/31/4712', 'MM/DD/RRRR'))
                ) inactive_date                              /* Bug 7551007 */
                               ,
          pvc.per_party_id per_party_id, pvc.relationship_id relationship_id,
          pvc.rel_party_id rel_party_id, pvc.party_site_id party_site_id,
          pvc.org_contact_id org_contact_id,
          pvc.org_party_site_id org_party_site_id, pvc.attribute_category,
          pvc.attribute1, pvc.attribute2, pvc.attribute3, pvc.attribute4,
          pvc.attribute5, pvc.attribute6, pvc.attribute7, pvc.attribute8,
          pvc.attribute9, pvc.attribute10, pvc.attribute11, pvc.attribute12,
          pvc.attribute13, pvc.attribute14, pvc.attribute15, pvs.vendor_id
     FROM ap_supplier_contacts pvc,
          ap_supplier_sites_all pvs,
          hz_parties hp,
          hz_relationships hpr,
          hz_party_sites hps,
          hz_org_contacts hoc,
          hz_parties hp2,
          ap_suppliers aps
    WHERE pvc.per_party_id = hp.party_id
      AND pvc.rel_party_id = hp2.party_id
      AND pvc.party_site_id = hps.party_site_id
      AND pvc.org_contact_id = hoc.org_contact_id(+)
      AND pvc.relationship_id = hpr.relationship_id
      AND hpr.directional_flag = 'F'
      AND pvs.party_site_id = pvc.org_party_site_id
      AND pvs.vendor_id = aps.vendor_id
      AND NVL (aps.vendor_type_lookup_code, 'DUMMY') <> 'EMPLOYEE'
   UNION
   SELECT pvc.vendor_contact_id vendor_contact_id,
          pvc.vendor_site_id vendor_site_id,
          pvc.last_update_date last_update_date,
          pvc.last_updated_by last_updated_by,
          pvc.last_update_login last_update_login,
          pvc.creation_date creation_date, pvc.created_by created_by,
          SUBSTR (hp.person_first_name, 1, 15) first_name,
          SUBSTR (hp.person_middle_name, 1, 15) middle_name,
          SUBSTR (hp.person_last_name, 1, 15) last_name,
          NVL (hp.person_pre_name_adjunct, hp.salutation) prefix,
          SUBSTR (hp.person_title, 1, 30) title                   --Bug9215166
                                               ,
          NULL mail_stop, hp2.primary_phone_area_code area_code,
          hp2.primary_phone_number phone, pvc.request_id request_id,
          pvc.program_application_id program_application_id,
          pvc.program_id program_id,
          pvc.program_update_date program_update_date,
          hp.organization_name_phonetic contact_name_alt,
          hp.person_first_name_phonetic first_name_alt,
          hp.person_last_name_phonetic last_name_alt,
          hoc.department department, hp2.email_address email_address,
          hp2.url url,
          (SELECT hcp4.phone_area_code
             FROM hz_contact_points hcp4
            WHERE hcp4.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp4.owner_table_id
              AND hcp4.contact_point_type = 'PHONE'
              AND hcp4.phone_line_type = 'PHONE'
              AND hcp4.primary_flag = 'N'
              AND ROWNUM < 2) alt_area_code,
          (SELECT hcp7.phone_number
             FROM hz_contact_points hcp7
            WHERE hcp7.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp7.owner_table_id
              AND hcp7.contact_point_type = 'PHONE'
              AND hcp7.phone_line_type = 'PHONE'
              AND hcp7.primary_flag = 'N'
              AND ROWNUM < 2) alt_phone,
          (SELECT hcp5.phone_area_code
             FROM hz_contact_points hcp5
            WHERE hcp5.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp5.owner_table_id
              AND hcp5.contact_point_type = 'PHONE'
              AND hcp5.phone_line_type = 'FAX'
              /* AND HCP5.PRIMARY_FLAG = 'N' Commented for bug#9200951 */
              AND hcp5.status = 'A'                /* Added for bug#9200951 */
              AND ROWNUM < 2) fax_area_code,
          (SELECT hcp6.phone_number
             FROM hz_contact_points hcp6
            WHERE hcp6.owner_table_name = 'HZ_PARTIES'
              AND pvc.rel_party_id = hcp6.owner_table_id
              AND hcp6.contact_point_type = 'PHONE'
              AND hcp6.phone_line_type = 'FAX'
              /* AND HCP6.PRIMARY_FLAG = 'N' Commented for bug#9200951 */
              AND hcp6.status = 'A'                /* Added for bug#9200951 */
              AND ROWNUM < 2) fax,
          hpr.end_date inactive_date, pvc.per_party_id per_party_id,
          pvc.relationship_id relationship_id, pvc.rel_party_id rel_party_id,
          pvc.party_site_id party_site_id, pvc.org_contact_id org_contact_id,
          pvc.org_party_site_id org_party_site_id, pvc.attribute_category,
          pvc.attribute1, pvc.attribute2, pvc.attribute3, pvc.attribute4,
          pvc.attribute5, pvc.attribute6, pvc.attribute7, pvc.attribute8,
          pvc.attribute9, pvc.attribute10, pvc.attribute11, pvc.attribute12,
          pvc.attribute13, pvc.attribute14, pvc.attribute15, aps.vendor_id
     FROM
          ap_supplier_contacts    pvc,
          hz_parties                      hp,
          hz_relationships           hpr,
          hz_org_contacts           hoc,
          hz_parties                     hp2,
          ap_suppliers                aps
    WHERE pvc.per_party_id = hp.party_id
      AND pvc.rel_party_id = hp2.party_id
      AND pvc.org_contact_id = hoc.org_contact_id(+)
      AND pvc.relationship_id = hpr.relationship_id
      AND hpr.directional_flag = 'F'
      AND pvc.org_party_site_id IS NULL
      AND pvc.vendor_site_id IS NULL
      AND hpr.object_id = aps.party_id
      AND hpr.relationship_code = 'CONTACT_OF'
      AND hpr.object_type = 'ORGANIZATION'
      AND NVL (aps.vendor_type_lookup_code, 'DUMMY') <> 'EMPLOYEE';
