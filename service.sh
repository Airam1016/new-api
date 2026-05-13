#!/bin/bash
cd "$(dirname "$0")" || exit

start() {
  lsof -ti :3000 | xargs kill -9 2>/dev/null
  go run main.go &
  sleep 3
  cd web/default || exit
  nohup bun run dev > /dev/null 2>&1 &
  cd ../..
  echo ""
  echo "  后端: http://localhost:3000"
  echo "  前端: http://localhost:5173"
  echo "  停止: ./service.sh stop"
}

stop() {
  echo "=== 停止 new-api ==="
  lsof -ti :3000 | xargs kill -9 2>/dev/null
  lsof -ti :5173 | xargs kill -9 2>/dev/null
  echo "已停止"
}

case "${1}" in
  start)   start ;;
  stop)    stop ;;
  restart) stop; start ;;
  *)       echo "用法: ./service.sh {start|stop|restart}" ;;
esac
