
all: build push

build:
	docker build -t bugcrowd/ecr-pusher .

push:
	docker push bugcrowd/ecr-pusher
