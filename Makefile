ENV=test

.PHONY: init	plan	validate	apply	build_packages	zip_main_py	zip_main_async_py	unittests tests

all:  init  plan

init:
	cd terraform/${ENV} && terraform init  -reconfigure

plan:
	cd terraform/${ENV} && terraform plan

validate:
	cd terraform/${ENV} && terraform validate

apply:
	cd terraform/${ENV} && terraform apply -auto-approve

build_packages:
	mkdir -p aws_lambda/package && pip3 install -r aws_lambda/requirements.txt --target  aws_lambda/package --upgrade

zip_packages:
	cd aws_lambda/package && zip -r9 ../aws_lambda.zip .

zip_main_py:
	cd aws_lambda && zip -g aws_lambda.zip main.py

zip_main_async_py:
	cd aws_lambda && zip -g aws_lambda.zip main_async.py

zip_lambda_function: build_packages	zip_packages zip_main_py zip_main_async_py

unittests:
	cd aws_lambda && python3 -m unittest discover

tests:	unittests	validate