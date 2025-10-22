FROM docker.n8n.io/n8nio/n8n
USER root
COPY license_patched.js /usr/local/lib/node_modules/n8n/dist/license.js
COPY project_service_ee_patched.js /usr/local/lib/node_modules/n8n/dist/services/project.service.ee.js
RUN chmod 644 /usr/local/lib/node_modules/n8n/dist/license.js && \
    chmod 644 /usr/local/lib/node_modules/n8n/dist/services/project.service.ee.js
USER node