scriptname _Camp_ArrayHelper hidden
{Global array helper functions.}

bool function ArrayAddForm(Activator[] myArray, Activator myActivator) global
;Adds a form to the first available element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < myArray.Length
		if IsNone(myArray[i])
			myArray[i] = myActivator
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArraySort(Activator[] myArray, int i = 0) global
;Removes blank elements by shifting all elements down.
	 ;		   false		=			   No sorting required
	 ;		   true			=			   Success
 
	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < myArray.Length
		  if IsNone(myArray[i])
		  	   myArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(myArray[i]))
						 myArray[iFirstNonePos] = myArray[i]
						 myArray[i] = none
 
						 ;Call this function recursively until it returns
						 ArraySort(myArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

int function ArrayCount(Activator[] myArray) global
;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"
 
	int i = 0
	int myCount = 0
	while i < myArray.Length
		if !(IsNone(myArray[i]))
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

; Array elements that contain forms from unloaded mods
; will fail '== None' checks because they are
; 'Activator<None>' objects. Check FormID as well.
bool function IsNone(Form akForm) global
	int i = 0
	if akForm
		i = akForm.GetFormID()
		if i == 0
			return true
		else
			return false
		endif
	else
		return true
	endif
endFunction