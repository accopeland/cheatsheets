## Pretty print the json
#jq "." < filename.json

# doc
https://earthly.dev/blog/jq-select/

# json / record parsing
gron
dasel
zq
rq
fx
jql
nushell (open foo.json)
Q
jaq

# nushell
https://www.nushell.sh/cookbook/jq_v_nushell.html#mapping-over-lists

# json filtering  rest api / html tools
jo - json output from shell
pup - html filtering
httpie ( http ) - better curl
gron (grep json)
jc (https://github.com/kellyjonbrazil/jc): serialize std output innto json
jp (jmespath.org)
jid (go) ~/local/x86_64/bin/jid
fx  - replaces jid and parts of jid (npm; see xx for go version)
# htmlq - like JQ for html (homebrew)

# Access the value at key "foo"
jq '.foo'

# Access first list item
jq '.[0]'

# Slice & Dice
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'

# test/ timing
jq -n '[range(1000000)] | reverse | length'
1000000
jaq -n '[range(1000000)] | reverse | length'

# parse trello json with jq
cat ltg.json  | jq ' .cards | .[] | .name'

# jira - jql date range query
created >= -5d

#  quoting keys
avoid '-' and ':' and lots of other chars ... quote if present to avoid impenetrable errmsgs
curl -s $RQC_API/rqcws/dump/ID | jq -r '[.seq_unit.library_name,.seq_unit.seq_unit_name,.stats."filter:inputbases"/1e9]|@csv'

#  builtins
https://github.com/stedolan/jq/blob/master/src/builtin.jq

#  formatting
jq -n -r '[1,2,3] | reduce .[1:][] as $i ("\(.[0])"; . + ", \($i)" )'

# mashing
parallel "curl -s $RQC_API/library/info/{} | jq -r '.library_info[]| [.seq_proj_name,.seq_proj_id,.final_deliverable_prod_name]|@csv'" :::: y > y.out

# contam report
cat 201705.txt  | jq -r '[.contam_report.data.table_data1] |.[]| .[] | [.read_cnt,.seq_cnt,.taxo] | @csv '

# pretty print json : http://www.restlessprogrammer.com/2013/03/how-to-pretty-print-json-from-command.html
json | JQ .

#  apid
jq -r '.[]|.analysis_projects[]| select(.status_name="All Analysis Done") | [.analysis_project_id,.status_name]|@csv' apid.json

# jq - json to tsv:
$ echo '{"one":1,"two":"x"}' | jq --raw-output '"\(.one)\t\(.two)"'
$ curl -s http://proposals.jgi.doe.gov/pmo_webservices/product_catalog | jq -r '.[]| [.final_deliv_product_name,.final_deliv_product_id] | @csv'

#  jat
jat get metadata.json AUTO-16007 | jq -r '.[]|.[]|.metadata | select(.coverage!=null) | [.analysis_project_id[0],.scaf_bp,.coverage] | @csv ' 2>/dev/null


# online tools
# https://jqplay.org

# filter using multiple input files
Given a list of ids in 'not-emp' (A) and a db dump in users.json (B) containing employee_id , to find records from A in B:
head A | parallel "jq --arg id {} '.[]| select(.employee_id == \$id )' B | jq '.accounts|.[].username'" |  sort -u

# to sort by a key:
jq '.foo | sort_by(.bar)'

# to count elements:
jq '.foo | length'

# print only selected fields:
jq '.foo[] | {field_1,field_2}'

# print selected fields as text instead of json:
jq '.foo[] | {field_1,field_2} | join(" ")'

# only print records where given field matches a value
jq '.foo[] | select(.field_1 == "value_1")'

# datetime filtering
# pull data with balcony aws ...
cat jgi.ami.json | jq --arg dt "2024-03-01" -r '.Images[]| select(.DeprecationTime < (now |strftime("%Y-%m-%dT%H:%M:%SZ"))) | [.DeprecationTime,.ImageId]|sort| @csv' > jgi.images.deprecated.csv

# filter ami by key/val
cat  jgi.ami.json  |  jq 'select(.Images[].OwnerId=="080819234838")'
