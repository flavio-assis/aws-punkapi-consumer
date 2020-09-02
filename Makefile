ENV=test

.PHONY: init	plan	validate	apply	zip_packages	zip_main_py	zip_main_async_py	unittests

all:  init  plan

init:
	cd terraform/${ENV} && terraform init  -reconfigure

plan:
	cd terraform/${ENV} && terraform plan

validate:
	cd terraform/${ENV} && terraform validate

apply:
	cd terraform/${ENV} && terraform apply -auto-approve

zip_packages:
	cd aws_lambda/package && zip -r9 ../aws_lambda.zip .

zip_main_py:
	cd aws_lambda && zip -g aws_lambda.zip main.py

zip_main_async_py:
	cd aws_lambda && zip -g aws_lambda.zip main_async.py

zip_lambda_function: zip_packages zip_main_py zip_main_async_py

unittests:
	cd aws_lambda && python3 -m unittest discover

tests:	unittests	validate