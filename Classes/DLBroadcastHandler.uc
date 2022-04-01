class DLBroadcastHandler extends BroadcastHandler;

var DL Link;
var DLActor DLA;
function PreBeginPlay(){
	Super.PreBeginPlay();
	Link=Spawn(class'DL');
	Link.DLB=self;

}
function BroadcastText( PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name Type ) {
	if(SenderPRI!=none && Receiver !=none && Msg!="")
		Link.MessageString=GetPlayerSteamID(SenderPRI)$":"$SenderPRI.PlayerName $": "$Msg;
	super.BroadcastText(SenderPRI,Receiver,Msg,Type);

}

function string GetPlayerSteamID(PlayerReplicationInfo PRI)
{
	local string IDString;
	local int SteamID;
	IDString=class'OnlineSubsystem'.static.UniqueNetIdToString(PRI.UniqueId);
	return IDString;

}


