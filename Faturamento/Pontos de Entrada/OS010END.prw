User Function OS010END
Local nTipo  := ParamIXB[1] //1 - TABELA - 2  - PRODUTO
Local nOpcao := ParamIXB[2] //3 - inclusao - 4  - alteracao - 5 - exclusao

	If nTipo == 1 //se for tabela
		RecLock("DA0", .F.)
			DA0->DA0_ATIVO := "2"		
		DA0->(MsUnlock())
	EndIf
Return