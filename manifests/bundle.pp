# setting up bundled plugins
class vim::bundle {
  $version = '1.0.0'
  $release = "vim-${version}"
  $url = "https://github.com/narkisr/.vim/releases/download/v${version}/${release}.tar.gz"
  $sum = '497e82187930f010e9231abe2d581f3c339dad41400c24abc058fb320cff5f08'

  archive {$release:
    ensure           => present,
    url              => $url,
    digest_string    => $sum,
    digest_type      => 'sha256',
    src_target       => '/usr/src',
    target           => $::vim::dot_vim,
    extension        => 'tar.gz',
    timeout          => '360',
    root_dir         => '/bundle',
    strip_components => 2
  }

  exec{'remove empty bundle':
    command => "rm -rf ${vim::dot_vim}/bundle",
    user    => root,
    path    => ['/usr/bin','/bin',],
    require => Git::Clone[$::vim::dot_vim],
  } -> Archive::Extract[$release]


  exec{'chown bundle':
    command => "chown -R ${::vim::user} ${vim::dot_vim}/bundle",
    user    => 'root',
    path    => ['/usr/bin','/bin', '/usr/sbin/'],
    require => Archive::Extract[$release]
  }
}
