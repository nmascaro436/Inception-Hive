COMPOSE_FILE = srcs/docker-compose.yml

all:
	mkdir -p /home/nmascaro/data/db
	mkdir -p /home/nmascaro/data/wp
	if [ ! -d "/home/nmascaro/data/db/mysql" ]; then chmod -R 777 /home/nmascaro/data; fi
	docker compose -f $(COMPOSE_FILE) up -d --build

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	docker compose -f $(COMPOSE_FILE) down --rmi all

fclean: clean
	rm -rf /home/nmascaro/data
	docker system prune -af

re: fclean all

.PHONY: all down clean fclean re up
