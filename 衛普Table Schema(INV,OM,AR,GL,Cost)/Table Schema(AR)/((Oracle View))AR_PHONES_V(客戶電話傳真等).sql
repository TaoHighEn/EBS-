DROP VIEW APPS.AR_PHONES_V;

/* Formatted on 2013/11/18 10:26 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW apps.ar_phones_v (row_id,
                                               phone_id,
                                               last_update_date,
                                               object_version,
                                               last_updated_by,
                                               creation_date,
                                               created_by,
                                               phone_number,
                                               status,
                                               phone_type,
                                               phone_type_meaning,
                                               last_update_login,
                                               customer_id,
                                               address_id,
                                               contact_id,
                                               country_code,
                                               area_code,
                                               extension,
                                               primary_flag,
                                               orig_system_reference,
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
                                               contact_point_type,
                                               owner_table_name,
                                               owner_table_id,
                                               telephone_type,
                                               TIME_ZONE,
                                               phone_touch_tone_type_flag,
                                               telex_number,
                                               web_type,
                                               attribute16,
                                               attribute17,
                                               attribute18,
                                               attribute19,
                                               attribute20,
                                               cust_contact_point_id,
                                               email_format,
                                               email_format_meaning,
                                               email_address,
                                               url,
                                               contact_point_purpose,
                                               contact_point_purpose_meaning,
                                               primary_by_purpose
                                              )
AS
   SELECT phon.ROWID, phon.contact_point_id, phon.last_update_date,
          phon.object_version_number, phon.last_updated_by,
          phon.creation_date, phon.created_by,
          DECODE (phon.contact_point_type,
                  'TLX', phon.telex_number,
                  phon.phone_number
                 ),
          phon.status, NVL (phon.phone_line_type, phon.contact_point_type),
          look.meaning, phon.last_update_login, NULL /* Customer ID */,
          NULL /* Address ID */, NULL /* Contact Id */,
          phon.phone_country_code, phon.phone_area_code, phon.phone_extension,
          phon.primary_flag, phon.orig_system_reference,
          phon.attribute_category, phon.attribute1, phon.attribute2,
          phon.attribute3, phon.attribute4, phon.attribute5, phon.attribute6,
          phon.attribute7, phon.attribute8, phon.attribute9, phon.attribute10,
          phon.attribute11, phon.attribute12, phon.attribute13,
          phon.attribute14, phon.attribute15, phon.contact_point_type,
          phon.owner_table_name, phon.owner_table_id, phon.telephone_type,
          phon.TIME_ZONE, phon.phone_touch_tone_type_flag, phon.telex_number,
          phon.web_type, phon.attribute16, phon.attribute17, phon.attribute18,
          phon.attribute19, phon.attribute20, NULL /* Cust_contact_point_id */,
          phon.email_format, look_format.meaning, phon.email_address,
          phon.url, phon.contact_point_purpose, look_purpose.meaning,
          phon.primary_by_purpose
     FROM hz_contact_points phon,
          ar_lookups look,
          ar_lookups look_format,
          ar_lookups look_purpose
    WHERE phon.contact_point_type NOT IN ('EDI')
      AND NVL (phon.phone_line_type, phon.contact_point_type) =
                                                              look.lookup_code
      AND (   (    look.lookup_type = 'COMMUNICATION_TYPE'
               AND look.lookup_code IN ('PHONE', 'TLX', 'EMAIL', 'WEB')
              )
           OR (look.lookup_type = 'PHONE_LINE_TYPE')
          )
      AND (phon.email_format = look_format.lookup_code(+)
           AND look_format.lookup_type(+) = 'EMAIL_FORMAT')
      AND (    phon.contact_point_purpose = look_purpose.lookup_code
           AND look_purpose.lookup_type IN
                       ('CONTACT_POINT_PURPOSE', 'CONTACT_POINT_PURPOSE_WEB')
          )
   UNION
   SELECT phon.ROWID, phon.contact_point_id, phon.last_update_date,
          phon.object_version_number, phon.last_updated_by,
          phon.creation_date, phon.created_by,
          DECODE (phon.contact_point_type,
                  'TLX', phon.telex_number,
                  phon.phone_number
                 ),
          phon.status, NVL (phon.phone_line_type, phon.contact_point_type),
          look.meaning, phon.last_update_login, NULL /* Customer ID */,
          NULL /* Address ID */, NULL /* Contact Id */,
          phon.phone_country_code, phon.phone_area_code, phon.phone_extension,
          phon.primary_flag, phon.orig_system_reference,
          phon.attribute_category, phon.attribute1, phon.attribute2,
          phon.attribute3, phon.attribute4, phon.attribute5, phon.attribute6,
          phon.attribute7, phon.attribute8, phon.attribute9, phon.attribute10,
          phon.attribute11, phon.attribute12, phon.attribute13,
          phon.attribute14, phon.attribute15, phon.contact_point_type,
          phon.owner_table_name, phon.owner_table_id, phon.telephone_type,
          phon.TIME_ZONE, phon.phone_touch_tone_type_flag, phon.telex_number,
          phon.web_type, phon.attribute16, phon.attribute17, phon.attribute18,
          phon.attribute19, phon.attribute20, NULL /* Cust_contact_point_id */,
          phon.email_format, look_format.meaning, phon.email_address,
          phon.url, phon.contact_point_purpose, NULL, NULL
     FROM 
           hz_contact_points    phon,
           ar_lookups               look, 
           ar_lookups               look_format
    WHERE phon.contact_point_type NOT IN ('EDI')
      AND NVL (phon.phone_line_type, phon.contact_point_type) =
                                                              look.lookup_code
      AND (   (    look.lookup_type = 'COMMUNICATION_TYPE'
               AND look.lookup_code IN ('PHONE', 'TLX', 'EMAIL', 'WEB')
              )
           OR (look.lookup_type = 'PHONE_LINE_TYPE')
          )
      AND (phon.email_format = look_format.lookup_code(+)
           AND look_format.lookup_type(+) = 'EMAIL_FORMAT')
      AND phon.contact_point_purpose IS NULL;

