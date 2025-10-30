// Placeholder for chatmail web asset deployment.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Package static web assets from www/ into ConfigMaps or container image.',
    sources: [
      'www/src/index.md',
      'www/src/info.md',
      'www/src/privacy.md',
      'www/src/page-layout.html',
      'www/src/main.css',
    ],
    k8sMapping: [
      'ConfigMap containing rendered HTML served by nginx pod',
      'Optional build container image pushed to registry',
      'Documentation for custom www_folder overrides',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement web asset packaging',
      source: cfg.www_folder,
    },
}
