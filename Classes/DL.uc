class DL extends TcpLink
config(DLConfig2);

var DLBroadcastHandler DLB;
var config int SVPort;
var config bool iwontinitconfig;
var bool InitiatingStatus;
var int PortStatus;
var transient string MessageString,CacheMessageString;
function InitConfigVar(){
	iwontinitconfig=true;
	SVPort=2424;
}
function PreBeginPlay(){
	if(!iwontinitconfig) InitConfigVar();
	SaveConfig();
	LinkMode = MODE_Text;
    ReceiveMode = RMODE_Event;
	SetTimer(1,true,'InitiateConnection');
	
}



function InitiateConnection(){
	LogInternal("[Discord Link 2] Attempting to initiate Connection...");
	PortStatus=BindPort(SVPort);

	if(PortStatus!=0 ){
		Listen();
		ClearTimer('InitiateConnection');
		LogInternal("[Discord Link 2] Start Listening.....");
		
	}
	else{
		LogInternal("[Discord Link 2] Initiating failed! PortStatus = "/*$string(InitiatingStatus)*/$string(PortStatus));
	}
}

event ReceivedText( string Text )
{
	local KFPlayerController KFPC;
	super.ReceivedLine(Text);
	//WorldInfo.Game.Broadcast(self, Text);
	DLB.DLA.SendMSG(Text);
	/*foreach WorldInfo.AllControllers(class'KFPlayerController',KFPC)
	{
		KFPC.ClientMessage(Text);
	}*/
	LogInternal("[Discord Link 2]"$Text);
}
function CheckNSendMessages(){
	if(MessageString!="" ){
		if(SendText(UnicodeConverter(MessageString))<=0){
			LogInternal("[Discord Link 2] Sending failed! Try again..");
		
		}
		else{
			MessageString="";
		}
	}
}
function string UnicodeConverter(coerce string str){
	local int I;
	local string S;
	//LogInternal(Str);
	for(I=0;I<len(str);I++){
		if(I!=len(str)-1){
			//S=S$Asc(Mid(str,I,len(str)-(I+2)))$"/";
			S=S$Asc(Mid(str,I,1))$"/";
		}
		else{
			S=S$Asc(Mid(str,I,1));
		}
	}
	//S=S$"/32/32";
	return S;
}
event Accepted(){
	LogInternal("[Discord Link 2] Connection Accepted.");
	SetTimer(0.3,true,'CheckNSendMessages');
}
/*event Opened(){
	LogInternal("[Discord Link 2] Successfully connected!");
	
}*/
event Destroyed(){
	Close();
	super.Destroyed();
	
}

event Closed(){
	LogInternal("[Discord Link 2] Either succeeded or failed.");
}
