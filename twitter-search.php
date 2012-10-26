<?php
//Orginal can be found here: https://github.com/VesuviusGroup/Twitter-Garden-SL


$query = $_REQUEST['query'];
$rpp = $_REQUEST['rpp'];

$c = curl_init();

curl_setopt($c, CURLOPT_URL, "http://search.twitter.com/search.json?rpp=" . $rpp . "&q=" . $query);
curl_setopt($c, CURLOPT_RETURNTRANSFER, TRUE);

curl_setopt($c, CURLOPT_USERAGENT, "Second Life object ");

//curl_setopt($c, CURLOPT_HTTPHEADER, $headers);


$response = @curl_exec($c);

if (chop($response)) {
        // We got a non-blank response, so try to parse it as JSON
        $json = json_decode($response, TRUE);
        curl_close($c);
       //echo $json;
        // Return the parsed data
       
        for ( $i=0; $i<$rpp; $i++ ){
        	
            $from_user = ereg_replace("%", "%25",$json[results][$i][from_user] );
            $text = html_entity_decode(ereg_replace("%", "%25",$json[results][$i][text])) ;
            print $from_user . ":^:";
            print $text. ":^:";
            print "http://twitter.com/" . $json[results][$i][from_user] . "/statuses/" . $json[results][$i][id] . ":*:";
        }
    }
?>