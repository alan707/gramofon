CarrierWave.configure do |config|
  # config.cache_dir = "#{Rails.root}/tmp/uploads"
  # config.storage = :s3

  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIUEHW25WUS5VHGBA',                        # required
    :aws_secret_access_key  => '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',                        # required
    # :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    # :host                   => 's3.example.com',             # optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'gramofon'                     # required
  # config.fog_public     = false                                   # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end