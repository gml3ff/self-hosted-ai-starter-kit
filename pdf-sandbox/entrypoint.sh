#!/bin/sh
set -e

# The job user; its password comes from the environment (PDF_SSH_PASSWORD in
# .env), never baked into the image.
if ! id pdfjob >/dev/null 2>&1; then
	adduser -D -s /bin/sh pdfjob
fi
echo "pdfjob:${PDF_SSH_PASSWORD:?PDF_SSH_PASSWORD must be set}" | chpasswd

# The mounted docker socket carries the host's docker group id, which won't
# match any group in this image — grant pdfjob whatever group owns it so
# run-in-sandbox.sh can spawn the job containers.
DOCKER_GID=$(stat -c %g /var/run/docker.sock)
GRP=$(getent group "$DOCKER_GID" | cut -d: -f1 || true)
if [ -z "$GRP" ]; then
	addgroup -g "$DOCKER_GID" dockersock
	GRP=dockersock
fi
addgroup pdfjob "$GRP"

ssh-keygen -A
exec /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
