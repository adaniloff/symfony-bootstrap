ifndef UID
  UID = $(shell id -u)
endif
ifndef PROJECT_PATH
  PROJECT_PATH    = /home/wwwroot/sf5
  CMD = $(DOCKER_EXEC_WWW) -it sf5_php
else
  CMD =
endif

DOCKER_EXEC     = docker exec -w $(PROJECT_PATH)
DOCKER_EXEC_WWW = $(DOCKER_EXEC) --user=dev
EXEC_PHP        = php
SYMFONY         = $(EXEC_PHP) bin/console
COMPOSER        = composer
DC              = docker-compose
CS_FIXER        = $(EXEC_PHP) vendor/friendsofphp/php-cs-fixer/php-cs-fixer
.DEFAULT_GOAL   = help

SUPPORTED_COMMANDS := console fix-cs
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  COMMAND_ARGS := $(subst :,\:,$(COMMAND_ARGS))
  $(eval $(COMMAND_ARGS):;@:)
endif

## -- Docker -----------------------------------------------------------
.env.local:
	touch .env.local

init: .env.local ## Initialize the project (build images, etc)
	$(DC) build --build-arg PROJECT_PATH=$(PROJECT_PATH) --build-arg UID=$(UID)

up: ## Start the containers
	$(DC) up -d

down: ## Stop the containers
	$(DC) down

bash: ## Get inside the container
	$(DOCKER_EXEC_WWW) -it sf5_php /bin/bash

## -- Composer -----------------------------------------------------------
install: composer.lock ## Install vendors according to the current composer.lock file
	$(CMD) $(COMPOSER) install --no-progress --no-suggest --prefer-dist --optimize-autoloader

update: composer.json ## Update vendors according to the composer.json file
	$(CMD) $(COMPOSER) update

## -- Symfony -----------------------------------------------------------
console: ## List all Symfony commands
	$(CMD) $(SYMFONY) $(COMMAND_ARGS)

cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	$(CMD) $(SYMFONY) c:c

warmup: ## Warmump the cache
	$(CMD) $(SYMFONY) cache:warmup

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

assets: purge ## Install the assets with symlinks in the public folder
	$(CMD) $(SYMFONY) assets:install public/ --symlink --relative

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*

## -- Misc -----------------------------------------------------------
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.php_cs: .php_cs.dist ## Initialize & warn about fix-cs config changes
	@if [ -f .php_cs ]; \
	then\
		echo '\033[1;41m/!\ The .php_cs.dist file has changed. Please check your .php_cs file (this message will not be displayed again).\033[0m';\
		touch .php_cs;\
		exit 1;\
	else\
		echo cp .php_cs.dist .php_cs;\
		cp .php_cs.dist .php_cs;\
	fi

fix-cs: .php_cs ## Run cs-fixer
ifneq "$(COMMAND_ARGS)" ""
	$(CMD) $(CS_FIXER) fix $(COMMAND_ARGS) --config=.php_cs
else
	@echo 'Please specify the directories in which you want to run the fixer. For example: "make fix-cs src/ tests/".'
endif
