# vim managment
class vim($home=false, $user=false){
  validate_string($home)
  validate_string($user)

  $vim_pack = $vim::is_desktop? {
    'true'  =>'vim-gtk',
    'false' =>'vim-nox'
  }

  package{$vim::vim_pack:
    ensure  => present
  }

  $dot_vim= "${home}/.vim"

  git::clone {$vim::dot_vim:
    url   => 'git://github.com/narkisr/.vim.git',
    dst   => $vim::dot_vim,
    owner => $user
  }

  exec{'.vim submodules':
    command  => 'git submodule update --init' ,
    returns  => [2,0],
    cwd      => $vim::dot_vim,
    path     => ['/usr/bin/','/bin'],
    user     => $user,
    require  => Git::Clone[$vim::dot_vim],
    timeout  => 560,
    provider => shell
  }

  file { "${home}/.vimrc":
    ensure  => link,
    target  => "${vim::dot_vim}/.vimrc",
    require => Git::Clone[$vim::dot_vim]
  }

  class {'vim::commandt': dot_vim => $vim::dot_vim}
  class {'vim::snipmate': dot_vim => $vim::dot_vim}

  include vim::powerline
}
