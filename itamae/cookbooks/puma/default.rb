remote_file 'copy puma.service' do
  source 'puma.service'
  path "/etc/systemd/system/puma.service"
end

service "apply policy" do
  name 'puma.service'
  action %w[enable start]
end
