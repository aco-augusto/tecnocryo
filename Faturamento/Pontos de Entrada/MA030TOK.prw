User Function MA030TOK
Local lRet   := .T.
Local aPergs := {}
Local aRet   := {"", Space(9)}

	If Altera
		If SA1->A1_MSBLQL == "1" .And. M->A1_MSBLQL != '1' //esta tentando desbloquear o cliente
			lRet := .F.
		
			aAdd(aPergs, {9, "Para desbloquear o cliente, você deve informar a senha do superior.", 180, 30, .T.})
			aAdd(aPergs, {8, "Senha", Space(9), "@!",,, '.T.', 40, .T.})
		
			ParamBox(aPergs, "Desbloquear Cliente", @aRet, {|| lRet := ConfSenha(aRet[2])},,,,,,,.F.,.F.)
		EndIf
	EndIf
Return(lRet)
/*
*/
Static Function ConfSenha(cSenha)
Local cPass := Chr(116) + Chr(101) + Chr(99) + Chr(118) + Chr(97) + Chr(108) + Chr(101) + Chr(100) + Chr(119) //
Local lRet  := Upper(cPass) == cSenha

	If !lRet
		Aviso("Desbloquear Cliente", "A senha informada não está correta. Tente novamente.", {"Ok"}, 1)	
	EndIf
Return(lRet)