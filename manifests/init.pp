# Class: vim
#
# This module manages vim
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class vim {
  $vim_pack = $vim::is_desktop? {
    'true'  =>'vim-gtk',
    'false' =>'vim-nox'
  }

  package{$vim::vim_pack:
    ensure  => present
  }

  include vim::ctags

  $home = "/home/${username}"
  $dot_vim= "${home}/.vim"

  git::clone {$vim::dot_vim:
    url   => 'git://github.com/narkisr/.vim.git',
    dst   => $vim::dot_vim,
    owner => $username
  }

  exec{'.vim submodules':
    command  => 'git submodule update --init' ,
    returns  => [2,0],
    cwd      => $vim::dot_vim,
    path     => ['/usr/bin/','/bin'],
    user     => $username,
    require  => Git::Clone[$vim::dot_vim],
    provider => shell
  }

  file { "${home}/.vimrc":
    ensure  => link,
    target  => "${vim::dot_vim}/.vimrc",
    require => Git::Clone[$vim::dot_vim]
  }

  class {'vim::commandt': dot_vim => $vim::dot_vim}
  class {'vim::snipmate': dot_vim => $vim::dot_vim}

}
