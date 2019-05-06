User function M460FIM()
Local cMsg := ""

	If SF4->F4_DUPLIC == "S" .And. !Empty(SF2->F2_DUPL)
		cMsg += "Deseja agendar o envio por e-mail dos boletos gerados na emissão do documento de saída " 
		cMsg += "Número " + AllTrim(SF2->F2_DOC) + " Série " + AllTrim(SF2->F2_SERIE) + " Cliente " + SF2->F2_CLIENTE + "-" + SF2->F2_LOJA + Chr(13) + Chr(10)
		cMsg += AllTrim(SA1->A1_NOME) + "?" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
		cMsg += "Obs.: Os boletos serão enviados após o documento saída receber a chave de autorização SEFAZ."
		
		If Aviso("Schedule Boletos", cMsg, {"Sim", "Não"}, 3) == 1
			RecLock("SF2", .F.)
				SF2->F2_YSCHBOL := "S"
				SF2->F2_YBOLENV := "N"
			MsUnlock()
		End If
	End If
Return