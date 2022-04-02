class DLActor extends KFMutator;

var DLRep DLR;
struct LogonUser
{
	var PlayerController User;
	var DLRep DLRep;
	structdefaultproperties
	{
		User=None
		DLRep=None 
	}
};
var transient array<LogonUser> Users;

function PreBeginPlay(){
	super.PreBeginPlay();
	if(Role==Role_Authority)
		SetTimer(1,true,'SetUpBroadcast');
		//SetTimer(2,false,'Delay');
	
}
function NotifyLogin(Controller NewPlayer)
{	
    
    if( PlayerController(NewPlayer)!=None )
        LoginPlayer(PlayerController(NewPlayer));
    if ( NextMutator != None )
        NextMutator.NotifyLogin(NewPlayer);
}
function LoginPlayer(PlayerController PC){

	local int I;
	if((PC != none) && PC.Player != none)
    {	
    	I = Users.Length;
    	Users.Length=I+1;
    	Users[I].User=PC;
		Users[I].DLRep=Spawn(class'DLRep',PC);
	}


}
function NotifyLogout(Controller Exiting)
{
    local int I;

    
    if(PlayerController(Exiting) != none)
    {
        I = Users.Find('User', PlayerController(Exiting));

        if(I >= 0)
        {
            Users[I].DLRep.Destroy();
            Users.Remove(I, 1);
        }
    }
    super(Mutator).NotifyLogout(Exiting);
      
}
function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    CleanupUsers();
    super(Mutator).GetSeamlessTravelActorList(bToEntry, ActorList);
     
}
final function CleanupUsers()
{
    local int I;

    for(I=0;I < Users.Length;I++)
    {
        // End:0x84
        if(Users[I].DLRep != none)
        {
            Users[I].DLRep.Destroy();
        }
      
    }
    Users.Length = 0;
    //return;    
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
	local int I;
	for(I=0;I<Users.Length;I++)
	{
		Users[I].DLRep.DiscordMSG=MSG;
	}
	
}