ECR Pusher
===========

ECR Pusher assists pushing docker images to AWS Elastic Container Registries. It will automatically create the repository at the registry if it does not already exist and encapsulate the login inside its own docker container. This allows for easy pushing to multiple registries without modifying the registry the docker host is configured for.

Usage
-----

ECR Pusher needs valid AWS credentials along with the docker image and tag you want to push.

```
docker run --privileged --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DOCKER_IMAGE=image:tag \
  -e TARGET_REPO=xxx \
  -e TARGET_TAG=xxx \
  -e AWS_ACCESS_KEY_ID=xxx \
  -e AWS_SECRET_ACCESS_KEY=xxx \
  -e AWS_SESSION_TOKEN=xxx \
  -e AWS_DEFAULT_REGION=xxx \
  bugcrowd/ecr-pusher
```
