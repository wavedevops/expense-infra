.PHONY: apply destroy

GREEN  = \033[32m
RED    = \033[31m
YELLOW = \033[33m
RESET  = \033[0m

apply:
	for dir in 06-app-alb 07-backend 08-web-alb 09-frontend; do \
		echo -e "$(YELLOW)Applying in $(GREEN)$$dir$(RESET)..."; \
		(cd $$dir && make apply); \
	done

destroy:
	for dir in 10-cdn 09-frontend 08-web-alb 07-backend 06-app-alb; do \
		echo -e "$(YELLOW)Destroying in $(RED)$$dir$(RESET)..."; \
		(cd $$dir && make destroy); \
	done
