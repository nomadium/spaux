current_dir = File.dirname(__FILE__)
node_name                "spaux"
client_key               ::File.join(current_dir, 'spaux.pem')
chef_server_url          "https://api.opscode.com/organizations/spaux"
cookbook_path            [current_dir]
ssl_verify_mode          :verify_peer
