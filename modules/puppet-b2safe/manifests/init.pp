# == Class puppet-b2safe ==
# 
# == Description ==
# 
# 

class puppet-b2safe(
$mymessage="bad",
$operating_system='sl6.6'
)
{
    
    class {'puppet-b2safe::packages':
    os    =>$operating_system,
    stage => 'pre',
    }->

    class{'db':
    os    =>$operating_system,
    stage =>'pre'
    }


    notify{"this is a class puppet-b2safe ${mymessage} ":}
    
}



