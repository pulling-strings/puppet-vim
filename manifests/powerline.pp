# Setting up vim powerline fonts
class vim::powerline {

  $fonts = "${vim::home}/.fonts"

  file{$fonts:
    ensure => directory
  }

  git::clone {"${fonts}/ubuntu-mono-powerline":
    url      => 'git://github.com/scotu/ubuntu-mono-powerline.git',
    dst      => "${fonts}/ubuntu-mono-powerline",
    owner    => $vim::user,
    require  => File[$fonts]
  }

}
