RUBY_VERSION = '2.7.1'
NODE_VERSION = '14.11.0'
YARN_VERSION = '1.21.0'
HOME = "/home/#{node[:user]}"
RAILS_ROOT = "#{HOME}/app"
RBENV_ROOT = "#{HOME}/.rbenv"
RBENV_INIT = <<-EOS
  export RBENV_ROOT=#{RBENV_ROOT}
  export PATH="#{RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
EOS

execute 'yum update' do
  command 'yum update -y'
end

%w[
  git
  wget
  gcc
  gcc-c++
  bzip2
  openssl-devel
  libyaml-devel
  libffi-devel
  readline-devel
  zlib-devel
  gdbm-devel
  ncurses-devel
  libicu-devel
  cmake
  mysql-devel
].each do |pkg|
  package pkg
  user node[:user]
end

git 'install rbenv' do
  destination "#{HOME}/.rbenv"
  repository 'https://github.com/rbenv/rbenv.git'
  user node[:user]
end

remote_file 'copy bash_profile' do
  source 'bash_profile'
  path "#{HOME}/.bash_profile"
end

execute 'reload bash_profile' do
  command "source #{HOME}/.bash_profile"
end

git 'install ruby-build' do
  destination "#{HOME}/.rbenv/plugins/ruby-build"
  repository 'https://github.com/rbenv/ruby-build.git'
  user node[:user]
end

execute "install ruby #{RUBY_VERSION}" do
  command "#{RBENV_INIT} rbenv install #{RUBY_VERSION}"
  user node[:user]
  not_if "#{RBENV_INIT} rbenv versions | grep #{RUBY_VERSION}"
end

execute 'set ruby version' do
  command "#{RBENV_INIT} rbenv global #{RUBY_VERSION}"
  user node[:user]
  not_if "#{RBENV_INIT} rbenv global | grep #{RUBY_VERSION}"
end

execute 'install Bundler' do
  command "#{RBENV_INIT} gem install bundler --no-ri --no-rdoc"
  user node[:user]
  not_if "#{RBENV_INIT} gem list | grep bundler"
end

execute 'install Node.js' do
  command 'curl --silent --location \
          https://rpm.nodesource.com/setup_14.x | bash -'
  not_if 'node -v'
end

package 'nodejs' do
  not_if "node -v"
end

execute 'install Yarn' do
  command 'wget https://dl.yarnpkg.com/rpm/yarn.repo \
          -O /etc/yum.repos.d/yarn.repo'
  not_if 'yum list installed | grep yarn'
end

package 'yarn' do
  not_if "yarn -v"
end
