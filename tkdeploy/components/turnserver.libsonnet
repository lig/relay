// Placeholder for TURN server deployment and UDP exposure.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Adapt chatmail-turn binary and systemd unit to Kubernetes workloads with UDP 3478.',
    sources: [
      'cmdeploy/src/cmdeploy/service/turnserver.service.f',
    ],
    k8sMapping: [
      'Deployment or DaemonSet with hostNetwork/NodePort for UDP 3478',
      'Secret for turnserver shared secret if required',
      'Lifecycle hooks to manage /run/chatmail-turn password exchange',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement TURN manifests',
      realm: cfg.mail_domain,
      udpPort: 3478,
    },
}
