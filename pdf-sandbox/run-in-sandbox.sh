#!/bin/sh
# Every SSH session lands here via ForceCommand. The command the n8n SSH node
# sent arrives in SSH_ORIGINAL_COMMAND and runs in a fresh pdf-tools container
# that docker removes when it exits — nothing persists between jobs. The
# timeout stops a wedged job from leaving a container running forever.
[ -n "$SSH_ORIGINAL_COMMAND" ] || { echo "no command provided" >&2; exit 64; }

# Read-only view of the invoice drop dir (host path — job containers are
# spawned via the host docker socket), at the same path n8n sees it, so
# workflows can pass /data/invoice-uploads/... file paths straight through.
exec timeout 600 docker run --rm -i \
	--memory 2g --cpus 2 --pids-limit 256 \
	-v /home/n8n-solutions/invoice-uploads:/data/invoice-uploads:ro \
	pdf-tools:local bash -c "$SSH_ORIGINAL_COMMAND"
