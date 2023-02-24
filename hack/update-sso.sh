#!/bin/bash  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

# The hostname must be 
TARGET_HOSTNAME=$1  
if [[ -z "$TARGET_HOSTNAME" ]]; then
  echo "No hostname passed to update the FrontendEnvironment" 
  echo "This is likely because SOUP_HOSTNAME env variable not set" 
  exit 
fi

SSO_HOST_KEYCLOAK=$( kubectl get routes keycloak -n dev-sso  -o jsonpath={".spec.host"})

cat << EOF > $ROOT/components/hac-boot/environment.yaml
apiVersion: cloud.redhat.com/v1alpha1
kind: FrontendEnvironment
metadata:
  name: env-boot
spec: 
# Use hack/update-sso.sh to compute this for dev-sso auth domain 
  sso: "https://$SSO_HOST_KEYCLOAK/auth/" 
  ingressClass: openshift-default
  hostname: $TARGET_HOSTNAME
EOF

yq -i '.spec.rules[0].host="'$TARGET_HOSTNAME'"'  $ROOT/components/hac-boot/proxy-ingress.yaml

echo "[INFO] SSO configuration for Frontend:"
echo "$ROOT/components/hac-boot/proxy-ingress.yaml has been updated to $TARGET_HOSTNAME"
echo "$ROOT/components/hac-boot/environment.yaml has been updated to "https://$SSO_HOST_KEYCLOAK/auth/" "