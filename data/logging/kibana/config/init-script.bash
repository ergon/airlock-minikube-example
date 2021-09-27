#!/bin/bash
# set -x

KIBANA_URL=${KIBANA_URL:-http://localhost:5601}
TMPL_DIR=${TMPL_DIR:-/var/tmp/kibana/}

# Wait for Kibana to be up and running
while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' ${KIBANA_URL}${SERVER_BASEPATH}/app/kibana)" != "200" ]]; do sleep 1; done

function kibana_index_patterns() {
  curl -fsS -w "\n" \
    -X "POST" \
    -H "kbn-xsrf: true" -H "Content-Type: application/json" \
    -d "@$1" \
    "${KIBANA_URL}${SERVER_BASEPATH}/api/saved_objects/_bulk_create?overwrite=true"
}
function kibana_import() {
  curl -fsS -w "\n" \
    -X POST \
    -H "kbn-xsrf: true" \
    --form "file=@$1" \
    "${KIBANA_URL}${SERVER_BASEPATH}/api/saved_objects/_import?overwrite=true"
}

kibana_index_patterns "${TMPL_DIR}/default-index-patterns.json"

if ((NO_IAM != 1)); then
	kibana_index_patterns "${TMPL_DIR}/airlock-iam-index-patterns.json"
	kibana_import "${TMPL_DIR}/airlock-iam-kibana.ndjson"
fi

if ((NO_WAF != 1)); then
	kibana_index_patterns "${TMPL_DIR}/airlock-waf-index-patterns.json"
	kibana_import "${TMPL_DIR}/airlock-waf-kibana.ndjson"
fi

echo -e "\n\e[0;32mKibana setup completed\e[0m\n"