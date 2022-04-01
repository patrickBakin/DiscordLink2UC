class DLActor extends Actor;

var DLRep DLR;
function PreBeginPlay(){
	super.PreBeginPlay();
	if(Role==Role_Authority)
		SetTimer(1,true,'SetUpBroadcast');
		SetTimer(2,false,'Delay');
	
}
simulated function PostBeginPlay(){
	super.PostBeginPlay();
	DLR=Spawn(class'DLRep');
}
function SetUpBroadcast(){
	local KFGameInfo KFGI;
	KFGI=KFGameInfo(WorldInfo.Game);
	if(DLBroadcastHandler(KFGI.BroadcastHandler)==None){
		KFGI.BroadcastHandler=spawn(class'DLBroadcastHandler');
		DLBroadcastHandler(KFGI.BroadcastHandler).DLA=self;
		return;
	}
	
	ClearTimer('SetUpBroadcast');
}

function SendMSG(string MSG)
{
	DLR.DiscordMSG=MSG;
}