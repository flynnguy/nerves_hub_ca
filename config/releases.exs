import Config

working_dir = "/etc/ssl"

host = System.fetch_env!("HOST")

config :nerves_hub_ca, :api,
  verify: :verify_peer,
  fail_if_no_peer_cert: true,
  otp_app: :nerves_hub_ca,
  port: System.fetch_env!("PORT"),
  cacertfile: Path.join(working_dir, "ca.pem"),
  certfile: Path.join(working_dir, "#{host}.pem"),
  keyfile: Path.join(working_dir, "#{host}-key.pem")


config :nerves_hub_ca, CA.User,
  ca: Path.join(working_dir, "user-root-ca.pem"),
  ca_key: Path.join(working_dir, "user-root-ca-key.pem")

config :nerves_hub_ca, CA.Device,
  ca: Path.join(working_dir, "device-root-ca.pem"),
  ca_key: Path.join(working_dir, "device-root-ca-key.pem")

