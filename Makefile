SHELL         = bash
PROJECT       = strangebuzz
EXEC_PHP      = php
REDIS         = redis-cli
GIT           = git
GIT_AUTHOR    = COil
SYMFONY       = $(EXEC_PHP) bin/console
SYMFONY_BIN   = ./symfony
COMPOSER      = $(EXEC_PHP) composer.phar
DOCKER        = docker-compose
BREW          = brew
.DEFAULT_GOAL = help
CS_FIXER      = $(EXEC_PHP) /root/.composer/vendor/friendsofphp/php-cs-fixer/php-cs-fixer
#.PHONY       = # Not needed for now

## -- Misc -----------------------------------------------------------
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

fix-cs: ## Run cs-fixer
	$(CS_FIXER) fix src/

## -- Composer -----------------------------------------------------------
install: composer.lock ## Install vendors according to the current composer.lock file
	$(COMPOSER) install --no-progress --no-suggest --prefer-dist --optimize-autoloader

update: composer.json ## Update vendors according to the composer.json file
	$(COMPOSER) update

## -- Symfony -----------------------------------------------------------
sf: ## List all Symfony commands
	$(SYMFONY)

cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	$(SYMFONY) c:c

warmup: ## Warmump the cache
	$(SYMFONY) cache:warmup

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

assets: purge ## Install the assets with symlinks in the public folder
	$(SYMFONY) assets:install public/ --symlink --relative

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*
