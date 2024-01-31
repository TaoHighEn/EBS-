select
---legal entity
ood.legal_entity            legal_entity_id,
xep.name                    legal_entity_name,
---
---ledger
gll.name                    ledger_name,
gll.short_name              ledger_short_name, 
gll.currency_code           currency_code ,  --- ±b¥»¥»¹ô
--
-- operating unit
ood.operating_unit          operating_unit_id,  
hou.name                    operating_unit,
---
--inventory organization
mp.organization_id          organization_id ,
mp.organization_code        organization_code,
ood.organization_name       organization_name,   
mp.master_organization_id   master_organization_id ,  
mp_m.organization_code      master_org_code  
from 
mtl_parameters                mp_m,
xle_entity_profiles           xep,
gl_ledgers                   gll,
hr_operating_units            hou, 
org_organization_definitions  ood ,  
mtl_parameters                mp
where  1=1 
  and  mp.organization_id         =  ood.organization_id
  and  ood.operating_unit         =  hou.organization_id
  and  ood.set_of_books_id        =  gll.ledger_id
  and  ood.legal_entity           =  xep.legal_entity_id
  and  mp.master_organization_id  =  mp_m.organization_id 
order by ood.set_of_books_id, ood.organization_code