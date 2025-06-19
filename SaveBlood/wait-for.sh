#!/bin/sh
# wait-for.sh HOST PORT -- COMMAND

set -e

host="$1"
port="$2"
shift 2

echo "⏳ Waiting for $host:$port..."

until nc -z "$host" "$port"; do
  echo "🔁 Still waiting for $host:$port..."
  sleep 2
done

echo "✅ $host:$port is available, starting app..."
exec "$@"
