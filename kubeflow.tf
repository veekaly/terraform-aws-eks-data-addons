locals {
  kubeflow_name     = "kubeflow"
  kubeflow_repo     = "https://github.com/kubeflow"
  kubeflow_version  = "v1.7.0"
  istio_version     = "1.17"
}

data "kustomization" "istio_crds" {
  path = "${path.module}/manifests/kubeflow/common/istio-${replace(local.istio_version, ".", "-")}/istio-crds/base"
}

resource "kustomization_resource" "istio_crds" {
  for_each = data.kustomization.istio_crds.ids
  manifest = data.kustomization.istio_crds.manifests[each.value]
}

data "kustomization" "istio_namespace" {
  path = "${path.module}/manifests/kubeflow/common/istio-${replace(local.istio_version, ".", "-")}/istio-namespace/base"
}

resource "kustomization_resource" "istio_namespace" {
  for_each = data.kustomization.istio_namespace.ids
  manifest = data.kustomization.istio_namespace.manifests[each.value]
}

data "kustomization" "istio_install" {
  path = "${path.module}/manifests/kubeflow/common/istio-${replace(local.istio_version, ".", "-")}/istio-install/base"
}

resource "kustomization_resource" "istio_install" {
  for_each = data.kustomization.istio_install.ids
  manifest = data.kustomization.istio_install.manifests[each.value]
}

# Decide if we need to use oidc-authservice or OAuth2-proxy
data "kustomization" "oidc_authservice" {
  path = "${path.module}/manifests/kubeflow/common/oidc-client/oidc-authservice/base"
}

resource "kustomization_resource" "oidc_authservice" {
  for_each = data.kustomization.oidc_authservice.ids
  manifest = data.kustomization.oidc_authservice.manifests[each.value]
}

# Decide if dex should be deployed through helm or kustomize
data "kustomization" "dex_overlays" {
  path = "${path.module}/manifests/kubeflow/common/dex/overlays/istio"
}

resource "kustomization_resource" "dex_overlays" {
  for_each = data.kustomization.dex_overlays.ids
  manifest = data.kustomization.dex_overlays.manifests[each.value]
}

data "kustomization" "knative_serving" {
  path = "${path.module}/manifests/kubeflow/common/knative/knative-serving/overlays/gateways"
}

resource "kustomization_resource" "knative_serving" {
  for_each = data.kustomization.knative_serving.ids
  manifest = data.kustomization.knative_serving.manifests[each.value]
}

data "kustomization" "knative_local_gateway" {
  path = "${path.module}/manifests/kubeflow/common/istio-${replace(local.istio_version, ".", "-")}/cluster-local-gateway/base"
}

resource "kustomization_resource" "knative_local_gateway" {
  for_each = data.kustomization.knative_local_gateway.ids
  manifest = data.kustomization.knative_local_gateway.manifests[each.value]
}

# This is optional, parameterize it later
data "kustomization" "knative_eventing" {
  path = "${path.module}/manifests/kubeflow/common/knative/knative-eventing/base"
}

resource "kustomization_resource" "knative_eventing" {
  for_each = data.kustomization.knative_eventing.ids
  manifest = data.kustomization.knative_eventing.manifests[each.value]
}

data "kustomization" "kubeflow_namespace" {
  path = "${path.module}/manifests/kubeflow/common/kubeflow-namespace/base"
}

resource "kustomization_resource" "kubeflow_namespace" {
  for_each = data.kustomization.kubeflow_namespace.ids
  manifest = data.kustomization.kubeflow_namespace.manifests[each.value]
}

data "kustomization" "kubeflow_roles" {
  path = "${path.module}/manifests/kubeflow/common/kubeflow-roles/base"
}

resource "kustomization_resource" "kubeflow_roles" {
  for_each = data.kustomization.kubeflow_roles.ids
  manifest = data.kustomization.kubeflow_roles.manifests[each.value]
}

data "kustomization" "kubeflow_istio" {
  path = "${path.module}/manifests/kubeflow/common/istio-${replace(local.istio_version, ".", "-")}/kubeflow-istio-resources/base"
}

resource "kustomization_resource" "kubeflow_istio" {
  for_each = data.kustomization.kubeflow_istio.ids
  manifest = data.kustomization.kubeflow_istio.manifests[each.value]
}

data "kustomization" "kubeflow_multiuser_pipeline" {
  path = "${path.module}/manifests/kubeflow/apps/pipeline/upstream/env/cert-manager/platform-agnostic-multi-user"
}

resource "kustomization_resource" "kubeflow_multiuser_pipeline" {
  for_each = data.kustomization.kubeflow_multiuser_pipeline.ids
  manifest = data.kustomization.kubeflow_multiuser_pipeline.manifests[each.value]
}

data "kustomization" "kserve_base" {
  path = "${path.module}/manifests/kubeflow/contrib/kserve/kserve"
}

resource "kustomization_resource" "kserve_base" {
  for_each = data.kustomization.kserve_base.ids
  manifest = data.kustomization.kserve_base.manifests[each.value]
}

data "kustomization" "kserve_models" {
  path = "${path.module}/manifests/kubeflow/contrib/kserve/models-web-app/overlays/kubeflow"
}

resource "kustomization_resource" "kserve_models" {
  for_each = data.kustomization.kserve_models.ids
  manifest = data.kustomization.kserve_models.manifests[each.value]
}

data "kustomization" "katib" {
  path = "${path.module}/manifests/kubeflow/apps/katib/upstream/installs/katib-with-kubeflow"
}

resource "kustomization_resource" "katib" {
  for_each = data.kustomization.katib.ids
  manifest = data.kustomization.katib.manifests[each.value]
}

data "kustomization" "kubeflow_dashboard" {
  path = "${path.module}/manifests/kubeflow/apps/centraldashboard/upstream/overlays/kserve"
}

resource "kustomization_resource" "kubeflow_dashboard" {
  for_each = data.kustomization.kubeflow_dashboard.ids
  manifest = data.kustomization.kubeflow_dashboard.manifests[each.value]
}

data "kustomization" "kubeflow_webhook" {
  path = "${path.module}/manifests/kubeflow/apps/admission-webhook/upstream/overlays/cert-manager"
}

resource "kustomization_resource" "kubeflow_webhook" {
  for_each = data.kustomization.kubeflow_webhook.ids
  manifest = data.kustomization.kubeflow_webhook.manifests[each.value]
}

data "kustomization" "notebook_controller" {
  path = "${path.module}/manifests/kubeflow/apps/jupyter/notebook-controller/upstream/overlays/kubeflow"
}

resource "kustomization_resource" "notebook_controller" {
  for_each = data.kustomization.notebook_controller.ids
  manifest = data.kustomization.notebook_controller.manifests[each.value]
}

data "kustomization" "jupyter_webapp" {
  path = "${path.module}/manifests/kubeflow/apps/jupyter/jupyter-web-app/upstream/overlays/istio"
}

resource "kustomization_resource" "jupyter_webapp" {
  for_each = data.kustomization.jupyter_webapp.ids
  manifest = data.kustomization.jupyter_webapp.manifests[each.value]
}

data "kustomization" "profiles_controller" {
  path = "${path.module}/manifests/kubeflow/apps/profiles/upstream/overlays/kubeflow"
}

resource "kustomization_resource" "profiles_controller" {
  for_each = data.kustomization.profiles_controller.ids
  manifest = data.kustomization.profiles_controller.manifests[each.value]
}

data "kustomization" "volumes_webapp" {
  path = "${path.module}/manifests/kubeflow/apps/volumes-web-app/upstream/overlays/istio"
}

resource "kustomization_resource" "volumes_webapp" {
  for_each = data.kustomization.volumes_webapp.ids
  manifest = data.kustomization.volumes_webapp.manifests[each.value]
}

data "kustomization" "tensorboard_webapp" {
  path = "${path.module}/manifests/kubeflow/apps/tensorboard/tensorboards-web-app/upstream/overlays/istio"
}

resource "kustomization_resource" "tensorboard_webapp" {
  for_each = data.kustomization.tensorboard_webapp.ids
  manifest = data.kustomization.tensorboard_webapp.manifests[each.value]
}

data "kustomization" "tensorboard_controller" {
  path = "${path.module}/manifests/kubeflow/apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow"
}

resource "kustomization_resource" "tensorboard_controller" {
  for_each = data.kustomization.tensorboard_controller.ids
  manifest = data.kustomization.tensorboard_controller.manifests[each.value]
}

data "kustomization" "training_operator" {
  path = "${path.module}/manifests/kubeflow/apps/training-operator/upstream/overlays/kubeflow"
}

resource "kustomization_resource" "training_operator" {
  for_each = data.kustomization.training_operator.ids
  manifest = data.kustomization.training_operator.manifests[each.value]
}

data "kustomization" "default_user" {
  path = "${path.module}/manifests/kubeflow/common/user-namespace/base"
}

resource "kustomization_resource" "default_user" {
  for_each = data.kustomization.default_user.ids
  manifest = data.kustomization.default_user.manifests[each.value]
}




