# vim managment
class vim(
  $home=false,
  $user=false,
  $repo='git://github.com/narkisr/.vim.git'
){
  validate_string($home)
  validate_string($user)

  case $::osfamily {
    'Debian': {
      $vim_pack = $vim::is_desktop? {
        'true'  =>'vim-gtk',
        'false' =>'vim-nox'
      }
    }
    'FreeBSD': {
      $vim_pack = 'vim-lite'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }


  package{$vim::vim_pack:
    ensure  => present
  }

  $dot_vim= "${home}/.vim"

  git::clone {$vim::dot_vim:
    url   => $repo,
    dst   => $vim::dot_vim,
    owner => $user
  }

  exec{'.vim submodules':
    command  => "${git::params::bin} submodule update --init" ,
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

  if($::osfamily !='FreeBSD' and $repo=='git://github.com/narkisr/.vim.git') {
    class {'vim::snipmate': dot_vim => $vim::dot_vim}
  }

  include vim::powerline
}
