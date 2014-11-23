config_file      ::File.join('@work_dir', 'client.rb')
cache_path       ::File.join('@work_dir', '.chef')
client_key       ::File.join('@work_dir', 'client.pem')
json_attribs     ::File.join('@work_dir', 'attributes.json')
chef_server_url  'https://api.opscode.com/organizations/spaux'
ssl_verify_mode  :verify_peer
no_lazy_load     true
node_name        'spaux'
override_runlist ["recipe[spaux::machine]"]
