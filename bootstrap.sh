# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo 'updating package information'
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

echo 'installing ruby-install'
wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz >/dev/null 2>&1
tar -xzvf ruby-install-0.5.0.tar.gz >/dev/null 2>&1
cd ruby-install-0.5.0/
make install
cd ..

echo 'installing ruby'
ruby-install ruby 2.2.0 >/dev/null 2>&1

install 'ruby dev' ruby-dev

echo 'installing chruby'
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz >/dev/null 2>&1
tar -xzvf chruby-0.3.9.tar.gz >/dev/null 2>&1
cd chruby-0.3.9/
make install
cd ..

echo 'do chruby load automatically'
sed -i '$ a\source /usr/local/share/chruby/chruby.sh' ~/.bashrc 
sed -i '$ a\source /usr/local/share/chruby/auto.sh' ~/.bashrc 
. ~/.bashrc

echo 'annotate ruby default version'
printf "ruby-2.2.0\n" > ~/.ruby-version

echo 'installling rails'
gem install rails -v 4.2.0 --no-rdoc --no-ri >/dev/null 2>&1

install Git git
install SQLite sqlite3 libsqlite3-dev
#install memcached memcached
#install Redis redis-server
#install RabbitMQ rabbitmq-server

#install PostgreSQL postgresql postgresql-contrib libpq-dev
#sudo -u postgres createuser --superuser vagrant
#sudo -u postgres createdb -O vagrant activerecord_unittest
#sudo -u postgres createdb -O vagrant activerecord_unittest2

install 'ExecJS runtime' nodejs

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'