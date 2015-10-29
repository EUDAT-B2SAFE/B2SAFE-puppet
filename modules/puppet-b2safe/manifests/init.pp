# == Class puppet-b2safe ==
# 
# == Description ==
# 
# 

class puppet-b2safe(
$mymessage="bad",
$operating_system='sl6.6',
$postgres_version='postgres93',
)
{
    
    class {'puppet-b2safe::packages':
    os    =>$operating_system,
    stage => 'pre',
    }->

    class{'db':
    os        => $operating_system,
    postgres  => $postgres_version,
    }

    class{'puppet-b2safe::irods':
    stage =>'main'    
    }

    notify{"this is a class puppet-b2safe ${mymessage} ":}
    
}



