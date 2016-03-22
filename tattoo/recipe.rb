class OdpsETL < FPM::Cookery::Recipe
  name     'tattoo'
  version  '1.0'
  revision '1'
  arch     'noarch'

  homepage    'http://repo.aliyun.com/etl/'
  source      'http://repo.aliyun.com/download/tattoo.tar.gz'
  md5         '5711641f8ef2804bc4a44a5cd2f1fb02'
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
