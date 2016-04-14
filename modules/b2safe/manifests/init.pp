# == Class b2safe ==
# 
# == Description ==
# 
# 

class b2safe(
)
{
    class {'b2safe::packages':
    stage => 'pre',
    }

    class{'db':
    }

    class{'b2safe::irods':
    stage =>'main'
    }
    
    class{'b2safe::b2safe':
    stage => 'post'
    }
}
    




