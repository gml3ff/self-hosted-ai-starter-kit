# n8n with the n8n-nodes-litellm community node baked in.
#
# The node is installed outside /home/node/.n8n because that path is shadowed
# by the n8n_storage volume at runtime. N8N_CUSTOM_EXTENSIONS points n8n's
# custom-directory loader at it (same layout `n8n-node dev` uses locally).
#
# To update the node: rebuild the tarball in the n8n-nodes-litellm repo
# (`npm run build && npm pack`), copy it here, and bump the filename below
# if the version changed.
FROM n8nio/n8n:latest

USER root
COPY n8n-nodes-litellm-0.1.1.tgz /tmp/n8n-nodes-litellm.tgz
# --ignore-scripts: n8n-workflow (peer dep) pulls native modules (isolated-vm,
# ssh2) whose builds need a toolchain this image lacks; they are not used on
# this node's load path, so skipping their build scripts is safe.
RUN mkdir -p /opt/custom-nodes && \
    cd /opt/custom-nodes && \
    npm install --ignore-scripts --omit=dev /tmp/n8n-nodes-litellm.tgz && \
    rm /tmp/n8n-nodes-litellm.tgz && \
    chown -R node:node /opt/custom-nodes

# Fail the image build if the node cannot be constructed in this environment.
RUN node -e "const c = require('/opt/custom-nodes/node_modules/n8n-nodes-litellm/dist/nodes/LmChatLiteLlm/LmChatLiteLlm.node.js').LmChatLiteLlm; const n = new c(); if (n.description.name !== 'lmChatLiteLlm') throw new Error('unexpected node name'); console.log('LiteLLM node loads OK:', n.description.displayName);"

USER node
ENV N8N_CUSTOM_EXTENSIONS=/opt/custom-nodes
