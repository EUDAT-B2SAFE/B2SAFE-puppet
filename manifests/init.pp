# == Class b2safe ==
# 
# == Description ==
# 
# 

class b2safe(
)
{

  class { '::b2safe::packages':
  } ->
  class{ '::b2safe::db':
  } ->
  class{ '::b2safe::irods':
  } ->
  class{ '::b2safe::b2safe':
  }

}