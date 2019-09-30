declare -r KUBERNETES_VERSION=v1.15.3

declare -r HELM_VERSION=2.14.3
declare -r HELM=./darwin-amd64/helm

declare -rx ISTIO_VERSION=1.3.1

declare -x KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
