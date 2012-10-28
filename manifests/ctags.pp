class vim::ctags {
  
  package{"ctags": ensure	=> installed }

  dots::link_dot{'.ctags':}
}
