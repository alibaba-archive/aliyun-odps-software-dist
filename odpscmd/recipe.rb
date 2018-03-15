class OdpscmdPublic < FPM::Cookery::Recipe
  name     'odpscmd'
  version  '0.29.1'
  revision '1'
  arch     'noarch'

  homepage    'http://github.com/aliyun/aliyun-odps-console'
  source      'http://repo.aliyun.com/download/odpscmd/0.29.1/odpscmd_public.zip'
  md5         '28ea665bccd4bd7b33a85b642b8f5dc8'
  description 'Aliyun ODPS Command Line Tool'
  section     'database'
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
    bin.install workdir('odpscmd')

    opt('odpscmd').mkdir
    opt('odpscmd').install 'conf'
    opt('odpscmd').install 'lib'
    opt('odpscmd').install 'plugins'
  end
end
