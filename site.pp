package {'git':
    ensure => 'present'
}

file {'/root/test_file.txt':
    ensure => 'present',
    mode => '0644',
    content => 'Test file created using manifest\n'
}

group {'devops':
    ensure => 'present',
    gid => 456
}

user {'testuser1':
    ensure => 'present',
    gid => 'devops',
    home => '/home/testuser1',
    managehome => true
}