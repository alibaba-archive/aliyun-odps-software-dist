class ApacheFlume < FPM::Cookery::Recipe
  name     'flume-ng'
  version  '1.6.0'
  revision '1'
  arch     'noarch'

  homepage 'http://flume.apache.org/'
  source   "http://apache.fayea.com/flume/#{version}/apache-flume-#{version}-bin.tar.gz"
  md5      'defd21ad8d2b6f28cc0a16b96f652099'

  description 'A distributed service for collecting large amounts of log data'
  section     'databases'
  license     'Apache License 2.0'
  maintainer  'Li Ruibo <lymanrb@gmail.com>'
  fpm_attributes :rpm_os => 'linux'

  case FPM::Cookery::Facts.target
  when :deb
  then
    depends  'default-jre-headless'
  when :rpm
  then
    depends 'java >= 1.6'
  end

  def build
  end

  def install
    bin.install workdir("flume-ng")
    opt('flume-ng').mkdir
    opt('flume-ng').install 'bin'
    opt('flume-ng').install 'lib'
    opt('flume-ng').install 'conf'
  end
end
