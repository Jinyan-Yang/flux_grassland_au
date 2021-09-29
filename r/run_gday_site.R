# 
run.gday.site.func('model/stp_hufken/',alocation.model ='HUFKEN',q = 2.5,q_s = 0.2)
run.gday.site.func('model/stp_sgs/',alocation.model ='SGS',q = 1,q_s = 0)

run.gday.site.func('model/yan_sgs/',alocation.model ='SGS',q = 1,q_s = 0)
run.gday.site.func('model/yan_hufken/',alocation.model ='HUFKEN',q = 2.5,q_s = 0.2)

run.gday.site.func('model/ym_sgs/',alocation.model ='SGS',q = 1,q_s = 0)

run.gday.site.func('model/ym_hufken/',alocation.model ='HUFKEN',q = 0.2,q_s = 0.2,
                   af = 0.02,
                   decay.rate = 0.1*365)

