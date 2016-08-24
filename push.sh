#!/bin/bash

set -eo pipefail

aws configure set s3.signature_version s3v4

login_to_registry() {
  local region="$(get_region)"
  eval "$(aws ecr get-login)"
}

get_region() {
  if [[ $AWS_DEFAULT_REGION ]]; then
    echo $AWS_DEFAULT_REGION
    return
  fi

  echo 'us-east-1'
}

get_account_id() {
  echo "$(aws sts get-caller-identity --output text --query Account)"
}

get_registry_endpoint() {
  local account_id="$(get_account_id)"
  local region="$(get_region)"
  echo "${account_id}.dkr.ecr.${region}.amazonaws.com"
}

get_full_docker_name() {
  local registry="$(get_registry_endpoint)"
  echo "${registry}/$1"
}

ensure_repo_exists() {
  local repo_name="$1"
  local region="$(get_region)"
  local search="$(aws ecr describe-repositories)"
  # Use jq filtering instead of specifying repo name to aws cli because a search with no results will
  # return with a non-zero exit code instead of an empty array
  local filtered_search="$(echo "$search" | jq -r ".repositories | map(select(.repositoryName==\"${repo_name}\"))")"

  if [[ $(echo "$filtered_search" | jq -r 'length') -eq 0 ]]; then
    echo "Creating docker repository ${repo_name}"
    aws ecr create-repository --repository-name "${repo_name}"
  fi
}

main() {
  local docker_full_name="$(get_full_docker_name ${TARGET_REPO})"
  local destination_tag="$TARGET_TAG"
  local registry="$(get_registry_endpoint)"

  if [[ ! $destination_tag ]]; then
    destination_tag="latest"
  fi

  ensure_repo_exists ${TARGET_REPO}

  login_to_registry
  docker tag $DOCKER_IMAGE $docker_full_name:$destination_tag
  docker push ${docker_full_name}:${destination_tag}

  # Remove remote registry tag
  docker rmi $docker_full_name:$destination_tag
}

main "$@"
