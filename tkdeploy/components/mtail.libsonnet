// Placeholder for mtail deployment exposing Prometheus metrics.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Deploy mtail binary with delivered_mail.mtail program and expose metrics over HTTP.',
    sources: [
      'cmdeploy/src/cmdeploy/mtail/delivered_mail.mtail',
      'cmdeploy/src/cmdeploy/mtail/mtail.service.j2',
    ],
    k8sMapping: [
      'Deployment or DaemonSet for mtail binary with ConfigMap containing programs',
      'Service exposing metrics on port 3903',
      'Optional ServiceMonitor/PodMonitor for Prometheus scraping',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement mtail manifests',
      enabled: cfg.mtail_address != null,
      bindAddress: cfg.mtail_address,
    },
}
