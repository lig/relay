// Default environment overrides for the Tanka deployment.
// Copy this template and customize per cluster.
{
  config: {
    mail_domain: "example.org",
    acme_email: "ops@example.org",
    passthrough_senders: [],
    passthrough_recipients: ["echo@example.org"],
    mtail_address: null,
    disable_ipv6: false,
    www_folder: "www/build",
  },
  features: {
    enableMail: true,
    enableIrohRelay: true,
    enableMtail: false,
  },
}
