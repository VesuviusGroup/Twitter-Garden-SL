//Orginal can be found here: https://github.com/VesuviusGroup/Twitter-Garden-SL
// Change these:
string url = "http://your.domain.com/folder/"; //make sure you end with a /
string file = "twitter-search.php";
string searchTerm = "npsl";
integer refresh = 60; //Refresh rate in seconds
float alpha = 1.0; //0.0 = invisible, 1 = fully visible
vector textColor = <1,1,1>; //white
//////////////////////////////////////////////

key requestID;
list Tweets = [];
list linesOnLink = [];
list links = [];
integer handle;
string primName = "TwitterPrim";
integer searchResults = 0;

default
{
    state_entry()
    {
        links = [];
        integer i;
        integer nPrims = llGetNumberOfPrims();            
        
        if(nPrims != 1){
            for(i = 1;i <= nPrims;i++){
                if(llGetLinkName(i) == primName){
                    links += i;
                }
            }
        }else{
            links = [0];
        }
        searchResults = llGetListLength(links);
        llMessageLinked(LINK_ALL_CHILDREN, TRUE,"", NULL_KEY);
        llSetTimerEvent(1);
    }

    touch_start(integer count)
    {
        integer i = 0;
        integer child;
        integer index;
        for(i;i < count;i++){
            child = llDetectedLinkNumber(i);
            index = llListFindList(linesOnLink, [child]);
            if(index != -1){
                llInstantMessage(llDetectedKey(i), "See the tweet from  " + llList2String(linesOnLink,index + 1) + " Link: " + llList2String(linesOnLink, index + 3));            
            }
        }
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        linesOnLink = [];
        integer i = 0;
        if (request_id == requestID)
        {
            // the php script is using ":*:" as a delimeter for a search result
            // ":^: is used for seperating out name, message and url"
            Tweets = llParseString2List(body,[":*:"],[]);
            while ( (i < llGetListLength(Tweets) ) && (i < llGetListLength(links) ) ) {
                linesOnLink += llList2Integer(links, i);
                linesOnLink += llParseString2List(llList2String( Tweets, i ),[":^:"],[]);
                string temp1 = llList2String(linesOnLink, (i*4) + 1 ) + ": " + llList2String(linesOnLink, (i*4) + 2 );

                list templist = llParseString2List( llUnescapeURL( temp1 ), [" "], [] );
                temp1 = llDumpList2String(templist, "\n");
                                
                llSetLinkPrimitiveParamsFast(llList2Integer(links, i),  [ PRIM_TEXT,  temp1,textColor, alpha ]);

                i++;
            }
            llSetTimerEvent(refresh);
        }
    }

    timer() 
    {
        requestID = llHTTPRequest(url + file + "?query=" + searchTerm + "&rpp=" + (string)searchResults,[HTTP_METHOD,"GET"],"");
    }    
}