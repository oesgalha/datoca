# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

# Fix the annoying message:
# "sudo: unable to resolve host ubuntu-xenial: Connection refused"
sudo sed -i '/127.0.0.1 localhost/s|$| ubuntu-xenial|' /etc/hosts

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

install Ruby ruby2.3 ruby2.3-dev
update-alternatives --set ruby /usr/bin/ruby2.3 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.3 >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

install Git git
install SQLite sqlite3 libsqlite3-dev
install 'Nokogiri dependencies' zlib1g-dev libxml2 libxml2-dev libxslt1-dev
install 'ExecJS runtime' nodejs
install 'Image Magick (paperclip dependecy)' imagemagick

echo installing PhantomJS
PHANTOMVER="phantomjs-2.1.1-linux-x86_64"
wget -q "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMVER.tar.bz2"
tar -xjf "$PHANTOMVER.tar.bz2"
sudo mv "$PHANTOMVER/" "/usr/local/share/"
sudo ln -sf "/usr/local/share/$PHANTOMVER/bin/phantomjs" "/usr/local/bin"
rm "$PHANTOMVER.tar.bz2"

install PostgreSQL postgresql-9.5 postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser joker
sudo -u postgres psql -c "ALTER USER joker WITH PASSWORD 'king-of-spades';"

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo "Your datoca dev box is ready! :)"
