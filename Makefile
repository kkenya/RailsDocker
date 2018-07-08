# railsを初期化する
.PHONY: init
init:
	bundle init
	sed -i '' 's/^# gem/gem/' Gemfile
	touch Gemfile.lock
	docker-compose run app rails new . --force --database=mysql --skip-bundle --skip-git
	cp -f template/database.yml config/database.yml
	cp .env.dev.sample .env.dev

# イメージを構築する
.PHONY: build
build:
	docker-compose build

# アプリケーションを起動する
.PHONY: up
up:
	rm -rf tmp/pids/server.pid
	docker-compose up

# アプリケーションを再起動する
.PHONY: restart
restart:
	docker-compose restart

# ログを出力する
.PHONY: logs
logs:
	docker-compose logs

# アプリケーションを終了する
.PHONY: down
down:
	docker-compose down

# コンテナの一覧
.PHONY: ps
ps:
	docker-compose ps

# railsのメソッドを実行する(e.g. make rails db:migrate)
rails:
	docker-compose run app rails $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

# docker: 停止しているコンテナをすべて削除する
.PHONY: clean
clean:
	docker rm `docker ps -f "status=exited" -q`
