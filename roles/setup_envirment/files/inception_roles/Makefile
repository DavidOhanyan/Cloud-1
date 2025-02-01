all: up #configure_volumes

up: #configure_volumes
	@echo "Lifting containers..."
	@docker compose -f ./srcs/docker-compose.yml up -d --build
	@echo "!DONE!"

down:
	@echo "Dropping containers..."
	@docker compose -f ./srcs/docker-compose.yml down
	@echo "!DONE!"

hard_down:
	@echo "Dropping containers and removing volumes..."
	@docker compose -f ./srcs/docker-compose.yml down -v
	@echo "!DONE!"

start:
	@echo "Starting containers..."
	@docker compose -f ./srcs/docker-compose.yml start
	@echo "!DONE!"

stop:
	@echo "Stopping containers..."
	docker compose -f ./srcs/docker-compose.yml stop
	@echo "!DONE!"

# configure_volumes:
# 	@mkdir -p /home/$USER/data/mariadb
# 	@mkdir -p /home/$USER/data/wordpress

remove_volumes:
	@rm -rf home/$USER/data/mariadb
	@rm -rf /home/$USER/data/wordpress
