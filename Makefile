DCE           = docker exec -w /home/wwwroot/sf5
DCR           = $(DCE) sf5_php
DC            = $(DCE) --user=www-data sf5_php
EXEC_PHP      = php
SYMFONY       = $(EXEC_PHP) bin/console
COMPOSER      = composer
DOCKER        = docker-compose
CS_FIXER      = $(EXEC_PHP) vendor/friendsofphp/php-cs-fixer/php-cs-fixer
.DEFAULT_GOAL = help

## -- Misc -----------------------------------------------------------
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

fix-cs: ## Run cs-fixer
	$(DCR) $(CS_FIXER) fix src/

bash: ## Get inside the container
	$(DCE) --user=www-data -it sf5_php /bin/bash

## -- Docker -----------------------------------------------------------
up: ## Start the containers
	$(DOCKER) up -d

down: ## Stop the containers
	$(DOCKER) down

## -- Composer -----------------------------------------------------------
install: composer.lock ## Install vendors according to the current composer.lock file
	$(DC) $(COMPOSER) install --no-progress --no-suggest --prefer-dist --optimize-autoloader

update: composer.json ## Update vendors according to the composer.json file
	$(DC) $(COMPOSER) update

## -- Symfony -----------------------------------------------------------
sf: ## List all Symfony commands
	$(DC) $(SYMFONY)

cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	$(DC) $(SYMFONY) c:c

warmup: ## Warmump the cache
	$(DC) $(SYMFONY) cache:warmup

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

assets: purge ## Install the assets with symlinks in the public folder
	$(DC) $(SYMFONY) assets:install public/ --symlink --relative

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*
