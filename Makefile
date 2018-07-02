# railsを初期化する
.PHONY: init
init:
	bundle init
	sed -i '' 's/^# gem/gem/' Gemfile
	touch Gemfile.lock
	docker-compose run app rails new . --force --database=mysql --skip-bundle --skip-git
	# config/database.yml passwordとhostを変更する

# サーバーを起動する
.PHONY: up
up:
	rm -rf tmp/pids/server.pid
	docker-compose up

# method1
# ターゲット名が引数に含まれていた場合エラー　'make run foo bar run'
# すでに定義されているターゲット名が引数に含まれていた場合実行してしまう
echo:
	@echo ./prog $(filter-out $@, $(MAKECMDGOALS))
%:
	@true

# method2
# すでに定義されているターゲット名が引数に含まれていた場合overriteしてしまう
ifeq (filter, $(firstword $(MAKECMDGOALS)))
  runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(runargs):;@true)
endif

filter:
	@echo $(runargs)

# railsのメソッドを実行する(e.g. make rails db:migrate)
rails:
	docker-compose run app rails $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
