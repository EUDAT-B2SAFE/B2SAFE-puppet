
# include hiera classes as array


node 'default'{
include puppet-b2safe
}



#run stages
stage { 'pre':
  before => Stage['main'],
}
stage { 'post': }
Stage['main'] -> Stage['post']



include(hiera_array("classes", []))

