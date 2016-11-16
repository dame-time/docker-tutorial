#!/bin/bash

rmifpresent() {
	if docker ps -a | grep -q $1; then
		echo "Killing previous instance of $(docker rm -fv $1)..."
	fi
}

rmifpresent redis
rmifpresent chat

mkdir -p logs
touch logs/logfile.txt

docker run -d --name redis redis
docker run -d --name chat -p 80:8000 -v $(pwd)/logs:/app/logs --link redis:redis -e REDIS_URL=redis://redis:6379 dt/chat

tail -f logs/logfile.txt
