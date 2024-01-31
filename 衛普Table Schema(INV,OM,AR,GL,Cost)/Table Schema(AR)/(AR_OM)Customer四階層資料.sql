SELECT   
---- party(organization) information 
        hp.party_name               organization_name,
        hp.known_as                 organization_alias,
-----
---- account information 
        hca.account_name            account_name ,
        hca.account_number          account_number,  
-----
--- site information
        hcas.org_id                 org_id , 
        hou.name                    ou_name,
        hcas.status                 site_status, 
        hcas.bill_to_flag           site_bill_to_flag,
        hcas.ship_to_flag           site_ship_to_flag,
        hl.address1                 site_address1,
        hl.address2                 site_address2,
        hl.address3                 site_address3,
        hl.address4                 site_address4,
        hl.ADDRESS_LINES_PHONETIC   site_alternate_name,
--------
----- site usage information
        hcsu.site_use_code          site_use_code,
        hcsu.primary_flag           site_use_primary_flag,
        hcsu.status                 site_use_status,
        hcsu.location               site_use_location ,
---------
---- OTHER ID INFORMATION 
        hp.party_id                 party_id ,             --第一層
        hca.cust_account_id         cust_account_id,       --第二層
        hcas.cust_acct_site_id      cust_acct_site_id ,    --第三層
        hcsu.site_use_id            site_use_id            --第四層
  FROM  
        hr_operating_units         hou,
        hz_locations               hl , 
        hz_party_sites             hps ,
------
        hz_parties                 hp ,      ---organizatio
        hz_cust_accounts           hca ,     ---account
        hz_cust_acct_sites_all     hcas ,    ---address(site)
        hz_cust_site_uses_all      hcsu      ---address(site) business purpose(ex: Bill To/Ship To)
 WHERE  1=1
   AND  hcsu.cust_acct_site_id    =  hcas.cust_acct_site_id  
   AND  hcas.party_site_id        =  hps.party_site_id(+)
   AND  hps.location_id           =  hl.location_id(+)
   AND  hcas.cust_account_id      =  hca.cust_account_id
   AND  hcas.org_id               =  hou.organization_id(+)
   AND  hca.party_id              =  hp.party_id
   and  hp.party_name             =  'FULY Customer 001(Party)'
---
   and  hps.party_id  = hca.party_id   -----新增此一條件!!