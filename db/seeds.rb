# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

lead_id_1210 = %{
 --conv_summary_uk_(lead_id)_09-21-09.sql

--9/26/2008 - added bank wizard (Marina)
--8/26/2008 - added debit card (pasted in issued from previous query)
--4/28/2008 - commented out internal providers (Marina)
--04/28/2008- added profitability offset and calculated profitability (Mstaton)
--SET LOCAL enable_bitmapscan=off;
--12/6/2012 - updated to improve performance(skhodukin)
SELECT DISTINCT
c.id as cust_id,
CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd))
in ('1','2','3','4','5','6','7','8','9')THEN c_s.source_type_cd ELSE c_s.group_cd END as source,

--c_s.source_type_cd as provider

--Lead Info
first(c_s.received_time) as received_time,
first(ml.created_on) as ml_created,
first(cc.created_on)as share_report_created,
first(icp.created_on) as icp_created,
first(tt.created_on) as tt_created,
first(bw.created_on) as bw_created,
first(c_s.type_cd) as type_cd ,
first(ap.amount) as approval,
first(c_s.sub_type_cd) as sub_type_cd,
first(c_s.confirmed_on) as confirmed,
min(case when c_s.type_cd in ('import','pass_active_customer', 'lead_reject_import') then l.created_on end) AS applied,
min(case when c_s.type_cd in ('import','pass_active_customer', 'lead_reject_import')
and l.status_cd not in ('declined','withdrawn','on_hold','applied')
then 'issued' end) AS issued,
first(ddi.signed_on) as ddi_signed_on,
first(pi.created_on) as credit_card_created_on,
first(c_s.group_cd) as group_cd,
first(ap.profitability_rate) as prft,
first(c.status_cd) as status,
'https://www.quickquid.co.uk/confirmation-'||first(c_s.source_type_cd)||'/'||first(c_s.remote_source_num)||'.html' as confirm_page,
first(c_s.lead_source) as lead_source,

first(yaml_field(c_s.lead_text,'bank_account_number')) as bank_account_number,
first(yaml_field(lead_text,'loan_amount_requested')) as loan_amount_requested,
first(yaml_field(c_s.lead_text,'home_phone_mobile')) as home_phone_mobile,
first(yaml_field(c_s.lead_text,'income_payment_period')) as income_payment_period,
first(yaml_field(c_s.lead_text,'email')) as lead_text_email,
c_s.id as cust_source_id,
first(c.created_on) as cust_created,

--#Comment in for lead text
--first(c_s.lead_text) as lead_text,

--#Provisions
first(ap.auto_action_cd) as auto_action_cd,
first(ap.reason_cd) as reason_cd,
min(c_s.created_on)-min(c_s.received_time) as cust_time,
min(c_s.created_on) -min(ml.created_on) as ml_time,
min(c_s.created_on) - min(cc.created_on) as share_report_time,
min(c_s.created_on)- min(icp.created_on) as icp_time,
min(c_s.created_on)- min(tt.created_on) as tt_time,
min(c_s.created_on)- min(bw.created_on) as bw_time,

--Loan Info
first(ap.risk_limit) as risk_limit,
first(ap.model_amount) as model_amount,
first(ap.amount) as final_amount,
first(c.email) as email ,
-------
first(c_s.profitability_offset) as profitability_offset,
COALESCE(first(ap.profitability_rate),0)+COALESCE(first(c_s.profitability_offset),0)
as calc_profitability,
first(c.fraud_flg) as fraud_flg



FROM
customer_sources c_s
left outer join customers c on c.id = c_s.customer_id and c.income_payment_cd is not null
left outer join people p on c.person_id=p.id
left outer join people_addresses pa on p.id = pa.person_id
left outer join addresses a on pa.address_id = a.id and a.eff_end_date is null
--LEFT OUTER JOIN loans l ON l.id = (SELECT max(id)
--FROM loans ll
--WHERE c.id = ll.customer_id AND
--ll.requested_time between c_s.received_time and c_s.received_time + interval '8 days'
--and ll.loan_type_cd in ('cso','payday')
--)
left outer join loans l on l.loan_type_cd in ('oec','payday')
                       and l.customer_source_id = c_s.id 
                       and l.customer_source_link_type_id is not null
                       and l.customer_id = c.id
LEFT OUTER JOIN loans l3 ON c.id =l3.customer_id and l3.loan_type_cd in ('oec','payday')
LEFT OUTER JOIN approvals ap on ap.id = (SELECT max(id)
FROM approvals lap
WHERE lap.customer_id = c.id
AND lap.processed_on BETWEEN c_s.received_time - interval '8 days' and c_s.received_time + interval '1 hour'
)
left outer join callml_reports ml on ml.id = ap.callml_report_id
left outer join callicp_reports icp on icp.id = ap.callicp_report_id
left outer join callcredit_reports cc on cc.id = ap.callcredit_report_id
left join credit_reports tt on tt.id=(select min(id) FROM
credit_reports where c_s.customer_id=customer_id and report_type_cd='teletrack_uk'
and inquiry_time <= c_s.received_time + interval '27 seconds')
left outer join bank_wizard_absolute_reports bw on bw.id = ap.bank_wizard_absolute_report_id
left outer join ddis ddi on c.id = ddi.customer_id
and ((ddi.eff_end_date is null or ddi.eff_end_date>=l.requested_time) and l.requested_time is not null)

left outer join payment_instruments.payment_instruments pi on pi.person_id=c.person_id 
and payment_instrument_type_id=1
and pi.payment_instrument_status_id=1
--left outer join approvals ap_2 on ap_2.customer_id = ap.customer_id
--and ap_2.processed_on > ddi.created_on
--and ap_2.id>ap.id
--left outer join approvals ap1_2 on ap1_2.customer_id = ap_2.customer_id
--and ap1_2.processed_on > ddi.created_on
--and ap1_2.id>ap.id and ap1_2.id<ap_2.id

-- # testing for actives w/ out import
-- left outer join customer_sources c_s1 on c_s1.customer_id = c_s.customer_id and c_s1.type_cd in ('import','pass_active_customer')and c_s1.id > c_s.id

WHERE
c_s.incoming_brand_id <>'11' and
c_s.received_time >= timestamp '2013-11-01 00:00:00' -- Will pull everything for today
AND c_s.received_time < timestamp '2013-11-30 23:59:59'
--and c_s.source_type_cd not like '%cpf%'
and c_s.source_type_cd = 'loanmachinefccpf'
--and c_s.lead_source = '9194420'
and c_s.type_cd in ('import','pass_active_customer','lead_reject_import')


GROUP BY
c.id,
CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd))
in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END,
c_s.id
-- c_s.import_cd

ORDER BY
first(c_s.received_time)desc;
}

q = Query.find_or_create_by(command: lead_id_1210)
puts q.errors.full_messages
qt = QueryTable.find_or_create_by(query_id: q.id)
puts qt.errors.full_messages

model_lead_source_performance_06_12_2014 = %{




/* ************************************************************************************
***************************************************************************************
***********************                  GOAL                  ************************
***************************************************************************************
************************************************************************************ */

/*
- Study lead_source performance for the past 7 days
  - Display confirmation, conversion, and issue rates
  - Compare to the past 30 days' average
- Display last month's defaults, CPF, and projected LTV by source
*/


/* ************************************************************************************
***************************************************************************************
********************                inputs - dates                *********************
***************************************************************************************
************************************************************************************ */

drop table if exists date_set;

select '2014-04-28'::date as date_beg
     , '2014-05-04'::date as date_end

into temp date_set;


/* ************************************************************************************
***************************************************************************************
********************                 run reports                  *********************
***************************************************************************************
************************************************************************************ */

-- select * from comp_provider
-- select * from comp_lead_source


/* ************************************************************************************
***************************************************************************************
**********************                 cpf info                 ***********************
***************************************************************************************
************************************************************************************ */

drop table if exists tmp_cpl_cpf;
create temp table tmp_cpl_cpf as
select
  ls.id as ls_id
  , ls.lead_seller_name
  , lsv.id as lsv_id
  , lsv.approved_on
  , coalesce(lsv.lead_pricing_scheme_type_id
        ,(select lsv2.lead_pricing_scheme_type_id
    from lead_seller_versions lsv2
    where lsv2.lead_seller_id = ls.id 
    and lsv2.approved_on is not null
    and lsv2.lead_pricing_scheme_type_id is not null
    order by id limit 1)
  ,case when lead_seller_name ~* '.*cpf$' then 1 end) as lead_pricing_scheme_type_id
  , lst.id as lst_id
  , lst.tier_number
  , lst.price
  , ls.brand_id
from lead_sellers ls
inner join lead_seller_versions lsv
  on lsv.lead_seller_id = ls.id and lsv.approved_on is not null
inner join lead_seller_tiers lst
  on lst.lead_seller_version_id = lsv.id
order by ls.id, lsv.id, lst.id;

-- select * from tmp_cpl_cpf


/* ************************************************************************************
***************************************************************************************
*********************                 last 7 days                 *********************
******************              everything but defaults              ******************
***************************************************************************************
************************************************************************************ */

drop table if exists last7;
SELECT
  -- strats
  CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
  , first(yaml_field(c_s.lead_text,'lead_source')) as lead_source

  -- counts
  , COUNT(c_s.received_time) AS total_sent
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')                                  THEN c_s.customer_id ELSE null END) AS total_imported
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') AND l.created_on     IS NOT NULL THEN c_s.id          ELSE null END) AS applied
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') AND c_s.confirmed_on IS     NULL THEN c_s.id          ELSE null END) AS NOT_confirmed
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') and l.status_cd not in ('declined','withdrawn','applied','on_hold') AND l.created_on IS NOT NULL THEN c_s.id ELSE null END) AS issued
 
  -- cpf
  , first(tc.lead_pricing_scheme_type_id) as lead_pricing_scheme
--  , tc.price
  , SUM(case
    when tc.lead_pricing_scheme_type_id=1 then tc.price*(case when c_s.type_cd in ('import','pass_active_customer','lead_reject_import') and l.status_cd not in ('declined','approved','on_hold','applied','withdrawn') then 1 else NULL end)    --cpf
    when tc.lead_pricing_scheme_type_id=2 then tc.price*(case when c_s.type_cd in ('import','pass_active_customer','lead_reject_import')                                                                                then 1 else NULL end)    --cpl
  else 0 end) as sum_lead_cost

  -- ltv
  -- oec, payday
  , AVG(ltr.twelve_month_score_adj) as ltv_avg
  , AVG(case when l.status_cd in ('in_default_pmt_proc','in_default','paid_off','issued','issued_pmt_proc') then ltr.twelve_month_score_adj else NULL end) as ltv_funded_avg
  -- installment
  , AVG(xis.loan_chain_1_npv) as npv_avg -- no distinction between npv and npv_funded for installment loans based on method of npv calc

into temp last7

FROM customer_sources c_s

LEFT JOIN customers c ON c.id=c_s.customer_id

LEFT JOIN loans l
  on l.customer_source_id=c_s.id
  and l.customer_id = c.id
  And l.customer_source_link_type_id is not null

-- for lead cost
left join tmp_cpl_cpf tc
  on tc.lst_id = (
  select lst_id 
  from tmp_cpl_cpf
  where lead_seller_name = c_s.source_type_cd
    and tier_number = substring(c_s.group_cd from '\d+')::int -- added by Xin; group_cd for noveaugbi is nonstandard
    and approved_on <= c_s.received_time
  order by lsv_id desc limit 1)

-- for LTV
  -- oec, payday
left join
  approvals a
  on a.id = (
  select max(id)
  from approvals
  where customer_id = l.customer_id
    and l.requested_time between processed_on - '5 minutes'::interval and processed_on + '5 minutes'::interval
  )

left join --(1:1 confirmed)
  long_term_results ltr
  on ltr.id = a.long_term_result_id

  -- installment
left join
  xcao.installments_scored_1m xis
  on xis.loan_id = l.id

WHERE
  c_s.country_cd='GB'
  AND c_s.type_cd IS NOT NULL
  and c_s.type_cd not in ('seo')
  and c_s.received_time::date between (select date_beg from date_set) and (select date_end from date_set)

GROUP BY
  provider
  , lead_source
  
order by
  provider
  , lead_source
;

-- select * from last7 limit 100;


/* ************************************************************************************
***************************************************************************************
*********************                 last 30 days                *********************
*********************                 counts only                 *********************
***************************************************************************************
************************************************************************************ */

drop table if exists last30;
SELECT
  -- strats
  CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
  , first(yaml_field(c_s.lead_text,'lead_source')) as lead_source

  -- counts
  , COUNT(c_s.received_time) AS total_sent
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')                                  THEN c_s.customer_id ELSE null END) AS total_imported
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') AND l.created_on     IS NOT NULL THEN c_s.id          ELSE null END) AS applied
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') AND c_s.confirmed_on IS     NULL THEN c_s.id          ELSE null END) AS NOT_confirmed
  , COUNT(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import') and l.status_cd not in ('declined','withdrawn','applied','on_hold') AND l.created_on IS NOT NULL THEN c_s.id ELSE null END ) AS issued
 
into temp last30

FROM customer_sources c_s

LEFT JOIN customers c ON c.id=c_s.customer_id

LEFT JOIN loans l
  on l.customer_source_id=c_s.id
  and l.customer_id = c.id
  And l.customer_source_link_type_id is not null

WHERE
  c_s.country_cd='GB'
  AND c_s.type_cd IS NOT NULL
  and c_s.type_cd not in ('seo')
  and c_s.received_time::date between (select date_end from date_set) - '30 days'::interval and (select date_end from date_set)

GROUP BY
  provider
  , lead_source
  
order by
  provider
  , lead_source
;

-- select * from last30;

/* ************************************************************************************
***************************************************************************************
*********************               defaults - oec               **********************
***************************************************************************************
************************************************************************************ */

drop table if exists oec;
SELECT
  -- strats
  CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
  , first(yaml_field(c_s.lead_text,'lead_source')) as lead_source
--  , yaml_field(c_s.lead_text,'lead_source') as lead_source

  -- loan ids
--  , l.id as l_id

  -- due date
--  , l.due_date as l_due_date
--  , loc_perf.statement_due_date::date as loc_due_date
--  , COALESCE(loc_perf.statement_due_date,l.due_date) as final_due_date
--  , c_s.received_time

  -- defaults
--  , ls.status_cd as ls_status_cd
--  , ls.eff_start_time
  , SUM(case when ls.id is not null and COALESCE(loc_perf.statement_due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end) as def
--  , case when ls.id is not null and COALESCE(loc_perf.statement_due_date,l.due_date)::date <= (select date_end from date_set) then 1 else 0 end as def
  , SUM(case when COALESCE(loc_perf.statement_due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end) as def_eligible
--  , case when COALESCE(loc_perf.statement_due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end as def_eligible

into temp oec

FROM customer_sources c_s

LEFT JOIN
  customers c
  ON c.id=c_s.customer_id

inner JOIN
  loans l
  on l.customer_source_id=c_s.id
  and l.customer_id = c.id
  and l.customer_source_link_type_id is not null
  and l.status_cd not in ('declined','approved','on_hold','applied','withdrawn')

left join
  bus_analytics.loc_statement_performance loc_perf
  on loc_perf.statement_id = (
  select max(statement_id)
  from bus_analytics.loc_statement_performance
  where loan_id = l.id
    and statement_due_date between (select date_end from date_set) - '67 days'::interval and (select date_end from date_set)
  )

left join
  loan_statuses ls
  on ls.id = (
  select max(id)
  from loan_statuses
  where loan_id = l.id
    and eff_start_time between COALESCE(loc_perf.statement_due_date,l.due_date) and COALESCE(loc_perf.statement_due_date,l.due_date) + '7 days'::interval
    and status_cd in ('in_default','in_default_pmt_proc')
  )

WHERE
  c_s.country_cd='GB'
  and l.loan_type_cd = 'oec'
  and c_s.type_cd IS NOT NULL
  and c_s.type_cd not in ('seo')
  and c_s.received_time::date between (select date_end from date_set) - '67 days'::interval AND (select date_end from date_set) - '37 days'::interval

group by
  provider
  , lead_source
 
order by
  provider
  , lead_source
;

-- select * from oec


/* ************************************************************************************
***************************************************************************************
*******************               defaults - payday               *********************
***************************************************************************************
************************************************************************************ */

drop table if exists payday;
SELECT
  -- strats
  CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
  , first(yaml_field(c_s.lead_text,'lead_source')) as lead_source
--  , yaml_field(c_s.lead_text,'lead_source') as lead_source

  -- loan ids
--  , l.id as l_id
--  , l2.id as l2_id
--  , l2.base_loan_id as l2_base_loan_id
--  , COALESCE(l2.id, l.id) as relevant_loan_id

  -- due date
--  , c_s.received_time
--  , l.due_date as l_due_date
--  , l2.due_date as topup_due_date
--  , COALESCE(l2.due_date,l.due_date) as final_due_date

  -- defaults
--  , ls.status_cd as ls_status_cd
  , SUM(case when ls.id is not null and COALESCE(l2.due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end) as def
--  , case when ls.id is not null and COALESCE(l2.due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end) as def_flg
  , SUM(case when COALESCE(l2.due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end) as def_eligible
--  , case when COALESCE(l2.due_date,l.due_date) <= (select date_end from date_set) then 1 else 0 end as def_eligible

into temp payday

FROM customer_sources c_s

LEFT JOIN
  customers c
  ON c.id=c_s.customer_id

left JOIN
  loans l
  on l.customer_source_id=c_s.id
  and l.customer_id = c.id
  and l.customer_source_link_type_id is not null
  and l.status_cd not in ('declined','approved','on_hold','applied','withdrawn')

left join
  loans l2
  on l2.id = (
  select max(id)
  from loans
  where base_loan_id = l.id and due_date between (select date_end from date_set) - '67 days'::interval and (select date_end from date_set)
  )

left join
  loan_statuses ls
  on ls.id = (
  select max(id)
  from loan_statuses
  where loan_id = COALESCE(l2.id, l.id)
    and eff_start_time between COALESCE(l2.due_date,l.due_date) and COALESCE(l2.due_date,l.due_date) + '7 days'::interval
    and status_cd in ('in_default','in_default_pmt_proc')
  )

WHERE
  c_s.country_cd='GB'
  and l.loan_type_cd = 'payday'
  and c_s.type_cd IS NOT NULL
  and c_s.type_cd not in ('seo')
  and c_s.received_time::date between (select date_end from date_set) - '67 days'::interval AND (select date_end from date_set) - '37 days'::interval

group by
  provider
  , lead_source
 
order by
  provider
  , lead_source
;

-- select * from payday


/* ************************************************************************************
***************************************************************************************
******************             defaults - installments             ********************
***************************************************************************************
************************************************************************************ */

drop table if exists inst;
SELECT
  -- strats
  CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
  , first(yaml_field(c_s.lead_text,'lead_source')) as lead_source
--  , yaml_field(c_s.lead_text,'lead_source') as lead_source

  -- loan ids
--  , l.id as l_id
--  , l.base_loan_id -- confirm no top-ups

  -- due date
--  , l.due_date as l_due_date -- payday: no top-ups

  -- defaults
--  , ls.status_cd as ls_status_cd -- status of loan 5d after due date
  , SUM(case when ls.id is not null and l.due_date <= (select date_end from date_set) then 1 else 0 end) as def
  , SUM(case when l.due_date <= (select date_end from date_set) then 1 else 0 end) as def_eligible
--  , case when ls.id is not null and l.due_date <= (select date_end from date_set) then 1 else 0 end as def
--  , case when l.due_date <= (select date_end from date_set) then 1 else 0 end as def_eligible

into temp inst

FROM customer_sources c_s

LEFT JOIN
  customers c
  ON c.id=c_s.customer_id

left JOIN
  loans l
  on l.customer_source_id=c_s.id
  and l.customer_id = c.id
  and l.customer_source_link_type_id is not null
  and l.status_cd not in ('declined','approved','on_hold','applied','withdrawn')

left join
  loan_statuses ls
  on ls.id = (
  select max(id)
  from loan_statuses
  where loan_id = l.id
    and eff_start_time between l.due_date and l.due_date + '7 days'::interval
    and status_cd in ('in_default','in_default_pmt_proc')
  )

WHERE
  c_s.country_cd='GB'
  and l.loan_type_cd = 'installment'
  and c_s.type_cd IS NOT NULL
  and c_s.type_cd not in ('seo')
  and c_s.received_time::date between (select date_end from date_set) - '67 days'::interval AND (select date_end from date_set) - '37 days'::interval

group by
  provider
  , lead_source
 
order by
  provider
  , lead_source
;

-- select * from inst


/* ************************************************************************************
***************************************************************************************
******************           composite - lead_source level         ********************
***************************************************************************************
************************************************************************************ */

drop table if exists comp_lead_source_calc;
select
  l7.provider
  , l7.lead_source

  , SUM(l7.total_sent) as l7_sent
  , SUM(l7.total_imported) as l7_imported
  , SUM(l7.not_confirmed) as l7_not_confirmed
  , SUM(l7.applied) as l7_applied
  , SUM(l7.issued) as l7_issued

  , SUM(l30.total_sent) as l30_sent
  , SUM(l30.total_imported) as l30_imported
  , SUM(l30.not_confirmed) as l30_not_confirmed
  , SUM(l30.applied) as l30_applied
  , SUM(l30.issued) as l30_issued

  , 1.0 - NICE_DIV(SUM(l7.not_confirmed),SUM(l7.total_imported)) as l7_confirmation_rate
  , NICE_DIV(SUM(l7.applied),SUM(l7.total_imported)) as l7_conversion_rate
  , NICE_DIV(SUM(l7.issued),SUM(l7.total_imported)) as l7_issue_rate

  , 1.0 - NICE_DIV(SUM(l30.not_confirmed),SUM(l30.total_imported)) as l30_confirmation_rate
  , NICE_DIV(SUM(l30.applied),SUM(l30.total_imported)) as l30_conversion_rate
  , NICE_DIV(SUM(l30.issued),SUM(l30.total_imported)) as l30_issue_rate

  , NICE_DIV(1.0 - NICE_DIV(SUM(l7.not_confirmed),SUM(l7.total_imported)),1.0 - NICE_DIV(SUM(l30.not_confirmed),SUM(l30.total_imported))) - 1.0 as confirmed_variance
  , NICE_DIV(NICE_DIV(SUM(l7.applied),SUM(l7.total_imported)),NICE_DIV(SUM(l30.applied),SUM(l30.total_imported))) - 1.0 as applied_variance
  , NICE_DIV(NICE_DIV(SUM(l7.issued),SUM(l7.total_imported)),NICE_DIV(SUM(l30.issued),SUM(l30.total_imported))) - 1.0 as issued_variance

  , AVG(l7.lead_pricing_scheme) as pricing_scheme
  , AVG(l7.sum_lead_cost) as sum_lead_cost
--  , AVG(case when l7.lead_pricing_scheme = 1 then NICE_DIV(l7.sum_lead_cost,l7.issued)
--         WHEN l7.lead_pricing_scheme = 2 then NICE_DIV(l7.sum_lead_cost,l7.total_imported)
--         ELSE 0 end) as lead_cost
  , NICE_DIV(SUM(l7.sum_lead_cost),SUM(l7.issued)) as cpf

  , AVG(l7.ltv_avg) as ltv_oec_payday
  , AVG(l7.ltv_funded_avg) as ltv_oec_payday_funded
  , AVG(l7.npv_avg) as npv_inst

--  , SUM(o.def) as oec_def
--  , SUM(o.def_eligible) oec_def_elig
--  , SUM(p.def) as payday_def
--  , SUM(p.def_eligible) as payday_def_elig
--  , SUM(i.def) as inst_def
--  , SUM(i.def_eligible) as inst_def_elig
  , SUM(COALESCE(o.def,0) + COALESCE(p.def,0) + COALESCE(i.def,0)) as def_count
  , SUM(COALESCE(o.def_eligible,0) + COALESCE(p.def_eligible,0) + COALESCE(i.def_eligible,0)) as def_eligible_count
  , NICE_DIV(
       SUM(COALESCE(o.def,0) + COALESCE(p.def,0) + COALESCE(i.def,0))
       , SUM(COALESCE(o.def_eligible,0) + COALESCE(p.def_eligible,0) + COALESCE(i.def_eligible,0))
      ) as default_rate
  , COALESCE(AVG(l7.ltv_funded_avg),AVG(l7.npv_avg)) - NICE_DIV(SUM(l7.sum_lead_cost),SUM(l7.issued)) as proj_profit

into temp comp_lead_source_calc

from last7 l7

left join last30 l30 on l30.provider||COALESCE(l30.lead_source,'#') ILIKE l7.provider||COALESCE(l7.lead_source,'#')
left join oec    o   on   o.provider||COALESCE(  o.lead_source,'#') ILIKE l7.provider||COALESCE(l7.lead_source,'#')
left join payday p   on   p.provider||COALESCE(  p.lead_source,'#') ILIKE l7.provider||COALESCE(l7.lead_source,'#')
left join inst   i   on   i.provider||COALESCE(  i.lead_source,'#') ILIKE l7.provider||COALESCE(l7.lead_source,'#')

group by
  l7.provider
  , l7.lead_source

order by
  l7.provider
  , l7.lead_source
;

-- select * from comp_lead_source_calc

drop table if exists comp_lead_source;

select 
  provider
  , lead_source
  , l7_sent
  , l7_imported
  , l7_not_confirmed
  , l7_applied
  , l7_issued
  , l30_sent
  , l30_imported
  , l30_not_confirmed
  , l30_applied
  , l30_issued
  , l7_confirmation_rate
  , l7_conversion_rate
  , l7_issue_rate
  , l30_confirmation_rate
  , l30_conversion_rate
  , l30_issue_rate
  , confirmed_variance
  , applied_variance
  , issued_variance
  , cpf
  , ltv_oec_payday
  , ltv_oec_payday_funded
  , npv_inst
  , def_count
  , def_eligible_count
  , default_rate
  , proj_profit

into temp comp_lead_source

from
  comp_lead_source_calc;


-- select * from last7
-- select * from last30
-- select * from oec
-- select * from payday
-- select * from inst

-- select * from comp_lead_source

/* ************************************************************************************
***************************************************************************************
*******************            composite - provider level            ******************
***************************************************************************************
************************************************************************************ */

drop table if exists comp_provider;

select
  provider
  , SUM(l7_sent) as l7_sent
  , SUM(l7_imported) as l7_imported
  , SUM(l7_not_confirmed) as l7_not_confirmed
  , SUM(l7_applied) as l7_applied
  , SUM(l7_issued) as l7_issued

  , SUM(l30_sent) as l30_sent
  , SUM(l30_imported) as l30_imported
  , SUM(l30_not_confirmed) as l30_not_confirmed
  , SUM(l30_applied) as l30_applied
  , SUM(l30_issued) as l30_issued

  , 1.0 - NICE_DIV(SUM(l7_not_confirmed),SUM(l7_imported)) as l7_confirmation_rate
  , NICE_DIV(SUM(l7_applied),SUM(l7_imported)) as l7_conversion_rate
  , NICE_DIV(SUM(l7_issued),SUM(l7_imported)) as l7_issue_rate

  , 1.0 - NICE_DIV(SUM(l30_not_confirmed),SUM(l30_imported)) as l30_confirmation_rate
  , NICE_DIV(SUM(l30_applied),SUM(l30_imported)) as l30_conversion_rate
  , NICE_DIV(SUM(l30_issued),SUM(l30_imported)) as l30_issue_rate

  , NICE_DIV(1.0 - NICE_DIV(SUM(l7_not_confirmed),SUM(l7_imported)),1.0 - NICE_DIV(SUM(l30_not_confirmed),SUM(l30_imported))) - 1.0 as confirmed_variance
  , NICE_DIV(NICE_DIV(SUM(l7_applied),SUM(l7_imported)),NICE_DIV(SUM(l30_applied),SUM(l30_imported))) - 1.0 as applied_variance
  , NICE_DIV(NICE_DIV(SUM(l7_issued),SUM(l7_imported)),NICE_DIV(SUM(l30_issued),SUM(l30_imported))) - 1.0 as issued_variance

  , NICE_DIV(SUM(sum_lead_cost),SUM(l7_issued)) as cpf

  , NICE_DIV(SUM(ltv_oec_payday        * l7_applied),SUM(case when ltv_oec_payday        is null then 0 else l7_applied end)) as avg_ltv
  , NICE_DIV(SUM(ltv_oec_payday_funded * l7_issued ),SUM(case when ltv_oec_payday_funded is null then 0 else l7_issued  end)) as avg_ltv_funded
  , NICE_DIV(SUM(npv_inst              * l7_issued ),SUM(case when npv_inst              is null then 0 else l7_issued  end)) as avg_npv

  , SUM(def_count) as def_count
  , SUM(def_eligible_count) as def_eligible_count
  , NICE_DIV(SUM(def_count),SUM(def_eligible_count)) AS default_rate
  , COALESCE(
       NICE_DIV(SUM(ltv_oec_payday_funded * l7_issued ),SUM(case when ltv_oec_payday_funded is null then 0 else l7_issued  end))
     , NICE_DIV(SUM(npv_inst              * l7_issued ),SUM(case when npv_inst              is null then 0 else l7_issued  end))
      ) - NICE_DIV(SUM(sum_lead_cost),SUM(l7_issued)) as proj_profit

into temp comp_provider

from comp_lead_source_calc

group by provider

order by provider
;

-- select * from comp_provider
}

q = Query.find_or_create_by(command: model_lead_source_performance_06_12_2014)
puts q.errors.full_messages
qt = QueryTable.find_or_create_by(query_id: q.id)
puts qt.errors.full_messages

pitch_main_query_backup_0211 = %{
--Query: Pitch_Main_Query_skhodukin.sql
--Update QQ Leads queries to no longer double-count issued loans for customers imported from >1 provider
--Owner: MGreen
--Written by: Skhodukin
--11/26/2012
--Acunote: https://acunote.cashnetusa.com/projects/5251/tasks/611100

drop table if exists temp_lead_pricing;

select l.lead_seller_name
,l.id as lead_seller_id
,t.tier_number
,t.cutoff
,t.price
,v.approved_on as eff_start_time
,case when v2.approved_on is null then current_timestamp else v2.approved_on end as eff_end_time
into temp temp_lead_pricing
from lead_sellers l
left outer join lead_seller_versions v on v.lead_seller_id = l.id
and v.approved_on is not null
left outer join lead_seller_versions v2 on v2.id = (select min(id) from lead_seller_versions
where lead_seller_id = l.id
and id > v.id
and approved_on is not null)
left outer join lead_seller_tiers t on t.lead_seller_version_id = v.id
order by l.lead_seller_name, v.approved_on, t.tier_number;


SELECT 
CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9')
THEN c_s.source_type_cd ELSE c_s.group_cd END as provider
,CASE when substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') 
then c_s.group_cd ELSE 'other' END AS tier
,case when (c_s.source_type_cd like '%cpf%') then 'cpf'
else 'cpl' end as lead_type
,extract(week from c_s.received_time)as week
,extract(month from c_s.received_time)as month
,t.price
,t.eff_start_time::date as pricing_start_time
,t.eff_end_time::date as pricing_end_time
,type_cd as type_cd
,sub_type_cd as sub_type_cd
,count(c_s.received_time) AS total_sent
,count(distinct c_s.customer_id) AS total_unique_customer
,count(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
THEN c_s.customer_id ELSE null END) AS total_imported
,count(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
--AND c_s.confirmed_on IS NOT NULL
AND l.created_on IS NOT NULL THEN c_s.id ELSE null END) AS applied
,count(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
AND c_s.confirmed_on IS NULL THEN c_s.id ELSE null END) AS NOT_confirmed
,count(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer','lead_reject_import')
and l.status_cd not in ('declined','withdrawn','applied','on_hold')
AND l.created_on IS NOT NULL THEN c_s.id ELSE null END ) AS issued

FROM customer_sources c_s 
left outer join customers c on c.id=c_s.customer_id
left outer join loans l on c_s.id = l.customer_source_id and l.customer_source_link_type_id is not null
and l.customer_id = c.id
--left outer join loans l ON l.id = (SELECT max(id) FROM loans ll 
-- WHERE c.id = ll.customer_id 
-- AND ll.requested_time between c_s.received_time and c_s.received_time + interval '3 day')
left outer join temp_lead_pricing t on t.lead_seller_name = c_s.source_type_cd
and c_s.received_time >= t.eff_start_time and c_s.received_time <= t.eff_end_time  
and case when  lower(c_s.group_cd) in ('t1','t2','t3','t4','t5','t6','t7','t8','t9','1','2','3','4','5','6','7','8','9') 
then cast(substring(c_s.group_cd from length(c_s.group_cd)) as smallint) else null end = t.tier_number

where c_s.country_cd='GB'
and c_s.incoming_brand_id <>'11'
and c_s.received_time between '2013-01-21' and '2013-06-17'

--and lower(c_s.group_cd) in ('t1','t2','t3','t4','t5','t6','1','2','3',
--'4','5','6')
GROUP BY 
provider
,tier
,week
,month
,lead_type
,t.price
,type_cd
,sub_type_cd
,t.eff_start_time
,t.eff_end_time
order by provider, tier 
}

q = Query.find_or_create_by(command: pitch_main_query_backup_0211)
puts q.errors.full_messages
qt = QueryTable.find_or_create_by(query_id: q.id)
puts qt.errors.full_messages

tiers_1218 = %{
--Query: Tiers_0514_smurzin.sql
--Update QQ Leads queries to no longer double-count issued loans for customers imported from >1 provider
--Owner: M Green
--Written by: Stanislav Murzin
--11/23/2012
--Acunote: https://acunote.cashnetusa.com/projects/5251/tasks/611100


SELECT
t.*

FROM (
SELECT
--c_s.customer_id,
CASE WHEN (c_s.group_cd is null) or substring(c_s.group_cd from length(c_s.group_cd))
in ('1','2','3','4','5','6','7','8','9') THEN c_s.source_type_cd ELSE c_s.group_cd END as provider,
CASE when substring(c_s.group_cd from length(c_s.group_cd)) in ('1','2','3','4','5','6','7','8','9') then c_s.group_cd
ELSE 'other'
END AS tier,

c_s.received_time::date as date,
count(c_s.received_time)
AS total_sent,
count(distinct c_s.customer_id)
AS total_sent_by_unique_customer,

first(yaml_field(c_s.lead_text,'lead_source')) as lead_source,
extract(month from c_s.received_time) as month,
type_cd,
sub_type_cd,

--extract(day from c_s.received_time) as day,
count(distinct CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
THEN c_s.customer_id ELSE null END)
AS total_imported,

count(distinct
CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
--AND c_s.confirmed_on IS NOT NULL
AND l.created_on IS NOT NULL THEN c_s.id ELSE null END )
AS applied,

count(distinct
CASE WHEN c_s.type_cd IN ('import','pass_active_customer', 'lead_reject_import')
AND c_s.confirmed_on IS NULL THEN c_s.id ELSE null END )
AS NOT_confirmed,



count(distinct
CASE WHEN c_s.type_cd IN ('import','pass_active_customer','lead_reject_import')
and l.status_cd not in ('declined','withdrawn','applied','on_hold')
AND l.created_on IS NOT NULL THEN c_s.id ELSE null END )

AS issued

FROM customer_sources c_s
LEFT OUTER JOIN customers c ON c.id=c_s.customer_id

LEFT OUTER JOIN loans l  on l.customer_source_id=c_s.id and l.customer_id = c.id and l.customer_source_link_type_id is not null
WHERE
c_s.country_cd='GB' and 
c_s.type_cd IS NOT NULL
and c_s.type_cd not in ('seo')
and c_s.incoming_brand_id <>'11'
and c_s.received_time >= '2013-06-03 00:00:00'
AND c_s.received_time <= '2013-06-03 23:59:59'

AND c_s.source_type_cd = 't3uk'
--and c_s.source_type_cd not like '%cpf%'
--and c_s. lead_source not in ('999_0','173_400078','999_300000')

GROUP BY provider--,ttt
, tier --, a.id, c.status_cd --c_s.source_type_cd, c_s.group_cd, c_s.confirmed_on
, lead_source
, month
, type_cd
, sub_type_cd
,c_s.received_time::date
--, day
--,c_s.customer_id
order by provider, tier,  lead_source
) AS t
}

q = Query.find_or_create_by(command: tiers_1218)
puts q.errors.full_messages
qt = QueryTable.find_or_create_by(query_id: q.id)
puts qt.errors.full_messages

g = Graph.find_or_create_by(name: "Test Graph")
puts g.errors.full_messages
g = Graph.find_or_create_by(name: "Test Graph 2")
puts g.errors.full_messages
g = Graph.find_or_create_by(name: "Test Graph 3")
puts g.errors.full_messages
