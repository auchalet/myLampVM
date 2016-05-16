<?php phpinfo(); 

if( mail('himself@vince-db.com', 'Test email', 'Test mail sent each time you reload the index page.') )
{  echo "Mail Sent!"; }

?>
