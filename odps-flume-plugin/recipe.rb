class OdpsFlumePlugin < FPM::Cookery::Recipe
  name     'odps-flume-plugin'
  version  '0.0.1'
  revision '1'
  arch     'noarch'

  homepage 'https://github.com/aliyun/aliyun-odps-flume-plugin'
  source   'https://github.com/aliyun/aliyun-odps-flume-plugin', :with => :git

  description 'ODPS Sink Plugin for Apache Flume'
  section     'databases'
  license     'Apache License 2.0'
  maintainer  'Li Ruibo <lymanrb@gmail.com>'
  depends     'flume-ng'
  fpm_attributes :rpm_os => 'linux'

  def build
  end

  def install
    opt('flume-ng/plugins.d').mkdir
    opt('flume-ng/plugins.d').install 'odps_sink'
    opt('flume-ng/conf').install 'odps_example.conf'
  end
end
