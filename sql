# description -- see postgres
Various stuff about sql, query tools and databases

# tools
prestodb -
orientdb -
duckdb  - fast , timeseries, postgres
prql
malloy

# dbt
# ...

# distributed sql query engine
presto (mysql, hive, cassandra, ...)
hive  (hadoop)
impala (hadoop, hdfs, hbase)
drill (hadoop, nosql, JSON, parquet)
pilosa
pig
jaql (JSON, hdfs)

# mysql port forward
# https://myopswork.com/transparent-ssh-tunnel-through-a-bastion-host-d1d864ddb9ae
ssh -i mymaster.pem  ec2-user@10.0.2.56 -o "proxycommand ssh -W %h:%p -i mymaster.pem ec2-user@mybastion.elb.amazonaws.com"
see ~/.ssh/config ProxyCommand LocalForward
see ~/.aliases rqct()

# orientdb - nosql / document/ multi-model /graph db

# sql cumulative with correlated subquery
select date, (select sum(u.value) from t as u  where u.date<=t.date) from t

# drill
sqlline -u jdbc:drill:zk=local

# convert csv file to schema e.g. for sqlite3
> csvsql -e iso-8859-1 asp.csv  # from csvkit

# csvkit csvsql
 csvsql --query "select Plate_Name,Well_Id,Illumina_Read_Percent_Contamination_Artifact_50Bp from metrics where Illumina_Read_Percent_Contamination_Artifact_50Bp>3 and Plate_Name='Simon-Crump_metaG'" metrics.csv

# duckdb
csv -> sqldb
window functions: https://duckdb.org/docs/sql/window_functions
duckdb> D create table T as select * from 'vw_sow_segment_hist.csv';
or
duckdb> D create table T as select * from read_csv_auto('vw_sow_segment_hist.csv');
D select count(*) from T ;
D describe T

# sqlite query over input file ids
# put input file into id,data format ; csv is convenient
sqlite3 SRAmetadb.sqlite
sqlite> create temporary table ids (id integer primary key, rid varchar);
sqlite> .import 't' ids
sqlite> .mode csv
sqlite> .import 't' ids
# join on id
sqlite> select * from ids limit 5 ;
id,rid
1,ERR4691828
2,ERR4691826
3,ERR4691827
sqlite> select sum(bases) from sra s inner join ids i on s.run_accession=i.rid ;

# sqlite query format (added to .sqliterc)
.mode column
.headers on
.separator ROW "\n"
.nullvalue NULL



# cycle time
see /Users/copeland/Repos/JGI/_Other/jgi-its-warehouse/scripts/unix/dw/build_sql/sp_report.sql

# postgres docs
https://www.postgresql.org/docs/11/sql-select.html

# postgres useful user def fn
CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

# postgres good stuff
# https://til.hashrocket.com/sql
\c dbname username host port.
dw --csv <<< "select generate_series(1,10)as i, random() as r"
dw --csv -c "select generate_series(1,10)as i, random() as r;"
LATERAL join
generate_series()
extract()
\timing
\watch
\gx  # toggle \x
window()
CTE: WITH foo as ()
row_number() over PARTITION
rollup() / cube() / group_sets()
:: type casting
EXPLAIN ANALYZE
~  : regex matches
LTREE and @>
select title from posts where title::tsvector @@ 'instr:*'::tsquery;
select x.y from (values (null), (1), (2)) x(y) where x.y != 1;
# distinct on, values()
select distinct on (letter) * from (values ('y', 512), ('y',128), ('z', 512), ('x',128), ('z', 256)) as x (letter, number);
group by and order by can use aliases
# query over array oof regexes
select * from my_table where my_column ilike any (array['%some%', '%words%'])
# group by week (start)
select count(*), date_trunc('week', request_time) from requests group by date_trunc('week', request_time) order by date_trunc desc ;
\c example # psql switch db
# case insensitive matching citext
create extension citext;
dw <<< "select sample_id, date_created, current_status from dw.sample_aliquot where date_created>='2021-11-09'\x \! ls" # arbitrary cmd

# data analyst questions - sql etc.
https://quip.com/2gwZArKuWk7W

# sql inner join
select proposal_id, proposal_pi, sp_project_id as spid, s.library_name as lib
from air
inner join seq_units s on seq_unit_id = rqc_seq_unit_id
where sp_actual_product in ('Metagenome Standard Draft', 'Metagenome Minimal Draft')
order by proposal_id

# sql histogram
select floor(datediff(sam_receive_date, sam_ship_approve_date)/30)*30 as app2rcv, count(*)

# postgres : dw
# brew install postgresql
dw-prddb01.jgi.doe.gov -U dw_user dwprd1p
password: XXXX
#psql postgresql://dbmaster:5433/mydb?sslmode=require
# works inside nersc
psql -h dw-prddb01.jgi.doe.gov -U dw_user -d dwprd1p # --csv

# sql cumulative with correlated subquery
select date, (select sum(u.value) from t as u  where u.date<=t.date) from t

# distributed sql query engine
presto (mysql, hive, cassandra, ...)
hive  (hadoop)
impala (hadoop, hdfs, hbase)
drill (hadoop, nosql, JSON, parquet)
pilosa
pig
jaql (JSON, hdfs)

# presto - open source dist SQL query engine for interactive analytic queries against data sources of all sizes
needs java >= 1.8
Add connectors to /usr/local/Cellar/presto/0.150/libexec/etc/catalog/. See: https://prestodb.io/docs/current/connector.html
# To start presto with launchd and restart login:
brew services start presto
#Or, if you don't want/need a background service you can just run:
presto-server run

# convert csv file to schema e.g. for sqlite3
> csvsql -e iso-8859-1 asp.csv  # from csvkit

# henplus - drivers: put in share directory
> cp $CLASSPATH/mysql-connector-java-5.1.34.jar  /usr/local/Cellar/henplus/0.9.8/share/henplus/
# or w/out root
mkdir -p ~/.henplus/lib
>cp /path/to/my/driver.jar ~/.henplus/lib

#
SELECT library_name,
l.project_id     ,
l.library_type,
s.qc_date         ,
s.qc_status       ,
replace(s.comments,chr(13),' ')  "comment"
FROM libraries2.dt_wg_qc_summary s,
libraries2.dt_white_board_libraries l
WHERE s.library_id   = l.library_id
AND s.qc_date         IS NOT NULL
AND upper(s.qc_status) = 'FAIL'
AND s.qc_date BETWEEN '01-MAR-2009' AND CURRENT_DATE
AND library_name NOT LIKE 'C%'
and library_type != 'Standard'
ORDER BY s.qc_status,
s.qc_date;        sam_receive_date as dt_rcv,
lib_create_date as dt_lc,
sdm_seq_complete_date as dt_seq_end,
s.posted_date as dt_su,
alq_create_date as dt_alq_cr,
abs(extract(day from sam_receive_date - sam_ship_approve_date)) as app2rcv,
abs(extract(day from sam_qc_date - sam_receive_date)) as rcvs2qc,
abs(extract(day from sow_item_qc_date-sam_qc_date)) as iqc2sqc,
abs(extract(day from alq_create_date-sow_item_qc_date)) as iqc2alq,
abs(extract(day from seg_create_date-alq_create_date)) as al2seq,
abs(extract(day from seg_create_date-lib_create_date)) as seq2lc,
abs(extract(day from pr_create_date-lib_create_date)) as pr2lc,
abs(extract(day from pr_create_date-pool_create_date)) as pc2pr,
abs(extract(day from sdm_seq_start_date-pool_create_date)) as seq2pc,
abs(extract(day from sdm_seq_start_date-sdm_seq_complete_date)) as seq,
abs(extract(day from rqc_seq_unit_qc_date-sdm_seq_complete_date)) as suqc2seq,
abs(extract(day from rqc_seq_unit_qc_date-sow_item_qc_date)) as sow2suqc,
abs(extract(day from sp_orig_complete_date-sow_item_qc_date)) as spc
from all_inclusive_report  a join sdm_sequence_unit s on a.sdm_seq_unit_id=s.sdm_sequence_unit_id
where sam_ship_approve_date between '2020-11-01' and '2021-11-12'  -- $F and $T
and acct_scientific_program in ('Fungal','Metagenome','Microbial')
and lib_name is not null
and sam_receive_date is not null
and sam_ship_approve_date is not null
select acct_year as Y_A,
extract(year_month from s.run_date) as ym_seq,
extract(year_month from jamo_dt_updated) as ym_jamo,
extract(year_month from q.dt_created) as ym_rqc,
acct_scientific_program as Prog, sp_actual_product as Prod,
date_format(lib_create_date,"%Y-%m-%d") as dt_lc,
date_format(sdm_seq_complete_date ,"%Y-%m-%d") as dt_seq_end,
date_format(s.dt_created,"%Y-%m-%d") as dt_su,
date_format(q.dt_created,"%Y-%m-%d") as dt_rqc,
date_format(jamo_dt_updated,"%Y-%m-%d") as dt_jamo,
date_format(jat_dt_updated,"%Y-%m-%d") as dt_jat,
datediff(q.dt_created,s.dt_created) as su2rqc,
datediff(jamo_dt_updated,q.dt_created) as rqc2jamo,
datediff(jamo_dt_updated,jat_dt_updated) as jamo2jat,
-- seq_unit_id as su,
library_name as lib
from rqc_pipeline_queue q
inner join seq_units s using( seq_unit_id)
inner join air a on s.seq_unit_id=a.rqc_seq_unit_id
where jamo_dt_updated is not null
and [jamo_dt_updated=daterange]
and [acct_scientific_program=Program]
-- group by dt_seq_end
order by Y_A
-- N=38462
/*   rpt_sam_age_days,     rpt_sow_item_age_days,    seg_create_date     sow_item_qc_date
    sp_orig_complete_date     sp_status_date
--  sam_ship_approve_date < sam_receive_date < sam_qc_date < sow_item_qc_date < alq_create_date < seg_create_date
   < lib_create_date < sdm_seq_start_date < sdm_seq_complete_date < rqc_seq_unit_qc_date

#
select [sam_receive_date:aggregation] as dt_sr,
count(*) as N,
date_format(alq_create_date,"%Y-%m-%d") as dt_alq_cr, -- yearweek(sam_receive_date) as yrwk,
round(avg(datediff(sam_receive_date, sam_ship_approve_date))) as app2rcv,
round(avg(datediff(sam_qc_date, sam_receive_date))) as rcvs2qc,
round(avg(datediff(sow_item_qc_date,sam_qc_date))) as iqc2sqc,
round(avg(datediff(alq_create_date,sow_item_qc_date))) as iqc2alq,
round(avg(abs(datediff(seg_create_date,alq_create_date)))) as al2seq,
round(avg(datediff(lib_create_date,seg_create_date))) as seq2lc,
round(avg(datediff(pr_create_date,lib_create_date))) as pr2lc,
round(avg(datediff(pr_create_date,pool_create_date))) as pc2pr,
round(avg(datediff(sdm_seq_start_date,pool_create_date))) as seq2pc,
round(avg(abs(datediff(sdm_seq_start_date,sdm_seq_complete_date)))) as seq,
round(avg(datediff(rqc_seq_unit_qc_date,sdm_seq_complete_date))) as suqc2seq,
round(avg(datediff(rqc_seq_unit_qc_date,sow_item_qc_date))) as sow2suqc,
round(avg(abs(datediff(sp_orig_complete_date,sow_item_qc_date)))) as spc,
acct_year as y_a
-- , acct_scientific_program as prg, sp_actual_product as prod, lib_name as lib
from air
where lib_name is not null
and [sam_ship_approve_date=daterange]
and [acct_scientific_program=Program]
and sam_receive_date is not null
and sam_ship_approve_date is not null
and sow_item_qc_date is not null
and rqc_seq_unit_qc_date is not null
group by dt_sr
order by acct_year, dt_sr
-- sow_qc::seq_unit_id   dt_created
-- sow_items::sow_item_id  dt_created
-- su:su_id  dt_created
-- select count(sdm_seq_start_date) from air where sdm_seq_start_date is not null #222628
-- select count(distinct seq_unit_id) from rqc_pipeline_queue  #290055
-- select count(distinct rqc_seq_unit_id) from air  # 216305
-- select count(distinct sdm_seq_unit_id) from air #202917
select lib_name, sp_actual_product,
sam_receive_date, sam_qc_date,  sow_item_qc_date, alq_create_date, lib_create_date,
sdm_seq_start_date, sdm_seq_complete_date,rqc_status_date, rqc_seg_qc_date,rqc_seq_unit_qc_date
from air
where lib_name= 'GCPSH'
-- seg_create_date,

#
select x.*, s1+s2+s3+s4+s5+s6+s7+s8+s9 as t
from (select lib_name, sp_actual_product,
  coalesce(datediff(sam_qc_date,sam_receive_date),0) as s1,
  coalesce(datediff(seg_create_date,sam_qc_date),0) as s2,
  coalesce(datediff( sow_item_qc_date,seg_create_date),0) as s3,
  coalesce(datediff( alq_create_date,sow_item_qc_date),0) as s4,
  coalesce(datediff(lib_create_date, alq_create_date),0) as s5,
  coalesce(datediff(sdm_seq_start_date,lib_create_date),0) as  s6,
  coalesce(datediff(sdm_seq_complete_date, sdm_seq_start_date),0) as s7,
  coalesce(datediff(rqc_status_date, sdm_seq_complete_date),0) as s8,
  coalesce(datediff(rqc_seq_unit_qc_date,rqc_status_date),0) as s9,
  coalesce(datediff(rqc_seg_qc_date, rqc_seq_unit_qc_date),0) as s10
  from air
  where  lib_name is not null
     and lib_name= 'GCPSH') x
#
select distinct sum(rdm.doe_bases) as Base_Output
from dw.rqc_doe_metrics rdm
where rdm.account_jgi_sci_prog = 'Metagenome'
and rdm.dt_finalized between '01-OCT-2019' and '30-SEP-2020'

# /*
select sum(yield_bases) as bases
from illumina_lane_stats
where


#
select  distinct final_deliverable_prod_name,
-- s.library_name as lib, sum(s.sdm_raw_base_count/1e9) as gb,
l.total_sow_item_log_amt_targeted as tla
-- , l.seq_proj_id
-- , count(s.seq_unit_id) as cnt
from seq_units s
inner join library_info l on s.rqc_library_id = l.library_id
inner join sow_meta sm on s.sow_item_id = sm.sow_item_id
where account_jgi_sci_prog="Metagenome"
and s.model_id = 9  -- illumina
and l.logical_amount_units = 'gb'
and [s.dt_created=daterange]
group by s.library_name, final_deliverable_prod_name, l.seq_proj_id, l.total_sow_item_log_amt_targeted
order by s.dt_created
-- having cnt > 1
select extract(year from s.run_date) as y_seq, acct_year as Y_A,
acct_scientific_program as Prog, sp_actual_product as Prod,
date_format(lib_create_date,"%Y-%m-%d") as dt_lc,
date_format(sdm_seq_complete_date ,"%Y-%m-%d") as dt_seq_end,
date_format(s.dt_created,"%Y-%m-%d") as dt_su,
date_format(q.dt_created,"%Y-%m-%d") as dt_rqc,
date_format(jamo_dt_updated,"%Y-%m-%d") as dt_jamo,
date_format(jat_dt_updated,"%Y-%m-%d") as dt_jat,
datediff(q.dt_created,s.dt_created) as su2rqc,
datediff(jamo_dt_updated,q.dt_created) as rqc2jamo,
datediff(jamo_dt_updated,jat_dt_updated) as jamo2jat,
-- seq_unit_id as su,
library_name as lib
from rqc_pipeline_queue q
inner join seq_units s using( seq_unit_id)
inner join air a on s.seq_unit_id=a.rqc_seq_unit_id
where jamo_dt_updated is not null
and [jamo_dt_updated=daterange]
-- group by dt_seq_end
order by s.run_date
-- N=30480

#
select
    s.seq_unit_name,
s.instrument_type,
    s2.raw_reads_count / s.raw_reads_count as unk
from seq_units s
inner join seq_units s2 on s.run_id = s2.run_id and s.run_section = s2.run_section
left join library_info l on s.rqc_library_id = l.library_id
left join seq_unit_qc qc on qc.seq_unit_name = s.seq_unit_name
where
    s.is_multiplex = 1
    and s2.library_name = 'unknown'
and [s.run_date=daterange]
order by s.dt_created desc
select
-- [x_axis] , [value_field]
  cluster_dt_start, cluster_runtime_sec
  , average
  , average - stdev as sd_minus_one
  , average + stdev as sd_plus_one
from
  -- [table]
  rqc_task_list
  , (
    select
     -- avg([value_field]) as average
    avg(cluster_runtime_sec) as average
    from
     -- [table]
    rqc_task_list
  )
  as a
  , (
    select
     -- stddev_samp([value_field]) as stdev
    stddev_samp(cluster_runtime_sec) as stdev
    from
     -- [table]
    rqc_task_list
  )
  as s
WITH range_values AS (
  SELECT date_trunc('week', min(created_at)) as minval,
         date_trunc('week', max(created_at)) as maxval
  FROM users),

week_range AS (
  SELECT generate_series(minval, maxval, '1 week'::interval) as week
  FROM range_values
),

weekly_counts AS (
  SELECT date_trunc('week', created_at) as week,
         count(*) as ct
  FROM users
  GROUP BY 1
)
-- end WITH (created 3 tmp tables) (CTE)

#
SELECT week_range.week,
       weekly_counts.ct
FROM week_range
LEFT OUTER JOIN weekly_counts on week_range.week = weekly_counts.week;

#-- extract or date_part instead of date_trunc ?
select
    s.run_date, s.seq_unit_name, s.library_name, s.instrument_type, l.library_protocol, l.account_jgi_sci_prog, s.run_configuration, s.raw_reads_count, l.seq_proj_name, l.target_fragment_size, qc.qc_state, l.plate_name, l.seq_prod_name, l.library_created_dt, l.library_created_by_name, l.degree_of_pooling, l.actual_library_queue, s.instrument_name, l.well_id,
    1-(s.filter_reads_count/s.raw_reads_count) as y_data
from seq_units s
left join library_info l on s.rqc_library_id = l.library_id
left join seq_unit_qc qc on qc.seq_unit_name = s.seq_unit_name
where
    s.seq_unit_status_id != 18
    and s.model_id = 9
    and s.filter_reads_count > 0
    and l.seq_prod_name not in ('Eukaryote Community Metatranscriptome', 'Metagenome Metatranscriptome')
    and s.run_date between '2021-03-07' and '2021-10-07'
             and l.library_protocol in ('Low Input (DNA)','Low Input (RNA)','Regular (DNA)','Regular (RNA)','smRNA','Ultra-Low Input (DNA)','Ultra-Low Input (RNA)') order by s.run_date
select
  case
    when floor([column]/[bin]) * [bin] < [trunc]
      then floor([column]/[bin]) * [bin]
    else [trunc]
  end as lower
  , case
    when floor([column]/[bin]) * [bin] < [trunc]
      then cast(floor([column]/[bin]) * [bin] as varchar) || ' - ' ||
           cast(floor (([column]+[bin]) / [bin]) * [bin] -1 as varchar
    )
    else [trunc] || ' +'
  end as label
  , count(*) as cnt
from
  [table]
group by 1 ,2
order by 1

#
select proposal_id, proposal_pi, proposal_title as title, sp_project_id as spid, sp_project_name as sp_name,
s.library_name as lib, s.sdm_raw_base_count as bases_raw, s.filter_reads_count*150 as bases_filt
-- air.sp_expected_num_samples
-- , air.sp_material_type, air.sp_project_name
from air
inner join seq_units s on seq_unit_id = rqc_seq_unit_id
where air.acct_year>2016
-- and sp_material_type = 'eDNA'
and sp_actual_product in ('Metagenome Standard Draft', 'Metagenome Minimal Draft')
-- and sp_actual_product like '%Metagenome%Draft'
-- proposal_id= 502924
order by proposal_id
CREATE OR REPLACE FUNCTION random_between(low INT ,high INT)
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

#
SELECT tube.id as id, tube.archive_purpose$ as archive_reason, modified_at$ as modified_date from jgi.tube$raw tube
LEFT JOIN jgi.container_content$raw content on content.container_id = tube.id
LEFT JOIN jgi.registry_entity$raw entity on entity.id = content.entity_id
WHERE (modified_at$ BETWEEN NOW() - INTERVAL '72 HOURS' AND NOW())
AND (tube.archive_purpose$ = 'Shipped' OR tube.archive_purpose$ = 'Expended')
AND entity.schema_id = 'ts_gIK6hizg'
union
select plate_id$ as id, well.archive_purpose$ as archive_reason, modified_at$ as modified_date from jgi.well$raw well
LEFT JOIN jgi.container_content$raw content on content.container_id = well.id
LEFT JOIN jgi.registry_entity$raw entity on entity.id = content.entity_id
WHERE (modified_at$ BETWEEN NOW() - INTERVAL '72 HOURS' AND NOW())
AND well.archive_purpose$ = 'Shipped' OR well.archive_purpose$ = 'Expended'
AND entity.schema_id = 'ts_gIK6hizg'

# -
select workflowname, trunc(daily_avg) as daily_avg, trunc(weekly_avg) as wk_avg, trunc(monthly_avg) as mon_avg
from (
    select workflowname, avg(count) monthly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01'
        group by workflowname, date_trunc('month', date_in)
    ) s
    group by 1
) monthly
join (
    select workflowname, avg(count) weekly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01'
        group by workflowname, date_trunc('week', date_in)
    ) s
    group by 1
) weekly using(workflowname)
join (
    select workflowname, avg(count) daily_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01'
        group by workflowname, date_trunc('day', date_in)
    ) s
    group by 1
) daily using(workflowname)
order by 1;

# event
select event,
    avg(total) filter (where day is not null) as avg_day,
    avg(total) filter (where week is not null) as avg_week,
    avg(total) filter (where month is not null) as avg_month
from (
    select
        event,
        date_trunc('day', created_at) as day,
        date_trunc('week', created_at) as week,
        date_trunc('month', created_at) as month,
        count(*) as total
    from tracking_stuff
    where event in ('thing','thing2','thing3')
    group by grouping sets ((event, 2), (event, 3), (event, 4))
) s
group by event

# workflow
select workflowname, daily_avg, weekly_avg, monthly_avg
from (
    select workflowname, avg(count) monthly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01' -- workflowname in ('thing1', 'thing2', 'thing3')
        group by workflowname, date_trunc('month', created_at)
    ) s
    group by 1
) monthly
join (
    select workflowname, avg(count) weekly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01' -- workflowname in ('thing1', 'thing2', 'thing3')
        group by workflowname, date_trunc('week', created_at)
    ) s
    group by 1
) weekly using(workflowname)
join (
    select workflowname, avg(count) daily_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2019-04-01' and '2019-06-01' -- workflowname in ('thing1', 'thing2', 'thing3')
        group by workflowname, date_trunc('day', created_at)
    ) s
    group by 1
) daily using(workflowname)
order by 1;

# workflow
select workflowname, yr, trunc(daily_avg) as daily_avg, trunc(weekly_avg) as wk_avg, trunc(monthly_avg) as mon_avg, trunc(yearly_avg) as yr_avg
from (
    select workflowname, avg(count) yearly_avg, yr
    from (
        select workflowname, count(*), extract(year from date_in) as yr
        from dw.clarity_sow_item_queues
        where date_in between '2016-09-01' and '2021-09-01'

        group by workflowname, yr
    ) s
    group by 1,3
) yearly
join (
    select workflowname, avg(count) monthly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2016-09-01' and '2021-09-01'
        group by workflowname, date_trunc('month', date_in)
    ) s
    group by 1
) monthly using(workflowname)
join (
    select workflowname, avg(count) weekly_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2016-09-01' and '2021-09-01'
        group by workflowname, date_trunc('week', date_in)
    ) s
    group by 1
) weekly using(workflowname)
join (
    select workflowname, avg(count) daily_avg
    from (
        select workflowname, count(*)
        from dw.clarity_sow_item_queues
        where date_in between '2016-09-01' and '2021-09-01'
        group by workflowname, date_trunc('day', date_in)
    ) s
    group by 1
) daily using(workflowname)
order by  workflowname, yr;

# constant column
select f1, f2, 'new_col' as foo from bar;

# rollup
select count(seq_unit_id) as tot_su, extract(year from read_qc_ppl_status_date) as y, read_qc_ppl_status, count(*)
from dw.rqc_data
where read_qc_ppl_status_date>'2018-01-01'
group by rollup(read_qc_ppl_status,y) order by y

# partition - see qctools.sh

# partition
with sam_hist as(
  select * from
    ( select samh.sample_id, samh.current_volume_ul initial_volume_ul, samh.current_concentration_ngul initial_concentration_ngul,
      row_number() over (partition by sample_id order by last_updated) rn from uss.dt_sample_hist samh where samh.current_volume_ul is not null
    ) sub1 where rn = 1
)
select sam.sample_id, sam.collabor_volume_ul,
    case when sam_hist.initial_volume_ul < 0 then 0 else sam_hist.initial_volume_ul end as initital_volume_ul,
    case when sam.current_volume_ul < 0 then 0 else sam.current_volume_ul end as current_volume_ul,
    sam.collabor_concentration_ngul, sam_hist.initial_concentration_ngul, sam.current_concentration_ngul,
    sam.qc_status, sam.qc_date, sam.current_status_id, sam.status_date, sam
from uss.dt_sample sam join sam_hist on sam_hist.sample_id = sam.sample_id
    join dw.all_inclusive_report air on air.sam_id = sam_hist.sample_id
where sam.qc_status is not null and sam.qc_date between '$F' and '$T' order by sample_id;

