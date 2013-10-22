# setting up ctag
class vim::ctags {

  package{'ctags':
    ensure => installed
  }

  shell::link_dot{'.ctags':}
}
