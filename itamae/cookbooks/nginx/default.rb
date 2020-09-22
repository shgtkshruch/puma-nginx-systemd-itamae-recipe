# http://nginx.org/en/linux_packages.html#RHEL-CentOS

remote_file 'copy bash_profile' do
  source 'nginx.repo'
  path "/etc/yum.repos.d/nginx.repo"
end

package 'nginx'

directory "/etc/nginx/sites-available" do
  action :create
end

directory "/etc/nginx/sites-enabled" do
  action :create
end
