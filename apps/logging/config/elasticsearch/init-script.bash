#!/bin/bash
set -x

ES_URL=${ES_URL:-http://localhost:9200}
TMPL_DIR=${TMPL_DIR:-/var/tmp/elasticsearch/}

# Wait for Elasticsearch to be up and running
while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' ${ES_URL})" != "200" ]]; do sleep 5; done

function curl_es() {
  curl -fisS -w "\n" \
  	-X "${1}" \
  	${3:+-H "Content-Type: application/json" -d "@$3"} \
  	"${ES_URL}${2}"
}

curl_es "PUT" "/_cluster/settings" "${TMPL_DIR}/ilm-settings.json"
curl_es "PUT" "/_ilm/policy/airlock-ilm-policy" "${TMPL_DIR}/airlock-ilm-policy.json"

curl_es "PUT" "/_ingest/pipeline/default-pipeline" "${TMPL_DIR}/default-ingest-pipeline.json"
curl_es "PUT" "/_template/default" "${TMPL_DIR}/default-template.json"
curl_es "PUT" "/default-000001" "${TMPL_DIR}/default-aliases.json"

if ((NO_IAM != 1)); then
  curl_es "PUT" "/_ingest/pipeline/airlock-iam-default-pipeline" "${TMPL_DIR}/airlock-iam-ingest-pipeline.json"
  curl_es "PUT" "/_template/airlock-iam" "${TMPL_DIR}/airlock-iam-template.json"
  curl_es "PUT" "/_template/airlock-iam-audit" "${TMPL_DIR}/airlock-iam-audit-template.json"
  curl_es "PUT" "/_template/airlock-iam-detail" "${TMPL_DIR}/airlock-iam-detail-template.json"
  curl_es "PUT" "/_template/airlock-iam-reporting" "${TMPL_DIR}/airlock-iam-reporting-template.json"
  curl_es "PUT" "/_template/airlock-iam-usertrail" "${TMPL_DIR}/airlock-iam-usertrail-template.json"
  curl_es "PUT" "/airlock-iam-detail-000001" "${TMPL_DIR}/airlock-iam-detail-aliases.json"
  curl_es "PUT" "/airlock-iam-audit-000001" "${TMPL_DIR}/airlock-iam-audit-aliases.json"
  curl_es "PUT" "/airlock-iam-usertrail-000001" "${TMPL_DIR}/airlock-iam-usertrail-aliases.json"
  curl_es "PUT" "/airlock-iam-reporting-000001" "${TMPL_DIR}/airlock-iam-reporting-aliases.json"
fi

if ((NO_WAF != 1)); then
  curl_es "PUT" "/_ingest/pipeline/airlock-waf-default-pipeline" "${TMPL_DIR}/airlock-waf-ingest-pipeline.json"
  curl_es "PUT" "/_template/airlock-waf" "${TMPL_DIR}/airlock-waf-template.json"
  curl_es "PUT" "/airlock-waf-default-000001" "${TMPL_DIR}/airlock-waf-aliases.json"
fi

echo -e "\n\e[0;32mElasticsearch setup completed\e[0m\n"