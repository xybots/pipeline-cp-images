#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit


packer_wrap() {
  local OPTS=""

  ${DRY_RUN:+echo ===} docker run -i --tty --rm \
    -e AWS_IMAGE_NAME=$AWS_IMAGE_NAME \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_REGION=$AWS_REGION \
    -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
    -e AWS_SSH_USERNAME=$AWS_SSH_USERNAME \
    -e AWS_SOURCE_AMI=$AWS_SOURCE_AMI \
    -e AWS_INTANCE_TYPE=$AWS_INTANCE_TYPE \
    -e AWS_SPOT_PRICE=$AWS_SPOT_PRICE \
    -e KUBERNETES_VERSION=$KUBERNETES_VERSION \
    -e ETCD_RELEASE_TAG=$ETCD_RELEASE_TAG \
    -e K8S_DNS_RELEASE_TAG=$K8S_DNS_RELEASE_TAG \
    -e HELM_RELEASE_TAG=$HELM_RELEASE_TAG \
    -e VAULT_VERSION=$VAULT_VERSION \
    -v $HOME/.aws:/root/.aws \
    -v $HOME/.ssh:/root/.ssh \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:$PWD \
    -w $PWD \
    $OPTS \
    hashicorp/packer:1.3.3 "$@" packer.json
}

main() {
  packer_wrap "$@"
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
