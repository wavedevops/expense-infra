apply:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform apply -auto-approve -var-file=inputs.tfvars


destroy:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform destroy -auto-approve -var-file=inputs.tfvars
