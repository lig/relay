#!/usr/bin/env python3
"""Convert chatmail.ini files into Jsonnet values templates."""

from __future__ import annotations

import argparse
import configparser
import json
import sys
from pathlib import Path
from typing import Any, Dict


DEFAULTS: Dict[str, Any] = {
    "max_user_send_per_minute": 60,
    "max_mailbox_size": "100M",
    "max_message_size": 31457280,
    "delete_mails_after": "20",
    "delete_large_after": "7",
    "delete_inactive_users_after": 90,
    "username_min_length": 9,
    "username_max_length": 9,
    "password_min_length": 9,
    "passthrough_senders": "",
    "passthrough_recipients": "",
    "www_folder": "",
    "filtermail_smtp_port": 10080,
    "filtermail_smtp_port_incoming": 10081,
    "postfix_reinject_port": 10025,
    "postfix_reinject_port_incoming": 10026,
    "disable_ipv6": False,
    "acme_email": "",
    "mtail_address": None,
    "imap_rawlog": False,
}


def parse_bool(value: str | None, default: bool) -> bool:
    if value is None:
        return default
    value = value.strip().lower()
    if value in {"", "none"}:
        return default
    return value == "true"


def parse_int(value: str | None, default: int) -> int:
    if value is None:
        return default
    value = value.strip()
    if value == "":
        return default
    return int(value)


def parse_str(value: str | None, default: str = "") -> str:
    if value is None:
        return default
    return value.strip()


def parse_optional_str(value: str | None) -> str | None:
    if value is None:
        return None
    stripped = value.strip()
    return stripped or None


def parse_list(value: str | None) -> list[str]:
    if value is None:
        return []
    return [item for item in value.split() if item]


def load_ini(path: Path) -> Dict[str, Any]:
    config = configparser.ConfigParser()
    config.read(path)
    if "params" not in config:
        raise ValueError(f"{path} does not contain a [params] section")
    params = config["params"]

    mail_domain = parse_str(params.get("mail_domain"))
    if not mail_domain:
        raise ValueError("mail_domain must be set in chatmail.ini")

    data: Dict[str, Any] = {
        "mail_domain": mail_domain,
        "max_user_send_per_minute": parse_int(
            params.get("max_user_send_per_minute"), DEFAULTS["max_user_send_per_minute"]
        ),
        "max_mailbox_size": parse_str(params.get("max_mailbox_size"), DEFAULTS["max_mailbox_size"]),
        "max_message_size": parse_int(params.get("max_message_size"), DEFAULTS["max_message_size"]),
        "delete_mails_after": parse_str(
            params.get("delete_mails_after"), DEFAULTS["delete_mails_after"]
        ),
        "delete_large_after": parse_str(
            params.get("delete_large_after"), DEFAULTS["delete_large_after"]
        ),
        "delete_inactive_users_after": parse_int(
            params.get("delete_inactive_users_after"), DEFAULTS["delete_inactive_users_after"]
        ),
        "username_min_length": parse_int(
            params.get("username_min_length"), DEFAULTS["username_min_length"]
        ),
        "username_max_length": parse_int(
            params.get("username_max_length"), DEFAULTS["username_max_length"]
        ),
        "password_min_length": parse_int(
            params.get("password_min_length"), DEFAULTS["password_min_length"]
        ),
        "passthrough_senders": parse_list(params.get("passthrough_senders")),
        "passthrough_recipients": parse_list(params.get("passthrough_recipients")),
        "www_folder": parse_str(params.get("www_folder"), DEFAULTS["www_folder"]),
        "filtermail_smtp_port": parse_int(
            params.get("filtermail_smtp_port"), DEFAULTS["filtermail_smtp_port"]
        ),
        "filtermail_smtp_port_incoming": parse_int(
            params.get("filtermail_smtp_port_incoming"), DEFAULTS["filtermail_smtp_port_incoming"]
        ),
        "postfix_reinject_port": parse_int(
            params.get("postfix_reinject_port"), DEFAULTS["postfix_reinject_port"]
        ),
        "postfix_reinject_port_incoming": parse_int(
            params.get("postfix_reinject_port_incoming"), DEFAULTS["postfix_reinject_port_incoming"]
        ),
        "disable_ipv6": parse_bool(params.get("disable_ipv6"), DEFAULTS["disable_ipv6"]),
        "acme_email": parse_str(params.get("acme_email"), DEFAULTS["acme_email"]),
        "mtail_address": parse_optional_str(params.get("mtail_address")),
        "imap_rawlog": parse_bool(params.get("imap_rawlog"), DEFAULTS["imap_rawlog"]),
        "privacy_postal": parse_optional_str(params.get("privacy_postal")),
        "privacy_mail": parse_optional_str(params.get("privacy_mail")),
        "privacy_pdo": parse_optional_str(params.get("privacy_pdo")),
        "privacy_supervisor": parse_optional_str(params.get("privacy_supervisor")),
        "mailboxes_dir": parse_optional_str(params.get("mailboxes_dir")),
    }

    iroh_value = params.get("iroh_relay")
    if iroh_value is not None:
        data["iroh_relay"] = iroh_value.strip()

    return data


def render_jsonnet(config: Dict[str, Any]) -> str:
    features = {
        "enableMail": True,
        "enableIrohRelay": "iroh_relay" not in config,
        "enableMtail": bool(config.get("mtail_address")),
    }

    body = {
        "config": config,
        "features": features,
    }

    json_text = json.dumps(body, indent=2, sort_keys=True)
    lines = json_text.splitlines()
    output_lines = ["// Generated by ini_to_jsonnet.py"]
    output_lines.append("{")
    for idx, line in enumerate(lines):
        prefix = "  " if idx == 0 else ""
        output_lines.append(f"{prefix}{line}")
    output_lines.append("}")
    return "\n".join(output_lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ini", type=Path, help="Path to chatmail.ini file")
    parser.add_argument("-o", "--output", type=Path, help="Write result to file instead of stdout")
    args = parser.parse_args(argv)

    try:
        config = load_ini(args.ini)
    except Exception as exc:  # noqa: BLE001 - provide readable error
        parser.error(str(exc))

    rendered = render_jsonnet(config)

    if args.output:
        args.output.write_text(rendered)
    else:
        sys.stdout.write(rendered)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
