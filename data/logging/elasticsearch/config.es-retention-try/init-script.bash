#!/bin/bash
#set -x

ES_URL=${ES_URL:-http://localhost:9200}
TMPL_DIR=${TMPL_DIR:-/var/tmp/elasticsearch}

# Wait for Elasticsearch to be up and running
while [[ "$(curl -s -o /dev/null -w '%{http_code}\n' ${ES_URL})" != "200" ]]; do sleep 1; done

function curl_es() {
  curl -fisS -w "\n" \
  	-X "${1}" \
  	${3:+-H "Content-Type: application/json" -d "@$3"} \
  	"${ES_URL}${2}"
}

curl_es "PUT" "/_ilm/policy/airlock-ilm-policy" "${TMPL_DIR}/airlock-ilm-policy.json"

curl_es "PUT" "/_template/default" "${TMPL_DIR}/default-template.json"

if ((NO_IAM != 1)); then
  curl_es "PUT" "/_ingest/pipeline/airlock-iam-default-pipeline" "${TMPL_DIR}/airlock-iam-ingest-pipeline.json"
  curl_es "PUT" "/_template/airlock-iam" "${TMPL_DIR}/airlock-iam-template.json"
  curl_es "PUT" "/_template/airlock-iam" "${TMPL_DIR}/airlock-iam-settings.json"
fi

if ((NO_WAF != 1)); then
  curl_es "PUT" "/_ingest/pipeline/airlock-waf-default-pipeline" "${TMPL_DIR}/airlock-waf-ingest-pipeline.json"
  curl_es "PUT" "/_template/airlock-waf" "${TMPL_DIR}/airlock-waf-template.json"
  curl_es "PUT" "/_template/airlock-waf" "${TMPL_DIR}/airlock-waf-settings.json"
fi

echo -e "\n\e[0;32mElasticsearch setup completed\e[0m\n"