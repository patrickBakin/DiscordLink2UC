class DLRep extends replicationinfo;

var repnotify string DiscordMSG;
var DLInteraction DLI;
var KFPlayerController TheKFPC;

replication
{
	if(bNetDirty)
		DiscordMSG;
}

simulated function PreBeginPlay()
{	
	super.PreBeginPlay();
	if(Role==Role_Authority)
	{
		LogInternal("DLRep Spawned!");
	}
}

simulated function KFPlayerController GetLocalPC()
{
	if (TheKFPC == None)
		TheKFPC = KFPlayerController(GetALocalPlayerController());
		
	return TheKFPC;
}
simulated function CheckHUD()
{	GetLocalPC();
	// Make sure we have a HUD first
	if (TheKFPC.myHUD == None)
	{
		SetTimer(1.0, false, nameof(CheckHUD));
		return;
	}
		AddInteraction(class'DiscordLink2.DLInteraction');
		
}
simulated event PostBeginPlay()
{
		
		super.PostBeginPlay();
		
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			SetTimer(2.0, false, nameof(CheckHUD));
			


		}
				

	  
		
}
simulated function AddInteraction(class<DLInteraction> DLClass)
{
	

	DLI = new (TheKFPC) DLClass;
	DLI.OwningKFPC = TheKFPC;
	TheKFPC.Interactions.AddItem(DLI);
	
}
simulated event ReplicatedEvent(name VarName)
{
	super.ReplicatedEvent(VarName);
	if(VarName == 'DiscordMSG')
	{
		ShowMessage(DiscordMSG);
	}
}

reliable client simulated function ShowMessage(string Msg)
{
	if(DLI!=none)
	{
		DLI.AddPendingMsg(Msg);
	}
}
simulated function Destroyed()
{
    // End:0x70
    if(DLI != none)
    {
        TheKFPC.Interactions.RemoveItem(DLI);
        DLI.OwningKFPC = none;
        DLI = none;
        TheKFPC = none;
    }
    //return;    
}
defaultproperties
{
	bAlwaysRelevant=false
    bOnlyRelevantToOwner=true
}