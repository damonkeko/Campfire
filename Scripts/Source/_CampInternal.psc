scriptname _CampInternal hidden

_CampfireInternalAPI function GetAPI() global
	;@TODO: Change to .esm check
	return (Game.GetFormFromFile(0x00024095, "Campfire.esp") as Quest) as _CampfireInternalAPI
endFunction

CampfireAPI function GetPublicAPI() global
	;@TODO: Change to .esm check
	return (Game.GetFormFromFile(0x00024095, "Campfire.esp") as Quest) as CampfireAPI
endFunction

Keyword function GetMagicDamageFireKeyword() global
	_CampfireInternalAPI Campfire = GetAPI()
	if Campfire == none
		RaiseCampAPIError()
		return None
	endif

	return Campfire.MagicDamageFire
endFunction

Keyword function GetMagicDamageFrostKeyword() global
	_CampfireInternalAPI Campfire = GetAPI()
	if Campfire == none
		RaiseCampAPIError()
		return None
	endif

	return Campfire.MagicDamageFrost
endFunction

function TryToEnableRef(ObjectReference akReference, bool bFadeIn = false) global
	;A more concise way to enable references without checking for None first (to avoid Papyrus log errors, etc)
	if akReference
		akReference.Enable(bFadeIn)
	endif
endFunction

function TryToDisableRef(ObjectReference akReference, bool bFadeOut = false) global
	;A more concise way to disable references without checking for None first (to avoid Papyrus log errors, etc)
	if akReference
		akReference.Disable(bFadeOut)
	endif
endFunction

function TryToDisableAndDeleteRef(ObjectReference akReference, bool bFadeOut = false) global
	;A more concise way to disable and delete references without checking for None first (to avoid Papyrus log errors, etc)
	if akReference
		akReference.Disable(bFadeOut)
		akReference.Delete()
	endif
endFunction

ObjectReference function PlaceAndWaitFor3DLoaded(ObjectReference akOrigin, Form FormToPlace, int Count = 1, bool ForcePersist = false, bool bDisableInteraction = false) global
	;A more concise way to place an object and wait until the object's 3D is loaded.
	;Prevents infinite loop if object never loads. 
	;Optionally set bDisableInteraction to True to make this object behave like a static (disable Havok physics) and disable activation.
	;@TODO: Profile this
	ObjectReference myObject = akOrigin.PlaceAtMe(FormToPlace, Count, ForcePersist, false)
	int iTryCount = 0
	while iTryCount < 200
		if !myObject.Is3DLoaded()
			iTryCount += 1
		else
			if bDisableInteraction
				myObject.SetMotionType(4)
				myObject.BlockActivation()
			endif
			return myObject
		endif
	endWhile
	return None
endFunction

function SetLastUsedCampfire(ObjectReference akCampfire) global
	CampfireAPI Campfire = GetPublicAPI()
	if Campfire == none
		RaiseCampAPIError()
		return
	endif

	Campfire.LastUsedCampfire = akCampfire
endFunction

function RaiseCampAPIError() global
	debug.trace("[Campfire] Fatal Internal Campfire API error occurred.")
endFunction