# Parameters
PROJECT_NAME = clickshire

# Variables
BUILD_TAG = $(PROJECT_NAME):latest
CONTAINER_NAME = $(PROJECT_NAME)
HTTPS_PORT = 443
HTTP_PORT = 80

# PHONY Rule
.PHONY: all start build stop clean ngrok

# Rules
all: start 

start:
	@echo "$(PROJECT_NAME): Starting '$(CONTAINER_NAME)'"
	@docker start $(CONTAINER_NAME) > /dev/null

build:
	@echo "$(PROJECT_NAME): Building '$(BUILD_TAG)'"

	@echo ""
	@docker build -t $(BUILD_TAG) .
	@echo ""
	
	@echo "$(PROJECT_NAME): Creating Image '$(CONTAINER_NAME)'"
	@docker create -p $(HTTPS_PORT):443 -p $(HTTP_PORT):80 --name $(CONTAINER_NAME) $(BUILD_TAG) > /dev/null

stop:
	@echo "$(PROJECT_NAME): Stopping '$(CONTAINER_NAME)'"
	@docker stop $(CONTAINER_NAME) > /dev/null

clean:
	@echo "$(PROJECT_NAME): Removing '$(CONTAINER_NAME)'"
	@docker rm $(CONTAINER_NAME) > /dev/null

restart: stop start

rebuild: clean build

reload: stop clean build start

ngrok:
	@echo "$(PROJECT_NAME): Launching ngrok's server listening on port '$(HTTPS_PORT)'"
	@./bin/ngrok http $(HTTPS_PORT)
