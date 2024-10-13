.PHONY: apply destroy

apply:
	for dir in 06-app-alb 07-backend  08-web-alb 09-frontend; do \
		echo "Applying in $$dir..."; \
		(cd $$dir && make apply); \
	done

destroy:
	for dir in 09-frontend 08-web-alb 07-backend 06-app-alb; do \
		echo "Destroying in $$dir..."; \
		(cd $$dir && make destroy); \
	done
