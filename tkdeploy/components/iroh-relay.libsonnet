// Placeholder for iroh-relay deployment and Service wiring.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Containerize iroh-relay with toml configuration and expose TCP 3340.',
    sources: [
      'cmdeploy/src/cmdeploy/iroh-relay.service',
      'cmdeploy/src/cmdeploy/iroh-relay.toml',
    ],
    k8sMapping: [
      'Deployment with ConfigMap containing iroh-relay.toml',
      'Service exposing TCP 3340 (and health endpoints)',
      'Feature flag to disable Deployment when external relay is configured',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement iroh-relay manifests',
      enabled: cfg.enable_iroh_relay,
      endpoint: cfg.iroh_relay,
    },
}
