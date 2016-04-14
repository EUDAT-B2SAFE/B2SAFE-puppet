
# include hiera classes as array


node 'default'{
include b2safe
}



#run stages
stage { 'pre':
  before => Stage['main'],
}
stage { 'post': }
Stage['main'] -> Stage['post']



include(hiera_array("classes", []))

