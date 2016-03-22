class OdpscmdPublic < FPM::Cookery::Recipe
  name     'odpscmd'
  version  '1.0'
  revision '1'
  arch     'noarch'

  homepage    'http://repo.aliyun.com/etl/'
  source      'http://repo.aliyun.com/download/tattoo.tar.gz'
  md5         'b04fb3e8a7d35b1cb1d666c0601d7889'
  description 'Aliyun ODPS ETL Tool'
  section     'database'
  license     'Apache License 2.0'
  maintainer  'onsuper <onesuperclark@gmail.com>'

  fpm_attributes :rpm_os => 'linux'

  case FPM::Cookery::Facts.target
  when :deb
  then
    depends  'default-jre-headless'
  when :rpm
  then
    depends 'java >= 1.7'
  end

  def build
  end

  def install
    bin.install workdir('tattoo')
    opt('tattoo').mkdir
    opt('tattoo').install 'lib'
  end
end
