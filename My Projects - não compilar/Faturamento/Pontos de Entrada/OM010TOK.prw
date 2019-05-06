User Function OM010TOK
Local lRet     := .T.
Local aPergs   := {}
Local aRet     := {"", Space(9)} 
Local oModel   := PARAMIXB[1] 
Local oGridTab := oModel:GetModel("DA0MASTER")

	//If Inclui
		//M->DA0_ATIVO := "2"
	//EndIf

	//If Altera
		//If  AllTrim(oGridTab:GetValue("DA0_ATIVO")) == "1" //esta tentando desbloquear a tabela
			lRet := .F.
		
			aAdd(aPergs, {9, "Para ativar a tabela, você deve informar a senha do superior.", 180, 30, .T.})
			aAdd(aPergs, {8, "Senha", Space(9), "@!",,, '.T.', 40, .T.})
		
			ParamBox(aPergs, "Ativar Tabela", @aRet, {|| lRet := ConfSenha(aRet[2])},,,,,,,.F.,.F.)
		//EndIf
	//EndIf
	
	If !lRet
		Help(" ",1,"Ativar Tabela", ,"A senha informada não está correta.", 3, 0)   
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