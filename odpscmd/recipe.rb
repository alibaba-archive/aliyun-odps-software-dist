class OdpscmdPublic < FPM::Cookery::Recipe
  name     'odpscmd'
  version  '0.20.1'
  revision '3'
  arch     'noarch'

  homepage    'http://github.com/aliyun/aliyun-odps-console'
  source      'https://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/cn/odps/0.0.62/assets/download/odpscmd_public.zip'
  md5         '17687cb46fa4cfd441956b8fe4ed634b'
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
