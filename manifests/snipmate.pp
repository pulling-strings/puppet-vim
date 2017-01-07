# deploy local snipmate snippets
class vim::snipmate($dot_vim, $archive) {

  exec{'deploy snipmate-snippets':
    command     => "rsync -av --delete . ${dot_vim}/bundle/snipmate/snippets/",
    cwd         => "${dot_vim}/bundle/snipmate-snippets",
    user        => $::vim::user,
    path        => ['/usr/local/rvm/bin/','/bin','/usr/bin',],
    require     => [Git::Clone[$dot_vim],Archive[$archive]],
    subscribe   => Archive::Extract[$archive],
    refreshonly => true
  }

}
