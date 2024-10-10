apply:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform apply -auto-approve
	#rm -rf .terraform ; rm -rf .terraform.lock.hcl

destroy:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform destroy -auto-approve
	rm -rf .terraform ; rm -rf .terraform.lock.hcl

