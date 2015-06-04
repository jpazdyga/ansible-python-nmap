class ansible {

  user { 'ansible':
    ensure     => 'present',
    home       => '/home/ansible',
    system     => true,
    uid        => 65100,
    gid        => 65100,
    require    => Group['ansible'],
    managehome => true,
  }

  group { 'ansible':
    ensure => 'present',
    system => 'true',
    name   => 'ansible',
    gid    => 65100,
  }

  file { '/home/ansible':
    ensure => 'directory',
    mode   => '0755',
    require => User['ansible'],
  }

  augeas { 'sudo4ansible':
    context => '/files/etc/sudoers',
    changes => [
      "set spec[user = 'ansible']/user ansible",
      "set spec[user = 'ansible']/host_group/host ALL",
      "set spec[user = 'ansible']/host_group/command YUM",
      "set spec[user = 'ansible']/host_group/command/runas_user ALL",
      "set spec[user = 'ansible']/host_group/command/tag NOPASSWD",
      "set Cmnd_Alias[alias/name = 'YUM']/alias/name YUM",
      "set Cmnd_Alias[alias/name = 'YUM']/alias/command[1] /usr/bin/yum",
  ],
  }

  augeas { 'ansiblenotty':
    context => '/files/etc/sudoers',
    changes => [
      "set Defaults[type=':ansible']/type :ansible",
      "clear Defaults[type=':ansible']/requiretty/negate",
    ]
  }

  ssh_authorized_key {
    'ansible-rsa-key':
      ensure => 'present',
      key    => '',
      type   => 'ssh-rsa',
      user   => 'ansible',
  }
}
