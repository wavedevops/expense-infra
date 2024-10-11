.PHONY: apply destroy

apply:
	for dir in 05-app-alb 06-backend 07-acm 08-web-alb 09-frontend; do \
		echo "Applying in $$dir..."; \
		(cd $$dir && make apply); \
	done

destroy:
	for dir in 09-frontend 08-web-alb 07-acm 06-backend 05-app-alb 04-db 03-vpn-bastion 02-sg 01-vpc; do \
		echo "Destroying in $$dir..."; \
		(cd $$dir && make destroy); \
	done
