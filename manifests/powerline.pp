# Setting up vim powerline fonts
class vim::powerline($home='',$username='') {

  $fonts = "${home}/.fonts"

  file{$fonts:
    ensure => directory
  }

  git::clone {"${fonts}/ubuntu-mono-powerline":
    url      => 'git://github.com/scotu/ubuntu-mono-powerline.git',
    dst      => "${fonts}/ubuntu-mono-powerline",
    owner    => $username,
    require  => File[$fonts]
  }

}
