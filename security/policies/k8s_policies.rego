package kubernetes.admission

deny[msg] {
  input.kind.kind == "Deployment"
  container := input.request.object.spec.template.spec.containers[_]
  not container.securityContext.runAsNonRoot
  msg = sprintf("container %s must runAsNonRoot", [container.name])
}