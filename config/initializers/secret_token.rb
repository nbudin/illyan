# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
Rails.application.config
Rails.application.config.secret_token = (
  ENV['SECRET_TOKEN'] ||
  'e7a133181a26379f49ca370a74fb9d9dfa4423d905abcae378ba6d5c45a584ba8819f1e824248504211b8faa060f95dbab47b3094163d25f259ad84b645c33cb'
  )
Rails.application.config.secret_key_base = (
  ENV['SECRET_KEY_BASE'] ||
  '8748a5986800b5ee7b77dcedd275308f7ee20e1f6b56e942968797d5a3e26185ac66890f5012f00e2d82efc70916a6d4dc85ccc597cb46278dc2d84859d02d7b'
  )