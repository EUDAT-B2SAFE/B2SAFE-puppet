# == Class puppet-b2safe ==
# 
# == Description ==
# 
# 

class puppet-b2safe(
)
{
    
    class {'puppet-b2safe::packages':
    stage => 'pre',
    }

    class{'db':
    }

    class{'puppet-b2safe::irods':
    stage =>'main'    
    }
    
    class{'puppet-b2safe::b2safe':
    stage => 'post'
    }
    
 
}
    




