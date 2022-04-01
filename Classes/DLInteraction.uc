class DLInteraction extends Interaction;

var KFPlayerController OwningKFPC;
var float DisplayTime;
var transient float CurrentTime;
var transient array<string> PendingMsgs;
var transient bool DrawingCurrent;
event PostRender(Canvas C)
{
	if(PendingMsgs.Length>0)
	{
		RenderPendingMsg(C);
	}
}


function AddPendingMsg(string Msg)
{
	PendingMsgs.AddItem(Msg);

}

function RenderPendingMsg(Canvas C)
{	
	local int I;
    local float X,Y;
	
	if(!DrawingCurrent)
	{
		CurrentTime=OwningKFPC.WorldInfo.RealTimeSeconds;
		DrawingCurrent=True;
	}
	if(OwningKFPC.WorldInfo.RealTimeSeconds-CurrentTime >DisplayTime)
	{
		DrawingCurrent=False;
		PendingMsgs.RemoveItem(PendingMsgs[0]);
	}
	C.Font =Font(DynamicLoadObject("UI_Canvas_Fonts.Font_Main", class'Font'));// GUIStyle.PickFont(GUIStyle.DefaultFontSize, Sc);
 
    X = C.ClipX * 0.875;
    Y = C.ClipY * 0.5;
    
               
                C.SetPos(X, Y);
                C.SetDrawColorStruct(MakeColor(115,138,219,255));
                C.DrawText("<Discord Link> "$PendingMsgs[0],,  0.78,0.78);

}

defaultproperties
{
	DisplayTime=4.0
}