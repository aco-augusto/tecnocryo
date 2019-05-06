User Function NNSantan()
Local nTam    := Len(AllTrim(SEE->EE_FAXATU))
Local cNumero := StrZero(Val(SEE->EE_FAXATU),nTam)
Local cMod11  := ""

	While !MayIUseCode(SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))  //verifica se esta na memoria, sendo usado
		cNumero := Soma1(cNumero)										// busca o proximo numero disponivel 
	EndDo

	cMod11 := Modulo11(cNumero,2,9)

	If Empty(SE1->E1_NUMBCO)
		RecLock("SE1",.F.)
			SE1->E1_NUMBCO := cNumero + cMod11
		SE1->(MsUnlock())
		
		RecLock("SEE",.F.)
			SEE->EE_FAXATU := Soma1(cNumero, nTam)
		SEE->(MsUnlock())
	EndIf	

	Leave1Code(SEE->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA))
	DbSelectArea("SE1")
Return(SE1->E1_NUMBCO)