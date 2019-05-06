User function M460FIM()
Local cMsg := ""

	If SF4->F4_DUPLIC == "S" .And. !Empty(SF2->F2_DUPL)
		cMsg += "Deseja agendar o envio por e-mail dos boletos gerados na emiss�o do documento de sa�da " 
		cMsg += "N�mero " + AllTrim(SF2->F2_DOC) + " S�rie " + AllTrim(SF2->F2_SERIE) + " Cliente " + SF2->F2_CLIENTE + "-" + SF2->F2_LOJA + Chr(13) + Chr(10)
		cMsg += AllTrim(SA1->A1_NOME) + "?" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
		cMsg += "Obs.: Os boletos ser�o enviados ap�s o documento sa�da receber a chave de autoriza��o SEFAZ."
		
		If Aviso("Schedule Boletos", cMsg, {"Sim", "N�o"}, 3) == 1
			RecLock("SF2", .F.)
				SF2->F2_YSCHBOL := "S"
				SF2->F2_YBOLENV := "N"
			MsUnlock()
		End If
	End If
Return