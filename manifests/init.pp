# vim managment
class vim(
  String $home='',
  String $user='',
  $repo='git://github.com/narkisr/.vim.git'
){

  include ::git::params

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
  } ->

  class {'vim::bundle': } ->

  file { "${home}/.vimrc":
    ensure  => link,
    target  => "${vim::dot_vim}/.vimrc",
    require => Git::Clone[$vim::dot_vim]
  }

  if($::osfamily !='FreeBSD' and $repo=='git://github.com/narkisr/.vim.git') {
    class {'vim::snipmate':
      dot_vim => $vim::dot_vim,
      archive => $vim::bundle::release
    }
  }

  include vim::powerline

}
