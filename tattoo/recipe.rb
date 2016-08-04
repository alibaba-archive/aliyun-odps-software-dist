class OdpsETL < FPM::Cookery::Recipe
  name     'tattoo'
  version  '1.1'
  revision '1'
  arch     'noarch'

  homepage    'http://repo.aliyun.com/etl/'
  source      'http://repo.aliyun.com/download/tattoo.tar.gz'
  md5         '565449d394cc9236f63129e1db245d5e'
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
