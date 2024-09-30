apply:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform apply -auto-approve -var-file=inputs.tfvars
	rm -rf .terraform
	 rm -rf .terraform.lock.hcl

destroy:
	rm -rf .terraform ; rm -rf .terraform.lock.hcl
	terraform init
	terraform destroy -auto-approve -var-file=inputs.tfvars
	rm -rf .terraform
	rm -rf .terraform
	rm -rf .terraform.lock.hcl

