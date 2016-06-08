  # == Class: b2safe
  #
  # == Description ==
  #
  # This class provides the main installation sequence for iRods and B2SAFE. 
  #
  # === Parameters
  #
  # === Authors
  #
  # === Copyright
  #
  # Copyright 2015 EUDAT2020
  #

class b2safe(
)
{
    class {'::b2safe::packages':
    stage => 'pre',
    }

    class{'::b2safe::db':
    }

    class{'::b2safe::irods':
    stage =>'main'
    }
    
    class{'::b2safe::b2safe':
    stage => 'post'
    }
}
    




