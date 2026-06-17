#!/bin/sh
set -e
envsubst '${PORT} ${RESEARCH_TOOLS_URL} ${ANTIBUROCRATA_URL} ${BROCHURES_URL} ${PRION_SURVEY_URL} ${PRIOCOHORT_URL} ${JOKIN_TOOLS_URL} ${CERTIFICADOS_URL} ${TXPR_URL} ${PRIONLAB_URL} ${DNI_URL} ${WHATSAPP_FEEP_URL} ${ACTPRION_URL} ${CLINICAL_SCALES_URL} ${DONATION_URL}' \
    < /etc/nginx/nginx.conf.template \
    > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
